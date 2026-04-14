CREATE DEFINER=`root`@`%` PROCEDURE `SP_CreateAndExecuteSyncSPFromMapForRawInforTables`(table_name varchar(100))
BEGIN

/*
DATE DERNIERE MODIF:    
2026-04_07 Pierre-Yves Calpetard (Emyode) User Story 597: Add PKs from information_schema.KEY_COLUMN_USAGE
2026-03-27 Pierre-Yves Calpetard (Emyode) User Story 597: Removed Index creation
2026-01-28 Vadim Simanovsky(Emyode) User Story 521: Add comments to curated's SP 
2025-11-04 Ezzeddine Chakroun [MERP-99] Commencer création.

DESCRIPTION
Génère le code pour la SP de sync de données infor_raw à curated pour une table spécifique.
Théoriquement one shot use
Hypothese :

ACtuellement il y a quelques limiations:
-'curated' est la seul valeur supportée pour la colonne de curated_schema dans curated.tbl_map_raw_to_curated
-Chaque colonne utilise dans la colonne expression doit être obligatoirement presente dans la colonne source_column separe par virgule ',' en cas de plusieurs. Actuellement la colonne expression supporte 4 colonnes(source et/ou destinations ) en totale utilises au maximum.

IMPORTANT
Il doit y avoir une primary key d'identifiée dans tbl_map_raw_to_curated.

PARAMÈTRES
table_name: le nom de la table curated dans tbl_map_raw_to_curated.
_output_sp: le code de la SP à créer, sans les instructions DELIMITER.


Hypotheses actuelles:
-Schemas de source doit etre infor_raw
-Query_str : condition de jointure entre la table source principale et la table auxilaire
-La table destination contient des colonnes qui n'ont pas query_str qui vont etre  alimentes tout d'abord de la table source principale
-query_cond: contienne des conditions de filtres 
-Curated schema supporte actuellement le schema de curated seulement
-expression: contient les colonnes de la table de base 
*/

DECLARE vs_result_str LONGTEXT DEFAULT '';
DECLARE vs_list_columns_source longtext;
DECLARE vs_list_columns_destination longtext;
DECLARE vs_list_primary_keys text;
DECLARE vs_sync_tablename varchar(100) ;
DECLARE vs_source_table_schema varchar(100);
DECLARE vs_source_table_name varchar(100);
DECLARE vs_outputDelete longtext;
DECLARE vs_outputInsert longtext;
DECLARE vs_outputUpdate longtext;
DECLARE vs_checkinforcompanyquery longtext;
DECLARE SyncInfoProcessName VARCHAR ( 100 ) DEFAULT CONCAT('SP_CreateAndExecuteSyncSPFromMapForRawInforTables - ',table_name);
DECLARE errno SMALLINT UNSIGNED DEFAULT 10000;
DECLARE tmStart TIME;
DECLARE tmPrev TIME;
DECLARE tmNow TIME;
DECLARE sTimeResult TEXT DEFAULT '';
DECLARE _output_sp TEXT DEFAULT '';

-- Delcare cursors
-- Declare cursors for the curated
DECLARE var_curated_table VARCHAR(255) DEFAULT '';
DECLARE var_curated_column VARCHAR(255) DEFAULT '';
DECLARE var_curated_schema VARCHAR(255) DEFAULT '';
DECLARE var_curated_type VARCHAR(255) DEFAULT '';
DECLARE var_curated_table_name VARCHAR(255) DEFAULT '';
DECLARE var_query_str LONGTEXT DEFAULT '';
DECLARE var_query_cond VARCHAR(255) DEFAULT NULL;
DECLARE var_source_column VARCHAR(255) DEFAULT '';
DECLARE var_expression longtext DEFAULT '';
DECLARE var_source_table longtext DEFAULT '';
DECLARE var_join_query_str longtext DEFAULT '';


DECLARE vs_latest_version_column LONGTEXT DEFAULT ''; 
DECLARE vs_delete_column LONGTEXT DEFAULT '';
DECLARE vs_cono_exist varchar(4) DEFAULT '';


