# kagami — static microblog processor
This is a minimalist POSIX shell implementation of a static HTML template
processor, designed for low-effort blogposting.

Kagami provides an extensible turing tarpit for dynamically generating
webpages from plaintext Markdown files through an easy to use templating
system and macro preprocessor.
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
corresponding source file. Indexes are always refreshed, regaredless of file
age.
If the `.kagami/` configuration has changed, all webpages will be regenerated.

### Error Handling
Kagami does very little error handling,
Missing configuration files will give error messages, but user error will not.

The `.kagami/` and `src/` directories can be empty and Kagami might warn
about it but won't stop you, you just won't get anything useful.

An example configuration is provided so you can get started.

# Metadata and Indexes
You can include inline metadata in your markdown files containing publishing
information, such as creation date or date of last modification.
A date timestamp takes the form `<!--label XXXX/XX/XX-->` where the date can be
any valid date string accepted by GNU date.

If a particular directory has an `index.md`, the resulting webpage will feature
a list of all other webpages in the same directory sorted by creation date
appended after your content.

Omitting date information lets you exclude files from this index.

# Macros
When a `{MACRO}` is found, the brackets are removed, the resulting identifier
is interpreted as a shell variable `$MACRO` and it's contents replace the
macro text in-place. If the variable is empty or unset, the macro is stripped
from the final webpage.

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
| `TITLE` | Taken from first `<h1>` heading on the page. | page filename |
| `CREATED` | Taken from first markdown comment in the form `<!--created xx/xx/xxxx-->` | N/A |
| `UPDATED` | Taken from second markdown comment in the form `<!--updated xx/xx/xxxx-->` | N/A |

# Installation
`make install` to drop the `kagami` executable in `/usr/local` by default.

You can change the install location with the `PREFIX` variable, eg. `make
install PREFIX=$HOME/.local`

# Dependencies
* POSIX shell
* GNU date
* [dc (desk calculator)](https://en.wikipedia.org/wiki/dc_(computer_program)) - for date conversion routines
* [cmark-gfm](https://github.com/github/cmark-gfm) - for converting github flavored markdown to html

# Example
~~My [personal site](https://microsounds.github.io) is built with Kagami from
sources located [here](https://github.com/microsounds/microsounds.github.io).~~

# License
GPLv3
