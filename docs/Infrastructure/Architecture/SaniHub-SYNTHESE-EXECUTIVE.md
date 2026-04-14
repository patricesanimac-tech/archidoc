# SaniHub — Architecture de Solution — SYNTHÈSE EXECUTIVE

## 📋 Livrables Complétés

### 1. **Document Architecture Principal** (40+ KB)
📄 `02.00.SaniHub-Middleware-Integration.md`

Contient 11 sections compréhensives :
- ✅ Résumé exécutif et objectifs métier
- ✅ Périmètre (flux inclus/exclus)
- ✅ Vision métier (as-is vs to-be)
- ✅ Modèle de données canonique
- ✅ Architecture événementielle (Event-Driven)
- ✅ Vue C4 (contexte + conteneurs)
- ✅ Intégrations détaillées (5 applications)
- ✅ Infrastructure Kubernetes (on-premise)
- ✅ Qualités de service (SLA, latency, throughput)
- ✅ Sécurité & Conformité (STRIDE, OAuth 2.0, chiffrement)
- ✅ Plan de migration (Strangler Fig + 3 phases)
- ✅ 5 Architecture Decision Records (ADRs)

**Status :** Brouillon — **Prêt pour validation CIO + Paul**

---

### 2. **Diagrammes d'Architecture**
📊 `SaniHub-Diagrams.puml` (PlantUML)

5 diagrammes visuels :
- ✅ **C4 Niveau 1 (Contexte)** — Acteurs, systèmes externes, hub central
- ✅ **C4 Niveau 2 (Conteneurs)** — API Gateway, Router, Transformer, Connecteurs, Event Store, Redis, Observability
- ✅ **Séquence Événementielle** — Flux complet commande client (TrueCommerce → M3 → Ortems → Dashboard)
- ✅ **ArchiMate Business** — Processus métier (Order-to-Cash, Procure-to-Pay)
- ✅ **ArchiMate Application** — Composants SaniHub, connecteurs, interfaces
- ✅ **Deployment Kubernetes** — Architecture on-premise avec namespaces, pods, PVCs

---

### 3. **Diagrammes Processus Métier**
📊 `SaniHub-BPMN-Diagrams.puml` (PlantUML)

3 diagrammes BPMN détaillés :
- ✅ **Order-to-Cash** — Flux complet 9 étapes (réception EDI → confirmation B2B → clôture)
- ✅ **Procure-to-Pay** — Flux complet 8 étapes (planification → paiement fournisseur)
- ✅ **Error Handling & Resilience** — Scénarios défaillance + retry logic + replay manuel

Chaque flux inclut **traçabilité complète** via `correlation_id`

---

## 🎯 Décisions Architecturales Clés

| Décision | Choix | Justification |
|----------|-------|---|
| **Style** | Event-Driven | Découplage, scalabilité, auditabilité |
| **Plateforme** | On-Premise (Kubernetes) | TCO, latency, security |
| **Event Store** | PostgreSQL + JSONB | Flexibilité, compliance SQL, coûts |
| **Message Broker** | RabbitMQ / Kafka | Persistence, failover, fanout |
| **Sécurité** | OAuth 2.0 + TLS | Authentification/autorisation centralisée |
| **Migration** | Strangler Fig | Progressif, zéro disruption |

---

## 📊 Cibles de Performance

| Métrique | Cible | Horizon |
|----------|-------|---------|
| **Latency p95** | <2 secondes | MVP (juin 2026) |
| **SLA Uptime** | 99.95% | Go-Live (nov 2026) |
| **Throughput** | 1000 msg/sec steady | 24 mois |
| **RTO (Recovery)** | 5 minutes | Go-Live |
| **RPO (Data Loss)** | 15 minutes | MVP |

---

## 📅 Timeline & Phases

| Phase | Quand | Flux | Risk |
|-------|-------|------|------|
| **MVP** | Juin 2026 | Commandes clients + EDI | Faible |
| **MVP+** | Juillet 2026 | Production orders (ODF) + Achats | Moyen |
| **Pre-Prod** | Août 2026 | Stock + MariaDB sync historique | Moyen |
| **Go-Live** | Novembre 2026 | Basculement complet | Moyen (cutover) |
| **Stabilisation** | Déc-Jan 2027 | Monitoring close, optimisation | Faible |

---

## 🎓 Frameworks Appliqués

✅ **TOGAF** — Architecture métier, applicative, technique, gouvernance  
✅ **ArchiMate 3.0** — Business, Application, Technology layers  
✅ **C4 Model** — Context, Containers, Components, Code  
✅ **BPMN 2.0** — Processus métier standard  
✅ **Pattern Patterns** — Saga, API Gateway, Circuit Breaker, CDC, CQRS

---

## 🔐 Sécurité

- **Authentification** : OAuth 2.0 (client credentials)
- **Chiffrement transit** : TLS 1.3
- **Chiffrement au repos** : AES-256 (PostgreSQL, Redis)
- **Gestion secrets** : HashiCorp Vault (rotation 90j)
- **Audit trail** : Event log immuable (24 mois)
- **STRIDE Threats** : 6 menaces identifiées + mitigations

---

## 🚀 Prochaines Étapes

1. **Présenter CIO + Paul** → Recueillir feedback (1 semaine)
2. **Créer document 02.01 Fonctionnel** → Détails connecteurs, APIs, schémas DB, CI/CD
3. **POC M3 Connecteur** → Valider approche OData + transformation (1 semaine dev)
4. **Dimensionner infra** → Tests de charge pour confirmer CPU/RAM/disque
5. **Kick-off dev** → Mathieu + 3-4 devs, sprint 1 début mai

---

## 📁 Fichiers Créés

```
docs/Infrastructure/Architecture/
├── 02.00.SaniHub-Middleware-Integration.md      (Document principal)
├── SaniHub-Diagrams.puml                         (C4 + ArchiMate + Deployment)
└── SaniHub-BPMN-Diagrams.puml                    (Processus + Error handling)
```

---

**Document révisé :** 2026-04-13  
**Auteur :** Mathieu, Architecte de Solution  
**Status :** ✅ Brouillon — Prêt validation

---

### Questions ou Feedback ?

- **Architecture métier OK ?** Valider avec Paul les processus Order-to-Cash et P2P
- **Plateforme on-premise sûre ?** Confirmer avec CIO la capacité infra K8s
- **Timeline agressive ?** MVP juin = 2 mois pour connecteurs M3 + Dynamics
- **Budget 600k$ réaliste ?** Valider avec directeur IT (infra + 4 devs + 16 semaines)
