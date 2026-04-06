---
name: Template Creation Guide
description: Guide pour la création et l'utilisation des templates pour les formats de sortie
applyTo: "DISABLE**/*.template.adoc,**/*.template.puml,**/*.template.md,**/*.template.csv,**/*.template.bpmn,**/*.template.feature"
---

# Guide pour la Création des Templates

## Généricité des Templates

**Important** : Lors de la création d’un template à partir d’un exemple, il est impératif de s’assurer que le template demeure générique et réutilisable. Pour cela :

- Remplacer tous les éléments spécifiques (actions, titres, conditions, références métier, etc.) par des variables explicites (`${VARIABLE}`)

- Ne pas inclure de contenu métier ou technique propre à l’exemple dans le template

- Documenter chaque variable pour guider l’utilisateur sur ce qu’il doit fournir

- Limiter la structure à l’essentiel et éviter la logique métier complexe ou trop spécifique

- Fournir un exemple d’utilisation générique, sans contenu métier, pour illustrer le remplissage du template

- Prévoir des variables optionnelles ou des blocs réutilisables pour permettre l’adaptation à différents cas

- Vérifier que le template peut être utilisé dans plusieurs contextes sans modification majeure

- Inclure uniquement les variables réellement utilisées dans le template

 

Ces recommandations garantissent la réutilisabilité et la flexibilité des templates pour tous les formats de sortie.

 

## Emplacement des Templates

 

**Important**: Tous les templates doivent être créés dans le répertoire `.github/templates/` du projet.

 

Structure organisationnelle recommandée :

 

```

.github/templates/

├── md/      # Templates Markdown (.template.md)

├── adoc/    # Templates AsciiDoc (.template.adoc)

├── puml/    # Templates PlantUML (.template.puml)

└── README.md  # Documentation des templates disponibles

```

 

## Convention de nommage

 

Le nom du template doit suivre la structure du document cible :

  - Utiliser le préfixe numérique et descriptif du document analysé (ex : `nn.nn.mon_template.template.adoc`)

  - Séparer les parties numérique par points et descriptif par des underscores pour refléter la hiérarchie et la lisibilité

  - Terminer par `.template.adoc`, `.template.md` ou `.template.puml` selon le format

Exemple : `03.00.current_solution.template.adoc` pour un template basé sur le document `03.00.current-solution.adoc`.

 

## Note de bas de page pour les documents générés

 

