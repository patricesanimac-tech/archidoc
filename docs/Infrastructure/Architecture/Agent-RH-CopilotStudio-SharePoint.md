# Architecture de Solution — Agent RH Conversationnel
## Option A : Microsoft Copilot Studio + SharePoint

**Version :** 1.0  
**Date :** 2026-04-10  
**Auteur(s) :** Architecture Team  
**Statut :** Brouillon  
**Classification :** Interne

---

## Résumé exécutif

L'Agent RH conversationnel est un assistant virtuel déployé via **Microsoft Copilot Studio**, permettant aux employés de Sani Marc d'interroger en langage naturel les politiques d'entreprise, conventions collectives, règles de vacances et autres documents RH déposés dans **SharePoint**.

**Objectifs clés :** Réduire le volume de demandes répétitives adressées aux RH de 40 %, offrir un accès instantané 24/7 aux politiques en vigueur, et constituer une base d'expérience chatbot IA pour les phases ultérieures de la stratégie IA de Sani Marc.

**Approche :** Déploiement RAG (Retrieval-Augmented Generation) entièrement géré par Microsoft — les documents RH déposés dans SharePoint sont automatiquement indexés par Azure AI Search, puis exploités par Copilot Studio qui expose le chatbot dans Microsoft Teams. Aucun code applicatif custom requis pour le MVP.

**Budget estimé :** 15 000 $ à 30 000 $ CAD (configuration, formation et déploiement pilote) + licences Copilot Studio (~30 $/utilisateur/mois).

---

## Historique des versions

| Version | Date | Auteur | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-04-10 | Architecture Team | Conception initiale — MVP RH |

---

## Table des matières

