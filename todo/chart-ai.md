# 📘 Charte d'utilisation de l'Intelligence Artificielle — Sani Marc

> **Version :** 1.1  
> **Date d'entrée en vigueur :** Avril 2026  
> **Prochaine révision :** Avril 2027  
> **Approbation :** Comité de Direction / Comité IA  
> **Propriétaire :** Direction des Technologies de l'Information

---

> 💡 **Note de rédaction :** Ce document constitue le cadre de référence pour toute initiative IA chez Sani Marc. Il doit être lu, compris et signé par tout intervenant travaillant avec des systèmes d'intelligence artificielle, qu'il soit employé, partenaire ou fournisseur. Il est vivant : il évolue avec la réglementation et la maturité organisationnelle.

---

## 1. Introduction

La présente charte définit les principes, les valeurs et les lignes directrices encadrant le développement, le déploiement et l'utilisation des solutions d'intelligence artificielle au sein de **Sani Marc**.

Depuis plus de 50 ans, Sani Marc accompagne les organisations canadiennes dans leur quête d'excellence en hygiène, désinfection et assainissement. L'intelligence artificielle représente un levier stratégique pour amplifier cette mission : améliorer la précision des recommandations, automatiser les tâches à faible valeur ajoutée, et offrir une expérience client plus personnalisée et proactive.

> 💡 **Pourquoi cette charte ?** L'adoption de l'IA comporte des risques réels : biais algorithmiques, fuites de données, dépendance excessive à des systèmes opaques. Cette charte protège Sani Marc, ses clients, ses employés et sa réputation bâtie sur 50 ans de confiance.

Cette charte vise à :

- Assurer une utilisation **responsable, éthique et sécurisée** de l'IA
- Protéger les **données sensibles** et les droits des individus
- Garantir la **conformité réglementaire** (Loi 25, LPRPDE, Loi C-27/LEAI)
- Maximiser la **valeur d'affaires** des initiatives IA
- Établir une **culture IA** durable au sein de l'organisation

---

## 2. Portée

Cette charte s'applique à :

| Qui | Périmètre |
|-----|-----------|
| **Tous les employés** | Permanents, temporaires, stagiaires |
| **Partenaires et fournisseurs** | Accès aux systèmes ou données Sani Marc |
| **Systèmes d'IA** | Outils grand public (ChatGPT, Claude, Copilot), solutions internes, modèles sur mesure |
| **Cas d'usage** | Expérimentation, POC, pilote, production |
| **Données** | Toute donnée traitée par un système IA, peu importe sa classification |

> 💡 **Enrichissement :** La portée inclut explicitement les **données en transit** vers des APIs externes. Un employé copiant une liste de clients dans ChatGPT est visé par cette charte, même si l'outil n'est pas officiellement déployé par Sani Marc.

---

## 3. Principes fondamentaux de l'IA

L'organisation s'engage à ancrer toutes ses initiatives IA dans les principes suivants. Ces principes s'inspirent du cadre de l'OCDE, de la Déclaration de Montréal pour une IA responsable, et des obligations légales québécoises et canadiennes.

### 3.1 Non-discrimination et équité algorithmique

Les systèmes d'IA ne doivent introduire aucun biais injuste fondé sur l'âge, le sexe, l'origine, la langue ou tout autre critère protégé. Tout modèle déployé doit être testé pour détecter les biais avant mise en production.

> 💡 **Exemple concret chez Sani Marc :** Un modèle de priorisation des clients pour la maintenance ne doit pas avantager systématiquement les grands comptes au détriment des clients de régions éloignées.

### 3.2 Liberté et autonomie humaine (*Human-in-the-Loop*)

L'IA soutient la prise de décision humaine sans la supplanter. Toute décision ayant un impact significatif (commercial, RH, sécurité) nécessite une validation par un humain qualifié.

### 3.3 Dignité humaine

Aucun système d'IA ne doit être conçu ou utilisé pour surveiller, manipuler, ou porter atteinte à l'intégrité physique ou psychologique des individus.

### 3.4 Protection de la vie privée et des données

Les données personnelles collectées ou traitées par un système IA sont soumises aux obligations de la **Loi 25 (Québec)**, de la **LPRPDE (fédéral)** et des clauses contractuelles applicables. Le principe de minimisation des données s'applique : ne collecter que ce qui est strictement nécessaire.

