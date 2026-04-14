# SP_CreateAndExecuteSyncSPFromMapForRawD365Tables

## 📌 Informations Générales

| Propriété | Valeur |
|-----------|--------|
| **Schéma** | `curated` |
| **Nom** | `SP_CreateAndExecuteSyncSPFromMapForRawD365Tables` |
| **Type** | Procédure Stockée Génératrice |
| **Créée par** | Ezzeddine Chakroun |
| **Date création** | 2025-11-04 |
| **Dernière modification** | 2026-03-27 |
| **Statut** | Actif |

## 🔍 Description

Génère et exécute dynamiquement la procédure stockée de synchronisation des données depuis le schéma `d365_raw` vers le schéma curated pour une table spécifique, basée sur le mappage défini dans `curated.tbl_map_raw_to_curated`.

Cette SP est spécialisée dans la synchronisation **d365_raw-to-curated**, effectuant un processus d'ETL (Extract-Transform-Load) avec gestion avancée des versions et suppressions logiques. Elle crée des tables baseline pour tracker les changements depuis Dynamics 365, applique un filtrage temporel de 3 minutes, et gère les transformations d'expressions complexes.

**Cas d'utilisation :**
- Synchronisation de comptes depuis Dynamics 365 vers curated
- Synchronisation de contacts et leads depuis D365
- Synchronisation de produits et tarification depuis D365
- Gestion des suppressions logiques (IsDelete = 'True')
- Suivi des versions (versionnumber) pour détecter les changements

## 📥 Paramètres

### Paramètres d'entrée

| Paramètre | Type | Description | Obligatoire | Valeur par défaut |
|-----------|------|-------------|-------------|-------------------|
| `table_name` | `VARCHAR(100)` | Nom de la table curated cible présente dans `tbl_map_raw_to_curated` | Oui | - |

### Paramètres de sortie

| Paramètre | Type | Description |
|-----------|------|-------------|
| Aucun | - | Crée et exécute directement la SP intermédiaire (contrairement à la SP parent qui retourne le code) |

## 📊 Données Manipulées

### Tables d'entrée

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| `tbl_map_raw_to_curated` | `curated` | Métadonnées | Configuration du mappage colonne-par-colonne pour la synchronisation D365 |
| `tbl_syncinfo` | `curated` | État | Informations de suivi de synchronisation |
| tables sources dynamiques | `d365_raw` | Source | Tables d365_raw dont les données sont synchronisées |
| `${source_table}_baseline` | `d365_raw` | État comparatif | Table baseline pour tracker les changements depuis le dernier sync |

### Tables de sortie

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| tables curated dynamiques | `curated` | Destination | Table curated cible remplie avec données transformées |
| `tbl_syncinfo_log` | `curated` | Journalisation | Historique des exécutions de synchronisation |
| `${source_table}_baseline` | `d365_raw` | État comparatif | Table mise à jour avec les dernières données synchronisées |

### Tables de référence

| Table | Schéma | Usage |
|-------|--------|-------|
| `tbl_syncinfo` | `curated` | Suivi des états de synchronisation et verrous |
| `INFORMATION_SCHEMA.ROUTINES` | système | Vérification des procédures custom |
| `INFORMATION_SCHEMA.TABLES` | système | Validation des schémas et tables |
| `INFORMATION_SCHEMA.COLUMNS` | système | Extraction des clés primaires et métadonnées colonnes |
| `management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT` | management | Génération des requêtes DELETE/INSERT/UPDATE |

## ⚙️ Logique et Flux

### Étapes principales

1. **Validation et Initialisation**
   - Vérification que la base de données est bien `curated`
   - Vérification l'absence de procédure custom `SP_Sync_${table_name}_custom`
   - Création/récupération de la table `tbl_syncinfo`
   - Vérification que aucune synchronisation n'est en cours
   - Récupération du schéma source (doit être `d365_raw`)
   - Extraction des métadonnées de mappage (colonnes, conditions, expressions)

2. **Validation du Schéma Source et Configuration**
   - Vérification que le schéma source est `d365_raw` (sinon signale erreur)
   - Récupération du nom de la table source
   - Extraction des clés primaires (exclusion de `versionnumber`)
   - Configuration des colonnes de version (`versionnumber`) et suppression (`IsDelete`)

