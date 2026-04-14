# SP_CreateAndExecuteSyncSPFromMap

## 📌 Informations Générales

| Propriété | Valeur |
|-----------|--------|
| **Schéma** | `curated` |
| **Nom** | `SP_CreateAndExecuteSyncSPFromMap` |
| **Type** | Procédure Stockée Génératrice |
| **Créée par** | Ezzeddine Chakroun |
| **Date création** | 2024-10-17 |
| **Dernière modification** | 2026-01-28 |
| **Statut** | Actif |

## 🔍 Description

Génère et exécute dynamiquement la procédure stockée de synchronisation des données depuis les schémas raw (`infor_raw`, `d365_raw`) vers le schéma curated, basée sur le mappage défini dans `curated.tbl_map_raw_to_curated`.

Cette SP effectue un processus d'ETL (Extract-Transform-Load) en créant une SP temporaire adaptée au mappage de colonne spécifique, puis l'exécute pour synchroniser les données. Elle est généralement utilisée en tant que one-shot ou dans un processus de création de tables.

**Cas d'utilisation :**
- Initialisation de la synchronisation de données raw vers curated
- Migration de données depuis Infor vers Dynamics 365
- Synchronisation de comptes clients et produits
- Alignement des données d'inventaire entre systèmes

## 📥 Paramètres

### Paramètres d'entrée

| Paramètre | Type | Description | Obligatoire | Valeur par défaut |
|-----------|------|-------------|-------------|-------------------|
| `table_name` | `VARCHAR(100)` | Nom de la table curated cible présente dans `tbl_map_raw_to_curated` | Oui | - |

### Paramètres de sortie

| Paramètre | Type | Description |
|-----------|------|-------------|
| `_output_sp` | `LONGTEXT` | Code SQL généré de la SP de synchronisation (sans directives DELIMITER) |

## 📊 Données Manipulées

### Tables d'entrée

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| `tbl_map_raw_to_curated` | `curated` | Métadonnées | Configuration du mappage colonne-par-colonne entre raw et curated |
| `tbl_syncinfo` | `curated` | État | Informations de suivi de synchronisation |
| tables sources dynamiques | `infor_raw`, `d365_raw` | Source | Tables raw dont les données sont synchronisées |

### Tables de sortie

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| tables curated dynamiques | `curated` | Destination | Tables curated remplies avec données transformées |
| `tbl_syncinfo_log` | `curated` | Journalisation | Historique des exécutions de synchronisation |

### Tables de référence

| Table | Schéma | Usage |
|-------|--------|-------|
| `tbl_syncinfo` | `curated` | Suivi des états de synchronisation et verrous |
| `INFORMATION_SCHEMA.ROUTINES` | système | Vérification des procédures custom |
| `INFORMATION_SCHEMA.TABLES` | système | Validation des schémas et tables |

## ⚙️ Logique et Flux

### Étapes principales

1. **Validation et Initialisation**
   - Vérification que la base de données est bien `curated`
   - Vérification l'absence de procédure custom `SP_Sync_${table_name}_custom`
   - Création/récupération de la table `tbl_syncinfo`
   - Vérification que aucune synchronisation n'est en cours

2. **Récupération du Schéma Source**
   - Requête du mappage dans `tbl_map_raw_to_curated` pour obtenir le schéma source (`infor_raw`, `d365_raw`, ou `curated`)
   - Sélection du type de SP à générer basée sur le schéma détecté

3. **Génération de la SP de Synchronisation**
   - Parcours des rangées du mappage
   - Construction dynamique des instructions INSERT/UPDATE/DELETE
   - Gestion des expressions de transformation
   - Intégration des conditions de jointure et filtrage
   - Génération du code SQL complet

