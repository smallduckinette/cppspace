# Vibe GitHub Issue & MR Automation Design

## High-Level Design

This system automates GitHub issue and MR workflow management using Vibe's headless mode. The goal is to streamline feature implementation and code review feedback handling.

### Workflow Overview

```
GitHub Issues → Filter (no MR) → Read Description → Create Branch → Vibe Headless Session → Push MR
                                                                                     ↓
GitHub Issues with MRs → Check for New Comments → Analyze Feedback → Update Code → Push MR Update
```

## Core Components

### 1. Issue Processing Pipeline

**Input**: GitHub issues without associated MRs
**Processing**: 
- Parse issue description
- Extract requirements
- Create feature branch
- Launch Vibe headless session with context
- Implement feature
- Push code and create MR

**Output**: New MR linked to issue

### 2. MR Feedback Handling Pipeline

**Input**: GitHub issues with existing MRs
**Processing**:
- Check for comments since last push
- Analyze feedback and code review comments
- Update implementation
- Push changes to MR
- Post response to comments

**Output**: Updated MR with addressed feedback

## Technical Approach

### Script Architecture

The bash script will:
1. Use GitHub CLI (`gh`) for issue/MR operations
2. Parse issue descriptions and comments
3. Create branches and manage git workflow
4. Launch Vibe headless sessions with appropriate context
5. Monitor and update MRs based on feedback

### Vibe Integration

- **Headless Mode**: Vibe runs without interactive prompts
- **Context Injection**: Issue descriptions and comments fed as context
- **Automation**: Script waits for Vibe session completion

### Git Workflow

- Branch naming: `issue-{number}-{slug}`
- Commit messages: Include issue reference
- MR titles: Based on issue title
- Regular pushes to keep MRs updated

## Implementation Details

### Required Tools

- `gh` (GitHub CLI)
- `git`
- `vibe` CLI
- `jq` for JSON parsing

### Script Features

1. **Issue Discovery**: Filter issues by state and MR presence
2. **Context Extraction**: Parse issue descriptions and comments
3. **Branch Management**: Create, checkout, and manage branches
4. **Vibe Orchestration**: Launch and monitor headless sessions
5. **MR Management**: Create, update, and comment on MRs
6. **Feedback Processing**: Analyze and incorporate code review comments

## Design Considerations

### Error Handling

- Retry failed operations
- Log all actions for audit trail
- Handle API rate limits
- Validate Vibe session outputs

### Safety Mechanisms

- Dry-run mode for testing
- Confirmation prompts for destructive actions
- Branch cleanup after MR merges
- Backup of important changes

### Extensibility

- Configurable via environment variables
- Modular design for easy extension
- Support for custom issue templates
- Plugin system for additional processors

## Future Enhancements

1. **Priority Handling**: Process issues based on priority labels
2. **Assignee Filtering**: Only process issues assigned to specific users
3. **CI Integration**: Trigger builds after MR updates
4. **Analytics**: Track processing metrics and success rates
5. **Multi-repo Support**: Handle issues across multiple repositories

## Usage

```bash
./vibe-github-automation.sh [--dry-run] [--issue <number>]
```

### Options

- `--dry-run`: Simulate actions without making changes
- `--issue <number>`: Process specific issue
- `--repo <owner/repo>`: Target specific repository
- `--label <label>`: Filter by label

## Example Workflow

1. Script discovers issue #42: "Add dark mode support"
2. Creates branch `issue-42-add-dark-mode`
3. Launches Vibe with context: "Implement dark mode feature based on issue #42"
4. Vibe implements the feature and exits
5. Script pushes code and creates MR
6. Later, reviewer comments on MR
7. Script detects new comments, updates code, pushes changes
8. Posts response to reviewer comments