-- Defining variables for aux table 
DECLARE vs_skip_filter TINYINT DEFAULT 0; -- if the schema is curated the aux is not needed
DECLARE vs_list_columns_source_aux longtext;
DECLARE vs_list_columns_destination_aux longtext;
DECLARE vs_list_columns_join_aux longtext;


DECLARE done INT DEFAULT FALSE;
DECLARE cursor_all_curated_tables CURSOR FOR SELECT DISTINCT CONCAT(curated_schema,'.',curated_table) FROM curated.tbl_map_raw_to_curated;
DECLARE cursor_query_str_columns CURSOR FOR SELECT curated_schema,curated_table,query_str,query_cond,curated_column,source_column,expression,source_table FROM curated.tbl_map_raw_to_curated WHERE IFNULL(query_str,'')!='';	 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

-- -------------------------------------------------------
--    Init
-- -------------------------------------------------------

SET tmStart = NOW(),
  tmPrev = NOW(); -- Create_Infor_Tables

-- Make sure we are in the "curated" database
IF ( DATABASE () <> 'curated' ) THEN

  SET @errmsg = CONCAT('ERROR: wrong database');
  
  SIGNAL SQLSTATE '45000' 
  SET MYSQL_ERRNO = errno,
    MESSAGE_TEXT = @errmsg;

END IF;

-- Make sure is not a custom SP
IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_SCHEMA = 'curated'
      AND ROUTINE_TYPE = 'PROCEDURE'
      AND ROUTINE_NAME = CONCAT('SP_Sync_' ,table_name, '_custom')
) THEN
    SET @errmsg = CONCAT('ERROR: there is a custom SP');
  
    SIGNAL SQLSTATE '45000' 
    SET MYSQL_ERRNO = errno,
      MESSAGE_TEXT = @errmsg;
END IF;
-- -------------------------------------------------------
--    curated.tbl_syncinfo
-- -------------------------------------------------------

-- Créer la table 
IF NOT EXISTS(
    SELECT T.TABLE_NAME FROM information_schema.`TABLES` AS T 
    WHERE T.TABLE_SCHEMA = 'curated' AND T.TABLE_NAME = 'tbl_syncinfo' LIMIT 1 
) THEN

  CREATE TABLE curated.tbl_syncinfo LIKE goliveinfor.tbl_syncinfo;	

END IF;

-- Créer l'enregistrement si manquant.
IF NOT EXISTS(
  SELECT ProcessName FROM curated.tbl_syncinfo 
  WHERE ProcessName = SyncInfoProcessName
) THEN

  INSERT INTO curated.tbl_syncinfo ( ProcessName, SyncStart, SyncEnd, LastFinished, NextStep, IsSynchronisingRegularTable )
  VALUES
    ( SyncInfoProcessName, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '', 0 );

END IF;

-- IMPORTANT: Valider que la SP n'est pas déjà en cours d'exécution (ou n'a pas terminée correctement lors de la dernière exécution).
--   Si 1) vous avez cette erreur, 2) curated.tbl_syncinfo.IsSynchronisingRegularTable est encore à 1 et 3) que "Server Monitor" montre que la sync n'est pas en cours,
--   alors aller mettre manuellement IsSynchronisingRegularTable = 0.

IF ( SELECT IsSynchronisingRegularTable FROM curated.tbl_syncinfo WHERE ProcessName = SyncInfoProcessName ) = 1 THEN
  
  SET @errmsg = CONCAT('ERROR: ',SyncInfoProcessName,': is already synchronising');

  SIGNAL SQLSTATE '45000' SET
  MYSQL_ERRNO = errno,
  MESSAGE_TEXT = @errmsg;

END IF;

-- Update SyncInfo
UPDATE curated.tbl_syncinfo -- SP_InitDatabaseFromProdbbx - début
SET NextStep = 'Init',
  SyncStart = NOW(),
  IsSynchronisingRegularTable = 1,
  SyncEnd = '0000-00-00 00:00:00' 
WHERE ProcessName = SyncInfoProcessName;

SET vs_sync_tablename =CONCAT(table_name,"_sync");

