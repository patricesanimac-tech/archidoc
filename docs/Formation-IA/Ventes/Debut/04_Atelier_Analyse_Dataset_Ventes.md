# Module 4 : Atelier pratique - Analyser un dataset de ventes

**Niveau**: Début  
**Durée**: 3 heures  
**Format**: Hands-on Atelier  
**Public cible**: Équipes commerciales (par petit groupe)

---

## 📌 Objectifs du module

À la fin de ce module, vous serez capable de :

✅ Charger et explorer un dataset réel (Excel/CSV)  
✅ Identifier patterns dans données ventes  
✅ Poser les bonnes questions aux données  
✅ Générer insights actionables  
✅ Communiquer résultats aux décideurs  

---

## 📚 Contenu du cours

### Section 1 : Préparation de l'atelier (30 min)

#### Outils requis

**Option 1 : Excel (Recommandé pour débutants)**
- ✅ Déjà installé chez vous
- ✅ Pas de code programmation
- ✅ Pivot tables = "IA décisionnelle"
- ⚠️ Limité à ~1M lignes

**Option 2 : Python (Data Scientists)**
- ✅ Plus puissant
- ✅ Peut traiter millions de lignes
- ⚠️ Demande apprentissage code

**Pour cet atelier** : Excel + Pivot tables (accessible à tous)

---

#### Le dataset Sani Marc

**Contexte** :
```
Sani Marc a 12 mois de données ventes :
- 486 contacts
- 158 leads convertis (32.5% conversion)
- 328 leads non-convertis (67.5% lost)
```

**Variables disponibles** :
```
│ Contact_Name     │ Acme Corp
├─ Company_Size   │ 250 employees
├─ Industry       │ Manufacturing
├─ Region         │ Montréal QC
├─ Lead_Score     │ 72 (0-100)
├─ Budget_Range   │ 50-100K$
├─ Current_Solution│ Competitor X
├─ Days_to_Close  │ 45 days
├─ Proposal_Value │ 75,000$
├─ Converted      │ Yes/No
└─ Close_Date     │ 2026-03-15
```

**Fichier** : `docs/Formation-IA/Ressources-Communes/sani_marc_sales_data.csv`

---

### Section 2 : Exploration des données (45 min)

#### 2.1 Charger le dataset dans Excel

**Étape 1 : Ouvrir le fichier**
```
Excel → Fichier → Ouvrir
→ Chercher: sani_marc_sales_data.csv
→ Cliquer
```

**Étape 2 : Vérifier l'import**
```
Questions:
- Toutes les colonnes visibles? ✓
- Nombres formatés correctement? ✓
- Dates en format correct? ✓
```

---

#### 2.2 Questions exploratoires

**Q1 : Combien de leads par industrie?**

```
Industrie      # Leads  # Convertis  Conversion %
─────────────────────────────────────────────
Healthcare     125      52          41.6% ⭐ (MEILLEUR)
Manufacturing  148      38          25.7%
Hospitality    95       42          44.2% ⭐⭐ (CHAMPION)
Food&Beverage  75       22          29.3%
Education      43       4           9.3% ❌ (WORST)

→ Insight: Healthcare + Hospitality = conversion 40%+ (focus!)
```

**Q2 : Quelle taille entreprise convertit?**

```
Company Size   # Leads  Conversion %
─────────────────────────────────
Small (<50)    142      18% ❌ (Faible)
Medium (50-500) 215    35% ✓ (Bon)
Large (>500)   129     42% ⭐ (Excellent)

→ Insight: Cibler entreprises >50 employés
```

**Q3 : Budget vs Conversion?**

```
Budget $       # Leads  Conversion %
─────────────────────────────────
<25K           87       15% ❌
25-50K         168      28% ✓
50-100K        142      41% ⭐
>100K          89       52% ⭐⭐

→ Insight: Budget >50K = conversion double
```

**Q4 : Region performance?**

```
Region         Conversion %  Leads  Revenue
──────────────────────────────────────────
Montréal       38%          124    3.2M$
Toronto        35%          98     2.4M$
Vancouver      28%          106    1.8M$
Autres         22%          158    1.2M$

→ Insight: Montréal meilleur marché (focus expansion?)
```

---

### Section 3 : Analyse des patterns (45 min)

#### 3.1 Lead Scoring - Qui convertit réellement?

**Méthode** :
1. Trier par `Lead_Score`
2. Puis par `Converted` (Yes/No)
3. Voir patterns

```
Lead_Score (0-100)  Convertis  % Conversion
───────────────────────────────
0-20               2/45          4.4% ❌❌❌
20-40              6/82         7.3% ❌
40-60              24/137       17.5% ⚠️
60-80              71/141       50.4% ✅
80-100             55/81        67.9% ⭐⭐⭐

→ Insight: Score < 40 = presque 0 conversion (stop effort!)
→ Score 60-80 = meilleur ROI (focused effort)
→ Score 80+ = conversion très haute mais peu leads
```

