# ${PROCEDURE_NAME}

## 📌 Informations Générales

| Propriété | Valeur |
|-----------|--------|
| **Schéma** | `${SCHEMA_NAME}` |
| **Nom** | `${PROCEDURE_NAME}` |
| **Type** | Procédure Stockée |
| **Créée par** | ${AUTHOR} |
| **Date création** | ${CREATION_DATE} |
| **Dernière modification** | ${LAST_MODIFIED_DATE} |
| **Statut** | ${STATUS} (Actif/Inactif/Obsolète) |

## 🔍 Description

${DESCRIPTION}

**Cas d'utilisation :**
- ${USE_CASE_1}
- ${USE_CASE_2}
- ${USE_CASE_N}

## 📥 Paramètres

### Paramètres d'entrée

| Paramètre | Type | Description | Obligatoire | Valeur par défaut |
|-----------|------|-------------|-------------|-------------------|
| `${PARAM_1_NAME}` | `${PARAM_1_TYPE}` | ${PARAM_1_DESC} | Oui/Non | ${PARAM_1_DEFAULT} |
| `${PARAM_2_NAME}` | `${PARAM_2_TYPE}` | ${PARAM_2_DESC} | Oui/Non | ${PARAM_2_DEFAULT} |
| `${PARAM_N_NAME}` | `${PARAM_N_TYPE}` | ${PARAM_N_DESC} | Oui/Non | ${PARAM_N_DEFAULT} |

### Paramètres de sortie

| Paramètre | Type | Description |
|-----------|------|-------------|
| `${OUT_PARAM_1_NAME}` | `${OUT_PARAM_1_TYPE}` | ${OUT_PARAM_1_DESC} |
| `${OUT_PARAM_N_NAME}` | `${OUT_PARAM_N_TYPE}` | ${OUT_PARAM_N_DESC} |

## 📊 Données Manipulées

### Tables d'entrée

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| `${INPUT_TABLE_1}` | `${SCHEMA_1}` | Source | ${INPUT_DESC_1} |
| `${INPUT_TABLE_N}` | `${SCHEMA_N}` | Source | ${INPUT_DESC_N} |

### Tables de sortie

| Table | Schéma | Type | Description |
|-------|--------|------|-------------|
| `${OUTPUT_TABLE_1}` | `${SCHEMA_1}` | Destination | ${OUTPUT_DESC_1} |
| `${OUTPUT_TABLE_N}` | `${SCHEMA_N}` | Destination | ${OUTPUT_DESC_N} |

### Tables de référence

| Table | Schéma | Usage |
|-------|--------|-------|
| `${REF_TABLE_1}` | `${SCHEMA}` | ${REF_DESC_1} |
| `${REF_TABLE_N}` | `${SCHEMA}` | ${REF_DESC_N} |

## ⚙️ Logique et Flux

### Étapes principales

1. **${STEP_1_TITLE}**
   - Validation : ${VALIDATION_1}
   - Actions : ${ACTION_1}
   - Gestion erreurs : ${ERROR_HANDLING_1}

2. **${STEP_2_TITLE}**
   - Validation : ${VALIDATION_2}
   - Actions : ${ACTION_2}
   - Gestion erreurs : ${ERROR_HANDLING_2}

3. **${STEP_N_TITLE}**
   - Validation : ${VALIDATION_N}
   - Actions : ${ACTION_N}
   - Gestion erreurs : ${ERROR_HANDLING_N}

### Diagramme du flux (optionnel)

```
${FLOW_DIAGRAM}
```

## ⚠️ Contraintes et Limitations

- ${CONSTRAINT_1}
- ${CONSTRAINT_2}
- ${LIMITATION_1}
- ${LIMITATION_2}

## 🔒 Conditions préalables

- ${PRECONDITION_1}
- ${PRECONDITION_2}
- ${PRECONDITION_N}

## 🚨 Gestion des erreurs

| Code d'erreur | Condition | Message | Action corrective |
|---------------|-----------|---------|-------------------|
| `${ERROR_CODE_1}` | ${ERROR_CONDITION_1} | ${ERROR_MESSAGE_1} | ${CORRECTION_1} |
| `${ERROR_CODE_N}` | ${ERROR_CONDITION_N} | ${ERROR_MESSAGE_N} | ${CORRECTION_N} |

## 📝 Exemple d'utilisation

```sql
-- Appel simple
CALL ${PROCEDURE_NAME}(${EXAMPLE_PARAM_1}, ${EXAMPLE_PARAM_2}, @output_var);

-- Récupération du résultat
SELECT @output_var AS result;
```

## 📊 Performance

| Aspect | Valeur | Notes |
|--------|--------|-------|
| Temps d'exécution moyen | ${AVG_EXEC_TIME} | Basé sur ${RECORD_COUNT} enregistrements |
| Indexation requise | ${INDEXES_REQUIRED} | Sur colonnes : ${INDEX_COLUMNS} |
| Ressources | ${RESOURCE_REQUIREMENTS} | CPU/Mémoire |

## 🔄 Dépendances

### Procédures appelées

- `${CALLED_PROCEDURE_1}` ({$CALLED_SCHEMA_1}.${CALLED_PROCEDURE_1})
- `${CALLED_PROCEDURE_N}` (${CALLED_SCHEMA_N}.${CALLED_PROCEDURE_N})

### Procédures qui l'appellent

- `${CALLING_PROCEDURE_1}` (${CALLING_SCHEMA_1})
- `${CALLING_PROCEDURE_N}` (${CALLING_SCHEMA_N})

### Tâches planifiées

- `${SCHEDULED_JOB_1}` - Exécution : ${SCHEDULE_1}
- `${SCHEDULED_JOB_N}` - Exécution : ${SCHEDULE_N}

## 📋 Historique des modifications

| Date | Auteur | Référence | Modification |
|------|--------|-----------|--------------|
| ${MOD_DATE_1} | ${MOD_AUTHOR_1} | ${MOD_REF_1} | ${MOD_DESC_1} |
| ${MOD_DATE_2} | ${MOD_AUTHOR_2} | ${MOD_REF_2} | ${MOD_DESC_2} |
| ${MOD_DATE_N} | ${MOD_AUTHOR_N} | ${MOD_REF_N} | ${MOD_DESC_N} |

## 📌 Notes et Points d'attention

- ${NOTE_1}
- ${NOTE_2}
- ${IMPORTANT_1}

## 🔗 Références

- Ticket : [${TICKET_ID}](${TICKET_URL})
- Documentation related : [${RELATED_DOC_1}](${RELATED_DOC_URL_1})
- Confluence : [${CONFLUENCE_LINK}](${CONFLUENCE_URL})

---

**Template utilisé :** `stored-procedure.template.md`
