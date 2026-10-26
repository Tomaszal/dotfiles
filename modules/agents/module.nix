{den, ...}: {
  den.aspects.dev.agents.includes = with den.aspects.dev.agents; [
    claude-code
    codex
    opencode
  ];
}
