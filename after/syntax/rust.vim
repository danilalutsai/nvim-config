" Keep brackets inside strings separate from the surrounding string color.
syntax match rustStringBracket /[{}()[\]]/ contained containedin=rustString
highlight default link rustStringBracket Delimiter
