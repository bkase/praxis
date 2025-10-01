# Google Calendar MCP Setup Guide

## Prerequisites
✅ Node.js 18+ (you have v22.19.0)
✅ Claude Desktop installed
⏳ Google Cloud Project with OAuth credentials

## Step 1: Create Google Cloud OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google Calendar API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Calendar API"
   - Click "Enable"

4. Create OAuth 2.0 credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth client ID"
   - Choose "Desktop app" as application type
   - Name it "Claude Calendar MCP"
   - Download the JSON file
   - Save it as `gcp-oauth.keys.json` in a secure location (e.g., `~/.config/google/`)

## Step 2: Install Google Calendar MCP

```bash
# Create a directory for MCP servers
mkdir -p ~/.config/mcp-servers
cd ~/.config/mcp-servers

# Install the Google Calendar MCP package globally
npm install -g @cocal/google-calendar-mcp

# Or install locally in the MCP servers directory
npm init -y
npm install @cocal/google-calendar-mcp
```

## Step 3: Authenticate with Google

```bash
# Set the path to your OAuth credentials
export GOOGLE_OAUTH_CREDENTIALS="$HOME/.config/google/gcp-oauth.keys.json"

# Run authentication (this will open a browser)
npx @cocal/google-calendar-mcp auth

# This creates a token file at ~/.config/@cocal/google-calendar-mcp/token.json
```

## Step 4: Configure Claude Desktop

1. Find your Claude Desktop config file:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`

2. Add the MCP server configuration:

```json
{
  "mcpServers": {
    "google-calendar": {
      "command": "npx",
      "args": ["@cocal/google-calendar-mcp"],
      "env": {
        "GOOGLE_OAUTH_CREDENTIALS": "/Users/bkase/.config/google/gcp-oauth.keys.json"
      }
    }
  }
}
```

**Note:** Replace the path with your actual credentials file location.

## Step 5: Restart Claude Desktop

1. Completely quit Claude Desktop (not just close the window)
2. Restart Claude Desktop
3. The MCP server should connect automatically

## Step 6: Test the Connection

In Claude, try these commands:
- "What events do I have today?"
- "Show my calendar for this week"
- "Create a test event tomorrow at 2pm"

## Available MCP Functions

Once connected, these functions will be available:
- `mcp_google_calendar_create_event` - Create new events
- `mcp_google_calendar_quick_add_event` - Add events from natural language
- `mcp_google_calendar_find_events` - Search and list events
- `mcp_google_calendar_update_event` - Modify existing events
- `mcp_google_calendar_delete_event` - Remove events
- `mcp_google_calendar_get_freebusy` - Check availability
- `mcp_google_calendar_list_calendars` - Show all calendars
- `mcp_google_calendar_analyze_busyness` - Analyze schedule density

## Troubleshooting

### If MCP doesn't connect:
1. Check Claude Desktop logs: `~/Library/Logs/Claude/`
2. Verify credentials file path is absolute
3. Ensure token was created: `~/.config/@cocal/google-calendar-mcp/token.json`
4. Try running manually: `GOOGLE_OAUTH_CREDENTIALS=/path/to/creds npx @cocal/google-calendar-mcp`

### If authentication fails:
1. Token expires after 7 days in test mode
2. Re-run: `npx @cocal/google-calendar-mcp auth`
3. For production, publish your OAuth app in Google Cloud Console

### If calendar operations fail:
1. Check you have Calendar API enabled in Google Cloud
2. Verify the account has calendar access
3. Check for specific error messages in Claude's response