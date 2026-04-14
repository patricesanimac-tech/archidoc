# Module 5 : Éthique et gouvernance des données commerciales

**Niveau**: Début  
**Durée**: 2 heures  
**Format**: Discussion + Cas pratiques  
**Public cible**: Tous les niveaux (ventes, IT, management)

---

## 📌 Objectifs du module

À la fin de ce module, vous serez capable de :

✅ Comprendre les lois de protection données (RGPD, PIPEDA)  
✅ Appliquer les bonnes pratiques éthique IA chez Sani Marc  
✅ Identifier les risques discrimination algorithmes  
✅ Prendre décisions éthiques avec données clients  
✅ Documenter votre utilisation IA pour conformité  

---

## 📚 Contenu du cours

### Section 1 : Contexte légal Canada/Québec (30 min)

#### 1.1 PIPEDA : La loi fédérale

**Qu'est-ce que c'est?**
```
Personal Information Protection and Electronic Documents Act
= Loi fédérale Canadian (tous provinces sauf AB, BC, MB)
```

**5 Principes clés** :

| # | Principe | Implication | Pour Sani Marc |
|---|---|---|---|
| **1** | **Accountability** | Vous avez VOUS responsabilité | Sani Marc = responsable IA ventes |
| **2** | **Identifying Purpose** | Dire pourquoi on collecte | "Scoring pour personaliser offres" |
| **3** | **Consent** | Obtenir permission client | Prospect opt-in mail = OK pour IA |
| **4** | **Limiting Collection** | Collecter minimal nécessaire | Pas besoin prénom mère pour score |
| **5** | **Accuracy** | Données correctes | Audits qualité données requis |

---

#### 1.2 LPRPDE Québec (plus strict)

**Approche** : Plus protective que PIPEDA
```
Si Sani Marc opère au Québec → appliquer LPRPDE
(Note: LPRPDE > PIPEDA = appliquer highest standard)
```

**Règles striction Québec** :
- ✅ Consent explicite (opt-in) souvent requis
- ✅ Droit à l'oubli (deletion données)
- ✅ Notification breaches (si sécurité compromise)

---

#### 1.3 Pratiques Sani Marc

**Politique current** :
```
Sani Marc = opère Canada-wide
Appliquer PIPEDA minimum + LPRPDE si Québec
= Highest standard automatiquement

Governance:
├─ DPO (Data Protection Officer): [X person in IT]
├─ Privacy impact assessments: [Annual audit]
├─ Vendor agreements: [Cover propriétés données]
└─ Training: [Yearly pour staff]
```

---

### Section 2 : Consentement et transparence (30 min)

#### 2.1 Qu'est-ce qu'un consentement valide?

**❌ MAUVAIS consentement**:
```
Prospect visite site Sani Marc
  ↓
Cookies auto-activé (sans demander)
+ Profil créé en D365 (sans notification)
+ Analyse IA lancée
  ↓
Legal risk: PIPEDA violation possible!
```

**✅ BON consentement** :
```
Prospect visite site
  ↓
"Sani Marc utilise IA pour noter leads
Cliquez OUI si d'accord avec scoring automatique"
  ↓
Prospect: OUI/NON
  ↓
If OUI → Profil + Scoring OK
If NON → Pas d'IA usage
```

---

#### 2.2 Transparence : Expliquer l'IA

**Question prospect**: "Comment vous avez le score 75?"

**❌ MAUVAISE réponse**:
```
"Notre IA a décidé" ← Trop vague, pas acceptable
```

**✅ BONNE réponse** :
```
"Voici pourquoi nous vous avons classé 75/100:
├─ Industrie (Santé) = +20 pts (besoin hygiène)
├─ Taille (500 emp) = +15 pts (can afford solution)
├─ Budget 50-100K$ = +20 pts (good range)
├─ Engagement élevé = +20 pts (opened emails)
└─ Score final = 75/100

Vous pouvez contester en écrivant X@sanimarc.com"
```

**Avantage** :
- ✅ Legal compliant (explainability requis par law)
- ✅ Trust accrue (transparency = confidence)
- ✅ Prospect peut corriger données

---

#### 2.3 Droit à l'oubli ("Right to be forgotten")

**Droit légal** :
```
À tout moment, prospect peut demander:
"Supprimez mes données!"
```

**Sani Marc obligation** :
```
Timeline: 30 jours (max)

Process:
1. Prospect: "Je retire my data"
2. Sani Marc: Vérifie identité (prevent fraud)
3. Sani Marc: Delete all records
   ├─ D365 (CRM)
   ├─ Email lists
   ├─ BI dashboards (anonimized)
   └─ Backups (when possible)
4. Sani Marc: Confirm à prospect

Note: Quelques exceptions légales (invoicing, compliance)
mais général = delete demandé
```

