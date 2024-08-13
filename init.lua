require("config.lazy")

vim.o.wrap = false

-- 1
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    -- 2
    vim.api.nvim_create_autocmd("BufWritePre", {
      -- 3
      buffer = args.buf,
      callback = function()
        -- 4 + 5
        vim.lsp.buf.format({ async = false, id = args.data.client_id })
      end,
    })
  end,
})

local format_on_save = function()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.lua",
    callback = function()
      vim.cmd([[silent! %!stylua -]])
    end,
  })
end

-- Attiva la formattazione automatica con Stylua
format_on_save()
