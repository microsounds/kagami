# kagami — static microblog generator

This is a minimalist POSIX shell implementation of a static HTML templating engine.

# Usage
Upon invocation, `kagami` searches the current directory and/or all parent directories up to `/` for a `.kagami/` subdir, any directory containing said subdir will be considered the working directory.

`kagami` recursively goes through through the contents of `src/`, converts markdown documents in into HTML markup and concatenates them with a user-supplied header and footer markup to create a static website.

The directory structure within `src/` is also recreated in the working directory, feel free to use your directory structure as your sitemap.

`kagami` also supports a few command line options.

| option | what |
| -- | -- |
| `-h` | Displays help and version information. |
| `clean` | Recursively removes all `*.htm` files in the working directory, except for `.kagami/` |


# Configuration folder
* `.kagami/macros`
	* List of user-provided shell variables that are queried during macro search and replace.
		* This file is sourced by `kagami` so feel free to use POSIX shell syntax.
* `.kagami/header.htm`
	* HTML syntax that is prepended to every processed markdown document in `src/`
* `.kagami/footer.htm`
	* HTML syntax that is appended after every processed markdown document in `src/`

# Minimal configuration
`kagami` expects a `.kagami/` and a `src/` directory before doing anything, but won't complain if those directories are empty.
Aside from that, you're free to do whatever you want. A barebones template is provided so you can get started.

# Macros
Macro placeholders look like this: `{MACRO}` and can appear anywhere in your markup and are parsed and replaced in-place during the final step.
Global macros come in 2 flavors, the built-in variables, and the user-provided shell variables described in `.kagami/macros` which override built-ins.

Only the characters `A-Za-z0-9_` can be used as macro identifiers.

| built-in | description |
| -- | -- |
| `{DOC_ROOT}` | Document root prefix, set to working directory by default. |

There are also per-file specific macros which override user-provided macros and are generated shortly before the parse and replace step.

| built-in | description |
| -- | -- |
| `{PAGE_TITLE}` | Derived from the first `<h1>` heading on the page. |

When a macro is found, the brackets are removed, the resulting identifier is interpreted as a shell variable and it's contents replace the placeholder text in-place. If the variable is not set, the placeholder is simply removed.

# Background
This script replaced a previous generic site generator written in GNU make and GNU m4 macro processor that quickly ballooned in complexity.
m4 allows you to run inline shell commands similar to PHP but has no concept of escape characters and will happily eat any word that matches a built-in macro, like `divert` and `shift`.

# Installation
Run `make install` to install to `/usr/local` by default.

You can change install location with the `PREFIX` variable, eg.
`make install PREFIX=$HOME/.local`

# Dependencies
* [cmark-gfm](https://github.com/github/cmark-gfm) - for converting [Github Flavored](https://github.github.com/gfm/) Markdown to HTML
	* _Most GNU/Linux distros already package this._
* any POSIX-compliant shell

# Example
~~My personal site at https://microsounds.github.io/ is built with `kagami` from sources located [here](https://github.com/microsounds/microsounds.github.io).~~

# License
GPLv3
