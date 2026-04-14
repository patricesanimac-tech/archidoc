# Module 1 : Architecture d'un système support IA complet

**Niveau**: Moyen  
**Durée**: 3 heures  
**Format**: Architecture + Hands-on design  
**Public cible**: Support managers, IT coordinators

---

## 📌 Objectifs

À la fin, vous pouvez :

✅ Concevoir architecture chatbot complet  
✅ Intégrer avec systèmes existants (ticketing, CRM)  
✅ Planifier implémentation réaliste  
✅ Mesurer et optimiser performance  

---

## 📚 Architecture système

### Section 1 : Composants du système (60 min)

#### 1.1 Vue d'ensemble

```
CLIENT INTERACTION LAYER
    ├─ Website chat widget
    ├─ Mobile app chat
    └─ SMS/WhatsApp

              ↓

CHATBOT LAYER
    ├─ NLP engine (understand intent)
    ├─ Knowledge base (FAQ, docs)
    └─ Conversation manager (context)

              ↓

INTEGRATION LAYER
    ├─ CRM (D365) ← customer history
    ├─ Ticketing (Zendesk) ← create tickets
    ├─ Knowledge base API
    └─ Escalation system

              ↓

BACKEND
    ├─ Analytics/logging
    ├─ Admin dashboard
    └─ Monitoring
```

---

#### 1.2 Components détail

**Component 1 : Chatbot Engine**

```
Input: "Ma piscine est verte, que faire?"
    ↓
NLP Processing:
├─ Tokenize: [Ma, piscine, verte, qu, faire]
├─ Intent: GREEN_POOL_ISSUE
├─ Confidence: 97%
├─ Entities: [PRODUCT=piscine, ISSUE=verte]
└─ Sentiment: Concerned/Frustrated
    ↓
Query Knowledge Base:
├─ Find matching documents
├─ Rank by relevance
└─ Select top 3 possible answers
    ↓
Generate Response:
├─ Combine knowledge base + context
├─ Personalize (customer history)
└─ Add follow-up questions
    ↓
Output: "Piscine verte = algaezation problème courant...
        [solution steps]
        Ça semble urgent? Je peux router vers expert."
```

---

**Component 2 : Knowledge Base**

```
Structure:
├─ FAQ (200+ entries)
├─ Product guides (50+ docs)
├─ Troubleshooting (100+ cases)
├─ Policies & procedures
└─ Previous conversations (learning)

Stored as:
├─ Text documents (searchable)
├─ Vectors (semantic search)
└─ Tags (categorization)

Chatbot queries:
"Find 3 best answers for: GREEN POOL ISSUE"
└─ Returns ranked list by relevance
```

---

**Component 3 : Integration Hub**

```
INBOUND:
Customer in chat → Chatbot logs in Zendesk

OUTBOUND:
1. GET request: "Retrieve customer history from CRM"
   D365 → Returns: "This customer renewed 3x this year"
   
2. Chatbot uses context: "You're a loyal customer!"
   
3. POST request: Create ticket in Zendesk
   Ticket auto-routed to specialty team

4. WEBHOOK: Monitor for escalation
   "Customer very frustrated?" → Alert manager
```

---

### Section 2 : Implémentation chez Sani Marc (60 min)

#### 2.1 Étape 1 : Audit support actuellement

**Questions clés** :
```
1. How many support tickets/day? 200
2. What systems do you use?
   ├─ Zendesk (ticketing)
   ├─ Google Sheets (KB - manual!)
   └─ Outlook (knowledge)

3. Top 10 issues?
   ├─ Horaires (15%)
   ├─ Renouvellement (12%)
   ├─ Technique (10%)
   ├─ ...
   └─ Other (55%)

4. Response time target?
   Immediate for urgent, <4h for normal
```

**Findings** :
```
Current state:
├─ Manual KB = outdated
├─ Average response time = 2.5 hours
├─ 30% same question asked weekly
└─ Staff frustrated (repetitive work)

Opportunity:
├─ Automate 50% FAQ
├─ Reduce response time to <30 min
├─ Free staff for complex cases
└─ Improve satisfaction
```

---

#### 2.2 Étape 2 : Design solution

**Option A : Chatbase (Simple)**
```
Timeline: 2 weeks
Cost: $50/month
Integration: Limited
Pros: Quick, easy
Cons: Basic routing

Result: Level 1 chatbot (FAQ only)
```

**Option B : Intercom (Intermediate)**
```
Timeline: 4 weeks
Cost: $300/month
Integration: Good (Zendesk, D365)
Pros: Routing, ticketing integration
Cons: Moderate complexity

Result: Level 2 chatbot (routing + context)
```

**Option C : Custom LLM (Advanced)**
```
Timeline: 3+ months
Cost: $5K setup + $1K/month
Integration: Full (any system)
Pros: 100% customized
Cons: High complexity, needs developer

Result: Level 3 chatbot (advanced AI)
```

**Recommendation Sani Marc** : Option B (Intercom)

---

#### 2.3 Étape 3 : Build Knowledge Base

**Phase 1 : Audit documents (Week 1)**
```
Collect ALL sources:
├─ Support emails (query 1000 past)
├─ FAQ page on website
├─ Product manuals
├─ Policy documents
└─ Staff documentation

Organize into categories:
├─ Pre-sales (8 docs)
├─ Onboarding (15 docs)
├─ Troubleshooting (42 docs)
├─ Renewal (12 docs)
├─ (Admin/backend (30 docs)
└─ Total: ~120 docs
```

