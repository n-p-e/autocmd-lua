local M = {}

M.remove_ws = function(str)
  return string.gsub(str, '%s', '')
end

return M