SELECT source_schema FROM curated.tbl_map_raw_to_curated WHERE curated_schema='curated' AND curated_table=table_name AND TRIM(IFNULL(query_str,'')) = '' ORDER BY curated_column_position LIMIT 1 INTO vs_source_table_schema;

SELECT source_table FROM curated.tbl_map_raw_to_curated WHERE curated_schema='curated' AND curated_table=table_name AND TRIM(IFNULL(query_str,'')) = '' ORDER BY curated_column_position LIMIT 1 INTO vs_source_table_name;

SELECT REPLACE(query_cond,source_table,'tbloriginal') FROM curated.tbl_map_raw_to_curated WHERE curated_schema='curated' AND curated_table=table_name AND IFNULL(query_cond,'') <>'' AND query_cond IS NOT NULL LIMIT 1 INTO var_query_cond;

SELECT 
	GROUP_CONCAT(
		REPLACE(IF(TRIM(IFNULL(expression,'')) = ''
		,CONCAT(source_table,'.',source_column)
		,	CONCAT(expression, ' AS ', curated_column)
		),source_table,'tbloriginal')
		ORDER BY curated_column_position 
		SEPARATOR ', 
	'
	) AS list_columns_source
FROM curated.tbl_map_raw_to_curated 
WHERE curated_schema='curated' 
	AND curated_table=table_name
  AND TRIM(IFNULL(query_str,'')) = ''
INTO vs_list_columns_source;

SELECT GROUP_CONCAT(CONCAT('`', curated_column, '`') ORDER BY curated_column_position SEPARATOR ', ') 
FROM curated.tbl_map_raw_to_curated 
WHERE curated_schema='curated' 
	AND curated_table=table_name
  AND TRIM(IFNULL(query_str,'')) = ''
INTO vs_list_columns_destination;

SELECT GROUP_CONCAT( COLUMN_NAME ORDER BY ORDINAL_POSITION SEPARATOR ', ')
FROM information_schema.`COLUMNS` AS T 
WHERE T.TABLE_SCHEMA = vs_source_table_schema 
	AND T.TABLE_NAME = vs_source_table_name
	AND COLUMN_KEY='PRI'
  AND COLUMN_NAME <> 'variationNumber'
INTO vs_list_primary_keys;

-- Filling variables for aux table
-- pour les tables source et destination d'aux puisqu'il utilisent la colonne source pour chaque expression, il faut eliminier les doublons des colonnes dans les listes. Actuellement 4 colonnes par expression sont supportes A ajuster en fonction de besoin
-- checking source schema and filling latest version and deleted columns

IF vs_source_table_schema ='infor_raw' THEN 

SET vs_latest_version_column='variationnumber';
SET vs_delete_column='deleted';

ELSE 
  SET @errmsg = CONCAT('ERROR: The schema of the source table ',vs_source_table_schema,': is not infor_raw. Please use another SP to Create and Execute the Sync ');
        SIGNAL SQLSTATE '45000' SET
        MYSQL_ERRNO = errno,
        MESSAGE_TEXT = @errmsg;
END IF;

SELECT GROUP_CONCAT(CONCAT('tbltmp.`', COLUMN_NAME, '`=tbloriginal.`', COLUMN_NAME, '`') SEPARATOR ' AND ')
  FROM information_schema.`COLUMNS` AS T 
  WHERE T.TABLE_SCHEMA = vs_source_table_schema 
    AND T.TABLE_NAME = vs_source_table_name
    AND COLUMN_KEY='PRI'
    AND COLUMN_NAME <> 'variationNumber'
  INTO vs_list_columns_join_aux;


-- checking if cono exists as a column in source table 

SELECT COLUMN_NAME
FROM information_schema.`COLUMNS` AS T 
WHERE T.TABLE_SCHEMA = vs_source_table_schema 
	AND T.TABLE_NAME = vs_source_table_name
  AND COLUMN_NAME = 'cono'
INTO vs_cono_exist;

SELECT CASE 
          WHEN vs_cono_exist='' THEN NULL 
          ELSE vs_cono_exist
       END AS test
 INTO vs_cono_exist;
 
SET tmNow = NOW(),
  sTimeResult = CONCAT(
    'Init: ',
  TIMEDIFF( tmNow, tmPrev )),
  tmPrev = tmNow;     