4. **Exécution de la SP Générée**
   - Appel de la SP appropriée selon le schéma source:
     - `SP_CreateAndExecuteSyncSPFromMapForRawD365Tables` pour D365
     - `SP_CreateAndExecuteSyncSPFromMapForRawInforTables` pour Infor
     - `SP_CreateAndExecuteSyncSPFromMapForCuratedTables` pour Curated
   - Exécution de la SP générée avec tracking du temps

5. **Finalisation et Journalisation**
   - Mise à jour de l'état dans `tbl_syncinfo`
   - Insertion d'un enregistrement dans `tbl_syncinfo_log` pour historique
   - Enregistrement des temps d'exécution

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
  ├─→ Récupérer source_schema depuis tbl_map_raw_to_curated
  │
  ├─→ Aiguiller selon source_schema
  │   ├─→ 'd365_raw' → SP_CreateAndExecuteSyncSPFromMapForRawD365Tables
  │   ├─→ 'infor_raw' → SP_CreateAndExecuteSyncSPFromMapForRawInforTables
  │   └─→ 'curated' → SP_CreateAndExecuteSyncSPFromMapForCuratedTables
  │
  ├─→ Exécuter SP générée
  │
  ├─→ Mettre à jour tbl_syncinfo (Finished)
  │
  ├─→ Logger dans tbl_syncinfo_log
  │
  └─→ END
```

## ⚠️ Contraintes et Limitations

- **Schéma de destination** : Seul `curated` est supporté comme `curated_schema`
- **Schémas source** : Uniquement `infor_raw` et `d365_raw` sont supportés (plus `curated` lui-même)
- **Colonnes dans expressions** : Maximum 4 colonnes (sources ou destinations) par expression
- **Colonnes d'expression** : Toutes les colonnes utilisées dans la colonne `expression` doivent être présentes dans `source_column` (séparées par virgules)
- **Primary Key** : Une clé primaire doit être obligatoirement définie dans `tbl_map_raw_to_curated`
- **SP Custom** : L'existence d'une SP `SP_Sync_${table_name}_custom` empêche l'exécution

## 🔒 Conditions préalables

- La table doit exister dans `curated.tbl_map_raw_to_curated` avec au moins une rangée
- Une clé primaire doit être identifiée pour la table dans le mappage
- Permissions d'accès aux tables `tbl_syncinfo`, `tbl_syncinfo_log`, et au schéma source
- Vu que la table `tbl_syncinfo` peut être crée si elle n'existe pas, une table `goliveinfor.tbl_syncinfo` doit exister comme modèle
- L'utilisateur exécutant doit avoir les permissions CREATE PROCEDURE sur le schéma `curated`

## 🚨 Gestion des erreurs

| Code d'erreur | Condition | Message | Action corrective |
|---------------|-----------|---------|-------------------|
| `45000` | Base de données ≠ 'curated' | `ERROR: wrong database` | Vérifier le contexte de base de données avant l'exécution |
| `45000` | SP custom existe pour cette table | `ERROR: there is a custom SP` | Supprimer la SP custom ou utiliser un nom de table différent |
| `45000` | Synchronisation déjà en cours | `ERROR: [ProcessName]: is already synchronising` | Vérifier `tbl_syncinfo.IsSynchronisingRegularTable` et corriger manuellement si nécessaire |

## 📝 Exemple d'utilisation

```sql
-- Appel simple pour synchroniser la table 'Customer'
CALL curated.SP_CreateAndExecuteSyncSPFromMap('Customer', @output_sp);

-- Vérifier le code généré
SELECT @output_sp AS generated_procedure;

-- Appel pour synchroniser 'Account'
CALL curated.SP_CreateAndExecuteSyncSPFromMap('Account', @output_sp);

