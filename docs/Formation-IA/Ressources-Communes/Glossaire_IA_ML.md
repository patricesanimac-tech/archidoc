# Glossaire IA et Machine Learning

> Termes clés pour formation IA Sani Marc. Réferez-vous ici lors d'une question terminologique.

---

## A

**Accuracy (Précision)**
- Pourcentage de prédictions correctes / total prédictions
- "Notre modèle = 87% accuracy" = 87 sur 100 prédictions justes
- Voir aussi: Precision, Recall

**Algorithm**
- Ensemble d'étapes/règles qui un ordinateur suit pour résoudre problème
- "Algorithme Random Forest" = ensemble d'étapes pour classer / prédire

**Artificial Intelligence (IA)**
- Domaine large: machines qui "pensent" ou "décident"
- Sous-ensemble: Machine Learning, Deep Learning, Expert Systems

**Audit (de bias)**
- Vérifier systématiquement qu'un modèle IA ne discrimine pas
- "Audit mensuel confirms pas de discrimination gender"

---

## B

**Bias (Biais)**
- Distortion systématique dans données ou modèle
- Biais gender: "Notre model score femmes 20% moins que hommes"
- Biais données: "90% données = hommes startups" → modèle apprend discrimination

**Black box**
- Modèle où on ne peut pas expliquer pourquoi prédiction X
- Contraire: Transparent / Explainable

**Business Impact**
- Effet du IA sur revenue, coûts, satisfaction client
- "Lead scoring = +$800K revenue year 1"

---

## C

**Classification**
- Prédire une CATÉGORIE (pas nombre)
- "Convertira ce prospect?" → "OUI" ou "NON" (2 classes)
- "Quel segment?" → "VIP", "Standard", "Faible" (3 classes)
- Voir aussi: Regression

**Clustering**
- Grouper ensemble items similaires sans labels pré-définis
- "Découvrir automatiquement 5 segments de clients"
- Algorithme: K-Means

**Confusion Matrix**
- Table montrant TP/TN/FP/FN pour évaluer classification
- Aide diagnostiquer si modèle confond certaines classes

**Consent (Consentement)**
- Permission d'un client/prospect pour utiliser ses données
- Legalement requis (PIPEDA, LPRPDE)
- "Prospect clicked OUI to opt-in chatbot scoring"

**Conversion**
- Prospect dit OUI et devient client
- Conversion rate: "32% de prospects = conversions"

---

## D

**Data (Données)**
- Information brute (nombres, texte, images)
- "Dataset de 486 leads = données historiques"

**Data Scientist**
- Expert: Python/SQL + ML + Statistiques + Domaine métier
- Crée et maintient modèles IA

**Decision Tree**
- Algorithm ML: série de questions oui/non pour décider
- "Budget >$50K?" → Oui → "Staff >100?" → ...

**Deep Learning**
- Subset de ML utilisant neural networks (beaucoup couches)
- "LLM gigantesque" = forma deep learning
- Requires énormément données + GPU

**Domain Knowledge**
- Expertise dans un domaine spécifique
- "Domain knowledge en ventes = connatre cycles, competitors"

---

## E

**Ensemble Methods**
- Combiner plusieurs models pour mieux prédiction
- Random Forest = ensemble de 100 petit trees

**Entité**
- Information clé en texte (personne, lieu, produit)
- NLP détecte "piscine vérite" → PRODUCT=piscine, ISSUE=verte

**Escalation**
- Passer de chatbot à human agent
- "Customer says FU chatbot" → escalate to supervisor

**Explainability**
- Capacité d'expliquer POURQUOI modèle prédiction X
- "Lead score 75 = Budget (25%) + Industry (20%) + ..."
- Ethiquement required par law

---

## F

**F1-Score**
- Moyenne harmonique Precision × Recall
- Balancé measure quand classes déséquilibrées
- "F1 = 0.87" = bon model overall

**False Negative (FN)**
- Prédiction: NON, Réalité: OUI
- Coûteux en ventes = "Excellent prospect missed"

