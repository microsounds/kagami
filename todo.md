# TODO list

## friendly URL scheme (non-feature)
* rewrite output filename into friendly URL based on md_title
	* strip non-URL characters at the same time

Having files with and without creation dates will complicate things,
requiring edge case exceptions in md_title and process_dir.

* wordpress-style URLs eg. "site.net/2020/6/20/my-blogpost.htm"

These can be implemented as symlinks, but `{DOC_ROOT}` becomes a non-optional
feature.

## ~~add support for generating table of contents with inline anchor links to every heading~~ done
`cmark`  doesn't support generating table of contents or even inline anchor links for headings

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

## ~~fix issue where newlines and stray grave characters can cause issues with sed~~ done
`grave` characters can appear in markdown toc but it must be converted to HTML before expansion of {TOC}

## ~~rewrite metadata functions as stateless filter functions~~ done
~~Performance gain from reading input file only once seem negligible.
This would be a style choice more than anything else.~~

Performance is marginally worse, but this was neccessary to write md_toc* series functions