UPDATE curated.tbl_syncinfo 
SET NextStep = CONCAT('SP_Sync_',table_name) 
WHERE ProcessName = SyncInfoProcessName;    


SET vs_result_str=CONCAT(
"CREATE PROCEDURE `SP_Sync_",table_name,"`()
BEGIN 

/*
DATE DERNIERE MODIF: ",DATE_FORMAT(NOW(), '%Y-%m-%d')," Créée par ",SyncInfoProcessName,"

DESCRIPTION
Mise à jour de la table ", table_name, ".
*/

DECLARE vs_cono NUMERIC(3);
DECLARE vs_minutes NUMERIC DEFAULT 3;
DECLARE SyncInfoProcessName VARCHAR(255) DEFAULT '",CONCAT('SP_Sync_',table_name),"';
DECLARE tmStart TIME;
DECLARE tmPrev TIME;
DECLARE tmNow TIME;
DECLARE sTimeResult TEXT DEFAULT '';
DECLARE errno SMALLINT UNSIGNED DEFAULT 10000;
DECLARE var_derniere_timestamp_base VARCHAR(40);

-- -------------------------------------------------------
--    Init
-- -------------------------------------------------------
SET tmStart = NOW(),
  tmPrev = NOW(); -- Init

-- Make sure we are in the 'curated' database
IF ( DATABASE () <> 'curated' ) THEN

  SET @errmsg = CONCAT('ERROR: wrong database');
  SIGNAL SQLSTATE '45000' SET
  MYSQL_ERRNO = errno,
  MESSAGE_TEXT = @errmsg;
	
END IF;

-- -------------------------------------------------------
--    curated.tbl_syncinfo
-- -------------------------------------------------------
-- Créer la table 
IF NOT EXISTS(
    SELECT T.TABLE_NAME FROM information_schema.`TABLES` AS T 
    WHERE T.TABLE_SCHEMA = 'curated' AND T.TABLE_NAME = 'tbl_syncinfo' LIMIT 1 
) THEN

  CREATE TABLE curated.tbl_syncinfo LIKE goliveinfor.tbl_syncinfo;
	
END IF;

-- Créer l'enregistrement si manquant.
IF NOT EXISTS(
  SELECT ProcessName FROM curated.tbl_syncinfo 
  WHERE ProcessName = SyncInfoProcessName
) THEN

  INSERT INTO curated.tbl_syncinfo ( ProcessName, SyncStart, SyncEnd, LastFinished, NextStep, IsSynchronisingRegularTable )
  VALUES
    ( SyncInfoProcessName, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '', 0 );
		
END IF;

-- IMPORTANT: Valider que la SP n'est pas déjà en cours d'exécution (ou n'a pas terminée correctement lors de la dernière exécution).
--   Si 1) vous avez cette erreur, 2) curated.tbl_syncinfo.IsSynchronisingRegularTable est encore à 1 et 3) que 'Server Monitor' montre que la sync n'est pas en cours,
--   alors aller mettre manuellement IsSynchronisingRegularTable = 0.
IF ( SELECT IsSynchronisingRegularTable FROM curated.tbl_syncinfo WHERE ProcessName = SyncInfoProcessName ) = 1 THEN
  
  SET @errmsg = CONCAT('ERROR: ',SyncInfoProcessName,': is already synchronising');
  SIGNAL SQLSTATE '45000' SET
  MYSQL_ERRNO = errno,
  MESSAGE_TEXT = @errmsg;
	
END IF;

-- Update SyncInfo
UPDATE curated.tbl_syncinfo
SET NextStep = 'Init',
	SyncStart = NOW(),
	IsSynchronisingRegularTable = 1,
	SyncEnd = '0000-00-00 00:00:00' 
WHERE ProcessName = SyncInfoProcessName;

-- ----------------------------------------------------------------------------
-- ---   Traitement
-- ----------------------------------------------------------------------
SET tmNow = NOW(),
  sTimeResult = CONCAT('Init: ', TIMEDIFF( tmNow, tmPrev )),
  tmPrev = tmNow;     

