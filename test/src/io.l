# 26sep07abu
# (c) Software Lab. Alexander Burger

### path ###
(test (path '@) (pack (pwd) '/))
(test (char "+") (char (path "+@")))


### read ###
(test (1 abc (d e f))
   (pipe (prinl "(1 abc (d e f))")
      (read) ) )
(test '(abc = def_ghi "(" "xyz" + - 123 ")")
   (pipe (prinl "abc = def_ghi(\"xyz\"+-123) # Comment")
      (make
         (while (read "_" "#")
            (link @) ) ) ) )


### wait ###
(let (*Run NIL  *Cnt 0)
   (test (1 2 3 4 5 6 7)
      (make
         (task -10 0  (link (inc '*Cnt)))
         (wait NIL (>= *Cnt 7)) ) ) )


### peek char ###
(pipe (prin "ab")
   (test "a" (peek))
   (test "a" (char))
   (test "b" (peek))
   (test "b" (char))
   (test NIL (peek))
   (test NIL (char)) )
(test "A" (char 65))
(test 65 (char "A"))


### skip ###
(test "a"
   (pipe (prinl "# Comment^Ja")
      (skip "#") ) )
(test "#"
   (pipe (prinl "# Comment^Ja")
      (skip) ) )


### eof ###
(test T (pipe NIL (eof)))
(test NIL (pipe (prin "a") (eof)))
(test T (pipe (prin "a") (eof T) (eof)))


### from till ###
(test "cd"
   (pipe (prin "ab.cd:ef")
      (from ".")
      (till ":" T) ) )


### line ###
(test '("a" "b" "c")
   (pipe (prin "abc^J") (line)) )
(test "abc"
   (pipe (prin "abc") (line T)) )
(test '("abc" "def")
   (pipe (prin "abc^Jdef")
      (list (line T) (line T)) ) )
(test '("abc" "def")
   (pipe (prin "abc^Mdef")
      (list (line T) (line T)) ) )
(test '("abc" "def")
   (pipe (prin "abc^M^Jdef")
      (list (line T) (line T)) ) )
(test '("a" "bc" "def")
   (pipe (prin "abcdef")
      (line T 1 2 3) ) )


### lines ###
(out (tmp "lines")
   (do 3 (prinl "abc")) )

(test 3 (lines (tmp "lines")))


### any ###
(test '(a b c d) (any "(a b # Comment^Jc d)"))
(test "A String" (any "\"A String\""))


### sym ###
(test "(abc \"Hello\" 123)"
   (sym '(abc "Hello" 123)) )


### str ###
(test '(a (1 2) b)
   (str "a (1 2) b") )
(test "a \"Hello\" DEF"
   (str '(a "Hello" DEF)) )


### load ###
(test 6 (load "-* 1 2 3"))


### in out ###
(out (tmp "file")
   (println 123)
   (println 'abc)
   (println '(d e f)) )
(in (tmp "file")
   (test 123 (read))
   (test 'abc (read))
   (test '(d e f) (read)) )


### pipe ###
(test 123 (pipe (println 123) (read)))


### open close ###
(let F (open (tmp "file"))
   (test 123 (in F (read)))
   (test 'abc (in F (read)))
   (test '(d e f) (in F (read)))
   (test F (close F)) )


### echo ###
(out (tmp "echo")
   (in (tmp "file")
      (echo) ) )
(in (tmp "echo")
   (test 123 (read))
   (test 'abc (read))
   (test '(d e f) (read)) )


### prin prinl space print printsp println ###
(out (tmp "prin")
   (prin 1)
   (prinl 2)
   (space)
   (print 3)
   (printsp 4)
   (println 5) )
(test (12 "^J" " " 34 5)
   (in (tmp "prin")
      (list (read) (char) (char) (read) (read)) ) )


### flush rewind ###
(out (tmp "prin")
   (prinl "abc")
   (flush)
   (test "abc" (in (tmp "prin") (line T)))
   (rewind) )
(out (tmp "prin") (prinl "def"))
(test "def" (in (tmp "prin") (line T)))


### rd pr ###
(pipe
   (for (N 1 (>= 4096 N) (inc N))
      (pr N) )
   (for (N 1 (>= 4096 N) (inc N))
      (test N (rd)) ) )
(pipe
   (for (C 1 (>= 4096 C) (inc C))
      (pr (char C)) )
   (for (C 1 (>= 4096 C) (inc C))
      (test C (char (rd))) ) )
(pipe
   (pr (7 "abc" (1 2 3) 'a))
   (test (7 "abc" (1 2 3) 'a) (rd)) )
(test "def"
   (out (tmp "pr")
      (pr 'abc "EOF" 123 "def") ) )
(test '(abc "EOF" 123 "def")
   (in (tmp "pr")
      (make
         (use X
            (until (== "EOF" (setq X (rd "EOF")))
               (link X) ) ) ) ) )


### wr ###
(test 3
   (out (tmp "wr")
      (wr 1 2 3) ) )
(test (hex "010203")
   (in (tmp "wr")
      (rd 3) ) )


### rpc ###
(test *Pid
   (pipe (rpc '*Pid) (run (rd))) )


### id ###
(test *DB (id 1 1))
(test 1 (id *DB))
(test (1 . 1) (id *DB T))


### lieu ###
(rollback)
(test NIL (lieu *DB))
(test *DB (val *DB) (lieu *DB))


### begin commit rollback ###
(let (X (new T)  Y (new T))
   (set X 1  Y 2)
   (commit)
   (test 1 (val X))
   (test 2 (val Y))
   (set X 111)
   (begin)
   (set Y 222)
   (commit T)
   (test 111 (val X))
   (test 222 (val Y))
   (rollback)
   (test 1 (val X))
   (test 222 (val Y)) )


### mark ###
(test NIL (mark *DB))
(test NIL (mark *DB T))
(test T (mark *DB))
(test T (mark *DB 0))
(test NIL (mark *DB))


### dbck ###
(test NIL (dbck))

# vi:et:ts=3:sw=3