**Phase 2 : Standardize (Week 2)**
```
Format each document:
├─ Title: Clear, searchable
├─ Tags: Category + subcategory
├─ Content: Step-by-step (short paragraphs)
├─ Images: Screenshots where helpful
└─ Links: Cross-references

Example:
Title: "How to fix green pool water"
Tags: [pool, troubleshooting, algae, water-quality]
Content: 
  "Green water = algae growth. Follow these steps:
   1. Test pH level
   2. Add algaecide (dosage = X gallons/pool)
   3. Run filter 24h continuously
   4. If persists, contact support"
```

**Phase 3 : Test & Iterate (Week 3)**
```
Launch as "beta"
├─ Monitor confusion rates
├─ Track unresolved questions
├─ Update answers based on feedback
└─ Add missing content

Example improvement:
❌ User: "Water green but no algae smell?"
✅ Updated: "Green water can also be copper/minerals"
```

---

#### 2.4 Étape 4 : Setup routing & escalations

**Routing logic** :

```
Incoming customer message
    ↓
Chatbot analyzes sentiment + urgency
    ↓
Route decision:
├─ FAQ-related + low urgency
│  └─ Answer from KB, done ✅
│
├─ FAQ-related + high urgency
│  └─ Answer + escalate to human
│  
├─ Complex issue
│  └─ Create ticket, queue to specialist
│  
└─ Emergency (customer angry)
   └─ Immediately to supervisor
```

**Implementation in Intercom** :

```
Rules:
1. If intent=RENEWAL and sentiment=positive
   → Auto-answer with renewal form

2. If intent=EMERGENCY
   → Skip queue, route to "Urgent" team

3. If confidence<60% (confused)
   → Ask clarifying questions or escalate

4. If customer says "I want human"
   → Immediate escalation (don't resist!)
```

---

### Section 3 : Metrics et ROI (60 min)

#### 3.1 KPIs à tracker

```
EFFICIENCY METRICS:
├─ Chat resolution %: (solved/conversations) 
│  Baseline: 0%, Target: 50%
├─ Avg resolution time: 
│  Baseline: 150 min, Target: 30 min
├─ Human escalations %:
│  Baseline: 100%, Target: 40%
└─ Human time saved:
   Baseline: 0h, Target: 20h/week

QUALITY METRICS:
├─ Customer satisfaction (CSAT):
│  Baseline: 72%, Target: 85%
├─ First contact resolution:
│  Baseline: 45%, Target: 70%
├─ Escalation quality:
│  Baseline: N/A, Target: Well-documented
└─ Chat accuracy:
   Baseline: N/A, Target: >90%

BUSINESS METRICS:
├─ Cost per ticket:
│  Baseline: $15, Target: $8
├─ Support team productivity:
│  Baseline: 8 tickets/person, Target: 15 tickets
├─ Customer retention:
│  Baseline: 85%, Target: 90%
└─ Revenue impact:
   Baseline: $0, Target: 2% increased satisfaction
```

---

#### 3.2 ROI Calculation

```
COSTS (Year 1):
├─ Intercom setup: $5K (1-time)
├─ KB creation: $3K (40 hours)
├─ staff training: $2K (1-time)
├─ Maintenance: $3.6K (12 months × $300)
└─ Subtotal: $13.6K

BENEFITS (Year 1):
├─ Staff reduction: 2 FTE × $60K = $120K
├─ Time saved: 20h/week × 50 weeks × $50/h = $50K
├─ Customer retention: 85%→90% × 1000 customers × $2K value = $100K
├─ Faster resolution: reduce churn 2% → $30K
└─ Subtotal: $300K

NET BENEFIT: $300K - $13.6K = $286.4K
ROI: 2,100%

Payback period: 2 weeks!
```

---

#### 3.3 Monitoring dashboard

```
WEEKLY REPORT:
Week 15 of implementation

KPI Status:
├─ Chat resolution: 48% (Target 50%) ← Almost there!
├─ CSAT: 81% (Target 85%) ← Good progress
├─ Avg resolution: 35 min (Target 30) ← Slight miss
├─ Escalations: 42% (Target 40%) ← Good!

Top issues chatbot resolved:
1. Hours/location: 234 chats (15% of volume)
2. Renewal process: 156 chats (12%)
3. Product overview: 124 chats (10%)
4. Billing questions: 98 chats (8%)
5. other: 388 chats (55%)

Issues where chatbot failed:
1. Complex technical (28% escalated)
2. Emotional support (18%)
3. Product customization (15%)

ACTIONS THIS WEEK:
- Add 10 new KB articles on technical issues
- Train chatbot on empathy patterns
- Review "failed" conversations for improvement
```

---

## 🎯 Résumé

1. **Architecture** = Chatbot + KB + Integration + Analytics
2. **For Sani Marc**: Recommend Intercom (balance complexity-benefit)
3. **KB critical**: 120 docs, standardized, tagged
4. **Routing smart**: Escalate intelligently, improve over time
5. **ROI massive**: 2,100% first year ($286K net benefit)

---

## 📋 Exercices

### Exercice 1 : Design your KB structure
```
Your support domain:
├─ Category 1: __________ (# documents?)
├─ Category 2: __________ (# documents?)
└─ Category 3: __________ (# documents?)

Total documents needed?
Realistic timeline: _____ weeks

Resources required:
├─ Technical writer hours: _____
├─ Manager review hours: _____
└─ Tools needed: _____
```

### Exercice 2 : Routing scenarios
```
Scenario A: "What are your hours?"
Route: __________ (KB? Human? Escalate?)
Why: __________

Scenario B: "I'm so angry, your product is garbage!"
Route: __________ (Needs empathy)

Scenario C: "Custom solution for enterprise?"
Route: __________ (Complex - human)
```

---

## 📞 Support

- **Intercom API docs**: intercom.com/docs
- **KB best practices**: See Ressources-Communes/
- **ROI calculator**: See Ressources-Communes/
- **Community**: #ia-sani-marc