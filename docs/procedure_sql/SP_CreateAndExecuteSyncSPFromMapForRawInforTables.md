# SP_CreateAndExecuteSyncSPFromMapForRawInforTables

## 📌 Informations Générales

| Propriété | Valeur |
|-----------|--------|
| **Schéma** | `curated` |
| **Nom** | `SP_CreateAndExecuteSyncSPFromMapForRawInforTables` |
| **Type** | Procédure Stockée (Générateur de code) |
| **Créée par** | Ezzeddine Chakroun [MERP-99] |
| **Date création** | 2025-11-04 |
| **Dernière modification** | 2026-04-07 |
| **Statut** | Actif |

## 🔍 Description

Génère dynamiquement le code de procédure stockée SQL pour la synchronisation de données entre le schéma source `infor_raw` et le schéma de destination `curated` pour une table spécifique.

Cette procédure est un **générateur de procédure** : elle crée une autre procédure stockée (`SP_Sync_[table_name]`) et l'exécute immédiatement. Elle utilise le mapping défini dans la table `curated.tbl_map_raw_to_curated` pour construire les requêtes appropriées.

**Cas d'utilisation :**
- Initialiser la synchronisation pour une nouvelle table curated
- Générer automatiquement les procédures de sync basées sur le mapping métier
- Maintenir les tables curated à jour avec les données provenant de `infor_raw`

## 📥 Paramètres

### Paramètres d'entrée

| Paramètre | Type | Description | Obligatoire | Valeur par défaut |
|-----------|------|-------------|-------------|-------------------|
| `table_name` | `VARCHAR(100)` | Nom de la table curated à synchroniser (telle que définie dans `tbl_map_raw_to_curated.curated_table`) | Oui | - |

### Paramètres de sortie

| Paramètre | Type | Description |
|-----------|------|-------------|
| `@output_sp` | `TEXT` | Code SQL de la procédure générée (variable locale, non retournée en sortie) |

## 📊 Données Manipulées

### Tables d'entrée

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| `tbl_map_raw_to_curated` | `curated` | Mapping | Définit le mapping entre colonnes source et destination, expressions, jointures |
| `TABLES` | `information_schema` | Système | Récupère les informations de structure des tables |
| `COLUMNS` | `information_schema` | Système | Extrait les colonnes, clés primaires, types de données |
| `KEY_COLUMN_USAGE` | `information_schema` | Système | Identifie les clés primaires de la table source |
| Table source `infor_raw.*` | `infor_raw` | Données | Table dynamique référencée par le paramètre `table_name` |

### Tables de sortie

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| Table curated | `curated` | Destination | Table de destination recevant les données synchronisées |
| `tbl_syncinfo` | `curated` | Suivi | Enregistrement du statut et de la progression de la synchronisation |

### Tables de référence

| Table | Schéma | Usage |
|-------|--------|-------|
| `tbl_syncinfo_log` | `curated` | Historique des synchronisations passées |
| `tbl_param` | `management` | Récupère la société infor (`infor_company`) |

## ⚙️ Logique et Flux

### Étapes principales

1. **Initialisation et validations**
   - Validation : Vérifier que la base de données active est `curated`
   - Validation : S'assurer qu'il n'existe pas de procédure de synchronisation personnalisée pour la table
   - Actions : Créer ou initialiser la table `tbl_syncinfo` pour le suivi
   - Gestion erreurs : Lever une erreur SIGNAL si la sync est déjà en cours

2. **Évaluation du mapping**
   - Validation : Récupérer le schéma source et le nom de la table source depuis le mapping
   - Actions : Extraire les colonnes source, les colonnes destination, les conditions de filtrage
   - Actions : Identifier automatiquement les colonnes de version (`variationNumber`) et suppression (`deleted`)
   - Gestion erreurs : S'assurer qu'une clé primaire est définie dans la table source

3. **Génération de la procédure SP_Sync_[table_name]**
   - Actions : Construire les clauses SELECT avec jointures (si `query_str` est défini)
   - Actions : Créer les tables de baseline pour Delta processing
   - Actions : Générer INSERT IGNORE, UPDATE, DELETE dynamiquement en fonction du mapping
   - Gestion erreurs : Inclure des blocs TRY-CATCH via curseurs pour valider l'exécution

4. **Création des tables temporaires**
   - Actions : Créer une table `[source]_baseline` pour tracker les dernières versions
   - Actions : Construire une table temporaire `tbltmp_max_vn_by_id_[source]` pour les max versions

5. **Exécution et suivi**
   - Actions : Exécuter la procédure générée immédiatement via PREPARE/EXECUTE
   - Actions : Mettre à jour `tbl_syncinfo` avec les points d'étape et durées d'exécution
   - Actions : Enregistrer les logs dans `tbl_syncinfo_log`

6. **Nettoyage**
   - Actions : Supprimer les tables temporaires créées
   - Actions : Finaliser et mettre à jour le statut dans `tbl_syncinfo`

## ⚠️ Contraintes et Limitations

- Le schéma source doit être `infor_raw` (validation explicite)
- Le schéma de destination supporté est actuellement `curated` uniquement
- Chaque colonne utilisée dans la colonne `expression` doit être présente dans `source_column` (séparées par virgules)
- La colonne `expression` supporte un maximum de 4 colonnes sources/destinations au total
- Une clé primaire doit être identifiée dans `tbl_map_raw_to_curated`
- La procédure crée une autre procédure (méta-programmation SQL) qui doit être gérée avec prudence

## 🔒 Conditions préalables

