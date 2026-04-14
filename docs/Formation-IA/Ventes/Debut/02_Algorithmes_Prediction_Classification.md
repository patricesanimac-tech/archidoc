# Module 2 : Algorithmes de prédiction et classification

**Niveau**: Début  
**Durée**: 2 heures  
**Format**: Cours théorique + Démonstrations interactives  
**Public cible**: Équipes commerciales

---

## 📌 Objectifs du module

À la fin de ce module, vous serez capable de :

✅ Comprendre les 5 algorithmes ML les plus courants  
✅ Connaître quand utiliser quel algorithme  
✅ Reconnaître la différence entre régression et classification  
✅ Interpréter les résultats d'un modèle  
✅ Évaluer la performance d'un algorithme  

---

## 📚 Contenu du cours

### Section 1 : Régression vs Classification (15 min)

#### 🔷 Régression : Prédire un NOMBRE

**Définition** :  
Prédire une valeur **continue** (nombre réel).

**Questions typiques** :
- "Combien vaut ce contrat?" → Montant en $
- "Quel revenu mensuel générera ce client?" → Montant mensuel
- "En combien de jours convertira ce lead?" → Nombre de jours

**Exemples d'algorithmes** :
- Régression linéaire
- Régression polynomiale
- SVR (Support Vector Regression)

**Visualisation** :
```
Montant du contrat ($)
│
│                    ●
│              ●     
│         ●    ●
│    ●    ●
│ ●  ●
└─────────────────────── Taille client
  
La parabole = Relation prédite entre variables
```

---

#### 🔹 Classification : Prédire une CATÉGORIE

**Définition** :  
Prédire une classe (OUI/NON, Catégorie A/B/C, etc.).

**Questions typiques** :
- "Est-ce que ce prospect convertira?" → OUI / NON (binaire)
- "Quel segment client?" → VIP / Standard / Faible (multi-classe)
- "Quel est le risque de churn?" → Élevé / Moyen / Bas (multi-classe)

**Exemples d'algorithmes** :
- Régression logistique
- Decision Trees (Arbres de décision)
- Random Forest
- SVM (Support Vector Machine)

**Visualisation pour classification binaire** :
```
Convertira?
│
OUI ●●●●
│   ●●
│
NON  ●●●●
│    ●●●
└────────────────────── Score engagement
Alta  Moyen  Bas
```

---

### Section 2 : Les 5 algorithmes essentiels (45 min)

#### 1️⃣ Régression Linéaire

**Qu'est-ce que c'est?**  
L'algorithme le plus simple : trouver la meilleure ligne droite qui passe par les points.

**Formule simple** :
```
y = a*x + b

y = Résultat prédit (montant vente)
x = Variable d'entrée (taille entreprise)
a = Pente (comment y change avec x)
b = Intercept (point de départ)
```

**Cas d'usage ventes** :
- Prédire le revenu moyen par client basé sur budget
- Estimer le cycle de vente par secteur

**Avantages** :
- ✅ Simple à comprendre
- ✅ Rapide à entraîner
- ✅ Bon pour données linéaires

**Limitations** :
- ❌ Suppose une relation linéaire (pas toujours vrai)
- ❌ Sensible aux valeurs aberrantes
- ❌ Peu performant sur données complexes

**Exemple concret Sani Marc** :
```
Données: Budget publicité (x) vs Nombre leads (y)

Budget ($) | Leads générés
-----------|---------------
1,000      | 15
2,000      | 28
3,000      | 42
5,000      | 70

Régression linéaire trouve :
Leads = 0.015 × Budget - 5
→ Avec 4,000$ → 55 leads prédits
```

---

#### 2️⃣ Régression Logistique

**Attention!** Malgré le nom, c'est pour **CLASSIFICATION**, pas régression!

**Qu'est-ce que c'est?**  
Prédire la probabilité qu'un lead convertisse (0-100%).

**Cas d'usage ventes** :
- Lead scoring : Probabilité conversion (0-100%)
- Churn risk : Risque perte client (en %)
- Upsell potential : Potentiel achat additionnel (en %)

**Comment ça fonctionne** :
```
ENTRÉES (Features)          MODÈLE                 SORTIE
●────────┐                                      ┌────> 78% prob.
●────────┼──> Régression Logistique ──────────┤
●────────┤                                      └────> 78% conversion
│  Score │                                          (OUI)
│  Budget│
│  Taille│
```

