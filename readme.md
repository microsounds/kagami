<img src="static/kagami.png" width="270px" align="right" alt="kagami">

# kagami — static microblog processor
This is a minimalist POSIX shell implementation of a static HTML template
processor, designed for low-frequency Web 1.0-esque blogposting.

**kagami** provides an extensible [turing tarpit](#background) for dynamically
generating webpages from plaintext Markdown files through an easy to use
templating system and macro preprocessor.

---------

### Templating System
There are only 2 user-extensible templates, `head.htm` and `tail.htm`, which go
before and after all your generated webpages, respectively.

### Macro Preprocessor
**kagami** also provides a user-extensible macro preprocessor, using inline syntax
that can appear anywhere in your templates or plaintext Markdown.

```html
<!-- .kagami/head.htm -->
<link rel="stylesheet" type="text/css" href="{DOC_ROOT}/res/style.css">
```
```html
<!-- .kagami/tail.htm -->
<span class="footnote">{FOOTNOTE}</span>
```
Macros take the form `{MACRO_NAME}` and correspond to an existing shell
environment variable, or one you define yourself using the optional `macros`
file that is sourced at runtime. They are evaluated and replaced from the final
webpage.
```shell
# .kagami/macros
DOC_ROOT='/var/www'
FOOTNOTE="(c) $(date '+%Y') <your name> -- All Rights Reserved."
```

# Usage
| command line option | effect |
| :-- | :-- |
| `clean` | Recursively deletes all output files that would have been created under normal operation. |
| `-h`, `--help` | Displays help information. |
| `-v`, `--version` | Displays version information. |

Invoking **kagami** searches the current directory and all parent directories above
it for an existing `.kagami/` configuration and a `.src/` directory. If found,
this becomes the _**working directory**_, all operations are relative to this
directory.

**kagami** will then recurse through the `.src/` directory and convert every
plaintext `*.md` Markdown file into a corresponding `*.htm` file outside of
`.src/`, preserving the same directory structure.

Subsequent invocations will only refresh webpages that are older than their
corresponding source file. Indexes are always refreshed, regaredless of file
age.
If any files within the `.kagami/` config directory have changed, all webpages
will be regenerated.

### Error Handling
**kagami** does very little error handling,
Missing configuration files will give error messages, but user error will not.

The `.kagami/` and `.src/` directories can be empty and **kagami** might warn
about it but won't stop you, you just won't get anything useful.

# Dynamic Indexes and Linking
Markdown files can contain metadata tags, such as creation date or time of
last modification, which take the form `<!--label XXXX/XX/XX-->` where the
date string can be any valid human readable date understood by GNU date.

If a particular directory has an `index.md`, the resulting webpage will feature
a dynamic list of all other webpages in the same directory sorted by creation
date appended after your content.

Omitting date information lets you exclude files from this index.

You can also manually link to other pages arbitrarily.
```html
[link]({DOC_ROOT}/path/to/file.md)
<a href="{DOC_ROOT}/path/to/file.md">...</a>
```
If you link to another `*.md` document, it will be converted to an `*.htm` link.

# Macros
When a `{MACRO}` is found, the brackets are removed, the resulting identifier
is interpreted as a shell variable `$MACRO` and it's contents replace the
macro text in-place. If the variable is empty or unset, the macro is stripped
from the final webpage.

Only the characters `A-Za-z0-9_` can be used as macro identifiers.

### Global Macros
These are generated and exported at startup and do not change during runtime.

User-provided shell variables and scripts `.` (dot) sourced from `.kagami/macros` can extend, override
or unset these at will.
Subshelled scripts will have read-only access only.

| built-in | description |
| :-- | :-- |
| `VERSION` | Processor name and version information. |
| `DOC_ROOT` | Document root prefix, set to working directory by default. |
| `DATE_FUNCTION` | Define a custom date function that takes a unix timestamp and outputs a human-readable date to stdout. A plain date function is set by default. |

### Local Macros
These are uniquely generated from every processed file at runtime and override global and
user-provided shell variables.

| built-in | description | fallback |
| :-- | :-- | :-- |
| `TITLE` | Taken from first `<h1>` heading on the page. | page filename |
| `CREATED` | Taken from first markdown comment in the form `<!--created xx/xx/xxxx-->` | N/A |
| `UPDATED` | Taken from second markdown comment in the form `<!--updated xx/xx/xxxx-->` | N/A |

# Installation
**kagami** is a single shell script, you can keep it with your webpages at
the document root, or you can install it to your path by running `make install`.

The default install location is `/usr/local`, you can change this with
`make install PREFIX=$HOME/.local`

An example template and configuration is provided so you can get started.
You can run `./kagami` in this directory to build a sample website.

# Requirements
* Any POSIX-compatible shell
* GNU date — Part of GNU coreutils, required for date conversion routines.
* [cmark](https://github.com/commonmark/cmark) — CommonMark Markdown to HTML converter
* [cmark-gfm](https://github.com/github/cmark-gfm) *(optional)* — cmark with GitHub Extensions
	* **kagami** will fall back to standard cmark if not available.
* pandoc *(optional)* — If installed, will generate a man file from this document during installation.

# Background
>**kagami** (かがみ) is weeb for *mirror* (鏡)

**kagami** was written to fit a particular use case, mine.
If your needs are simple, then **kagami** is simple.
This isn't a full-fat wordpress-style blog generator.
Management of static elements such as images, client-side Javascript,
stylesheets and site structure are left as an exercise to the user.

# Example
My [personal site](https://microsounds.github.io) is generated using **kagami** from
the **kagami** template located [here](https://github.com/microsounds/microsounds.github.io).

# License
GNU General Public License version 3 or later.
