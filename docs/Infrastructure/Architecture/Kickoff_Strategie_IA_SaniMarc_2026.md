# Kickoff — Stratégie IA Sani Marc 2026

> **Document de démarrage** — Par où commencer la transformation IA à Sani Marc  
> Version : 1.0 | Date : Avril 2026 | Statut : Actif

---

## Pourquoi ce document ?

Démarrer une transformation IA sans plan clair est la première cause d'échec. Ce document de kickoff définit les premières étapes concrètes, dans le bon ordre, pour éviter les pièges classiques et générer des succès visibles rapidement.

---

## Vue d'ensemble du Kickoff (90 jours)

```
Semaine 1-2       Semaine 3-4       Semaine 5-8          Semaine 9-12
──────────────────────────────────────────────────────────────────────
MOBILISER    →   DIAGNOSTIQUER  →  PRIORISER       →   LANCER
Équipe & vision   État des lieux    Quick wins          Premier POC
```

---

## Phase 0 — Mobilisation (Semaines 1–2)

### Objectif
Obtenir l'adhésion de la direction et constituer l'équipe de démarrage.

### Actions prioritaires

| # | Action | Responsable | Livrable |
|---|--------|-------------|----------|
| 1 | Présenter la vision IA à la direction (C-suite) | VP TI / DG | Présentation exécutive approuvée |
| 2 | Nommer un **Parrain exécutif** du projet IA | Direction | Lettre de mandat |
| 3 | Identifier le **champion IA** dans chaque département | Management | Liste des champions (8 personnes) |
| 4 | Constituer le **Comité de pilotage IA** (COPIL) | VP TI | Charte COPIL signée |
| 5 | Allouer un budget initial pour Phase 0–1 | Direction | Budget approuvé |

### Équipe minimale de démarrage

```
Direction
  └── Parrain exécutif (VP ou DG)
        └── Chef de projet IA (TI)
              ├── Champion IA — Ventes
              ├── Champion IA — Production
              ├── Champion IA — Support Client
              └── Champion IA — Finances
```

> **Règle d'or** : Sans parrain exécutif visible et engagé, arrêter ici et recommencer.

---

## Phase 1 — Diagnostic (Semaines 3–4)

### Objectif
Comprendre où on est avant de décider où on va.

### 1.1 — Évaluation de la Maturité IA

Évaluer Sani Marc sur les 5 dimensions suivantes (score de 1 à 5) :

| Dimension | Score actuel | Cible 12 mois | Actions requises |
|-----------|:------------:|:-------------:|------------------|
| Données & Infrastructure | ? / 5 | 3 / 5 | Inventaire des sources de données |
| Culture & Compétences | ? / 5 | 2 / 5 | Formation de sensibilisation |
| Gouvernance & Éthique | ? / 5 | 3 / 5 | Politique IA interne |
| Cas d'usage & Valeur | ? / 5 | 3 / 5 | Ateliers départementaux |
| Technologie & Outillage | ? / 5 | 3 / 5 | Audit licences Microsoft 365 |

**Outil** : Atelier de 2h avec les champions IA. Grille de scoring à remplir collectivement.

### 1.2 — Inventaire des Données

Questions clés à répondre :

- Quelles données existent dans **Infor M3** (transactions, stocks, clients) ?
- Quelles données sont dans **Dynamics 365** (CRM, service client) ?
- Y a-t-il déjà un **Data Lake / Databricks** en exploitation ?
- Quelles données sont dans des **Excel / SharePoint** non structurés ?
- Quelles données sont **sensibles** (RH, financier, client) ?

**Livrable** : Cartographie des sources de données (1 page)

### 1.3 — Audit des Licences Microsoft 365

Vérifier ce qui est **déjà disponible** (souvent sous-utilisé) :

