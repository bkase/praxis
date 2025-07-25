# Aethel CLI Usage Guide for LLM Agents

This guide describes how to use the aethel CLI to manage documents, packs, and patches in an aethel vault.

## Core Concepts

- **Doc**: Markdown file with YAML front-matter, identified by UUID
- **Pack**: Directory containing type schemas and templates
- **Patch**: JSON object describing mutations to a Doc
- **Vault**: Directory containing `docs/` and `packs/` subdirectories

## Commands

### Initialize Vault
```bash
aethel init [PATH]
```
Creates a new vault with `docs/`, `packs/`, and `.aethel/` directories.

### Write Document
```bash
echo '{JSON_PATCH}' | aethel write --json - --output json
```

Patch JSON structure:
```json
{
  "uuid": null,          // null for create, existing UUID for update
  "type": "pack.type",   // e.g., "journal.morning"
  "frontmatter": {       // custom fields (not base fields)
    "key": "value"
  },
  "body": "Content",     // markdown body text
  "mode": "create"       // create|append|merge_frontmatter|replace_body
}
```

Base front-matter fields (auto-managed):
- `uuid`: Document identifier
- `type`: Document type (pack.local)
- `created`: Creation timestamp
- `updated`: Last update timestamp
- `v`: Schema version
- `tags`: Array of strings

Output:
```json
{
  "uuid": "generated-uuid",
  "path": "vault/docs/uuid.md",
  "committed": true,
  "warnings": []
}
```

### Read Document
```bash
# Read as markdown (default)
aethel read <UUID>

# Read as JSON
aethel read <UUID> --output json
```

### Check Document
```bash
aethel check <UUID> --output json
```

Validates document against its schema.

### List Packs
```bash
aethel list --output json
```

Output:
```json
[
  {
    "name": "journal",
    "version": "1.0.0",
    "protocolVersion": "0.1.0",
    "types": [
      {
        "id": "journal.morning",
        "version": "1.0.0"
      }
    ]
  }
]
```

### Add Pack
```bash
aethel add <PATH> --output json
```

Copies pack from `<PATH>` to `vault/packs/`. Path must contain `pack.json`.

### Remove Pack
```bash
aethel remove <PACK_NAME> --output json
```

## Error Handling

All errors follow protocol codes:
- 400xx: Bad request/malformed input
- 404xx: Not found
- 409xx: Conflict
- 422xx: Validation errors
- 500xx: System errors

Error JSON format:
```json
{
  "code": 42200,
  "message": "Schema validation failed",
  "data": {
    "pointer": "/frontmatter/field",
    "expected": "string",
    "got": "number"
  }
}
```

## Patch Modes

- **create**: Create new document (uuid must be null)
- **append**: Append to body, merge front-matter
- **merge_frontmatter**: Update only front-matter
- **replace_body**: Replace entire body, merge front-matter

## Pack Structure

```
packs/name@version/
├── pack.json
├── types/
│   └── type.schema.json
└── templates/
    └── type.md
```

## Usage Patterns

### Create Document
```bash
echo '{
  "uuid": null,
  "type": "journal.morning",
  "frontmatter": {"mood": "happy"},
  "body": "Today was good.",
  "mode": "create"
}' | aethel write --json - --output json
```

### Update Document
```bash
echo '{
  "uuid": "existing-uuid",
  "frontmatter": {"mood": "great"},
  "body": "\n\nMore content.",
  "mode": "append"
}' | aethel write --json - --output json
```

### Workflow Example
```bash
# Initialize vault
aethel init my-vault
cd my-vault

# Add a pack
aethel add ../packs/journal@1.0.0 --output json

# Create document
echo '{"uuid":null,"type":"journal.morning","frontmatter":{"mood":"good"},"body":"First entry.","mode":"create"}' | aethel write --json - --output json

# Read it back
aethel read <UUID> --output json

# Update it
echo '{"uuid":"<UUID>","body":"\n\nAdditional thoughts.","mode":"append"}' | aethel write --json - --output json
```

## Important Notes

- Always use `--output json` for machine parsing
- Vault root defaults to current directory or ancestor with `docs/` and `packs/`
- All writes are atomic (write to temp, rename)
- Document files are stored as `docs/<UUID>.md`
- Pack names must match `^[a-z0-9\-]+$`
- Type IDs are `packName.localType`