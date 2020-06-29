[
  import_deps: [:ecto],
  inputs: ["*.{ex,exs}", "{lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"],
  locals_without_parens: [defenum: 2]
]