**Avantages** :
- ✅ Probabilités comprises (entre 0-100%)
- ✅ Facile à interpréter
- ✅ Rapide à entraîner
- ✅ Bon départ pour classification binaire

**Limitations** :
- ❌ Assume relation linéaire
- ❌ Performance moyenne sur données complexes
- ❌ Moins précis que forêts aléatoires

**Exemple concret** :
```
Prospect A:  74% chance conversion → Lead chaud
Prospect B:  32% chance conversion → Lead tiède
Prospect C:  15% chance conversion → Lead froid
```

---

#### 3️⃣ Decision Trees (Arbres de décision)

**Qu'est-ce que c'est?**  
Un modèle qui pose des questions oui/non en cascade pour prendre une décision.

**Visualisation** :
```
                  Secteur?
                  /      \
              Santé    Autre
              /            \
          Budget?        Taille?
          /    \         /    \
        >100K <100K    Grande  Petit
        /        \      /       \
      OUI     NON   OUI        NON
```

**Cas d'usage ventes** :
- Segmentation clients automatique
- Priorisation leads
- Prédiction de valeur (haute/moyenne/basse)

**Avantages** :
- ✅ Très interprétable (on voit les règles)
- ✅ Pas besoin de normaliser données
- ✅ Gère bien données non-linéaires
- ✅ Efficace pour classification multi-classe

**Limitations** :
- ❌ Tend à overfitting (trop adaptés aux données)
- ❌ Moins robustes que forêts aléatoires
- ❌ Peuvent créer des modèles trop complexes

**Exemple arbre simple pour lead scoring** :
```
LEAD ENTRANT
    ↓
Budget disponible > 50K$ ?
    ├─ NON → Score: 30 (basse priorité)
    └─ OUI
        ↓
        Urgence mentionnée ?
        ├─ NON → Score: 60 (priorité moyenne)
        └─ OUI
            ↓
            Contacts précédents ?
            ├─ NON → Score: 85 (haute priorité) ⭐
            └─ OUI → Score: 75 (priorité moyenne-haute)
```

---

#### 4️⃣ Random Forest (Forêt Aléatoire)

**Qu'est-ce que c'est?**  
Plusieurs arbres de décision petits + vote majoritaire = meilleure prédiction.

**Analogie** :
```
Vous devez choisir un prospect à contacter.

1 ami vous dit: "Contact le!" (1 arbre seul = risqué)
    vs
10 experts vous donnent avis:
- 7 disent "OUI contacter" → Vous décidez OUI (70% consensus)
- 3 disent "Peut-être"
= Forêt aléatoire (plus robuste!)
```

**Visualisation** :
```
Données d'entraînement
        ↓
    [Forêt aléatoire]
    ├─ Arbre 1  ──→ Prédiction 1
    ├─ Arbre 2  ──→ Prédiction 2
    ├─ Arbre 3  ──→ Prédiction 3
    └─ ...
        ↓
    [Vote majoritaire]
    → Résultat final robuste
```

**Cas d'usage ventes** :
- Lead scoring avancé
- Segmentation clients multi-critères
- Prédiction valeur contrat
- Détection de prospects à relancer

**Avantages** :
- ✅ Très performant en général (90%+ accuracy souvent)
- ✅ Gère bien overfitting
- ✅ Peu de tuning nécessaire
- ✅ Donne "feature importance" (variables clés)
- ✅ Robuste aux valeurs aberrantes

**Limitations** :
- ❌ Moins interprétable (boîte noire)
- ❌ Plus lent à entraîner que arbres simples
- ❌ Demande plus de données

**Feature Importance (Importance des variables)** :
```
Prédiction = Convertira ce prospect?

Feature Importance:
├─ Budget: 35% (TRÈS important)
├─ Secteur: 25% (Important)
├─ Taille entreprise: 20% (Important)
├─ Historique achats: 15% (Modéré)
└─ Localisation: 5% (Peu important)

→ Concentrez-vous sur Budget et Secteur!
```

---

#### 5️⃣ Support Vector Machine (SVM)

**Qu'est-ce que c'est?**  
Trouver l'hyperplan (ligne) optimal qui sépare au mieux les deux classes.

**Visualisation** :
```
Convertira?
│    ●●●●●● Oui (convertis)
│    ●●●●
│  ────────────── ← Hyperplan séparateur
│  ●●●●●●● Non (non-convertis)
│  ●●●
└────────────────────
```

