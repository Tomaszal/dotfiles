---
description: Moon task conventions.
applyTo: "**/moon.yaml,.moon/tasks/**/*.yaml"
---

- Name tasks according to their actual behavior and scope, without implying work they do not perform.
- Group related tasks under consistent prefixes chosen for discoverability and responsibility.
- Do not infer task ownership from its implementation tool or the task that invokes it.
- Keep aggregate names and contents aligned; a broad name requires correspondingly broad coverage.
- Use plural names for collections and the same verb for the same operation.
- Include only segments that distinguish the task; project names already provide context.
- Describe only a task's general purpose, without implementation details. Omit the description when the task name already makes its purpose clear.
- Express execution requirements through dependency relationships. Preserve parallelism between independent tasks.
- When naming feedback leaves the intended convention unclear, agree on alternatives before making further edits.
- Keep file selection in tool configs rather than task command arguments.
- Separate tasks with blank lines, use multiline YAML lists, and use block scalars for strings when line breaks improve readability.
- Use cleanup dependencies for formatting after tasks that generate files.
- Make tasks that build or activate Nix configurations, including installer builds, depend on `repo:flake/generate` (`flake/generate` within the root project).
