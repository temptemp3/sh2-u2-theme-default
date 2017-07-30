#!/bin/bash
## include
## version 0.0.1 - initial
##################################################
markdown() { ${SH}/markdown.sh ${@} ; }
file_mime_encoding() { ${SH2}/file-mime-encoding.sh ${@} ; }
cdr() { ${SH2}/cdr.sh ${@} ; }
##################################################
include() {
 true
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
