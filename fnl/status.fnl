(module status
  {require {line line}
   require-macros [macros]})

(def async
  (vim.loop.new_async
    (vim.schedule_wrap
      #(set vim.wo.statusline (line.render :status)))))

(def events ["ColorScheme" "FileType" "BufWinEnter" "BufReadPost" "BufWritePost"
             "BufEnter" "WinEnter" "FileChangedShellPost" "VimResized" "TermOpen"])

(defn load_line [] (async:send))

(defn augroup []
  (let [cmd vim.api.nvim_command]
    (cmd "augroup galaxyline")
    (cmd "autocmd!")
    (each [_ event (ipairs events)]
      (cmd (.. "autocmd " event " * lua require(\"status\").load_line()")))
    ; (cmd "autocmd WinLeave * lua require(\"status\").unload_line()")
    ; TODO ?
    (cmd "augroup END")))

(augroup)