---

### Section 3 : Discrimination et biais algorithmiques (30 min)

#### 3.1 Qu'est-ce que la discrimination?

**Définition** :
```
Traiter différemment 2 prospects identiques
basé sur protected characteristics:
├─ Gender (homme/femme)
├─ Race/Ethnicity
├─ Religion
├─ Age
├─ Disability
└─ Sexual orientation
```

**Enjeu IA** :
```
L'algorithme peut discriminer SANS intention
si données historiques biaisées.

Exemple: "Modèle prédit conversion"
Donnée historique: 80% time winners = hommes (biais historique)
  ↓
Modèle apprend bias
  ↓
Résultat: Femmes entrepreneurs = scores +25% moins élevé
  ↓
Legal liability! ⚠️
```

---

#### 3.2 Sources de biais

**Source 1 : Biais historique**
```
Vos données ventes de 2020:
"Ventes à PME = 70% led par hommes (biais culturel)"
  ↓
Modèle apprend: "Homme = plus probable vente"
  ↓
Today: Refuse femmes entrepreneurs
```

**Source 2 : Data quality**
```
Secteur "Healthcare" proxy:
"Healthcare" = 80% hôpitaux (publics, diversité)
"Retail" = 90% petits commerces (owners: varied)
  ↓
Modèle peut apprendre "secteur" = proxy pour caractéristiques
```

**Source 3 : Features proxy**
```
Ne jamais utiliser :
├─ Zipcode (proxy pour race/wealth)
├─ Name (proxy pour ethnicity)
├─ Age (proxy pour gender dynamics)
└─ School name (proxy pour wealth)
```

---

#### 3.3 Tester et mitiger biais

**Test simple : Audit dataset**

```
Question: Est-ce notre dataset biaisé?

Audit:
1. Breakdown par gender (if recorded)
   "50% hommes, 50% femmes dans data?"
   ✓ Oui = Good
   ✗ 70/30 split = Potential bias

2. Breakdown par size entreprise
   "Representation small/medium/large?"
   ✓ Représentative = Good
   ✗ All large = Model biased vs SME

3. Breakdown par industriès
   "All sectors equally represented?"
   ✓ Oui = Good
   ✗ 90% manufacturi + 10% healthcare = Unbalanced
```

**Mitigation strategies** :

| Biais détecté | Stratégie |
|---|---|
| Sous-représentation groupe | Collecter plus données (oversampling) |
| Features proxy utilisés | Remplacer par meilleur feature |
| Historique discrimination | Remove données pré-biaisées |
| Modèle discriminattoire | Re-entrainer sans features problématiques |

---

### Section 4 : Cas pratiques à Sani Marc (30 min)

#### Cas 1 : Peut-on utiliser le prénom pour évaluer leads?

**Question** : "Name" correlates fortement avec decision-making → inclure?

**Analysis** :
```
Nom = prénom peut être proxy pour:
├─ Origine ethnique
├─ Religion
└─ Gender

Even si correlate avec conversion = NOT OK
Car violerait PIPEDA (discrimination)
```

**Decision** : ❌ Ne pas utiliser "name" en IA model

**Alternative** : Utiliser données non-discriminatoire
```
Au lieu de "name":
├─ Titre (Director, Manager, Owner)
├─ Email domain (company.com)
├─ Historique achat company
└─ Budget allocated
```

---

#### Cas 2 : Prospect est "en retard" payement

**Scenario** :
```
Prospect A: Historique excellent
Prospect B: 1 retard 2 ans ago
  ↓
Modèle: "Prospect B = risque élevé"
  ↓
Score: Prospect B = 30 (basse priorité)
  ↓
Question: Fair?
```

**Análisis** :
```
Faits:
- Prospect B = 1/5 payments late (80% on-time)
- May have been cash flow issue (temporary)
- Company still active, growing

Risk: Excluding based on 1 event = discrimination
si disproportionately affects certain group
```

**Decision** : 
```
✅ OK inclure dans modèle
✅ Mais: Weight < 5% (ne pas overweight)
✅ Include explainability: "Historical payment delay"
✅ Allow appeal: Call if score concerns
```

---

#### Cas 3 : Femmes entrepreneurs + Lead Score

**Data analysis** :
```
Dataset Ventes Sani Marc:
└─ Woman-founded companies = 15% dataset
└─ But conversion rate = 32% (vs 33% avg)
  ↓
Score model predicts:
└─ Woman-founded = 22% (vs avg 32%)
  ↓
Bias detected! ⚠️
```

**Root cause** :
```
Probability: 
1. Dataset small (woman-founded underrepresented)
2. Feature selection included proxy (e.g., "company age")
3. Feedback loop (women scored lower → called less → converted less)
```

