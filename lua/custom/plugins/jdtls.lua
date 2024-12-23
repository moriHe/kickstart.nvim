return {
  'mfussenegger/nvim-jdtls',
  dependencies = { 'folke/which-key.nvim' },
  ft = { 'java' }, -- Only for java files
  config = function()
    local mason_registry = require 'mason-registry'

    -- Get the Lombok jar file path
    local lombok_jar = mason_registry.get_package('jdtls'):get_install_path() .. '/lombok.jar'

    local function get_root_dir(fname)
      -- You can modify this to fit your preferred root dir detection for Java projects
      return require('lspconfig.util').root_pattern('pom.xml', 'build.gradle', '.git')(fname)
    end

    local function project_name(root_dir)
      return root_dir and vim.fs.basename(root_dir)
    end

    local function jdtls_config_dir(config_project_name)
      return vim.fn.stdpath 'cache' .. '/jdtls/' .. config_project_name .. '/config'
    end

    local function jdtls_workspace_dir(workspace_project_name)
      return vim.fn.stdpath 'cache' .. '/jdtls/' .. workspace_project_name .. '/workspace'
    end

    local function full_cmd(opts)
      local fname = vim.api.nvim_buf_get_name(0)
      local root_dir = opts.root_dir(fname)
      local curr_project_name = opts.project_name(root_dir)
      local cmd = { vim.fn.exepath 'jdtls', string.format('--jvm-arg=-javaagent:%s', lombok_jar) }
      if curr_project_name then
        table.insert(cmd, '-configuration')
        table.insert(cmd, opts.jdtls_config_dir(project_name))
        table.insert(cmd, '-data')
        table.insert(cmd, opts.jdtls_workspace_dir(project_name))
      end
      return cmd
    end

    -- Attach the language server on Java files
    local function attach_jdtls()
      local fname = vim.api.nvim_buf_get_name(0)
      -- Install java-debug and store path to .jar in ~/.env JAVA_DEBUG_PLUGIN
      -- Or see initialitation path of .env in init.lua
      -- For reference: See https://github.com/mfussenegger/nvim-jdtls section "java-debug-installation"
      local java_debug_path = vim.fn.getenv 'JAVA_DEBUG_PLUGIN'

      local isDebuggerSetup = true
      if not java_debug_path or type(java_debug_path) ~= 'string' or java_debug_path == '' then
        isDebuggerSetup = false
        vim.notify(
          'WARN: JAVA_DEBUG_PLUGIN environment variable is not set or invalid! You can ignore this warning if you dont need the debugger',
          vim.log.levels.WARN
        )
      end

      local java_debug_glob = isDebuggerSetup and vim.fn.glob(java_debug_path, 1) or nil
      local bundles = java_debug_glob and { java_debug_glob } or {}

      local config = {
        cmd = full_cmd {
          root_dir = get_root_dir,
          project_name = project_name,
          jdtls_config_dir = jdtls_config_dir,
          jdtls_workspace_dir = jdtls_workspace_dir,
        },
        root_dir = get_root_dir(fname),
        init_options = {
          bundles = bundles,
        },
        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = 'all',
              },
            },
          },
        },
      }

      -- Start or attach the Java LSP server
      require('jdtls').start_or_attach(config)
    end

    -- Auto-attach jdtls to java buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'java' },
      callback = attach_jdtls,
    })

    -- Setup keymaps and dap after attaching
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'jdtls' then
          local wk = require 'which-key'
          wk.add {
            {
              mode = 'n',
              buffer = args.buf,
              { '<leader>ev', require('jdtls').extract_variable_all, desc = '[V]ariable' },
              { '<leader>ec', require('jdtls').extract_constant, desc = '[C]onstant' },
              { '<leader>gs', require('jdtls').super_implementation, desc = '[S]uper' },
              { '<leader>gS', require('jdtls.tests').goto_subjects, desc = '[S]ubjects' },
              { '<leader>co', require('jdtls').organize_imports, desc = '[O]rganize Imports' },
            },
          }
          wk.add {
            {
              mode = 'v',
              buffer = args.buf,
              {
                '<leader>em',
                [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                desc = '[M]ethod',
              },
              {
                '<leader>ec',
                [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                desc = '[C]onstant',
              },
            },
          }
        end
      end,
    })

    -- Trigger the first attachment (since auto-command doesn't fire initially)
    -- INFO: I commented out the line below because the code runs twice right now. If it causes any issues, uncomment attach_jdtls()
    --    attach_jdtls()
  end,
}