**Cas d'usage ventes** :
- Classification binaire (conversion oui/non)
- Prédiction de churn
- Détection d'anomalies

**Avantages** :
- ✅ Excellent en dimension haute (beaucoup de variables)
- ✅ Très précis sur classification binaire
- ✅ Memory efficient (ne garde que support vectors)

**Limitations** :
- ❌ Peu interprétable (boîte noire)
- ❌ Lent sur très grands datasets
- ❌ Demande normalisation des données
- ❌ Tuning paramètres complexe

---

### Section 3 : Comparaison des algorithmes (20 min)

| Algorithme | Type | Facilité | Performance | Interprétabilité | Vitesse |
|---|---|---|---|---|---|
| **Régression Linéaire** | Régression | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Régression Logistique** | Classification | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Decision Tree** | Classification | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Random Forest** | Classification | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| **SVM** | Classification | ⭐ | ⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐ |

**Quand utiliser quoi?**

| Situation | Algorithme recommandé |
|---|---|
| Juste commencer, besoin d'explications | Régression logistique |
| Données simples, peu de variables | Régression linéaire |
| Besoin d'interprétabilité/traçabilité | Decision Tree |
| Besoin de meilleure performance | Random Forest |
| Données complexe/haute dimension | SVM ou Random Forest |
| Très peu de données | Régression logistique ou SVM |

---

### Section 4 : Comment évaluer un modèle? (20 min)

#### 4.1 Métriques de performance

**Pour CLASSIFICATION (ex: Convertira oui/non?)** :

##### 🎯 Accuracy (Précision globale)
```
Exactitude = Bonnes prédictions / Total prédictions

Exemple:
- 100 prospects prédit
- 85 prédictions correctes
- Accuracy = 85%

⚠️ ATTENTION! Peut être trompeuse si classes déséquilibrées
```

##### 📊 Confusion Matrix (Matrice de confusion)
```
Réalité vs Prédiction:

                Prédit OUI    Prédit NON
Réel OUI   →    TP=70        FN=10      (Recalled: 87%)
Réel NON   →    FP=5         TN=15      (Precision: 93%)

Termes:
- TP (True Positive): Bonus! Prédiction correcte (OUI/OUI)
- TN (True Negative): Prédiction correcte (NON/NON)
- FP (False Positive): Fausse alerte (prédit OUI, réel NON)
- FN (False Negative): Manqué (prédit NON, réel OUI) ❌ Coûteux!
```

##### 🎲 Precision vs Recall
```
PRECISION = TP / (TP + FP)
"De mes 75 prédictions OUI, combien étaient vraies?"
→ 70 vraies / 75 = 93% Precision

RECALL = TP / (TP + FN)
"Des 80 vrais OUI, combien j'en ai trouvé?"
→ 70/80 = 87% Recall

Trade-off: + Precision = - Recall (et vice-versa)
```

**Exemple concret ventes** :
```
Modèle lead scoring:

Precision 90% = "Si je contacte un lead, 90% vont convertir"
Recall 75% = "Je trouve 75% des prospects qui auraient convertis"

Question: Vaut mieux haute Precision ou haute Recall?
Réponse: Dépend du coût!
- Coût contact élevé? → Priorité Precision
- Perte revenue haute si rate prospect? → Priorité Recall
```

##### 🔄 F1-Score
```
F1 = Moyenne harmonique Precision et Recall
F1 = 2 × (Precision × Recall) / (Precision + Recall)

Meilleur score = 1.0, Pire = 0.0

Utilité: Seule métrique pour évaluer si données déséquilibrées
```

---

**Pour RÉGRESSION (ex: Prédire montant contrat)** :

##### 📏 MAE (Mean Absolute Error)
```
MAE = Moyenne des écarts absolus

Exemple prédictions montant:
Réel: 100K$  | Prédit: 95K$  | Erreur: 5K$
Réel: 50K$   | Prédit: 48K$  | Erreur: 2K$
Réel: 200K$  | Prédit: 210K$ | Erreur: 10K$

MAE = (5 + 2 + 10) / 3 = 5.67K$

Interprétation: En moyenne, on se trompe de 5.67K$
```

##### 📊 RMSE (Root Mean Square Error)
```
RMSE = Racine de la moyenne des erreurs au carré

Plus pénalisant pour grosses erreurs que MAE.

Exemple: MAE=5K$ mais erreur max=100K$ → RMSE plus haut
```

