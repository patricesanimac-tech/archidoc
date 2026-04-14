# Architecture de Solution - Chatbot IA Générative

## Sani Marc - Support Clientèle Intelligent

**Version:** 1.0  
**Date:** 2026-04-07  
**Auteur(s):** Architecture Team  
**Statut:** Prêt pour révision CTO  
**Classification:** Interne

---

## Résumé exécutif

Le Chatbot IA Générative Sani Marc est une plateforme conversationnelle alimentée par GPT-4 qui permet aux agents du Support Clientèle de trouver rapidement et précisément les réponses à leurs questions en langage naturel, basées sur la documentation interne (procédures, fiches produits, guides). 

**Objectifs clés:** Réduire temps de réponse de 30%, augmenter adoption à 200+ agents, scorer >70% d'acceptation de réponses IA.

**Approche:** Design progressif en 3 phases (Pilote 8 semaines → Expansion 8 semaines → Optimization). Architecture RAG (Retrieval-Augmented Generation) pour grounding documentaire, déploiement AWS Fargate haute disponibilité Multi-AZ (SLA 99.5%), compliance RGPD complète.

**Budget:** $500K CAD (design + build + déploiement pilot)

---

## Historique des versions

| Version | Date | Auteur | Description des changements |
|---------|------|--------|----------------------------|
| 1.0 | 2026-04-07 | Architecture Team | Conception initiale - Pilote |

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
9. [Décisions architecturales projet](#9-décisions-architecturales-projet)

---

# 1. Contexte du projet

## 1.1 Vue d'ensemble

### 1.1.1 Objectif du document

Ce document décrit l'**Architecture de Solution** pour le **Chatbot IA Générative interne de Sani Marc**. 

Il détaille la conception fonctionnelle et technique d'une plateforme d'IA générative permettant aux agents du Support Clientèle de poser des questions en langage naturel et d'obtenir des réponses fiables, contextualisées et basées sur la documentation interne de l'entreprise.

**Audience:**
- Directeur IT & Architecture (sponsor)
- Équipe Support Clientèle (utilisateurs finaux)
- Équipe Développement (implémentation)
- Comité de gouvernance architecture

**Ce document NE couvre PAS:**
- Formation détaillée des utilisateurs
- Procédures opérationnelles d'administration complètes
- Maintenance matérielle des serveurs AWS

### 1.1.2 Portée du projet

**Inclus dans ce projet:**
- Plateforme chatbot conversationnel bilingue (FR/EN)
- Intégration avec documentation interne (procédures, fiches produits, guides)
- Moteur d'IA générative basé sur OpenAI GPT-4
- Interface utilisateur responsive (web + chat widget)
- Système d'audit et traçabilité complet
- Support pour agents (50-200 utilisateurs)
- Déploiement progressif (pilote → full scale)

**Exclus de ce projet (hors scope):**
- Intégration système SOS (CRM) - confirmer séparation
- Formation RH des agents utilisateurs (responsabilité métier)
- Intégration réseaux sociaux (Facebook Messenger, WhatsApp)
- Maintenance infrastructure AWS (DevOps responsable)

### 1.1.3 Relation avec l'Architecture d'Entreprise

Ce projet s'inscrit dans la **Phase 1 : Modernisation digitale - Support Clientèle** et contribue aux capacités métier suivantes:
- **Accélération résolution tickets**
- **Amélioration accès connaissance**
- **Réduction coûts support**
- **Qualité service client**

**Alignement avec principes d'entreprise:**
- Transparence de l'IA (sources citées, confiance)
- Respect de la vie privée (audit des interactions, RGPD prêt)
- Qualité & fiabilité (grounding documentaire, test)
- Évolutivité (scalable à 500+ agents)

## 1.2 Objectifs du projet

### 1.2.1 Objectifs métier

| ID | Objectif | Métrique de succès | Échéance |
|---|----------|-------------------|----------|
| OBJ-001 | Réduire temps moyen de réponse aux demandes support | Diminution de 30% en 6 mois | Q2 2026 |
| OBJ-002 | Augmenter taux de résolution proposées par IA | Propositions IA acceptées > 70% | Q3 2026 |
| OBJ-003 | Augmenter satisfaction agents support | NPS > 7/10 après 3 mois | Q2 2026 |
| OBJ-004 | Centraliser base de connaissance | 100% documentation structurée | Q1 2026 |
| OBJ-005 | Support multilingue transparent | FR & EN avec basculement automatique | Q1 2026 |

### 1.2.2 Critères d'acceptation

**Fonctionnels:**
- Chatbot peut répondre à questions en FR & EN en < 3 secondes
- Réponses citent sources (documentation, procédures) avec confiance score
- Interface utilisateur intuitive pour agents support
- Historique complet des interactions (audit trail)
- Gestion automatique des situations "pas de réponse" (escalade)

**Non-fonctionnels:**
- Performance: Latence p95 < 3 secondes
- Disponibilité: SLA 99.5% heures de bureau
- Scalabilité: Support 500+ utilisateurs simultanés
- Sécurité: Chiffrement end-to-end, authentification SSO
- Auditabilité: Logs complets, traçabilité utilisateurs

## 1.3 Parties prenantes

### 1.3.1 Équipe projet

| Rôle | Nom | Responsabilité | Disponibilité |
|---|---|---|---|
| **Architecture Lead** | [À assigner] | Conception architecture, décisions techniques, ADR validation | 100% |
| **Product Manager** | [À assigner] | Backlog, priorités, acceptance criteria, roadmap | 100% |
| **Tech Lead Backend** | [À assigner] | Implémentation orchestration, APIs, code reviews, perf optimization | 100% |
| **ML Engineer** | [À assigner] | Fine-tuning LLM, RAG optimization, vector search tuning | 80% |
| **DevOps Engineer** | [À assigner] | Infrastructure AWS, monitoring, CI/CD, incident response | 80% |
| **Support Manager (Pilot)** | [À assigner] | Feedback utilisateurs, pilot validation, training, change management | 50% |
| **Security Officer** | [À assigner] | Threat modeling, pentest, compliance (RGPD), security reviews | 30% |
| **QA / Test Lead** | [À assigner] | Load testing, integration testing, UAT coordination | 70% |

### 1.3.2 Sponsors et décideurs

- **Sponsor exécutif:** VP Support Client & Operations
- **Sponsor métier:** Head of Customer Support
- **Comité de validation architecture:** CTO + Arch Review Board

## 1.4 Exigences

### 1.4.1 Exigences fonctionnelles prioritaires

| ID | User Story | Priorité | Estimation | Sprint |
|---|-----------|----------|------------|--------|
| RF-001 | Agent pose question en langage naturel → Chatbot répond avec source | **P0** | 8 semaines | S1-S2 |
| RF-002 | Support français ET anglais avec détection automatique | **P0** | 4 semaines | S1 |
| RF-003 | Historique complet des questions/réponses par agent | **P0** | 3 semaines | S1 |
| RF-004 | Admin peut importer/mettre à jour documentation base connaissance | **P0** | 5 semaines | S1-S2 |
| RF-005 | Chatbot escalade intelligent vers agent humain si confiance basse | **P1** | 3 semaines | S2 |
| RF-006 | Feedback agent sur qualité réponse (useful/not useful) | **P1** | 2 semaines | S2 |
| RF-007 | Analytics: dashboards utilisation, topics populaires, satisfaction | **P1** | 4 semaines | S2-S3 |
| RF-008 | Multi-document search avec ranking par pertinence | **P2** | 3 semaines | S3 |

### 1.4.2 Exigences non-fonctionnelles

| ID | Catégorie | Exigence | Critère d'acceptation | Priorité |
|---|---|---|---|---|
| RNF-001 | Performance | Latence réponse IA | < 3 secondes p95 | **P0** |
| RNF-002 | Performance | Throughput | 100 req/sec minimum | **P0** |
| RNF-003 | Disponibilité | Uptime heures bureau | 99.5% SLA | **P0** |
| RNF-004 | Disponibilité | Recovery après dysfonctionnement | RTO < 15m, RPO < 1h | **P0** |
| RNF-005 | Scalabilité | Utilisateurs simultanés | 500+ agents sans dégradation | **P1** |
| RNF-006 | Sécurité | Chiffrement données | TLS 1.3 en transit, AES-256 au repos | **P0** |
| RNF-007 | Sécurité | Authentification | SSO Active Directory + MFA optionnel | **P0** |
| RNF-008 | Audit | Traçabilité interactions | Logs complets (qui, quoi, quand, résultat) | **P0** |
| RNF-009 | Conformité | RGPD readiness | Consentement, anonymisation optionnelle | **P1** |
| RNF-010 | Maintenabilité | Code coverage | > 80% tests unitaires | **P1** |

## 1.5 Contraintes

### 1.5.1 Contraintes techniques
- **LLM:** OpenAI GPT-4 imposé par direction (pas d'alternatives locales pour MVP)
- **Infrastructure:** AWS uniquement (contrat MultiYears AWS)
- **Budget:** 500k$ CAD pour design + build + déploiement pilote
- **Documentation:** Code en anglais, documentation métier en FR/EN

### 1.5.2 Contraintes temporelles
- **Pilote production:** Fin Q2 2026 (8-10 semaines)
- **Rollout phase 1:** 50-100 agents (Q3 2026)
- **Full scale:** 200+ agents (Q4 2026)
- **Gelé avant vacances:** Pas de déploiement juillet-août

### 1.5.3 Contraintes réglementaires
- **RGPD:** Respect du droit à l'oubli, consentement explicite
- **Accessibilité:** WCAG 2.1 AA minimum (interface web)
- **Conformité données:** Données client sensibles → chiffrement + audit
- **Transparence IA:** Décisions IA doivent être explicables (sources cités)

## 1.6 Hypothèses et risques

### 1.6.1 Hypothèses

| ID | Hypothèse | Impact si fausse | Probabilité |
|---|-----------|---|---|
| HYP-001 | Documentation existante est suffisante pour MVP | Retard de 2-3 semaines | Moyenne |
| HYP-002 | OpenAI API disponible et performante (pas de throttling) | Latence > 5s, mauvaise UX | Faible |
| HYP-003 | Agents adoptent outil rapidement (pas de résistance) | Utilisation faible, pilot échoue | Moyenne-Haute |
| HYP-004 | Pas de modification majeure besoin métier pendant pilot | Scope creep, delay | Moyenne |
| HYP-005 | Budget 500k$ cohérent avec périmètre | Incomplétion phases | Faible |

### 1.6.2 Dépendances externes

| Dépendance | Fournisseur | Impact | Plan de contingence |
|---|---|---|---|
| OpenAI GPT-4 API | OpenAI | Service complètement bloqué si API down | Fallback mode read-only sur base docs statique |
| AWS Services | Amazon | Infrastructure indisponible | Multi-AZ + failover automatique |
| Documentation source | Support Métier | Qualité base connaissance | Audit documentation, validation avant import |
| Données de test | Support Clientèle | Pas de scénarios réalistes | Extraction de tickets historiques SOS |

### 1.6.3 Registre des risques projet

| ID | Risque | Probabilité | Impact | Mitigation | Propriétaire |
|---|---|---|---|---|---|
| RISK-001 | Qualité réponses IA insuffisante (hallucinations) | Haute | Élevé | RAG strict (grounding), feedback loop | ML Engineer + Product |
| RISK-002 | Surcoûts API OpenAI (usage imprévu) | Moyenne | Moyen | Budget tracking, rate limiting, monitoring | DevOps + Finance |
| RISK-003 | Adoption faible par agents (préfèrent méthodes actuelles) | Moyenne | Élevé | Pilots progressifs, formation, quick wins | Support Manager |
| RISK-004 | Délai obtention documentation structurée | Moyenne | Moyen | Commencer avec 30% docs cruciaux, itérer | Product Manager |
| RISK-005 | Sécurité: données sensibles exposées en logs | Faible | Critique | Masquage données, audit logs, SIEM | Security Officer |
| RISK-006 | Performance dégradée à 100+ utilisateurs | Moyenne | Moyen | Load testing, cache layer, async queues | DevOps + Tech Lead |
| RISK-007 | Compatibilité multilingue (Anglais ≠ Français) | Basse | Moyen | Prompt engineering, test exhaustif FR/EN | ML Engineer |

---

# 2. Architecture fonctionnelle

## 2.1 Vue d'ensemble fonctionnelle

### 2.1.1 Contexte système (C4 - Niveau 1)

```
┌─────────────────────────────────────────────────────────────┐
│                    Sani Marc Organization                   │
│                                                               │
│  ┌──────────────┐                    ┌──────────────────┐   │
│  │   Agents     │◄──────────────────►│  Chatbot IA      │   │
│  │   Support    │   Conversations    │  Générative      │   │
│  │ (50-200)     │                    │  (Internal)      │   │
│  └──────────────┘                    │                  │   │
│                                       │  • Questions FR/EN│   │
│  ┌──────────────┐                    │  • Réponses docs │   │
│  │   Internal   │◄───Ingériênt───►  │  • Audit trail   │   │
│  │   Knowledge  │    Documents       │                  │   │
│  │   Docs       │                    └──────────────────┘   │
│  │ (Procédures, │                              ▲            │
│  │  Fiches      │                              │ API Calls  │
│  │  Produits,   │                              ▼            │
│  │  FAQ, etc)   │                    ┌──────────────────┐   │
│  └──────────────┘                    │  OpenAI          │   │
│                                       │  GPT-4 API       │   │
│  ┌──────────────┐                    │  (External)      │   │
│  │   Support    │                    └──────────────────┘   │
│  │   Manager    │                                            │
│  │   (Admin)    │◄────Administration──────────────────┐     │
│  └──────────────┘                                     │     │
│                                       ┌───────────────┴──┐  │
│                                       │  Admin Console   │  │
│                                       │  • Docs mgmt     │  │
│                                       │  • Analytics     │  │
│                                       │  • Modération    │  │
│                                       └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

**Description systémique:**  
Le Chatbot IA Générique est une composante centralisée, interne à Sani Marc, qui orchestre:
1. **Interactions agents** (questions FR/EN, obtention réponses)
2. **Intégration connaissance** (ingestion docs, actualisation)
3. **Invocation LLM** (appels API OpenAI GPT-4)
4. **Administration** (gestion docs, monitoring, audit)

### 2.1.2 Acteurs du système

| Acteur | Type | Responsabilités | Volumétrie | Fréquence |
|---|---|---|---|---|
| **Agent Support** | Utilisateur primaire | Poser questions au chatbot, valider réponses, feedback | 50-200 agents de jour | 20-50 questions/jour par agent |
| **Support Manager** | Utilisateur secondaire | Monitoring dashboards, escalation humaine si besoin | 5-10 managers | 2-3 fois/jour |
| **Administrator** | Administrateur système | Importer/mettre à jour documentation, gérer utilisateurs | 1-2 admins | Quotidien |
| **OpenAI API** | Service externe | Générer réponses via GPT-4, embeddings | - | À la demande (synchrone) |
| **Documentation System** | Système source | Documents existants (procédures, FAQs, fiches produits) | - | Mises à jour périodiques |
| **Audit Logs** | Système de suivi | Tracer toutes interactions, décisions | - | En temps réel |

## 2.2 Processus métier implémentés

### 2.2.1 Processus principal: Recherche d'information et résolution de demande support

**Diagramme BPMN (simplifié):**

```
          ┌─────────────────────┐
          │ Agent pose question │
          │ en langage naturel  │
          └──────────┬──────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  Enrichissement Query  │
        │  • Normalisation FR/EN │
        │  • Extraction contexte │
        └──────────┬─────────────┘
                   │
        ┌──────────▼──────────┐
        │ Vector Embedding    │────────┐
        │ Query via OpenAI    │        │
        └─────────────────────┘        │
                   │                   │
                   └──────────┬────────┘
                              │
                   ┌──────────▼──────────┐
                   │ Similarity Search   │
                   │ in Knowledge Base   │
                   │ (Vector DB)         │
                   └──────────┬──────────┘
                              │
                   ┌──────────▼──────────┐
                   │ Retrieval Context   │
                   │ • Top-3 docs        │
                   │ • Relevance scores  │
                   └──────────┬──────────┘
                              │
                   ┌──────────▼──────────┐
                   │ Generate Answer     │
                   │ via GPT-4           │
                   │ (RAG Prompt)        │
                   └──────────┬──────────┘
                              │
           ┌──────────────────┼──────────────────┐
           │                  │                  │
    ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐
    │  Answer     │   │  No Answer  │   │ Error/       │
    │  Generated  │   │  Found      │   │ Timeout      │
    │  OK         │   │             │   │ (Fallback)   │
    └──────┬──────┘   └──────┬──────┘   └──────┬──────┘
           │                 │                 │
    ┌──────▼──────────────────▼────────────────▼──────┐
    │         Return Response to Agent        │
    │  • Answer text (FR/EN)                 │
    │  • Source citations with links         │
    │  • Confidence score (0-1)              │
    │                                        │
    └──────┬───────────────────────────────────┘
           │
    ┌──────▼────────────────┐
    │ Agent Reviews Answer  │
    ├─────────────────────┬─┘
    │                     │
┌───┴──────┐          ┌───┴──────┐
│ Useful   │          │Not useful │
│ (Ack)    │          │ (Escalate)│
└──────────┘          └───┬──────┘
                          │
              ┌───────────▼────────────┐
              │  Log Feedback         │
              │  Retrain Model Loop   │
              │ (for optimization)    │
              └──────────────────────┘
```

**Détails du processus:**
- **Déclencheur:** Agent Submit question en chat
- **Fréquence:** Continu (24/7 pendant heures support)
- **Durée moyenne:** 2-3 secondes (client attend réponse instantanée)
- **Acteurs impliqués:** Agent, Chatbot, OpenAI, Knowledge Base

**Scénarios d'exception:**
1. **API OpenAI timeout:** Fallback à réponse "Je ne peux pas répondre" + escalade
2. **Aucun document pertinent trouvé:** Réponse "Aucune information trouvée, veuillez contacter support"
3. **Erreur intégration:** Log erreur, afficher message utilisateur, notifier admin
4. **Langue ambiguë:** Détecter langue, confirmner avec agent ou basculer automatique

---

## 2.3 Cas d'utilisation principaux

### UC-001: Poser une question produit

**Acteur principal:** Agent Support  
**Objectif:** Obtenir rapidement information détaillée sur un produit sanitaire Sani Marc

**Préconditions:**
- Agent est connecté au chatbot
- Documentation produit est présente dans la base de connaissance
- Réseauconnecté à OpenAI API

**Scénario nominal:**
1. Agent tape question: "Quels sont les ingrédients actifs du désinfectant Sani-X?"
2. Chatbot enrichit requête (détecte contexte produit)
3. Chatbot recherche documents pertinents (embedding + similarity)
4. Chatbot envoie prompt RAG à OpenAI GPT-4
5. GPT-4 génère réponse structurée avec sources
6. Chatbot affiche réponse à l'agent avec links vers fiches produit
7. Agent valide réponse (useful / not useful)

**Scénarios alternatifs:**
- **No knowledge:** Réponse "Veuillez consulter la fiche produit Sani-X ou contacter le manager"
- **Ambiguous question:** Chatbot demande clarification: "Parlez-vous du Sani-X Classic ou Sani-X Pro?"
- **Language mix:** Chatbot détecte FR + EN, répond en FR ou EN selon langue dominante

**Exigences spéciales:**
- Réponse < 3 secondes
- Source doit être citable (ex: "Fiche Sani-X v2.1 (04-2026)")
- Si réponse partially réussie, indiquer "Plus qu'une réponse complète serait..."

### UC-002: Dépannage problème client

**Acteur principal:** Agent Support  
**Objectif:** Diagnostic rapide et solutions pour problème client

**Préconditions:**
- Agent a contexte du problème du client
- Procédures de dépannage sont dans la base de connaissance
- Problème est technique (pas commercial)

**Scénario nominal:**
1. Agent demande: "La dilution du produit XYZ n'est pas correcte, comment vérifier?"
2. Chatbot récupère procédures de dépannage pertinentes
3. GPT-4 génère guide pas-à-pas en FR/EN
4. Chatbot affiche avec format lisible, étapes numérotées
5. Agent peut escalader vers technician si complexe

**Exigences spéciales:**
- Procédures doivent être step-by-step, pas narratives
- Inclure sécurité/warnings si pertinent
- Lier vers documents complémentaires si besoin

### UC-003: Gérer la base de connaissance (Admin)

**Acteur principal:** Administrator  
**Objectif:** Importer, actualiser, ou supprimer documents de la base

**Préconditions:**
- Admin a droits d'accès
- Document au format PDF/TXT/Markdown reconnu

**Scénario nominal:**
1. Admin accède console d'administration
2. Sélectionne "Importer document"
3. Upload fichier fiche produit (ex: Sani-X_v3_FT.pdf)
4. Système crée embeddings (via OpenAI)
5. Ajoute au vector store
6. Archive version antérieure
7. Notifie agents de mise à jour

**Exigences spéciales:**
- Déduplication automatique (si document similaire déjà présent)
- Versioning (garder historique)
- Indexation doit être < 1min par doc (100 pages)

---

## 2.4 Modèle de domaine fonctionnel

### 2.4.1 Diagramme conceptuel

```
┌─────────────────────────────┐
│     Support Agent           │
├─────────────────────────────┤
│ - id (UUID)                 │
│ - firstName, lastName       │
│ - email                     │
│ - role (Agent/Manager/Admin)│
│ - language_preference (FR/EN)
└────────────┬────────────────┘
             │ Asks
             │
             ├───────────────┐
             │               │
        ┌────▼──────┐   ┌────▼──────────┐
        │ Question  │   │ Conversation  │
        ├───────────┤   ├───────────────┤
        │ - id      │   │ - id (UUID)   │
        │ - text    │   │ - agent_id    │
        │ - lang    │   │ - created_at  │
        │ - created_│   │ - messages[]  │
        │   at      │   └───────────────┘
        └────┬──────┘
             │
             ├──◄─────────┐
             │            │
        ┌────▼──────┐ ┌───▼──────────┐
        │   Query   │ │   Response   │
        ├───────────┤ ├──────────────┤
        │ - id      │ │ - id         │
        │ - text    │ │ - text (FR)  │
        │ - embed   │ │ - text (EN)  │
        │   ding    │ │ - sources[]  │
        │ - lang    │ │ - confidence │
        │ - context │ │ - feedback   │
        └───────────┘ │   (useful/   │
                      │    not)      │
                      └──────────────┘
                           
        ┌──────────────────────────┐
        │ Knowledge Document       │
        ├──────────────────────────┤
        │ - id (UUID)              │
        │ - title                  │
        │ - content                │
        │ - type (Procedure/       │
        │   Product/FAQ/Guide)     │
        │ - language (FR/EN)       │
        │ - version                │
        │ - source_url             │
        │ - embeddings (vector)    │
        │ - last_updated           │
        │ - created_by (Admin)     │
        └──────────────────────────┘
```

### 2.4.2 Concepts métier clés

| Concept | Définition | Propriétés | Règles |
|---------|-----------|-----------|---------|
| **Question** | Requête en langage naturel posée par agent support | ID unique, texte, langue détectée, timestamp, contexte optionnel | Doit être < 500 chars, > 3 chars, texte valide |
| **Réponse** | Résultat généré par LLM basé sur documents pertinents (RAG) | Texte FR/EN, sources citées, score confiance (0-1), timestamp | Doit citer sources, score > 0.3 pour afficher |
| **Document** | Élément base de connaissance (fiche produit, procédure, FAQ) | ID, titre, contenu, type, version, embeddings vectoriels | Unique per version, immutable après version, archivable |
| **Embedding** | Représentation vectorielle d'un document ou question | Vector float[1536] (OpenAI), langue, timestamp | Généré via API OpenAI Embedding model |
| **Feedback** | Validation agent sur qualité réponse | Agent ID, response ID, rating (useful=1/not=0), comment optionnel | Utilisé pour fine-tuning et monitoring |
| **Audit Log** | Trace complète interaction (security, compliance) | ID, user, action, timestamp, contexte, source IP | Immuable, retenti minimum 1 an |

---

## 2.5 Interfaces utilisateur

### 2.5.1 Architecture de navigation

```
Chatbot IA - Navigation principale

┌─────────────────────────────────────────┐
│          Login / SSO / Dashboard         │
├─────────────────────────────────────────┤
│ Main Navigation                         │
│  • Chat (Primary)                       │
│  • History / Conversations              │
│  • Knowledge Search (Advanced)          │
│  • Help & Documentation                 │
│  • [Admin only] Admin Console           │
├─────────────────────────────────────────┤
│                                         │
│  ┌───────────────┐  ┌────────────────┐ │
│  │  Chat View    │  │  History Pane  │ │
│  │               │  │ (Sidebar)      │ │
│  │ • New chat    │  │ • Recent chats │ │
│  │ • Type Q      │  │ • Search past  │ │
│  │ • View A      │  │ • Clear        │ │
│  │ • Feedback    │  │                │ │
│  │ • Copy A      │  │                │ │
│  └───────────────┘  └────────────────┘ │
│                                         │
│  ┌────────────────────────────────────┐ │
│  │  Admin Console (if Admin role)      │ │
│  │  • Document Management              │ │
│  │  • Analytics Dashboard              │ │
│  │  • User Management                  │ │
│  │  • Audit Logs                       │ │
│  └────────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### 2.5.2 Écrans principaux

| Écran | Route | Rôle(s) | Fonctionnalités clés |
|-------|-------|---------|---------------------|
| **Chat** | `/chat` | Agent, Manager | Question input, réponse display, source links, feedback buttons |
| **History** | `/history` | Agent, Manager | Lister conversations, search, export, clear |
| **Admin - Docs** | `/admin/documents` | Admin | Upload docs, manage versions, delete, preview embeddings |
| **Admin - Analytics** | `/admin/analytics` | Admin, Manager | Dashboard KPIs, top questions, response quality metrics |
| **Admin - Logs** | `/admin/logs` | Admin | Query logs, filter par user/timestamp/action, export CSV |
| **Settings** | `/settings` | Agent | Language preference, notification settings |

### 2.5.3 Écran Chat (Détail)

```
┌──────────────────────────────────────────────────────┐
│  Sani Marc - Chatbot IA Support                     │
├──────────────────────────────────────────────────────┤
│  Welcome Agent! Questions? Posez votre question...  │
├──────────────────────────────────────────────────────┤
│                                                      │
│  ┌────────────────────────────────────────────────┐ │
│  │ System: Pour commencer, posez une question sur  │ │
│  │ nos produits ou procédures de support. Je vais │ │
│  │ chercher les réponses dans notre documentation. │ │
│  └────────────────────────────────────────────────┘ │
│     12:30                                            │
│                                                      │
│  ┌────────────────────────────────────────────────┐ │
│  │ Agent: Quel est la meilleure dilution pour     │ │
│  │ le Sani-Clean pour le nettoyage de carrelage? │ │
│  └────────────────────────────────────────────────┘ │
│                                                      │
│  ┌────────────────────────────────────────────────┐ │
│  │ Bot: Pour le Sani-Clean sur carrelage, il est │ │
│  │ recommandé une dilution de 1:10 (10% produit) │ │
│  │ avec de l'eau tiède. Laisser agir 5 minutes.  │ │
│  │                                                │ │
│  │ Sources:                                       │ │
│  │ • Fiche technique Sani-Clean v2.1 (Sec. 4)   │ │
│  │ • Guide application produits (p.23)           │ │
│  │                                                │ │
│  │ Confiance: 89% [Useful] [Not useful] [Copy]  │ │
│  └────────────────────────────────────────────────┘ │
│     12:32                                            │
│                                                      │
│  ┌────────────────────────────────────────────────┐ │
│  │ Your message...                   [Send] [Voice]│ │
│  └────────────────────────────────────────────────┘ │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

# 3. Architecture de solution

## 3.1 Vue d'ensemble de la solution

### 3.1.1 Architecture en conteneurs (C4 - Niveau 2)

```
AWS Cloud (us-east-1 + us-east-1b backup)

┌────────────────────────────────────────────────────────────┐
│ ALB (Application Load Balancer)                            │
│ • SSL/TLS termination (*.sanimarc.corp)                   │
│ • Route /api → Backend, /web → Frontend                   │
└────────────────────────────────────────────────────────────┘
         │                          │
         ▼                          ▼
    ┌─────────────────┐      ┌──────────────────┐
    │  Backend API    │      │  Frontend (React)│
    │  (FastAPI/Py)  │      │  (Static Assets) │
    │                 │      │  | + Chat Widget │
    │ ECS Fargate:    │      │                  │
    │ • 3-4 tasks    │      │ CloudFront CDN   │
    │ • Auto-scale    │      │ • Global cache   │
    │ • Health check  │      │ • Edge caching   │
    │                 │      │                  │
    │ Port: 8000      │      │ Port: 443 (HTTPS)│
    └────────┬────────┘      └──────────────────┘
             │
    ┌────────┴─────────────────────────────────┐
    │                                           │
    ▼                                           │
└──────────────────────────┐                   │
│ RAG Orchestration Layer  │                   │
│ • Query encoding        │                   │
│ • Vector similarity     │                   │
│ • Prompt construction   │                   │
│ • Response parsing      │                   │
└──────────────────────────┘                   │
    │            │            │                │
    ▼            ▼            ▼                │
┌──────────┐ ┌─────────┐ ┌──────────────────┐ │
│ Vector   │ │  Query  │ │  LLM Provider    │ │
│ Store    │ │ Cache   │ │ (OpenAI GPT-4)   │ │
│ (Pinecone)│ │ (Redis) │ │ • /completions  │ │
│          │ │ 1-hour  │ │ • /embeddings   │ │
│ 1K+ docs │ │ TTL    │ │                  │ │
│ Embeddings│ │        │ │ External Service│ │
└──────────┘ └─────────┘ └──────────────────┘
    │
    ▼
┌─────────────────────────────────────────┐
│ PostgreSQL RDS (Primary Database)       │
│ • Agent sessions (conversation history) │
│ • Feedback & ratings                    │
│ • Documents metadata                    │
│ • Audit logs (immutable)                │
│ • User profiles + SSO mapping           │
│                                         │
│ Multi-AZ: Primary (us-east-1a)         │
│           Standby (us-east-1b)         │
│ Backup: Daily snapshots (30-day retain)│
└─────────────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────┐
│ S3 (Document Storage)            │
│ • Raw docs (PDF, TXT, MD)       │
│ • Processed documents           │
│ • Audit logs archive            │
│ • Versioning enabled            │
│ • Replication to secondary      │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│ External Services                │
├──────────────────────────────────┤
│ • OpenAI API (GPT-4 + Embedding) │
│ • AD/SSO (Corp auth)             │
│ • CloudWatch (Monitoring)        │
│ • EventBridge (Event bus)        │
└──────────────────────────────────┘
```

### 3.1.2 Style architectural

**Architecture choisie:** **Event-driven microservices hybrid + RAG (Retrieval-Augmented Generation)**

**Justification:**
1. **Scalabilité horizontale:** Chaque composant (orchestration, caching) peut scale indépendamment
2. **Résilience:** Fallback chains (cache → static docs → human escalation)
3. **RAG pattern obligatoire:** LLM seul = hallucinations → grounding documentaire essentiel
4. **Cost optimization:** Pay-as-you-go serverless où possible (Lambda, Fargate)
5. **Separation of concerns:** Orchestration distincte de LLM provider (portable vers Llama Plus tard)

### 3.1.3 Patterns architecturaux appliqués

1. **RAG (Retrieval-Augmented Generation)**
   - Encodage query → vector embedding
   - Similarity search contra doc base
   - Prompt construction avec contexte pertinent

2. **API Gateway Pattern**
   - ALB/API Gateway single entry point
   - Authentification centralisée
   - Rate limiting, throttling

3. **Cache-Aside Pattern**
   - Redis cache pour question fréquentes
   - TTL 1 heure (docs changent pas souvent)
   - Cache misses → vector search

4. **Circuit Breaker**
   - OpenAI API failure → fallback static response
   - health checks ECS Fargate

5. **CDC (Change Data Capture)**
   - Document updates → PG trigger → event → vector index update
   - Async processing queue (SQS)

6. **CQRS (Separation Commands/Queries)**
   - Write: Question + Feedback
   - Read: Conversation history + analytics
   - Separate read replicas for dashboards

---

## 3.2 Composants applicatifs

### 3.2.1 Frontend

**Technologies:** React 18, TypeScript, Tailwind CSS, shadcn/ui

**Responsabilités:**
- Interface utilisateur conversationnelle (chat widget)
- Gestion locale session utilisateur
- Affichage réponses avec markdown rendering
- Source citations avec hyperlienks
- Feedback interface (useful/not useful)
- History pane avec search

**Déploiement:** CloudFront + S3 static hosting  
**Bundle size:** < 500KB (gzipped)

### 3.2.2 Backend - RAG Orchestration (FastAPI)

**Technologies:** Python 3.11, FastAPI, Pydantic, SQLAlchemy, async/await

**Responsabilités:**
- Request validation + authentication (SSO)
- Query preprocessing (normalisation, langue detection)
- Vector embedding + similarity search
- RAG prompt construction
- LLM API calls (OpenAI)
- Response parsing + ranking
- Conversation context management
- Feedback ingestion
- Audit logging

**Endpoints principaux:**

```python
POST /api/v1/conversations/{conv_id}/messages
  Body: { "content": str, "language": "fr"|"en" }
  Response: { "id", "content", "sources": [...], "confidence": float, "timestamp" }

GET /api/v1/conversations/{agent_id}
  Response: [{ "id", "messages": [...], "created_at", "updated_at" }]

POST /api/v1/feedback
  Body: { "message_id", "response_id", "helpful": bool, "comment": str }

GET /api/v1/health
  Response: { "status": "ok", "version", "dependencies": {...} }
```

**Déploiement:** AWS ECS Fargate (3-4 task replicas, auto-scale on CPU > 70%)

### 3.2.3 Admin Console Backend (FastAPI extension)

**Responsabilités:**
- Document upload processing
- Vector index management
- User + role management
- Analytics aggregation
- Audit log queries

**Endpoints:**

```python
POST /api/v1/admin/documents/upload
  Body: multipart form-data (file)
  Response: { "document_id", "indexed_at", "chunk_count", "status" }

GET /api/v1/admin/analytics/dashboard
  Query: ?from=2026-04-01&to=2026-04-07
  Response: { "total_questions": int, "avg_response_time": float, "top_topics": [...], "satisfaction_score": float }

GET /api/v1/admin/logs
  Query: ?user_id=&action=&from_date=&limit=100
  Response: [{ "id", "user_id", "action", "timestamp", "details", "ip" }]
```

### 3.2.4 Services additionnels

**Vector Store (Pinecone)**
- 10K+ document chunks taille 500-2000 chars
- Hybrid search: keyword + semantic
- Metadata: language, source, version, date

**Cache Layer (Elasticache Redis)**
- Key: hash(query_text + language)
- Value: cached response
- TTL: 1 hour

**Message Queue (SQS)**
- Document processing jobs
- Feedback ingestion
- Vector index updates
- Async notification

---

## 3.3 Architecture des données

### 3.3.1 PostgreSQL RDS (Primary)

**Configuration:**
- Instance type: db.t4g.medium (initial), scale to db.r6g.xlarge if needed
- Multi-AZ: Primary (us-east-1a), Standby (us-east-1b), failover 2-3 min
- Backup: Daily snapshots (30-day retention), 1 backup → secondary region
- Parameter group: UTF-8, max_connections=200, work_mem=4MB

**Tables principales:**

```sql
-- Users & Sessions
CREATE TABLE support_agents (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  role VARCHAR(50), -- 'agent' | 'manager' | 'admin'
  language_pref VARCHAR(5) DEFAULT 'fr', -- 'fr' | 'en'
  ad_username VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW(),
  last_login_at TIMESTAMP,
  is_active BOOLEAN DEFAULT true
);

-- Conversations History
CREATE TABLE conversations (
  id UUID PRIMARY KEY,
  agent_id UUID NOT NULL REFERENCES support_agents(id),
  title VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP -- soft delete
);

-- Messages (Questions & Answers)
CREATE TABLE messages (
  id UUID PRIMARY KEY,
  conversation_id UUID NOT NULL REFERENCES conversations(id),
  role VARCHAR(20), -- 'user' | 'assistant'
  content TEXT NOT NULL,
  language VARCHAR(5), -- detected language
  created_at TIMESTAMP DEFAULT NOW()
);

-- Responses (LLM outputs with metadata)
CREATE TABLE responses (
  id UUID PRIMARY KEY,
  message_id UUID NOT NULL REFERENCES messages(id),
  response_text TEXT NOT NULL,
  response_text_en TEXT, -- English version if FR
  sources JSONB, -- Array of {doc_id, chunk, relevance_score}
  confidence_score FLOAT CHECK (confidence_score BETWEEN 0 AND 1),
  model_used VARCHAR(50), -- 'gpt-4', version
  tokens_used INT,
  latency_ms INT,
  generated_at TIMESTAMP DEFAULT NOW()
);

-- Feedback on responses
CREATE TABLE feedback (
  id UUID PRIMARY KEY,
  response_id UUID NOT NULL REFERENCES responses(id),
  agent_id UUID NOT NULL REFERENCES support_agents(id),
  helpful BOOLEAN,
  comment TEXT,
  rating INT, -- 1-5 stars
  created_at TIMESTAMP DEFAULT NOW()
);

-- Document metadata
CREATE TABLE documents (
  id UUID PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content_type VARCHAR(50), -- 'procedure' | 'product_sheet' | 'faq' | 'guide'
  language VARCHAR(5), -- 'fr' | 'en' | 'bilingual'
  version VARCHAR(20),
  source_url VARCHAR(500),
  status VARCHAR(20), -- 'draft' | 'published' | 'archived'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES support_agents(id),
  vector_indexed_at TIMESTAMP,
  chunk_count INT
);

-- Audit log (immutable)
CREATE TABLE audit_logs (
  id BIGSERIAL PRIMARY KEY,
  timestamp TIMESTAMP DEFAULT NOW() NOT NULL,
  user_id UUID,
  action VARCHAR(100), -- 'ask_question', 'view_document', 'escalate', etc
  resource_type VARCHAR(50), -- 'conversation', 'document', 'feedback'
  resource_id UUID,
  details JSONB,
  source_ip INET,
  status_code INT,
  CONSTRAINT audit_immutable CHECK (timestamp <= NOW())
);
CREATE INDEX idx_audit_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX idx_audit_user_action ON audit_logs(user_id, action, timestamp DESC);
```

### 3.3.2 Vector Database (Pinecone)

**Index:**
- Name: `sanimarc-knowledge-base`
- Dimension: 1536 (OpenAI embedding)
- Metric: cosine similarity
- Namespace: auto-partition by language (sanimarc-fr, sanimarc-en)

**Vector records:**
```json
{
  "id": "doc-123-chunk-5",
  "values": [0.123, -0.456, ...1536 dims],
  "metadata": {
    "document_id": "doc-123",
    "chunk_number": 5,
    "content_preview": "Pour diluer le Sani-Clean...",
    "document_type": "product_sheet",
    "language": "fr",
    "source_url": "documents/Sani-Clean_v2.pdf",
    "version": "2.1",
    "date_indexed": "2026-04-07T10:00:00Z"
  }
}
```

### 3.3.3 S3 Document Storage

**Buckets:**
- `sanimarc-documents-prod`: Raw documents (PDF, TXT, MD uploaded)
- `sanimarc-documents-processed`: Extracted text + chunks
- `sanimarc-logs-archive`: Audit logs monthly exports

**Folder structure:**
```
sanimarc-documents-prod/
├── product-sheets/
│   ├── Sani-Clean_v2.1.pdf
│   ├── Sani-X_v3.0.pdf
│   └── ...
├── procedures/
│   ├── Support_Troubleshooting_v1.pdf
│   └── ...
├── faqs/
│   └── FAQ_Products_2026.md
└── versions/
    └── Sani-Clean/
        ├── v2.0/  # Archive
        ├── v2.1/  # Current
        └── ...
```

---

# 4. Intégrations et interfaces

## 4.1 Intégrations externes

### 4.1.1 OpenAI API (GPT-4 + Embeddings)

**Endpoints:**
- `POST https://api.openai.com/v1/chat/completions` (Chat API)
- `POST https://api.openai.com/v1/embeddings` (Embedding API)

**Usage:**
- Chat completions: 50-100 req/min avec context window 4K tokens
- Embeddings: 500-1000 req/min (batch processing possible)

**Cost estimate (annualized):**
- GPT-4 input: ~$0.03/1K tokens
- GPT-4 output: ~$0.06/1K tokens
- Embeddings: ~$0.0001/1K tokens
- Estimated: $500/month at 200 agents × 30 questions/day

**Error handling:**
- Timeout > 10s → fallback response
- Rate limit errors (429) → queue + retry exponential backoff
- Auth error (401) → alert admin, immediate escalation

### 4.1.2 Azure Active Directory (SSO)

**Integration:** OAuth 2.0 code flow

```
Agent → Frontend → Backend → Azure AD
                    ↓
          Validate ID + Access token
                    ↓
          Load user roles/permissions from AD groups
                    ↓
          Return JWT to Frontend (valid 1 hour)
```

**Scopes:**
- `openid profile email user.read` (default)

**Groups mapping (from AD):**
- `SaniMarc-Support-Agents` → role="agent"
- `SaniMarc-Support-Managers` → role="manager"
- `SaniMarc-IA-Admins` → role="admin"

### 4.1.3 Notification Service (Email)

**Integration:** AWS SES (Simple Email Service)

**Events triggering emails:**
- Document uploaded + indexed successfully
- Feedback flagged suspicious (auto-escalation)
- Daily analytics summary to managers
- Error critical (API failures)

---

## 4.2 Contrats d'interfaces applicatifs

### API REST - Key Endpoints

**1. Authentication**
```http
POST /api/v1/auth/login
Headers: Authorization: Bearer <ad_token>
Response: {
  "access_token": "...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": { "id", "email", "role", "name" }
}
```

**2. Ask Question**
```http
POST /api/v1/conversations/{conv_id}/messages
Headers: Authorization: Bearer <token>
Body: {
  "content": "Quelle est la dilution du Sani-Clean?",
  "language": "fr"
}
Response: {
  "id": "msg-uuid",
  "role": "assistant",
  "content": "Pour le Sani-Clean sur carrelage... ",
  "sources": [
    {
      "document_id": "doc-123",
      "title": "Fiche Sani-Clean v2.1",
      "relevance_score": 0.95,
      "url": "/docs/view/doc-123"
    }
  ],
  "confidence_score": 0.89,
  "latency_ms": 1250,
  "created_at": "2026-04-07T14:30:00Z"
}
```

**3. Get Conversation History**
```http
GET /api/v1/conversations/{agent_id}?limit=10&offset=0
Response: {
  "total": 45,
  "conversations": [
    {
      "id": "conv-uuid",
      "title": "Questions Produits Sani-Clean",
      "message_count": 8,
      "created_at": "2026-04-05T09:00:00Z",
      "updated_at": "2026-04-07T14:30:00Z"
    }
  ]
}
```

**4. Submit Feedback**
```http
POST /api/v1/feedback
Body: {
  "response_id": "resp-uuid",
  "helpful": true,
  "rating": 5,
  "comment": "Réponse très précise et bien structurée"
}
Response: { "id": "feedback-uuid", "status": "recorded" }
```

---

# 5. Architecture de déploiement

## 5.1 Infrastructure AWS

### 5.1.1 AWS Services Utilisés

| Service | Purpose | Config |
|---------|---------|--------|
| **ALB** | Load balancer applicatif | listener:443 → target groups |
| **ECS Fargate** | Backend (FastAPI application) | 3-4 tasks, 2 vCPU / 4GB RAM each |
| **CloudFront** | Frontend CDN + static caching | Origin: S3, TTL: 1d |
| **S3** | Static website hosting + document storage | Versioning, replication enabled |
| **RDS PostgreSQL** | Primary database | db.t4g.medium, Multi-AZ |
| **Elasticache Redis** | Query cache + session store | cache.t4g.micro, Single-AZ |
| **Pinecone** | Vector database (external) | 10K items, monthly subscription |
| **CloudWatch** | Logs + monitoring | Logs group: /ecs/chatbot-api |
| **EventBridge** | Event bus (document updates) | Rules → SQS → Lambda processors |
| **SQS** | Async job queue | Standard queue, 300s visibility timeout |
| **Lambda** | Document processing functions | Python 3.11 runtime, 5min timeout |
| **IAM** | Identity + Access management | Least privilege roles |
| **Secrets Manager** | Credential storage | OpenAI API key, DB password, etc |

### 5.1.2 Regions + Disaster Recovery

**Primary region:** us-east-1 (N. Virginia)  
**Backup region:** us-west-2 (Oregon) - future

**Multi-AZ within us-east-1:**
- ALB: us-east-1a + us-east-1b (redundant)
- ECS tasks: distributed us-east-1a + us-east-1b
- RDS: Primary us-east-1a, Standby us-east-1b (sync replication)
- Redis: us-east-1a only (cache, acceptable loss)

**RTO/RPO targets:**
- RTO (Recovery Time Objective): < 15 minutes
- RPO (Recovery Point Objective): < 1 hour

**Backup strategy:**
- RDS automated backup: daily, 30-day retention
- S3 cross-region replication: to us-west-2
- ECS service: auto-replace failed tasks

### 5.1.3 CI/CD Pipeline

**Version control:** GitHub  
**CI/CD tool:** GitHub Actions

**Pipeline stages:**

```
Git push → main branch
           ↓
[1] Lint + Type Check (Python, TypeScript)
    → pytest, mypy, eslint
           ↓
[2] Build Docker images
    → Docker build -t chatbot-api:v1.2.3
    → Push to ECR (Elastic Container Registry)
           ↓
[3] Deploy to staging (ECS update service)
           ↓
[4] Integration tests + Load tests (stg)
           ↓
[5] Manual approval gate (architect)
           ↓
[6] Deploy to production (blue-green deployment)
           ↓
[7] Smoke tests + Rollback if failures
           ↓
[8] Notify Slack #deployments
```

**Deployment strategy:** Blue-green (minimize downtime)  
**Rollback:** Automatic if health check fails for 2 min

---

## 5.2 Infrastructure as Code

**Tool:** Terraform

**Key modules:**
```
terraform/
├── vpc/              # VPC, subnets, security groups
├── ecs/              # Fargate cluster, services, tasks
├── rds/              # PostgreSQL RDS cluster
├── elasticache/      # Redis cache
├── s3/               # Buckets + policies
├── iam/              # Roles + permissions
├── cloudwatch/       # Log groups + alarms
├── vault/            # Secrets management
└── main.tf           # Root module with tfvars
```

**Deployment:**
```bash
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

---

# 6. Qualités de service

## 6.1 Performance

### 6.1.1 Latency SLO

| Metric | Target | Measurement |
|--------|--------|-------------|
| **p50 (Median)** | < 800ms | End-to-end (FE input → response display) |
| **p95** | < 2500ms | 95th percentile |
| **p99** | < 4000ms | 99th percentile |
| **API response time** | < 3000ms | Backend latency (excluding FE render) |

**Measured dimensions:**
- Question submitted
- Vector embedding (OpenAI API) ~ 300ms
- Similarity search (Pinecone) ~ 100ms
- LLM inference (GPT-4) ~ 1-2s
- Response parsing ~ 50ms

### 6.1.2 Throughput

- **Messages per second:** 100 msg/s target
- **Concurrent users:** 200+ agents without degradation
- **Database:** 1000 queries/sec capacity

**Load test scenarios:**
- Ramp-up: 0 → 100 agents over 10 min
- Sustained: 100 agents for 30 min (random questions)
- Spike: +50 agents sudden (escalation test)
- Pass criteria: p95 latency < 3s throughout

---

## 6.2 Scalabilité

### 6.2.1 Horizontal scaling

**Frontend:**
- CloudFront auto-scales (no manual action)
- S3 serves unlimited requests

**Backend (ECS Fargate):**
- Target: 70% CPU utilization
- Min tasks: 3, Max tasks: 10
- Scale-up delay: 1 min, Scale-down delay: 5 min

**Database (RDS):**
- Read replicas: Can add read replica if read queries spike
- Current capacity: db.t4g.medium handles 50K queries/day

**Vector Store (Pinecone):**
- Auto-scales on index size + QPS
- Budget: $5K/month for quota

### 6.2.2 Capacity planning (12-month projection)

| Timeline | Agents | QPM (queries/min) | Conversations | Storage (GB) |
|----------|--------|---------|---|---|
| Month 0 (Pilot) | 3 | 150 | 50 | 0.1 |
| Month 3 | 50 | 2500 | 500 | 1 |
| Month 6 | 100 | 5000 | 1000 | 2 |
| Month 12 | 200+ | 10K+ | 2000+ | 5-10 |

**Infrastructure scaling plan:**
- **Months 0-3:** Current setup (db.t4g.medium, 1 Redis node)
- **Months 4-6:** Upgrade RDS to db.t4g.large, add read replica
- **Months 7+:** Consider Fargate spot instances for cost optimization

---

## 6.3 Disponibilité

### 6.3.1 Uptime SLA

**Target:** 99.5% SLA (heures bureau only: 8AM-6PM, weekday)

- **Heures bureau (peak):** 99.5% (down ~45 min/month)
- **Off-peak:** 95% acceptable (2-3 hours maintenance window per month)

**Maintenance window:** Jeudi 22:00-23:00 UTC (hors pic)

### 6.3.2 Health checks

**Application health check (ECS):**
- Endpoint: `GET /api/v1/health`
- HTTP 200 → healthy
- Interval: 30s, Timeout: 5s, Failures threshold: 3
- Unhealthy task → auto-replacement

**Dependency health check (background):**
```python
# Every 5 minutes
- OpenAI API test call (cost: ~$0.0001)
- Database connection test
- Redis connectivity
- S3 list buckets test
- Pinecone index status

If any critical dependency down:
  → CloudWatch alarm → SNS notification → auto-escalation
```

---

## 6.4 Monitoring + Observabilité

### 6.4.1 Metrics

**CloudWatch dashboards:**

1. **System Health Dashboard**
   - API response time (p50, p95, p99)
   - Error rate (5xx, 4xx by endpoint)
   - ECS task count + CPU/Memory utilization
   - Database connections in-use
   - Redis evictions + hit rate

2. **Application Dashboard**
   - Questions asked (per hour)
   - Average confidence score
   - Time to first response
   - Cache hit rate
   - Top topics (word cloud)

3. **Business Dashboard**
   - User engagement (unique agents)
   - Feedback rate (useful/not useful)
   - Escalation rate (% questions escalated)
   - Response quality trending

### 6.4.2 Logging

**Structured logging (JSON):**
```json
{
  "timestamp": "2026-04-07T14:30:00Z",
  "level": "INFO",
  "service": "chatbot-api",
  "trace_id": "abc123def456",
  "user_id": "agent-uuid",
  "event": "question_answered",
  "latency_ms": 1250,
  "confidence_score": 0.89,
  "tokens_used": 450,
  "status": "success"
}
```

**Log retention:**
- CloudWatch Logs: 30 days
- S3 Archive: 1 year (monthly exports)

### 6.4.3 Tracing

**Distributed tracing:** AWS X-Ray

**Traced flows:**
- User question → Vector search → LLM call → Response
- Document upload → S3 → Processing → Vector index

---

# 7. Sécurité

## 7.1 Authentification + Autorisation

### 7.1.1 Authentication

**Method:** OAuth 2.0 avec Azure AD (SSO)

**Flow:**
1. Agent accède chatbot.sanimarc.corp
2. Frontend redirects vers Azure AD login
3. Agent enters corporate email + password (+ MFA optionnel)
4. Azure AD retourne ID token + access token
5. Frontend stores JWT locally (1 hour expiry)
6. Subsequent API calls use JWT in Authorization header

**Token format:** JWT (JSON Web Token)
```json
{
  "sub": "user@sanimarc.com",
  "oid": "ad-object-id",
  "given_name": "John",
  "family_name": "Doe",
  "roles": ["agent", "manager"],
  "iat": 1712519400,
  "exp": 1712523000
}
```

### 7.1.2 Authorization (RBAC)

**Roles:**
- **agent:** Can ask questions, view conversation history, submit feedback
- **manager:** agent perms + view team dashboards + escalate tickets
- **admin:** manager perms + document management + user management + audit logs

**Endpoint protections example:**
```python
@app.post("/api/v1/conversations/{id}/messages")
@require_auth(roles=["agent", "manager", "admin"])
def ask_question(id: str, payload: QuestionPayload, user: AuthUser = Depends(get_user)):
    # Check user owns conversation or is manager
    validate_access(user.id, conversation_id)
    ...
```

---

## 7.2 Données en transit

### 7.2.1 Transport Security (TLS)

- **Version:** TLS 1.3 minimum
- **Cipher suites:** Modern suites (ECDHE + AES-GCM)
- **Certificate:** Wildcard *.sanimarc.corp (ACM managed)
- **HSTS:** Max-age: 31536000 (1 year), includeSubDomains

**Verification:**
```bash
openssl s_client -connect chatbot.sanimarc.corp:443 -tls1_3
```

### 7.2.2 API Security

- **rate limiting:** 100 req/min per user
- **CORS:** Only sanimarc.corp origins
- **CSRF protection:** State parameter in OAuth flow
- **Request validation:** JSON schema + input sanitization

---

## 7.3 Données au repos

### 7.3.1 Database Encryption

**PostgreSQL RDS:**
- Encryption: AWS KMS (customer-managed key)
- Key rotation: Annual
- TLS for replication (primary ↔ standby)

**S3 Documents:**
- Encryption: AWS KMS
- Default encryption policy enforced
- Versioning for recovery

**Redis Cache:**
- Encryption: disabled (cache, not sensitive)
- At-rest: encrypted via RDS encryption

### 7.3.2 Secrets Management

**AWS Secrets Manager:**
```json
{
  "openai_api_key": "sk-...",
  "db_password": "...",
  "jwt_signing_key": "...",
  "encryption_key": "..."
}
```

**Rotation policy:**
- OpenAI key: quarterly
- DB password: annually
- Others: on-demand

---

## 7.4 Conformité

### 7.4.1 RGPD Compliance

**Key requirements:**
1. **Data minimization:** Collect only necessary data (emails, roles, interactions)
2. **Purpose specification:** Clearly state knowledge base purpose
3. **Consent:** Explicit checkbox: "I accept my questions are logged for quality improvement"
4. **Right to be forgotten:** Agent can request deletion of conversations
   - Endpoint: `DELETE /api/v1/conversations/{id}` → soft delete
   - Audit logs retained (legal obligation)
5. **Data export:** `GET /api/v1/agent/data-export` → JSON download
6. **Privacy policy:** Link in UI to updated privacy policy
7. **DPA with vendors:** OpenAI DPA signed (USA, standard clauses)

### 7.4.2 Data Classification

| Data | Classification | Encryption | Audit | Retention |
|------|---|---|---|---|
| **Questions** | Internal | At-rest + transit | Yes | 2 years |
| **Responses** | Internal | At-rest + transit | Yes | 2 years |
| **Feedback** | Internal | No (aggregated) | Yes | 1 year |
| **Audit logs** | Confidential | At-rest | Yes | 3 years (legal) |
| **Credentials** | Secret | TDE + Vault | No | Rotated |

---

## 7.5 Threat Model + Mitigations

| Threat | Likelihood | Impact | Mitigation |
|--------|---|---|---|
| **Unauthorized access (broken auth)** | Low | Critical | OAuth SSO, JWT validation, no hardcoded creds |
| **Data breach (DB exfiltration)** | Medium | Critical | Encryption KMS, network isolation (SG), RDS backups versioned |
| **LLM prompt injection** | Medium | High | Input validation, prompt guardrails, user content sanitization |
| **API rate limit abuse** | Medium | Medium | Rate limiting (100/min per user), WAF rules |
| **DDoS** | Low | Medium | CloudFront DDoS protection, WAF rules, Auto Scaling |
| **Vendor lock-in (OpenAI)** | Medium | Medium | Abstract via Interface, ready to swap to Llama |
| **Vector DB poisoning** | Low | Medium | Document approval workflow, versioning, audit logs |
| **Social engineering (admin)** | Medium | High | MFA for admins, training, access logging |

---

## 7.6 Security Testing

**Cadence:** Quarterly

- **Penetration testing:** External vs public endpoints
- **Code review:** OWASP Top 10 focus
- **Vulnerability scanning:** Dependabot + SonarQube
- **Data breach simulation:** Tabletop exercise

---

# 8. Plan de transition

## 8.1 Stratégie de déploiement

### Phase 1 - Pilot (Weeks 1-8)

**Objectif:** Valider concept avec 3 agents, itérer sur UX

**Équipe:**
- 2 agents (Support Clientèle) - pilot users
- 1 manager (de support) - feedback sponsor
- 1 ML Engineer (fine-tuning)
- 1 Tech Lead Backend

**Livrables:**
- Chatbot MVP deployé (staging)
- Knowledge base initiale (30% docs critiques)
- Admin console basique (upload docs)
- Monitoring dashboard

**Success criteria (pilot):**
- ✓ Responders < 3s, p95
- ✓ Agents adopte tool (5+ questions/day each)
- ✓ Feedback useful > 70%
- ✓ No security incidents

**Timeline:**
- Weeks 1-2: Infrastructure setup (AWS, DB, ECS, IAM)
- Weeks 2-3: Backend API + OpenAI integration
- Weeks 3-4: Frontend + SSO integration
- Weeks 5-6: Knowledge base ingestion + vector index
- Weeks 6-7: Admin console
- Weeks 7-8: Load testing + production deployment to pilot env

### Phase 2 - Expansion (Weeks 9-16)

**Objectif:** Scale to 50-100 agents, refine based on pilot feedback

**Additions:**
- Knowledge base 100% coverage
- Advanced analytics dashboard
- Feedback loop + retraining
- Performance optimizations (caching, parallelization)

**Timeline:**
- Week 9: Org comms + change management
- Weeks 9-10: Documentation + training materials
- Week 11: Wave 1 rollout (25 agents)
- Weeks 12-13: Monitoring + issue resolution
- Weeks 14-15: Wave 2 rollout (75 agents total)
- Week 16: Retrospective + plan Phase 3

### Phase 3 - Optimization (Weeks 17+)

**Objectif:** Full scale (200+ agents), cost optimization, advanced features

**Focus areas:**
- LLM fine-tuning on feedback data
- Multi-region deployment (failover)
- Enterprise features (audit reports, compliance)
- Mobile app support

---

## 8.2 Change Management

### 8.2.1 Stakeholder communication

**Timeline:**
- **Week 0:** Email announcement + executive briefing
- **Week 2:** Agent training workshops (1 hour, 3 sessions)
- **Week 5:** Manager preview + dashboard walkthrough
- **Week 8:** Go-live communications + support channel

**Messaging:**
- Frame as "Knowledge Assistant" (not replacement)
- Emphasize speed + consistency benefits
- Address concerns: "Not tracking personal info, only improving tool"

### 8.2.2 Training + Enablement

**Agent training (1 hour workshop):**
1. Demo (5 min): Ask sample questions, see responses
2. Hands-on (30 min): Agents try real questions
3. Tips + tricks (15 min): Advanced search, feedback, escalation
4. Q&A (10 min)

**Manager training (30 min):**
1. Dashboard overview (metrics, KPIs)
2. Monitoring + escalation procedures
3. Admin panel walkthrough

**Documentation:**
- Quick start guide (1-pager)
- FAQ (10 questions)
- Troubleshooting guide
- Video tutorials (2-3 min each)

---

## 8.3 Support + Operations Plan

### 8.3.1 Support Structure

**Level 1 (Agent-facing):**
- Help desk #chatbot-support on Slack
- Response time: < 4 hours
- Escalation to L2 if cannot resolve

**Level 2 (Product-focused):**
- Product Manager + Tech Lead Backend
- Response time: < 1 hour
- Handles bugs, feature requests, tuning

**Level 3 (VendorI / Infrastructure):**
- DevOps + Architect
- Infrastructure incidents, vendor issues

### 8.3.2 Operational Runbooks

**Runbook 1: OpenAI API Outage**
1. Detect: CloudWatch alarm or manual report
2. Isolate: Disable LLM calls, enable fallback ("Please contact support")
3. Notify: Slack alert + email managers
4. Recover: Wait for API health, test with small sample questions
5. Resume: Rollout gradually

**Runbook 2: High error rate (> 5%)**
1. Check: CloudWatch logs for error patterns
2. Assess: Database load, API rate limits, vector search issues
3. Mitigate: Scale ECS, clear Redis cache, notify OpenAI
4. Monitor: Dashboard latency, error rate trednumerical trending
5. RCA: Post-mortem once stable

---

# 9. Décisions architecturales projet

## ADR-001: Utiliser OpenAI GPT-4 comme LLM primaire

**Status:** ACCEPTED

**Context:** 
- Besoin LLM robuste pour réponses fiables (pas hallucinations)
- Alternative: Llama 2/3 (open-source, auto-hébergé) OU Claude (Anthropic)

**Decision:** 
OpenAI GPT-4 (API cloud)

**Rationale:**
1. **Qualité:** GPT-4 meilleures résultats RAG + multilingue (FR/EN)
2. **Effort:** Intégration rapide via API (pas d'infra ML)
3. **Cost:** ~$500/month à usage prévu, budget acceptable
4. **Support:** OpenAI support commercial réactif

**Consequences:**
- ❌ Vendor lock-in (OpenAI)
- ❌ Data goes to US (OpenAI API)
- ✅ Quick time-to-market
- ✅ High reliability

**Alternatives rejected:**
- **Llama 3 (self-hosted):** Latency > 5s, infrastructure overhead
- **Claude API:** Non-multilingual support, cost ~ same

---

## ADR-002: RAG (Retrieval-Augmented Generation) obligatoire

**Status:** ACCEPTED

**Context:**
LLM standalone = hallucination risk (invente sources). Support clients besoin confiance absolue source.

**Decision:**
Always retrieve relevant docs before LLM call

**Rationale:**
1. **Grounding:** LLM basé sur docs internes → réponses exactes + citable
2. **Traceability:** Sources listées pour vérification agent
3. **Cost:** Retrieve documents < 200ms, cost negligible

**Consequences:**
- ✅ Resp confidence > baseline
- ✅ Audit trail complet
- ❌ Latency +200ms (embedding + vector search)
- ❌ Requires document preprocessing

---

## ADR-003: Vector Store externe (Pinecone) vs Postgres pgvector

**Status:** ACCEPTED (Pinecone)

**Context:**
Need scalable vector search. Options: (1) PostgreSQL pgvector extension, (2) Pinecone SaaS

**Decision:**
Pinecone

**Rationale:**
1. **Scaling:** Pinecone auto-scales, pgvector = DB bottleneck
2. **Perf:** Pinecone optimized for similarity (1M+ vectors), pgvector slower
3. **Cost:** Pinecone ~$500/mo vs pgvector infrastructure cost
4. **Maintenance:** SaaS (no ops burden)

**Consequences:**
- ✅ Scalability to 100K+ documents
- ✅ Better latency (dedicated hardware)
- ❌ External vendor + cost
- ❌ Data residency (Pinecone in US)

---

## ADR-004: Cache-aside strategy with Redis

**Status:** ACCEPTED

**Context:**
Many agents ask similar questions (~20% repetition). Cache accelerates response.

**Decision:**
Redis cache + 1-hour TTL
- Key: hash(question_text + language)
- Value: { response, sources, confidence, timestamp }

**Rationale:**
1. **Performance:** Cache hit = response < 200ms (vs 2-3s LLM)
2. **Cost:** Saves 20% OpenAI API calls (~$100/month savings)
3. **Simplicity:** Redis is standard, well-supported

**Consequences:**
- ✅ Latency reduction for popular questions
- ✅ Cost savings
- ❌ Stale data if documents updated (mitigated by 1h TTL)
- ❌ Cache invalidation complexity (current: time-based only)

---

## ADR-005: Async document processing (SQS + Lambda)

**Status:** ACCEPTED

**Context:**
Admin uploads 100-page PDF. Processing = 30-60 seconds (extract text, chunk, embed). Sync = bad UX.

**Decision:**
Async job queue (SQS) + Lambda processor
- Admin uploads → immediate 202 Accepted
- Background job indexes document
- Admin gets email when ready

**Rationale:**
1. **UX:** No blocking, instant feedback
2. **Reliability:** Retries if Lambda fails
3. **Cost:** Lambda pay-per-second is cheap for batch jobs
4. **Scale:** Can parallelize document processing

**Consequences:**
- ✅ Non-blocking upload
- ✅ Better scaling of document ingest
- ❌ Latency before docs queryable (30-60s)
- ❌ Complexity (async state tracking)

---

## ADR-006: PostgreSQL Multi-AZ vs Single-AZ

**Status:** ACCEPTED (Multi-AZ)

**Context:**
SLA99.5% requires high availability. Options: (1) Single-AZ + restore backup, (2) Multi-AZ sync replication

**Decision:**
Multi-AZ (Primary us-east-1a, Standby us-east-1b)

**Rationale:**
1. **RTO:** Multi-AZ failover < 3 min vs restore > 30 min
2. **Compliance:** Customers expect SLA 99.5%
3. **Cost:** +30% infrastructure cost << business risk

**Consequences:**
- ✅ RTO < 3 min (acceptable for most)
- ✅ Sync replication (no data loss)
- ❌ +30% database cost
- ❌ Slightly higher latency (sync replication overhead)

---

## ADR-007: ECS Fargate vs Lambda for API

**Status:** ACCEPTED (ECS Fargate)

**Context:**
Backend needs long-running orchestration (embedding, LLM calls, response construction). Lambda = 15min timeout max.

**Decision:**
ECS Fargate
- Containers (FastAPI application)
- 3-4 task replicas, auto-scale on CPU

**Rationale:**
1. **Timeout:** No 15min limit, can wait for LLM
2. **Flexibility:** Full Python env (libraries, dependencies)
3. **Cost:** Fargate similar cost to Lambda for continuous workload
4. **Control:** More control over logging, monitoring

**Consequences:**
- ✅ No timeout constraints
- ✅ Standard app deployment (Dockerfile)
- ❌ Cold start ~10-20s first request (minor)
- ❌ Always running cost (even idle)

---

## ADR-008: OAuth SSO via Azure AD

**Status:** ACCEPTED

**Context:**
Sani Marc uses Azure AD (Office 365). Options: (1) Azure AD OAuth, (2) SAML, (3) LDAP

**Decision:**
OAuth 2.0 code flow with Azure AD

**Rationale:**
1. **Alignment:** Company standard (Office 365, Teams, etc.)
2. **UX:** Seamless SSO (users already logged into Windows)
3. **Security:** Microsoft manages identity, MFA available
4. **Compliance:** AD groups for RBAC

**Consequences:**
- ✅ Seamless SSO
- ✅ Leverage company AD groups
- ❌ Dependency on Azure AD availability
- ❌ Requires AD admin for group setup

---

## ADR-009: Français + Anglais via language parameter

**Status:** ACCEPTED

**Context:**
Sani Marc bilingual. Users may be FR-preferred or EN-preferred. Options: (1) Detect language automatically, (2) Let user choose, (3) Both

**Decision:**
Auto-detect + user override
- Frontend detects browser language (FR/EN)
- Question language auto-detected on input
- Response generated in question language
- User can override with language selector

**Rationale:**
1. **User experience:** Works out-of-box for most
2. **Accuracy:** Auto-detection French vs English accurate
3. **Flexibility:** User can override if needed

**Consequences:**
- ✅ Seamless multilingue support
- ✅ Flexible
- ❌ Need French + English documents
- ❌ Response logic slightly more complex

---

## ADR-010: Feedback loop for continuous improvement

**Status:** ACCEPTED

**Context:**
How to improve response quality over time? Options: (1) No feedback, (2) Simple ratings, (3) Detailed feedback + retraining

**Decision:**
User feedback (binary: useful/not useful) + telemetry
- Agent clicks "Useful" or "Not useful"
- Data collected for model retraining (quarterly)
- Monitoring dashboard shows feedback distribution

**Rationale:**
1. **Simple:** 2-button UX, high engagement expected
2. **Actionable:** Identify low-confidence or problematic queries
3. **Improvement:** Fine-tune LLM prompts or retrieval based on data
4. **Cost:** Minimal overhead

**Consequences:**
- ✅ Continuous improvement loop
- ✅ Low cognitive load (simple buttons)
- ❌ Limited feedback signal (binary only)
- ❌ Quarterly retraining lag

---

# Conclusion

Cette architecture de solution fournit une fondation solide, scalable et sécurisée pour le Chatbot IA Générative de Sani Marc. En combinant les forces du RAG (grounding documentaire) avec OpenAI GPT-4 et une infrastructure AWS robuste, la plateforme délivrera des réponses fiables et améliorera significativement la productivité des agents support.

Les phases de déploiement progressif (Pilote → Expansion → Optimization) permettent de valider le concept rapidement tout en minimisant le risque. Les décisions architecturales clés (RAG, Pinecone, Fargate, etc.) sont justifiées par les contraintes métier et les KPIs d'acceptation.

**Prochaines étapes:**
1. ✅ Validation par le Comité d'Architecture
2. ⏳ Design technique détaillé (Semaines 1-2)
3. ⏳ Déploiement infrastructure (Semaines 3-4)
4. ⏳ Développement itératif (Semaines 5-12)
5. ⏳ Pilot deployment (Semaines 13-16)
6. ⏳ Rollout progressif (Semaines 17-26)

---

# Annexes

## Annexe A: Glossaire projet

| Terme | Définition | Contexte |
|-------|-----------|---------|
| **RAG** | Retrieval-Augmented Generation | Pattern fondamental : récupérer docs pertinents avant appel LLM |
| **Embedding** | Vecteur float[1536] représentant texte | Généré par OpenAI API, utilisé pour similarité sémantique |
| **Hallucination** | LLM invente faux faits/sources | Risque mitigé par RAG grounding |
| **Pinecone** | Vector database SaaS | Stockage recherche similarité (1M+ documents scalable) |
| **Fargate** | Serverless container orchestration | AWS service pour déployer Docker containers sans gérer VMs |
| **Multi-AZ** | Multiple Availability Zones | Déployer dans 2+ zones AWS pour haute disponibilité |
| **SSO** | Single Sign-On via OAuth | Authentification unifiée via Azure AD corporate |
| **Vector similarity** | Cosine distance entre embeddings | Métrique pour trouver docs similaires à question |
| **Confidence score** | Score 0-1 qualité réponse | Indique fiabilité réponse pour agent |
| **Escalation** | Transférer à agent humain | Automatique si confiance < seuil ou type question |
| **Feedback loop** | User rating → model improvement | Agents clickent useful/not useful → retraining |
| **Fine-tuning** | Adapter LLM sur données propres | Utilisera feedback agent pour améliorer réponses |
| **RTO** | Recovery Time Objective | Target temps pour restaurer service après incident |
| **RPO** | Recovery Point Objective | Target perte données maximale acceptable |
| **CDC** | Change Data Capture | Détecter doc updates → event → vector index re-index |
| **TTL** | Time To Live | Redis cache dur 1 heure avant expiration |
| **WCAG** | Web Content Accessibility Guidelines | Standard accessibilité web (AA niveau requis) |
| **OWASP Top 10** | Security vulnerabilities ranking | Framework pour vérifications sécurité applicative |
| **ADR** | Architecture Decision Record | Documentation décisions architecturales + rationale |

---

## Annexe B: Références

### Documents liés (projet Sani Marc)
- [CIO Roadmap 2026-2027](link/to/roadmap) - Roadmap stratégique IT
- [Sani Marc Brand Guidelines](link/to/brand) - Style UI/UX corporate à respecter
- [Data Classification Policy](link/to/policy) - Policy données sensibles
- [Disaster Recovery Plan](link/to/dr-plan) - Plan continuité métier

### Standards + Frameworks appliqués
- **TOGAF 9.2:** The Open Group Architecture Framework (archétype solution architecture)
- **C4 Model:** Context-Containers-Components-Code (diagrammes architecture)
- **ArchiMate 3.0:** Notation standard architecture d'entreprise
- **BPMN 2.0:** Business Process Model and Notation (processus métier)
- **UML 2.5:** Unified Modeling Language (diagrammes techniques)
- **OWASP Top 10:** Web application security risks (checklist)
- **WCAG 2.1:** Web Content Accessibility Guidelines (AA level minimum)
- **RGPD:** Règlement Général Protection Données (compliance)

### Outils + Technologies référencées
- **AWS:** Cloud infrastructure (EC2, RDS, S3, ECS Fargate, ELB, CloudFront, CloudWatch, etc.)
- **OpenAI API:** GPT-4 + text-embedding-3-small models
- **Pinecone:** Vector database SaaS
- **PostgreSQL:** Open-source relational database
- **Redis (Elasticache):** In-memory cache
- **Terraform:** Infrastructure as Code
- **GitHub Actions:** CI/CD automation
- **IAM (AWS):** Identity and Access Management
- **AWS Secrets Manager:** Credential storage
- **Azure AD:** Corporate authentication (SSO)
- **CloudWatch + X-Ray:** Observability AWS

### Références externes
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [AWS RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/)
- [Pinecone Vector Database Docs](https://docs.pinecone.io/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [RAG Evaluation Frameworks](https://docs.llamaindex.ai/en/latest/use_cases/rag/)

---

## Annexe C: Contacts et équipe

### Équipe projet (rôles clés)

| Rôle | Nom | Email | Département | Disponibilité | Canal principal |
|------|-----|-------|-------------|---------------|-----------------|
| **Sponsor Exécutif** | VP Support Client & Operations | [À assigner] | Direction Opérations | 20% | Email + executive briefings |
| **Sponsor Métier** | Head of Customer Support | [À assigner] | Support Clientèle | 50% | Weekly sync + Slack |
| **Architecture Lead** | Solution Architect | [À assigner] | IT Architecture | 100% | Daily standup + Slack |
| **Product Manager** | Product Manager | [À assigner] | Product/Innovation | 100% | Product meetings + Slack |
| **Tech Lead Backend** | Senior Backend Engineer | [À assigner] | Development | 100% | Daily standup + code reviews |
| **ML Engineer** | ML/AI Specialist | [À assigner] | Data Science | 80% | Weekly RAG optimization |
| **DevOps Engineer** | Cloud Operations | [À assigner] | Cloud Infrastructure | 80% | On-pager rotation |
| **Security Officer** | Information Security | [À assigner] | Security | 30% | Security reviews + compliance |
| **Support Manager (Pilot)** | Support Team Lead | [À assigner] | Support Clientèle | 50% | User feedback sessions |

### Points de contact support

| Composant | Propriétaire | Email | Slack Channel | SLA |
|-----------|-------------|-------|--------------|-----|
| **Backend API** | Tech Lead Backend | [À assigner] | #chatbot-api-support | 4 hours |
| **Vector Database** | DevOps Engineer | [À assigner] | #chatbot-platform | 2 hours |
| **OpenAI Integration** | ML Engineer | [À assigner] | #chatbot-ml | 1 hour critical |
| **Database (RDS)** | DevOps Engineer | [À assigner] | #database-support | 30 min critical |
| **User Issues** | Support Manager | [À assigner] | #chatbot-support | 4 hours |
| **Security Incidents** | Security Officer | [À assigner] | #security-incidents | 15 min |

---

## Annexe D: Revues et approbations

### Signatures d'approbation

| Rôle | Nom | Approuvé | Date | Notes |
|------|-----|----------|------|-------|
| **CTO / Chief Architect** | [À assigner] | ☐ | ___ | Approbation architecture globale |
| **VP Operations** | [À assigner] | ☐ | ___ | Sponsor exécutif |
| **Head of Support** | [À assigner] | ☐ | ___ | Sponsor métier |
| **Security Officer** | [À assigner] | ☐ | ___ | Revue sécurité + RGPD |
| **Finance / Budget Owner** | [À assigner] | ☐ | ___ | Budget $500K CAD validé |
| **Architecture Review Board** | [À assigner] | ☐ | ___ | Comité architecture |

### Historique de révision

| Version | Date | Auteur | Rôle | Changements majeurs | Statut |
|---------|------|--------|------|-------------------|--------|
| 0.9 | 2026-04-03 | Architecture Team | Solution Architect | Draft initial - structure + sections 1-5 | **DRAFT** |
| 0.95 | 2026-04-05 | Architecture Team | Solution Architect | Ajout sections 6-7, sécurité + qualités service | **DRAFT** |
| 1.0 | 2026-04-07 | Architecture Team | Solution Architect | Complétion sections 8-9 (transition, ADRs) + annexes | **READY FOR REVIEW** |
| 1.1 | [TBD] | [Architecture Lead] | Solution Architect | Feedback CTO + modifications section [X] | [À compléter] |
| 2.0 | [Post-Pilot] | [Architecture Lead] | Solution Architect | Leçons pilote, mise à jour architecture | [À compléter] |

### Examen de conformité

- ✅ **Structurellement conforme au template:** Document suit structure 9 sections + annexes
- ✅ **Alignement TOGAF:** Couvre métier, applicative, technique, gouvernance
- ✅ **C4 Model complété:** Context (L1), Containers (L2), Components partiels (L3)
- ✅ **Décisions justifiées:** 10 ADRs documentées (context + decision + consequences)
- ✅ **Risques identifiés:** Matrix risques + mitigations fourni
- ⏳ **Modèle données:** SQL schemas détaillés, besoin validation DBA
- ⏳ **Infrastructure as Code:** Terraform structure définie, besoin implémentation
- ⏳ **Security:** Threat model inclus, besoin pentest pour validation

### Prochaines actions pré-approbation

- [ ] CTO review + feedback architecture
- [ ] Security Officer pentest initial (infrastructure)
- [ ] Finance validation budget $500K CAD
- [ ] Support Manager validation business requirements
- [ ] DBA review schéma PostgreSQL
- [ ] DevOps review infrastructure code (Terraform)
- [ ] Comité Architecture vote approval
- [ ] Signature CTO + VP Operations

---

**Document créé:** 2026-04-07  
**Architecture Lead:** [À assigner]  
**Propriétaire document:** [À assigner - probablement CTO ou Solution Architect]  
**Dernière révision:** 2026-04-07  
**Prochaine revue:** Post-pilot (Semaine 9) OU avant approbation formelle

---

> **Note:** Ce document est basé sur le template `02.00.architecture_solution.template.md` du référentiel `.github/templates/md/`.
