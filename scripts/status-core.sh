#!/bin/bash

# Core Subtree Status Script
# Shows the current status of both core subtrees

echo "📊 Core Subtree Status"
echo "========================================"

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "🌿 Current branch: $CURRENT_BRANCH"
echo ""

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  UNCOMMITTED CHANGES DETECTED"
    echo "   You have local modifications. Consider committing before updating cores."
    echo ""
fi

# Show recent commits in each subtree
echo "📱 Frontend Core (Angular) - Recent Changes:"
echo "----------------------------------------"
echo "Last 5 commits affecting frontend/:"
git log --oneline -5 -- frontend/ || echo "No commits found in frontend/"
echo ""

echo "⚡ Backend Core (Java) - Recent Changes:"  
echo "----------------------------------------"
echo "Last 5 commits affecting backend/:"
git log --oneline -5 -- backend/ || echo "No commits found in backend/"
echo ""

# Show commits by category
echo "🔍 Commit Analysis:"
echo "----------------------------------------"

CORE_COMMITS=$(git log --oneline --grep="CORE:" --since="1 month ago" | wc -l)
BUSINESS_COMMITS=$(git log --oneline --grep="BUSINESS:" --since="1 month ago" | wc -l)
MERGE_COMMITS=$(git log --oneline --grep="MERGE:" --since="1 month ago" | wc -l)

echo "📊 Last 30 days:"
echo "   🔧 CORE commits (backportable): $CORE_COMMITS"
echo "   🏢 BUSINESS commits (stays here): $BUSINESS_COMMITS"  
echo "   🔀 MERGE commits (conflict resolution): $MERGE_COMMITS"
echo ""

# Check remote status
echo "🌐 Remote Status:"
echo "----------------------------------------"
git remote -v | grep -E "(java-core|angular-core)" || echo "⚠️  Core remotes not configured"
echo ""

# Show potential backports
echo "🚀 Potential Backports:"
echo "----------------------------------------"
CORE_COMMITS_DETAIL=$(git log --oneline --grep="CORE:" --since="1 week ago")
if [ -z "$CORE_COMMITS_DETAIL" ]; then
    echo "   ✅ No core changes to backport"
else
    echo "   📝 Recent CORE commits that could be backported:"
    echo "$CORE_COMMITS_DETAIL" | sed 's/^/   /'
    echo ""
    echo "   💡 Run: ./scripts/backport-core.sh <backend|frontend> <branch-name>"
fi

echo ""
echo "🛠️  Available Commands:"
echo "----------------------------------------"
echo "   📥 Update cores: ./scripts/update-core.sh"
echo "   📤 Backport changes: ./scripts/backport-core.sh <backend|frontend> <branch>"
echo "   📊 Check status: ./scripts/status-core.sh" 