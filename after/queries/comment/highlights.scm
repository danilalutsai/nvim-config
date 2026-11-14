; Registered in lua/plugins/treesitter.lua instead of the installed query.
; The installed query also captures bare TODO-style words as text.
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
