# 14sep06abu
# (c) Software Lab. Alexander Burger

### Concurrent DB Garbage Collector ###
# *DbgcDly *DbgcPid

(default *DbgcDly 128)

(if (fork)
   (setq *DbgcPid @)

   (undef 'upd)
   (de upd Lst
      (wipe Lst)
      (let *DbgcDly (>> 1 *DbgcDly)
         (for S Lst
            (mark S T)
            (markData (val S))
            (maps markData S)
            (wipe S) ) ) )

   (de markExt (S)
      (unless (mark S T)
         (wait *DbgcDly)
         (markData (val S))
         (maps markData S)
         (wipe S) ) )

   (de markData (X)
      (while (pair X)
         (markData (pop 'X)) )
      (and (ext? X) (markExt X)) )

   (loop
      (markExt *DB)
      (let Cnt 0
         (for (F . @) (or *Dbs (2))
            (for (S (seq F)  S  (seq S))
               (wait *DbgcDly)
               (unless (mark S)
                  (dbSync)
                  (if (mark S)
                     (rollback)
                     (and (isa '+Entity S) (zap> S))
                     (zap S)
                     (commit 'upd)
                     (inc 'Cnt) ) ) ) )
         (when *Blob
            (use (@S @R F S)
               (let Pat (conc (chop *Blob) '(@S "." @R))
                  (in (list 'find *Blob "-type" "f")
                     (while (setq F (line))
                        (wait *DbgcDly)
                        (when (match Pat F)
                           (unless
                              (and
                                 (setq S (extern (pack (replace @S '/))))
                                 (get S (intern (pack @R))) )
                              (inc 'Cnt)
                              (call 'rm (pack F)) )
                           (wipe S) ) ) ) ) ) )
         (msg Cnt " conDbgc") )
      (mark 0) ) )

# vim:syntax=picolisp:ts=3:sw=3:expandtab