| Outil | Disponible ? | Utilisé ? | Potentiel IA |
|-------|:---:|:---:|---|
| Microsoft Copilot (M365) | Oui / Non | Oui / Non | Productivité bureautique |
| Azure OpenAI Service | Oui / Non | Oui / Non | IA Générative sur mesure |
| Power BI + Copilot | Oui / Non | Oui / Non | Analyse prédictive |
| Power Automate | Oui / Non | Oui / Non | Automatisation processus |
| Azure AI Services | Oui / Non | Oui / Non | Vision, Voix, NLP |
| Dynamics 365 Copilot | Oui / Non | Oui / Non | CRM augmenté |

---

## Phase 2 — Priorisation (Semaines 5–8)

### Objectif
Choisir les bons projets, dans le bon ordre, avec les bonnes personnes.

### 2.1 — Ateliers Cas d'Usage (1 atelier par département)

**Format d'un atelier** (2h par département) :
1. Présentation des familles d'IA (30 min)
2. Brainstorming des problèmes à résoudre (45 min)
3. Vote sur les 3 cas d'usage prioritaires (30 min)
4. Évaluation rapide ROI/Complexité (15 min)

**8 ateliers à planifier :**

| Département | Semaine | Animateur |
|-------------|:-------:|-----------|
| Ventes | S5 | Champion IA Ventes + Chef projet IA |
| Support Client | S5 | Champion IA Support + Chef projet IA |
| Production | S6 | Champion IA Production + Chef projet IA |
| Achats | S6 | Champion IA Achats + Chef projet IA |
| Finances | S7 | Champion IA Finances + Chef projet IA |
| Ressources Humaines | S7 | Champion IA RH + Chef projet IA |
| Administration | S8 | Champion IA Admin + Chef projet IA |
| TI | S8 | Équipe TI interne |

### 2.2 — Matrice de Priorisation

Classer chaque cas d'usage dans la grille suivante :

```
         COMPLEXITÉ
              Faible          Haute
         ┌──────────────┬──────────────┐
Haute    │  ★ QUICK WIN │  PLANIFIER   │
VALEUR   │  → Faire d'  │  → Roadmap   │
         │  abord       │  12-24 mois  │
         ├──────────────┼──────────────┤
Faible   │  AUTOMATISER │  ÉVITER      │
VALEUR   │  → Si temps  │  → Reporter  │
         │              │              │
         └──────────────┴──────────────┘
```

### 2.3 — Sélection des Quick Wins (0-6 mois)

Critères de sélection d'un Quick Win :
- ✅ Valeur visible en moins de 3 mois
- ✅ Ne nécessite pas de nouveau système
- ✅ S'appuie sur des licences déjà payées
- ✅ Impacte au moins 5 utilisateurs
- ✅ Champion IA motivé pour le porter

**Quick wins typiques pour Sani Marc :**

| Cas d'usage | Famille IA | Outil | Département | Effort |
|-------------|-----------|-------|-------------|--------|
| Rédaction d'offres de prix avec Copilot | IA Générative | M365 Copilot | Ventes | 2 semaines |
| Résumé automatique des tickets clients | IA Générative | Dynamics 365 Copilot | Support | 2 semaines |
| Tableau de bord prédictif des stocks | IA Prédictive | Power BI Copilot | Achats/Prod. | 4 semaines |
| Assistant RH pour FAQ employés | IA Générative | Copilot Studio | RH | 4 semaines |
| Rapport financier automatisé | IA Générative | M365 Copilot + Excel | Finances | 3 semaines |
| Classification des bons de commande | IA Générative | Azure AI + Power Automate | Achats | 3 semaines |

---

## Phase 3 — Premier POC (Semaines 9–12)

### Objectif
Livrer un résultat concret avant la fin du trimestre pour maintenir la mobilisation.

### Critères d'un bon premier POC

- **Simple** : maximum 2 systèmes intégrés
- **Mesurable** : KPI clair défini avant de commencer
- **Rapide** : résultat en 4 semaines maximum
- **Visible** : démonstrable à toute la direction

### Structure d'un POC

