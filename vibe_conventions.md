# Vibe Conventions for Headless Mode

## General Guidelines

When running in headless mode, Vibe must:
1. **Complete the task fully** - Address all requirements and feedback
2. **Test thoroughly** - Ensure no regressions and all edge cases covered
3. **Follow best practices** - Clean code, proper structure, documentation
4. **Be idempotent** - Safe to run multiple times

## Issue Implementation

**Prompt format:**
```
Implement the feature for issue #{number}: {title}. Description: {body}.
Make sure the implementation is complete and addresses all requirements.
Test thoroughly and ensure no regressions.
```

**Expected behavior:**
- Analyze the issue description completely
- Break down requirements
- Implement feature with proper tests
- Verify all requirements met
- No partial implementations

## PR Feedback Handling

**Prompt format:**
```
Address PR feedback for PR #{number}: {title}. Comments: {comments}.
Make sure all feedback is addressed completely.
Test thoroughly and ensure no regressions.
```

**Expected behavior:**
- Read all comments carefully
- Address each point systematically
- Make necessary code changes
- Add tests for new scenarios
- Verify all feedback resolved
- No outstanding issues

## Technical Requirements

- **Code quality:** Follow project coding standards
- **Testing:** Unit tests, integration tests, edge cases
- **Documentation:** Update docs if needed
- **Backwards compatibility:** Don't break existing functionality
- **Error handling:** Graceful degradation when possible

## Headless Mode Specifics

When `--agent auto-approve` is used:
- All tool actions are automatically approved
- No interactive prompts
- Complete automation expected
- Must handle errors gracefully
- Should exit cleanly when done
