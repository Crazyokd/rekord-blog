#!/bin/bash
# Markdown Pretty Self-Contained HTML Generation Script
# By Lucas Garron and Rekord

set -e

if [ "$#" = "0" ]
then
	echo "Usage: ${0} file.md"
	exit 1
fi

MARKDOWN_PATH="/usr/local/bin/Markdown.pl"
IN_FILE_PATH="$1"
IN_FILE_NAME=`basename "$IN_FILE_PATH"`
OUT_FILE_PATH="${IN_FILE_PATH%.*}.html"
OUT_FILE_NAME=`basename "$OUT_FILE_PATH"`

function printStatus {
  echo "$@"
}

function printMarkdown {

printStatus "[>   ] Creating $OUT_FILE_PATH..."

echo -n "" > "$OUT_FILE_PATH"

printStatus "[=>  ] Embedding Markdown source..."

echo "<!-- Markdown Source -->" >> "$OUT_FILE_PATH"
echo "<!--" >> "$OUT_FILE_PATH"
cat "$IN_FILE_PATH" >> "$OUT_FILE_PATH"
echo "-->" >> "$OUT_FILE_PATH"

printStatus "[==> ] Starting HTML and including CSS..."

echo "<html>" >> "$OUT_FILE_PATH"
echo "<head>" >> "$OUT_FILE_PATH"
echo '<meta http-equiv="Content-type" content="text/html;charset=UTF-8">' >> "$OUT_FILE_PATH"
echo "<title>$OUT_FILE_NAME</title>" >> "$OUT_FILE_PATH"
echo "<style>" >> "$OUT_FILE_PATH"
echo "$1" >> "$OUT_FILE_PATH"
echo "</style>" >> "$OUT_FILE_PATH"
echo "</head>" >> "$OUT_FILE_PATH"
echo "<body>" >> "$OUT_FILE_PATH"

# echo "<hr>" >> "$OUT_FILE_PATH"

printStatus "[===>] Marking down..."

"$MARKDOWN_PATH" "$IN_FILE_PATH" >> "$OUT_FILE_PATH"
echo "<div class=\"div_foot\">
        <b>`basename "$OUT_FILE_PATH"`</b> - Generated on <b>`date`</b> by <b>`whoami`</b> using <a href=\"http://daringfireball.net/projects/markdown/\">Markdown</a> and <a href=\"https://github.com/lgarron/md2html\">lgarron/md2html</a>. Source is embedded.
    </div>" >> "$OUT_FILE_PATH"
echo "</body>" >> "$OUT_FILE_PATH"
echo "</html>" >> "$OUT_FILE_PATH"

printStatus "[====] Done."

}

# Just be careful not use any backticks in the CSS, and end with a line of HEREDOC`"
printMarkdown "`cat <<HEREDOC
/* Taken from QLMarkdown: https://github.com/toland/qlmarkdown */
/* Extracted and interpreted from adcstyle.css and frameset_styles.css */
/* body */
body {
	margin: 20px 40px;
	background-color: #fff;
	color: #000;
	font: 13px "Myriad Pro", "Lucida Grande", Lucida, Verdana, sans-serif;
}
/* links */
a:link {
	color: #00f;
	text-decoration: none;
}
a:visited {
	color: #00a;
	text-decoration: none;
}
a:hover {
	color: #f60;
	text-decoration: underline;
}
	
a:active {
	color: #f60;
	text-decoration: underline;
}
/* html tags */
/*  Work around IE/Win code size bug - courtesy Jesper, waffle.wootest.net  */
* html code	{
	font-size: 101%;
}
* html pre {
	font-size: 101%;
}
/* code */
pre, code {
	font-size: 11px; font-family: monaco, courier, consolas, monospace;
}
pre {
	margin-top: 5px;
	margin-bottom: 10px;
	border: 1px solid #c7cfd5;
	background: #f1f5f9;
	margin: 20px 0;
	padding: 8px;
	text-align: left;
}
hr {
	color: #919699;
	size: 1;
	width: 100%;
	noshade: "noshade"
}
/* headers */
h1, h2, h3, h4, h5, h6 {
	font-family: "Myriad Pro", "Lucida Grande", Lucida, Verdana, sans-serif;
	font-weight: bold;
}
h1	{
	margin-top: 1em;
	margin-bottom: 25px;
	color: #000;
	font-weight: bold;
	font-size: 30px;
}
h2	{
	margin-top: 2.5em;
	font-size: 24px;
	color: #000;
	padding-bottom: 2px;
	border-bottom: 1px solid #919699;
}
h3	{
	margin-top: 2em;
	margin-bottom: .5em;
	font-size: 17px;
	color: #000;
}
h4	{
	margin-top: 2em;
	margin-bottom: .5em;
	font-size: 15px;
	color: #000;
}
h5	{
	margin-top: 20px;
	margin-bottom: .5em;
    padding: 0;
	font-size: 13px;
	color: #000;
}
h6	{
	margin-top: 20px;
	margin-bottom: .5em;
    padding: 0;
	font-size: 11px;
	color: #000;
}
p {
    margin-top: 0px;
    margin-bottom: 10px;
}
/* lists */
ul	{
	list-style: square outside;
	margin: 0 0 0 30px;
	padding: 0 0 12px 6px;
}
li	{
	margin-top: 7px;
}
	        
ol {
	list-style-type: decimal;
	list-style-position: outside;
	margin: 0 0 0 30px;
	padding: 0 0 12px 6px;
}
	
ol ol {
	list-style-type: lower-alpha;
    list-style-position: outside;
	margin: 7px 0 0 30px;
	padding: 0 0 0 10px;
    }
ul ul {
	margin-left: 40px;
	padding: 0 0 0 6px;
}
li>p { display: inline }
li>p+p { display: block }
li>a+p { display: block }
/* table */
table {
	border-top: 1px solid #919699;
	border-left: 1px solid #919699;
	border-spacing: 0;
}
	
table th {
	padding: 4px 8px 4px 8px;
	background: #E2E2E2;
	font-size: 12px;
	border-bottom: 1px solid #919699;
	border-right: 1px solid #919699;
}
table th p {
	font-weight: bold;
	margin-bottom: 0px; 
}
	
table td {
	padding: 8px;
	font-size: 12px;
	vertical-align: top;
	border-bottom: 1px solid #919699;
	border-right: 1px solid #919699;
}
table td p {
	margin-bottom: 0px; 
}
table td p + p  {
	margin-top: 5px; 
}
table td p + p + p {
	margin-top: 5px; 
}
/* forms */
form {
	margin: 0;
}
button {
	margin: 3px 0 10px 0;
}
input {
	vertical-align: middle;
	padding: 0;
	margin: 0 0 5px 0;
}
select {
	vertical-align: middle;
	padding: 0;
	margin: 0 0 3px 0;
}
textarea {
	margin: 0 0 10px 0;
	width: 100%;
}
.div_foot {
    position: absolute;
    height: 50px;
    text-align: center;
    line-height: 50px;
    width: 100%;
}
HEREDOC`"