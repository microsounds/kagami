# TODO
Wishlist for stuff to add in the future.

## Paste full correctly rendered article summaries in RSS `description` field
This should be accomplished without re-rendering every indexed article twice.

1. This would require spinning off macro expansion into it's own function
2. Another possibility is processing index pages last and concatting from finished pages without processing twice.
3. Or better yet, index pages get their own `process_dir()` function where threads are backgrounded until all pre-requsite pages have been built.
4. Or a correctly rendered temporary file without header/footer can be dropped for a hypothetical `process_index_dir()` to slurp up later.

## Prevent automatic rewrite features from affecting `<pre>` blocks
* Currently, `# comments` and `*.md` references within `<pre>` blocks are being modified and introducing page issues.
	* Prevent `md_toc_anchor()` from affecting `# comments` within code blocks.

### `# comments`
This can be avoided by using markdown single-tab delimited `<pre>` blocks (not \`\`\`) at the expense of losing syntax highlighting hints.

### `*.md => *.htm` rewrites
This can be suppressed by replacing period with HTML entity code `&period;` to link to literal `.md` documents.

## implement `{MACRO}` expansion in CSS and JS files (probably stupid)
Would this be re-implementing a bloated CSS preprocessor too? idk

## friendly URL scheme (non-feature)
* rewrite output filename into friendly URL based on md_title
	* strip non-URL characters at the same time

Having files with and without creation dates will complicate things,
requiring edge case logic in md_title and process_dir.

* wordpress-style URLs eg. "site.net/2020/6/20/my-blogpost.htm"

These can be implemented as symlinks, but `DOC_ROOT` becomes a non-optional macro.

# IMPLEMENTED
Old implementation notes for reference.
~~Stricken notes~~ represent outdated assumptions.

## ~~automatic RSS feed generation~~
I was overthinking this, RSS feed is now built automatically if
optional macro `SITE_HOSTNAME` with a domain name prefix exists.

* ~~This would require the non-optional use of
	`SITE_AUTHOR`, `SITE_TITLE`, `SITE_DESCRIPTION` and `SITE_HOSTNAME` user provided macros~~
	to form a valid RSS document during the `md_index()` process, as this is when most
	article metadata like title, page contents and creation date are all in scope.

just `SITE_TITLE` and `SITE_DESCRIPTION` and they're still optional

* ~~Relative filenames are not ideal, many RSS readers choke on use of `xml:base`
	for relative URL basenames and it's officially deprecated from the XML standard.~~
	~~Additional local `{MACROS}`~~ including full canonical URL and a description would have to be implemented.
* ~~Currently, `md_index()` has no awareness of how deep within the `.src/` directory
	it's operating in, `for f in *.md` only returns immediate filenames.~~

full canonical URLs are derived by subtracting `$source_dir` from `$PWD` when needed

* ~~At this point, it seems easier to re-implement a simplistic version of what pandoc does, appending
	metadata at the top of the markdown document instead of hiding it in HTML inline comments as currently done.~~

demanding more information from the user wasn't neccessary

* Generating an RSS file from multiple invocations of `md_index()` ~~would also violate
	DRY principles~~, as it would be tacked on before and after execution of the main `process_dir()` loop

## ~~add support for generating table of contents with inline anchor links to every heading~~
`cmark` doesn't support generating table of contents or even inline anchor links for headings

Forcibly add support for toc's even if it's not supported in cmark.

Append `<span id="0001"><span>` to the end of `# headings` via IFS= while read -r or similar

```
# a <span id="0001"></span>
## b
### c
#### d
##### e
###### f

<div class="toc">

* [a](#0001)
	* [b](#0002)
		* [c](#0003)
			* [d](#0004)
				* [e](#0005)
					* [f](#0006)

</div>
```

Maintain markdown list of these in {TOC}, which can be optionally added in document.

## ~~fix issue where newlines and stray grave characters can cause issues with sed~~
`grave` characters can appear in markdown toc but it must be converted to HTML before expansion of {TOC}

## ~~rewrite metadata functions as stateless filter functions~~
~~Performance gain from reading input file only once seem negligible.
This would be a style choice more than anything else.~~

Performance is marginally worse, but this was neccessary to write md_toc* series functions
