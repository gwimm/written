(module line {require {core aniseed.core
                       util util}
              require-macros [macros]})

(def lines {})

(defn render [name]
  "Iterates through `sections` building statusline string"
  (util.intercalate
    "%="
    (icollect [section-index section (ipairs (. lines name))]
      (util.concat
        (icollect [component-index component (ipairs section)]
          (let [{:provider provider
                 :highlight highlight
                 :condition condition} component]

            (defn render-highlight []
              (when (core.string? highlight)
                (.. "%#" highlight "#")))

            (defn render-component []
              (.. (aif (render-highlight) it "")
                  (match (type provider)
                    :string provider
                    :function (.. "%{luaeval('require(\"line\").draw')"
                                  "(\"" name "\", " section-index
                                  ", " component-index ")}"))
                  "%#Normal#"))

            (if (and provider (aif condition (it) true))
              (render-component))))))))

(defn draw [name section-index component-index]
  "Provider call trampoline"
  (let [{:provider provider
         :highlight highlight} (core.get-in lines [name section-index component-index])
        (ok widget) (safe-call provider)
        group (when (core.string? highlight) highlight)]
    (.. " " ; notice the obligatory `(.. " " x)` vim is stupid
        (if ok
          (match (type widget)
            :string widget
            :table (let [{:text text :color color} widget]
                     (aif color (util.color.add-group (if (core.string? highlight) highlight group) it))
                     text))
          (do (util.color.add-group group (util.color.get-group :ErrorMsg))
              (.. " " widget " "))))))