> 💡 **Loi 25 – Points clés :** Consentement explicite, droit d'accès et de rectification, obligation de divulguer les décisions automatisées touchant les individus, nomination d'un responsable de la protection des renseignements personnels (RPRP).

### 3.5 Explicabilité et transparence

Sani Marc favorise les systèmes d'IA **explicables** (XAI — *Explainable AI*). Lorsqu'une décision automatisée affecte un individu, il doit être possible d'en comprendre les raisons principales.

> 💡 **Enrichissement :** Ce principe est absent de la version initiale. L'explicabilité est une exigence croissante en droit (Loi C-27) et une attente légitime des clients, notamment dans les secteurs alimentaires et de la santé.

### 3.6 Durabilité environnementale

L'entraînement et l'exploitation de grands modèles d'IA consomment des ressources énergétiques significatives. Sani Marc s'engage à prioriser les solutions IA proportionnées à la valeur générée et à mesurer l'empreinte carbone de ses infrastructures IA.

### 3.7 Diversité, équité et justice sociale

Les équipes impliquées dans le développement IA doivent refléter la diversité de l'organisation et de sa clientèle. Les datasets doivent être représentatifs et régulièrement audités.

---

## 4. Quatre piliers pour le succès de l'IA

> 💡 **Note :** Ces quatre piliers constituent le modèle opérationnel de réussite pour Sani Marc. Ils doivent être adressés conjointement — négliger l'un compromet l'ensemble.

### 4.1 Acculturation

| Action | Responsable | Fréquence |
|--------|-------------|-----------|
| Sensibilisation aux usages et risques de l'IA | RH + TI | À l'embauche |
| Formation au prompting efficace et sécurisé | TI | Trimestrielle |
| Ateliers par département sur les cas d'usage | Comité IA | Semestrielle |
| Communication sur les nouveaux outils approuvés | TI | Au besoin |

> 💡 **Enrichissement :** La formation doit être différenciée par profil : un représentant des ventes n'a pas les mêmes besoins qu'un ingénieur de données. Sani Marc doit développer des parcours de formation adaptés par département.

### 4.2 Robustesse

- Modèles testés sur des jeux de données représentatifs avant déploiement
- Mécanismes de détection des hallucinations et des dérives (*drift monitoring*)
- Procédures de *fallback* humain en cas de défaillance du modèle
- Tests adversariaux (résistance aux attaques de type *prompt injection*)
- Plans de continuité pour les systèmes IA critiques

### 4.3 Qualité des données

Chez Sani Marc, les données proviennent de systèmes hétérogènes (M3, D365, terrain). La qualité des données est un prérequis non négociable à toute initiative IA.

- Catalogue de données avec classification (public, interne, confidentiel, secret)
- *Data lineage* documenté pour les modèles en production
- Processus de validation et de nettoyage des données avant ingestion
- Fréquence de rafraîchissement définie et respectée

> 💡 **Enrichissement :** Ajouter un indicateur de qualité des données (Data Quality Score) pour chaque dataset utilisé en IA. Cible recommandée : ≥ 95 % de complétude et de cohérence.

### 4.4 Conformité réglementaire

| Cadre | Applicabilité | Statut |
|-------|--------------|--------|
| **Loi 25** (Québec) | Toutes données de résidents québécois | Obligatoire — en vigueur |
| **LPRPDE** | Activités commerciales inter-provinciales | Obligatoire |
| **Loi C-27 / LEAI** | Systèmes IA à impact élevé | À surveiller (adoption en cours) |
| **EU AI Act** | Systèmes déployés pour clients européens | À surveiller |
| **ISO/IEC 42001** | Système de management IA | Recommandé |

---

## 5. Règles d'utilisation de l'IA

### 5.1 Classification des outils IA

Avant toute utilisation, chaque outil doit être classifié et approuvé :

| Catégorie | Exemples | Utilisation autorisée |
|-----------|----------|----------------------|
| **Approuvés — Standard** | Microsoft Copilot (M365), GitHub Copilot | Données internes non sensibles |
| **Approuvés — Restreints** | Azure OpenAI (tenant privé) | Avec contrôles de sécurité validés |
| **En évaluation** | Nouveaux outils soumis au processus d'approbation | POC isolé, données anonymisées uniquement |
| **Non approuvés** | ChatGPT public, outils sans entente de confidentialité | **Interdit** pour données professionnelles |

