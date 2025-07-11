#!/bin/bash

# Update Core Dependencies Script
# Pulls latest changes from both core repositories

set -e  # Exit on any error

echo "🔄 Updating core dependencies..."
echo "========================================"

# Check if we have uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  WARNING: You have uncommitted changes."
    echo "   Consider committing them before updating core dependencies."
    read -p "   Continue anyway? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Update cancelled."
        exit 1
    fi
fi

echo ""
echo "⚡ Updating backend core (prolinkli-java-core)..."
echo "----------------------------------------"
if git subtree pull --prefix=backend origin/prolinkli-java-core main --squash; then
    echo "✅ Backend core updated successfully"
else
    echo "❌ Backend core update failed"
    echo "   You may need to resolve conflicts manually"
    exit 1
fi

echo ""
echo "📱 Updating frontend core (prolinkli-angular-core)..."
echo "----------------------------------------"
if git subtree pull --prefix=frontend origin/prolinkli-angular-core main --squash; then
    echo "✅ Frontend core updated successfully"
else
    echo "❌ Frontend core update failed"
    echo "   You may need to resolve conflicts manually"
    exit 1
fi

echo ""
echo "🎉 Core updates complete!"
echo "========================================"
echo "📋 Next steps:"
echo "   1. Run your tests to verify compatibility"
echo "   2. Check for any new features in the core that you can leverage"
echo "   3. Update your business logic if needed"
echo ""
echo "💡 If you made any improvements to core functionality,"
echo "   consider backporting them with: ./scripts/backport-core.sh" 
