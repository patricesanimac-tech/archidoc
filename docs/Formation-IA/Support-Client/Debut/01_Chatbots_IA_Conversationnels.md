# Module 1 : Chatbots et IA conversationnels - Fondamentaux

**Niveau**: Début  
**Durée**: 2 heures  
**Format**: Démonstrations + Atelier  
**Public cible**: Équipes support client

---

## 📌 Objectifs du module

À la fin de ce module, vous serez capable de :

✅ Comprendre comment fonctionnent les chatbots IA  
✅ Connaître les types de chatbots disponibles  
✅ Identifier les cas d'usage pour Sani Marc  
✅ Évaluer ROI d'un chatbot  
✅ Reconnaître limites et meilleure pratiques  

---

## 📚 Contenu du cours

### Section 1 : Qu'est-ce qu'un chatbot? (30 min)

#### 1.1 Définition simple

```
Chatbot = Programme informatique
qui converses avec humans en langage naturel
pour résoudre problèmes ou répondre questions
```

**Trois niveaux de complexité** :

```
Level 1: RULE-BASED CHATBOT (Simple)
└─ Patterns: "If client says X → Reply Y"
   Exemple: "Bonjour" → "Bienvenue chez Sani Marc!"

Level 2: AI LIGHT CHATBOT (Intermediate)
└─ ML basique: Comprend variations des patterns
   Exemple: "Bonjour, salut, coucou" → tous la même réaction

Level 3: ADVANCED AI CHATBOT (Complex)
└─ Deep Learning/NLP: Vrai compréhension + contexte
   Exemple: Peut poser questions de suivi, ajuster réponses
```

**Pour Sani Marc** : Commencer Level 1-2, upgrade à Level 3 plus tard

---

#### 1.2 Cas d'usage courants

**FAQ Automation (Level 1)**
```
Client: "Quels sont les horaires horaires?"
Chatbot: "Nous sommes ouverts Lun-Ven 8h-17h EST"

Benefit:
├─ 70% des questions support = FAQ
├─ Chatbot Level 1 = 70% réduction tickets
└─ ROI positif en 2 mois
```

**Routing Intelligent (Level 2)**
```
Client: "J'ai un problème avec ma commande 12345"
Chatbot: "Laissez-moi vérifier... commande approche expiration?"
Client: "Oui"
Chatbot: "Route vers 'Urgent Renewals' team"
→ Correct agent reçoit ticket (faster resolution)
```

**Proactive Support (Level 3)**
```
Client vista website, consulte pricing
Chatbot detect: "Client comparing prices"
Chatbot: "Vous cherchez solution économe?
  → Laissez-moi montrer nos packages SME..."
→ Proactive engagement (conversion +20%+)
```

---

### Section 2 : Technologie derrière les chatbots (30 min)

#### 2.1 NLP - Natural Language Processing

```
Human: "Je pense que mon eau piscine a un problème,
        l'eau change de couleur?"

NLP Process:
1. TOKENIZATION (split):
   ["Je", "pense", "que", "mon", ...]

2. ENTITY RECOGNITION:
   - PRODUCT: "eau piscine"
   - ISSUE: "change de couleur"
   - SENTIMENT: Concerned (pas happy)

3. INTENT CLASSIFICATION:
   Intent = "Report_Problem"
   Confidence: 95%

4. RESPONSE GENERATION:
   "Désolé d'entendre! C'est common quand...
    Pouvez-vous confirmer..."
```

**Résultat** : Machine comprend le message comme human = conversationnel naturel ✅

---

#### 2.2 Machine Learning pour conversation

**Approche "Transfer Learning"** :

```
Google/OpenAI fourni "Foundational Model"
(entraîné sur billions d'conversations)
    ↓
Sani Marc fine-tunes pour vos données
(1000-5000 examples de support conversations)
    ↓
Résultat: Chatbot parle comme votre support team!
```

**Exemple adaptation** :

```
Generic model:
"Water appears discolored. Check pH levels."

After fine-tuning par Sani Marc:
"L'eau de votre piscine change? C'est souvent un problème
de pH ou d'équilibre chimique. Pouvons-nous vérifier..."
(Plus naturel, branded tone)
```

---

### Section 3 : Types de chatbots (30 min)

#### 3.1 Chatbot architectures

