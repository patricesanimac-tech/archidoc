# Analyse du Pipeline Azure Data Factory
## `PL_IntgrID_Account_M3ToD365_Databricks_Inner`

---

## 1. Vue d'ensemble

### 1.1 Nom du pipeline
`PL_IntgrID_Account_M3ToD365_Databricks_Inner`

### 1.2 Objectif
Ce pipeline orchestre la **synchronisation des comptes clients (Account)** depuis le système ERP **Infor M3** vers **Microsoft Dynamics 365 (D365)**. Il supporte deux modes d'exécution :
- **Full Load** : chargement complet de tous les comptes (validation du nombre de fichiers requise)
- **Sync (Delta)** : synchronisation incrémentale des modifications

Le pipeline gère le cycle de vie complet du fichier de données : réception via SFTP → fusion → transformation (Databricks) → archivage ou gestion des erreurs.

---

## 2. Architecture du Pipeline

### 2.1 Flux d'exécution principal

```
[Set varProcessDateTime]
        ↓
[Set varSyncType]
        ↓
[Set varFilePath]
        ↓
[FullLoad Validation]  ←── Si isFullLoad=true : validation du nombre de fichiers + vérification comptes M3 hors plage
        ↓ (Succeeded)
[Merge json files]  ←── Si varError vide : fusion des fichiers JSON du SFTP
        ↓ (Succeeded)
[Set varWarningFileName]
[Set varProcessFilesPath]
[Set varMergedFilesListFileName]
        ↓ (tous Succeeded)
[PL_SFTP_Account_Inner_DF_part1]  ←── Pipeline enfant : Dataflow partie 1 (Databricks)
        ↓ (Succeeded)                       ↓ (Failed)
[PL_SFTP_Account_Inner_DF_part2]    [RunningTaskError_DFAccount]
        ↓ (Succeeded)  ↓ (Failed)           ↓
[LookForWarningFile] [RunningTaskError_DFAccountUpdateBillTo]
        ↓                    ↓
[If WarningFile]    [Copy file to Error folder Update Bill To]
        ↓                    ↓
[Delete WarningFile] [Remove file from Landing folder Update Bill To]
        ↓
[Copy Merged files to Archive]
        ↓
[Delete Merged files list]
        ↓
[Delete Merged files list file - OnSuccess]
        ↓
[Remove file from Landing folder_copy1]
```

---

## 3. Activités à haut niveau

| # | Nom de l'activité | Type | Rôle |
|---|---|---|---|
| 1 | `Set varProcessDateTime` | SetVariable | Initialise l'horodatage du traitement (format EST `yyyyMMddTHHmmss`) |
| 2 | `Set varSyncType` | SetVariable | Détermine le type : `FullLoad` ou `Sync` selon le paramètre `isFullLoad` |
| 3 | `Set varFilePath` | SetVariable | Construit le chemin SFTP source selon l'entité et le type de sync |
| 4 | `FullLoad Validation` | IfCondition | Si Full Load : valide le nombre de fichiers JSON et les comptes hors plage via API Infor |
| 5 | `Merge json files` | IfCondition + Copy | Fusionne tous les fichiers JSON du répertoire SFTP en un seul fichier |
| 6 | `Set varWarningFileName` | SetVariable | Prépare le nom du fichier d'avertissement |
| 7 | `Set varProcessFilesPath` | SetVariable | Prépare le chemin ADLS de traitement |
| 8 | `Set varMergedFilesListFileName` | SetVariable | Prépare le nom du fichier de liste des fichiers fusionnés |
| 9 | `PL_SFTP_Account_Inner_DF_part1` | ExecutePipeline | Lance le pipeline enfant Databricks partie 1 (transformation des comptes) |
| 10 | `PL_SFTP_Account_Inner_DF_part2` | ExecutePipeline | Lance le pipeline enfant Databricks partie 2 (mise à jour BillTo) |
| 11 | `LookForWarningFile` | Lookup | Vérifie l'existence d'un fichier d'avertissement dans ADLS |
| 12 | `If WarningFile` | IfCondition | Si avertissements présents : enregistre l'erreur de type warning dans MariaDB |
| 13 | `Delete WarningFile` | Delete | Supprime le fichier d'avertissement ADLS après traitement |
| 14 | `Copy Merged files to Archive` | Copy | Archive les fichiers fusionnés traités vers le répertoire `Archive/` SFTP |
| 15 | `Delete Merged files list` | Delete | Supprime les fichiers originaux de la landing zone après archivage |
| 16 | `Delete Merged files list file - OnSuccess` | Delete | Supprime le fichier de liste `.txt` après succès |
| 17 | `Remove file from Landing folder_copy1` | Delete | Supprime le fichier fusionné de la landing zone après succès complet |
| 18 | `RunningTaskError_DFAccount` | Lookup (SP) | Enregistre l'erreur MariaDB si la partie 1 échoue |
| 19 | `Copy file to Error folder` | Copy | Copie le fichier fusionné vers le répertoire `Error/` si partie 1 échoue |
| 20 | `Remove file from Landing folder` | Delete | Supprime le fichier de la landing après copie en erreur (partie 1) |
| 21 | `RunningTaskError_DFAccountUpdateBillTo` | Lookup (SP) | Enregistre l'erreur MariaDB si la partie 2 échoue |
| 22 | `Copy file to Error folder Update Bill To` | Copy | Copie le fichier vers `Error/` si partie 2 échoue |
| 23 | `Remove file from Landing folder Update Bill To` | Delete | Supprime le fichier de la landing après copie en erreur (partie 2) |
| 24 | `Delete Merged files list file - OnFail` | Delete | Supprime le fichier de liste `.txt` si partie 2 échoue |
| 25 | `Delete Merged files list file - OnDFAccountFail` | Delete | Supprime le fichier de liste `.txt` si partie 1 échoue |

