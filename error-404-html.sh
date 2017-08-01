#!/bin/bash
## error-404-html
## version 0.0.2 - title template
##################################################
. $( dirname ${0} )/include.sh
##################################################
error-404-html-template() {
 cat << EOF
<!DOCTYPE html>
<html>
<head>
<meta name="robots" content="noindex, nofollow">
$( file-charset )
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
</style>
$( title-template )
</head>
<body class="w3-light-grey">
<div class="w3-content" style="max-width:1400px">

$( doc-html-header )

<!-- begin Grid -->
<div class="w3-row">
<div class="w3-col l8 s12">

<div class="w3-card-4 w3-margin w3-white">
<div class="w3-container">
$( h1 404. Page not found )
$( p The page you are looking for is nowhere to be found. Please check the URL or return to the $( u $( a $( if-bloginfo-url && { echo "index.html" ; true ; } || get-bloginfo-url ) Home Page ) ). )
<!--.w3-container--></div>
<!--.w3-card--></div>

<!--.w3-col--></div>
<!--.w3-row--></div>
<!-- Grid end -->

<!-- .w3-content --></div>

$( doc-html-footer )

</body>
</html>
EOF
}
#-------------------------------------------------
error-404-html() {
 error-404-html-template
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
error-404-html
##################################################
