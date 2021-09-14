local r = require('helper').remove_ws

describe('autocmd-lua', function()
  before_each(function()
    vim.cmd [[
      augroup test_augroup
        au!
      augroup END
    ]]
  end)

  it('defines an autocmd group', function()
    require('autocmd-lua').augroup {
      'test_augroup',
      autocmds = {
        { event = 'FileType',    pattern = 'lua', cmd = function() vim.opt.sw = 2 end },
        { event = 'BufReadPost', pattern = '*',   cmd = 'echom "hello"'},
      },
    }
    local response = vim.api.nvim_exec([[au test_augroup]], true)
    response = vim.split(response, '\n')

    assert.equals(5, #response)
    assert.equals('test_augroup  BufReadPost', response[2])
    assert.equals(
      "    *         lua _autocmd_lua._execute_group('test_augroup', 2)",
      response[3]
    )

    assert.equals('test_augroup  FileType', response[4])
    assert.equals(
      "    lua       lua _autocmd_lua._execute_group('test_augroup', 1)",
      response[5]
    )

  end)

  it('defines an autocmd group with alternative style', function ()
    require('autocmd-lua').augroup {
      group = 'test_augroup',
      autocmds = {{
        'FileType', {
          lua = function() print('inside lua file') end,
          markdown = 'set sw=2',
        }
      }}
    }
    local response = vim.api.nvim_exec([[au test_augroup]], true)

    assert.has.match(r [[%s+ markdown %s+ lua %s+ _autocmd_lua._execute_group %( ]], response)
    assert.has.match(r [[%s+ lua      %s+ lua %s+ _autocmd_lua._execute_group %( ]], response)

  end)

end)
