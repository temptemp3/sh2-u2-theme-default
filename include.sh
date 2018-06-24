#!/bin/bash
## include
## version 0.1.0 - sections
##################################################
markdown() { ${SH}/markdown.sh ${@} ; }
file_mime_encoding() { ${SH2}/file-mime-encoding.sh ${@} ; }
cdr() { ${SH2}/cdr.sh ${@} ; }
cecho() { ${SH2}/cecho.sh ${@} ; }
. ${SH2}/aliases/commands.sh
##################################################
declare -A document
##################################################
template-card-container() { { local function_name ; function_name="${1}" ; }
 w3-color() {
  test "${w3_color}" && {
   echo ${w3_color}
  true
  } || {
   echo w3-white
  }
 }
 w3-card-class() {
  test "${w3_card_class}" && {
   echo ${w3_card_class}
  true
  } || {
   echo ""
  } 
 }
 w3-card() {
  test "${w3_card}" && {
   echo ${w3_card}
  true
  } || {
   echo "w3-card-4"
  }
 }
 cat << EOF
<div class="$( w3-card ) w3-margin $( w3-color ) $( w3-card-class )">
<div class="w3-container">
EOF
 ${function_name}
 cat << EOF
<!--.w3-container--></div>
<!--.w3-card--></div>
EOF
}
#-------------------------------------------------
template() {
 commands
}
#-------------------------------------------------
head-template() {
 cat << EOF
<head>
$( meta-charset UTF-8 )
<meta name="viewport" content="width=device-width, initial-scale=1">
$( title-template )
$( if-meta-robots )
$( if-link-canonical )
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
</style>
$( if-hljs )
</head>
EOF
}
#-------------------------------------------------
the-head() {
 head-template
}
#-------------------------------------------------
html-template() {
 cat << EOF
<!DOCTYPE html>
<html>
$( the-head )
$( the-body )
</html>
EOF
}
#-------------------------------------------------
the-html() {
 html-template
}
#-------------------------------------------------
body-template() {
 cat << EOF
<body class="w3-light-grey">
<div class="w3-content" style="max-width:1400px">
$( doc-html-header )
$( grid-template )
<!-- .w3-content --></div>
$( doc-html-footer )
</body>
EOF
}
#-------------------------------------------------
the-body() {
 body-template
}
#-------------------------------------------------
index-link-canonical() {
 echo "https://${document['domain']}/"
}
#-------------------------------------------------
default-link-canonical() {
 echo "https://${document['domain']}/${document['name']}.html"
}
#-------------------------------------------------
which-link-canonical() { 
 case ${document['name']} in 
  index) index-link-canonical ;;
  *) default-link-canonical ;;
 esac 
}
#-------------------------------------------------
link-canonical() {
 cat << EOF
<link rel="canonical" href="$( which-link-canonical )" />
EOF
}
#-------------------------------------------------
if-link-canonical() {
 if-bloginfo-url || {
  link-canonical
 } 
}
#-------------------------------------------------
if-hljs() {
 grep -v -e '<code class=' &>/dev/null || {
  hljs
 }
}
#-------------------------------------------------
hljs() {
 cat << EOF
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/default.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
EOF
}
#-------------------------------------------------
meta-robots-content() { { local candidate_meta_robots ; candidate_meta_robots="${1}" ; }
 case ${candidate_meta_robots} in
  noindex,follow)	echo "noindex, follow"		;;
  noindex,nofollow)	echo "noindex, nofollow"	;;
  index,nofollow)	echo "index, nofollow" 		;;
  default|*) 		echo "index, follow" 		;;
 esac
}
#-------------------------------------------------
meta-robots() { 
 cat << EOF
<meta name="robots" content="$( meta-robots-content ${document['meta-robots']} )">
EOF
}
#-------------------------------------------------
if-meta-robots() {
 test ! "${document['meta-robots']}" || {
  meta-robots
 }
}
#-------------------------------------------------
get-document-info() {
 document['name']=$( basename ${file} )
 document['domain']=$( basename $( get-bloginfo-url ) )
}
#-------------------------------------------------
get-document-meta-payload() {
 local document_meta
 local document_meta_name
 local document_meta_value
 document_meta=$(
  cat ${file} \
  | grep \
  -e '<[!]--\s*[a-z-]\+:\([a-z]\|[A-Z]\|[0-9]\|[-,. ]\)*-->' \
  --only-matching \
  | sed -e 's/<!--\s\+//g' \
  -e 's/\s\+-->//g' 
 )
 test ! "${document_meta}" || {
  document_meta_name=$( 
   echo "${document_meta}" | cut -f1 -d:
  )
  document_meta_value=$(
   echo "${document_meta}" | cut -f2 -d:
  )
  document["${document_meta_name}"]="${document_meta_value}" 
 }
}
#-------------------------------------------------
get-document-meta() {
 case $( basename ${0} .sh ) in
  error-404-html) true ;; 
  *) get-document-meta-payload ;;
 esac 
}
#-------------------------------------------------
include() {
 true
}
#-------------------------------------------------
default-title-template() {
 title "$( deslugify ${document['name']} ) | $( if-bloginfo-url || echo ${document['domain']} ; )"
}
#-------------------------------------------------
which-title-template() { { local candidate_title_template_name ; candidate_title_template_name="${1}" ; }
 case ${candidate_title_template_name} in
  error-404-html|error-404) error-404-title-template ;;
  doc-html|default) default-title-template ;;
  *) default-title-template ;;
 esac
}
#-------------------------------------------------
title-template() { 
{ local candidate_title_template_name ; test ${#} -eq 1 && { candidate_title_template_name="${1}" ; true  ; } || { candidate_title_template_name=$( basename ${0} .sh ) ; } ; }
 echo ${0} 1>&2 
 which-title-template ${candidate_title_template_name}
}
#-------------------------------------------------
doc-html-header-template() {
 cat << EOF
<!-- Header -->
<header class="w3-container w3-center w3-padding-32"> 
<h1><b>$( if-bloginfo-name || echo "<a style=\"text-decoration:none;\" href=\"$( get-bloginfo-url )\">$( get-bloginfo-name )</a>" )</b></h1>
<p>$( if-bloginfo-description || get-bloginfo-description )</p>
</header>
EOF
}
#-------------------------------------------------
document-h1() {
 h1 ${document['name']}
}
#-------------------------------------------------
if-document-h1() {
 test ! \
 -a "${document['show-document-heading-one']}" \
 -a "${document['show-document-heading-one']}" = "false" || {
  document-h1
 }
}
#-------------------------------------------------q
document-intro-template() {
 p "${document['document-intro']}" 
}
#-------------------------------------------------
test-document-intro() {
 test ! "${document['document-intro']}" 
}
#-------------------------------------------------
if-document-intro() {
 test-document-intro || {
  document-intro-template
 }
}
#-------------------------------------------------
grid-content-column-template-h1-generator() {
 if-document-h1
 if-document-intro
}
#-------------------------------------------------
grid-content-column-template-h1() {
  {
    template \
    card-container \
    ${FUNCNAME}-generator
  }
}
#-------------------------------------------------
grid-content-column-template() {
 cat << EOF
<div class="w3-col l8 s12">
$( the-content )
<!--.w3-col--></div>
EOF
}
#-------------------------------------------------
grid-navigation-column-template() {
 cat << EOF
<div class="w3-col l4">
<div class="w3-card-2 w3-margin w3-margin-top w3-white">
<div class="w3-container">
$( the-navigation )
<!--.w3-container--></div>
<!--.w3-card--></div>
<!--.w3-col--></div>
EOF
}
#-------------------------------------------------
grid-content-column() {
 grid-content-column-template
}
#-------------------------------------------------
grid-navigation-column() {
 grid-navigation-column-template
}
#-------------------------------------------------
grid-template() {
 cat << EOF
<!-- begin Grid -->
<div class="w3-row">
$( grid-navigation-column )
$( grid-content-column )
<!--.w3-row--></div>
<!-- Grid end -->
EOF
}
#-------------------------------------------------
doc-html-navigation-element-template() {
 local navigation_element
 for navigation_element in index ${navigation}
 do
  cat << EOF
<a href="${navigation_element}.html" class="w3-bar-item w3-button w3-mobile">${navigation_element}</a>
EOF
 done
 
}
#-------------------------------------------------
doc-html-navigation-template() {
 cat << EOF
<div class="w3-bar w3-white">
$( doc-html-navigation-element-template )
</div> 
EOF
}
#-------------------------------------------------
the-navigation() {
 doc-html-navigation-template
}
#-------------------------------------------------
doc-html-footer-template() {
 cat << EOF
<footer class="w3-container w3-dark-grey w3-padding-32 w3-margin-top">
<p>&copy; 2015-$( date +%Y ) $( if-bloginfo-url || a $( get-bloginfo-url ) ${document['domain']} )Nicholas Shellabarger</p>
<!--button class="w3-button w3-black w3-disabled w3-padding-large w3-margin-bottom">Previous</button>
<button class="w3-button w3-black w3-padding-large w3-margin-bottom">Next</button-->
<!--mute in global fields -->
<!--p>Powered by <a href="https://www.w3schools.com/w3css/default.asp" target="_blank" rel="nofollow">w3.css</a></p-->
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
meta-charset() { { local charset ; charset="${1}" ; }
 cat << EOF
<meta charset="${charset}">
EOF
}
#-------------------------------------------------
file-charset() {
 meta-charset-template $( file-charsets $( file_mime_encoding ${file} ) )
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
text_content() { { local html ; html=${@} ; }
 echo ${@} \
 | sed 's/<[^>]*.//g'
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
title() { { local text ; text="${@}" ; }
 tag-fold title ${text}
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
the-content-payload-default() {
 markdown ${temp_file}
}
#-------------------------------------------------
the-content-payload-sections-template-generator-default() { 
 sed -n "${range}p" ${infile} > ${infile}-section
 markdown ${infile}-section
}
#-------------------------------------------------
the-content-payload-sections-template-generator-body() { 
 sed -n "${range}p" ${infile} > ${infile}-section
 sed -i '1,3d' ${infile}-section
 sed -i '$d' ${infile}-section
 sed -i '$d' ${infile}-section
 sed -i '$d' ${infile}-section
 markdown ${infile}-section
}
#-------------------------------------------------
the-content-payload-sections-template-generator-start-end() { 
 echo ${section_start}
 echo ${section_end}
}
#-------------------------------------------------
the-content-payload-sections-template-generator() { 
 commands
}
#-------------------------------------------------
the-content-payload-sections-template-setup-section-end() { 
 local line_no
 line_no=$(( 
  $( echo ${range} | cut '-d,' '-f2' ) - 1 
 ))
 section_end=$(
  text_content $( 
   sed -n "${line_no}p" ${infile} 
  )
 )
 cecho "section end: \"${section_end}\""
}
#-------------------------------------------------
the-content-payload-sections-template-setup-section-start() { 
 local line_no
 line_no=$(( 
  $( echo ${range} | cut '-d,' '-f1' ) + 1 
 ))
 section_start=$(
  text_content $( 
   sed -n "${line_no}p" ${infile} 
  )
 )
 cecho "section start: \"${section_end}\""
}
#-------------------------------------------------
the-content-payload-sections-template() { 
  set -v -x 
  local section_end
  ${FUNCNAME}-setup-section-end
  ${FUNCNAME}-setup-section-start
  pattern_date_dd_mmm_yyyy="[0-9][0-9] [A-Z][a-z][a-z] [0-9][0-9][0-9][0-9]"
  case ${section_end} in
   ${pattern_date_dd_mmm_yyyy}) {
     {
       (
         local w3_color
         w3_color="w3-dark-gray"
         local w3_card_class
         w3_card_class="collapsible"
         template \
         card-container \
         ${FUNCNAME}-generator-start-end
       )
       (
         local w3_card
	 w3_card="w3-card-3"
         local w3_card_class
         w3_card_class="content"
         template \
         card-container \
         ${FUNCNAME}-generator-body
       )
     } >> ${temp_file}-sections-footer
   } ;;
   *) {
     {
       template \
       card-container \
       ${FUNCNAME}-generator-default
     }
   } ;;
  esac
  set +v +x
}
#-------------------------------------------------
the-content-payload-sections() { { local infile ; infile="${1}" ; }
 cecho green in ${FUNCNAME}
 get-div-lines() {
  cat ${infile} \
  | grep '^[*][*][*]\+' --only-matching -n \
  | cut '-d:' '-f1'
 }
 len() { echo ${#} ; }
 cdr() { echo ${@:2} ; }
 car() { echo ${1} ; }
 cadr() { car $( cdr ${@} ) ; }
 local range
 local div_lines
 div_lines=$(
  get-div-lines
 )
 while [ ! ]
 do
  range="$(( $( car ${div_lines} ) + 1 )),$(( $( cadr ${div_lines} ) - 1 ))"
  ${FUNCNAME}-template
  div_lines=$( cdr ${div_lines} )
  test ! $( len ${div_lines} ) -le 1 || {
   break
  }
 done
}
#-------------------------------------------------
the-content-payload() {
 commands
}
#-------------------------------------------------
the-content() {
 cecho green in ${FUNCNAME}
 cat << EOF
<style>
.collapsible {
/*
    background-color: #777;
    color: white;
*/
    cursor: pointer;
    padding: 18px;
/*
    width: 100%;
*/
    border: none;
    text-align: left;
    outline: none;
    font-size: 15px;
}

.active, .collapsible:hover {
    background-color: #555;
}

.content {
    padding: 0 18px;
    display: none;
    overflow: hidden;
    background-color: #f1f1f1;
}
</style>
EOF
 #------------------------------------------------
 # original
 #------------------------------------------------
 #markdown ${file}
 #return 
 #------------------------------------------------
 #- ignore first line in doc-html
 # + make the first line in doc special and 
 #   reserved for purpose to be specified at later 
 #   date
 #------------------------------------------------
 local temp_file
 temp_file="temp-${RANDOM}-$( date +%s )-file"
 sed  "1d" ${file} > ${temp_file}
 #head ${temp_file} 1>&2
 #------------------------------------------------
 # payload
 # - default
 # + output html as is
 # - sections
 # + output html in sections
 #------------------------------------------------
 {
   ${FUNCNAME}-payload \
   sections \
   ${temp_file}
 }
 #------------------------------------------------
 {
   set -v -x
   touch ${temp_file}-sections-footer
   cat ${temp_file}-sections-footer
   set +v +x
 }
 #------------------------------------------------
 cat << EOF
<script>
var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function() {
        this.classList.toggle("active");
        var content = this.nextElementSibling;
        if (content.style.display === "block") {
            content.style.display = "none";
        } else {
            content.style.display = "block";
        }
    });
}
</script>
EOF
 #------------------------------------------------
 # cleanup
 #------------------------------------------------
 test ! -f "${temp_file}" || {
  cecho yellow $( rm -v ${temp_file} )
 }
 #------------------------------------------------
}
#-------------------------------------------------
initialize() {
 get-document-info
 get-document-meta
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
