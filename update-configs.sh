#!/bin/bash
# Container-safe configuration backup script

echo "🔄 Safely backing up homelab configurations..."
echo "ℹ️  This script COPIES files - containers keep running"

# Navigate to repo directory
cd ~/homelab-configs

# Check container status for user info
echo ""
echo "📊 Container Status Check:"
if command -v docker >/dev/null 2>&1; then
    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "(pihole|cloudflared)"; then
        echo "✅ Containers are running - using safe copy method"
    else
        echo "ℹ️  No Pi-hole/Cloudflared containers detected running"
    fi
else
    echo "ℹ️  Docker not found - assuming system service setup"
fi

echo ""
echo "📁 Copying configurations..."

# Copy the entire Docker Compose stack
echo "📦 Copying Docker Compose stack..."
if sudo cp -r /opt/stacks/pihole/* pihole-cloudflare/ 2>/dev/null; then
    echo "✅ Docker stack copied from /opt/stacks/pihole/"
else
    echo "❌ Failed to copy Docker stack from /opt/stacks/pihole/"
    echo "   Check if path exists and permissions are correct"
fi

# Also copy Pi-hole persistent data if it exists separately
if [ -d "/etc/pihole" ]; then
    echo "📁 Copying Pi-hole persistent data..."
    mkdir -p pihole-cloudflare/pihole-data
    if sudo cp -r /etc/pihole/* pihole-cloudflare/pihole-data/ 2>/dev/null; then
        echo "✅ Pi-hole data copied from /etc/pihole/"
    fi
fi

# Copy Cloudflare persistent data if it exists separately
if [ -d "/etc/cloudflared" ]; then
    echo "📁 Copying Cloudflare persistent data..."
    mkdir -p pihole-cloudflare/cloudflare-data
    if sudo cp -r /etc/cloudflared/* pihole-cloudflare/cloudflare-data/ 2>/dev/null; then
        echo "✅ Cloudflare data copied from /etc/cloudflared/"
    fi
fi

# Fix ownership (critical for Git operations)
sudo chown -R $USER:$USER pihole-cloudflare/

# Update README with last backup time
sed -i "s/Last Backup.*/Last Backup**: $(date '+%Y-%m-%d %H:%M:%S')/" README.md

# Check for changes and commit
echo ""
if [[ -n $(git status --porcelain) ]]; then
    echo "📝 Changes detected:"
    git status --short
    
    echo ""
    echo "Enter commit message (or press Enter for default):"
    read -r commit_msg
    
    if [[ -z "$commit_msg" ]]; then
        commit_msg="Backup: Configuration sync $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    
    git add .
    git commit -m "$commit_msg"
    echo "✅ Changes committed successfully!"
    
    # Push to GitHub if remote exists
    if git remote -v | grep -q origin; then
        echo ""
        echo "⬆️  Pushing to GitHub..."
        if git push origin main; then
            echo "✅ Successfully pushed to GitHub!"
            echo "🌐 View at: $(git remote get-url origin)"
        else
            echo "❌ Failed to push to GitHub - check authentication"
        fi
    else
        echo "ℹ️  No remote repository configured"
    fi
else
    echo "ℹ️  No changes detected - configurations are up to date"
fi

echo ""
echo "🏠 Local repository: ~/homelab-configs"
echo "📁 Docker stack location: /opt/stacks/pihole"
echo "📅 Backup completed: $(date '+%Y-%m-%d %H:%M:%S')"