Lors de la génération d'un document à partir d'un template `.adoc` (c'est-à-dire dans les fichiers générés, et non dans le template lui-même), ajouter systématiquement la note de bas de page suivante en fin de document :

```

[NOTE]

Ce document est basé sur le template : `nn.nom-descriptif.template.adoc`.

```

## Principes Fondamentaux

 

1. **Réutilisabilité**

   - Un template doit être réutilisable dans plusieurs contextes

   - `${DOC_TYPE}`: Type de document

   - `${SECTION}`: Section spécifique

   - `${REFERENCE}`: Références externes

   - `${ATTACHMENT}`: Pièces jointes

 

6. **Variables AsciiDoc Spécifiques**

   - `${EMAIL}`: Email de l'auteur (pour format auteur complet)

   - `${DESCRIPTION}`: Description détaillée du document

   - `${KEYWORDS}`: Mots-clés séparés par des virgules

   - `${ABSTRACT}`: Résumé du document

   - `${DRAWIO_*}`: Variables pour les diagrammes Draw.io

   - `${TAB*_*}`: Variables pour les onglets Confluence

   - `${EXPAND_*}`: Variables pour les sections extensibles

   - `${SPACE_KEY}`: Identifiant de l'espace Confluence

   - `${TABLE_*}`: Variables pour les tables structurées

 

7. **Variables PlantUML Spécifiques**

   - `${DIAGRAM_NAME}`: Nom du diagramme

   - `${DIAGRAM_TITLE}`: Titre du diagramme

   - `${DOMAIN*_*}`: Variables pour les domaines fonctionnels

   - `${SERVICE*_*}`: Variables pour les services participants

   - `${AWS_SERVICE_TYPE}`: Type de service AWS

   - `${UC_REFERENCES}`: Références aux cas d'utilisation

   - `${REQ_REFERENCES}`: Références aux exigences

   - `${BUSINESS_REFERENCES}`: Références métier colorées

   - `${ERROR_CODE}`: Codes d'erreur pour la gestion d'exceptionsléments personnalisables

   - Maintenir une structure cohérente

 

2. **Séparation des Préoccupations**

   - Séparer le format de sortie du prompt principal

   - Permettre la maintenance indépendante des templates

   - Faciliter la réutilisation entre différents prompts

 

4. **Flexibilité**

   - Utiliser des variables pour les éléments dynamiques

   - Prévoir des sections optionnelles

   - Permettre l'adaptation selon le contexte

   - Adapter le format selon le type de sortie

 

## Documentation des variables dans les templates

 

**Important** : Chaque variable du template doit être documentée de façon détaillée pour guider l'utilisateur lors du remplissage.

 

**Règle de présentation** : Ne pas utiliser le caractère U+202F (espace fine insécable) dans la documentation des variables ou des exemples. Préférer une formulation simple et neutre, par exemple : Exemple: "Business Requirements".

 

### Recommandations pour la description des variables

 

- Préciser le rôle, le style attendu et donner un exemple de valeur pour chaque variable.

- Indiquer le format attendu (paragraphe, tableau, liste à puces, liste numérotée, etc.).

- Mentionner la granularité (ex : maximum 80 caractères par ligne pour le texte, structure AsciiDoc pour les tableaux).

- Pour les variables de type tableau, indiquer la syntaxe AsciiDoc recommandée (`[cols=...] |=== ... |===`).

- Pour les listes structurées, recommander l'utilisation de titres hiérarchiques (`===`, `====`, `=====`) et de listes à puces ou numérotées.

- Pour les variables de diagramme, préciser l’usage des macros et des paramètres (ex : Draw.io, PlantUML).

- Donner un exemple de description enrichie :

 

```yaml

variables:

  - name: SECTION_TITLE

    description: >

      Titre principal du document (niveau 1). Doit résumer la solution détaillée (ex : "Detailed Target Solution"). Utilisé pour l’en-tête AsciiDoc.

    required: true

  - name: DRAWIO_PATH

    description: >

      Chemin relatif vers le fichier Draw.io à référencer. Sert à la fois pour le lien et la macro d’inclusion. Exemple : "03.02.detailed-target-solution/AS004-cardAccountPayment-target-detailed.drawio"

    required: true

  - name: DESCRIPTION_GENERALE

    description: >

      Paragraphe(s) décrivant la solution détaillée, son contexte, ses objectifs et ses enjeux. Peut inclure des éléments métier, techniques, et des contraintes. Utiliser des phrases courtes et claires, maximum 80 caractères par ligne.

    required: true

  - name: CONTEXTE_AFFAIRES

    description: >

      Tableau AsciiDoc présentant les attributs métier (domaine, capacité, etc.). Utiliser le style `[cols=...] |=== ... |===` pour la structure. Exemple : Domaine, Capacité d’Affaires, etc.

    required: true

```

 

- Adapter la description des variables selon la complexité et la structure du document source analysé.

- Pour les templates issus de documents riches (plus de 1 000 mots, 10+ sections), enrichir la documentation des variables pour refléter la diversité des styles et des points abordés.

 

### Template Markdown (.md)

```markdown

---

name: [Nom du template]

description: [Description du format de sortie]

format: markdown

variables:

  - name: [variable1]

    description: [Description de la variable]

    required: [true/false]

  - name: [variable2]

    description: [Description de la variable]

    required: [true/false]

---

 

# Template: [Nom du Template]

 

## Structure

 

\`\`\`

[Structure du format de sortie avec variables]

\`\`\`

 

## Variables

 

- `${variable1}`: [Description et utilisation]

- `${variable2}`: [Description et utilisation]

 

## Exemple

 

\`\`\`

[Exemple concret du template avec des valeurs]

\`\`\`

```

 

### Template AsciiDoc (.adoc)

 

**Important**: Les templates AsciiDoc doivent suivre les standards définis dans `adoc.instructions.md`.

 

```asciidoc

---

name: [Nom du template]

description: [Description du format de sortie]

format: markdown

variables:

  - name: [variable1]

    description: [Description de la variable]

    required: [true/false]

  - name: [variable2]

    description: [Description de la variable]

    required: [true/false]

---

 

= Template: ${TEMPLATE_NAME}

:author: ${AUTHOR}

:email: ${EMAIL}

:revnumber: ${VERSION}

:description: ${DESCRIPTION}

:keywords: ${KEYWORDS}

:doctype: book

:imagesdir: images

:source-highlighter: highlight.js

:experimental:

:figure-caption: Figure

:table-caption: Tableau

:project-name: ${PROJECT_NAME}

 

// Configuration spécifique au template

:icons: font

:toc:

:toclevels: 3

 

[abstract]

${ABSTRACT}

 

== ${SECTION1_TITLE}

 

=== ${SUBSECTION1_TITLE}

 

==== ${SUBSUBSECTION1_TITLE}

 

[source,${SOURCE_LANGUAGE}]

----

${SOURCE_CODE}

----

 

== ${SECTION2_TITLE}

 

=== Diagrammes PlantUML

 

[[${DIAGRAM_ID}]]

.${DIAGRAM_TITLE}

[plantuml,target=${DIAGRAM_TARGET},format=png]

----

@startuml

${PLANTUML_CONTENT}

@enduml

----

 

La figure <<${DIAGRAM_ID}>> illustre ${DIAGRAM_DESCRIPTION}.

 

=== Diagrammes Draw.io (si applicable)

 

[NOTE]

====

.References

- link:${DRAWIO_PATH}[${DRAWIO_NAME} (drawio)]

- link:${DRAWIO_IMAGE_PATH}[${DRAWIO_NAME} (PNG)]

====

 

confluence-macro::drawio[diagramName="${DRAWIO_FILENAME}", pageIndex="${DRAWIO_PAGE_INDEX}", width="${DRAWIO_WIDTH}", height="${DRAWIO_HEIGHT}"]

 

=== Tables et Données

 

.${TABLE_TITLE}

[cols="${TABLE_COLS}"]

|===

${TABLE_HEADERS}

 

${TABLE_CONTENT}

|===

 

== ${SECTION3_TITLE}

 

[IMPORTANT]

.${IMPORTANT_TITLE}

====

${IMPORTANT_CONTENT}

====

 

[WARNING]

.${WARNING_TITLE}

====

${WARNING_CONTENT}

====

 

== Sections Extensibles (pour Confluence)

 

.${EXPAND_TITLE}

[confluence-macro, ui-expand]

confluence-macro:include[pageTitle="${INCLUDE_PAGE_TITLE}"]

 

== Onglets (pour Confluence)

 

[confluence-macro, ui-tabs]

 

[confluence-macro, ui-tab, title="${TAB1_TITLE}"]

confluence-macro:include[pageTitle="${TAB1_PAGE_TITLE}"]

 

[confluence-macro, ui-tab, title="${TAB2_TITLE}"]

confluence-macro:include[pageTitle="${TAB2_PAGE_TITLE}"]

 

```

 

### Template PlantUML (.puml)

 

**Important**: Les templates PlantUML doivent suivre les standards appropriés selon le type de diagramme :

- `seq-puml.instructions.md` pour les diagrammes de séquence

- `activity-puml.instructions.md` pour les diagrammes d'activité

 

```plantuml

@startuml ${DIAGRAM_NAME}

 

' Configuration AWS Icons - Import obligatoire (suivre seq-puml.instructions.md)

!define AWSPuml https://raw.githubusercontent.com/awslabs/aws-icons-for-plantuml/v15.0/dist

!include AWSPuml/AWSCommon.puml

!include AWSPuml/Storage/all.puml

!include AWSPuml/Compute/all.puml

!include AWSPuml/Database/all.puml

!include AWSPuml/ApplicationIntegration/all.puml

!include AWSPuml/Containers/all.puml

 

' Configuration standard (suivre seq-puml.instructions.md)

skinparam defaulttextalignment center

skinparam linetype ortho

skinparam shadowing false

skinparam style strictuml

skinparam MaxMessageSize 500

 

skinparam Arrow {

    Thickness 2

    Color black

    FontColor black

}

 

skinparam note {

    backgroundColor #yellow

    borderColor #black

    borderThickness 1

    textAlignment left

}

 

skinparam sequence {

    boxBackgroundColor #powderblue

    boxBorderColor #black

    dividerBackgroundColor #yellow

    groupBackgroundColor #skyblue

    groupBodyBackgroundColor transparent

    lifeLineBorderColor #black

    messageAlign center

    referenceBackgroundColor #palegreen

    referenceHeaderBackgroundColor #limegreen

}

 

title ${DIAGRAM_TITLE}

 

' Variables à définir:

' ${DIAGRAM_NAME}: Nom du diagramme

' ${DIAGRAM_TITLE}: Titre du diagramme

' ${VERSION}: Version

' ${AUTHOR}: Auteur

' ${DOMAIN_*}: Domaines fonctionnels

' ${SERVICE_*}: Services participants

 

' Regroupement par domaine (suivre les couleurs standardisées)

box "${DOMAIN1_NAME}" ${DOMAIN1_COLOR}

    participant "$AWSImg(${AWS_SERVICE_TYPE})\\n${SERVICE1_TYPE}\\n${SERVICE1_NAME}" as ${SERVICE1_ALIAS}

end box

 

box "${DOMAIN2_NAME}" ${DOMAIN2_COLOR}

    participant "$AWSImg(${AWS_SERVICE_TYPE})<


