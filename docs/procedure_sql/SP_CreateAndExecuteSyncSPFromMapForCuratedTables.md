# SP_CreateAndExecuteSyncSPFromMapForCuratedTables

## 📌 Informations Générales

| Propriété | Valeur |
|-----------|--------|
| **Schéma** | `curated` |
| **Nom** | `SP_CreateAndExecuteSyncSPFromMapForCuratedTables` |
| **Type** | Procédure Stockée Génératrice |
| **Créée par** | Ezzeddine Chakroun |
| **Date création** | 2025-11-04 |
| **Dernière modification** | 2026-03-27 |
| **Statut** | Actif |

## 🔍 Description

Génère et exécute dynamiquement la procédure stockée de synchronisation des données au sein du schéma curated pour une table spécifique, basée sur le mappage défini dans `curated.tbl_map_raw_to_curated`.

Cette SP est spécialisée dans la synchronisation **curated-to-curated**, effectuant un processus d'ETL (Extract-Transform-Load) en créant une SP temporaire adaptée au mappage de colonne spécifique, puis l'exécute pour synchroniser les données. Elle gère les jointures complexes avec les tables auxiliaires (query_str) et les transformations d'expressions.

**Cas d'utilisation :**
- Synchronisation de données entre tables curated
- Enrichissement de colonnes depuis tables auxiliaires curated
- Application de transformations et expressions au sein du schéma curated
- Migration et mise à jour de données curated

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
| `tbl_map_raw_to_curated` | `curated` | Métadonnées | Configuration du mappage colonne-par-colonne pour la synchronisation curated |
| `tbl_syncinfo` | `curated` | État | Informations de suivi de synchronisation |
| tables sources dynamiques | `curated` | Source | Tables curated sources dont les données sont synchronisées |

### Tables de sortie

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| tables curated dynamiques | `curated` | Destination | Table curated cible remplie avec données transformées |
| `tbl_syncinfo_log` | `curated` | Journalisation | Historique des exécutions de synchronisation |

### Tables de référence

| Table | Schéma | Usage |
|-------|--------|-------|
| `tbl_syncinfo` | `curated` | Suivi des états de synchronisation et verrous |
| `INFORMATION_SCHEMA.ROUTINES` | système | Vérification des procédures custom |
| `INFORMATION_SCHEMA.TABLES` | système | Validation des schémas et tables |
| `INFORMATION_SCHEMA.COLUMNS` | système | Extraction des clés primaires et métadonnées colonnes |

## ⚙️ Logique et Flux

### Étapes principales

1. **Validation et Initialisation**
   - Vérification que la base de données est bien `curated`
   - Vérification l'absence de procédure custom `SP_Sync_${table_name}_custom`
   - Création/récupération de la table `tbl_syncinfo`
   - Vérification que aucune synchronisation n'est en cours
   - Récupération du schéma source (doit être `curated`)
   - Extraction des métadonnées de mappage (colonnes, conditions, expressions)

2. **Validation du Schéma Source**
   - Vérification que le schéma source est `curated` (sinon signale une erreur)
   - Récupération du nom de la table source
   - Extraction des clés primaires (exclusion de `versionnumber`)

3. **Génération Dynamique de la SP Temporaire**
   - Construction du code SQL complet pour `SP_Sync_${table_name}`
   - Intégration des colonnes sans jointure (query_str vide)
   - Intégration des colonnes avec jointures et expressions complexes
   - Gestion des UPDATE avec LEFT JOIN sur tables auxiliaires
   - Intégration des conditions de filtrage (query_cond)

4. **Exécution de la SP Générée**
   - Préparation dynamique de la SP via PREPARE STATEMENT
   - Exécution de la SP
   - Suppression de la table de travail `${table_name}_sync`

5. **Appel Direct de la SP Générée**
   - Exécution immédiate de `SP_Sync_${table_name}` pour effectuer la synchronisation
   - Cela inclut :
     - Création de la table intermédiaire `${table_name}_sync`
     - Insertion des colonnes sans jointure
     - Mise à jour des colonnes avec jointures
     - Synchronisation vers la table régulière (DELETE/INSERT/UPDATE)
     - Nettoyage de la table intermédiaire

