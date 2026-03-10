-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

---@module 'lazy'
---@type LazySpec
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Show inline values
    'theHamsta/nvim-dap-virtual-text',

    -- Creates a beautiful dap UI
    'igorlfs/nvim-dap-view',
    -- Disassembly view for dap UI
    'Jorenar/nvim-dap-disasm',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'SGauvin/ctest-telescope.nvim',
  },
  -- keys = {
  --   -- Basic debugging keymaps, feel free to change to your liking!
  --   { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
  --   { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
  --   { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
  --   { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
  --   { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
  --   { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
  -- },
  keys = {
    -- Basic debugging keymaps
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },

    -- Dap-View Keybindings
    { '<leader>dt', function() require('dap-view').toggle() end, desc = 'Dap-View: Toggle UI' },
    { '<leader>dT', function() require('dap-view').toggle(true) end, desc = 'Dap-View: Force close UI' },
    { '<leader>do', function() require('dap-view').open() end, desc = 'Dap-View: Open UI' },
    { '<leader>dq', function() require('dap-view').close() end, desc = 'Dap-View: Close UI' },
    { '<leader>dQ', function() require('dap-view').close(true) end, desc = 'Dap-View: Close UI & hide terminal' },
    { '<leader>dw', function() require('dap-view').add_expr() end, desc = 'Dap-View: Add watch' },
    { '<leader>dw', function() require('dap-view').add_expr() end, mode = 'v', desc = 'Dap-View: Add watch (selection)' },
    {
      '<leader>dW',
      function()
        local expr = vim.fn.input 'Watch expression: '
        if expr and expr ~= '' then require('dap-view').add_expr(expr) end
      end,
      desc = 'Dap-View: Add watch (input)',
    },

    -- Jump to specific views
    { '<leader>djr', function() require('dap-view').jump_to_view 'repl' end, desc = 'Dap-View: Jump to REPL' },
    { '<leader>djs', function() require('dap-view').jump_to_view 'scopes' end, desc = 'Dap-View: Jump to Scopes' },
    { '<leader>djS', function() require('dap-view').jump_to_view 'stack' end, desc = 'Dap-View: Jump to Stack' },
    { '<leader>djb', function() require('dap-view').jump_to_view 'breakpoints' end, desc = 'Dap-View: Jump to Breakpoints' },
    { '<leader>djw', function() require('dap-view').jump_to_view 'watches' end, desc = 'Dap-View: Jump to Watches' },
    { '<leader>dje', function() require('dap-view').jump_to_view 'exceptions' end, desc = 'Dap-View: Jump to Exceptions' },
    { '<leader>djt', function() require('dap-view').jump_to_view 'threads' end, desc = 'Dap-View: Jump to Threads' },
    { '<leader>djc', function() require('dap-view').jump_to_view 'console' end, desc = 'Dap-View: Jump to Console' },

    -- Navigate between views
    { '<leader>d[', function() require('dap-view').navigate { count = -1, wrap = true } end, desc = 'Dap-View: Previous view' },
    { '<leader>d]', function() require('dap-view').navigate { count = 1, wrap = true } end, desc = 'Dap-View: Next view' },

    -- Navigate between sessions
    { '<leader>dn', function() require('dap-view').navigate { count = 1, wrap = true, type = 'sessions' } end, desc = 'Dap-View: Next session' },
    { '<leader>dN', function() require('dap-view').navigate { count = -1, wrap = true, type = 'sessions' } end, desc = 'Dap-View: Previous session' },
  },
  config = function()
    -- local dap = require 'dap'

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
        'codelldb',
      },
    }

    -- vim.keymap.set("n", "<F5>", function()
    --   if dap.session() == nil and (vim.bo.filetype == "cpp" or vim.bo.filetype == "c") then
    --     -- Only call this on C++ and C files
    --     require("ctest-telescope").pick_test_and_debug()
    --   else
    --     dap.continue()
    --   end
    -- end, { desc = "Debug: Start/Continue" })

    require('dap-view').setup {
      winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl', 'disassembly', 'sessions', 'console' },
        -- Must be one of the sections declared above
        default_section = 'watches',
        -- Append hints with keymaps within the labels
        show_keymap_hints = true,
        -- Configure each section individually
        base_sections = {
          -- Labels can be set dynamically with functions
          -- Each function receives the window's width and the current section as arguments
          watches = { label = ' ', keymap = 'W' }, -- Watches
          scopes = { label = ' ', keymap = 'S' }, -- Scopes
          exceptions = { label = ' ', keymap = 'E' }, -- Exceptions
          breakpoints = { label = ' ', keymap = 'B' }, -- Breakpoints
          threads = { label = ' ', keymap = 'T' }, -- Threads
          repl = { label = ' ', keymap = 'R' }, -- REPL
          sessions = { label = ' ', keymap = 'K' }, -- Sessions
          console = { label = ' ', keymap = 'C' }, -- Console
        },
        -- Add your own sections
        custom_sections = {},
        controls = {
          enabled = true,
          position = 'right',
          buttons = {
            'play',
            'step_into',
            'step_over',
            'step_out',
            'step_back',
            'run_last',
            'terminate',
            'disconnect',
          },
          custom_buttons = {},
        },
      },
      windows = {
        size = 0.25,
        position = 'below',
        terminal = {
          size = 0.5,
          position = 'left',
          -- List of debug adapters for which the terminal should be ALWAYS hidden
          -- Use the actual names for the adapters you want to hide
          hide = {
            'delve', -- `delve` is known to not use the terminal.
          },
        },
        anchor = function()
          -- Anchor to the first terminal window found in the current tab
          -- Tweak according to your needs
          local windows = vim.api.nvim_tabpage_list_wins(0)

          for _, win in ipairs(windows) do
            local bufnr = vim.api.nvim_win_get_buf(win)
            if vim.bo[bufnr].buftype == 'terminal' then return win end
          end
        end,
      },
      icons = {
        collapsed = '󰅂 ',
        disabled = '',
        disconnect = '',
        enabled = '',
        expanded = '󰅀 ',
        filter = '󰈲',
        negate = ' ',
        pause = '',
        play = '',
        run_last = '',
        step_back = '',
        step_into = '',
        step_out = '',
        step_over = '',
        terminate = '',
      },
      help = {
        border = nil,
      },
      render = {
        -- Optionally a function that takes two `dap.Variable`'s as arguments
        -- and is forwarded to a `table.sort` when rendering variables in the scopes view
        sort_variables = nil,
        -- Full control of how frames are rendered, see the "Custom Formatting" page
        threads = {
          -- Choose which items to display and how
          format = function(name, lnum, path)
            return {
              { part = name, separator = ' ' },
              { part = path, hl = 'FileName', separator = ':' },
              { part = lnum, hl = 'LineNumber' },
            }
          end,
          -- Align columns
          align = false,
        },
        -- Full control of how breakpoints are rendered, see the "Custom Formatting" page
        breakpoints = {
          -- Choose which items to display and how
          format = function(line, lnum, path)
            return {
              { part = path, hl = 'FileName' },
              { part = lnum, hl = 'LineNumber' },
              { part = line, hl = true },
            }
          end,
          -- Align columns
          align = false,
        },
      },
      -- Controls how to jump when selecting a breakpoint or navigating the stack
      -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
      -- Only a subset of the options is available: newtab, useopen, usetab and uselast
      -- Can also be a function that takes the current winnr and the destination bufnr
      -- If a function, should return the winnr of the destination window
      switchbuf = 'usetab,uselast',
      -- Auto open when a session is started and auto close when all sessions finish
      -- Alternatively, can be a string:
      -- - "keep_terminal": as above, but keeps the terminal when the session finishes
      -- - "open_term": open the terminal when starting a new session, nothing else
      auto_toggle = false,
      -- Reopen dapview when switching to a different tab
      -- Can also be a function to dynamically choose when to follow, by returning a boolean
      -- If a function, receives the name of the adapter for the current session as an argument
      follow_tab = false,
    }

    require('dap-disasm').setup {
      -- Add disassembly view to nvim-dap-view
      dapview_register = true,

      -- If registered, pass section configuration to nvim-dap-view
      dapview = {
        keymap = 'D',
        label = '󰒓 ', -- Disassembly
      },

      -- The sign to use for instruction the exectution is stopped at
      sign = 'DapStopped',

      -- Number of instructions to show before the memory reference
      ins_before_memref = 16,

      -- Number of instructions to show after the memory reference
      ins_after_memref = 16,

      -- Columns to display in the disassembly view
      columns = {
        'address',
        'instructionBytes',
        'instruction',
      },
    }

    require('nvim-dap-virtual-text').setup {
      enabled = true, -- enable this plugin (the default)
      enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true, -- show stop reason when stopped for exceptions
      commented = false, -- prefix virtual text with comment string
      only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
      all_references = false, -- show virtual text on all all references of the variable (not only definitions)
      clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
      --- A callback that determines how a variable is displayed or whether it should be omitted
      --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
      --- @param buf number
      --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
      --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
      --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
      --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
      display_callback = function(variable, buf, stackframe, node, options)
        -- by default, strip out new line characters
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value:gsub('%s+', ' ')
        else
          return variable.name .. ' = ' .. variable.value:gsub('%s+', ' ')
        end
      end,
      -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
      virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

      -- experimental features:
      all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
      -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Note: if you are using Lazy.nvim, pass these
    -- arguments to `opts` instead of manually calling `setup`
    require('ctest-telescope').setup {
      -- Path to the ctest executable
      ctest_path = 'ctest',

      -- Extra arguments to pass to ctest
      -- For example, to add '-C Debug', you should set this variable to {"-C", "Debug"}
      extra_ctest_args = {},

      -- Folder where your compiled executables will be found
      build_folder = 'build',

      -- Configuration you would pass to require("dap").configurations.cpp
      dap_config = {
        type = 'codelldb',
        request = 'launch',
        stopAtEntry = true,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'Enable pretty printing',
            ignoreFailures = false,
          },
        },
      },
    }
  end,
}
