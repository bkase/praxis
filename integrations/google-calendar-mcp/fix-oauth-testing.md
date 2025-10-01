# Fix Google OAuth Testing Mode Error

## The Issue
The OAuth app is in "Testing" mode and you're not listed as an approved tester.

## Solution 1: Add Yourself as a Test User (Recommended)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** → **OAuth consent screen**
4. Look for the **Test users** section
5. Click **+ ADD USERS**
6. Add your email address (the Gmail account you want to use)
7. Click **SAVE**

Now try authenticating again:
```bash
cd ~/.config/mcp-servers
export GOOGLE_OAUTH_CREDENTIALS="$HOME/.config/google/gcp-oauth.keys.json"
npx @cocal/google-calendar-mcp auth
```

## Solution 2: Create Your Own OAuth App

If the above doesn't work, you need to create your own OAuth credentials:

### Step 1: Create New Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click the project dropdown (top bar)
3. Click **New Project**
4. Name it "Claude Calendar MCP"
5. Click **Create**

### Step 2: Enable Calendar API
1. Go to **APIs & Services** → **Library**
2. Search for "Google Calendar API"
3. Click on it and press **Enable**

### Step 3: Configure OAuth Consent Screen
1. Go to **APIs & Services** → **OAuth consent screen**
2. Choose **External** user type
3. Click **Create**
4. Fill in required fields:
   - App name: "Claude Calendar MCP"
   - User support email: your email
   - Developer contact: your email
5. Click **Save and Continue**
6. Skip scopes (click **Save and Continue**)
7. Add your email as a test user
8. Click **Save and Continue**

### Step 4: Create OAuth Credentials
1. Go to **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
3. Application type: **Desktop app**
4. Name: "Claude Calendar MCP"
5. Click **Create**
6. Download the JSON file
7. Save it as `~/.config/google/gcp-oauth.keys.json`

### Step 5: Re-authenticate
```bash
cd ~/.config/mcp-servers
export GOOGLE_OAUTH_CREDENTIALS="$HOME/.config/google/gcp-oauth.keys.json"
npx @cocal/google-calendar-mcp auth
```

## Solution 3: Use Personal Account

Make sure you're:
1. Using a personal Google account (not workspace)
2. Logged into the correct Google account in your browser
3. The same account that created the OAuth credentials

## Testing Mode Limitations

While in testing mode:
- Token expires every 7 days
- Limited to 100 test users
- No verification required

This is fine for personal use!

## To Move to Production (Optional)

Only needed if sharing with others:
1. Go to **OAuth consent screen**
2. Click **PUBLISH APP**
3. Google will review (can take weeks)
4. Not necessary for personal use