6. **Finalisation et Journalisation**
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
  │   ├─→ source_table (doit être 'curated')
  │   ├─→ colonnes sans query_str
  │   ├─→ colonnes avec query_str (jointures)
  │   └─→ conditions de filtrage (query_cond)
  │
  ├─→ Valider schéma source = 'curated'
  │
  ├─→ Générer dynamiquement SP_Sync_${table_name}
  │   ├─→ Créer table ${table_name}_sync
  │   ├─→ Insérer colonnes sans query_str
  │   ├─→ Updater colonnes avec query_str (LEFT JOIN)
  │   ├─→ Synchroniser à la table régulière
  │   └─→ Nettoyer table temporaire
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

- **Schéma source obligatoire** : Le schéma source doit **obligatoirement** être `curated` (sinon signale erreur 45000)
- **Schéma de destination** : Seul `curated` est supporté
- **Colonnes dans expressions** : Maximum 4 colonnes (sources ou destinations) par expression
- **Colonnes d'expression** : Toutes les colonnes utilisées dans la colonne `expression` doivent être présentes dans `source_column` (séparées par virgules)
- **Primary Key** : Une clé primaire doit être obligatoirement définie dans `tbl_map_raw_to_curated`
- **SP Custom** : L'existence d'une SP `SP_Sync_${table_name}_custom` empêche l'exécution
- **Pas d'index creation** : À partir de 2026-03-27, la création d'index a été supprimée (US 597)
- **Exclusion colonne versionnumber** : Les clés primaires nommées `versionnumber` sont exclues du calcul de jointure

## 🔒 Conditions préalables

