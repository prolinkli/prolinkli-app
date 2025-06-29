# Git Subtree Workflow for Business + Core Development

This guide addresses the challenge of extending core functionality with business logic while staying synchronized with core framework updates.

## The Challenge

You want to:
- ✅ Add business logic to `backend/` and `frontend/` folders
- ✅ Pull in core framework updates regularly  
- ✅ Handle conflicts when your changes conflict with core updates
- ✅ Optionally backport improvements to core repositories

## Recommended Workflow

### 1. Branch Strategy

#### For Core Framework Changes
When making changes that belong in the core framework:
```bash
# Create a feature branch for core changes
git checkout -b feature/core-auth-improvement

# Make your changes in backend/ or frontend/
# ... edit files ...

# Commit with clear "CORE:" prefix
git commit -m "CORE: Add new JWT validation method

- Adds validateTokenWithRefresh() method
- Improves error handling for expired tokens
- Should be backported to java-core"

# When ready, backport to core
git subtree push --prefix=backend java-core feature/auth-improvement
```

#### For Business Logic Changes
When adding business-specific functionality:
```bash
# Create a feature branch for business features
git checkout -b feature/business-user-profiles

# Make your changes
# ... edit files ...

# Commit with "BUSINESS:" prefix
git commit -m "BUSINESS: Add user profile management

- Adds ProfileController for business-specific user data
- Integrates with CRM system
- Business-only feature, not for core backport"
```

### 2. Pulling Core Updates

#### Simple Case (No Conflicts)
```bash
# Pull latest core updates
git subtree pull --prefix=backend java-core main --squash
git subtree pull --prefix=frontend angular-core main --squash
```

#### Complex Case (With Conflicts)
When you have local business changes and core updates conflict:

```bash
# 1. First, pull core updates (this may create conflicts)
git subtree pull --prefix=backend java-core main --squash

# 2. If conflicts occur, resolve them manually
# Edit conflicted files, keeping both business logic AND core updates

# 3. Commit the resolution
git commit -m "MERGE: Resolve conflicts between core updates and business logic

- Integrated new core authentication methods
- Preserved business-specific user validation
- Updated business controllers to use new core APIs"

# 4. Test thoroughly to ensure business logic still works
```

### 3. Advanced: Rebasing Business Changes

If you want cleaner history, you can rebase your business changes on top of core updates:

```bash
# 1. Create a backup branch
git branch backup-before-rebase

# 2. Identify your business commits
git log --oneline --grep="BUSINESS:" main ^origin/main

# 3. Interactive rebase to reorganize commits
git rebase -i HEAD~10  # Adjust number as needed

# 4. In the rebase, reorder commits so core changes come first,
#    then business changes that depend on them
```

## Conflict Resolution Strategies

### Strategy 1: Merge-First Approach (Recommended)
- Always merge core updates first
- Resolve conflicts by preserving both core improvements AND business logic
- Test thoroughly after each merge
- This keeps a clear history of when core updates were integrated

### Strategy 2: Rebase Approach (Advanced)
- Temporarily stash or commit business changes
- Pull core updates
- Rebase business changes on top
- More complex but creates cleaner history

## Helper Scripts

### Update Core Dependencies
```bash
#!/bin/bash
# scripts/update-core.sh

echo "🔄 Updating core dependencies..."

echo "📱 Updating frontend core..."
git subtree pull --prefix=frontend angular-core main --squash

echo "⚡ Updating backend core..."  
git subtree pull --prefix=backend java-core main --squash

echo "✅ Core updates complete! Run tests to verify compatibility."
```

### Backport Core Changes
```bash
#!/bin/bash
# scripts/backport-core.sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <backend|frontend> <branch-name>"
    exit 1
fi

if [ "$1" = "backend" ]; then
    echo "🚀 Backporting backend changes to java-core..."
    git subtree push --prefix=backend java-core "$2"
elif [ "$1" = "frontend" ]; then
    echo "🚀 Backporting frontend changes to angular-core..."
    git subtree push --prefix=frontend angular-core "$2"
else
    echo "❌ Invalid option. Use 'backend' or 'frontend'"
    exit 1
fi
```

## Best Practices

### Commit Message Conventions
- `CORE:` - Changes that should be backported to core repositories
- `BUSINESS:` - Business-specific changes that stay in this repo
- `MERGE:` - Conflict resolution commits when integrating core updates
- `SYNC:` - Pure sync commits from core repositories

### File Organization
```
backend/
├── src/main/java/com/prolinkli/
│   ├── core/           # 🔄 Core framework code (sync with core repo)
│   └── business/       # 🏢 Business-specific code (stays here)
```

### Development Flow
1. **Daily**: Pull core updates if available
2. **Feature Development**: Use appropriate branching strategy
3. **Before Release**: Ensure all core improvements are backported
4. **Testing**: Always test business logic after core updates

## Troubleshooting

### "Cannot backport" Error
If `git subtree push` fails:
```bash
# The core repo might have moved ahead
# First sync, then try backporting to a new branch
git subtree pull --prefix=backend java-core main --squash
git subtree push --prefix=backend java-core new-feature-branch
```

### Complex Merge Conflicts
If conflicts are too complex:
```bash
# 1. Backup your changes
git branch backup-my-changes

# 2. Reset to before the failed merge
git reset --hard HEAD~1

# 3. Apply core updates more granularly
# ... manual conflict resolution ...

# 4. Cherry-pick your business changes back
git cherry-pick backup-my-changes
```

## Summary

This workflow allows you to:
- ✅ Extend core functionality with business logic
- ✅ Stay synchronized with core framework updates
- ✅ Handle conflicts gracefully
- ✅ Maintain clean history with proper commit organization
- ✅ Easily backport improvements to core repositories

The key is **clear commit organization** and **regular synchronization** with the core repositories. 