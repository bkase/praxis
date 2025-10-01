#!/bin/bash

# Google Calendar MCP Setup Script

echo "🚀 Google Calendar MCP Setup"
echo "============================"
echo ""

# Step 1: Create directories
echo "📁 Creating configuration directories..."
mkdir -p ~/.config/mcp-servers
mkdir -p ~/.config/google

# Step 2: Install the package
echo ""
echo "📦 Installing Google Calendar MCP package..."
cd ~/.config/mcp-servers

# Check if package.json exists, if not initialize
if [ ! -f "package.json" ]; then
    npm init -y > /dev/null 2>&1
fi

# Install the MCP package
npm install @cocal/google-calendar-mcp

echo "✅ Package installed"

# Step 3: Check for OAuth credentials
echo ""
echo "🔑 Checking for OAuth credentials..."
CREDS_PATH="$HOME/.config/google/gcp-oauth.keys.json"

if [ ! -f "$CREDS_PATH" ]; then
    echo "❌ OAuth credentials not found at $CREDS_PATH"
    echo ""
    echo "Please follow these steps:"
    echo "1. Go to https://console.cloud.google.com/"
    echo "2. Create OAuth 2.0 credentials for 'Desktop app'"
    echo "3. Download the JSON file"
    echo "4. Save it as: $CREDS_PATH"
    echo "5. Run this script again"
    exit 1
else
    echo "✅ Found credentials at $CREDS_PATH"
fi

# Step 4: Authenticate
echo ""
echo "🔐 Authenticating with Google..."
echo "A browser window will open for authentication."
echo "Press Enter to continue..."
read

export GOOGLE_OAUTH_CREDENTIALS="$CREDS_PATH"
cd ~/.config/mcp-servers
npx @cocal/google-calendar-mcp auth

# Step 5: Configure Claude Desktop
echo ""
echo "⚙️  Configuring Claude Desktop..."

CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

# Check if config exists
if [ ! -f "$CLAUDE_CONFIG" ]; then
    echo "Creating new Claude config..."
    mkdir -p "$(dirname "$CLAUDE_CONFIG")"
    cat > "$CLAUDE_CONFIG" << EOF
{
  "mcpServers": {
    "google-calendar": {
      "command": "node",
      "args": ["$HOME/.config/mcp-servers/node_modules/@cocal/google-calendar-mcp/dist/index.js"],
      "env": {
        "GOOGLE_OAUTH_CREDENTIALS": "$CREDS_PATH"
      }
    }
  }
}
EOF
else
    echo "⚠️  Claude config already exists at:"
    echo "   $CLAUDE_CONFIG"
    echo ""
    echo "Add this to your mcpServers section:"
    cat << EOF

    "google-calendar": {
      "command": "node",
      "args": ["$HOME/.config/mcp-servers/node_modules/@cocal/google-calendar-mcp/dist/index.js"],
      "env": {
        "GOOGLE_OAUTH_CREDENTIALS": "$CREDS_PATH"
      }
    }

EOF
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Completely quit Claude Desktop (Cmd+Q)"
echo "2. Restart Claude Desktop"
echo "3. Test with: 'What events do I have today?'"
echo ""
echo "The MCP functions will be available as mcp_google_calendar_* tools"