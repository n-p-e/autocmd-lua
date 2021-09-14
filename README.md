## autocmd-lua: Define Neovim autocommands without pain

### Example

```lua
require('autocmd-lua').create_group {
  group = 'test_group',
  autocmds = {
    { event = 'FileType',    pattern = 'lua', cmd = function() vim.opt.sw = 2 end },
    { event = 'BufReadPost', pattern = '*',   cmd = 'echom "hello"'},
  },
}
-- OR
require('autocmd-lua').create_group {
  group = 'filetype_commands',
  autocmds = {{
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