- La table curated doit être enregistrée dans `curated.tbl_map_raw_to_curated` avec un mapping complet
- La table source `infor_raw.[table_name]` doit exister et contenir les colonnes définies dans le mapping
- Les colonnes `variationNumber` et `deleted` doivent exister dans la table source
- La base de données `curated` doit être active lors de l'appel
- L'utilisateur doit avoir les permissions CREATE PROCEDURE, ALTER TABLE sur `curated`
- L'une synchronisation antérieure ne doit pas être en cours (`tbl_syncinfo.IsSynchronisingRegularTable = 0`)

## 🚨 Gestion des erreurs

| Code d'erreur | Condition | Message | Action corrective |
|---------------|-----------|---------|-------------------|
| `45000 (errno 10000)` | Base de données incorrecte | `ERROR: wrong database` | S'assurer que `USE curated;` a été exécuté avant l'appel |
| `45000 (errno 10000)` | Procédure personnalisée existe | `ERROR: there is a custom SP` | Vérifier/supprimer la procédure `SP_Sync_[table_name]_custom` existante |
| `45000 (errno 10000)` | Sync déjà en cours | `ERROR: [ProcessName] is already synchronising` | Vérifier `tbl_syncinfo` et réinitialiser `IsSynchronisingRegularTable = 0` manuellement si nécessaire |
| `45000 (errno 10000)` | Schéma source invalide | `ERROR: The schema of the source table [schema] is not infor_raw` | Mettre à jour le mapping dans `tbl_map_raw_to_curated` avec le bon schéma source |

## 📝 Exemple d'utilisation

```sql
-- Appel pour synchroniser la table 'Account'
USE curated;
CALL SP_CreateAndExecuteSyncSPFromMapForRawInforTables('Account');

-- Vérifier le statut et les timings
SELECT ProcessName, SyncStart, SyncEnd, NextStep, SyncInfo
FROM curated.tbl_syncinfo
WHERE ProcessName = 'SP_CreateAndExecuteSyncSPFromMapForRawInforTables - Account'
ORDER BY SyncEnd DESC LIMIT 1;

-- Consulter l'historique complet
SELECT * FROM curated.tbl_syncinfo_log
WHERE ProcessName = 'SP_Sync_Account'
ORDER BY SyncEnd DESC LIMIT 10;
```

## 📊 Performance

| Aspect | Valeur | Notes |
|--------|--------|-------|
| Temps d'exécution moyen | Variable (5 min à plusieurs heures) | Dépend de la taille de la table source et de la complexité du mapping |
| Indexation requise | Index sur colonnes PK | Les colonnes de clé primaire de la table source doivent être indexées |
| Ressources | CPU/Mémoire important | Crée plusieurs tables temporaires; monitorer l'espace disque |

## 🔄 Dépendances

### Procédures appelées

- `management.SP_Qry_GenSyncDelInsUpdQueriesForTable_OUT` (schéma `management`) - Génère les requêtes DELETE, INSERT, UPDATE pour la sync
- `management.SP_Utils_ExecMultipleStmt` (potentiellement, selon le mapping) - Exécute plusieurs instructions SQL

### Procédures qui l'appellent

- Orchestrateurs de synchronisation (non détaillés dans ce fichier)
- Pipelines ADF ou outils d'ETL externes

### Tâches planifiées

Aucune identifiée dans ce fichier (à déterminer via `information_schema.EVENTS`)

## 📋 Historique des modifications

| Date | Auteur | Référence | Modification |
|------|--------|-----------|--------------|
| 2025-11-04 | Ezzeddine Chakroun | [MERP-99] | Création initiale |
| 2025-01-28 | Vadim Simanovsky | [MERP-99] / US 521 | Ajout de commentaires à la SP de sync curated |
| 2026-03-27 | Pierre-Yves Calpetard (Emyode) | US 597 | Suppression de la création d'index |
| 2026-04-07 | Pierre-Yves Calpetard (Emyode) | US 597 | Ajout des clés primaires depuis `information_schema.KEY_COLUMN_USAGE` |

## 📌 Notes et Points d'attention

- **Méta-programmation SQL** : Cette procédure génère et exécute du code SQL dynamique. Assurez-vous de valider le SQL généré avant la production.
- **Delta processing** : La procédure utilise un système de baseline et de variations pour détecter les changements et optimiser la performance.
- **Gestion de la suppression logique** : Les enregistrements marqués avec `deleted = 1` sont filtrés lors de la synchronisation.
- **Enregistrement du suivi** : Chaque étape de la synchronisation est loggée dans `tbl_syncinfo` avec les durées d'exécution.
- **Limitation du schéma** : Actuellement, seul `infor_raw` est supporté comme schéma source. Un refactoring future devrait généraliser ce support.
- **Clés primaires composites** : La procédure supporte les clés primaires composites, en utilisant `GROUP_CONCAT` pour les énumérer.
- **Expressions complexes** : Les expressions SQL dans le mapping doivent être écrites avec soin, en utilisant les alias corrects (`tbloriginal`, `tblcu`).
- **Suppression de la procédure antérieure** : Aucun mécanisme de DROP n'est inclus; les anciennes procédures générées restent en place.

## 🔗 Références

- Ticket : [MERP-99](https://example.com/MERP-99) (à adapter selon le système de tickets)
- Documentation related : Mapping `curated.tbl_map_raw_to_curated`
- Confluence : [Synchronisation de données Infor → Curated](https://example.com/confluence) (à adapter)

---

**Template utilisé :** `stored-procedure.template.md`
