return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            staticcheck = true,
            analyses = {
              ST1000 = false
            }
          }
        }
      }
    }
  }
}