**Architecture 1 : Intent-based**
```
Détecte l'intention → Dispatch réponse

Client: "Comment reset l'alarme?"
Chatbot détecte: intent=RESET_ALARM
Response: [Predefined instructions pour reset]

Limitation: Awkward si client pose variation
```

**Architecture 2 : Context-aware**
```
Comprend contexte + historique

Session:
1. Client: "Mon système ne marche plus"
2. Chatbot: "Quel système?"
3. Client: "L'application"
4. Chatbot recall: "Quel département?" (utilise contexte)

Benefit: Plus naturel, handle edge cases
```

**Architecture 3 : LLM-based (Latest)**
```
Powered by GPT-4 / Claude / Llama

Client: Libre texte, n'importe quoi
Chatbot: Génère réponse on-the-fly
Benefit: TRÈS flexible, comprend presque tout
Risk: Parfois hallucine ou invente info

Pour Sani Marc:
├─ Risque halluciner numéro client
├─ Risque promise fausse feature
└─ Solution: RAG retrieval (doc -> only accurate info)
```

---

#### 3.2 Chatbot platforms pour Sani Marc

| Platform | Coût | Facilité | IA Level | Pour SME |
|---|---|---|---|---|
| **Chatbase** | $20-100/mo | ⭐⭐⭐⭐⭐ | Level 2 | ✅ YES |
| **Intercom** | $50-300+/mo | ⭐⭐⭐⭐ | Level 2 | ✅ YES |
| **Zendesk** | $100-500+/mo | ⭐⭐⭐ | Level 1-2 | ✅ YES |
| **Microsoft Teams** | $6/user/mo | ⭐⭐⭐ | Level 1 | ✅ YES |
| **Custom LLM** | $10K+/mo | ⭐⭐ | Level 3 | ❌ Later |

**Recommandation Sani Marc** : Chatbase ou Intercom (Level 2, coût optimal)

---

### Section 4 : Cas d'usage pratiques Sani Marc (30 min)

#### 4.1 Use case 1: FAQ Support piscines

**Problème** :
```
Support team reçoit 200 tickets/jour
50% = questions FAQ (horaires, basics)
= 100 tickets/jour = 800h/mois
= 10 FTE = coûteux!
```

**Solution Chatbot Level 1** :
```
Chatbot answers 70% FAQ:
├─ "Horaires ouverture?" → [Prédefined response]
├─ "Comment contacter?" → [Form + auto-response]
├─ "Quel produit?" → [Product guide]
└─ Si complexe → Escalate human

Impact:
├─ 100 tickets/jour avoid → 30 human-handled
├─ Staff: 10 FTE reduction → 3 FTE minimum
├─ Cost savings: $250K/year
└─ Client satisfaction: ↑ (instant response)
```

**Implementation timeline**:
```
Week 1: Collect 50 common FAQ + responses
Week 2-3: Configure Chatbase, test
Week 4: Soft launch (feedback loop)
Week 5: Full rollout
```

---

#### 4.2 Use case 2: Intelligent Routing

**Before** :
```
Client calls with urgent issue
├─ Goes to queue (wait 15 min avg)
├─ Random agent picks up
├─ Wrong department? Re-route (another 5 min)
├─ Client frustrated ❌

Total resolution time: 3 hours
Customer satisfaction: 65%
```

**After with Chatbot Routing** :
```
Client: "J'ai un emergency - ma piscine verte!"
Chatbot: "EMERGENCY detected + POOL CHEMICAL"
├─ Route directly to "Pool Chemistry Team"
├─ Agent have context already (fast resolution)
├─ Client on phone within 2 min ✅

Total resolution time: 30 min
Customer satisfaction: 95%
```

**Implementation** :
```
Chatbot must understand:
├─ Issue severity (URGENT/NORMAL/INFO)
├─ Department routing (Pool/HVAC/Laundry/etc)
├─ Client type (VIP/Standard/New)

Then: Auto-route to right queue
```

---

#### 4.3 Use case 3: Proactive outreach

**Scenario** :
```
Customer visits "Support" page
Chatbot: "Bonjour! Puis-je vous aider?"
(instead of waiting they ask)

→ 30% more engagements
→ Issues resolved BEFORE they escalate
└─ Proactive = higher satisfaction
```

