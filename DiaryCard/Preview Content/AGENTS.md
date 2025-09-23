# Assistant Preferences

## Communication
- Be concise and clear by default. Prefer short, direct answers.
- Use markdown headings and code fences for readability.
- Avoid tables. Use bullet lists instead.
- Include small, concrete Swift examples when helpful.
- After edits, include a brief “Changes made” summary.

## Editing Policy
- Make small, focused edits that compile.
- Ask before large refactors or multi-file rewrites.
- Prefer minimal diffs and avoid churn; follow existing project patterns.
- Create new files when it improves clarity; name them descriptively and let me know.

## Swift & Platforms
- Language: Swift
- UI: SwiftUI preferred
- Concurrency: async/await preferred
- iOS minimum: 18.0 (SwiftData usage)
- macOS: not targeted unless specified
- Swift/Xcode: follow the latest supported by the current Xcode (v26).

## Code Style
- Prefer `#Preview` for SwiftUI previews.
- Keep functions small and focused; prefer pure helpers when practical.
- Favor value semantics and immutability where reasonable.
- Try to follow my code style.

## Dependencies
- Do not add third-party packages without explicit approval.

## Testing
- Use the Swift Testing framework for new non-trivial logic.
- Keep tests fast, deterministic, and focused on behavior.

## Performance & Safety
- Treat warnings as issues; resolve them proactively and briefly explain if unrelated to main task. 
- Add availability guards for APIs not available on all targets.
- Avoid unnecessary work on the main thread.

## Workflow & Ambiguity
- Summarize the rationale for non-trivial changes before changing.
- When requirements are ambiguous, ask brief clarifying questions before editing.
