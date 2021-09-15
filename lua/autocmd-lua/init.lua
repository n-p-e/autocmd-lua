local M = {}

M._events = {}

M.augroup = function(args)
  args = args or {}

  local group = args.group or args[1]
  local autocmds = args.autocmds or args[2]
  -- group name should only contain non-whitespace characters
  vim.validate {
    group = { group, function(a) return type(a) == 'string' and string.match(a, '%s') == nil end, 'valid augroup name' },
  }
  if table.maxn(autocmds) == 0 then
    vim.api.nvim_notify('Warning: autocmds should be a list', 3, {})
  end

  local commands = {} -- array of commands (vimL string or lua function)
  local definition = { string.format('augroup %s', group), '  au!' }
  -- Used to identify each lua function
  -- The generated definition looks like:
  --   au <Event> <Pattern> lua _autocmd_lua._execute_group('<group_name>', <number>)
  local num = 1

  local register_cmd = function(event, pattern, cmd)
    vim.validate {
      event = { event, function(a) return type(a) == 'string' and string.match(a, '%s') == nil end, 'valid event name' },
      pattern = { pattern, 'string' },
      cmd = {
        cmd,
        function(a) return type(a) == 'string' or type(a) == 'function' end,
        'lua function or vimscript string',
      },
    }

    commands[num] = cmd
    table.insert(
      definition, string.format([[  au %s %s lua _autocmd_lua._execute_group('%s', %d)]], event, pattern, group, num)
    )
    num = num + 1
  end

  for _, au in ipairs(autocmds) do
    local event = au.event or au[1]
    local pattern_or_commands = au.pattern or au[2] or ''
    local cmd = au.cmd or au[3]

    if type(pattern_or_commands) == 'string' then
      register_cmd(event, pattern_or_commands, cmd)
    elseif type(pattern_or_commands) == 'table' then
      for pattern, pattern_cmd in pairs(pattern_or_commands) do
        register_cmd(event, pattern, pattern_cmd)
      end
    else
      error('Expect a string for pattern or table<pattern, command>')
    end

  end

  M._events[group] = commands

  table.insert(definition, 'augroup END')
  definition = table.concat(definition, '\n')

  vim.cmd(definition)
end

M.create_group = M.augroup

M._execute_group = function(group, num)
  local autocmds = M._events[group]
  if autocmds == nil then
    error(string.format('autocmd-lua: Group %s does not exist', group))
  end
  local cmd = autocmds[num]
  if cmd == nil then
    error(string.format('autocmd-lua: Unknown command in group %s (number %d)', group, num))
  end

  if type(cmd) == 'function' then
    local ok, error_msg = pcall(cmd)
    if not ok then
      error(string.format('autocmd-lua: Error in autocmd group %s, msg: %s', group, error_msg))
    end
  else
    vim.cmd(cmd)
  end
end

_G._autocmd_lua = M

return M
