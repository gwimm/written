{:packer-use
 (fn [...]
   (let [core (require "aniseed.core")
         args [...]
         use-statements []]
     (for [i 1 (core.count args) 2]
       (let [name (. args i)
             block (. args (+ i 1))]
         (core.assoc block 1 name)
         (when (. block :mod)
           (core.assoc block :config `#(require ,(. block :mod))))
         (core.assoc block :mod nil)
         (table.insert use-statements block)))

     (let [use-sym (gensym)]
       `(let [packer# (require "packer")]
          (packer#.startup
            (fn [,use-sym]
              ,(unpack
                (icollect [_# v# (ipairs use-statements)]
                 `(,use-sym ,v#)))))))))
 :safe-call
 (fn [f]
   `(let [core# (require "aniseed.core")
          fennel# (require "aniseed.fennel")]
     (xpcall ,f #(core#.println (fennel#.traceback $1)))))

 :dbg
 (fn [x] `(do (print (.. `,(tostring x) " => " (vim.inspect ,x))) ,x))

 :aif
 (fn [test-form then-form else-form]
   `(let [,(sym :it) ,test-form]
      (if it ,then-form ,else-form)))}

