return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    event = 'InsertEnter',
    config = function()
      local null_ls = require("null-ls")
      -- if you want to set up formatting on save, you can use this as a callback
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      
      local lsp_formatting = function(bufnr)
          vim.lsp.buf.format({
              filter = function(client)
                  -- apply whatever logic you want (in this example, we'll only use null-ls)
                  return client.name == "null-ls"
              end,
              bufnr = bufnr,
          })
      end
      
      -- add to your shared on_attach callback
      local on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
              vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup,
                  buffer = bufnr,
                  callback = function()
                      lsp_formatting(bufnr)
                  end,
              })
          end
      end
      
      null_ls.setup({
        on_attach = on_attach,
        sources = {
          null_ls.builtins.formatting.prettier.with({
            only_local = "node_modules/.bin",
            extra_filetypes = { "svelte" }
          })
        }
      })
             
    end,
  },
}