- La table doit exister dans `curated.tbl_map_raw_to_curated` avec au moins une rangée
- **Le schéma source DOIT être `curated`** (validation stricte)
- Une clé primaire doit être identifiée pour la table source
- Permissions d'accès aux tables `tbl_syncinfo`, `tbl_syncinfo_log` et au schéma `curated`
- Une table `goliveinfor.tbl_syncinfo` doit exister comme modèle (si tbl_syncinfo n'existe pas)
- L'utilisateur exécutant doit avoir les permissions :
  - CREATE/DROP PROCEDURE sur le schéma `curated`
  - CREATE/DROP TABLE sur le schéma `curated`
  - SELECT/INSERT/UPDATE/DELETE sur les tables curated impliquées

## 🚨 Gestion des erreurs

| Code d'erreur | Condition | Message | Action corrective |
|---------------|-----------|---------|-------------------|
| `45000` | Base de données ≠ 'curated' | `ERROR: wrong database` | Vérifier le contexte de base de données avant l'exécution |
| `45000` | SP custom existe pour cette table | `ERROR: there is a custom SP` | Supprimer la SP custom ou utiliser un nom de table différent |
| `45000` | Synchronisation déjà en cours | `ERROR: [ProcessName]: is already synchronising` | Vérifier `tbl_syncinfo.IsSynchronisingRegularTable` et corriger manuellement si nécessaire |
| `45000` | Schéma source ≠ 'curated' | `ERROR: The schema of the source table [schema]: is not curated. Please use another SP to Create and Execute the Sync` | Utiliser `SP_CreateAndExecuteSyncSPFromMapForRawD365Tables` ou `SP_CreateAndExecuteSyncSPFromMapForRawInforTables` selon le schéma source |

## 📝 Exemple d'utilisation

```sql
-- Appel simple pour synchroniser la table 'CustomerEnhanced' depuis source curated
CALL curated.SP_CreateAndExecuteSyncSPFromMapForCuratedTables('CustomerEnhanced');

-- Appel pour synchroniser 'AccountDetails'
CALL curated.SP_CreateAndExecuteSyncSPFromMapForCuratedTables('AccountDetails');

-- Vérifier l'état dans tbl_syncinfo
SELECT ProcessName, SyncStart, SyncEnd, SyncInfo 
FROM curated.tbl_syncinfo 
WHERE ProcessName LIKE 'SP_CreateAndExecuteSyncSPFromMapForCuratedTables%'
ORDER BY SyncStart DESC;

-- Consulter l'historique des syncs
SELECT ProcessName, SyncStart, SyncEnd, SyncInfo 
FROM curated.tbl_syncinfo_log 
WHERE ProcessName LIKE '%SP_Sync_CustomerEnhanced%'
ORDER BY SyncStart DESC LIMIT 5;
```

## 📊 Performance

| Aspect | Valeur | Notes |
|--------|--------|-------|
| Temps d'exécution moyen | 10-60 secondes | Dépend de la taille des données et de la complexité des jointures |
| Indexation requise | Oui | Sur les colonnes de clé primaire et jointure (query_str) |
| Ressources | Modérées à élevées | Création de table temporaire + LEFT JOINs = I/O intensif |
| Allocation mémoire | Variable | Dépend du volume de données dans la table source |

## 🔄 Dépendances

### Procédures appelées

- Aucune autre procédure stockée appelée (génère et exécute directement)
- Utilise les curseurs pour parcourir le mappage

### Procédures qui l'appellent

- `SP_CreateAndExecuteSyncSPFromMap` (SP parent qui aiguille selon le schéma source)
- Processus d'initialisation de base de données
- Pipelines Azure Data Factory de synchronisation curated-to-curated

### Tâches planifiées

- Exécution manuelle via outils d'administration de base de données
- Intégration dans pipelines ADF pour synchronisation périodique

### Tables générées dynamiquement

- `SP_Sync_${table_name}` : Procédure générée pour la synchronisation spécifique
- `curated.${table_name}_sync` : Table intermédiaire pour stockage temporaire

## 📋 Historique des modifications

| Date | Auteur | Référence | Modification |
|------|--------|-----------|--------------|
| 2026-03-27 | Pierre-Yves Calpetard (Emyode) | US #597 | Suppression de la création d'index |
| 2026-01-28 | Vadim Simanovsky (Emyode) | US #521 | Ajout de commentaires sur les SP curés |
| 2025-11-04 | Ezzeddine Chakroun | [MERP-99] | Création initiale |

## 📌 Notes et Points d'attention

- **Schéma source obligatoire curated** : Cette procédure est **strictement réservée** à la synchronisation curated-to-curated. Pour les autres schémas (infor_raw, d365_raw), utiliser les autres procédures spécialisées
- **Verrou de synchronisation** : Si vous rencontrez l'erreur "is already synchronising" et que "Server Monitor" montre que la sync n'est pas en cours, mettez manuellement `IsSynchronisingRegularTable = 0` dans `curated.tbl_syncinfo`
- **SP Custom override** : Les SP nommées `SP_Sync_${table_name}_custom` sont validées et blocquent l'exécution, permettant une surcharge personnalisée
- **Tracking temporel détaillé** : Les logs incluent des TIMEDIFF pour chaque étape (Init, création table sync, insertion, update, synchronisation, cleanup, finalisation)
- **Curseurs pour jointures** : Utilise deux curseurs pour traiter les colonnes avec jointures (query_str)
- **Pas d'index depuis US 597** : À partir de mars 2026, la création dynamique d'index a été supprimée
- **Génération une seule fois théorique** : Théoriquement, cette SP devrait être utilisée une seule fois par table (like the parent SP)

## 🔗 Références

- Fichier source : [SP_CreateAndExecuteSyncSPFromMapForCuratedTables.sql](SP_CreateAndExecuteSyncSPFromMapForCuratedTables.sql)
- SP Parent : [SP_CreateAndExecuteSyncSPFromMap.md](SP_CreateAndExecuteSyncSPFromMap.md)
- Tables de configuration : `curated.tbl_map_raw_to_curated`
- Tables de suivi : `curated.tbl_syncinfo`, `curated.tbl_syncinfo_log`
- Répertoire des procédures : [docs/procedure_sql/](docs/procedure_sql/)

---

**Template utilisé :** `stored-procedure.template.md`