UPDATE curated.tbl_syncinfo SET NextStep = 'creer les tables baselines sil nexiste pas ' WHERE ProcessName = SyncInfoProcessName;

-- Créer table baseline of the base table if it doesnt exists
CREATE TABLE IF NOT EXISTS ",vs_source_table_schema,".",vs_source_table_name,"_baseline LIKE ",vs_source_table_schema,".",vs_source_table_name,";

SET @pk_check := (
  SELECT COUNT(*)
  FROM information_schema.KEY_COLUMN_USAGE
  WHERE TABLE_SCHEMA = '", vs_source_table_schema,"'
    AND TABLE_NAME = '", vs_source_table_name,"_baseline'
    AND CONSTRAINT_NAME = 'PRIMARY'
    AND COLUMN_NAME = '", vs_latest_version_column,"'
);

IF @pk_check > 0 THEN
SET @pk_list := (SELECT GROUP_CONCAT(COLUMN_NAME) FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_NAME = '", table_name, "'  AND TABLE_SCHEMA = '", vs_source_table_schema, "' AND COLUMN_NAME <> '", vs_latest_version_column, "' AND CONSTRAINT_NAME = 'PRIMARY' ORDER BY ORDINAL_POSITION);
  SET @createPK := CONCAT(
  'ALTER TABLE ", vs_source_table_schema, ".", vs_source_table_name, "_baseline ',
  'DROP PRIMARY KEY, ADD PRIMARY KEY (', @pk_list, ')'
  );

  PREPARE stmt FROM @createPK;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END IF;

SELECT -- SP_Sync_", table_name, "
  DATE_SUB(IFNULL(
    MAX(timestamp),
    '2000-01-01 00:00:00'
  ),
  INTERVAL 3 MINUTE)
FROM ",vs_source_table_schema,".",vs_source_table_name,"_baseline INTO var_derniere_timestamp_base;

SELECT infor_company
INTO vs_cono
FROM management.tbl_param
WHERE `id` = 1;

SET tmNow = NOW(),
	sTimeResult = CONCAT(sTimeResult,' | creer les tables baselines : ', TIMEDIFF( tmNow, tmPrev )),
	tmPrev = tmNow;    

UPDATE curated.tbl_syncinfo SET NextStep = 'Traiter les baselines' WHERE ProcessName = SyncInfoProcessName;

CREATE OR REPLACE TEMPORARY TABLE `", vs_source_table_schema,"`.`tbltmp_max_vn_by_id_",vs_source_table_name,"` -- SP_Sync_", table_name, "
(
PRIMARY KEY (",vs_list_primary_keys,")
  )
ENGINE = MyISAM
SELECT ",vs_list_primary_keys,", MAX(",vs_latest_version_column,") AS LastVersionNumber
FROM `", vs_source_table_schema,"`.`",vs_source_table_name,"` 
WHERE  timestamp >= var_derniere_timestamp_base ",IFNULL(CONCAT(' AND ',vs_cono_exist,'=vs_cono'),''),"
GROUP BY ",vs_list_primary_keys,";

-- remplir la table de baseline avec les donnes de la table originale qui ont la date superieur au timestamp
REPLACE INTO ",vs_source_table_schema,".",vs_source_table_name,"_baseline  -- SP_Sync_", table_name, "
SELECT tbloriginal.*  
FROM `",vs_source_table_schema,"`.`tbltmp_max_vn_by_id_",vs_source_table_name,"` AS tbltmp
  INNER JOIN ",vs_source_table_schema,".",vs_source_table_name," AS tbloriginal ON ",vs_list_columns_join_aux,"  AND tbloriginal.",vs_latest_version_column," = tbltmp.LastVersionNumber ;

SET tmNow = NOW(),
    sTimeResult = CONCAT(sTimeResult,' | Traiter les baselines ', TIMEDIFF( tmNow, tmPrev )),
    tmPrev = tmNow; 


UPDATE curated.tbl_syncinfo SET NextStep = 'create sync table curated.",vs_sync_tablename,"' WHERE ProcessName = SyncInfoProcessName;
    