**Recommandation** :
```
Stratégie scoring:
├─ <40 : Nurturing emails seulement (pas d'appel)
├─ 40-60: Auto-response + escalade si réaction
├─ 60-80: Appel vendeur (conversion 50%+)
└─ 80+: Sales director appelle (conversion 68%+)

Impact: Concentration meilleure + conversion +15%
```

---

#### 3.2 Cycle de vente par segment

**Question**: "Combien de temps pour fermer un deal?"

```
Segment          Days_to_Close avg.  Conversion %
─────────────────────────────────────────
Healthcare       38 jours            41.6%
Manufacturing    52 jours            25.7%
Hospitality      31 jours ⭐         44.2%
Food&Beverage    45 jours            29.3%
Education        89 jours ❌         9.3%

→ Insight: Hospitality = cycle court + conversion ✅
→ Insight: Education = cycle long + faible conversion → abandon?
```

**Bonne pratique**:
```
Si cycle > 60 jours ET conversion < 20%
→ Réévaluer investissement
→ Possib de redéployer ressources
```

---

#### 3.3 Current Solution vs Conversion

**Question**: "Quel concurrent bloque nos ventes?"

```
Current Competitor  # Leads  Conversion %
─────────────────────────────────────
Aucun concurrent    112      58% ⭐⭐ (Nouveau marché)
Competitor A        189      31% ✓ (Battable)
Competitor B        98       18% ❌ (Very competitive)
In-house solutions  87       12% ⚠️ (Embedded)

→ Insight: "Aucun concurrent" = easiest wins → priorité
→ Insight: Competitor B = coûteux à conquérir → avoid
→ Insight: In-house = besoin démonstration ROI (messaging)
```

**Stratégie**:
```
1. Doubler effort sur "Aucun concurrent" (58% conversion)
2. Développer messaging vs Competitor A (31% battable)
3. Reévaluer vs Competitor B (18% pas rentable)
```

---

### Section 4 : Modèle prédictif simple (45 min)

#### 4.1 Créer un simple Lead Scoring Formula

**Objectif** : Prédire qui convertira avec règle simple (pas ML complexe)

**Données du passé**:
```
Rechercher dans Excel :
Lorsque conversion = YES :
  ├─ Score moyen: 71
  ├─ Budget/proposition: 67K$ moyen
  ├─ Industry: Hospitality + Healthcare 65%
  └─ Company size: >50 employees 80%

Rechercher dans Excel :
Lorsque conversion = NO :
  ├─ Score moyen: 34
  ├─ Budget/proposition: 28K$ moyen
  ├─ Industry: Education + Food 40%
  └─ Company size: <50 employees 55%
```

**Créer formule scoring** :
```
SCORE = 
  + (Lead_Score > 60) ? 30 points : 0
  + (Budget > 50K) ? 25 points : 0
  + (IN Healthcare, Hospitality) ? 20 points : 0
  + (Company_Size > 50) ? 15 points : 0
  + (Days_to_close < 50) ? 10 points : 0

Total: 0-100 points
```

**Résultat** :
```
Score calculé 80+: 68% conversion (actual) ✅ Match!
Score calculé 40-60: 18% conversion (actual) ✅ Match!
Score calculé <40: 5% conversion (actual) ✅ Match!

Notre simple formula prédit correctement! 🎉
```

---

#### 4.2 Appliquer scoring aux prospects actuels

**Étape 1** : Ajouter colonne "Predicted_Score" (avec formule)

```
Excel formule:
=IF(F2>60,30,0) + IF(G2>50000,25,0) + ...

Résultat pour 50 prospects actuels:
├─ 12 leads scoring 80+ (appeler immédiatement!)
├─ 18 leads scoring 60-80 (appeler cette semaine)
├─ 15 leads scoring 40-60 (nurturing)
└─ 5 leads scoring <40 ( archive/email)
```

**Impact potentiel** :
```
Avant: Appeler 50 leads (50 appels)
Après: Focus 12 leads 80+ (meilleur ROI)
       + 18 leads 60-80 (good ratio)
       = 30 appels seulement (40% réduction efforts)
       
Mais conversion rate passe de 32% → 45%+
= Plus de résultats avec MOINS d'efforts! 📈
```

---

### Section 5 : Insights et recommandations (30 min)

#### 5.1 Résumer vos findings

**Template rapport** :

```
RAPPORT ANALYSE DONNÉES VENTES - [Votre Département]

1. TAILLE ÉCHANTILLON
   [Nombre leads]: 486
   [Conversion globale]: 32.5%

2. TOP INSIGHTS
   Insight 1: [Description] → Impact: [$ ou %]
   Insight 2: [Description] → Impact: [$ ou %]
   Insight 3: [Description] → Impact: [$ ou %]

3. SEGMENTS CIBLES
   Segment A: [Caractéristiques] → Conversion 50%+
   Segment B: [Caractéristiques] → Conversion 35%+

4. RECOMMANDATIONS ACTIONS
   Action 1: [Concrete] → Potentiel revenue: $XXK
   Action 2: [Concrete] → Potentiel gain temps: XX%
   Action 3: [Concrete] → Potentiel conversion: +XX%

5. NEXT STEPS
   [ ] Implémentation action 1 (responsable X, délai 2 semaines)
   [ ] Mesure KPI action 1 (tracking revenue/leads)
   [ ] Review résultats (réunion dans 6 semaines)
```

