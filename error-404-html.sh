#!/bin/bash
## error-404-html
## version 0.0.1 - initial
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
<title>$( basename ${file} ) not found</title>
</head>
<body class="w3-light-grey">
<div class="w3-content" style="max-width:1400px">
<!-- Header -->
<header class="w3-container w3-center w3-padding-32"> 
<h1><b>$( a $( get-bloginfo-url ) $( get-bloginfo-name ) )</b></h1>
<p>$( get-bloginfo description )</p>
</header>

<!-- begin Grid -->
<div class="w3-row">
<div class="w3-col l8 s12">

<div class="w3-card-4 w3-margin w3-white">
<div class="w3-container">
$( h1 404. Page not found )
$( p The page you are looking for is nowhere to be found. Please check the URL or return to the $( u $( a $( get-bloginfo-url ) Home Page ) ). )
<!--.w3-container--></div>
<!--.w3-card--></div>

<!--.w3-col--></div>
<!--.w3-row--></div>
<!-- Grid end -->

<!-- .w3-content --></div>

<footer class="w3-container w3-dark-grey w3-padding-32 w3-margin-top">
&copy; 2017 $( a $( get-bloginfo-url ) $( basename $( get-bloginfo-url ) ) )
<!--button class="w3-button w3-black w3-disabled w3-padding-large w3-margin-bottom">Previous</button>
<button class="w3-button w3-black w3-padding-large w3-margin-bottom">Next</button-->
</footer>

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
