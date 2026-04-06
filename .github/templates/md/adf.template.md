---
name: Azure Data Factory Pipeline Analysis Template
description: Template Markdown pour documenter l’analyse d’un pipeline Azure Data Factory ou un pipeline de données similaire.
format: markdown
variables:
  - name: PIPELINE_NAME
    description: Nom du pipeline ADF ou Data Integration analysé.
    required: true
  - name: PIPELINE_PURPOSE
    description: Objectif principal et portée du pipeline, en une à deux phrases claires.
    required: true
  - name: EXECUTION_CONTEXT
    description: Contexte d’exécution ou modes supportés par le pipeline (par ex. Full Load, Sync/Delta, validation, archivage).
    required: false
  - name: LIFECYCLE_DESCRIPTION
    description: Description synthétique du cycle de vie des données traitées par le pipeline.
    required: false
  - name: MAIN_FLOW
    description: Description du flux d’exécution principal sous forme de diagramme Mermaid.
    required: true
  - name: ACTIVITY_TABLE
    description: Tableau Markdown listant les activités du pipeline avec les colonnes #, Nom de l’activité, Type et Rôle.
    required: true
  - name: VARIABLE_TABLE
    description: Tableau Markdown listant les variables du pipeline avec les colonnes Variable, Type et Description.
    required: true
  - name: PARAMETER_TABLE
    description: Tableau Markdown listant les paramètres du pipeline avec les colonnes Paramètre, Type, Valeur par défaut et Description.
    required: true
  - name: DATA_FLOW_TABLE
    description: Tableau Markdown des sources, destinations et technologies utilisées par le flux de données.
    required: false
  - name: MAPPED_FIELDS
    description: Description ou liste des champs mappés dans les fichiers ou objets de données traités.
    required: false
  - name: PATH_TABLE
    description: Tableau Markdown des chemins critiques utilisés par le pipeline (SFTP, ADLS, archive, erreur, etc.).
    required: false
  - name: NOTES
    description: Informations additionnelles, points d’attention ou remarques générales.
    required: false
---

# Analyse du Pipeline Azure Data Factory

## 1. Vue d’ensemble

### 1.1 Nom du pipeline

` ${PIPELINE_NAME} `

### 1.2 Objectif

${PIPELINE_PURPOSE}

### 1.3 Contexte d’exécution

${EXECUTION_CONTEXT}

### 1.4 Cycle de vie des données

${LIFECYCLE_DESCRIPTION}

---

## 2. Architecture du pipeline

### 2.1 Flux d’exécution principal

```mermaid
${MAIN_FLOW}
```

---

## 3. Activités à haut niveau

${ACTIVITY_TABLE}

---

## 4. Variables

${VARIABLE_TABLE}

---

## 5. Paramètres

${PARAMETER_TABLE}

---

## 6. Flux de données

${DATA_FLOW_TABLE}

---

## 7. Champs mappés

${MAPPED_FIELDS}

---

## 8. Chemins et emplacements

${PATH_TABLE}

---

## 9. Notes complémentaires

${NOTES}

---

## Structure du template

- `PIPELINE_NAME`: Nom du pipeline analysé.
- `PIPELINE_PURPOSE`: Objectif du pipeline et portée du traitement.
- `EXECUTION_CONTEXT`: Modes d’exécution et conditions particulières.
- `LIFECYCLE_DESCRIPTION`: Description du cycle de vie des données.
- `MAIN_FLOW`: Représentation textuelle du flux principal.
- `ACTIVITY_TABLE`: Tableau listant les activités, types et rôles.
- `VARIABLE_TABLE`: Tableau listant les variables utilisées.
- `PARAMETER_TABLE`: Tableau listant les paramètres du pipeline.
- `DATA_FLOW_TABLE`: Tableau des sources/destinations/technologies.
- `MAPPED_FIELDS`: Champs mappés du schéma ou du fichier de données.
- `PATH_TABLE`: Chemins de stockage et de traitement critiques.
- `NOTES`: Remarques additionnelles ou points d’attention.

## Exemple d’utilisation

```markdown
---
name: Azure Data Factory Pipeline Analysis Template
description: Exemple d’utilisation du template ADF avec variables remplies.
format: markdown
variables:
  - name: PIPELINE_NAME
    description: Nom du pipeline ADF ou Data Integration analysé.
    required: true
  - name: PIPELINE_PURPOSE
    description: Objectif principal et portée du pipeline.
    required: true
  - name: MAIN_FLOW
    description: Flux principal du pipeline.
    required: true
  - name: ACTIVITY_TABLE
    description: Tableau des activités du pipeline.
    required: true
  - name: VARIABLE_TABLE
    description: Tableau des variables du pipeline.
    required: true
  - name: PARAMETER_TABLE
    description: Tableau des paramètres du pipeline.
    required: true
---

# Analyse du Pipeline Azure Data Factory

## 1. Vue d’ensemble

### 1.1 Nom du pipeline

`PL_IntgrID_Account_M3ToD365_Databricks_Inner`

### 1.2 Objectif

Ce pipeline orchestre la synchronisation des comptes clients depuis Infor M3 vers Dynamics 365.

### 1.3 Contexte d’exécution

Full Load / Sync (Delta) avec gestion des erreurs et archivage.

### 1.4 Cycle de vie des données

Réception via SFTP → fusion des fichiers JSON → transformation Databricks → archivage ou erreur.

---

## 2. Architecture du pipeline

### 2.1 Flux d’exécution principal

```
[Set varProcessDateTime]
        ↓
[Set varSyncType]
        ↓
[Set varFilePath]
        ↓
[FullLoad Validation]
        ↓
[Merge json files]
        ↓
[PL_SFTP_Account_Inner_DF_part1]
        ↓
[PL_SFTP_Account_Inner_DF_part2]
        ↓
... etc.
```

---

## 3. Activités à haut niveau

| # | Nom de l’activité | Type | Rôle |
|---|---|---|---|
| 1 | Set varProcessDateTime | SetVariable | Initialise l’horodatage |

---

## 4. Variables

| Variable | Type | Description |
|---|---|---|
| varProcessDateTime | String | Horodatage du traitement |

---

## 5. Paramètres

| Paramètre | Type | Valeur par défaut | Description |
|---|---|---|---|
| sftpPath | string | SyncInforToAzure/ | Chemin racine SFTP |
```
