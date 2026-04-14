# Module 1 : Prédiction du potentiel client - Lead Scoring Avancé

**Niveau**: Moyen  
**Durée**: 3 heures  
**Format**: Théorie + Implémentation Excel  
**Public cible**: Gestionnaires ventes, analystes

---

## 📌 Objectifs du module

À la fin de ce module, vous serez capable de :

✅ Construire un modèle Random Forest de lead scoring  
✅ Valider la performance du modèle  
✅ Implémenter scoring en production (D365)  
✅ Mesurer l'impact business  
✅ Maintenir et re-entraîner le modèle  

---

## 📚 Contenu

### Section 1 : Architecte du scoring avancé (45 min)

#### 1.1 Score simple vs avancé

**Score simple (Niveau Début)** :
```
Score = (Lead_Score × 0.4) + (Budget × 0.3) + (Industry × 0.3)
Avantage: Facile comprendre/expliquer
Limitation: Pas flexible, pas apprentissage
```

**Score avancé (Niveau Moyen)** :
```
Random Forest avec 15+ features
+ Validation croisée (cross-fold)
+ Impact analysis par feature
Avantage: Much better performance (45% vs 32% conversion)
Limitation: Moins "explainable" (black box)
```

---

#### 1.2 Données requises

**Minimum requis** :
```
200+ leads historiques (avec résultat: Converted Y/N)
+ 10-15 variables prédictives

"Pas assez données?"
→ Commencer simple (regression logistique)
→ Augmenter taille: 6-12 mois
→ Migrate à random forest quand possible
```

**Variables recommandées pour Sani Marc** :
```
├─ Company characteristics: size, industry, sector
├─ Engagement: email opens, website visits, response time
├─ Fit: prior products, budget range, current solution
├─ Timing: days since contact, proposal status
├─ Interaction history: # calls, # meetings, # proposals
├─ Competition: who's competing, win/loss patterns
└─ External: growth signals, funding, news mentions
```

---

### Section 2 : Implémentation modèle (90 min)

#### 2.1 Préparation données phase (Excel ou Python)

**Étape 1 : Collecter données**
```
Exporter D365 :
├─ Tous leads 12 derniers mois
├─ Dates, valeurs, status (Converted Y/N)
└─ Save en CSV/Excel

Résultat: 486 lignes × 25 colonnes
```

**Étape 2 : Nettoyer**
```
❌ Valeurs manquantes > 10%? Drop colonne
❌ Doublons? Merge
❌ Erreurs évidentes? Correct ou remove
✅ Résultat: 450 lignes propres × 18 colonnes
```

**Étape 3 : Encoding variables catégoriques**
```
AVANT:
├─ Industry: "Healthcare", "Manufacturing", ...

APRÈS (Numerical):
├─ Industry_Healthcare: 1 or 0
├─ Industry_Manufacturing: 1 or 0
└─ Industry_Other: 1 or 0
```

**Étape 4 : Normaliser numériques**
```
AVANT:
├─ Budget: 10,000 à 500,000 (different scales)
├─ Company_size: 10 à 10,000

APRÈS (0-1 scale):
├─ Budget_normalized: 0.02 à 1.0
├─ Companysize_normalized: 0.001 à 1.0
(Random Forest utilise normalized data)
```

---

#### 2.2 Séparation train/test

```
450 leads NETTOYÉS
    ↓
Split 70/15/15 :
├─ 315 Training (70%)  ← Apprentissage modèle
├─ 68 Validation (15%) ← Tuner paramètres
└─ 67 Test (15%)       ← FINAL EVAL (ne pas touch!)
```

**Importance du test set** :
```
Ne JAMAIS laisser modèle voir test data avant évaluation!
Sinon: Overfitting risk, metrics biaisées
```

---

#### 2.3 Entraîner Random Forest (Python snippet)

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import pandas as pd

# Load data
data = pd.read_csv('sani_marc_clean.csv')

# Features vs Target
X = data.drop(['Converted'], axis=1)
y = data['Converted']  # 1 = Yes, 0 = No

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.15, random_state=42
)

# Train
model = RandomForestClassifier(
    n_estimators=100,  # 100 arbres
    max_depth=10,      # pas trop profonds
    min_samples_leaf=5,
    random_state=42
)
model.fit(X_train, y_train)

# Evaluate
train_score = model.score(X_train, y_train)  # ~0.92
test_score = model.score(X_test, y_test)    # ~0.87

