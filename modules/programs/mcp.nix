{lib, ...}: {
  den.default.homeManager = {
    options.programs.mcp.wrapperHooks = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Shell commands run by MCP client wrappers before launching the client";
    };
  };
}
