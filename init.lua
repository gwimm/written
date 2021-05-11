
local fn = vim.fn
local pack_path = fn.stdpath("data") .. "/site/pack"

function ensure(user, repo)
  local install_path = string.format("%s/packer/start/%s", pack_path, repo, repo)
  local exec = vim.api.nvim_command

  if fn.empty(fn.glob(install_path)) > 0 then
    exec(string.format("!git clone https://github.com/%s/%s %s", user, repo, install_path))
  end
  exec(string.format("packadd %s", repo))
end

ensure("webthomason", "packer.nvim")
ensure("Olical", "aniseed")

vim.g["aniseed#env"] = { compile = true }
