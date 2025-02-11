return {
  -- Configurações do null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        null_ls.builtins.formatting.golines.with({
          extra_args = { "--max-len=80" },
        }),
      })
    end,
  },

  -- Autocomando para formatação automática ao salvar
  {
    "nvim-lua/plenary.nvim", -- Certifique-se de que plenary está instalado
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
  },
}