1. [Contexte du projet](#1-contexte-du-projet)
2. [Architecture fonctionnelle](#2-architecture-fonctionnelle)
3. [Architecture de solution](#3-architecture-de-solution)
4. [Intégrations et interfaces](#4-intégrations-et-interfaces)
5. [Architecture de déploiement](#5-architecture-de-déploiement)
6. [Qualités de service](#6-qualités-de-service)
7. [Sécurité](#7-sécurité)
8. [Plan de transition](#8-plan-de-transition)
9. [Décisions architecturales](#9-décisions-architecturales)
10. [Comparaison Option A vs Option B](#10-comparaison-option-a-vs-option-b)

---

# 1. Contexte du projet

## 1.1 Vue d'ensemble

### 1.1.1 Objectif du document

Ce document décrit l'**Architecture de Solution** pour l'**Agent RH conversationnel de Sani Marc — Option A**, basé sur Microsoft Copilot Studio et SharePoint.

Il détaille la conception fonctionnelle et technique d'un assistant virtuel permettant aux employés de consulter en langage naturel les politiques RH internes, en obtenant des réponses précises et sourcées, issues directement des documents officiels déposés par l'équipe RH dans SharePoint.

**Audience :**
- Directeur TI et Architecture (décideur)
- Directrice des Ressources Humaines (sponsor métier)
- Équipe TI (implémentation et administration)
- Comité de gouvernance architecture

**Ce document NE couvre PAS :**
- L'architecture de l'Option B (base vectorielle indépendante de Microsoft)
- Les processus RH eux-mêmes (gestion de la paie, SIRH, recrutement)
- La formation continue des modèles IA (hors périmètre Copilot Studio)
- L'intégration avec Infor M3 ou Dynamics 365 (phase ultérieure)

### 1.1.2 Portée du projet

**Inclus dans ce projet :**
- Agent conversationnel bilingue (français / anglais) répondant aux questions RH
- Indexation automatique des documents RH déposés dans SharePoint (PDF, Word, PowerPoint)
- Interface employé via Microsoft Teams (canal principal) et SharePoint Web Part
- Gestion des escalades vers un agent RH humain si la question dépasse le contexte documentaire
- Tableau de bord analytique (questions posées, taux de satisfaction, topics populaires)
- Respect des permissions SharePoint (un employé ne voit que les documents auxquels il a accès)

**Exclus du projet (hors périmètre) :**
- Intégration avec le SIRH (gestion RH transactionnelle — demandes de congés, paie)
- Chatbot face aux clients Sani Marc (usage interne uniquement)
- Intégration avec Infor M3 ou D365 CRM (Phase 2)
- Formation et certification des employés via le chatbot (Phase 2)

### 1.1.3 Alignement stratégique

Cet agent s'inscrit dans la **Phase 1 (Fondation) de la Stratégie IA Sani Marc 2026–2031**, contribuant aux capacités métier suivantes :

- **Efficacité opérationnelle RH** : réduction du temps consacré aux questions répétitives
- **Accessibilité de la connaissance** : politiques disponibles 24/7 pour tous les employés
- **Culture IA** : première expérience concrète d'un agent IA pour les employés Sani Marc
- **Réutilisabilité** : le pattern RAG validé ici servira de base aux agents futurs (Support, Production, Achats)

**Alignement avec les principes d'architecture :**
- Transparence de l'IA (toute réponse cite le document source)
- Souveraineté des données (tout reste dans le tenant Microsoft Azure Canada)
- Conformité PIPEDA (pas de données personnelles exposées dans le chatbot)
- Priorité aux outils Microsoft déjà licenciés

---

## 1.2 Objectifs du projet

### 1.2.1 Objectifs métier

| ID | Objectif | Métrique de succès | Échéance |
|---|---|---|---|
| OBJ-001 | Réduire les questions RH répétitives adressées à l'équipe RH | Diminution de 40 % des demandes entrantes de type FAQ | 6 mois post-déploiement |
| OBJ-002 | Offrir un accès instantané aux politiques RH en vigueur | Disponibilité 24/7, réponse en < 5 secondes | Dès go-live |
| OBJ-003 | Assurer la précision des réponses | Taux d'acceptation des réponses IA > 75 % (feedback employé) | 3 mois post-pilote |
| OBJ-004 | Valider l'adhésion des employés au canal IA | NPS > 7/10 auprès des utilisateurs pilotes | 2 mois post-pilote |
| OBJ-005 | Constituer un référentiel documentaire RH structuré | 100 % des politiques actives indexées dans SharePoint | Avant go-live |

### 1.2.2 Critères d'acceptation

**Fonctionnels :**
- L'agent répond en français et en anglais avec détection automatique de la langue
- Chaque réponse cite le document source (titre, section ou numéro de page)
- L'agent escalade vers un humain RH si la confiance est inférieure au seuil configuré
- L'historique des conversations est accessible aux administrateurs RH et TI (audit)
- Les employés peuvent évaluer la qualité d'une réponse (pouce haut / pouce bas)

**Non-fonctionnels :**
- Latence de réponse < 5 secondes (p95)
- Disponibilité 99.5 % durant les heures ouvrables
- Sécurité : respect des permissions SharePoint sans configuration supplémentaire
- Conservation des logs de conversation : 12 mois (conformité PIPEDA)

---

## 1.3 Parties prenantes

### 1.3.1 Équipe projet

| Rôle | Nom | Responsabilité | Disponibilité |
|---|---|---|---|
| **Architecte de solution** | [À assigner] | Conception technique, décisions d'architecture, validation ADR | 50 % |
| **Administrateur Copilot Studio** | [À assigner] | Configuration de l'agent, topics, sources de données | 100 % |
| **Administrateur SharePoint** | [À assigner] | Structure bibliothèque documentaire, permissions, métadonnées | 50 % |
| **Représentant RH (contenu)** | [À assigner] | Validation des documents, règles de diffusion, tests UAT | 50 % |
| **Change Manager / Communication** | [À assigner] | Plan de communication, formation des employés, adoption | 30 % |
| **Responsable Sécurité TI** | [À assigner] | Revue DLP, conformité PIPEDA, audit des accès | 20 % |

### 1.3.2 Sponsors et décideurs

- **Sponsor exécutif :** VP Ressources Humaines & Affaires Corporatives
- **Sponsor métier :** Directrice des Ressources Humaines
- **Sponsor TI :** Directeur des Technologies de l'Information
- **Comité de validation :** Architecture Review Board

---

## 1.4 Exigences

### 1.4.1 Exigences fonctionnelles

| ID | User Story | Priorité | Estimation | Sprint |
|---|---|---|---|---|
| RF-001 | En tant qu'employé, je veux poser une question sur mes vacances en français et recevoir une réponse basée sur la politique en vigueur | **P0** | 5 pts | S1 |
| RF-002 | En tant qu'employé, je veux que les réponses citent le document et la section sources | **P0** | 3 pts | S1 |
| RF-003 | En tant qu'employé, je veux interagir avec l'agent directement dans Microsoft Teams | **P0** | 3 pts | S1 |
| RF-004 | En tant qu'employé anglophone, je veux poser mes questions en anglais et obtenir une réponse en anglais | **P0** | 3 pts | S1 |
| RF-005 | En tant que responsable RH, je veux déposer un nouveau document PDF dans SharePoint et qu'il soit disponible dans l'agent dans les 24h | **P0** | 5 pts | S1 |
| RF-006 | En tant qu'employé, je veux pouvoir indiquer si la réponse m'a été utile (feedback) | **P1** | 2 pts | S2 |
| RF-007 | En tant qu'employé, je veux être redirigé vers un agent RH humain si l'agent ne peut pas répondre | **P1** | 3 pts | S2 |
| RF-008 | En tant qu'administrateur RH, je veux consulter les questions les plus fréquentes posées à l'agent | **P1** | 5 pts | S2 |
| RF-009 | En tant qu'administrateur TI, je veux consulter l'historique complet des conversations pour audit | **P2** | 5 pts | S3 |
| RF-010 | En tant que responsable RH, je veux accéder à un tableau de bord de satisfaction et d'utilisation | **P2** | 8 pts | S3 |

### 1.4.2 Exigences non-fonctionnelles

| ID | Catégorie | Exigence | Critère d'acceptation | Priorité |
|---|---|---|---|---|
| RNF-001 | Performance | Latence réponse agent | < 5 secondes p95 | **P0** |
| RNF-002 | Performance | Délai d'indexation nouveaux documents | < 24 heures après dépôt SharePoint | **P0** |
| RNF-003 | Disponibilité | Uptime heures ouvrables | 99.5 % SLA (hérité de Microsoft 365) | **P0** |
| RNF-004 | Sécurité | Respect des permissions documentaires | L'agent ne retourne jamais un document auquel l'utilisateur n'a pas accès dans SharePoint | **P0** |
| RNF-005 | Sécurité | Authentification | SSO Azure AD (Entra ID) obligatoire — aucune authentification en double | **P0** |
| RNF-006 | Conformité | Conservation des logs | Logs conversation conservés 12 mois minimum (PIPEDA) | **P0** |
| RNF-007 | Maintenabilité | Mise à jour documentaire | Un responsable RH non-technique peut déposer/retirer un document sans intervention TI | **P1** |
| RNF-008 | Accessibilité | Bilinguisme FR/EN | Toutes les réponses dans la langue de la question, sans intervention manuelle | **P1** |
| RNF-009 | Scalabilité | Utilisateurs simultanés | Support de 500+ employés sans dégradation | **P1** |
| RNF-010 | Auditabilité | Traçabilité complète | Logs : identifiant employé (anonymisé), question, réponse, source citée, timestamp, feedback | **P1** |
| RNF-011 | Conformité PIPEDA | Données personnelles | Aucune donnée personnelle identifiable stockée dans les logs sans consentement explicite | **P0** |
| RNF-012 | DLP | Prévention fuite de données | Politique DLP Microsoft Purview appliquée aux conversations Copilot | **P1** |

---

## 1.5 Contraintes

### 1.5.1 Contraintes techniques
- **Écosystème obligatoire :** Microsoft 365 (tenant existant Sani Marc)
- **LLM :** Azure OpenAI GPT-4o via Copilot Studio (modèle géré Microsoft, non configurable)
- **Sources de données MVP :** SharePoint uniquement (Copilot Studio Bing-grounded knowledge)
- **Interface principale :** Microsoft Teams (déjà déployé chez Sani Marc)
- **Aucun code custom :** Configuration low-code via interface Copilot Studio pour le MVP

### 1.5.2 Contraintes temporelles
- **Pilote (10 utilisateurs RH) :** 4 semaines après go-signal
- **Déploiement complet :** 8–10 semaines après go-signal
- **Gel des déploiements :** Jamais en période de renouvellement de conventions collectives

### 1.5.3 Contraintes réglementaires
- **PIPEDA :** Pas de conservation de données personnelles identifiables sans consentement
- **Souveraineté des données :** Région Azure Canada East obligatoire pour tout traitement
- **Transparence IA :** L'employé doit savoir qu'il interagit avec un agent IA (pas un humain)
- **Droit à l'oubli :** Possibilité de supprimer l'historique d'un employé sur demande

---

## 1.6 Hypothèses et risques

### 1.6.1 Hypothèses
- Sani Marc dispose déjà d'un tenant Microsoft 365 actif avec Teams déployé
- Les licences Microsoft Copilot Studio sont disponibles ou seront acquises
- L'équipe RH est disponible pour valider et structurer le corpus documentaire avant le pilote
- Les documents RH existants sont en format numérique (PDF, Word) et non en version papier uniquement
- Azure AD (Entra ID) est la source d'identité principale pour tous les employés

### 1.6.2 Risques

| ID | Risque | Probabilité | Impact | Mitigation |
|---|---|---|---|---|
| R-001 | Documents RH non structurés ou obsolètes retardent l'indexation | Élevée | Moyen | Sprint de préparation documentaire avant déploiement technique |
| R-002 | Résistance des employés à utiliser un agent IA pour des questions sensibles (vacances, congés maternité) | Moyenne | Élevé | Communication claire, escalade facile vers humain RH, anonymisation option |
| R-003 | Réponses incorrectes sur des sujets à enjeux légaux (convention collective) | Faible | Élevé | Disclaimer automatique, validation humaine avant déploiement des documents légaux |
| R-004 | Coût des licences Copilot Studio dépasse le budget prévu si adoption forte | Faible | Moyen | Modèle de licence par consommation disponible en alternative |
| R-005 | Indexation partielle de documents PDF scannés (images non-OCR) | Moyenne | Moyen | Conversion OCR via Azure Document Intelligence avant dépôt SharePoint |

---

# 2. Architecture fonctionnelle

## 2.1 Cas d'utilisation principaux

### UC-001 : Consultation d'une politique RH

**Acteur principal :** Employé Sani Marc  
**Objectif :** Obtenir une réponse précise sur une politique RH en vigueur  
**Préconditions :** L'employé est authentifié dans Microsoft Teams via Azure AD  
**Scénario nominal :**
1. L'employé ouvre le canal Teams « Agent RH » ou lance le chatbot depuis le Web Part SharePoint
2. Il pose sa question en langage naturel (ex. : « Combien de jours de vacances ai-je droit après 3 ans de service ? »)
3. L'agent analyse la question et interroge la base documentaire SharePoint via Azure AI Search
4. L'agent retourne une réponse rédigée en langage naturel, avec citation du document source et de la section
5. L'employé évalue la réponse (pouce haut / pouce bas)

**Scénarios alternatifs :**
- *Question hors périmètre documentaire :* L'agent indique qu'il ne peut pas répondre et propose l'escalade vers un agent RH humain
- *Confiance de réponse sous le seuil :* L'agent signale l'incertitude et invite l'employé à contacter RH directement
- *Document PDF non OCR :* L'agent retourne une réponse partielle et recommande de contacter RH

**Exigences spéciales :** Disclaimer affiché pour toute réponse relative à une convention collective  
**Fréquence estimée :** 20–50 interactions/jour (tous employés confondus)  
**Canaux :** Microsoft Teams, SharePoint Web Part

---

### UC-002 : Administration du corpus documentaire RH

**Acteur principal :** Responsable RH (non-technique)  
**Objectif :** Mettre à jour les documents disponibles dans l'agent sans passer par TI  
**Préconditions :** Le responsable RH a les droits d'écriture sur la bibliothèque SharePoint dédiée  
**Scénario nominal :**
1. Le responsable RH dépose un nouveau PDF ou met à jour un document existant dans la bibliothèque SharePoint « Politiques-RH »
2. Un flux Power Automate déclenche le réindexation du document dans Azure AI Search (dans les 24h)
3. Le responsable RH valide dans le tableau de bord Copilot Studio que le document est bien indexé
4. L'agent est immédiatement capable de répondre en se basant sur le nouveau document

**Scénarios alternatifs :**
- *Document en format image (PDF scanné) :* Notification automatique au responsable RH pour conversion OCR
- *Document retiré :* Le responsable RH déplace le fichier vers un dossier « Archivés » — l'indexation est automatiquement exclue

**Fréquence estimée :** 2–5 mises à jour documentaires par mois

---

### UC-003 : Escalade vers un agent RH humain

**Acteur principal :** Employé Sani Marc  
**Objectif :** Être mis en relation avec un agent RH humain pour une question sensible ou sans réponse documentaire  
**Préconditions :** L'agent IA a déterminé que la question dépasse son périmètre ou que la confiance est insuffisante  
**Scénario nominal :**
1. L'agent détecte que la question nécessite une réponse personnalisée ou transactionnelle (ex. : « Je voudrais poser une journée de congé »)
2. L'agent informe l'employé qu'il va le rediriger vers un collègue RH
3. L'agent ouvre un chat Teams avec l'agent RH de garde ou envoie un courriel avec résumé de la conversation
4. La conversation entre l'employé et l'agent RH humain se poursuit dans Teams

**Fréquence estimée :** 10–20 % des conversations conduiront à une escalade

---

## 2.2 Processus métier supportés

### Processus A : Réponse à une question RH de type FAQ

| Attribut | Valeur |
|---|---|
| **Déclencheur** | Question en langage naturel d'un employé dans Teams |
| **Fréquence** | 20–50 fois/jour |
| **Durée moyenne** | 15–45 secondes (de la question à la réponse affichée) |
| **Acteurs** | Employé, Agent IA (Copilot Studio), Azure AI Search, SharePoint |

```
Employé pose question (Teams / SharePoint)
          ↓
[Copilot Studio] — Analyse intention (topic matching + NLU)
          ↓
[Azure AI Search] — Recherche sémantique dans index SharePoint
          ↓
Documents pertinents récupérés (top-K chunks)
          ↓
[Azure OpenAI GPT-4o] — Génération réponse ancrée dans les documents
          ↓
Réponse + Citation source → Retournée à l'employé
          ↓
Employé évalue la réponse (feedback optionnel)
```

---

### Processus B : Mise à jour du corpus documentaire

| Attribut | Valeur |
|---|---|
| **Déclencheur** | Dépôt ou modification d'un fichier dans SharePoint (bibliothèque dédiée) |
| **Fréquence** | 2–5 fois/mois |
| **Durée moyenne** | Indexation automatique dans les 4 à 24 heures |
| **Acteurs** | Responsable RH, SharePoint, Power Automate, Azure AI Search |

```
Responsable RH dépose/modifie document (SharePoint)
          ↓
[Power Automate] — Flux déclenché sur événement SharePoint
          ↓
[Azure AI Search] — Réindexation du document (chunking + embeddings)
          ↓
Document disponible dans l'agent (< 24h)
          ↓
Notification optionnelle au responsable RH (confirmation)
```

---

## 2.3 Catalogue documentaire RH (corpus initial proposé)

| Catégorie | Documents types | Format | Priorité d'indexation |
|---|---|---|---|
| Conventions collectives | Convention syndicale, amendements | PDF | Haute |
| Politiques de vacances | Politique d'accumulation, calendrier | PDF/Word | Haute |
| Horaires et quarts | Grille horaire, politique quarts de travail | PDF | Haute |
| Avantages sociaux | Régime d'assurance, REER collectif | PDF | Haute |
| Manuel de l'employé | Guide d'accueil, code de conduite | PDF/Word | Moyenne |
| Procédures RH | Demande congé, télétravail, maladie | PDF/Word | Moyenne |
| Formulaires | Formulaires téléchargeables (référence) | PDF | Basse |

---

# 3. Architecture de solution

## 3.1 Vue d'ensemble — Diagramme de contexte

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Tenant Microsoft 365                          │
│                         (Azure Canada East)                          │
│                                                                      │
│  ┌─────────────┐    ┌──────────────────┐    ┌──────────────────┐   │
│  │  Employé    │───▶│  Microsoft Teams  │───▶│  Copilot Studio  │   │
│  │  Sani Marc  │    │  (interface)      │    │  (Agent IA)      │   │
│  └─────────────┘    └──────────────────┘    └────────┬─────────┘   │
│                                                       │              │
│  ┌─────────────┐    ┌──────────────────┐    ┌────────▼─────────┐   │
│  │ Responsable │───▶│ SharePoint Online │───▶│  Azure AI Search │   │
│  │    RH       │    │ (corpus docs RH)  │    │  (index + RAG)   │   │
│  └─────────────┘    └──────────────────┘    └────────┬─────────┘   │
│                                                       │              │
│                                             ┌────────▼─────────┐   │
│                                             │  Azure OpenAI    │   │
│                                             │  GPT-4o          │   │
│                                             │  (génération)    │   │
│                                             └──────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Azure AD (Entra ID) — Authentification SSO de bout en bout  │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3.2 Architecture RAG détaillée (flux de traitement)

### Phase 1 — Indexation (offline, à chaque mise à jour documentaire)

```
Documents SharePoint (PDF, Word, PowerPoint)
          │
          ▼
┌─────────────────────────────────────────────────────────┐
│               Azure AI Search — Indexeur                 │
│                                                          │
│  1. Extraction texte (traitement natif PDF/Word)        │
│  2. Chunking sémantique (paragraphes, ~500 tokens)      │
│  3. Génération embeddings (text-embedding-ada-002)       │
│  4. Stockage dans l'index vectoriel + index full-text    │
└─────────────────────────────────────────────────────────┘
          │
          ▼
   Index Azure AI Search
   ├── Champ vectoriel (embeddings)
   ├── Champ full-text (mots-clés)
   ├── Métadonnées (titre, URL SharePoint, date, section)
   └── Permissions (trimming par utilisateur Azure AD)
```

### Phase 2 — Inférence (online, à chaque question d'un employé)

```
Question employé (Teams)
          │
          ▼
┌─────────────────────────────────────────────────────────┐
│  Copilot Studio — Orchestration                          │
│                                                          │
│  1. Détection intention (topic matching)                │
│  2. Appel Knowledge Source (SharePoint via AI Search)   │
│  3. Recherche hybride : vectorielle + full-text         │
│  4. Security trimming (permissions SharePoint)          │
│  5. Top-K documents récupérés (contexte)                │
│  6. Prompt engineering (question + contexte → GPT-4o)   │
│  7. Génération réponse ancrée + citations               │
└─────────────────────────────────────────────────────────┘
          │
          ▼
Réponse + [Source : Politique Vacances, Section 3.2, p.7]
```

---

## 3.3 Composants techniques

| Composant | Technologie Microsoft | Rôle | Notes |
|---|---|---|---|
| **Interface conversationnelle** | Microsoft Teams App | Canal principal d'interaction employé | Déjà déployé chez Sani Marc |
| **Interface web alternative** | SharePoint Web Part (Copilot Studio embed) | Accès sans Teams | Option secondaire |
| **Moteur IA de l'agent** | Microsoft Copilot Studio | Orchestration des topics, flux de conversation, connexion sources | Low-code, configuré via interface graphique |
| **Base documentaire** | SharePoint Online (bibliothèque dédiée) | Stockage des documents RH officiels | Permissions gérées par RH |
| **Moteur de recherche** | Azure AI Search | Indexation, recherche vectorielle, security trimming | Intégration native Copilot Studio |
| **Modèle de langage** | Azure OpenAI GPT-4o | Génération de réponses naturelles ancrées | Géré Microsoft, région Canada |
| **Automatisation indexation** | Power Automate | Déclenchement réindexation sur dépôt de document | Flux low-code |
| **Identité & accès** | Azure AD / Microsoft Entra ID | SSO, permissions, groupes d'accès | Source d'identité existante |
| **Analytics & monitoring** | Copilot Studio Analytics + Dataverse | Topics populaires, satisfaction, volume | Dashboard natif Copilot Studio |
| **Protection données** | Microsoft Purview (DLP) | Politique DLP sur conversations Copilot | Conformité PIPEDA |
| **Logs & audit** | Microsoft Purview Audit | Traçabilité complète des interactions | Conservation 12 mois |

---

## 3.4 Architecture des topics Copilot Studio

```
Agent RH Sani Marc
│
├── 📁 Topics Principaux (Greetings & Navigation)
│   ├── Bienvenue & Présentation de l'agent
│   ├── Je ne comprends pas (fallback)
│   └── Au revoir
│
├── 📁 Vacances & Congés
│   ├── Nombre de jours de vacances (par ancienneté)
│   ├── Politique de report des vacances
│   ├── Congé maladie / Congé personnel
│   ├── Congé maternité / paternité / parental
│   └── Demande de congé → Escalade RH
│
├── 📁 Avantages Sociaux
│   ├── Régime d'assurance collective
│   ├── Régime de retraite (REER collectif)
│   └── Programme d'aide aux employés (PAE)
│
├── 📁 Conventions Collectives
│   ├── Droits et obligations (avec disclaimer légal)
│   ├── Procédure de grief
│   └── Ancienneté et progression salariale
│
├── 📁 Politiques de travail
│   ├── Télétravail
│   ├── Code de conduite
│   └── Harcèlement et dignité au travail
│
└── 📁 Escalades
    ├── Redirection vers agent RH (Teams live chat)
    └── Envoi de courriel vers équipe RH
```

---

# 4. Intégrations et interfaces

## 4.1 Carte des intégrations

```
                    ┌──────────────────┐
                    │  Copilot Studio  │
                    │    (Agent RH)    │
                    └──────┬───────────┘
                           │
         ┌─────────────────┼─────────────────────┐
         │                 │                      │
         ▼                 ▼                      ▼
┌────────────────┐  ┌─────────────────┐  ┌──────────────────┐
│ Microsoft Teams│  │ Azure AI Search │  │ SharePoint Online │
│ (interface)    │  │ (RAG index)     │  │ (documents RH)   │
└────────────────┘  └─────────────────┘  └──────────────────┘
         │                 │                      │
         ▼                 ▼                      ▼
┌────────────────┐  ┌─────────────────┐  ┌──────────────────┐
│  Azure AD      │  │ Azure OpenAI    │  │ Power Automate   │
│  (auth SSO)    │  │ GPT-4o          │  │ (indexation)     │
└────────────────┘  └─────────────────┘  └──────────────────┘
```

## 4.2 Détail des intégrations

### INT-001 : Copilot Studio ↔ SharePoint (Knowledge Source)

| Attribut | Valeur |
|---|---|
| **Type** | Native Copilot Studio — Knowledge Source SharePoint |
| **Protocole** | Microsoft Graph API (interne) |
| **Authentification** | SSO Azure AD (droits délégués) |
| **Fréquence de synchronisation** | Continue (indexation déclenchée par Power Automate) |
| **Security trimming** | Actif — l'agent ne retourne que les documents accessibles à l'utilisateur authentifié |
| **Configuration** | Low-code dans Copilot Studio Studio → Knowledge → Add SharePoint |

### INT-002 : Copilot Studio ↔ Microsoft Teams

| Attribut | Valeur |
|---|---|
| **Type** | Native Copilot Studio — Channel Teams |
| **Déploiement** | Publication de l'agent comme application Teams (admin Teams approval) |
| **Interface** | Chat conversationnel Teams, possibilité d'App dans le panneau gauche |
| **Notification escalade** | Teams Adaptive Card pour les redirections vers agents RH humains |

### INT-003 : Power Automate ↔ SharePoint ↔ Azure AI Search

| Attribut | Valeur |
|---|---|
| **Type** | Flux Power Automate déclenché sur événement SharePoint |
| **Déclencheur** | Création ou modification d'un fichier dans la bibliothèque « Politiques-RH » |
| **Action** | Appel à l'API Azure AI Search pour réindexation du document |
| **Délai** | < 24 heures (selon configuration de l'indexeur Azure AI Search) |
| **Notification** | Courriel optionnel au responsable RH confirmant l'indexation |

---

# 5. Architecture de déploiement

## 5.1 Environnements

| Environnement | Objectif | Utilisateurs | Notes |
|---|---|---|---|
| **Développement/Config** | Configuration et tests internes TI | Équipe TI (3–5 personnes) | Tenant de test ou environnement Copilot Studio Dev |
| **Pilote** | Validation avec groupe restreint | 10 personnes : équipe RH + volontaires | 4 premières semaines |
| **Production** | Déploiement à tous les employés | Tous les employés Sani Marc | Après validation pilote |

## 5.2 Structure SharePoint recommandée

```
Site SharePoint : « RH — Politiques et Documents »
│
├── 📚 Bibliothèque : Politiques-RH (indexée par l'agent)
│   ├── 📁 Conventions-Collectives/
│   │   ├── Convention_Collective_2024-2027.pdf
│   │   └── Amendement_2025.pdf
│   ├── 📁 Vacances-Conges/
│   │   ├── Politique_Vacances_Annuelles.pdf
│   │   └── Calendrier_Feries_2026.pdf
│   ├── 📁 Avantages-Sociaux/
│   │   └── Guide_Assurances_Collectives.pdf
│   ├── 📁 Manuel-Employe/
│   │   └── Manuel_Employe_v3.2.pdf
│   └── 📁 Politiques-Travail/
│       ├── Politique_Teletravail.pdf
│       └── Code_Conduite.pdf
│
└── 📚 Bibliothèque : Politiques-RH-Archives (NON indexée)
    └── [Documents obsolètes déplacés ici par RH]
```

## 5.3 Plan de déploiement

```
Semaine 1-2 : Préparation
├── Inventaire et nettoyage des documents RH
├── Création structure SharePoint et permissions
├── Acquisition/activation licences Copilot Studio
└── Configuration Azure AI Search knowledge source

Semaine 3-4 : Configuration Copilot Studio
├── Création des topics principaux (vacances, congés, avantages)
├── Configuration du fallback et escalade Teams
├── Tests internes (équipe TI + RH)
└── Ajustements des seuils de confiance et réponses

Semaine 5-6 : Pilote (10 utilisateurs)
├── Déploiement canal Teams (groupe pilote)
├── Collecte feedback quotidien
├── Ajustements topics et formulations
└── Validation conformité PIPEDA avec responsable sécurité

Semaine 7-8 : Déploiement général
├── Communication employés (intranet, courriel)
├── Déploiement Teams à tous les employés
├── Activation SharePoint Web Part (accès alternatif)
└── Formation responsables RH (admin corpus documentaire)

Post-déploiement (mois 2–3)
├── Revue mensuelle des analytics (topics, satisfaction)
├── Enrichissement continu du corpus documentaire
└── Évaluation passage à Phase 2 (Option B)
```

---

# 6. Qualités de service

## 6.1 Performance

| Métrique | Cible | Méthode de mesure |
|---|---|---|
| Latence réponse (p50) | < 2 secondes | Copilot Studio Analytics |
| Latence réponse (p95) | < 5 secondes | Copilot Studio Analytics |
| Délai d'indexation nouveaux documents | < 24 heures | Monitoring Power Automate |
| Taux de réponse utile (feedback positif) | > 75 % | Copilot Studio — Satisfaction dashboard |

## 6.2 Disponibilité

L'agent hérite du **SLA Microsoft 365 (99.9 % de disponibilité mensuelle)** incluant SharePoint Online, Teams et Copilot Studio. Aucune infrastructure propre à gérer.

| Composant | SLA Microsoft | Impact panne |
|---|---|---|
| Microsoft Teams | 99.9 % | Interface principale indisponible |
| SharePoint Online | 99.9 % | Corpus documentaire inaccessible |
| Azure AI Search | 99.9 % | Recherche documentaire impossible |
| Azure OpenAI | 99.9 % | Génération de réponses impossible |
| Copilot Studio | 99.9 % | Agent complet indisponible |

> En cas d'incident Microsoft 365, les employés sont redirigés vers le courriel RH habituel.

## 6.3 Scalabilité

Copilot Studio ne nécessite aucune configuration de scalabilité — le service est élastique et géré par Microsoft. La scalabilité est limitée uniquement par les licences acquises (modèle par consommation disponible).

---

# 7. Sécurité

## 7.1 Modèle de contrôle d'accès

```
Employé Sani Marc
      │
      │ Authentification Azure AD (SSO)
      ▼
┌─────────────────────────────────────────────────┐
│  Microsoft Entra ID (Azure AD)                  │
│  - MFA activé (recommandé)                      │
│  - Groupes de sécurité par département          │
└─────────────┬───────────────────────────────────┘
              │
     Jeton d'accès (OAuth 2.0)
              │
              ▼
┌─────────────────────────────────────────────────┐
│  Copilot Studio                                 │
│  - Accès agent uniquement aux utilisateurs      │
│    authentifiés (pas d'accès anonyme)           │
└─────────────┬───────────────────────────────────┘
              │
   Security trimming automatique
              │
              ▼
┌─────────────────────────────────────────────────┐
│  Azure AI Search                                │
│  - Filtre par permissions SharePoint de         │
│    l'utilisateur (ACL trimming)                 │
│  - L'employé ne voit QUE les documents          │
│    auxquels il a accès dans SharePoint          │
└─────────────────────────────────────────────────┘
```

**Principe clé :** Sani Marc ne configure aucune sécurité custom — tout hérite des permissions SharePoint existantes, gérées par l'équipe RH et TI dans Azure AD.

## 7.2 Protection des données (PIPEDA)

| Mesure | Implémentation | Responsable |
|---|---|---|
| **Aucune donnée personnelle dans les réponses** | Les documents indexés sont des politiques générales, non des dossiers individuels | RH (validation corpus) |
| **Anonymisation des logs de conversation** | Identifiant anonymisé (guid) plutôt que nom/prénom dans les logs Dataverse | TI |
| **Conservation des logs** | 12 mois, puis suppression automatique via politique Purview | TI |
| **Droit à l'oubli** | Suppression manuelle des logs d'un employé sur demande (admin Copilot Studio) | TI + RH |
| **Transparence** | Message de bienvenue indiquant clairement qu'il s'agit d'un agent IA | RH (configuration topics) |

## 7.3 Politique DLP (Data Loss Prevention)

Une politique Microsoft Purview DLP doit être configurée pour :
- Détecter la mention de numéros d'assurance sociale (NAS) dans les conversations
- Détecter les informations bancaires dans les conversations
- Bloquer l'affichage de telles informations dans les réponses de l'agent

## 7.4 Classification des données

| Type de document | Classification | Accès SharePoint recommandé |
|---|---|---|
| Manuel de l'employé | Public interne | Tous les employés |
| Politique de vacances | Public interne | Tous les employés |
| Convention collective | Confidentiel interne | Tous les employés (lecture) |
| Grilles salariales | Confidentiel restreint | Gestionnaires RH uniquement |
| Dossiers employés individuels | **EXCLU du corpus agent** | Jamais indexés |

> **Règle absolue :** Aucun dossier individuel d'employé (dossier disciplinaire, évaluation de performance, absence maladie) ne doit être déposé dans la bibliothèque SharePoint indexée par l'agent.

---

# 8. Plan de transition

## 8.1 Gestion du changement

| Phase | Action | Responsable | Échéance |
|---|---|---|---|
| Avant déploiement | Communication aux gestionnaires (objectifs, limites de l'agent) | DRH | Semaine 3 |
| Avant déploiement | FAQ employés publiée sur l'intranet (« L'agent RH c'est quoi ? ») | Communication + RH | Semaine 4 |
| Pilote | Sessions de questions/réponses avec les utilisateurs pilotes | RH + TI | Semaines 5–6 |
| Go-live | Courriel d'annonce à tous les employés avec guide de démarrage | DRH | Semaine 7 |
| Post go-live | Formation responsables RH sur la gestion du corpus documentaire | TI | Semaine 8 |

## 8.2 Formation

| Public | Contenu | Format | Durée |
|---|---|---|---|
| **Tous les employés** | Comment poser une question à l'agent RH, comprendre les réponses et citations, escalader vers RH | Courte vidéo (2 min) + fiche aide-mémoire | 2 minutes |
| **Responsables RH** | Déposer/retirer des documents, vérifier l'indexation, analyser les analytics | Atelier pratique | 1 heure |
| **Administrateurs TI** | Configuration des topics, gestion des seuils, audit des logs, escalades | Documentation technique + formation | 2 heures |

## 8.3 Critères de succès du pilote (Semaines 5–6)

Avant le déploiement général, les critères suivants doivent être validés :

- [ ] Taux de réponse utile (feedback positif) > 70 %
- [ ] Zéro incident de sécurité ou de fuite de données pendant le pilote
- [ ] Latence p95 < 5 secondes mesurée sur 2 semaines
- [ ] L'équipe RH valide que toutes les conventions collectives sont correctement indexées
- [ ] 100 % des escalades aboutissent correctement à un agent RH humain
- [ ] Disclaimer légal présent sur toutes les réponses relatives aux conventions collectives

---

# 9. Décisions architecturales

## ADR-001 : Choix de Copilot Studio comme orchestrateur principal

**Décision :** Utiliser Microsoft Copilot Studio (anciennement Power Virtual Agents) comme plateforme d'agent IA pour le MVP.

**Contexte :** Sani Marc dispose d'un tenant Microsoft 365. L'objectif est un quick win en 8 semaines sans développement custom.

**Alternatives considérées :**
- Azure Bot Framework (SDK custom) → Écarté car nécessite développement
- LangChain + Python + Qdrant (Option B) → Écarté pour le MVP, retenu pour Phase 2
- Bot Framework Composer → Écarté au profit de Copilot Studio (plus complet)

**Conséquences :**
- ✅ Déploiement rapide (low-code)
- ✅ Sécurité héritée Microsoft 365
- ⚠️ Dépendance forte à l'écosystème Microsoft
- ⚠️ Personnalisation limitée du pipeline RAG

---

## ADR-002 : SharePoint comme seule source de vérité documentaire RH

**Décision :** Tous les documents RH utilisés par l'agent doivent être déposés dans une bibliothèque SharePoint dédiée.

**Contexte :** Garantir la traçabilité, le contrôle des accès et la simplicité de maintenance pour l'équipe RH non-technique.

**Conséquences :**
- ✅ Les responsables RH gèrent le corpus sans passer par TI
- ✅ Les permissions SharePoint garantissent le security trimming automatique
- ⚠️ Les documents stockés hors SharePoint (réseau local, OneDrive personnel) ne sont pas indexés

---

## ADR-003 : Security trimming activé — pas d'accès anonyme

**Décision :** L'agent n'est accessible qu'aux utilisateurs authentifiés via Azure AD. Le security trimming Azure AI Search est activé.

**Contexte :** Certains documents (ex. : conditions d'un régime pour gestionnaires) ne doivent pas être accessibles à tous.

**Conséquences :**
- ✅ Conformité PIPEDA et respect des niveaux d'accès RH existants
- ⚠️ Les employés sans compte Microsoft 365 actif ne peuvent pas accéder à l'agent

---

## ADR-004 : Dossiers individuels des employés EXCLUS du corpus

**Décision :** Aucun dossier individuel (évaluation, discipline, maladie, paie) ne peut être déposé dans la bibliothèque indexée.

**Contexte :** Risque majeur PIPEDA si l'agent peut être interrogé sur des données personnelles d'un employé.

**Conséquences :**
- ✅ Conformité PIPEDA assurée par design
- ⚠️ L'agent ne peut pas répondre à des questions personnalisées (ex. : « Combien de jours me reste-t-il ? »)
- → Ce cas sera adressé en Phase 2 via intégration avec le SIRH (hors périmètre MVP)

---

# 10. Comparaison Option A vs Option B

| Dimension | Option A (Copilot Studio + SharePoint) — Ce document | Option B (Claude/GPT + Base vectorielle) |
|---|---|---|
| **Délai de déploiement** | 4–8 semaines | 3–6 mois |
| **Compétences requises** | Low-code, Power Platform, SharePoint | Python, LangChain/LlamaIndex, MLOps, DevOps |
| **Infrastructure à gérer** | Aucune (tout géré Microsoft) | Pipeline d'ingestion, base vectorielle, API, monitoring |
| **Sources de données** | SharePoint / M365 principalement | Toutes sources : ERP M3, D365, SQL, fichiers locaux, APIs |
| **Contrôle du pipeline RAG** | Faible (boîte noire Microsoft) | Total (chunking, re-ranking, embeddings personnalisés) |
| **Indépendance fournisseur** | Faible (lock-in Microsoft) | Élevée (LLM et base vectorielle interchangeables) |
| **Qualité RAG optimisable** | Non | Oui |
| **Sécurité** | Héritée de SharePoint + Azure AD (automatique) | À concevoir et implémenter explicitement |
| **Souveraineté des données** | Tenant Microsoft (Canada East) | Dépend des choix d'hébergement |
| **Coût initial** | Faible (configuration) + licences Copilot | Élevé (développement + infrastructure) |
| **Coût récurrent** | Licences par utilisateur (prévisible) | Pay-per-token + infrastructure (variable) |
| **Cas d'usage RH MVP** | ✅ Idéal | ✅ Possible mais sur-dimensionné |
| **Cas d'usage multi-systèmes (M3 + D365 + docs)** | ⚠️ Limité | ✅ Idéal |
| **Recommandation** | **Phase 1 — Quick Win** | **Phase 2 — Industrialisation** |

---

## Annexe A — Licences Microsoft requises

| Produit | Licence | Coût estimé (CAD/mois) | Notes |
|---|---|---|---|
| Microsoft Copilot Studio | Copilot Studio (par locataire + sessions) | ~300–500 $/mois (base) | 25 000 sessions/mois incluses |
| Azure AI Search | Standard S1 | ~250–400 $/mois | Indexation + recherche vectorielle |
| Azure OpenAI GPT-4o | Pay-per-token | ~100–300 $/mois (selon volume) | Variable selon utilisation |
| SharePoint Online | Inclus M365 Business | 0 $ supplémentaire | Déjà licencié |
| Microsoft Teams | Inclus M365 Business | 0 $ supplémentaire | Déjà déployé |
| Power Automate | Inclus M365 Business (flux standards) | 0 $ supplémentaire | Flux SharePoint standard |
| Microsoft Purview | Inclus M365 E3/E5 | Variable selon licence existante | Audit + DLP |

**Coût mensuel récurrent estimé :** 650 $ à 1 200 $ CAD/mois (hors licences M365 existantes)

---

## Annexe B — Questions ouvertes à résoudre avant déploiement

| # | Question | Responsable | Échéance |
|---|---|---|---|
| Q-001 | Quels sont les niveaux d'accès SharePoint par groupe d'employés (syndiqués vs non-syndiqués) ? | RH + TI | Semaine 1 |
| Q-002 | Les documents RH existants sont-ils tous en format textuel (non scannés) ? | RH | Semaine 1 |
| Q-003 | La convention collective actuelle autorise-t-elle l'utilisation d'un agent IA pour informer les employés sur ses clauses ? | RH + Juridique | Semaine 2 |
| Q-004 | Quel est le processus d'escalade disponible durant les heures non-ouvrables ? | RH | Semaine 2 |
| Q-005 | L'entreprise dispose-t-elle déjà des licences Copilot Studio ou faut-il les acquérir ? | TI | Semaine 1 |
