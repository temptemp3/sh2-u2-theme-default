#!/bin/bash
## doc-html
## version 0.0.5 - hljs
##################################################
. $( dirname ${0} )/include.sh
##################################################
doc-html-template() {
 cat << EOF
<!DOCTYPE html>
<html>
<head>
$( file-charset )
<meta name="viewport" content="width=device-width, initial-scale=1">
$( title-template )
$( if-meta-robots )
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
</style>
$( if-hljs )
</head>
<body class="w3-light-grey">

<div class="w3-content" style="max-width:1400px">

$( doc-html-header )

$( doc-html-grid )

<!-- .w3-content --></div>

$( doc-html-footer )

</body>
</html>
EOF
}
#-------------------------------------------------
doc-html-initialize() {
 get-document-meta
}
#-------------------------------------------------
doc-html-list() {
 doc-html-initialize
 doc-html-template 
}
#-------------------------------------------------
doc-html() {
 doc-html-list
}
##################################################
if [ ${#} -ge 2 -a -f "${1}" -a -f "${2}" ] 
then
 file="${1}"
 bloginfo="${2}"
 navigation=${@:3}
else
 exit 1 # wrong args
fi
##################################################
doc-html
##################################################
