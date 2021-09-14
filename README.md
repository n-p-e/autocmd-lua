# autocmd-lua: A wrapper to define Neovim autocommands in lua

## Example

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
    }
  }}
}
```

