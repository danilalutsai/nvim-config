; Overrides nvim-treesitter's bundled queries/comment/highlights.scm.
;
; There is deliberately no `; extends` modeline here: without it this file
; REPLACES the bundled query instead of adding to it. That is the whole point —
; the bundled patterns are `(tag (name) @capture)` with no colon requirement,
; because the comment grammar has the colon as optional.
;
; Every pattern below names the anonymous ":" node as a required child, so a
; bare `WARN` in prose stays plain and only `WARN:` lights up.
;
; The comment parser is injected into every language's comments, so this
; applies everywhere: ts, lua, css, the lot.

((tag (name) @comment.todo ":")
  (#any-of? @comment.todo "TODO" "WIP"))

((tag (name) @comment.note ":")
  (#any-of? @comment.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST"))

((tag (name) @comment.warning ":")
  (#any-of? @comment.warning "HACK" "WARNING" "WARN" "FIX"))

((tag (name) @comment.error ":")
  (#any-of? @comment.error "FIXME" "BUG" "ERROR"))

; The `(danila)` in `TODO(danila):` and a bare `#123` issue reference.
; Both also gated on the colon so they cannot fire on their own.
((tag (user) @constant.comment ":"))
