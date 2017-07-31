#!/bin/bash
## include
## version 0.0.2 - ul li
##################################################
markdown() { ${SH}/markdown.sh ${@} ; }
file_mime_encoding() { ${SH2}/file-mime-encoding.sh ${@} ; }
cdr() { ${SH2}/cdr.sh ${@} ; }
##################################################
include() {
 true
}
#-------------------------------------------------
doc-html-header-template() {
 cat << EOF
<!-- Header -->
<header class="w3-container w3-center w3-padding-32"> 
<h1><b>$( if-bloginfo-name || a $( get-bloginfo-url ) $( get-bloginfo-name ) )</b></h1>
<p>$( if-bloginfo-description || get-bloginfo-description )</p>
</header>
EOF
}
#-------------------------------------------------
doc-html-grid-template() {
 cat << EOF
<!-- begin Grid -->
<div class="w3-row">

<div class="w3-col l8 s12">
<div class="w3-card-4 w3-margin w3-white">
<div class="w3-container">
$( h1 $( basename ${file} ) )
$( the-content )
<!--.w3-container--></div>
<!--.w3-card--></div>
<!--.w3-col--></div>

<div class="w3-col l4">
<div class="w3-card-2 w3-margin w3-margin-top w3-white">
<div class="w3-container">
<ul><li><a href="index.html">top</li></ul>
${navigation} 
<!--.w3-container--></div>
<!--.w3-card--></div>
<!--.w3-col--></div>

<!--.w3-row--></div>
<!-- Grid end -->
EOF
}
#-------------------------------------------------
doc-html-footer-template() {
 cat << EOF
<footer class="w3-container w3-dark-grey w3-padding-32 w3-margin-top">
&copy; 2017 $( if-bloginfo-url || a $( get-bloginfo-url ) $( basename $( get-bloginfo-url ) ) )
<!--button class="w3-button w3-black w3-disabled w3-padding-large w3-margin-bottom">Previous</button>
<button class="w3-button w3-black w3-padding-large w3-margin-bottom">Next</button-->
</footer>
EOF
}
#-------------------------------------------------
doc-html-header() {
 if-bloginfo-name || if-bloginfo-description || doc-html-header-template
}
#-------------------------------------------------
doc-html-grid() {
 doc-html-grid-template
}
#-------------------------------------------------
doc-html-footer() {
 doc-html-footer-template
}
#-------------------------------------------------
if-bloginfo-url() {
 test ! "$( get-bloginfo-url )" != "bloginfo-url"
}
#-------------------------------------------------
if-bloginfo-name() {
 test ! "$( get-bloginfo-name )" != "bloginfo-name"
}
#-------------------------------------------------
if-bloginfo-description() {
 test ! "$( get-bloginfo-description )" != "bloginfo-description"
}
#-------------------------------------------------
get-bloginfo-description() {
 get-bloginfo description
}
#-------------------------------------------------
get-bloginfo-name() {
 get-bloginfo name
}
#-------------------------------------------------
get-bloginfo-url() { { local path ; path="${1}" ; }
 echo $( get-bloginfo url )${path}
}
#-------------------------------------------------
get-bloginfo() { { local record_name ; record_name="${1}" ; }
 local record_value
 record_value=$(
  cdr $( 
   cat ${bloginfo} | grep -e "${record_name}" 
  )
 )
 test "${record_value}" || {
  record_value="bloginfo-${record_name}"
 }
 echo ${record_value}
}
#-------------------------------------------------
file-charsets() { { local charset ; charset="${1}" ; }
 echo ${file} ${charset} 1>&2
 case ${charset} in
  SHIFT_JIS)	echo Shift_JIS ;;
  utf-8) 	echo UTF-8 ;;
  us-ascii) 	echo US-ASCII ;;
  *)		echo ISO-8859-1 ;;
 esac 
}
#-------------------------------------------------
file-charset() {
 local charset
 charset=$( file-charsets $( file_mime_encoding ${file} ) )
 cat << EOF
<meta charset="${charset}">
EOF
}
#-------------------------------------------------
deslugify() { { local text ; text="${@}" ; }
 echo ${text} |
 sed \
  -e 's/[-_]\+/ /g'
}
#-------------------------------------------------
a() { { local href ; href="${1}" ; local text ; text=${@:2} ; }
 cat << EOF
<a href="${href}">${text}</a>
EOF
}
#-------------------------------------------------
li() { { local text ; text="${@}" ; }
 tag-fold li ${text}
}
#-------------------------------------------------
ul() { { local text ; text="${@}" ; }
 tag-fold ul ${text}
}
#-------------------------------------------------
p() { { local text ; text="${@}" ; }
 tag-fold p ${text}
}
#-------------------------------------------------
u() { { local text ; text="${@}" ; }
 tag-fold u ${text}
}
#-------------------------------------------------
tag-fold() { { local tag ; tag="${1}" ; local text ; text=${@:2} ; }
 cat << EOF
<${tag}>${text}</${tag}>
EOF
}
#-------------------------------------------------
h1() { { local text ; text="${@}" ; }
 tag-fold h1 $( deslugify ${text} )
}
#-------------------------------------------------
the-content() {
 markdown ${file}
}
##################################################
if [ ! ] 
then
 true
else
 exit 1 # wrong args
fi
##################################################
include
##################################################
