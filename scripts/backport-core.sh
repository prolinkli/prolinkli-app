#!/bin/bash

# Backport Core Changes Script
# Pushes changes back to core repositories

set -e  # Exit on any error

show_usage() {
    echo "Usage: $0 <backend|frontend> <branch-name>"
    echo ""
    echo "Examples:"
    echo "  $0 backend feature/new-auth-method"
    echo "  $0 frontend feature/improved-components" 
    echo ""
    echo "This will push your changes from the subtree to the core repository"
    echo "as a new branch that you can then create a pull request from."
}

if [ "$#" -ne 2 ]; then
    echo "❌ Error: Wrong number of arguments"
    show_usage
    exit 1
fi

COMPONENT="$1"
BRANCH_NAME="$2"

# Validate component
if [[ "$COMPONENT" != "backend" && "$COMPONENT" != "frontend" ]]; then
    echo "❌ Error: Component must be 'backend' or 'frontend'"
    show_usage
    exit 1
fi

# Validate branch name
if [[ ! "$BRANCH_NAME" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
    echo "❌ Error: Invalid branch name. Use only letters, numbers, hyphens, underscores, and slashes."
    exit 1
fi

echo "🚀 Backporting $COMPONENT changes to core..."
echo "========================================"

# Check if we have uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  WARNING: You have uncommitted changes."
    echo "   Please commit your changes before backporting."
    exit 1
fi

# Determine the remote and folder
if [ "$COMPONENT" = "backend" ]; then
    REMOTE="java-core"
    FOLDER="backend"
    CORE_REPO="prolinkli-java-core"
else
    REMOTE="angular-core" 
    FOLDER="frontend"
    CORE_REPO="prolinkli-angular-core"
fi

echo "📦 Component: $COMPONENT"
echo "🌿 Branch: $BRANCH_NAME"
echo "📁 Folder: $FOLDER"
echo "🔗 Remote: $REMOTE"
echo ""

# Show what commits we're about to push
echo "📝 Recent commits in $FOLDER/:"
echo "----------------------------------------"
git log --oneline -10 --grep="CORE:" -- "$FOLDER/"
echo ""

read -p "🤔 Do you want to proceed with backporting these changes? [y/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Backport cancelled."
    exit 1
fi

echo ""
echo "🔄 Pushing to $REMOTE as branch '$BRANCH_NAME'..."

if git subtree push --prefix="$FOLDER" "$REMOTE" "$BRANCH_NAME"; then
    echo ""
    echo "✅ Backport successful!"
    echo "========================================"
    echo "🎉 Your changes have been pushed to:"
    echo "   Repository: https://github.com/prolinkli/$CORE_REPO"
    echo "   Branch: $BRANCH_NAME"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Go to the core repository on GitHub"
    echo "   2. Create a pull request from the '$BRANCH_NAME' branch"
    echo "   3. Review and merge the changes"
    echo "   4. Other projects can then pull your improvements!"
else
    echo ""
    echo "❌ Backport failed!"
    echo "========================================"
    echo "🔍 Possible causes:"
    echo "   1. The core repository has moved ahead (try updating first)"
    echo "   2. Network connectivity issues"
    echo "   3. Permission issues with the core repository"
    echo ""
    echo "💡 Try running: ./scripts/update-core.sh first, then retry"
    exit 1
fi 