-- Créer table _sync
DROP TABLE IF EXISTS curated.",vs_sync_tablename,";

CREATE TABLE curated.",vs_sync_tablename," LIKE curated.",table_name,";

SET tmNow = NOW(),
	sTimeResult = CONCAT(sTimeResult,' | create sync table curated.",vs_sync_tablename,": ', TIMEDIFF( tmNow, tmPrev )),
	tmPrev = tmNow;     

    
-- -----------------------------------------------------
-- --- Insert Data
-- -----------------------------------------------------

UPDATE curated.tbl_syncinfo SET NextStep = 'inserer les colonnes qui nont pas query str' WHERE ProcessName = SyncInfoProcessName;


INSERT IGNORE INTO curated.`", vs_sync_tablename, "` -- SP_Sync_", table_name, "
  (
	", vs_list_columns_destination, "
)
SELECT 
	", vs_list_columns_source, "
FROM `", vs_source_table_schema,"`.`",vs_source_table_name,"_baseline` AS tbloriginal 
WHERE ",vs_delete_column,"<> 1 ",IFNULL(CONCAT(' AND ',var_query_cond),''),";

  SET tmNow = NOW(),
    sTimeResult = CONCAT(sTimeResult,' | inserer les colonnes qui nont pas query str : ', TIMEDIFF( tmNow, tmPrev )),
    tmPrev = tmNow;   
  
  " );
SET done= FALSE ;

