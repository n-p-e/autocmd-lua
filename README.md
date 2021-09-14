## autocmd-lua: Define Neovim autocommands without pain

### Example

```lua
require('autocmd-lua').augroup {
  group = 'test_group',
  autocmds = {
    { event = 'FileType',    pattern = 'lua', cmd = function() vim.opt.sw = 2 end },
    { event = 'BufReadPost', pattern = '*',   cmd = 'echom "hello"'},
  },
}
-- OR
require('autocmd-lua').augroup {
  -- the keys `group` and `autocmds` are optional
  'filetype_commands',
  {{
    'FileType', {
      lua = function() do_something end,
      markdown = 'set sw=2',
      -- the key is passed as the pattern
      ['help,man'] = 'nmap q :q<CR>',
    }
  }}
}
```

### Planned features

- [ ] Support `<amatch>` in callback
