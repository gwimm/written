(module lsp
  {require {ani aniseed.core
            fnl aniseed.fennel
            lsp lspconfig}})

; ------------------------------------------------------------------------------

(defn on_attach [client bufnr]
  ; (pkg lsp_signature.nvim [lsp_signature (require "lsp_signature")]
  ;   (lsp_signature.on_attach)

  (if client.resolved_capabilities.document_highlight
    (do
      ; (utils.highlight "LspReferenceRead"  {:gui "underline"})
      ; (utils.highlight "LspReferenceText"  {:gui "underline"})
      ; (utils.highlight "LspReferenceWrite" {:gui "underline"})
      (vim.api.nvim_exec
         "augroup lsp_document_highlight
           autocmd! * <buffer> 
           autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight() 
           autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
         augroup END"
        false))))

(defn better_root_pattern [patterns except-patterns]
  "match path if one of the given patterns is matched,
   EXCEPT if one of the except-patterns is matched"
  (fn [path] 
    (when (not ((lsp.util.root_pattern except-patterns) path))
      ((lsp.util.root_pattern patterns) path))))

(defn init-lsp [name ?opts]
  "initialize a language server with defaults"
  (let [merged-opts (ani.merge {:on_attach on_attach} (or ?opts {}))]
    ((. lsp name :setup) merged-opts)))

; (let [capabilities (vim.lsp.protocol.make_client_capabilities)]
;   (set capabilities.textDocument.completion.completionItem.snippetSupport true)
;   (set capabilities.textDocument.completion.completionItem.resolveSupport
;         { :properties ["documentation" "detail" "additionalTextEdits"]})
;   (init-lsp :rust_analyzer { :capabilities capabilities})) 
