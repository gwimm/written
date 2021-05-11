(module buffertabs
  {require {core aniseed.core}})

(local state {:state "state"})

(defn valid-buffer? [buf-number]
  (if (or (not buf-number) (< buf-number 1))
    false
    (and (vim.api.nvim_buf_is_valid buf-number) (core.get-in vim.bo [buf-number :buflisted]))))

(defn get-buffers []
  (core.filter valid-buffer? (vim.api.nvim_list_bufs)))

(defn buffertabs []
  (let [buf_nums (get-buffers)]
    "string"))

(set vim.o.showtabline 2)
; (set vim.o.tabline "%!v:luaeval('require(\"buffertabs\").bufferline')()")
(set vim.o.tabline "%#StatusLineMode#%{luaeval('require(\"buffertabs\").buffertabs')()}%=rhs")
; (set vim.o.tabline "%#StatusLineMode#%{lua.bufferline()}")

; (get-buffers)
; 
; (vim.fn.winbufnr 0)
; (vim.api.nvim_list_bufs)
; (vim.api.nvim_buf_get_lines 17 0 -1 false)
; (valid-buffer? 1)