##### 🎯 R² (Coefficient de détermination)
```
R² = Proportion de variance expliquée (0 à 1)

R² = 0.85 = Le modèle explique 85% de la variation

Interprétation:
- R² > 0.9: Excellent ✅
- R² 0.7-0.9: Bon ✓
- R² 0.5-0.7: Acceptable
- R² < 0.5: Faible ❌
```

---

#### 4.2 Overfitting vs Underfitting

**Overfitting** : Le modèle mémorise les entraînement au lieu d'apprendre patterns

```
Données entraînement: 95% juste
Données test: 60% juste ← PROBLÈME!

Le modèle a appris les cas particuliers, pas les patterns généraux
```

**Underfitting** : Le modèle est trop simple

```
Données entraînement: 65% juste
Données test: 60% juste

Le modèle ne capture pas assez la complexité
```

**Équilibre optimal** :
```
Performance
     ▲
     │                    ●← Optimal (train vs test proches)
     │                 ● 
     │              ●     ●
     │           ●             ● ← Overfitting
     │        ●                    (écart train/test)
     │     ●                       
     │  ●  ← Underfitting
     └────────────────────────────► Complexité du modèle

Astuce: Utiliser "validation set" pour détecter overfitting
```

---

### Section 5 : Processus pratique de sélection (15 min)

**Étape 1 : Commencer simple**
```
Commencer avec Régression Logistique
→ Si performance insuffisante → passer à Random Forest
```

**Étape 2 : Diviser les données**
```
100% données
├─ 70% → Entraînement (apprentissage du modèle)
├─ 15% → Validation (tuner les paramètres)
└─ 15% → Test (évaluation finale, pas d'ajustement)
```

**Étape 3 : Entraîner et évaluer**
```
Entraîner modèle sur 70%
    ↓
Évaluer sur 15% validation
    ↓
Performance acceptable?
    ├─ NON → Ajuster paramètres / essayer autre algo
    └─ OUI
        ↓
    Évaluer sur 15% test final
        ↓
    Performance maintenue?
        ├─ NON → Overfitting détecté!
        └─ OUI → Modèle prêt pour production ✅
```

**Étape 4 : Production**
```
Monitoré performance continue (données réelles)
    ↓
Performance dégradée? (drifting)
    ├─ OUI → Re-entraîner modèle
    └─ NON → Continuer suivi
```

---

## 🎯 Résumé des points clés

1. **Régression** = prédire nombre | **Classification** = prédire catégorie
2. **5 algos essentiels** : Linéaire, Logistique, Tree, Forest, SVM
3. **Pour commencer** : Régression logistique ou Decision Tree
4. **Pour meilleure performance** : Random Forest
5. **Metrics clés** : Accuracy, Precision, Recall, F1-Score
6. **Overfitting** = danger commun (monitoré avec test set)
7. **Processus** : Entraîner (70%) → Valider (15%) → Tester (15%) → Produire

---

## 📋 Exercices pratiques

### Exercice 1 : Quel algo choisir?

**Scénario A**: "Prédire montant moyen du contrat par lead"
→ Algo? **Régression linéaire ou Random Forest regression** ✓

**Scénario B**: "Convertira ou pas ce prospect?"
→ Algo? **Régression logistique ou Random Forest** ✓

**Scénario C**: "Segmenter 1000 clients en 3 groupes de valeur"
→ Algo? **Decision Tree ou Random Forest (multi-classe)** ✓

### Exercice 2 : Interpréter un résultat

**Modèle Lead Scoring Résultat** :
- Accuracy: 88%
- Precision: 92%
- Recall: 78%
- F1-Score: 0.85

**Questions**:
1. Le modèle est-il bon? **Oui, 88% c'est bon pour ventes** ✓
2. Qu'interprétez? **92% prédictions OUI sont correctes, mais on rate 22% vrais leads** ✓
3. Amélioration? **Augmenter Recall (actuellement 78%)** ✓

### Exercice 3 : Données d'entraînement

Vous avez 500 prospects historiques (300 convertis, 200 non-convertis).

**Comment diviser?**
```
500 prospects
├─ 350 → Entraînement (70%)
├─ 75 → Validation (15%)
└─ 75 → Test (15%)
```

**Attention** : Maintient les proportions (60% convertis) dans chaque groupe!

---

## 📞 Support

- **Questions algorithmes** : Voir glossaire_ia_ml.md
- **Modèles prêts à l'emploi** : azure.microsoft.com/ml
- **Prochaine étape** : Module 3 - Outils IA CRM pratiques