#!/bin/bash

# Configure ProLinkLi App Script
# Sets up git remotes and other initial configuration

set -e  # Exit on any error

echo "🔧 Configuring ProLinkLi App..."
echo "========================================"

# Function to add remote if it doesn't exist
add_remote_if_not_exists() {
    local remote_name="$1"
    local remote_url="$2"
    
    if git remote get-url "$remote_name" >/dev/null 2>&1; then
        echo "   ✅ Remote '$remote_name' already exists"
        # Check if URL matches
        current_url=$(git remote get-url "$remote_name")
        if [ "$current_url" != "$remote_url" ]; then
            echo "   ⚠️  Remote '$remote_name' URL mismatch:"
            echo "      Current: $current_url"
            echo "      Expected: $remote_url"
            read -p "   🤔 Update the URL? [y/N]: " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git remote set-url "$remote_name" "$remote_url"
                echo "   ✅ Updated '$remote_name' URL"
            fi
        fi
    else
        echo "   📡 Adding remote '$remote_name'..."
        git remote add "$remote_name" "$remote_url"
        echo "   ✅ Added remote '$remote_name'"
    fi
}

echo ""
echo "📡 Setting up git remotes..."
echo "----------------------------------------"

# Add core repository remotes
add_remote_if_not_exists "prolinkli-angular-core" "https://github.com/prolinkli/prolinkli-angular-core"
add_remote_if_not_exists "prolinkli-java-core" "https://github.com/prolinkli/prolinkli-java-core"

echo ""
echo "🔍 Verifying configuration..."
echo "----------------------------------------"

# Show all remotes
echo "📋 Configured remotes:"
git remote -v | sed 's/^/   /'

echo ""
echo "🎯 Testing remote connectivity..."
echo "----------------------------------------"

# Test if remotes are accessible
for remote in "prolinkli-angular-core" "prolinkli-java-core"; do
    echo -n "   Testing $remote... "
    if git ls-remote "$remote" HEAD >/dev/null 2>&1; then
        echo "✅ OK"
    else
        echo "❌ FAILED"
        echo "      You may need to configure authentication or check network access"
    fi
done

echo ""
echo "🎉 Configuration complete!"
echo "========================================"
echo "📋 Next steps:"
echo "   1. Run './scripts/update-core.sh' to pull latest core dependencies"
echo "   2. Run './scripts/status-core.sh' to check the current status"
echo "   3. Start developing with './scripts/start-dev.sh'"
echo ""
echo "💡 Pro tips:"
echo "   • Use 'CORE:' prefix in commits for changes that should be backported"
echo "   • Use 'BUSINESS:' prefix for app-specific changes"
echo "   • Run './scripts/backport-core.sh' to push improvements back to core" 