**Implementation** :
```
1. Detect visitor on support page
2. Chatbot greets after 5 seconds
3. Offer: "FAQ? Direct to agent? Self-service?"
4. Guide customer based on need

Result:
├─ 30% less phone calls (self-service)
├─ Faster resolution (proactive)
├─ Better satisfaction (they felt helped)
```

---

### Section 5 : Implémentation best practices (30 min)

#### 5.1 Qu'implémenter d'abord?

**Phase 1 (Quick win - 2 semaines)**
```
Chatbot très simple:
├─ 10 FAQ responses
├─ Hours + contact info
├─ Product overview
├─ Auto-escalate to agent

Goal: Capture 50% des support requests
Impact: -500 tickets/month
```

**Phase 2 (Enhancement - 1-2 mois)**
```
Add features:
├─ Intelligent routing (department + urgency)
├─ Context awareness (reference tickets)
├─ Sentiment analysis ("client angry?" → urgent)
├─ Learning from conversations

Goal: Capture 70% des requests
Impact: -1000 tickets/month
```

**Phase 3 (Advanced - 3+ mois)**
```
LLM-based chatbot:
├─ Semantic search (find docs)
├─ Proactive suggestions
├─ Multilingual
├─ Analysis of trends

Goal: Capture 80% des requests
Impact: Frees up team for complex cases
```

---

#### 5.2 Mesurer succès

**Metrics à tracker** :

| Métrique | Baseline | Target 3mo | Target 12mo |
|---|---|---|---|
| **Messages résolues par chatbot** | 0% | 50% | 70% |
| **Customer satisfaction** (CSAT) | 72% | 80% | 88% |
| **Average resolution time** | 3 hours | 45 min | 20 min |
| **Support tickets/day** | 200 | 100 | 60 |
| **Agent productivity** (tickets/day) | 8 | 15 | 20+ |
| **Cost per ticket** | $15 | $8 | $5 |

---

#### 5.3 Pièges à éviter

**Piège 1 : Chatbot frustrated users**
```
❌ Chatbot répond with generic messages
❌ Can't escalate to human properly
❌ Clients rage: "Je veux un HUMAN!"

✅ SOLUTION:
├─ Chatbot must recognize frustration
├─ Easy path to human agent (1 click)
├─ Agent receives context
└─ Try: 2 human handoffs max, then escalate
```

**Piège 2 : Limited scope**
```
❌ Chatbot programmed for 20 FAQ only
❌ Client asks anything outside = fail
❌ Confidence erodes

✅ SOLUTION:
├─ Define core 70% well
├─ For edge cases: "Je ne sais pas, appelons X"
├─ Escalate intelligently, don't fake
```

**Piège 3 : No monitoring**
```
❌ Deploy chatbot, forget about it
❌ After 3 months = broken/outdated
❌ Customers frustrated

✅ SOLUTION:
├─ Weekly review of conversations
├─ Version control (track changes)
├─ Monthly updates (improve)
└─ Quarterly strategy review
```

---

## 🎯 Résumé

1. **Chatbots Level 1** = FAQ automation (2 weeks, big ROI)
2. **Chatbots Level 2** = Add routing + context (2-8 weeks)
3. **Chatbots Level 3** = LLM advanced (3+ months)
4. **For Sani Marc** : Start Level 1→2 (70% ticket reduction, $200K+ savings)
5. **Success = monitoring** (weekly reviews required)

---

## 📋 Exercices

### Exercice 1 : Identifier chatbot opportunities
```
Liste 5 top FAQ à votre support desk:
1. _________________________
2. _________________________
3. _________________________
4. _________________________
5. _________________________

% des tickets = ces 5 FAQ?
Answer: Usually 30-50%

Conclusion: Même chatbot simple = huge impact!
```

### Exercice 2 : Escalation scenarios
```
Cas 1: Client: "Ma piscine verte + je suis allergique!"
Action: URGENT → Pool team → Now

Cas 2: Client: "Comment fonctionnent les filtres?"
Action: FAQ → Auto-response → Resolved

Cas 3: Client: "Je veux custom solution!"
Action: Complex → Human agent → Consultation
```

---

## 📞 Support

- **Demos chatbase/Intercom**: Request from IT
- **FAQ drafting**: Collaborate with current support team
- **ROI calculator**: See Ressources-Communes/
- **Community**: #ia-sani-marc Slack