---

## 4. Variables

| Variable | Type | Description |
|---|---|---|
| `varProcessDateTime` | String | Horodatage du traitement en heure EST (`yyyyMMddTHHmmss`) |
| `varFilePath` | String | Chemin SFTP du répertoire source (ex. `SyncInforToAzure/Account_FullLoad/`) |
| `varProcessFilesPath` | String | Chemin ADLS pour les fichiers de traitement (ex. `ToD365/Landing/Account/`) |
| `varMergeFileName` | String | Nom du fichier JSON fusionné (ex. `AccountMerge_20240315T123456.json`) |
| `varWarningFileName` | String | Nom du fichier d'avertissement (ex. `Account_WarningManualUpdate_....json`) |
| `varMergedFilesListFileName` | String | Nom du fichier `.txt` contenant la liste des fichiers fusionnés |
| `varSyncType` | String | Type de synchronisation : valeur de `FullLoadPath` ou `SyncPath` |
| `varWarningContent` | String | Contenu du fichier d'avertissement (tronqué à 900 chars si > 1000) |
| `varError` | String | Message d'erreur de validation Full Load (vide = pas d'erreur) |
| `varInforAPIBaseURL` | String | URL de base de l'API Infor M3 (récupérée depuis D365) |
| `varFullLoadFilePath` | String | Variable déclarée mais non utilisée dans ce pipeline |

---

## 5. Paramètres

| Paramètre | Type | Valeur par défaut | Description |
|---|---|---|---|
| `sftpPath` | string | `SyncInforToAzure/` | Chemin racine SFTP |
| `ProcessedPath` | string | `Archive/` | Sous-répertoire d'archivage SFTP |
| `ErrorPath` | string | `Error/` | Sous-répertoire d'erreur SFTP |
| `adlsContainerName` | string | `integration` | Conteneur Azure Data Lake Storage |
| `adlsProcessFilesPath` | string | `ToD365/Landing/` | Chemin ADLS pour les fichiers de traitement |
| `EntityName` | string | `Account` | Nom de l'entité traitée |
| `FullLoadPath` | string | `FullLoad` | Nom du sous-répertoire Full Load |
| `SyncPath` | string | `Sync` | Nom du sous-répertoire Sync |
| `FullLoadNbrFilesRequired` | int | `19` | Nombre exact de fichiers JSON requis pour valider un Full Load |
| `RunningTask_LogID` | string | `0` | ID de log pour le suivi dans MariaDB |
| `RunningTask_TaskName` | string | `PL_SFTP_Account` | Nom de la tâche pour la journalisation MariaDB |
| `AccountsNotSyncMinRangeNbr` | string | `690000` | Borne inférieure de la plage de comptes à surveiller dans M3 |
| `AccountsNotSyncMaxRangeNbr` | string | `699999` | Borne supérieure de la plage de comptes à surveiller dans M3 |
| `isFullLoad` | bool | `false` | Active le mode Full Load (vs Sync incrémental) |
| `ForceRenewInforApiBearerToken` | bool | `false` | Force le renouvellement du Bearer Token Infor API |

---

## 6. Flux de données

### Sources et destinations

| Système | Rôle | Technologie |
|---|---|---|
| **SFTP** | Source des fichiers JSON M3 | SFTP (SftpReadSettings / SftpWriteSettings) |
| **Azure Data Lake Storage (ADLS)** | Stockage intermédiaire de traitement | AzureBlobFSReadSettings |
| **Azure Key Vault (AKV)** | Stockage sécurisé du Bearer Token Infor | MSI Auth via WebActivity |
| **Dynamics 365 (D365)** | Source du paramètre `InforAPIBaseURL` + destination finale | DynamicsSource |
| **Infor M3 API** | Validation des comptes hors plage | API REST (WebActivity) |
| **MariaDB** | Journalisation des erreurs et avertissements | SP `SP_RunningTaskErrorSynapse` |
| **Databricks (via pipelines enfants)** | Transformation et chargement des données | ExecutePipeline |

### Champs mappés (fichier JSON Account)

Le fichier JSON transporte **32 champs** d'un compte client :

`Action`, `AccountNumber`, `CustomerName`, `M3Status`, `BillTo`, `Street1`, `Street2`, `City`, `State`, `PostalCode`, `Country`, `Phone`, `Extension`, `Fax`, `PrimaryMarket`, `SecondaryMarket`, `PurchasingGroup`, `AdditionalPurchasingGroup`, `NationalGroup`, `Manager`, `Language`, `Kosher`, `StoreNumber`, `TaxExemption`, `TPS`, `TVP`, `CreditLimit`, `OutstandingAmount`, `HardBlock`, `PaymentTerm`, `Warehouse`, `DivCompAramark` + `FileName` (ajouté automatiquement)

### Chemins SFTP

| Chemin | Usage |
|---|---|
| `SyncInforToAzure/Account_FullLoad/` | Fichiers source Full Load |
| `SyncInforToAzure/Account_Sync/` | Fichiers source Sync |
| `SyncInforToAzure/Archive/Account_FullLoad/YYYYMM/MergedFiles_<datetime>/` | Archivage après succès |
| `SyncInforToAzure/Error/Account/YYYYMM/` | Fichiers en erreur |