3. **Gestion des Tables Baseline**
   - Création de la table baseline `${source_table}_baseline` si elle n'existe pas
   - Vérification/correction de la clé primaire (doit exclure `versionnumber`)
   - Calcul du dernier timestamp de modification (avec recul de 3 minutes pour chevauchement)
   - Création d'une table temporaire `tbltmp_max_vn_by_id_${source_table}` pour tracker la dernière version par ID

4. **Remplissage de la Table Baseline**
   - Utilisation de REPLACE INTO pour mettre à jour la baseline
   - Synchronisation uniquement des enregistrements modifiés depuis le dernier sync (comparaison timestamp)
   - Sélection de la dernière version (versionnumber) pour chaque ID

5. **Génération Dynamique de la SP Temporaire**
   - Construction du code SQL complet pour `SP_Sync_${table_name}`
   - Création de la table de travail `${table_name}_sync`
   - Intégration des colonnes sans jointure (query_str vide)
   - Filtrage des enregistrements supprimés (`IsDelete <> 'True'`)
   - Intégration des colonnes avec jointures et expressions complexes
   - Gestion des UPDATE avec LEFT JOIN sur tables auxiliaires

6. **Exécution de la SP Générée**
   - Préparation dynamique de la SP via PREPARE STATEMENT
   - Exécution de la SP
   - Suppression de la table de travail `${table_name}_sync`
   - Suppression de la table temporaire `tbltmp_max_vn_by_id_${source_table}`

7. **Appel Direct de la SP Générée**
   - Exécution immédiate de `SP_Sync_${table_name}` pour effectuer la synchronisation
   - Cela inclut :
     - Insertion des colonnes sans jointure depuis la baseline
     - Mise à jour des colonnes avec jointures
     - Synchronisation vers la table régulière (DELETE/INSERT/UPDATE) via management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT
     - Nettoyage de la table intermédiaire

8. **Finalisation et Journalisation**
   - Mise à jour de l'état dans `tbl_syncinfo`
   - Insertion d'un enregistrement dans `tbl_syncinfo_log` pour historique
   - Enregistrement des temps d'exécution par étape

### Diagramme du flux

```
START
  │
  ├─→ Vérifier base de données = 'curated'
  │
  ├─→ Vérifier absence de SP custom
  │
  ├─→ Créer/récupérer tbl_syncinfo
  │
  ├─→ Vérifier aucune sync en cours
  │   (IsSynchronisingRegularTable = 0)
  │
  ├─→ Récupérer métadonnées de mappage
  │   ├─→ source_table (doit être 'd365_raw')
  │   ├─→ latest_version_column = 'versionnumber'
  │   ├─→ delete_column = 'IsDelete'
  │   └─→ colonnes avec/sans query_str
  │
  ├─→ Valider schéma source = 'd365_raw'
  │
  ├─→ Gérer tables baseline
  │   ├─→ Créer ${source_table}_baseline si absent
  │   ├─→ Récupérer dernier timestamp (-3 min)
  │   ├─→ Créer table temporaire max versions
  │   └─→ Mettre à jour baseline (REPLACE INTO)
  │
  ├─→ Générer dynamiquement SP_Sync_${table_name}
  │   ├─→ Créer table ${table_name}_sync
  │   ├─→ Insérer colonnes sans query_str (avec filtre IsDelete)
  │   ├─→ Updater colonnes avec query_str (LEFT JOIN)
  │   ├─→ Appeler management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT
  │   ├─→ Synchroniser à table régulière (DELETE/INSERT/UPDATE)
  │   └─→ Nettoyer tables temporaires
  │
  ├─→ PREPARE STATEMENT du code généré
  │
  ├─→ EXECUTE SP_Sync_${table_name}
  │
  ├─→ DEALLOCATE PREPARE
  │
  ├─→ CALL SP_Sync_${table_name}() - exécution directe
  │
  ├─→ Mettre à jour tbl_syncinfo (Finished)
  │
  ├─→ Logger dans tbl_syncinfo_log
  │
  └─→ END
```

## ⚠️ Contraintes et Limitations

- **Schéma source obligatoire** : Le schéma source doit **obligatoirement** être `d365_raw` (sinon signale erreur 45000)
- **Schéma de destination** : Seul `curated` est supporté
- **Colonnes dans expressions** : Maximum 4 colonnes (sources ou destinations) par expression
- **Colonnes d'expression** : Toutes les colonnes utilisées dans la colonne `expression` doivent être présentes dans `source_column` (séparées par virgules)
- **Primary Key** : Une clé primaire doit être obligatoirement définie dans `tbl_map_raw_to_curated`, sans `versionnumber`
- **SP Custom** : L'existence d'une SP `SP_Sync_${table_name}_custom` empêche l'exécution
- **Pas d'index creation** : À partir de 2026-03-27, la création d'index a été supprimée (US 597)
- **Délai de 3 minutes** : Recul automatique de 3 minutes lors du filtrage temporel pour éviter les chevauchements
- **Gestion IsDelete** : À partir de 2025-12-18, utilise IFNULL pour vérifier `IsDelete <> 'True'`
- **Colonne versionnumber exclue** : La colonne `versionnumber` est exclue de la clé primaire de la baseline

