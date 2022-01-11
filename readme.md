<!-- github specific -->
![ver] ![gpl]

[ver]: https://img.shields.io/badge/version-idk%20lol-%2363B0B0?logo=github
[gpl]: https://img.shields.io/badge/license-GPLv3+-%23997ECE

# kagami — static microblog processor

<img src="static/kagami.png" width="270px" align="right" alt="kagami">
<!----✂---cut-here----->

This is a minimalist static HTML template processor and macro preprocessor
written in POSIX shell, designed for low-frequency, low-effort Web 1.0-esque
blogposting.

**kagami** provides an extensible [turing tarpit](#background) for dynamically
authoring webpages from plaintext Markdown files through an easy to use
templating system and macro preprocessor.

Unlike other static site authoring tools,
**kagami** [stays out of your way](#error-handling) and doesn't enforce
any particular site layout or demand more information from the user
through mandatory environment variables or YAML-style frontmatter blocks
at the top of all your documents, it's the _easy-going_ static microblog processor!

---------

### Templating System
There are only 2 user-extensible templates, `head.htm` and `tail.htm`, which go
before and after all your generated webpages, respectively.

### Macro Preprocessor
**kagami** also provides a user-extensible macro preprocessor, using inline
syntax that can appear anywhere in your templates or plaintext Markdown.

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
authored webpage.
```shell
## .kagami/macros
DOC_ROOT='/var/www'
FOOTNOTE="&copy; $(date '+%Y') <your name> -- All Rights Reserved."
```
From this point forward, the term "Markdown" will refer to **kagami**'s special
superset of Markdown which includes inline `{MACROS}` and use of inline HTML.

# Usage
| command line option | effect |
| :--- | :--------- |
| `clean` | Recursively deletes all output files that would have been created under normal operation. |
| `-h`, `--help` | Displays help information. |
| `-v`, `--version` | Displays version information. |

## An example working directory
```
/ (document root)
├── .kagami/
│   ├── head.htm
│   ├── tail.htm
│   └── macros
└── .src/
    ├── index.md
    ├── about.md
    ├── projects.md
    └── blog/
        ├── index.md
        ├── 5-cute-facts-about-kagami.md
        └── 10-mindbending-kagami-techniques.md
```

Invoking **kagami** searches the current directory and all parent directories
above it for an existing `.kagami/` template and a `.src/` directory. If found,
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
Because **kagami** doesn't get in your way, very little error handling is done,
if at all. You can make use of as many or as few `.kagami/` template features
as you want, **kagami** will simply warn you of missing functionality.

The `.kagami/` and `.src/` directories can even be empty and **kagami** might warn
about it but won't stop you, you won't get anything useful though.

# Dynamic Indexes and Link Rewriting
Markdown files can contain metadata tags, such as creation date or time of last
modification, which take the permissive form `<!-- word XXXX/XX/XX -->` where
the date string `XXXX/XX/XX` can be [any valid human readable date][gdate]
understood by GNU `date`. _Spaces between `<!--` and `-->` are optional._

[gdate]: https://www.gnu.org/software/coreutils/manual/html_node/Date-input-formats.html

If a particular directory has an `index.md`, the resulting webpage will feature
a dynamic list of all other webpages in the same directory sorted by creation
date appended after your content.

_**Omitting date information lets you exclude files from this index.**_

You can also manually link to other pages arbitrarily.
```html
[link]({DOC_ROOT}/path/to/file.md)
<a href="{DOC_ROOT}/path/to/file.md">...</a>
```
If you link to another `*.md` document, it will be automatically converted to
an `*.htm` link.

>_To suppress this behavior in finished webpages, you can mention or link to
> literal `.md` documents using the `&period;` HTML entity code._

# Dynamic RSS 2.0 Feed Generation
A dynamically updated RSS 2.0 feed `rss.xml` will be generated along with your
authored web pages at the root of the working directory if the optional macro
`SITE_HOSTNAME` is defined at runtime.

_**Items omitted from indexing will also be excluded from appearing in the RSS feed.**_

`SITE_TITLE` and `SITE_DESCRIPTION` are used in the RSS `<title>` and
`<description>` metadata fields and are optional but recommended.
Do note that they are _"required"_ by the [RSS 2.0 spec][rss].

[rss]: https://cyber.harvard.edu/rss/rss.html#requiredChannelElements

* `SITE_HOSTNAME` describes a URL prefix such as your domain name in the form `https://sub.domain.name`
* Any prefix of arbitrary directory depth, eg. `https://domain.name/sub/dir/1/2/3/4` is considered valid.
	* _This is required to generate valid URLs for the RSS feed._

# Embedded Table of Contents and Anchor Links
When writing structured content, you can embed a dynamically generated table of
contents with navigable anchor links anywhere in your markdown using local
macro `{TOC}`.

Given the following markdown structure, matching inline anchor links
will be appended to every heading in your markdown automatically.

	# hello world           <span id="hello-world"></span>
	## middle               <span id="middle"></span>
	### lesser point        <span id="lesser-point"></span>
	# second major topic    <span id="second-major-topic"></span>

```html
<!-- {TOC} macro will expand to the following -->
<div class="toc">
* [hello world](#hello-world)
    * [middle](#middle)
        * [lesser point](#lesser-point)
* [second major topic](#second-major-topic)
</div>
```

# Macros
When a `{MACRO}` is found in processed markdown, the brackets are removed, the resulting identifier
is interpreted as a shell variable `$MACRO` and it's contents replace the macro
text in-place. If the variable is empty or unset, the macro is stripped from
the final webpage.

The term _macros_ as used by this documentation can be used interchangeably with
_environment variables_ and _shell variables_ as they are one and the same as
far as **kagami** is concerned.

Only the characters `A-Za-z0-9_` can be used as macro identifiers.

Expanded `{MACROS}` cannot contain `\n` newlines, they will be stripped by the
preprocessor. This is a limitation of `sed`, use inline HTML in macro
expansions such as `<br/>` if you need line breaks.

### Global Macros
These are generated and exported at startup and do not change during runtime.

User-provided shell variables and shell scripts `.` (dot) sourced from
`.kagami/macros` can extend, override or unset these at will.
Subshelled scripts _(including those written in languages other than shell)_ will have read-only access only.

| built-in | description |
| :-- | :--------- |
| `VERSION` | Processor name and version information. |
| `DOC_ROOT` | Document root prefix, set to the working directory by default. |
| `DATE_FUNCTION` | Defines a custom date function alias that takes a unix timestamp and outputs a human-readable date to stdout. A plain date function is set by default. |

#### On modifying macros at runtime
One use case for modifying global macros is the `{DOC_ROOT}` macro, which
expands to the working directory.
Leaving this to the default setting allows you to generate web pages for local
viewing without an web server, simply write all intra-site URLs with
`{DOC_ROOT}/path/to/file`.

You can deploy your webpages for use with an web server by placing
`unset DOC_ROOT` in your `.kagami/macros`, it will rewrite all your intra-site URLs
starting from the root of your web server `/`.

### User-provided Macros
These can be provided to **kagami** at runtime to enable specific _optional_ features.

| user-provided | description |
| :-- | :--------- |
| `SITE_HOSTNAME` | _(optional)_ Defines a site hostname prefix and is the **minimum requirement** to generate an RSS feed. <br/>_eg. `https://sub.domain.name`_ |
| `SITE_TITLE`, `SITE_DESCRIPTION` | _(optional)_ Used for populating the `<title>` and `<description>` fields in RSS feed metadata and are _highly recommended_. |

### Local Macros
These are uniquely generated from every processed file at runtime and override
global and user-provided shell variables.

| built-in | description |
| :-- | :--------- |
| `TITLE` | Taken from first markdown `<h1>` heading on the page, uses page filename as fallback. |
| `CREATED` | Human readable timestamp taken from earliest valid date found in metadata comment. <br/>_eg. `<!--created xx/xx/xxxx-->`_ |
| `UPDATED` | Human readable timestamp taken from second earliest valid date found in metadata comment. <br/>_eg. `<!--updated xx/xx/xxxx-->`_ |
| `TOC` | _(optional)_ Anchor-linked table of contents linking to all headings found on the page. |

# Installation
**kagami** is a single shell script, you can keep it with your webpages at the
document root, or you can install it to your path by running `make install`. On
installation, if you have `pandoc` installed, this document will be available
as a manpage accessible via `man kagami`.

The default install location is `/usr/local`, you can change this with
`make install PREFIX=$HOME/.local`

An example template and configuration is provided so you can get started.
You can run `./kagami` in this directory to build a sample website.

# Requirements
* Any POSIX-compatible shell
* GNU date — Part of GNU coreutils, required for date conversion routines.
* [cmark](https://github.com/commonmark/cmark) — CommonMark Markdown to HTML processor
* [cmark-gfm](https://github.com/github/cmark-gfm) *(preferred)* — `cmark` with GitHub Extensions
	* _Adds support for inline footnotes, tables, strikethrough and autolinking URLs._
		* _**kagami** will fall back to standard `cmark` if not available._
* pandoc *(optional)* — Used during installation, creates an online manual page from this document.

# Background
>**kagami** (かがみ) is weeb for *mirror* (鏡)

**kagami** was written to fit a particular use case, mine.
If your needs are simple, then **kagami** is simple. This isn't a full-fat
wordpress-style blog generator.
Management of static elements such as images, client-side scripting,
stylesheets and site structure fall outside of the scope of this tool.

RSS feeds are reproducible, `lastBuildDate` matches the `pubDate` of the most
recent `item` found. This is to avoid the issue of dirtying a `git` worktree
just by running `kagami`

Several scrapped iterations of this tool were previously written as a portable
makefile using a C preprocessor and later, general purpose macro preprocessor
GNU `m4`.
`cpp` chokes on C syntax being used incorrectly, `m4` chokes on stray grave
symbols and common dictionary words like `divert` and `shift` as these are `m4` syntax.

I ended up implementing elements from both, along with the ability to add custom functionality
as part of the **kagami** template without making changes to the tool itself.

# Example
My [personal site](https://microsounds.github.io) is generated using **kagami** from
the **kagami** template located [here](https://github.com/microsounds/microsounds.github.io).

# License
GNU General Public License version 3 or later.