```
Semaine 1 : Cadrage
  ├── Définir le problème précis
  ├── Définir le KPI de succès
  ├── Identifier les données nécessaires
  └── Valider avec le champion IA

Semaine 2-3 : Construction
  ├── Accès aux données/systèmes
  ├── Configuration de l'outil IA
  ├── Tests avec utilisateurs clés
  └── Ajustements

Semaine 4 : Validation
  ├── Démonstration au COPIL
  ├── Mesure du KPI
  ├── Décision : arrêter / ajuster / déployer
  └── Documentation des apprentissages
```

### Gabarit de fiche POC

```markdown
## POC — [Nom du cas d'usage]
- **Département** : ...
- **Problème** : ...
- **Solution IA** : ...
- **KPI de succès** : ...
- **Données requises** : ...
- **Outil utilisé** : ...
- **Champion IA** : ...
- **Durée** : 4 semaines
- **Budget** : ...
```

---

## Jalons et Gouvernance

### Réunions de suivi

| Réunion | Fréquence | Participants | Durée |
|---------|-----------|--------------|-------|
| COPIL IA | Mensuel | Direction + Champions + Chef projet | 1h |
| Stand-up équipe IA | Hebdomadaire | Champions + Chef projet | 30 min |
| Revue POC | À la fin de chaque POC | COPIL + Équipe POC | 1h |
| Bilan trimestriel | Trimestriel | Direction élargie | 2h |

### Jalons des 90 premiers jours

```
Semaine 2  ✓ Parrain exécutif nommé
           ✓ Champions IA identifiés
           ✓ Budget Phase 0-1 approuvé

Semaine 4  ✓ Maturité IA évaluée
           ✓ Inventaire données complété
           ✓ Audit licences Microsoft terminé

Semaine 8  ✓ 8 ateliers cas d'usage complétés
           ✓ Quick wins sélectionnés (top 3)
           ✓ Premier POC choisi et cadré

Semaine 12 ✓ Premier POC livré et évalué
           ✓ Décision de passage à la Phase 1 (Fondation)
           ✓ Roadmap 12 mois validée par la direction
```

---

## Facteurs Critiques de Succès

| Facteur | Description | Risque si absent |
|---------|-------------|-----------------|
| **Parrainage exécutif** | Un VP ou DG visible et engagé | Projet abandonné en 3 mois |
| **Quick win visible** | Succès concret dans les 90 jours | Perte de crédibilité et de budget |
| **Champions IA motivés** | Ambassadeurs dans chaque département | Résistance au changement |
| **Données accessibles** | Accès aux données M3 et D365 | Impossibilité de construire les POC |
| **Formation de base** | Sensibilisation de tous les employés | Peur et rejet de l'IA |
| **Communication régulière** | Avancement partagé à toute l'entreprise | Rumeurs et démobilisation |

---

## Prochaines Étapes Immédiates

> À faire cette semaine :

- [ ] **JOUR 1** — Présenter ce document à la direction
- [ ] **JOUR 2** — Identifier et confirmer le Parrain exécutif
- [ ] **JOUR 3** — Nommer le Chef de projet IA (interne ou externe)
- [ ] **SEMAINE 1** — Planifier les 8 ateliers departementaux (S5-S8)
- [ ] **SEMAINE 2** — Lancer l'audit des licences Microsoft 365

---

## Références et Ressources

| Document | Localisation |
|----------|-------------|
| Stratégie IA complète (5 ans) | `docs/Infrastructure/Architecture/Strategie_IA_SaniMarc_2026.md` |
| Architecture chatbot IA | `docs/Architecture-Chatbot-IA-Sani-Marc.md` |
| Formation IA par département | `docs/Formation-IA/` |
| Agent Architecte IA (assistant) | `.github/agents/agent-architecte-ia-entreprise.agent.md` |

---

*Document préparé par l'Architecte IA Entreprise — Sani Marc | Avril 2026*
