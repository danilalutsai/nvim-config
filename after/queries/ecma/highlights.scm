; extends

; Shared by JavaScript, TypeScript, and TSX (including Vue script blocks).
([
  (this)
  (super)
] @variable.milka_red
  (#set! priority 150))

((identifier) @variable.milka_red
  (#any-of? @variable.milka_red "document" "window")
  (#set! priority 150))

; Color error names without capturing their arguments or surrounding code.
((identifier) @type.milka_error
  (#any-of? @type.milka_error
    "Error" "AggregateError" "EvalError" "InternalError" "RangeError"
    "ReferenceError" "SyntaxError" "TypeError" "URIError")
  (#set! priority 150))

((identifier) @variable.milka_console
  (#eq? @variable.milka_console "console")
  (#set! priority 150))

; Special numeric constants stay red while numeric literals are purple.
((identifier) @constant.builtin
  (#any-of? @constant.builtin "NaN" "Infinity")
  (#set! priority 150))