print(f"Train Accuracy: {train_score:.2%}")
print(f"Test Accuracy: {test_score:.2%}")
# Output:
# Train Accuracy: 92%
# Test Accuracy: 87%
# → Good! Not overfitting (difference < 5%)
```

---

#### 2.4 Évaluer performance

```
Confusion Matrix на test set:

                Prédit OUI  Prédit NON
Réel OUI    →   35 (TP)    5 (FN)        recall: 87%
Réel NON    →   3 (FP)     24 (TN)       precision: 92%

Métriques:
├─ Accuracy: 59/67 = 88% ✅
├─ Precision: 35/38 = 92% (When say YES, correct 92%)
├─ Recall: 35/40 = 87% (Catch 87% true convertors)
└─ F1-Score: 0.89 ✅

Interpretation:
✅ 88% accuracy = très bon pour ventes
✅ 92% precision = peu faux positifs (appels inutiles)
✅ 87% recall = capture 87% vraies opportunities
✓ Model ready for production!
```

---

#### 2.5 Feature Importance

**Analyser quelles variables prédisent mieux** :

```python
# Get feature importance
importance = model.feature_importances_

# Display top 10
feature_names = X.columns
top_10 = sorted(zip(feature_names, importance), 
                key=lambda x: x[1], reverse=True)[:10]

for feature, imp in top_10:
    print(f"{feature:30} {imp:.1%}")

OUTPUT:
Lead_Score                    15.2%  ← Principal predictor
Budget_Range                  12.8%
Industry_Healthcare           10.5%
Response_Time                 8.3%
Company_Size                  7.2%
Days_Since_Contact            6.1%
Current_Solution              5.4%
Email_Engagement              4.8%
Number_Contacts               4.2%
Proposal_Value                3.6%
```

**Insights** :
```
→ Lead_Score (15%) = still most important
→ Budget + Industry (23.3%) = combination critical
→ New variables (Response_Time, Email) = valuable

Recommendation:
├─ Invest in better lead scoring (15% of power)
├─ Improve industry data quality (10.5%)
└─ Track response time metrics (8.3%)
```

---

### Section 3 : Scoring prospects actuels (30 min)

#### 3.1 Générer scores pour pipeline actuel

```python
# Load current leads
current_leads = pd.read_csv('current_pipeline.csv')

# Apply model
current_leads['Predicted_Score'] = model.predict_proba(
    current_leads[features]
)[:, 1] * 100

# Output
current_leads[['Company', 'Predicted_Score', 'Recommended_Action']]
.to_csv('scored_pipeline.csv')
```

**Résultat** :
```
Company              Score  Action
──────────────────────────────────
Acme Corp             87    CALL TODAY ⭐
BioTech Inc           73    Call this week
Manufacturing XYZ     52    Nurture email
Food Services LLC     28    Archive/reactivate

Insight: Focus 12 leads 80+ = 3x better ROI
```

---

#### 3.2 Segmentation par score

```
0-30   (5 leads)   Archive/pause     ← Cold storage
30-60  (8 leads)   Nurture/email     ← Automatic
60-80  (18 leads)  Sales focus       ← Personal contact
80+    (12 leads)  PRIORITY          ← Director attention
```

**Allocation vendeur** :
```
Avant scoring:
├─ Bruno: 50 leads (mélangé qualité)
├─ Maria: 45 leads
└─ Yassine: 35 leads
= 130 leads / 3 vendeurs = 43 leads chacun

Après scoring + allocation:
├─ Bruno (SENIOR): 12 leads 80+ (conversion 68%+!)
├─ Maria (MID): 18 leads 60-80 (conversion 50%+)
└─ Yassine (JUNIOR): 8 leads 30-60 (conversion 25%+)
└─ Nurture system: 8 leads <30 (automatic)

Result:
├─ Bruno: +25% expected conversion (68% vs 32%)
├─ Maria: +50% expected conversion (50% vs 33%)
├─ Yassine: Fewer, better leads = higher success
└─ Nurturing: 8 leads kept warm auto (no cost)
```

---

### Section 4 : Implémentation en production (30 min)

#### 4.1 Intégration D365

**Option 1 : Batch monthly (Simple)**
```
Workflow:
1. Exporter D365 → Excel (1st of month)
2. Score via Python script (30 min)
3. Upload résultats → D365 "AI_Score" field
4. Vendeurs see scores in CRM

