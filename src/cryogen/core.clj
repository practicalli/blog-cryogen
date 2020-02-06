(ns cryogen.core
  (:require [cryogen-core.compiler :refer [compile-assets-timed]]
            [cryogen-core.plugins :refer [load-plugins]]))

(defn -main [config-file]
  (load-plugins)
  (compile-assets-timed (read-string (slurp config-file)))
  (System/exit 0))