## 🔒 Conditions préalables

- La table doit exister dans `curated.tbl_map_raw_to_curated` avec au moins une rangée
- **Le schéma source DOIT être `d365_raw`** (validation stricte)
- Une clé primaire doit être identifiée pour la table source (sans `versionnumber`)
- La table source en d365_raw doit contenir les colonnes :
  - `versionnumber` : Pour tracker les versions
  - `IsDelete` : Pour le marquage de suppression logique
  - `modifiedon` : Pour le timestamp de modification (format ISO)
- Permissions d'accès aux tables `tbl_syncinfo`, `tbl_syncinfo_log` et aux schémas `d365_raw` et `curated`
- Une table `goliveinfor.tbl_syncinfo` doit exister comme modèle (si tbl_syncinfo n'existe pas)
- Accès à la procédure `management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT` pour générer les requêtes SYNC
- L'utilisateur exécutant doit avoir les permissions :
  - CREATE/DROP PROCEDURE/TABLE sur le schéma `curated`
  - SELECT/INSERT/UPDATE/DELETE sur les tables d365_raw et curated impliquées
  - Accès au schéma `management` pour exécuter SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT

## 🚨 Gestion des erreurs

| Code d'erreur | Condition | Message | Action corrective |
|---------------|-----------|---------|-------------------|
| `45000` | Base de données ≠ 'curated' | `ERROR: wrong database` | Vérifier le contexte de base de données avant l'exécution |
| `45000` | SP custom existe pour cette table | `ERROR: there is a custom SP` | Supprimer la SP custom ou utiliser un nom de table différent |
| `45000` | Synchronisation déjà en cours | `ERROR: [ProcessName]: is already synchronising` | Vérifier `tbl_syncinfo.IsSynchronisingRegularTable` et corriger manuellement si nécessaire |
| `45000` | Schéma source ≠ 'd365_raw' | `ERROR: The schema of the source table [schema]: is not d365_raw. Please use another SP to Create and Execute the Sync` | Utiliser `SP_CreateAndExecuteSyncSPFromMapForRawInforTables` ou `SP_CreateAndExecuteSyncSPFromMapForCuratedTables` selon le schéma source |

## 📝 Exemple d'utilisation

```sql
-- Appel simple pour synchroniser la table 'Account' depuis d365_raw
CALL curated.SP_CreateAndExecuteSyncSPFromMapForRawD365Tables('Account');

-- Appel pour synchroniser 'Contact'
CALL curated.SP_CreateAndExecuteSyncSPFromMapForRawD365Tables('Contact');

-- Appel pour synchroniser 'Product'
CALL curated.SP_CreateAndExecuteSyncSPFromMapForRawD365Tables('Product');

-- Vérifier l'état dans tbl_syncinfo
SELECT ProcessName, SyncStart, SyncEnd, SyncInfo 
FROM curated.tbl_syncinfo 
WHERE ProcessName LIKE 'SP_CreateAndExecuteSyncSPFromMapForRawD365Tables%'
ORDER BY SyncStart DESC;

-- Consulter l'historique des syncs
SELECT ProcessName, SyncStart, SyncEnd, SyncInfo 
FROM curated.tbl_syncinfo_log 
WHERE ProcessName LIKE '%SP_Sync_Account%'
ORDER BY SyncStart DESC LIMIT 5;

-- Vérifier l'état de la baseline après sync
SELECT COUNT(*) AS total_records, MAX(modifiedon) AS last_modified
FROM d365_raw.Account_baseline;
```

## 📊 Performance

| Aspect | Valeur | Notes |
|--------|--------|-------|
| Temps d'exécution moyen | 15-90 secondes | Dépend de la taille des données D365 et complexité des jointures |
| Indexation requise | Oui | Sur clés primaires, versionnumber, modifiedon, et colonnes de jointure |
| Ressources | Modérées à élevées | Création table baseline + comparaison versions + LEFT JOINs = I/O intensif |
| Allocation mémoire | Variable | Dépend du volume de données D365 |
| Récupération delta | 3 minutes avant dernier sync | Overlap configuré pour garantir aucune donnée manquée |

## 🔄 Dépendances

### Procédures appelées

- `management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT` : Génération des requêtes DELETE/INSERT/UPDATE
- Aucune autre procédure stockée appelée (génère et exécute directement)
- Utilise les curseurs pour parcourir le mappage

### Procédures qui l'appellent

- `SP_CreateAndExecuteSyncSPFromMap` (SP parent qui aiguille selon le schéma source)
- Processus d'initialisation de base de données
- Pipelines Azure Data Factory de synchronisation d365-to-curated

### Tâches planifiées

- Exécution manuelle via outils d'administration de base de données
- Exécution périodique via Azure Data Factory pour synchronisation continue

### Tables générées dynamiquement

- `SP_Sync_${table_name}` : Procédure générée pour la synchronisation spécifique
- `curated.${table_name}_sync` : Table intermédiaire pour stockage temporaire
- `d365_raw.tbltmp_max_vn_by_id_${source_table}` : Table temporaire pour tracker les versions maximales
- `d365_raw.${source_table}_baseline` : Table baseline pour détecter les changements

## 📋 Historique des modifications

| Date | Auteur | Référence | Modification |
|------|--------|-----------|--------------|
| 2026-03-27 | Pierre-Yves Calpetard (Emyode) | US #597 | Suppression de la création d'index |
| 2026-01-28 | Vadim Simanovsky (Emyode) | US #521 | Ajout de commentaires sur les SP curés |
| 2025-12-18 | - | - | Ajout de IFNULL pour vérification IsDelete |
| 2025-11-04 | - | - | Ajout d'un index sur modifiedon dans la baseline |
| 2025-11-04 | Ezzeddine Chakroun | [MERP-99] | Création initiale |

## 📌 Notes et Points d'attention

- **Schéma source obligatoire d365_raw** : Cette procédure est **strictement réservée** à la synchronisation d365_raw-to-curated. Pour les autres schémas (infor_raw, curated), utiliser les autres procédures spécialisées
- **Gestion des colonnes D365 requises** : La table source doit obligatoirement contenir :
  - `versionnumber` : Entier croissant pour chaque version
  - `IsDelete` : Booléen/Chaîne ('True'/'False') pour suppression logique
  - `modifiedon` : Timestamp ISO (format: 'YYYY-MM-DDTHH:mm:ssZ')
- **Verrou de synchronisation** : Si vous rencontrez l'erreur "is already synchronising" et que "Server Monitor" montre que la sync n'est pas en cours, mettez manuellement `IsSynchronisingRegularTable = 0` dans `curated.tbl_syncinfo`
- **SP Custom override** : Les SP nommées `SP_Sync_${table_name}_custom` sont validées et blocquent l'exécution, permettant une surcharge personnalisée
- **Tracking temporel détaillé** : Les logs incluent des TIMEDIFF pour chaque étape (Init, baselines, création table sync, insertion, update, sync, cleanup, finalisation)
- **Baselines pour change detection** : Les tables baseline sont essentielles pour détecter les changements incrémentiels depuis D365
- **Délai de 3 minutes intentionnel** : Le recul de 3 minutes est configuré pour gérer les décalages d'horloge et éviter les races conditions
- **Pas d'index depuis US 597** : À partir de mars 2026, la création dynamique d'index a été supprimée pour améliorer la performance
- **Curseurs pour jointures** : Utilise deux curseurs pour traiter les colonnes avec jointures (query_str)
- **Génération une seule fois théorique** : Théoriquement, cette SP devrait être utilisée une seule fois par table lors de l'initialisation D365

## 🔗 Références

- Fichier source : [SP_CreateAndExecuteSyncSPFromMapForRawD365Tables.sql](SP_CreateAndExecuteSyncSPFromMapForRawD365Tables.sql)
- SP Parent : [SP_CreateAndExecuteSyncSPFromMap.md](SP_CreateAndExecuteSyncSPFromMap.md)
- Tables de configuration : `curated.tbl_map_raw_to_curated`
- Tables de suivi : `curated.tbl_syncinfo`, `curated.tbl_syncinfo_log`
- Procédure de génération de sync : `management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT`
- Répertoire des procédures : [docs/procedure_sql/](docs/procedure_sql/)

---

**Template utilisé :** `stored-procedure.template.md`