**False Positive (FP)**
- Prédiction: OUI, Réalité: NON
- "Vendeur appelle poor prospect = temps perdu"

**Feature (Variable)**
- Input données pour prédiction
- Lead scoring features: [Budget, Industry, Score, JobTitle]
- Feature engineering = créer meilleurs features

**Feedback Loop**
- System qui apprend de résultats passés
- "Si chatbot donne mauvaise réponse, flag pour improve"

---

## G

**Governance (Gouvernance)**
- Framework règles qui contrôlent IA usage
- "Governance requires audit mensuel + DPO approval"

---

## H

**Hyperparameter**
- Setting qu'on ajuste du machine learning model
- "Random Forest hyperparameters: n_estimators=100, max_depth=10"
- Tuning = amélioration performance

---

## I

**Intent**
- Intention/goal utilisateur dans conversation
- NLP détecte: "Je want renew" → intent=RENEWAL

**Integration (Intégration)**
- Connection entre systèmes
- "Chatbot intégré à D365" = données flow bidirectionnel

---

## J

**Job Title**
- Titre professionnel d'une personne
- Not OK pour ML: peut être biais proxy

---

## K

**K-Means**
- Algorithm clustering: divider data en K groupes
- "K=5" = créer 5 segments clients

---

## L

**Label (Étiquette)**
- Réponse correcte pour training data
- Supervised learning: "Prospect A convertis = label: YES"

**LLM (Large Language Model)**
- Modèle deep learning énorme (Billions parameters)
- ChatGPT, Claude, Llama = LLMs

**Logistic Regression**
- Algoritm pour classification probabilité (0-100%)
- "Lead = 78% conversion probability"

---

## M

**Machine Learning (ML)**
- Algorithm que apprend patterns données
- Sous-set de IA
- Types: Supervised, Unsupervised, Reinforcement

**MAE (Mean Absolute Error)**
- Moyenne des erreurs absolues en regression
- "Model prédits pas parfait = MAE = 5K$ error"

**Model**
- Version trained d'un algorithm
- "Notre lead scoring model" = trained Random Forest

**Monitoring (Suivi)**
- Observation continu performance model production
- "Monthly audits confirm model performance stable"

---

## N

**Neural Network**
- Structure données inspirée brain: nodes + connections
- Foundation pour deep learning

**NLP (Natural Language Processing)**
- AI discipline: computers comprendre human language
- Applications: chatbots, sentiment analysis, translation

---

## O

**Overfitting**
- Model memorize training data au lieu d'apprendre patterns
- Signs: 95% train accuracy, 55% test accuracy
- Prevention: test set discipline, validation

---

## P

**Phase**
- Stage de projet (déploiement)
- "Phase 1: Pilot (5 vendeurs)" → "Phase 2: Scaling (50 vendeurs)"

**Precision (Exactitude)**
- "De nos prédictions OUI, combien correct?"
- Precision = true positives / predicted positives
- "92% precision" = quand on dit OUI, 92% vraiment OUI

**Prediction**
- Output estimé d'un model
- "Model prédiction pour lead: 78% conversion"

**Predictive Analytics**
- Utiliser données historiques pour predict future
- "Predict qui va churner" = predictive analytics

**Privacy**
- Droit/protection données personnels clients
- PIPEDA, LPRPDE guarantee privacy

---

## R

**Random Forest**
- Algorithm: ensemble 100+ small decision trees voting
- Très populaire, usually très performant
- "Random Forest accuracy = 87%"

**Recall (Couverture)**
- "De vraies conversions, combien on détecte?"
- Recall = true positives / actual positives
- "87% recall" = on trouve 87% vraies opportunities

**Regression**
- Prédire une VALEUR/nombre (pas catégorie)
- "Predict montant contrat" = regression problem
- Voir aussi: Classification

**RGPD/PIPEDA**
- Lois protection données (EU/Canada)
- Requirent: Consent, Transparency, Right to forget

