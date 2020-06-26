# kagami — static microblog generator

This is a minimalist POSIX shell implementation of a static HTML templating engine.

# Usage
Upon invocation, `kagami` searches the current directory and/or all parent directories up to `/` for a `.kagami` subdir, any directory containing said subdir will be considered the working directory.

`kagami` recurses through the contents of `src/`, converts markdown documents in into HTML markup and concatenates them with user-supplied header/footer markup to create a free-form static website.

# Minimal configuration
Your site can be as free-form as you'd like but the following directory structure is mandatory.

```
$working_dir
 |
 |   # configuration folder [mandatory]
 +-- .kagami/
 |     |-- macros        # tab-delimited list of search and replace macros
 |     |-- header.htm    # HTML markup to be prepended to each file in src/
 |     +-- footer.htm    # HTML markup to be appended after each file in src/
 |
 |   # directory containing markdown documents [mandatory]
 +-- src/
      |-- index.md
      |-- example.md
      +-- subdir/        # directory structure can be of arbitrary depth
           |-- index.md  # you can consider this your sitemap
           +-- example/  # it will be recreated outside of the src/ directory
           (...)
```

# Motivation
This script replaced a previous site generator written in GNU make and GNU m4 macro processor. m4 has no concept of escape characters and will happily eat any word that matches a built-in macro, like `divert` and `shift`.

# Dependencies
* [cmark-gfm](https://github.com/github/cmark-gfm) - [Github Flavored](https://github.github.com/gfm/) Markdown to HTML conversion
	* _Most GNU/Linux distros already package this._
* any POSIX-compliant shell

# Example
My personal site at https://microsounds.github.io/ is built with `kagami` from sources located [here](https://github.com/microsounds/microsounds.github.io).

# License
GPLv3