> 💡 **Enrichissement :** La liste des outils approuvés est maintenue par la Direction TI et publiée sur l'intranet. Toute demande d'ajout passe par le formulaire de demande d'approbation d'outil IA.

### 5.2 Données sensibles

**Il est strictement interdit de :**

- Saisir des informations personnelles de clients, employés ou partenaires dans des outils IA non approuvés
- Exposer des données financières, des formules de produits, des secrets commerciaux ou du code propriétaire
- Soumettre des données relatives à la sécurité alimentaire ou aux protocoles de désinfection sans approbation
- Contourner les mesures de pseudonymisation ou d'anonymisation

> 💡 **Rappel Loi 25 :** Toute divulgation accidentelle de renseignements personnels à un tiers (y compris un outil IA externe) peut constituer un incident de confidentialité à déclarer à la Commission d'accès à l'information (CAI).

### 5.3 Validation humaine (*Human-in-the-Loop*)

| Niveau de décision | Exemple | Validation requise |
|-------------------|---------|-------------------|
| **Critique** | Licenciement, sécurité alimentaire, réclamation client majeure | Direction + validation documentée |
| **Significative** | Recommandation de produit, priorisation de maintenance | Chef d'équipe |
| **Opérationnelle** | Rédaction d'e-mail, résumé de document | Auto-validation de l'employé |

### 5.4 Transparence envers les tiers

- Informer explicitement les clients ou partenaires lorsqu'un système IA traite leurs données ou génère des recommandations les concernant
- Documenter les limites et les incertitudes des modèles utilisés
- Mentionner l'usage de l'IA dans les communications lorsque cela est pertinent

### 5.5 Sécurité — Menaces à surveiller

| Menace | Description | Mesure de mitigation |
|--------|-------------|---------------------|
| **Prompt injection** | Manipulation du modèle via des instructions malveillantes | Validation des entrées, sandboxing |
| **Data leakage** | Fuite de données sensibles via les réponses du modèle | Filtres de sortie, audit des logs |
| **Data poisoning** | Contamination des données d'entraînement | Contrôle d'intégrité, validation des sources |
| **Model inversion** | Reconstitution de données d'entraînement depuis le modèle | Anonymisation renforcée, *differential privacy* |
| **Shadow AI** | Usage non déclaré d'outils IA personnels | Sensibilisation, politique d'utilisation acceptable |

---

## 6. Gouvernance de l'IA

### 6.1 Structure de gouvernance

```
Comité de Direction
        │
        ▼
   Comité IA ←──────── Responsable Protection des Données (RPRP)
        │
   ┌────┴────┐
   ▼         ▼
Architectes  Sécurité TI
   │         │
   ▼         ▼
Data Teams   ─────── Utilisateurs (Champions IA par département)
```

### 6.2 Rôles et responsabilités

| Rôle | Responsabilités clés |
|------|---------------------|
| **Comité IA** | Orientation stratégique, arbitrage des priorités, approbation des outils, révision annuelle de la charte |
| **Directeur TI** | Supervision de la gouvernance technique, approbation finale des déploiements |
| **RPRP (Loi 25)** | Conformité en matière de protection des données, déclaration à la CAI, réponse aux demandes d'accès |
| **Architectes IA** | Conception des solutions, revue de conformité technique, documentation |
| **Équipe Sécurité** | Évaluation des risques, tests d'intrusion, gestion des incidents |
| **Data Teams** | Qualité, gouvernance et documentation des datasets |
| **Champions IA** | Ambassadeurs par département, remontée de besoins, soutien à l'adoption |
| **Tous les employés** | Respect de la charte, signalement des incidents |

### 6.3 Cycle de vie d'un système IA

```
1. Idéation ──► 2. Évaluation des risques ──► 3. Approbation Comité IA
                                                        │
4. Surveillance ◄── 5. Déploiement ◄── 4. Développement & Validation
        │
6. Révision/Retrait
```

> 💡 **Enrichissement :** Chaque étape doit produire un livrable documenté. L'étape 2 (Évaluation des risques) utilise la grille d'évaluation standardisée du Comité IA. Aucun système ne peut passer en production sans avoir complété les étapes 1 à 4.

### 6.4 Gestion des fournisseurs et outils tiers

Tout fournisseur d'outil ou de service IA doit satisfaire aux exigences suivantes avant approbation :

