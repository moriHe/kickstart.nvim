-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
-- TODO: Dependencies for java tests and debugging are ensure_installed in init.lua
-- However, it might be useful to mention them here too. Since it is tightly coupled.

-- TODO: See if tests work or what needs to be setup for it.
-- And secondary, debug junit tests https://github.com/mfussenegger/nvim-jdtls

-- TODO: Maybe setup more keymaps for debugging.
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<leader>dt', dapui.toggle, desc = '[T]oggle UI' },
      { '<leader>ds', dap.continue, desc = '[S]tart' },
      { '<leader>di', dap.step_into, desc = 'Step [I]nto' },
      { '<leader>dl', dap.step_over, desc = '[L]eap Over' },
      { '<leader>do', dap.step_out, desc = 'Step [O]ut' },
      { '<leader>db', dap.toggle_breakpoint, desc = '[B]reakpoint Toggle' },
      {
        '<leader>dB',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Set [B]reakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<leader>dr', dapui.toggle, desc = 'Last Session [R]esult' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Launch Application',
        mainClass = 'com.example.Main',
        classPaths = { 'target/classes', 'target/dependency/*' },
      },
      {
        type = 'java',
        request = 'attach',
        name = 'Debug (Attach)',
        hostName = '127.0.0.1',
        port = 5005,
      },
    }
    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup()

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