**ROI (Return on Investment)**
- Revenue/benefit - coût investissement
- "Lead scoring ROI = 787K$ net benefit"

**RPA (Robotic Process Automation)**
- Automate tâches repetitives avec bots
- "RPA tool clicks buttons, fills forms automatically"

---

## S

**Sampling**
- Selecting subset de données pour analysis
- Training/Validation/Test = différent samples

**Scoring**
- Assigner point de 0-100 à prospect
- "Lead score 78" = très bon prospect

**Segment**
- Group de clients avec characteristics similaires
- "VIP segment" = high-value customers

**Segmentation**
- Processus divider customers en segments
- "Segmentation by revenue, retention, loyalty"

**Sentiment Analysis**
- Détecter émotion dans texte
- "Customer feedback = positive, negative, ou neutral?"

**Supervised Learning**
- Training data avec labels (inputs + correct outputs)
- "Training: Budget=$50K+, Converted=YES"

**SVM (Support Vector Machine)**
- Algorithm classification: find optimal separting line
- Very accurate pour classification binaire

---

## T

**Test Set**
- Données utilisé pour FINAL evaluation (never touched during training)
- "Test accuracy = 87%" = honest performance esimate
- Distinguish: Train set, Validation set

**Tokenization**
- Split text en words/phrases (tokens)
- "Hello world" → ["Hello", "world"]

**Transfer Learning**
- Utiliser pre-trained model + fine-tune avec vos données
- "Google LLM" + "fine-tune avec vos conversations"
- Much faster que training from scratch

**Training Data (Données d'entraînement)**
- Données utilisé pour "teach" modèle
- Usually 70% données totales

**True Negative (TN)**
- Prédiction: NON, Réalité: NON ✅ correct
- "Correctly rejected bad prospects"

**True Positive (TP)**
- Prédiction: OUI, Réalité: OUI ✅ correct
- "Correctly identified good prospects"

---

## U

**Underfitting**
- Model trop simple, pas capture complexity
- Signs: 60% train, 55% test accuracy (both low)

**Unsupervised Learning**
- Training data SANS labels
- "Find 5 client segments" = no pre-defined categories

---

## V

**Validation Set**
- Données pour tune modèle pendant training
- Distinguish: Train (learn), Validation (tune), Test (final eval)

**Variable**
- Piece d'information (budget, industry, company size)
- Synonyme: Feature

---

## W

**Webhook**
- Automated message entre systèmes
- "When lead created → trigger webhook → slack notification"

---

## X-Z

**XML/JSON**
- Format données structurées
- "API return response en JSON format"

---

## Acronymes courants

| Acronym | Meaning | Contexte |
|---|---|---|
| **IA** | Intelligence Artificielle | Domaine général |
| **ML** | Machine Learning | Apprendre données |
| **DL** | Deep Learning | Neural networks |
| **NLP** | Natural Language Processing | Conversations, texte |
| **API** | Application Programming Interface | Systèmes comunicat |
| **CRM** | Customer Relationship Management | D365, Salesforce |
| **ROI** | Return on Investment | Bénéfice final |
| **KPI** | Key Performance Indicator | Métrique succès |
| **CSAT** | Customer Satisfaction | Support metric |
| **FTE** | Full Time Equivalent | Ressource mesure |
| **CSV** | Comma Separated Values | Format fichier |
| **ETL** | Extract Transform Load | Data pipeline |
| **TP/TN/FP/FN** | True/False Positive/Negative | Confusion matrix |
| **PIPEDA** | PERSONAL INFORMATION PROTECTION... | Loi Canada |
| **LPRPDE** | LOI PROTEGEANT RENSEIGNEMENTS... | Loi Québec |

---

## Ressources plus approfondies

- Module: Fondamentaux_IA_ML_Ventes.md
- Website: deeplearning.ai
- Livre: Hands-On ML (Aurélien Géron)
- Course: Andrew Ng - ML Specialization