- Accord de confidentialité (NDA) signé
- Entente de traitement de données conforme à la Loi 25
- Politique de rétention et de suppression des données documentée
- Localisation des données (préférence : Canada ou infrastructure souveraine)
- Processus de revue annuelle du fournisseur

---

## 7. Gestion des incidents IA

> 💡 **Enrichissement :** Section absente de la version initiale. La gestion des incidents est critique pour maintenir la confiance et respecter les obligations légales (délai de 72h pour déclaration à la CAI en cas d'incident de confidentialité).

### 7.1 Classification des incidents

| Sévérité | Description | Exemple | Délai de réponse |
|----------|-------------|---------|-----------------|
| **Critique** | Impact sur la sécurité des personnes ou violation légale | Fuite de données personnelles | < 4 heures |
| **Élevé** | Défaillance majeure d'un système IA en production | Recommandations erronées en sécurité alimentaire | < 24 heures |
| **Modéré** | Comportement inattendu sans impact immédiat | Hallucinations fréquentes dans un rapport | < 72 heures |
| **Faible** | Anomalie mineure ou question de performance | Réponse lente | Prochaine fenêtre de maintenance |

### 7.2 Procédure de signalement

1. **Détection** : Tout employé ayant observé un comportement anormal doit le signaler immédiatement
2. **Canal** : Billetterie TI (urgent) ou formulaire d'incident IA sur l'intranet
3. **Escalade** : TI → Sécurité → RPRP → Comité IA selon la sévérité
4. **Déclaration CAI** : Dans les 72h si des renseignements personnels sont compromis
5. **Post-mortem** : Obligatoire pour tout incident de sévérité Critique ou Élevé

---

## 8. Cas d'usage autorisés et interdits chez Sani Marc

> 💡 **Enrichissement :** Les cas d'usage ont été adaptés au contexte métier de Sani Marc (hygiène, agroalimentaire, soins de santé, piscines, maintenance d'équipements).

### 8.1 Cas d'usage autorisés (sans restriction particulière)

- Assistance à la rédaction de documentation interne et de rapports
- Résumé automatique de notes de réunion et d'e-mails
- Génération de code avec GitHub Copilot (révision humaine obligatoire)
- Analyse de données anonymisées ou agrégées
- Recherche de produits et recommandations internes (catalogue)
- Traduction et reformulation de communications clients

### 8.2 Cas d'usage autorisés avec encadrement strict

| Cas d'usage | Conditions requises |
|-------------|---------------------|
| Recommandations de protocoles de désinfection | Validation obligatoire par un expert terrain avant transmission au client |
| Analyse de données clients pour personnalisation | Consentement client, anonymisation, approbation RPRP |
| Maintenance prédictive des équipements | Modèle validé, humain dans la boucle pour décision d'intervention |
| Chatbot client (SaniHub) | Escalade vers humain pour cas hors périmètre, divulgation de l'IA obligatoire |
| Analyse de tendances agroalimentaires | Sources de données validées, conformité aux normes HACCP |

### 8.3 Cas d'usage interdits (sans approbation spéciale)

- Décisions RH automatisées (embauche, promotion, licenciement)
- Analyse de données de santé sans anonymisation et consentement explicite
- Systèmes de surveillance ou de notation comportementale des employés
- Génération de contenu trompeur ou imitant un humain sans divulgation
- Toute utilisation de données de sécurité alimentaire dans des outils non approuvés

---

## 9. Mesure et amélioration continue

### 9.1 Indicateurs de performance (KPIs)

| Indicateur | Cible | Fréquence de mesure |
|------------|-------|---------------------|
| Taux de conformité à la charte (audits) | ≥ 95 % | Trimestrielle |
| Nombre d'incidents IA signalés | 0 critique / trimestre | Mensuelle |
| Taux de complétion des formations obligatoires | 100 % des employés concernés | Semestrielle |
| Nombre d'outils IA approuvés vs utilisés | Ratio ≥ 90 % | Trimestrielle |
| Délai moyen d'approbation d'un nouvel outil IA | ≤ 15 jours ouvrables | Trimestrielle |
| Data Quality Score des datasets IA | ≥ 95 % | Mensuelle |

### 9.2 Processus d'amélioration

