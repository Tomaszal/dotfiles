---
description: Moon task conventions.
applyTo: "**/moon.yaml,.moon/tasks/**/*.yaml"
---

- Name tasks with slash-separated segments for the managed domain or resource and the operation, as in `domain/operation`. Shared leading segments form a prefix; additional segments add nesting.
- Keep related tasks under the same prefix. Avoid extra nesting unless it groups existing tasks.
- Use plural names for collections and the same verb for the same operation.
- Include only segments that distinguish the task; project names already provide context.
- Describe only a task's general purpose, without implementation details. Omit the description when the task name already makes its purpose clear.
- Keep aggregate tasks scoped to their prefix; unprefixed aggregates in the root project should combine domain tasks across the repository.
- Keep file selection in tool configs rather than task command arguments.
- Separate tasks with blank lines, use multiline YAML lists, and use block scalars for strings when line breaks improve readability.
- Use cleanup dependencies for formatting after tasks that generate files.
- Make tasks that build or activate Nix configurations, including installer builds, depend on `repo:flake/generate` (`flake/generate` within the root project).
