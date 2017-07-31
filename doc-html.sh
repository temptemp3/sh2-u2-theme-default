#!/bin/bash
## doc-html
## version 0.0.1 - initial
##################################################
. $( dirname ${0} )/include.sh
##################################################
doc-html-template() {
 cat << EOF
<!DOCTYPE html>
<html><!-- based on https://www.w3schools.com/w3css/tryit.asp?filename=tryw3css_templates_blog&stacked=h -->
<head>
$( file-charset )
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
</style>
<title>$( basename ${file} ) not found</title>
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
doc-html() {
 doc-html-template 
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