OPEN cursor_query_str_columns;

	read_loop: LOOP
	
	FETCH cursor_query_str_columns INTO var_curated_schema,var_curated_table,var_query_str,var_query_cond,var_curated_column,var_source_column,var_expression,var_source_table ;
	
	IF done THEN
		LEAVE read_loop;
	END IF;

	IF var_curated_table= table_name THEN 
	
		-- CALL management.SP_Utils_ExecMultipleStmt(var_indexes_query);

    SELECT 
      (CASE WHEN IFNULL(var_expression,'')='' THEN CONCAT('tblcu.',var_source_column)
      ELSE REPLACE(var_expression,var_source_table,'tblcu')
      END) AS source_column Into @source_column;

		SET vs_result_str=CONCAT(vs_result_str,
"UPDATE curated.tbl_syncinfo SET NextStep = 'avec query str - ", var_curated_column, "' WHERE ProcessName = SyncInfoProcessName;
");
IF var_source_table = 'curated' THEN 
  SET var_join_query_str=var_query_str;
ELSE
  SET var_join_query_str=CONCAT(
    SUBSTRING_INDEX(TRIM(var_query_str), ' tblcu', 1),
    '_baseline tblcu',
    SUBSTRING_INDEX(TRIM(var_query_str), ' tblcu', -1)
  );
END IF ;

SET vs_result_str=CONCAT(vs_result_str,"
UPDATE curated.`",vs_sync_tablename,"` AS tbl_des
LEFT JOIN ",var_query_str,"
SET tbl_des.", var_curated_column ," = ", @source_column ,"
WHERE IFNULL(tbl_des.", var_curated_column ,",'') <> IFNULL(", @source_column ,",'');
");


	END IF;
END LOOP;
  
SET vs_result_str = CONCAT( vs_result_str, "
SET tmNow = NOW(),
    sTimeResult = CONCAT(sTimeResult,' | inserer les colonnes qui ont query str : ', TIMEDIFF( tmNow, tmPrev )),
	tmPrev = tmNow;
    
  " );
CLOSE cursor_query_str_columns;	

CALL management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT('curated',table_name, vs_outputDelete, vs_outputInsert, vs_outputUpdate);

SET _output_sp=CONCAT(vs_result_str,
"
-- ----- MAJ de la table régulière ----- --
-- Delete
UPDATE curated.tbl_syncinfo 
SET NextStep = '_sync to reg - delete'
WHERE ProcessName = SyncInfoProcessName;

",IFNULL(CONCAT(vs_outputDelete,';'),''),
"

SET tmNow = NOW(),
	sTimeResult = CONCAT(sTimeResult,' | _sync to reg - delete: ', TIMEDIFF( tmNow, tmPrev )),
	tmPrev = tmNow;

-- Insert
UPDATE curated.tbl_syncinfo SET NextStep = '_sync to reg - insert' WHERE ProcessName = SyncInfoProcessName;

",IFNULL(CONCAT(vs_outputInsert,';'),''),
"

SET tmNow = NOW(),
	sTimeResult = CONCAT(sTimeResult,' | _sync to reg - insert: ', TIMEDIFF( tmNow, tmPrev )),
	tmPrev = tmNow;

-- Update
UPDATE curated.tbl_syncinfo SET NextStep = '_sync to reg - update' WHERE ProcessName = SyncInfoProcessName;

",IFNULL(CONCAT(vs_outputUpdate,';'),''),
"

-- ----------------------------------------------------------------------------
-- ---   Cleanup
-- ----------------------------------------------------------------------------
SET tmNow = NOW(),
	sTimeResult = CONCAT(sTimeResult,' | _sync to reg - update: ', TIMEDIFF( tmNow, tmPrev )),
	tmPrev = tmNow;     

-- Cleanup
UPDATE curated.tbl_syncinfo SET NextStep = 'Cleanup' WHERE ProcessName = SyncInfoProcessName;

DROP TABLE IF EXISTS curated.",vs_sync_tablename,";

DROP TEMPORARY TABLE IF EXISTS `",vs_source_table_schema,"`.`tbltmp_max_vn_by_id_",vs_source_table_name,"`;


SET tmNow = NOW(),
	sTimeResult = CONCAT(sTimeResult,' | Cleanup: ', TIMEDIFF( tmNow, tmPrev )),
	tmPrev = tmNow;     

-- -----------------------------------------------------
-- --- Finaliser
-- -----------------------------------------------------
UPDATE curated.tbl_syncinfo SET NextStep = 'Finaliser' WHERE ProcessName = SyncInfoProcessName;

SET tmNow = NOW();

SET sTimeResult = CONCAT(
  'Total: ',
  TIMEDIFF( tmNow, tmStart ),
  ' || ',
  sTimeResult,
  ' | Finaliser: ',
	TIMEDIFF( tmNow, tmPrev )
); -- Update syncInfo

UPDATE curated.tbl_syncinfo
SET NextStep = 'Finished',
	SyncEnd = NOW(),
	LastFinished = NOW(),
	IsSynchronisingRegularTable = 0,
	SyncInfo = sTimeResult 
WHERE ProcessName = SyncInfoProcessName;

INSERT INTO tbl_syncinfo_log
SELECT * FROM tbl_syncinfo WHERE ProcessName = SyncInfoProcessName;

END
");




PREPARE stmt1 FROM _output_sp;

EXECUTE stmt1;
DEALLOCATE PREPARE stmt1; 

SET vs_sync_tablename=CONCAT("CALL SP_Sync_",table_name,"();");

PREPARE stmt2 FROM vs_sync_tablename;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2; 




SET tmNow = NOW(),
	sTimeResult = CONCAT(sTimeResult,' | ',CONCAT('SP_Sync_',table_name),': ',TIMEDIFF( tmNow, tmPrev )),
  tmPrev = tmNow;     

-- -----------------------------------------------------
-- --- Finaliser
-- -----------------------------------------------------
UPDATE curated.tbl_syncinfo 
SET NextStep = 'Finaliser' 
WHERE ProcessName = SyncInfoProcessName;


SET tmNow = NOW();

SET sTimeResult = CONCAT(
  'Total: ',
  TIMEDIFF( tmNow, tmStart ),
  ' || ',
  sTimeResult,
  ' | Finaliser: ',
	TIMEDIFF( tmNow, tmPrev )
); -- Update syncInfo

UPDATE curated.tbl_syncinfo --  - fin
SET NextStep = 'Finished',
	SyncEnd = NOW(),
	LastFinished = NOW(),
	IsSynchronisingRegularTable = 0,
	SyncInfo = sTimeResult 
WHERE ProcessName = SyncInfoProcessName;

INSERT INTO curated.tbl_syncinfo_log
SELECT * FROM curated.tbl_syncinfo WHERE ProcessName = SyncInfoProcessName; 

END