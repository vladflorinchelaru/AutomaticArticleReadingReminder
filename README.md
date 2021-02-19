# AutomaticArticleReadingReminder
A lightweight PowerShell script that can ease the batch download of scientific articles.

The user is highly encouraged to check the source code before running it.
Of note, there are two variables to be configured by the user:
`$listfile`
By default, the script will search for this file in the current working directory. If found, then the file will be parsed line by line (one line means one link) and the script will (try to) download the PDF corresponding to that article.
If the file is not found, then the user is expected to input a file name at the console.
`$SCHB`
If you (or your institution) use(s) any web service that automatically logs you in and enables you to directly view the PDF without a paywall hassle please enter the address of that web service in the $SCHB variable.
For example, if `$SCHB="contoso.ro/"` and inside `$listfile` the DOI is written as `https://doi.org/10.1007/s11192-020-03806-w`, then the script will access `contoso.ro/autologon/https://doi.org/10.1007/s11192-020-03806-w` instead of going directly to `https://doi.org/10.1007/s11192-020-03806-w`.
Do note that the script does not insert a `/` between `$SCHB` and the DOI link read from the file, and as such `$SCHB` should end with a slash (as per the example).
IF YOU DON'T USE such systems and the script should go directly to `doi.org`, then please set `$SCHB = ""` (just the quotations marks, no space between them)!
This option, although legally used inside Universities, labs, dormitories, can also be used illegally with some websites. *** The author(s) and publisher(s) of this script thereby exonerate themselves from any explicit or implicit illegal activities done with the help of this script, and as such the responsibilities lie on the shoulders of the end user. ***

This script uses the GNU GPL 3.0 license.
