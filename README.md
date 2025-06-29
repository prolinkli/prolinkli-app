# Prolinkli Business Application

This repository contains the main Prolinkli business application, which integrates both the backend and frontend core components using Git subtrees.

## Repository Structure

```
prolinkli-app/
├── backend/          # Java Spring Boot backend (subtree from prolinkli-java-core)
├── frontend/         # Angular frontend (subtree from prolinkli-angular-core)
├── scripts/          # Helper scripts for managing subtrees
│   ├── update-core.sh     # Pull latest core updates
│   ├── backport-core.sh   # Push changes back to core repos
│   └── status-core.sh     # Monitor subtree status
└── README.md              # This file
```

## Git Subtrees Setup

This repository uses Git subtrees to manage the core components:

- **Backend**: `prolinkli-java-core` repository mapped to `backend/` folder
- **Frontend**: `prolinkli-angular-core` repository mapped to `frontend/` folder

### Benefits of Git Subtrees

1. **Single Repository**: All code is contained in one repository for easier development
2. **Simplified CI/CD**: Build and deploy everything from one place
3. **Easy Backporting**: Push changes back to core repositories
4. **No Submodule Complexity**: Code is directly included, no pointer files

## Quick Start

### Prerequisites
- **Java 17+** - [Download here](https://adoptium.net/)
- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
- **Node.js & Angular CLI** - For frontend development

### Setup & Run

```bash
# 1. Clone this repository
git clone https://github.com/prolinkli/prolinkli-app.git
cd prolinkli-app

# 2. Start backend
cd backend
./start-db.sh
./start-dev.sh

# 3. Start frontend (in another terminal)
cd frontend
# Angular commands will go here
```

## Working with Subtrees

### Quick Commands

```bash
# Update core dependencies
./scripts/update-core.sh

# Check subtree status  
./scripts/status-core.sh

# Backport your improvements to core
./scripts/backport-core.sh backend feature/my-improvement
./scripts/backport-core.sh frontend feature/my-improvement
```

### Manual Subtree Operations

#### Update Backend (Java Core)
```bash
git subtree pull --prefix=backend java-core main --squash
```

#### Update Frontend (Angular Core)
```bash
git subtree pull --prefix=frontend angular-core main --squash
```

#### Push Backend Changes to Java Core
```bash
git subtree push --prefix=backend java-core feature/branch-name
```

#### Push Frontend Changes to Angular Core
```bash
git subtree push --prefix=frontend angular-core feature/branch-name
```

## Development Workflow

### 1. Regular Development
- Work normally in the `backend/` and `frontend/` folders
- Commit and push to this repository as usual
- The subtree history is preserved

### 2. Core Feature Development
- If you're developing a feature that belongs in the core:
  - Develop it in the appropriate `backend/` or `frontend/` folder
  - Test it in the context of the business application
  - When ready, push it back to the core repository using subtree push
  - Other projects using the core will benefit from your improvements

### 3. Syncing with Core Updates
- Regularly pull updates from core repositories
- Resolve any conflicts if they arise
- Test that core updates work with your business logic

## Commit Conventions

Use these prefixes to organize your commits:

- `CORE:` - Changes that should be backported to core repositories
- `BUSINESS:` - Business-specific changes that stay in this repo
- `MERGE:` - Conflict resolution commits when integrating core updates
- `SETUP:` - Repository setup and configuration changes

## Core Repositories

- **Java Core**: [prolinkli-java-core](https://github.com/prolinkli/prolinkli-java-core)
  - Authentication, authorization, JWT handling
  - Database models and DAOs
  - Security configuration
  - Utility classes

- **Angular Core**: [prolinkli-angular-core](https://github.com/prolinkli/prolinkli-angular-core)
  - Authentication components
  - Core UI components
  - Utility services
  - Common pipes and directives

## Documentation

- **[Java Core Documentation](backend/README.md)** - Backend-specific documentation
- **[Angular Core Documentation](frontend/README.md)** - Frontend-specific documentation

## Contributing

1. **Business Features**: Develop directly in this repository
2. **Core Features**: Develop here but consider backporting to core repositories
3. **Core Bugs**: Fix in this repository and backport to core repositories

## Troubleshooting

### Subtree Pull Conflicts
If you encounter conflicts when pulling core updates:
1. Resolve conflicts manually, preserving both core updates AND business logic
2. Commit with `MERGE:` prefix explaining the resolution
3. Test thoroughly to ensure business logic still works

### Backport Issues
If `git subtree push` fails:
- The core repo might have moved ahead
- First run `./scripts/update-core.sh` to sync
- Then try backporting to a new branch

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**🎯 Ready to start building your business application on top of the core framework!**


