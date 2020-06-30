# kagami — static microblog processor
This is a minimalist POSIX shell implementation of a static HTML template
processor, meant for low-effort blogposting.

Kagami provides a ~~"basic and extensible framework"~~ turing tarpit
for generating static webpages from plaintext Markdown files using a templating
system and a macro preprocessor that are extremely simple to use.
---------

### Templating System

There are only 2 user-extensible templates, `head.htm` and `tail.htm`, which go
before and after all your generated webpages, respectively.

### Macro Preprocessor
Kagami also provides a user-extensible macro preprocessor, using inline syntax
that can appear anywhere in your templates or plaintext Markdown.

```html
<!-- .kagami/head.htm -->
<link rel="stylesheet" type="text/css" href="{DOC_ROOT}/res/style.css">
```
```shell
# .kagami/macros
DOC_ROOT='/var/www'
```
Macros take the form `{MACRO_NAME}` and correspond to an existing shell
environment variable, or one you define yourself using the optional `macros`
file that is sourced at runtime. They are evaluated and replaced from the final
webpage.


# Usage
| command line option | effect |
| :-- | :-- |
| `-h` | Displays help and version information. |
| `clean` | Recursively removes all `*.htm` files in the working directory, excluding files located in `.kagami/` |

Invoking Kagami searches the current directory and all parent directories above
it for an existing `.kagami/` configuration and a `src/` directory. If found,
this becomes the _**working directory**_, all operations are relative to this
directory.

Kagami will then recurse through the `src/` directory and convert every
plaintext `*.md` Markdown file into a corresponding `*.htm` file outside of
`src/`, preserving the same directory structure.

Subsequent invocations will only refresh webpages that are older than their
corresponding source file.
If the `.kagami/` configuration has changed, all webpages will be regenerated.

An example configuration is provided so you can get started.

### Error Handling
Kagami does very little in the way of error handling, and will not try to
prevent most forms of user error.

The `.kagami/` and `src/` directories can be empty and Kagami might warn
about it but won't stop you, you just won't get anything useful.

# Macros
When a `{MACRO}` is found, the brackets are removed, the resulting identifier is
interpreted as a shell variable `$MACRO` and it's contents replace the macro text
in-place. If the variable is empty or unset, the macro is stripped from the
final webpage.

Only the characters `A-Za-z0-9_` can be used as macro identifiers.

### Global Macros
These are generated at startup and do not change during runtime.

User-provided shell variables sourced from `.kagami/macros` can extend, override
or unset these at will.

| built-in | description |
| :-- | :-- |
| `VERSION` | Processor name and version information. |
| `DOC_ROOT` | Document root prefix, set to working directory by default. |

### Local Macros
These are uniquely generated from every processed file at runtime and override global and
user-provided shell variables.

| built-in | description | fallback |
| :-- | :-- | :-- |
| `PAGE_TITLE` | Taken from first `<h1>` heading on the page. | page filename |

# Installation
`make install` to drop the `kagami` executable in `/usr/local` by default.

You can change the install location with the `PREFIX` variable, eg. `make
install PREFIX=$HOME/.local`

# Dependencies
* [cmark-gfm](https://github.com/github/cmark-gfm) - for converting [Github Flavored](https://github.github.com/gfm) Markdown to HTML
	* _Packaged by most GNU/Linux distros._
* any POSIX-compliant shell

# Example
~~My [personal site](https://microsounds.github.io) is built with Kagami from
sources located [here](https://github.com/microsounds/microsounds.github.io).~~

# License
GPLv3
