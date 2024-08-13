return {
  -- Plugin per LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Gestore per LSP, DAP, linters, e formatters
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      -- Autocompletamento
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    config = function()
      local lsp_servers = require('config.lsp_servers')
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = lsp_servers.servers,
      })
      
      local lspconfig = require("lspconfig")
      for _, server in ipairs(lsp_servers.servers) do
	      local config = lsp_servers.server_settings[server] or {}
		  lspconfig[server].setup(config)
	  end

      -- Configurazione autocompletamento
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
  -- Aggiungi altri plugin se necessario
}
