# todo

## rewrite metadata functions as stateless filter functions
Performance gain from reading input file only once seem negligible.
This would be a style choice more than anything else.

## friendly URL scheme (non-feature)
* rewrite output filename into friendly URL based on md_title
	* strip non-URL characters at the same time

Having files with and without creation dates will complicate things,
requiring edge case exceptions in md_title and process_dir.

* wordpress-style URLs eg. "site.net/2020/6/20/my-blogpost.htm"

These can be implemented as symlinks, but `{DOC_ROOT}` becomes a non-optional
feature.