-- Récupération du code généré pour révision avant exécution
SELECT @output_sp INTO OUTFILE '/tmp/SP_Sync_Account.sql';
```

## 📊 Performance

| Aspect | Valeur | Notes |
|--------|--------|-------|
| Temps d'exécution moyen | 5-30 secondes | Dépend de la taille des données source et de la complexité du mappage |
| Indexation requise | Oui | Sur les colonnes de jointure et clés primaires |
| Ressources | Modérées | I/O intensif selon volume des tables source |

## 🔄 Dépendances

### Procédures appelées

- `SP_CreateAndExecuteSyncSPFromMapForRawD365Tables` (curated)
- `SP_CreateAndExecuteSyncSPFromMapForRawInforTables` (curated)
- `SP_CreateAndExecuteSyncSPFromMapForCuratedTables` (curated)

### Procédures qui l'appellent

- Processus d'initialisation de base de données
- Pipelines Azure Data Factory de synchronisation
- Scripts de migration de données

### Tâches planifiées

- Exécution manuelle via outils d'administration de base de données
- Intégration dans pipelines ADF pour synchronisation périodique

## 📋 Historique des modifications

| Date | Auteur | Référence | Modification |
|------|--------|-----------|--------------|
| 2026-01-28 | Vadim Simanovsky (Emyode) | US #521 | Ajout de commentaires sur les SP curés |
| 2025-11-10 | Ezzeddine Ch. | - | Division en 3 SP pour chaque schéma source |
| 2025-09-24 | Ezzeddine Ch. | - | Paramétrage de CONO dans les SP de sync |
| 2025-08-13 | Ezzeddine CH. | - | Traitement des cas expression + query_str non vides |
| 2025-08-12 | Ezzeddine CH. | - | Amélioration processus sync basée sur D365Client |
| 2025-05-26 | Ezzeddine CH. | - | Fix des requêtes updateinsertdelete null |
| 2025-02-14 | Ezzeddine CH. | - | Correction implémentation indexes_query |
| 2025-01-06 | Ezzeddine CH. | - | Correction implémentation query_cond |
| 2024-12-22 | Paul B. | [MERP_99] | Gestion IsSynchronisingRegularTable, formatage, espacements |
| 2024-11-19 | Paul B. | [MERP-99] | Ajustement du nom de la SP |
| 2024-11-14 | - | - | Modification inner join en left join |
| 2024-11-13 | Ezzeddine Chakroun | - | Ajout query_cond et création/exécution SP sync |
| 2024-11-12 | Ezzeddine Chakroun | - | Correction erreurs logs et utilisation SIGNAL |
| 2024-11-07 | Ezzeddine Chakroun | - | Gestion cas où update query peut être null |
| 2024-11-06 | Ezzeddine Chakroun | - | Changement schéma call en management, table map en curated |
| 2024-10-31 | Paul B. | [MERP-99] | Variable list_columns_source varchar(255) → longtext |
| 2024-10-17 | Ezzeddine Chakroun | [MERP-99] | Création initiale |

## 📌 Notes et Points d'attention

- **Verrou de synchronisation** : Si vous rencontrez l'erreur "is already synchronising" et que "Server Monitor" montre que la sync n'est pas en cours, mettez manuellement `IsSynchronisingRegularTable = 0` dans `curated.tbl_syncinfo`
- **SP Custom override** : Les SP nommées `SP_Sync_${table_name}_custom` sont validées et blocquent l'exécution, permettant une surcharge personnalisé
- **Tracking temporel** : Les logs dans `tbl_syncinfo_log` incluent les TIMEDIFF pour chaque étape
- **Génération une seule fois** : Théoriquement, cette SP devrait être utilisée une seule fois par table lors de l'initialisation

## 🔗 Références

- Fichier source : [SP_CreateAndExecuteSyncSPFromMap.sql](SP_CreateAndExecuteSyncSPFromMap.sql)
- Tables de configuration : `curated.tbl_map_raw_to_curated`
- Tables de suivi : `curated.tbl_syncinfo`, `curated.tbl_syncinfo_log`
- Répertoire des procédures : [docs/procedure_sql/](docs/procedure_sql/)

---

**Template utilisé :** `stored-procedure.template.md`