- **Audits internes** : Revue semestrielle par le Comité IA
- **Audit externe** : Annuel, par un tiers indépendant (préconisé dès 2027)
- **Veille réglementaire** : Mise à jour de la charte à chaque changement législatif majeur
- **Feedback employés** : Sondage biannuel sur l'adoption et les besoins en formation
- **Revue de la charte** : Complète tous les 12 mois, partielle à chaque incident majeur

---

## 10. Engagement de l'organisation

Sani Marc s'engage à :

- Déployer une IA **éthique, sécurisée et responsable**, au service de sa mission d'excellence en hygiène
- **Protéger les données** de ses clients, partenaires et employés avec rigueur
- Assurer une **adoption durable et maîtrisée**, en investissant dans la formation et l'accompagnement
- Respecter et **anticiper les obligations légales** québécoises, canadiennes et internationales
- Maintenir la **confiance** qui est au cœur de la relation Sani Marc avec ses clients depuis 50 ans
- **Revoir et améliorer** cette charte au fil de l'évolution des technologies et des pratiques

---

## 11. Conclusion

L'intelligence artificielle représente une opportunité stratégique majeure pour Sani Marc dans sa mission de transformer les défis d'hygiène en opportunités de performance et de confiance. Son succès repose sur un équilibre entre **innovation, gouvernance et responsabilité**.

Cette charte n'est pas une contrainte : c'est un **avantage concurrentiel**. Les organisations qui maîtrisent leur IA de manière éthique et transparente bâtissent une relation de confiance durable avec leurs parties prenantes.

> 💡 **Message final :** Chaque employé de Sani Marc est un acteur de la réussite de l'IA responsable. Le respect de cette charte, le signalement des anomalies et la participation aux formations sont des gestes concrets qui protègent l'organisation et ses clients.

---

## 12. Glossaire

| Terme | Définition |
|-------|-----------|
| **IA (Intelligence Artificielle)** | Systèmes capables de réaliser des tâches nécessitant normalement l'intelligence humaine |
| **LLM** | Grand modèle de langage (*Large Language Model*), ex. GPT-4, Claude |
| **Hallucination** | Réponse d'un modèle IA présentée avec confiance mais factuellement incorrecte |
| **Prompt injection** | Attaque consistant à manipuler un modèle IA via des instructions malveillantes cachées dans les données |
| **Data drift** | Dégradation de la performance d'un modèle due à l'évolution des données en production |
| **Human-in-the-Loop** | Approche intégrant une validation humaine à des étapes clés du processus IA |
| **XAI** | IA explicable (*Explainable AI*) — capacité à justifier les décisions d'un modèle |
| **RPRP** | Responsable de la Protection des Renseignements Personnels (obligation Loi 25) |
| **CAI** | Commission d'accès à l'information du Québec — autorité de contrôle pour la Loi 25 |
| **Loi 25** | Loi québécoise modernisant la protection des renseignements personnels (en vigueur depuis 2023) |
| **LEAI** | Loi sur l'intelligence artificielle et les données (Loi C-27, fédérale) |
| **Shadow AI** | Usage non déclaré et non approuvé d'outils IA par des employés |

---

## 13. Annexes

### Annexe A — Processus d'approbation d'un outil IA

```
Employé/Département ──► Formulaire de demande ──► Évaluation TI (sécurité, conformité)
                                                          │
                              ◄── Approbation/Refus ◄── Comité IA (si données sensibles)
                              │
                    Publication dans le catalogue
                    des outils approuvés (intranet)
```

### Annexe B — Contacts

| Rôle | Contact |
|------|---------|
| Comité IA | comite-ia@sanimarc.com |
| RPRP (Loi 25) | protection-donnees@sanimarc.com |
| Sécurité TI | securite-ti@sanimarc.com |
| Signalement d'incident | incidents-ia@sanimarc.com |

### Annexe C — Références et cadres de référence

- [Déclaration de Montréal pour un développement responsable de l'IA](https://declarationmontreal-iaresponsable.com/)
- [Principes directeurs de l'OCDE sur l'IA](https://oecd.ai/en/ai-principles)
- [Commission d'accès à l'information — Loi 25](https://www.cai.gouv.qc.ca/)
- [Règlement européen sur l'IA (EU AI Act)](https://artificialintelligenceact.eu/)
- [ISO/IEC 42001 — Système de management de l'IA](https://www.iso.org/standard/81230.html)

---

*Document approuvé par le Comité de Direction de Sani Marc — Avril 2026*  
*Prochaine révision obligatoire : Avril 2027*