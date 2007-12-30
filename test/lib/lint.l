# 13oct07abu
# (c) Software Lab. Alexander Burger

### noLint ###
(let foo '(() (bar FreeVariable))
   (use *NoLint
      (noLint 'bar)
      (noLint 'foo 'FreeVariable)
      (test NIL (lint 'foo)) ) )

### lint ###
(let foo '((R S T) (let N 7 (bar X Y)))
    (test '((var T) (def bar) (bnd Y X) (use N))
       (lint 'foo) ) )

(let foo '(() (task -6000 0 X 7 (println N)))
   (test '((bnd N) (use X))
       (lint 'foo) ) )

# vi:et:ts=3:sw=3