---

#### 5.2 Présenter aux décideurs

**Format** : 10 minutes, 3-5 slides

**Slide 1 : The Opportunity**
```
Titre: "Sani Marc peut augmenter conversion ventes de 32% à 45%"

Contenu:
- 486 leads analysés
- Pattern identifiés (lead score, industrie, budget)
- Opportunité: +13% conversion = +$200K revenue
- Timeline: 6 semaines pour implémenter

Visuel: Graph conversion baseline vs. potentiel
```

**Slide 2 : Profile du prospect gagnant**

```
Qui convertit vraiment:

✅ Industry: Hospitality (44%) + Healthcare (42%)
✅ Budget: >50K$ (41%)
✅ Company size: >50 employees (35%+)
✅ Lead score IA: 60+ (50%)
✅ Cycle: <45 jours

Recommandation: Focus ces segments uniquement
```

**Slide 3 : Actions et ROI**

```
3 Actions immédiates:
1. Implémenter lead scoring (1 semaine)
   → Impact: 30% réduction effort, +15% conversion
   
2. Retrainer vendeurs (segment-focus)
   → Impact: Appels plus pertinents
   
3. Arrêter secteurs faibles (Education, Petit budgets)
   → Impact: Redéployer ressources vers high-ROI

Total potentiel: $200K revenue supplémentaire
Coût implémentation: <$5K
ROI: 40x en 12 mois
```

---

### Section 6 : Cas d'étude avancés (pratique optionnelle)

#### Cas étude 1 : Pourquoi conversion Education = 9% ?

```
Hypothèses à tester:

H1: "Budgets trop bas"
Analyse: Budget Education = 15K moyen vs 67K autres
→ Confirme! Proposer solutions à la baisse?

H2: "Cycle trop long + multiple stakeholders"
Analyse: Days_to_close Education = 89j vs 38j autres
→ Confirme! Besoin change management messaging?

H3: "Déjà solutions in-house"
Analyse: 60% Education = in-house solutions
→ Confirme! Obstacle ROI démonstration?

Recommandation: Abandon segment Education + message ROI
```

---

#### Cas étude 2 : Pourquoi Manufacturing underperform?

```
Données Manufacturing:
├─ Leads: 148
├─ Conversion: 25.7%
├─ Cycle: 52 jours (long)
├─ Budget: 35K$ moyen (bas)
├─ Competitor: Competitor A (35% conversion ailleurs)

Questions:
1. Est-ce le marché diffilce?
   → Non, Healthcare fait 42% conversion
   
2. Est-ce notre positioning?
   → Peut-être. Competitor A = 35% vs notre 26%
   
3. Les vendeurs struggle?
   → Vérifier. Peut-être besoin coaching
   
4. Produit ne match pas needs?
   → Possible. Audit solution fit?

Recommandation: Deep dive ventes Manufacturing
Potentiel: Si on passe de 26% → 35% = +$300K$ revenue
```

---

## 🎯 Résumé des points clés

1. **Données réelles** = Insights vrais
2. **Patterns simples** = Impactful recommendations
3. **Score = Priorisation** (effort → résultats)
4. **Segments ciblés** = Meilleure conversion
5. **Communication** = Critical (insights → actions)

---

## 📋 Exercices post-atelier

### Exercice 1 : Votre propre analyse

Télécharger `sani_marc_sales_data.csv`

Pick 1 question et répondre:
```
Q: [Votre question]

Analyse:
├─ Données utilisées: [List variables]
├─ Finding principal: [Description]
└─ Recommandation: [Action concrète]

Impact estimé:
├─ Revenue: [Potentiel $]
├─ Time saved: [Heures/semaine]
└─ Conversion: [+X%]
```

### Exercice 2 : Scoring Your Prospects

Prendre vos 10 leads actuels
Appliquer simple scoring formula (Section 4.1)

```
Lead Name      | Predicted Score | Action
───────────────┼─────────────────┼─────────────
Acme Corp      | 82              | Call today
...            | ...             | ...
```

Résultat: 
- [ ] Identifié 2-3 leads 80+ (appeler)
- [ ] Identifié segments mid-value (nurture)
- [ ] Identifié segments low-value (archive)

---

## 📞 Support

- **Données dataset** : Voir Ressources-Communes/
- **Excel pivot tables** : Microsoft Office support
- **Questions analyses** : #ia-sani-marc sur Slack
- **Prochaine étape** : Module 5 - Éthique données