**Fix**:
```
1. Over-sample woman-founded data (increase weight)
2. Remove proxy features potentially discriminatory
3. Retrain model
4. Test: Predicted score should be ~32% (not 22%)
5. Monitor: Quarterly audit for continued bias
```

---

### Section 5 : Governance à Sani Marc (30 min)

#### 5.1 Framework de gouvernance IA

```
SANI MARC IA GOVERNANCE

┌─────────────────────────────────────────┐
│   Steering Committee                    │
│   ├─ VP Commercial                      │
│   ├─ CTO / IT Director                  │
│   ├─ DPO (Data Protection Officer)      │
│   └─ Legal / Compliance                 │
└─────────────────────────────────────────┘
            ↓
    All AI initiatives ← Review
            ↓
┌─────────────────────────────────────────┐
│   Impact Assessment (before deploying)  │
│   ├─ Fairness audit                     │
│   ├─ Data privacy review                │
│   ├─ Security assessment                │
│   └─ Compliance check                   │
└─────────────────────────────────────────┘
            ↓
    Approved? → Deploy
            ↓
┌─────────────────────────────────────────┐
│   Monitoring (after deployment)         │
│   ├─ Performance tracking               │
│   ├─ Bias detection                     │
│   ├─ Data quality check                 │
│   └─ Complaint resolution               │
└─────────────────────────────────────────┘
```

---

#### 5.2 Checklist avant production

**Avant d'utiliser ANY IA model en ventes** :

- [ ] **Transparency** : Peut-on expliquer le score à prospect?
- [ ] **Bias audit** : Dataset biaisé? Features discriminatoires?
- [ ] **Consent** : Prospects ont-ils accepted automated scoring?
- [ ] **Accuracy** : Model performance acceptable? (80%+ minimum)
- [ ] **Data quality** : <5% missing values, no major outliers?
- [ ] **Security** : Data encrypted? Access controlled?
- [ ] **Appeal process** : Prospect can contest score?
- [ ] **Monitoring** : Plan pour check performance regularly?
- [ ] **Documentation** : Tout documenté pour compliance?

---

#### 5.3 Monitoring continu

**Quarterly audit** :

```
1. Bias check:
   Conversion rate par demographic = stable?

2. Performance:
   Model still predicts correctly? (accuracy > 80%?)

3. Data quality:
   Missing values increasing? Outliers detected?

4. Complaints:
   Any prospect complaints? Pattern?

5. Feedback:
   Vendeur feedback = model helpful?

If problème detected:
├─ Alert stakeholders
├─ Analyze root cause
├─ Plan remediation
└─ Re-train if needed
```

---

### Section 6 : Bonnes pratiques (15 min)

#### Principes clés

| Principe | Application |
|---|---|
| **Transparency** | Expliquer comment fonctionne IA |
| **Fairness** | Auditer biais, treat todos equally |
| **Accountability** | Clear ownership, responsibility |
| **Security** | Protéger données client |
| **Consent** | Demander permission avant IA |
| **Explainability** | Justifier decisions |
| **Appeal** | Allow contestation |
| **Monitoring** | Check ongoing fairness |

---

## 🎯 Résumé des points clés

1. **PIPEDA + LPRPDE** = lois fédérales/QC protection données
2. **Consentement valide** = critical légalement et éthiquement
3. **Biais algorithmique** = risque majeur (discrimination légale)
4. **Audit bias** = simple mais essentiel before production
5. **Governance framework** = qui decide, comment monitoring
6. **Monitoring continu** = pas one-time, requires surveillance

---

## 📋 Exercices pratiques

### Exercice 1 : Conformité check

Pour votre lead scoring model, répondre :

- [ ] Prospects ont consentement IA? (Y/N)
- [ ] Pouvez expliquer score? (Y/N)
- [ ] Audit biais fait? (Y/N)
- [ ] Appeal process défini? (Y/N)
- [ ] Monitoring plan exist? (Y/N)

Score: 5/5 = Ready for production

---

### Exercice 2 : Feature selection

Vous avez 20 features pour lead scoring. Identifier problématiques :

Features proposées:
```
✓ Company size
✓ Industry
✗ [Name] → PROBLEM: Ethnic proxy
✗ [Zip code] → PROBLEM: Wealth proxy
✓ Budget allocated
✗ [Age company] → PROBLEM: Can be age proxy
✓ Prior purchase history
```

Résultat: Retirer 3 features problématiques

---

## 📞 Contact pour questions

- **Compliance** : DPO@sanimarc.com
- **Ethical concerns** : [X manager]
- **Data access** : IT department
- **Community** : #ia-sani-marc