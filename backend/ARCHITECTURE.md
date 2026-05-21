# KHEDMA Backend Architecture

This document outlines the architectural decisions and directory structure for the KHEDMA Smart Home Services & Medical Care Platform backend.

## 1. Directory Tree & Modular Structure

We follow a strictly Decoupled Clean Architecture grouped by Feature (Modular Monolith approach).

```
khidma-backend/
├── .github/
│   └── workflows/
│       └── main.yml           # CI/CD pipelines
├── docker-compose.yml         # Container orchestration (Postgres, Redis, App)
├── Dockerfile                 # Production Build image
├── src/
│   ├── app.module.ts          # Root module
│   ├── main.ts                # Application Entrypoint
│   ├── core/                  # Cross-cutting concerns (Auth guards, interceptors, filters)
│   ├── config/                # Environment, Database, and external service configurations
│   └── modules/               # Feature-First Modules
│       ├── auth/              # Authentication & JWT
│       ├── users/             # Client & Provider profiles
│       ├── orders/            # TaskRequest, Escrow, Status Tracking
│       ├── wallet/            # Subscriptions, Transactions, Discounts
│       ├── chat/              # Negotiation & Tech Support (Socket.io)
│       └── emergency-dispatch/# (Example Implementation)
│           ├── presentation/  # Controllers, Resolvers, DTOs
│           ├── application/   # Use Cases, Application Services
│           ├── domain/        # Entities, Value Objects, Repository Interfaces
│           └── infrastructure/# Concrete Repositories, External API calls
└── test/                      # E2E Tests
```

## 2. Layer Breakdown

Each module adheres to Clean Architecture layers:

1. **Presentation Layer (`presentation/`)**:
   - Handles HTTP/Socket requests and responses.
   - Contains Controllers (NestJS) and DTOs (Data Transfer Objects).
   - Validates incoming data. It must **not** contain business logic.
2. **Application Layer (`application/`)**:
   - Contains Use Cases (Services) representing the business workflows (e.g., `CreateEmergencyRequestUseCase`).
   - Orchestrates Domain Entities and Infrastructure services.
3. **Domain Layer (`domain/`)**:
   - The core of the system. Completely agnostic of the framework (NestJS) or database (Postgres).
   - Contains Entities (e.g., `EmergencyEntity`), Value Objects, and interfaces for Repositories (e.g., `IEmergencyRepository`).
4. **Infrastructure Layer (`infrastructure/`)**:
   - Contains implementations of Domain interfaces.
   - Database repositories (TypeORM/Prisma), external API adapters (Stripe, Twilio), and caching mechanisms (Redis).

## 3. Database Strategy (PostgreSQL + Redis)

- **PostgreSQL**: Used as the primary relational datastore. It is highly suited for complex queries, Escrow guarantees, wallet transaction integrity (ACID), and Geographic proximity searches using the **PostGIS** extension (replacing the previous MongoDB 2dsphere indexing for a unified relational approach).
- **Redis**: Used for high-speed, volatile data:
  - Caching frequent queries (seasonal services, app config).
  - Tracking Helper live locations and `onlineStatus`.
  - Storing real-time Socket.io session IDs for Chat/Negotiation.
- **ORM / Query Builder**: TypeORM or Prisma will be injected in the Infrastructure layer to fulfill the Repository interfaces.

## 4. Dependency Injection & Scalability

- **Strict DI**: NestJS's IoC container is used to inject interfaces, not concrete classes. For example, `EmergencyUseCase` requests `IEmergencyRepository` via a custom string token (`EMERGENCY_REPOSITORY`). The module configuration binds that token to the concrete `EmergencyRepository`.
- **Microservices Readiness**: Because modules do not directly import concrete database connections or business logic from other modules (they communicate via Use Cases or internal event buses), an entire folder (e.g., `emergency-dispatch`) can be physically moved to a new microservice repository with minimal refactoring.
