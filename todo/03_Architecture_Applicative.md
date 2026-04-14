# Architecture Applicative - WALLY
## Guide de Développement et Standards Techniques

**Version:** 1.0  
**Date:** [Date]  
**Auteur(s):** [Architectes Applicatifs, Tech Leads]  
**Statut:** [Brouillon / En révision / Approuvé]  
**Classification:** Interne Technique

---

## Historique des versions

| Version | Date | Auteur | Description des changements |
|---------|------|--------|----------------------------|
| 1.0 | [Date] | [Nom] | Version initiale |

---

## Table des matières

1. [Introduction](#1-introduction)
2. [Stack technologique](#2-stack-technologique)
3. [Standards de développement](#3-standards-de-développement)
4. [Patterns et architectures](#4-patterns-et-architectures)
5. [Développement frontend](#5-développement-frontend)
6. [Développement backend](#6-développement-backend)
7. [Gestion des données](#7-gestion-des-données)
8. [Testing et qualité](#8-testing-et-qualité)
9. [DevOps et déploiement](#9-devops-et-déploiement)
10. [Observabilité](#10-observabilité)
11. [Sécurité applicative](#11-sécurité-applicative)
12. [Best practices et anti-patterns](#12-best-practices-et-anti-patterns)

---

# 1. Introduction

## 1.1 Objectif du document

Ce document est le **guide de référence technique** pour tous les développeurs travaillant sur WALLY. Il contient:
- Les standards de code et conventions
- Les patterns architecturaux à utiliser
- Les guidelines de développement par technologie
- Les best practices éprouvées
- Les exemples de code concrets

**Audience:** 
- Développeurs (Frontend, Backend, Full-Stack)
- Tech Leads
- Nouveaux membres de l'équipe (onboarding)
- Contributeurs externes

**Ce document NE couvre PAS:**
- La vision stratégique et principes d'entreprise (voir Architecture d'Entreprise)
- La conception fonctionnelle d'un projet spécifique (voir Architecture de Solution)

## 1.2 Comment utiliser ce document

**Pour les développeurs:**
- Référence quotidienne pour standards et patterns
- Consulter avant d'implémenter une nouvelle fonctionnalité
- Source de vérité pour résoudre des questions techniques

**Pour les Tech Leads:**
- Base pour code reviews
- Guide pour onboarding nouveaux développeurs
- Référence pour décisions techniques

**Pour les contributeurs:**
- Comprendre les attentes de qualité
- Apprendre les patterns utilisés dans le projet

## 1.3 Évolution du document

Ce document est vivant et évolue avec le projet:
- ✅ Mise à jour après chaque ADR technique majeure
- ✅ Enrichissement basé sur les learnings d'équipe
- ✅ Review trimestrielle pour pertinence
- ✅ Feedback continu encouragé via PR ou discussions

---

# 2. Stack technologique

## 2.1 Vue d'ensemble

### 2.1.1 Récapitulatif des technologies
```
Frontend: React 18 + TypeScript + Vite
Backend: Python 3.11+ + FastAPI
Database: PostgreSQL 15+
Cache: Redis 7+
Message Queue: Celery + Redis (ou AWS SQS)
Infrastructure: Kubernetes (EKS) + Terraform
CI/CD: GitHub Actions
Monitoring: CloudWatch + Datadog (ou Prometheus/Grafana)
```

### 2.1.2 Matrice de compatibilité
| Composant | Version minimale | Version recommandée | Notes |
|-----------|-----------------|-------------------|-------|
| Node.js | 18.x | 20.x LTS | Pour frontend build |
| Python | 3.11 | 3.11 | Pas encore 3.12 (librairies) |
| PostgreSQL | 15.0 | 15.5 | Pour advanced features |
| Redis | 7.0 | 7.2 | Pour modules additionnels |
| Docker | 24.0 | 26.0 | Pour build multi-stage |
| Kubernetes | 1.28 | 1.29 | EKS version supportée |

## 2.2 Frontend Stack

### 2.2.1 Core
- **Framework:** React 18.2+
- **Language:** TypeScript 5.3+
- **Build tool:** Vite 5.0+
- **Package manager:** npm 10+ (lock file committed)

### 2.2.2 Librairies principales
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "@reduxjs/toolkit": "^2.0.0",
    "react-redux": "^9.0.0",
    "@mui/material": "^5.15.0",
    "@tanstack/react-query": "^5.17.0",
    "axios": "^1.6.0",
    "date-fns": "^3.0.0",
    "zod": "^3.22.0",
    "react-hook-form": "^7.49.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@typescript-eslint/eslint-plugin": "^6.16.0",
    "@typescript-eslint/parser": "^6.16.0",
    "eslint": "^8.56.0",
    "prettier": "^3.1.0",
    "vite": "^5.0.0",
    "vitest": "^1.1.0",
    "@testing-library/react": "^14.1.0"
  }
}
```

### 2.2.3 Standards de version
- **React:** Toujours latest stable (18.x actuellement)
- **TypeScript:** Latest stable (5.x)
- **Dépendances:** Mise à jour mensuelle des patches, trimestrielle des mineures
- **Breaking changes:** ADR requis + migration plan

## 2.3 Backend Stack

### 2.3.1 Core
- **Language:** Python 3.11+
- **Framework:** FastAPI 0.109+
- **ASGI Server:** Uvicorn 0.25+ (production: Gunicorn + Uvicorn workers)
- **ORM:** SQLAlchemy 2.0+
- **Validation:** Pydantic V2

### 2.3.2 Librairies principales
```txt
# requirements.txt (principales)
fastapi==0.109.0
uvicorn[standard]==0.25.0
sqlalchemy==2.0.25
pydantic==2.5.0
pydantic-settings==2.1.0
alembic==1.13.0
psycopg2-binary==2.9.9
redis==5.0.1
celery==5.3.4
python-jose[cryptography]==3.3.0  # JWT
passlib[argon2]==1.7.4  # Password hashing
python-multipart==0.0.6  # File uploads
httpx==0.26.0  # Async HTTP client
structlog==24.1.0  # Structured logging
pytest==7.4.3
pytest-asyncio==0.23.0
```

### 2.3.3 Structure de projet type
```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app initialization
│   ├── config.py            # Pydantic Settings
│   ├── dependencies.py      # Dependency injection
│   ├── api/
│   │   ├── __init__.py
│   │   ├── v1/
│   │   │   ├── __init__.py
│   │   │   ├── endpoints/
│   │   │   │   ├── auth.py
│   │   │   │   ├── entities.py
│   │   │   │   └── ...
│   │   │   └── router.py
│   │   └── deps.py         # Endpoint dependencies
│   ├── core/
│   │   ├── __init__.py
│   │   ├── security.py      # Auth utilities
│   │   ├── logging.py       # Logging config
│   │   └── exceptions.py    # Custom exceptions
│   ├── models/              # SQLAlchemy models
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── user.py
│   │   └── entity.py
│   ├── schemas/             # Pydantic schemas
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── entity.py
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   ├── auth_service.py
│   │   └── entity_service.py
│   ├── repositories/        # Data access layer
│   │   ├── __init__.py
│   │   └── entity_repository.py
│   ├── tasks/               # Celery tasks
│   │   ├── __init__.py
│   │   └── email_tasks.py
│   └── db/
│       ├── __init__.py
│       ├── session.py       # Database session
│       └── base.py          # Base model
├── alembic/                 # Database migrations
│   ├── versions/
│   └── env.py
├── tests/
│   ├── unit/
│   ├── integration/
│   └── conftest.py
├── Dockerfile
├── requirements.txt
├── pyproject.toml           # Poetry ou setup config
└── README.md
```

## 2.4 Infrastructure et Outils

### 2.4.1 Containers
- **Container runtime:** Docker 24+
- **Orchestration:** Kubernetes 1.28+ (Amazon EKS)
- **Registry:** Amazon ECR

### 2.4.2 Infrastructure as Code
- **Tool:** Terraform 1.6+
- **Provider:** AWS
- **State:** S3 + DynamoDB lock

### 2.4.3 CI/CD
- **Platform:** GitHub Actions
- **Artifact storage:** ECR pour images, S3 pour autres
- **Secret management:** AWS Secrets Manager + GitHub Secrets

### 2.4.4 Monitoring et Observabilité
- **Logs:** CloudWatch Logs (AWS) + ELK Stack (si on-premise)
- **Metrics:** Prometheus + Grafana OU Datadog
- **Tracing:** AWS X-Ray OU Jaeger
- **APM:** Datadog OU New Relic (si budget)

---

# 3. Standards de développement

## 3.1 Conventions de code

### 3.1.1 Naming conventions

**Python (PEP 8):**
```python
# Variables et fonctions: snake_case
user_name = "John"
def calculate_total_price(items: list) -> float:
    pass

# Classes: PascalCase
class UserRepository:
    pass

# Constants: UPPER_SNAKE_CASE
MAX_RETRY_ATTEMPTS = 3
API_BASE_URL = "https://api.example.com"

# Private methods/attributes: prefix with _
def _internal_helper():
    pass

class MyClass:
    def __init__(self):
        self._private_attr = None
```

**TypeScript:**
```typescript
// Variables et fonctions: camelCase
const userName = "John";
function calculateTotalPrice(items: Item[]): number {
  // ...
}

// Classes, Interfaces, Types: PascalCase
class UserRepository {}
interface UserData {}
type UserId = string;

// Constants: UPPER_SNAKE_CASE ou camelCase (selon contexte)
const MAX_RETRY_ATTEMPTS = 3;
const apiBaseUrl = "https://api.example.com";

// Private methods: prefix with #
class MyClass {
  #privateMethod() {}
}

// Enums: PascalCase pour enum, UPPER_SNAKE_CASE pour values
enum Status {
  ACTIVE = "ACTIVE",
  INACTIVE = "INACTIVE",
}
```

**SQL:**
```sql
-- Tables: plural snake_case
CREATE TABLE users (...);
CREATE TABLE user_profiles (...);

-- Columns: singular snake_case
user_id, created_at, first_name

-- Indexes: idx_{table}_{columns}
CREATE INDEX idx_users_email ON users(email);

-- Foreign keys: fk_{from_table}_{to_table}
CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users(id)
```

### 3.1.2 Formatting

**Python:**
```python
# Utiliser Black (line length: 88)
# Configuration dans pyproject.toml
[tool.black]
line-length = 88
target-version = ['py311']
include = '\.pyi?$'

# Imports order (isort)
# 1. Standard library
import os
import sys
from typing import Optional

# 2. Third-party
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

# 3. Local
from app.core.config import settings
from app.models.user import User
```

**TypeScript:**
```typescript
// Utiliser Prettier (default config)
// .prettierrc.json
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": false,
  "printWidth": 100,
  "tabWidth": 2
}

// Imports order (ESLint plugin)
// 1. React
import React, { useState, useEffect } from "react";

// 2. Third-party
import { useQuery } from "@tanstack/react-query";
import { Box, Typography } from "@mui/material";

// 3. Local
import { UserCard } from "@/components/UserCard";
import { fetchUsers } from "@/services/api";
```

### 3.1.3 Linting

**Python (Ruff ou Pylint + mypy):**
```toml
# pyproject.toml
[tool.ruff]
select = ["E", "F", "I", "N", "W"]
ignore = ["E501"]  # Line too long (Black handles this)
line-length = 88
target-version = "py311"

[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

**TypeScript (ESLint):**
```json
// .eslintrc.json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "prettier"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/explicit-function-return-type": "off",
    "react/react-in-jsx-scope": "off"
  }
}
```

## 3.2 Git workflow

### 3.2.1 Branching strategy
**Stratégie:** Trunk-Based Development (ou GitFlow simplifié)

```
main (protected)
  ├── feature/JIRA-123-add-user-auth
  ├── feature/JIRA-124-dashboard-ui
  ├── bugfix/JIRA-125-fix-login-error
  └── hotfix/JIRA-126-critical-security-patch
```

**Règles:**
- `main` : Always deployable, protected
- `feature/*` : Nouvelles fonctionnalités
- `bugfix/*` : Corrections de bugs
- `hotfix/*` : Corrections critiques en prod

### 3.2.2 Commit messages
**Format:** Conventional Commits

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation
- `style`: Formatting (pas de changement de code)
- `refactor`: Refactoring (pas de nouvelle feature ou fix)
- `perf`: Amélioration de performance
- `test`: Ajout ou modification de tests
- `chore`: Tâches de maintenance (build, deps, etc.)

**Exemples:**
```bash
feat(auth): implement OAuth2 login flow

- Add OAuth2 provider configuration
- Implement callback handler
- Add user session management

Closes #123

fix(api): handle null pointer exception in user service

The user service was crashing when email field was null.
Added proper validation and error handling.

Fixes #456

docs(readme): update installation instructions

chore(deps): upgrade FastAPI to 0.109.0
```

### 3.2.3 Pull Requests

**Template:**
```markdown
## Description
[Brève description du changement]

## Type de changement
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix ou feature qui casse l'existant)
- [ ] Documentation update

## Comment a été testé?
[Décrire les tests effectués]

## Checklist:
- [ ] Mon code suit les standards du projet
- [ ] J'ai effectué un self-review
- [ ] J'ai commenté les parties complexes
- [ ] J'ai mis à jour la documentation
- [ ] Pas de nouveaux warnings
- [ ] J'ai ajouté des tests
- [ ] Tests unitaires passent localement
- [ ] Tests d'intégration passent

## Screenshots (si UI)
[Images avant/après]

## Issue liée
Closes #[numéro]
```

**Règles de PR:**
- ✅ Maximum 400 lignes de code (sinon découper)
- ✅ Minimum 2 reviewers (1 senior ou Tech Lead obligatoire)
- ✅ CI doit passer (tests, linting, security scan)
- ✅ Pas de merge sans approval
- ✅ Squash commits avant merge (historique propre)

## 3.3 Documentation du code

### 3.3.1 Python docstrings (Google style)
```python
def calculate_discount(
    price: float,
    discount_rate: float,
    max_discount: Optional[float] = None
) -> float:
    """Calculate the discounted price.

    Args:
        price: The original price.
        discount_rate: The discount rate as a decimal (e.g., 0.15 for 15%).
        max_discount: Optional maximum discount amount in absolute value.

    Returns:
        The final price after applying the discount.

    Raises:
        ValueError: If price is negative or discount_rate is not between 0 and 1.

    Example:
        >>> calculate_discount(100.0, 0.2)
        80.0
        >>> calculate_discount(100.0, 0.5, max_discount=30.0)
        70.0
    """
    if price < 0:
        raise ValueError("Price cannot be negative")
    if not 0 <= discount_rate <= 1:
        raise ValueError("Discount rate must be between 0 and 1")

    discount_amount = price * discount_rate
    if max_discount is not None:
        discount_amount = min(discount_amount, max_discount)

    return price - discount_amount
```

### 3.3.2 TypeScript JSDoc
```typescript
/**
 * Fetches user data from the API.
 *
 * @param userId - The unique identifier of the user
 * @param options - Optional fetch configuration
 * @returns A promise that resolves to the user data
 * @throws {ApiError} When the API request fails
 *
 * @example
 * ```typescript
 * const user = await fetchUser("123");
 * console.log(user.name);
 * ```
 */
async function fetchUser(
  userId: string,
  options?: RequestOptions
): Promise<User> {
  try {
    const response = await apiClient.get(`/users/${userId}`, options);
    return response.data;
  } catch (error) {
    throw new ApiError("Failed to fetch user", error);
  }
}
```

### 3.3.3 Commentaires inline
```python
# ✅ GOOD: Explain WHY, not WHAT
# Use exponential backoff to avoid overwhelming the API during outages
for attempt in range(MAX_RETRIES):
    try:
        return make_request()
    except RequestException:
        sleep(2 ** attempt)

# ❌ BAD: Comment states the obvious
# Loop through users
for user in users:
    # Print user name
    print(user.name)
```

```typescript
// ✅ GOOD: Explain non-obvious logic
// Safari requires a user gesture to play audio, so we initialize on first click
const initAudio = () => {
  audioContext.resume();
};

// ❌ BAD: Redundant comment
// Set loading to true
setLoading(true);
```

---

# 4. Patterns et architectures

## 4.1 Layered Architecture (Backend)

### 4.1.1 Structure en couches
```
┌─────────────────────────────┐
│    API Layer (Endpoints)    │  ← FastAPI routers
├─────────────────────────────┤
│    Service Layer            │  ← Business logic
├─────────────────────────────┤
│    Repository Layer         │  ← Data access
├─────────────────────────────┤
│    Model Layer              │  ← SQLAlchemy models
└─────────────────────────────┘
```

**Principe:** Chaque couche ne dépend que de la couche en dessous.

### 4.1.2 Exemple d'implémentation
```python
# models/entity.py (Model Layer)
from sqlalchemy import Column, String, DateTime
from app.db.base import Base

class Entity(Base):
    __tablename__ = "entities"

    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    created_at = Column(DateTime, server_default=func.now())

# repositories/entity_repository.py (Repository Layer)
from typing import List, Optional
from sqlalchemy.orm import Session
from app.models.entity import Entity

class EntityRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, entity_id: str) -> Optional[Entity]:
        return self.db.query(Entity).filter(Entity.id == entity_id).first()

    def list_all(self, skip: int = 0, limit: int = 100) -> List[Entity]:
        return self.db.query(Entity).offset(skip).limit(limit).all()

    def create(self, entity: Entity) -> Entity:
        self.db.add(entity)
        self.db.commit()
        self.db.refresh(entity)
        return entity

    def delete(self, entity_id: str) -> bool:
        entity = self.get_by_id(entity_id)
        if entity:
            self.db.delete(entity)
            self.db.commit()
            return True
        return False

# services/entity_service.py (Service Layer)
from typing import List
from app.repositories.entity_repository import EntityRepository
from app.schemas.entity import EntityCreate, EntityResponse
from app.core.exceptions import EntityNotFoundError

class EntityService:
    def __init__(self, repository: EntityRepository):
        self.repository = repository

    def get_entity(self, entity_id: str) -> EntityResponse:
        entity = self.repository.get_by_id(entity_id)
        if not entity:
            raise EntityNotFoundError(f"Entity {entity_id} not found")
        return EntityResponse.from_orm(entity)

    def list_entities(self, skip: int = 0, limit: int = 100) -> List[EntityResponse]:
        entities = self.repository.list_all(skip, limit)
        return [EntityResponse.from_orm(e) for e in entities]

    def create_entity(self, data: EntityCreate) -> EntityResponse:
        # Business logic here
        entity = Entity(**data.dict())
        created = self.repository.create(entity)
        return EntityResponse.from_orm(created)

# api/v1/endpoints/entities.py (API Layer)
from fastapi import APIRouter, Depends, HTTPException
from app.services.entity_service import EntityService
from app.schemas.entity import EntityCreate, EntityResponse
from app.api.deps import get_entity_service

router = APIRouter()

@router.get("/{entity_id}", response_model=EntityResponse)
async def get_entity(
    entity_id: str,
    service: EntityService = Depends(get_entity_service)
):
    try:
        return service.get_entity(entity_id)
    except EntityNotFoundError as e:
        raise HTTPException(status_code=404, detail=str(e))

@router.post("/", response_model=EntityResponse, status_code=201)
async def create_entity(
    data: EntityCreate,
    service: EntityService = Depends(get_entity_service)
):
    return service.create_entity(data)
```

## 4.2 Component Architecture (Frontend)

### 4.2.1 Structure des composants React
**Pattern:** Container/Presentational Components

```
components/
├── UserList/
│   ├── UserList.tsx           # Container (logic)
│   ├── UserListView.tsx       # Presentational (UI)
│   ├── UserListItem.tsx       # Sub-component
│   ├── UserList.test.tsx
│   ├── UserList.styles.ts     # Styles (si pas CSS modules)
│   └── index.ts               # Barrel export
```

**Exemple:**
```typescript
// UserList.tsx (Container)
import { useQuery } from "@tanstack/react-query";
import { fetchUsers } from "@/services/api";
import { UserListView } from "./UserListView";

export const UserList: React.FC = () => {
  const { data: users, isLoading, error } = useQuery({
    queryKey: ["users"],
    queryFn: fetchUsers,
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return <UserListView users={users || []} />;
};

// UserListView.tsx (Presentational)
import { User } from "@/types/user";
import { UserListItem } from "./UserListItem";
import { Box, Typography } from "@mui/material";

interface UserListViewProps {
  users: User[];
}

export const UserListView: React.FC<UserListViewProps> = ({ users }) => {
  if (users.length === 0) {
    return <Typography>No users found</Typography>;
  }

  return (
    <Box>
      {users.map((user) => (
        <UserListItem key={user.id} user={user} />
      ))}
    </Box>
  );
};

// UserListItem.tsx (Sub-component)
interface UserListItemProps {
  user: User;
}

export const UserListItem: React.FC<UserListItemProps> = ({ user }) => {
  return (
    <Box sx={{ padding: 2, borderBottom: "1px solid #eee" }}>
      <Typography variant="h6">{user.name}</Typography>
      <Typography variant="body2" color="text.secondary">
        {user.email}
      </Typography>
    </Box>
  );
};
```

### 4.2.2 Custom Hooks
```typescript
// hooks/useAuth.ts
import { useState, useEffect } from "react";
import { User } from "@/types/user";
import { authService } from "@/services/auth";

export const useAuth = () => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const currentUser = await authService.getCurrentUser();
        setUser(currentUser);
      } catch (error) {
        setUser(null);
      } finally {
        setLoading(false);
      }
    };
    checkAuth();
  }, []);

  const login = async (email: string, password: string) => {
    const user = await authService.login(email, password);
    setUser(user);
  };

  const logout = async () => {
    await authService.logout();
    setUser(null);
  };

  return { user, loading, login, logout };
};

// Usage
const MyComponent = () => {
  const { user, loading, login, logout } = useAuth();

  if (loading) return <div>Loading...</div>;
  if (!user) return <LoginForm onSubmit={login} />;

  return <Dashboard user={user} onLogout={logout} />;
};
```

## 4.3 Dependency Injection (Backend)

### 4.3.1 FastAPI Dependencies
```python
# app/api/deps.py
from typing import Generator
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.repositories.entity_repository import EntityRepository
from app.services.entity_service import EntityService
from app.core.security import get_current_user
from app.models.user import User

# Database session dependency
def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Repository dependency
def get_entity_repository(
    db: Session = Depends(get_db)
) -> EntityRepository:
    return EntityRepository(db)

# Service dependency
def get_entity_service(
    repository: EntityRepository = Depends(get_entity_repository)
) -> EntityService:
    return EntityService(repository)

# Auth dependency
async def get_current_active_user(
    current_user: User = Depends(get_current_user)
) -> User:
    if not current_user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Inactive user"
        )
    return current_user

# Permission dependency
def require_admin(
    current_user: User = Depends(get_current_active_user)
) -> User:
    if "admin" not in current_user.roles:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Insufficient permissions"
        )
    return current_user
```

**Usage dans endpoints:**
```python
@router.get("/admin-only")
async def admin_endpoint(
    current_user: User = Depends(require_admin),
    service: EntityService = Depends(get_entity_service)
):
    # Only admins can access this
    return service.get_admin_data()
```

## 4.4 Error Handling Patterns

### 4.4.1 Backend (Python)
```python
# core/exceptions.py
class AppException(Exception):
    """Base exception for application errors"""
    def __init__(self, message: str, status_code: int = 500):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)

class EntityNotFoundError(AppException):
    def __init__(self, message: str):
        super().__init__(message, status_code=404)

class ValidationError(AppException):
    def __init__(self, message: str):
        super().__init__(message, status_code=422)

class UnauthorizedError(AppException):
    def __init__(self, message: str = "Unauthorized"):
        super().__init__(message, status_code=401)

# main.py - Exception handlers
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from app.core.exceptions import AppException

app = FastAPI()

@app.exception_handler(AppException)
async def app_exception_handler(request: Request, exc: AppException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.message, "type": exc.__class__.__name__}
    )

@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    # Log the error
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}
    )
```

### 4.4.2 Frontend (TypeScript)
```typescript
// services/api/errors.ts
export class ApiError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public details?: unknown
  ) {
    super(message);
    this.name = "ApiError";
  }
}

export const handleApiError = (error: unknown): ApiError => {
  if (error instanceof ApiError) {
    return error;
  }

  if (axios.isAxiosError(error)) {
    const statusCode = error.response?.status || 500;
    const message = error.response?.data?.detail || error.message;
    return new ApiError(message, statusCode, error.response?.data);
  }

  return new ApiError("An unexpected error occurred", 500);
};

// Usage in component
const MyComponent = () => {
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (data: FormData) => {
    try {
      await apiService.createEntity(data);
      // Success
    } catch (err) {
      const apiError = handleApiError(err);
      setError(apiError.message);

      // Different handling based on status code
      if (apiError.statusCode === 401) {
        // Redirect to login
        navigate("/login");
      } else if (apiError.statusCode === 422) {
        // Validation errors
        setFieldErrors(apiError.details);
      }
    }
  };

  return (
    <>
      {error && <Alert severity="error">{error}</Alert>}
      <Form onSubmit={handleSubmit} />
    </>
  );
};
```

---

# 5. Développement frontend

## 5.1 State Management (Redux Toolkit)

### 5.1.1 Slice structure
```typescript
// features/users/usersSlice.ts
import { createSlice, createAsyncThunk, PayloadAction } from "@reduxjs/toolkit";
import { User } from "@/types/user";
import { fetchUsers as fetchUsersApi } from "@/services/api";

interface UsersState {
  users: User[];
  loading: boolean;
  error: string | null;
}

const initialState: UsersState = {
  users: [],
  loading: false,
  error: null,
};

// Async thunk
export const fetchUsers = createAsyncThunk("users/fetchUsers", async () => {
  const response = await fetchUsersApi();
  return response;
});

const usersSlice = createSlice({
  name: "users",
  initialState,
  reducers: {
    addUser: (state, action: PayloadAction<User>) => {
      state.users.push(action.payload);
    },
    removeUser: (state, action: PayloadAction<string>) => {
      state.users = state.users.filter((u) => u.id !== action.payload);
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsers.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchUsers.fulfilled, (state, action) => {
        state.loading = false;
        state.users = action.payload;
      })
      .addCase(fetchUsers.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || "Failed to fetch users";
      });
  },
});

export const { addUser, removeUser } = usersSlice.actions;
export default usersSlice.reducer;

// Selectors
export const selectUsers = (state: RootState) => state.users.users;
export const selectUsersLoading = (state: RootState) => state.users.loading;
```

### 5.1.2 Store configuration
```typescript
// store/index.ts
import { configureStore } from "@reduxjs/toolkit";
import usersReducer from "@/features/users/usersSlice";
import authReducer from "@/features/auth/authSlice";

export const store = configureStore({
  reducer: {
    users: usersReducer,
    auth: authReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        // Ignore these action types
        ignoredActions: ["persist/PERSIST"],
      },
    }),
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

// Typed hooks
import { TypedUseSelectorHook, useDispatch, useSelector } from "react-redux";
export const useAppDispatch: () => AppDispatch = useDispatch;
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
```

## 5.2 API Communication (React Query)

### 5.2.1 API Client setup
```typescript
// services/api/client.ts
import axios, { AxiosInstance, AxiosRequestConfig } from "axios";
import { getAuthToken } from "@/services/auth/token";

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";

class ApiClient {
  private client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: API_BASE_URL,
      timeout: 10000,
      headers: {
        "Content-Type": "application/json",
      },
    });

    // Request interceptor (add auth token)
    this.client.interceptors.request.use(
      (config) => {
        const token = getAuthToken();
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    // Response interceptor (handle errors)
    this.client.interceptors.response.use(
      (response) => response,
      async (error) => {
        if (error.response?.status === 401) {
          // Token expired, refresh or redirect to login
          // ... refresh logic
        }
        return Promise.reject(error);
      }
    );
  }

  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.get<T>(url, config);
    return response.data;
  }

  async post<T>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.post<T>(url, data, config);
    return response.data;
  }

  async put<T>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.put<T>(url, data, config);
    return response.data;
  }

  async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.delete<T>(url, config);
    return response.data;
  }
}

export const apiClient = new ApiClient();
```

### 5.2.2 React Query hooks
```typescript
// services/api/users.ts
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { apiClient } from "./client";
import { User, CreateUserData } from "@/types/user";

// Fetch users
export const useUsers = () => {
  return useQuery({
    queryKey: ["users"],
    queryFn: () => apiClient.get<User[]>("/users"),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

// Fetch single user
export const useUser = (userId: string) => {
  return useQuery({
    queryKey: ["users", userId],
    queryFn: () => apiClient.get<User>(`/users/${userId}`),
    enabled: !!userId, // Only run if userId exists
  });
};

// Create user mutation
export const useCreateUser = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateUserData) =>
      apiClient.post<User>("/users", data),
    onSuccess: (newUser) => {
      // Invalidate and refetch users list
      queryClient.invalidateQueries({ queryKey: ["users"] });

      // Or optimistically update
      queryClient.setQueryData<User[]>(["users"], (old) =>
        old ? [...old, newUser] : [newUser]
      );
    },
  });
};

// Delete user mutation
export const useDeleteUser = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (userId: string) =>
      apiClient.delete(`/users/${userId}`),
    onSuccess: (_, userId) => {
      // Remove user from cache
      queryClient.setQueryData<User[]>(["users"], (old) =>
        old ? old.filter((u) => u.id !== userId) : []
      );
    },
  });
};

// Usage in component
const UserList = () => {
  const { data: users, isLoading, error } = useUsers();
  const createUser = useCreateUser();
  const deleteUser = useDeleteUser();

  const handleCreate = async (data: CreateUserData) => {
    try {
      await createUser.mutateAsync(data);
      toast.success("User created!");
    } catch (error) {
      toast.error("Failed to create user");
    }
  };

  const handleDelete = (userId: string) => {
    deleteUser.mutate(userId);
  };

  if (isLoading) return <Loader />;
  if (error) return <ErrorMessage error={error} />;

  return (
    <div>
      <CreateUserForm onSubmit={handleCreate} />
      {users?.map((user) => (
        <UserCard key={user.id} user={user} onDelete={handleDelete} />
      ))}
    </div>
  );
};
```

## 5.3 Form Handling (React Hook Form + Zod)

```typescript
// schemas/user.ts
import { z } from "zod";

export const createUserSchema = z.object({
  name: z.string().min(1, "Name is required").max(100),
  email: z.string().email("Invalid email address"),
  age: z.number().min(18, "Must be at least 18").max(120),
  role: z.enum(["user", "admin"]),
});

export type CreateUserFormData = z.infer<typeof createUserSchema>;

// components/CreateUserForm.tsx
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { createUserSchema, CreateUserFormData } from "@/schemas/user";
import { TextField, Button, Select, MenuItem } from "@mui/material";

interface CreateUserFormProps {
  onSubmit: (data: CreateUserFormData) => Promise<void>;
}

export const CreateUserForm: React.FC<CreateUserFormProps> = ({ onSubmit }) => {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<CreateUserFormData>({
    resolver: zodResolver(createUserSchema),
    defaultValues: {
      name: "",
      email: "",
      age: 18,
      role: "user",
    },
  });

  const onSubmitForm = async (data: CreateUserFormData) => {
    await onSubmit(data);
    reset(); // Reset form after success
  };

  return (
    <form onSubmit={handleSubmit(onSubmitForm)}>
      <TextField
        {...register("name")}
        label="Name"
        error={!!errors.name}
        helperText={errors.name?.message}
        fullWidth
        margin="normal"
      />

      <TextField
        {...register("email")}
        label="Email"
        type="email"
        error={!!errors.email}
        helperText={errors.email?.message}
        fullWidth
        margin="normal"
      />

      <TextField
        {...register("age", { valueAsNumber: true })}
        label="Age"
        type="number"
        error={!!errors.age}
        helperText={errors.age?.message}
        fullWidth
        margin="normal"
      />

      <Select
        {...register("role")}
        label="Role"
        fullWidth
        margin="normal"
      >
        <MenuItem value="user">User</MenuItem>
        <MenuItem value="admin">Admin</MenuItem>
      </Select>

      <Button
        type="submit"
        variant="contained"
        disabled={isSubmitting}
        fullWidth
      >
        {isSubmitting ? "Creating..." : "Create User"}
      </Button>
    </form>
  );
};
```

## 5.4 Routing (React Router)

```typescript
// router/index.tsx
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { RootLayout } from "@/layouts/RootLayout";
import { ProtectedRoute } from "@/components/ProtectedRoute";
import { HomePage } from "@/pages/HomePage";
import { LoginPage } from "@/pages/LoginPage";
import { DashboardPage } from "@/pages/DashboardPage";
import { UsersPage } from "@/pages/UsersPage";
import { NotFoundPage } from "@/pages/NotFoundPage";

const router = createBrowserRouter([
  {
    path: "/",
    element: <RootLayout />,
    children: [
      {
        index: true,
        element: <HomePage />,
      },
      {
        path: "login",
        element: <LoginPage />,
      },
      {
        path: "dashboard",
        element: (
          <ProtectedRoute>
            <DashboardPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "users",
        element: (
          <ProtectedRoute requireRole="admin">
            <UsersPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "*",
        element: <NotFoundPage />,
      },
    ],
  },
]);

export const AppRouter = () => <RouterProvider router={router} />;

// components/ProtectedRoute.tsx
import { Navigate } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";

interface ProtectedRouteProps {
  children: React.ReactNode;
  requireRole?: string;
}

export const ProtectedRoute: React.FC<ProtectedRouteProps> = ({
  children,
  requireRole,
}) => {
  const { user, loading } = useAuth();

  if (loading) return <Loader />;

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (requireRole && !user.roles.includes(requireRole)) {
    return <Navigate to="/unauthorized" replace />;
  }

  return <>{children}</>;
};
```

---

# 6. Développement backend

## 6.1 FastAPI Application Structure

### 6.1.1 Main application
```python
# app/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.logging import setup_logging
from app.api.v1.router import api_router

setup_logging()

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    docs_url=f"{settings.API_V1_STR}/docs",
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API router
app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/health")
async def health_check():
    return {"status": "healthy", "version": settings.VERSION}

@app.on_event("startup")
async def startup_event():
    # Initialize connections, etc.
    pass

@app.on_event("shutdown")
async def shutdown_event():
    # Cleanup
    pass
```

### 6.1.2 Configuration management
```python
# app/core/config.py
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    # App
    PROJECT_NAME: str = "WALLY API"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"
    
    # Security
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Database
    DATABASE_URL: str
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379"
    
    # CORS
    ALLOWED_ORIGINS: list[str] = ["http://localhost:3000"]
    
    # External APIs
    EXTERNAL_API_KEY: str
    EXTERNAL_API_URL: str
    
    # Logging
    LOG_LEVEL: str = "INFO"
    
    model_config = SettingsConfigDict(
        env_file=".env",
        case_sensitive=True,
        extra="ignore"
    )

settings = Settings()
```

## 6.2 Database Operations

### 6.2.1 Models (SQLAlchemy 2.0)
```python
# app/models/base.py
from datetime import datetime
from sqlalchemy import DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

class Base(DeclarativeBase):
    pass

class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now()
    )

# app/models/user.py
from sqlalchemy import String, Boolean
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import Base, TimestampMixin
import uuid

class User(Base, TimestampMixin):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(
        String,
        primary_key=True,
        default=lambda: str(uuid.uuid4())
    )
    email: Mapped[str] = mapped_column(String, unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_superuser: Mapped[bool] = mapped_column(Boolean, default=False)
    
    # Relationships
    entities: Mapped[list["Entity"]] = relationship(
        back_populates="owner",
        cascade="all, delete-orphan"
    )
```

### 6.2.2 Database migrations (Alembic)
```python
# alembic/env.py
from alembic import context
from sqlalchemy import engine_from_config, pool
from app.core.config import settings
from app.models.base import Base
# Import all models
from app.models.user import User
from app.models.entity import Entity

config = context.config
config.set_main_option("sqlalchemy.url", settings.DATABASE_URL)

target_metadata = Base.metadata

def run_migrations_online():
    connectable = engine_from_config(
        config.get_section(config.config_ini_section),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True  # Detect type changes
        )

        with context.begin_transaction():
            context.run_migrations()
```

**Commandes:**
```bash
# Create migration
alembic revision --autogenerate -m "Add users table"

# Apply migration
alembic upgrade head

# Rollback
alembic downgrade -1

# Show current revision
alembic current
```

## 6.3 Authentication & Authorization

### 6.3.1 JWT utilities
```python
# app/core/security.py
from datetime import datetime, timedelta
from typing import Any, Union
from jose import jwt, JWTError
from passlib.context import CryptContext
from app.core.config import settings

pwd_context = CryptContext(schemes=["argon2"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_access_token(data: dict[str, Any], expires_delta: Union[timedelta, None] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def decode_access_token(token: str) -> Union[str, None]:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        user_id: str = payload.get("sub")
        return user_id
    except JWTError:
        return None
```

### 6.3.2 Auth dependencies
```python
# app/api/deps.py
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from app.core.security import decode_access_token
from app.db.session import get_db
from app.models.user import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    user_id = decode_access_token(token)
    if user_id is None:
        raise credentials_exception
    
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise credentials_exception
    
    return user

async def get_current_active_user(
    current_user: User = Depends(get_current_user)
) -> User:
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

async def get_current_superuser(
    current_user: User = Depends(get_current_active_user)
) -> User:
    if not current_user.is_superuser:
        raise HTTPException(
            status_code=403,
            detail="The user doesn't have enough privileges"
        )
    return current_user
```

## 6.4 Async Tasks (Celery)

### 6.4.1 Celery configuration
```python
# app/tasks/celery_app.py
from celery import Celery
from app.core.config import settings

celery_app = Celery(
    "wally",
    broker=settings.REDIS_URL,
    backend=settings.REDIS_URL
)

celery_app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="UTC",
    enable_utc=True,
    task_track_started=True,
    task_time_limit=30 * 60,  # 30 minutes
)

# app/tasks/email_tasks.py
from app.tasks.celery_app import celery_app
import structlog

logger = structlog.get_logger()

@celery_app.task(name="send_email", bind=True, max_retries=3)
def send_email_task(self, to: str, subject: str, body: str):
    try:
        # Email sending logic
        logger.info("Sending email", to=to, subject=subject)
        # ... actual email sending
        return {"status": "sent", "to": to}
    except Exception as exc:
        logger.error("Failed to send email", error=str(exc))
        # Retry with exponential backoff
        raise self.retry(exc=exc, countdown=60 * (2 ** self.request.retries))

# Usage in endpoint
@router.post("/send-notification")
async def send_notification(email: str, message: str):
    task = send_email_task.delay(email, "Notification", message)
    return {"task_id": task.id, "status": "queued"}
```

---

*[Le document continue avec les sections 7-12 couvrant la gestion des données, testing, DevOps, observabilité, sécurité et best practices...]*

---

# Annexes

## Annexe A: Checklists

### Code Review Checklist
```markdown
## Functional
- [ ] Code implements requirements correctly
- [ ] Edge cases are handled
- [ ] Error handling is appropriate

## Code Quality
- [ ] Follows naming conventions
- [ ] No code duplication
- [ ] Functions are small and focused
- [ ] Comments explain WHY, not WHAT

## Testing
- [ ] Unit tests included and passing
- [ ] Test coverage > 80%
- [ ] Integration tests if applicable

## Security
- [ ] No secrets in code
- [ ] Input validation present
- [ ] SQL injection prevented
- [ ] XSS prevented

## Performance
- [ ] No obvious performance issues
- [ ] Database queries optimized
- [ ] No N+1 queries

## Documentation
- [ ] README updated if needed
- [ ] API docs updated
- [ ] Complex logic documented
```

### Pre-Deployment Checklist
```markdown
- [ ] All tests pass
- [ ] Code reviewed and approved
- [ ] Migration scripts tested
- [ ] Rollback plan documented
- [ ] Feature flags configured
- [ ] Monitoring alerts configured
- [ ] Stakeholders notified
- [ ] Change request approved
```

## Annexe B: Glossaire technique

| Terme | Définition |
|-------|-----------|
| ORM | Object-Relational Mapping - Mapping entre objets code et tables DB |
| JWT | JSON Web Token - Standard pour tokens d'authentification |
| CORS | Cross-Origin Resource Sharing - Politique de sécurité navigateur |
| SSR | Server-Side Rendering - Rendu HTML côté serveur |
| CSR | Client-Side Rendering - Rendu HTML côté navigateur |
| Hydration | Processus de rendre interactif un HTML pré-rendu |

## Annexe C: Références et ressources

**Documentation officielle:**
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [React Docs](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [SQLAlchemy 2.0 Tutorial](https://docs.sqlalchemy.org/en/20/tutorial/)

**Guides de style:**
- [PEP 8 - Python Style Guide](https://peps.python.org/pep-0008/)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)

**Outils:**
- [Can I Use](https://caniuse.com/) - Browser compatibility
- [Regex101](https://regex101.com/) - Regex testing
- [JSON Schema Validator](https://www.jsonschemavalidator.net/)

## Annexe D: Contacts

| Domaine | Expert | Contact |
|---------|--------|---------|
| Architecture Applicative | [Nom] | [email] |
| Frontend | [Tech Lead Frontend] | [email] |
| Backend | [Tech Lead Backend] | [email] |
| DevOps | [DevOps Lead] | [email] |
| Sécurité | [Security Champion] | [email] |

---

**Document maintenu par:** Équipe Architecture & Tech Leads  
**Prochaine revue:** Trimestrielle  
**Feedback:** Créer une issue GitHub ou contacter tech-leads@entreprise.com
