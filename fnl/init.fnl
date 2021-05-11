(module init
  {require {core aniseed.core
            fennel aniseed.fennel
            nvim aniseed.nvim
            lsp lspconfig
            util util
            line line}})

(require "plugins")
(def color (require "color"))
(def status (require "status"))

(defn table-apply [fs xs]
  (core.merge xs
    (collect [k f (pairs fs)]
      (values k (f (. xs k))))))

(def scheme color.scheme.gruvbox)

(def modes
  {:n   {:text "NORMAL"       :color scheme.gray}
   :i   {:text "INSERT"       :color scheme.bright_green}
   :c   {:text "CMD"          :color scheme.bright_red}
   :ce  {:text "NORMEX"       :color scheme.bright_red}
   :cv  {:text "EX"           :color scheme.bright_red}
   :ic  {:text "INSCOMP"      :color scheme.bright_red}
   :no  {:text "OP-PENDING"   :color scheme.bright_red}
   :r   {:text "HIT-ENTER"    :color scheme.bright_red}
   :r?  {:text "CONFIRM"      :color scheme.bright_red}
   :R   {:text "REPLACE"      :color scheme.bright_red}
   :Rv  {:text "VIRTUAL"      :color scheme.bright_red}
   :s   {:text "SELECT"       :color scheme.bright_red}
   :S   {:text "SELECT"       :color scheme.bright_red}
   :t   {:text "TERM"         :color scheme.bright_red}
   :v   {:text "VISUAL"       :color scheme.bright_purple}
   :V   {:text "VISUAL LINE"  :color scheme.bright_purple}
   "" {:text "VISUAL BLOCK" :color scheme.bright_purple}})

(def mode-table {})
(each [k v (pairs modes)]
  (tset mode-table k (table-apply {:text #(.. " " $1 " ") :color #{:bg $1}} v)))

(util.color.add-groups
  {:StatusLineMode {:fg scheme.dark0_hard :style [:bold]}
   :StatusLineBufName (util.color.get-group :Normal)})

(set line.lines.status
  [[{:provider #(. mode-table (nvim.fn.mode)) :highlight :StatusLineMode}
    {:provider #(.. " " (vim.fn.bufname) " ") :highlight :StatusLineBufName}]
   [{:provider #(let [[line column] (vim.api.nvim_win_get_cursor 0)]
                  {:text (.. " " (math.ceil
                                   (* 100 (/ line (vim.fn.line "$")))) "%"
                             " "  line " : " (+ 1 column) " ")
                   :color (table-apply {:fg #(if (<= 80 column)
                                               scheme.neutral_red $1)}
                                       (util.color.get-group :StatusLineMode))})
     :highlight :StatusLinePosition}]])

(set vim.o.showmode false)
(set vim.g.nvim_tree_auto_open 1)
(set vim.g.nvim_tree_side "left")
(set vim.g.nvim_tree_width 30)
(set vim.g.nvim_tree_lsp_diagnostics 1)

(vim.cmd "let mapleader=\"\\<Space>\"")
(vim.cmd "let maplocalleader=\",\"")
(vim.cmd "set list listchars=trail:-") ; ,eol:↵

(nvim.set_keymap :n :<C-p> "<cmd>Telescope find_files<cr>" {:noremap true})

(set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")