Coût: ~$500/mois (data engineer 2 heures)
```

**Option 2 : Real-time (Advanced)**
```
D365 automation:
├─ Nouveau lead enter → trigger webhook
├─ Appelle ML API (scoring model)
├─ Retour score automatiquement
├─ D365 updated real-time

Coût: ~$2K setup + $200/mois
Benefit: Immediate scoring, no delay
```

**Pour Sani Marc : Recommander Option 1 (start simple**

---

#### 4.2 Change management

**Jour 1 : Communication**
```
Email team:
"À partir du 1er mai, vous verrez AI_Score dans D365
- Green (80+): Contact immediately
- Yellow (60-80): This week
- Red (<60): Archive/nurture

Cela devrait multiplier votre conversion par 1.3x
Questions? Office hour lundi 14h"
```

**Jour 2-3 : Formation**
```
2h session:
├─ Démo score (show 10 examples)
├─ Explain why (feature importance)
├─ How to use (filtering, sorting)
└─ Q&A

Post-training: 1-page quick reference guide
```

**Semaine 1 : Monitoring**
```
Track:
├─ Adoption: % vendors using score
├─ Feedback: What working/not working
├─ Performance early signals
└─ Adjust messaging as needed
```

---

### Section 5 : Mesurer impact business (30 min)

#### 5.1 KPIs à tracker

**Avant vs Après** (3 months comparison)

| KPI | Before | After | Change |
|---|---|---|---|
| **Conversion rate** | 32% | 42% | +10% 📈 |
| **Avg cycle time** | 52 days | 41 days | -11 days ⏱️ |
| **Calls/lead** | 3.2 | 2.5 | -22% 💪 |
| **Time admin** | 8h/week | 4h/week | -50% 🚀 |
| **Revenue/lead** | $14K | $18K | +28% 💰 |

---

#### 5.2 ROI Calculation

```
INVESTMENT:
├─ Model development: $5K (1-time)
├─ D365 integration: $2K (1-time)
├─ Training: $1K (1-time)
└─ Maintenance: $200/month ongoing

Total Year 1: $5K + $2K + $1K + $2.4K = $10.4K

BENEFITS (Year 1):
├─ 50 vendeurs × $800K revenue baseline
├─ Conversion improvement: 32% → 42% (+10%)
├─ 50 vendeurs × $800K × 10% = $4M additional revenue
└─ Profit margin 20% = $800K gross profit

NET BENEFIT: $800K - $10.4K = $789.6K
ROI: 7,580% (!!)

Timeline to positive ROI: 1 week
```

---

#### 5.3 Dashboard monitoring

```
MONTHLY TRACKING:
Semaine 1: Extract data
Semaine 2: Analyze vs target
Semaine 3: Report + suggestions
Semaine 4: Act on insights

KPI Dashboard:
├─ Conversion %: Now 41% (Target 42%)
├─ Avg cycle: 42 days (Target 35)
├─ Cost per deal: $324 (baseline $450)
├─ Revenue: $3.2M MTD (On pace!)
  
Status: ON TRACK ✅

Concerns detected:
- Yassine: 25% conversion (vs 42% avg)
  → Coaching opportunity?
- Maria: Excellent 50% (above average!)
  → Share technique with team?
```

---

## 🎯 Résumé des points clés

1. **Random Forest >> Simple scoring** (45% vs 32% conversion)
2. **Proper train/test split** = essentiel (prevent overfitting)
3. **87% accuracy = très bon** pour ventes
4. **Implementation simple** en D365 (batch monthly recommended)
5. **ROI massif** : $800K benefit pour $10K investment
6. **Monitoring continu** = success key

---

## 📋 Exercices

### Exercice 1 : Évaluer un modèle proposal
```
Scenario: Un consultant propose model avec:
├─ 95% train accuracy
└─ 72% test accuracy

Question: Problème?
Réponse: OUI - 23% difference = overfitting!
Action: Reject et demander adjustment
```

### Exercice 2 : Scoring votre pipeline
```
Download sani_marc_current_leads.csv
Apply notre model
Categorize par score:
├─ 80+: X leads
├─ 60-80: Y leads
├─ <60: Z leads

Present recommendation: Which focus first?
```

---

## 📞 Support

- **Model questions**: Voir Ressources-Communes/modeles_templates.md
- **D365 integration**: Contact IT department
- **Issues**: #ia-sani-marc Slack