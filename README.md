## autocmd-lua: Define Neovim autocommands without pain

### Install

```
use 'jakelinnzy/autocmd-lua'
```

### Example

```lua
require('autocmd-lua').augroup {
  group = 'test_group',
  autocmds = {
    { event = 'FileType', pattern = 'lua', cmd = function() vim.opt.sw = 2 end },
    -- the keys above are optional
    { 'BufReadPost', '*', 'echom "hello"'},
  },
}
-- OR
require('autocmd-lua').augroup {
  -- the keys `group` and `autocmds` are also optional
  'filetype_commands',
  {{
    'FileType', {
      lua = function() do_something end,
      markdown = 'set sw=2',
      -- these keys are passed as the pattern
      ['help,man'] = 'nmap q :q<CR>',
    }
  }}
}
```

### Features

- Pass a lua function or a vimL string (which is passed to `vim.cmd`)
- Does `au!` for you so no duplicate commands
- Alternative syntax to define multiple commands for an event
- No dependencies

### Planned

- [ ] Support `<amatch>` in callback
