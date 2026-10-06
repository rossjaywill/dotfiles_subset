return {
    cmd = {
      "/usr/bin/clangd",
      -- "~/.nix-profile/bin/clangd",
      "-j=8",
      "--malloc-trim",
      "--background-index",
      "--background-index-priority=normal",
      "--pch-storage=memory",
      "--completion-style=detailed",
      "--offset-encoding=utf-16",
      "--header-insertion=never",
      "--enable-config",
      "--clang-tidy",
      "--log=error",
      "--pretty"
    },
    filetypes = {"c", "cpp", "objc", "objcpp"},
    root_markers = { "compile_commands.json", ".git", "CMakeLists.txt" },
    offset_encoding = "utf-16",
}
