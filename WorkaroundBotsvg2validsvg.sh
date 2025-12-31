#!/bin/bash
#Author: Johannes Kalliauer (JoKalliauer)
#created: 2019-02-20

# $1 ... input (f.e. Buggy.svg)
# $2 ... output (f.e. Repaired.svg)
# $3 ... SVGCleaner (YES or NO)
# $4 ... scour (YES or NO)
# $5 ... valid (YES or NO)
# $6 ....safe (YES or NO)
# $7 ....kerning (YES or NO)
# $8 ....svgo (YES or NO)


#rm -f $1

export i=$1
export i2=$2

SVGCleaner=$3
ScourScour=$4
validValid=$5
safe=$6
kerningKerning=$7
SvgoSvgo=$8

~/.bash_profile

T35245tspan=YES
EinzeilTags=YES


#----
export i3=$2.svg

if [ -z ${SVGCleaner+x} ] || [ -z "$SVGCleaner" ]; then
 SVGCleaner=YES
fi
if [ -z ${EinzeilTags+x} ]; then
 EinzeilTags=YES
fi
if [ -z ${ScourScour+x} ] || [ -z "$ScourScour" ]; then
 ScourScour=YES
fi
if [ -z ${validValid+x} ] || [ -z "$validValid" ]; then
 validValid=NO
fi
if [ -z ${safe+x} ] || [ -z "$safe" ]; then
 safe=NO
fi
if [ -z ${kerningKerning+x} ] || [ -z "$kerningKerning" ]; then
 kerningKerning=NO
fi
if [ $validValid = "YES" ]; then
 ScourScour="YES"
fi
if [ -z ${SvgoSvgo+x} ]; then
 echo set SvgoSvgo to yes
 SvgoSvgo=YES
fi

echo c $SVGCleaner
echo e $EinzeilTags
echo s $ScourScour
echo v $validValid
echo sa $safe
echo k $kerningKerning

echo "\n \n" >> outbut.log
echo c $SVGCleaner e $EinzeilTags s $ScourScour v $validValid sa $safe k $kerningKerning o $SvgoSvgo >> outbut.log
echo 1 $1 2 $2 3$3 4 $4 5 $5 6 $6 7 $7 8 $8 >> outbut.log


#if [ $SVGCleaner = '' ]; then
# SVGCleaner=YES
#fi

if [ $HOSTNAME = LAPTOP-K1FUMMIP ]; then
 PC=locaJK
elif [ $HOSTNAME = jkalliau-Z87M-D3H ]; then
 PC=locaJK
elif [ $HOSTNAME = tools-sgebastion-07 ] || [ $HOSTNAME = tools-sgebastion-10 ]; then
 PC=WikiMedia
elif [ $HOSTNAME = DESKTOP-7VKND0M ]; then
 PC=locaJK
elif  [ $HOSTNAME = localhost.localdomain ]; then
 PC=locaJK
elif  [ $HOSTNAME = fedora ]; then
 PC=locaJK
elif [[ $HOSTNAME =  tools-sgewebgrid-lighttpd-* ]] || [[ $HOSTNAME = tools-sgeweblight-10-20 ]]; then
 PC=WikiMedia
elif  [ $HOSTNAME = lws84.imws.tuwien.ac.at ]; then
 PC=locaJK
else
 echo did not recognice HOSTNAME $HOSTNAME
 PC=$HOSTNAME
fi
echo $PC
echo $PC >> outbut.log

if [ -z "$1" ]
  then
    echo "No inputfile supplied"
    if [ -z "$i" ]
    then
	 exit
	fi
fi

if [ $PC = locaJK ]; then
 #rm -f $1
 wget -q https://commons.wikimedia.org/wiki/Special:FilePath/$i -O $i
 export ScourJK="python3 -m scour.scour"
else
 if [ $PC = WikiMedia ]; then
  # do not remove this on convert it might be needed to check
  #rm -f $1
  #wget -q https://commons.wikimedia.org/wiki/Special:FilePath/$i -O $i
  #export ScourJK="python3 -m scour.scour"
  export ScourJK="/data/project/svgworkaroundbot/prgm2/pythonJK/PythonIn/bin/python3.7 -m scour.scour"
  #echo $ScourJK >foobar064
 else
  echo did not recognice HOSTNAME $HOSTNAME
 fi
fi
export PATH=/data/project/svgworkaroundbot/SVGWorkaroundBot/cleanupSVG-master/:/data/project/svgworkaroundbot/prgm/svgcleaner/:$PATH
#echo HN $HOSTNAME > foobar070.del

# ---- Begin ----


if [ $EinzeilTags = 'YES' ]; then
  sed -i "s/\r/ /g" $i #remove carriage return (DOS,MAC)
  sed -ri -e ':a' -e 'N' -e '$!ba' -e "s/\n[[:space:]]+/ /g" $i #reduce to one space
  #sed -ri -e ':a' -e 'N' -e '$!ba' -e "s/[[:space:]\r\n]+/ /g" $i #no need for that
  sed -ri 's/[[:space:]]*<(g|path|svg|flowRoot|defs|clipPath|radialGradient|linearGradient|filter|mask|pattern|text|metadata|!--|image|inkscape:perspective) /\n<\1 /g' $i
fi

#remove empty flow Text in svg (first update svg2validsvg.sh)
#remove empty flow Text in svg (everything else will be done by https://github.com/JoKalliauer/cleanupSVG/blob/master/Flow2TextByInkscape.sh )
sed -ri "s/<flowPara([-[:alnum:]\"\' \.\:\%\=\;\,#\(\)]*)\/>//g;s/<flowRoot([-[:alnum:]\" \.:%=;]*)\/>//g" $i
sed -i 's/<flowSpan[-[:alnum:]=\":;\. ]*>[[:space:]]*<\/flowSpan>//g' $i
sed -ri -e ':a' -e 'N' -e '$!ba' -e "s/<flowRoot([-[:alnum:]\.=\" \:\(\)\%\#\,\';]*)>[[:space:]]*<flowRegion(\/|[[:alnum:]\"= ]*>[[:space:]]*<(path|rect) [-[:alnum:]\. \"\=:]*\/>[[:space:]]*<\/flowRegion)>[[:space:]]*(<flowDiv\/>|)[[:space:]]*<\/flowRoot>//g" $i #delete empty flowRoot
sed -ri -e ':a' -e 'N' -e '$!ba' -e "s/<flowRoot([-[:alnum:]\.=\" \:\(\)\%\#\,\';]*)>[[:space:]]*<flowRegion([-[:alnum:]=:\" ]*)>[[:space:]]*(<path[-[:alnum:]\.=\"\ \#]*\/>|<rect( id=\"[-[:alnum:]]*\"|) x=\"([-[:digit:]\. ]+)\" y=\"([-[:digit:]\. ]+)\"([[:lower:][:digit:]=\.\" \#:]+)\/>)[[:space:]]*<\/flowRegion>[[:space:]]*(|<flowPara([-[:alnum:]\.=\" \:\#;% ]*)>([[:space:] ]*)<\/flowPara>)[[:space:]]*<\/flowRoot>//g" $i ##delete flowRoot only containing spaces

sed -ri "s/inkscape:version=\"0.(4[\. r[:digit:]]+|91 r13725)\"//g" $i # https://bugs.launchpad.net/inkscape/+bug/1763190

 sed -i "s/ inkscape:connector-curvature=\"0\"//g" $i #https://commons.wikimedia.org/wiki/File:Royal_Monogram_of_Princess_Adityadhornkitikhun.svg

if [ $safe = 'YES' ];
 then
 #https://commons.wikimedia.org/wiki/User:JoKalliauer/IllegalSVGPattern
 sed -ri "s/  <d:SVGTestCase xmlns:d=\"http:\/\/www.w3.org\/2000\/02\/svg\/testsuite\/description\/\"/  <d:SVGTestCase xmlns:d=\"http:\/\/www.w3.org\/2000\/svg\" xmlnsd=\"http:\/\/www.w3.org\/2000\/02\/svg\/testsuite\/description\/\"/" $i
 sed -ri "s/ xmlns=\"http:\/\/www.w3.org\/1999\/xhtml\"/ xmlnsDeactivated=\"http:\/\/www.w3.org\/1999\/xhtml\"/" $i
 sed -ri  "s/ xmlns(|:bd)=\"http:\/\/(www.|)example.org\/[[[:alpha:]]*\"/ xmlns\1=\"http:\/\/www.inkscape.org\/namespaces\/inkscape\"/" $i
 sed -ri "s/:href=(\"|')([[:lower:]\.]+)([-[:alnum:]\/\.#_:]*)(\"|')/href=\1\2\3\4/" $i
 sed -ri "s/<(animate|set)([[:alpha:]=\"':# ]*) attributeName=(\"|')xlink:href(\"|')/<\1\2 attributeName=\3xlinkDeactivated\4/" $i
 sed -ri "s/<set([[:alpha:] =\"]*) xlink:href=/<set\1 xlinkDeactivated=/" $i
 sed -ri "s/<(d:testDescription) ([[:alnum:]:\"=\/. ]*)href=\"([[htp\.\/]]*)/<\1 \2hrefDeactivated=\"\3/" $i
 sed -ri "s/<image xlink:href=\"data:image\/svg\+xml;base64,/<image xlinkhref=\"data:image\/svg+xml;base64,/" $i
 sed -ri "s/@import url\(([[:lower:]\.\/\"]*)([-[:alnum:]\/\.#\"]*)\)/Deactivated urlDeactivated\(\1\2\)/" $i
 sed -ri "s/(src:|@import) url\(([[:lower:]\.\/\"]*)([-[:alnum:]\/\.#\"]*)\)/\1 urlDeactivated\(\2\3\)/" $i
 sed -ri "s/ xlink:href=\"url\(\#([[:alpha:]]*)\)\"/ xlink:href=\"\#\1\"/" $i
 sed -ri "s/<script/<Deactivatedscript/g" $i
 sed -ri "s/<\/script>/<\/Deactivatedscript>/g" $i
 sed -ri "s/[[:blank:]]on([[:lower:]]+)=(\"|')([[:alpha:]]+[[:alnum:]_,' \(\)\.#;]*)/ deactivatedon\1=\2\3/g" $i
fi

if [ $SvgoSvgo = 'YES' ]; then
 echo runSvgoSvgo,JK YN $SvgoSvgo, i $i ,ii $i2
 sed -n '1p' $i > foobar169.del
 svgo -i $i -o $i2 -p 5 --pretty --indent=1 --multipass  > foobar170.del
 svgo -i $i -o $i2 -p 5 --pretty --indent=1 --multipass  &> foobar171.del
 sed -n '1p' $i > foobar172.del
 sed -n '1p' $i2 > foobar173.del
 cp $i file.svg
 rm $i
 mv $i2 $i
fi

if [ $validValid = 'YES' ];
 then
 export scour
 echo runScourScour,JK $ScourJK, YN $ScourScour, i $i ,ii $i2
 #rm tmp.svg
 if [ $PC = WikiMedia ]; then
  /data/project/svgworkaroundbot/prgm2/pythonJK/PythonIn/bin/python3.7 -m scour.scour -i $i -o $i2 --keep-unreferenced-defs --remove-descriptions --strip-xml-space  --set-precision=6 --indent=space --nindent=1 --renderer-workaround --set-c-precision=6 --protect-ids-noninkscape  --disable-simplify-colors  --keep-editor-data
 else
  python3 -m scour.scour -i $i -o $i2 --keep-unreferenced-defs --remove-descriptions --strip-xml-space  --set-precision=6 --indent=space --nindent=1 --renderer-workaround --set-c-precision=6 --protect-ids-noninkscape  --disable-simplify-colors  --keep-editor-data
 fi
 #sed -n '1p' $i2 > foobar119
 python3 ./FFlow2TextBySed.py $i2 $i3
 #sed -n '1p' $i3 > foobar121
 rm $i
 mv $i3 $i
else
 if [ $ScourScour = 'YES' ];
 then
  export scour
  echo runScourScour,JK $ScourJK, YN $ScourScour, i $i ,ii $i2
  #rm tmp.svg  # /data/project/svgworkaroundbot/prgm2/pythonJK/PythonIn/bin/python3.7 -m scour.scour -i
  cp $i l200.svg
  sed -n '1p' $i > foobar201
  if [ $PC = WikiMedia ]; then
   sed -n '1p' $i > foobar203
   /data/project/svgworkaroundbot/prgm2/pythonJK/PythonIn/bin/python3.7 -m scour.scour -i $i -o $i2 --keep-unreferenced-defs --remove-descriptions --strip-xml-space  --set-precision=6 --indent=space --nindent=1 --renderer-workaround --set-c-precision=6 --protect-ids-noninkscape  --disable-simplify-colors  --keep-editor-data
   sed -n '1p' $i2 > foobar205
  else
   sed -n '1p' $i > foobar152.del
   python3 -m scour.scour -i $i -o $i2 --keep-unreferenced-defs --remove-descriptions --strip-xml-space  --set-precision=6 --indent=space --nindent=1 --renderer-workaround --set-c-precision=6 --protect-ids-noninkscape  --disable-simplify-colors  --keep-editor-data
   sed -n '1p' $i2 > foobar154.del
  fi
  cp $i2 l210.svg
  python3 ./FFlow2TextBySed.py $i2 $i3
  #sed -n '1p' $i3 > foobar133
  rm $i
  mv $i3 $i
  cp $i l214.svg
 else
  echo no ScourScour $ScourScour
 fi
fi


   ## invalid file

#W3C (SVG1.1)  there is no attribute "href"
#W3C (SVG1.1) Error: required attribute "xlink:href" not specified
#CorelDraw-Problem (not very common)
#https://commons.wikimedia.org/wiki/File:IIIIER.svg
#https://commons.wikimedia.org/wiki/File:Eliandthethirteenthconfession_logo.svg
sed -i "s/ href=\"/  xmlns:xlink=\"http:\/\/www.w3.org\/1999\/xlink\" xlink:href=\"/g" $i

if [ $SVGCleaner = 'YES' ]; then
 echo runsvgcleaner $SVGCleaner
 svgcleaner $i $i2 --allow-bigger-file --indent 1 --resolve-use no --apply-transform-to-gradients yes --apply-transform-to-shapes yes --convert-shapes yes --group-by-style no --join-arcto-flags no --join-style-attributes no --merge-gradients yes --regroup-gradient-stops yes --remove-comments no --remove-declarations no --remove-default-attributes yes --remove-desc yes --remove-dupl-cmd-in-paths yes --remove-dupl-fegaussianblur yes --remove-dupl-lineargradient yes --remove-dupl-radialgradient yes --remove-gradient-attributes yes --remove-invalid-stops yes --remove-invisible-elements no --remove-metadata no --remove-needless-attributes yes --remove-nonsvg-attributes no --remove-nonsvg-elements no --remove-text-attributes no --remove-title no --remove-unreferenced-ids no --remove-unresolved-classes yes --remove-unused-coordinates yes --remove-unused-defs yes --remove-version yes --remove-xmlns-xlink-attribute yes --simplify-transforms yes --trim-colors yes --trim-ids no --trim-paths yes --ungroup-defs yes --ungroup-groups no --use-implicit-cmds yes --list-separator comma --paths-to-relative yes --remove-unused-segments yes --convert-segments yes --apply-transform-to-paths no --coordinates-precision 2 --paths-coordinates-precision 5 --properties-precision 3 --transforms-precision 7 #--copy-on-error
 rm $i
 mv $i2 $i
else
 echo no SVGCleaner $SVGCleaner
fi
if [ $validValid = 'YES' ]; then
 svgcleaner $i $i2 --allow-bigger-file --indent 1 --remove-nonsvg-attributes yes --remove-nonsvg-elements yes --remove-version yes --remove-text-attributes yes --remove-needless-attributes yes --resolve-use no --apply-transform-to-gradients yes --apply-transform-to-shapes yes --convert-shapes yes --group-by-style no --join-arcto-flags no --join-style-attributes no --merge-gradients yes --regroup-gradient-stops yes --remove-comments yes --remove-declarations no --remove-default-attributes yes --remove-desc yes --remove-dupl-cmd-in-paths yes --remove-dupl-fegaussianblur yes --remove-dupl-lineargradient yes --remove-dupl-radialgradient yes --remove-gradient-attributes yes --remove-invalid-stops yes --remove-invisible-elements yes --remove-metadata no --remove-title yes --remove-unreferenced-ids yes --remove-unresolved-classes yes --remove-unused-coordinates yes --remove-unused-defs yes --remove-xmlns-xlink-attribute yes --simplify-transforms yes --trim-colors yes --trim-ids yes --trim-paths yes --ungroup-defs yes --ungroup-groups yes --use-implicit-cmds yes --list-separator comma --paths-to-relative yes --remove-unused-segments yes --convert-segments yes --apply-transform-to-paths no --coordinates-precision 2 --paths-coordinates-precision 5 --properties-precision 3 --transforms-precision 5
 mv $i2 $i
fi

#remove useless metadata
sed -i "s/<metadata id=\"metadata8\">  <rdf:RDF>  <cc:Work rdf:about=\"\">  <dc:format>image\/svg+xml<\/dc:format>  <dc:type rdf:resource=\"http:\/\/purl.org\/dc\/dcmitype\/StillImage\"\/>  <dc:title\/>  <\/cc:Work>  <\/rdf:RDF>  <\/metadata>//" $i


#Remove CDATA by AdobeIllustrator
sed -ri -e ':a' -e 'N' -e '$!ba' -e "s/<\!\[CDATA\[([[:alnum:]=+\/\t\n[:space:]@:;\(\)\"\,\'\{\}\-])*\t\]\]>[[:space:]]*//g" $i #Remove CDATA
sed -ri -e ':a' -e 'N' -e "s/<i:pgf[[:lower:] =\"_]*>[[:space:][:alnum:]\/=\+]*<\/i:pgf>//" $i #Remove AI-Elemtents for CDATA

#remove jpg im metadata
sed -ri -e ':a' -e 'N' -e '$!ba' -e "s/<xapGImg:image>([[:alnum:][:space:]\/+])*={0,2}[[:space:]]*<\/xapGImg:image>//g" $i

## == unsave uploads
#https://commons.wikimedia.org/wiki/Commons:Help_desk#Found_unsafe_CSS_in_the_style_element_of_uploaded_SVG_file
sed -i "s/src: url(\"data:font\/woff;charset=utf-8;base64,data:application\/x-font-ttf;base64,AAEAAAAQAQAABAAAR[[:alnum:]+\/]*\");//" $i

## == Workarounds for Librsvg ==

#Repair WARNING in <mask> with id=ay: Mask element found with maskUnits set. It will not be rendered properly by Wikimedia's SVG renderer. See https://phabricator.wikimedia.org/T55899 for details
#copied from svg2validsvg
sed -ri "s/<mask([-[:alnum:]_ =\".]*) maskUnits=\"userSpaceOnUse\"([[:alnum:]=_\". ]*)>/<mask\1\2>/g" $i

#Change spaces to , in stroke-dasharray (solves librsvg-Bug https://phabricator.wikimedia.org/T32033 )
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\.,]*)([[:digit:]\.]+) ([[:digit:]\., ]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i
sed -ri 's/stroke-dasharray=\"([[:digit:]\., ]*)([[:digit:]\.]+) ([[:digit:]\.,]+)\"/stroke-dasharray=\"\1\2,\3\"/g' $i

#Change "'font name'" to 'font name'(solves librsvg-Bug) https://commons.wikimedia.org/wiki/File:T184369.svg
sed -ri "s/font-family=\"'([-[:alnum:] ]*)'(|,[-[:lower:]]+)\"/font-family=\'\1\'/g" $i

# multiple x-koordinates https://phabricator.wikimedia.org/T35245
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =\(\)]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =\,:\\]*)>([[:alnum:]])/<tspan x=\"\2\" \1 \5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i # splits multipe x-koordinates in seperate tspan (solves librsvg-Bug)
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =\(\)]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =\,:\\]*)>/<tspan x=\"\2\"\1\5>/g" $i # reduce multipe x-koordinates in text to the first (solves librsvg-Bug)

sed -ri "s/<text([-[:alnum:]\.\"\#\ =\(\)]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =\,:\\\(\)]*)>/<text x=\"\2\"\1\5>/g" $i # remove multipe x-koordinates in text (solves librsvg-Bug)
sed -ri "s/<text([-[:alnum:]\.\"\#\ =\(\)]*) y=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =\,:\\\(\)]*)>/<text y=\"\2\"\1\5>/g" $i # remove multipe y-koordinates in text (solves librsvg-Bug)




#Repair https://phabricator.wikimedia.org/T68672 (solves librsvg-Bug)
#from svg2validsvg
sed -ri "s/<style( id=\"[[:alnum:]]*\"|)>/<style type=\"text\/css\"\1>/" $i

#solved librsvg-Bug T193929 https://phabricator.wikimedia.org/T193929
sed -i "s/ xlink:href=\"data:image\/jpg;base64,/ xlink:href=\"data:image\/jpeg;base64,/g" $i
sed -i "s/ xlink:href=\"data:;base64,\/9j\/4AAQSkZJRgABA/ xlink:href=\"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABA" $i
sed -ri "s/ xlink:href=\"data:;base64,( |)iVBORw0KGgoAAAANSUhEUgAA/ xlink:href=\"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAA/" $i

#solved librsvg-Bug T194192 https://phabricator.wikimedia.org/T194192
sed -ri "s/<svg([-[:alnum:]=\" ]*) viewBox=\"0,0,([[:digit:]\.]*),([[:digit:]\.]*)\"/<svg\1 viewBox=\"0 0 \2 \3\"/g" $i

#librsvgbug https://phabricator.wikimedia.org/phab:T207506 (<code>font-weight="normal"</code> ignored)
sed -ri "s/font-weight=\"normal\"/font-weight=\"400\"/g" $i

#https://commons.wikimedia.org/wiki/File:Wikidata_stamp.svg
sed -i 's/="RGB(/="rgb(/g' $i

if [ $T35245tspan = 'YES' ]; then
# remove multipe x-koordinates in tspan (solves librsvg-Bug)
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
sed -ri "s/<tspan([-[:alnum:]\.\"\#\ =]*) x=\"([-[:digit:]\.]+)( |,)([-[:digit:]\. ,]+)\"([-[:alnum:]\.\"\#\ =]*)>([-[:alnum:] \'\+=\.\%\(\)→\/])/<tspan x=\"\2\"\1\5>\6<\/tspan><tspan x=\"\4\"\1\5>/g" $i
fi

## useless

  #remove useless/empty metadata
#W3C: element "rdf:RDF" undefined
#Nu: Warning: This validator does not validate RDF. RDF subtrees go unchecked.
# use scour/svgcleaner/svgo or https://de.wikipedia.org/wiki/Benutzer:Marsupilami/Inkscape-FAQ#Wie_erstelle_ich_eine_Datei_die_dem_Standard_SVG_1.1_entspricht?
#copied form validbySed
sed -ri -e ':a' -e 'N' -e '$!ba' -e "s/[[:space:]\r\n]*<rdf:RDF>[[:space:]\r\n]*<cc:Work( rdf:about=\"\"|)>[[:space:]\r\n]*<dc:format>image\/svg\+xml<\/dc:format>[[:space:]\r\n]*<dc:type rdf:resource=\"http:\/\/purl.org\/dc\/dcmitype\/StillImage\"\/>([[:space:]\r\n]*<dc:title\/>|)[[:space:]\r\n]*<\/cc:Work>[[:space:]\r\n]*<\/rdf:RDF>//" $i
sed -i -e ':a' -e 'N' -e '$!ba' -e "s/<metadata id=\"metadata[[:digit:]]*\">[[:space:]\r\n]*<\/metadata>//" $i


#W3C: Error: there is no attribute "sodipodi:version"
#W3C: Error: element "sodipodi:namedview" undefined
#W3C: Error: element "inkscape:perspective" undefined
#W3C: Error:  there is no attribute "inkscape:collect"
#W3C: Error: there is no attribute "sodipodi:cx"
#W3C: Error: there is no attribute "inkscape:label"
#W3C: Error:  there is no attribute "sodipodi:nodetypes"
#Nu: Warning: This validator does not validate Inkscape extensions properly. Inkscape-specific errors may go unnoticed.
# use scour/svgcleaner --remove-nonsvg-attributes yes --remove-nonsvg-elements yes/svgo
   sed -i "s/<sodipodi:namedview id=\"namedview[[:digit:]]*\" bordercolor=\"#666666\" borderopacity=\"1\" gridtolerance=\"10\" guidetolerance=\"10\" inkscape:current-layer=\"svg[[:digit:]]*\" inkscape:cx=\"[[:digit:].]*\" inkscape:cy=\"[-[:digit:].]*\" inkscape:pageopacity=\"0\" inkscape:pageshadow=\"2\" inkscape:window-height=\"480\" inkscape:window-maximized=\"0\" inkscape:window-width=\"640\" inkscape:window-x=\"0\" inkscape:window-y=\"0\" inkscape:zoom=\"0.[[:digit:]]*\" objecttolerance=\"10\" pagecolor=\"#ffffff\" showgrid=\"false\"\/>//" $i

   ## invalid file

## fonts
sed -ri 's/ font-family=\"(Times New Roman)\"/ font-family=\"Liberation Serif,\1\"/g' $i #as automatic

if [ $kerningKerning = 'YES' ]; then
# ./T36947kerning.sh
	#put viewBox at the beginning (otherwise I will have a variable to less)
	sed -ri 's/<svg([-[:alnum:]=\" \.\/:\,\(\)_#]+) viewBox="([-[:digit:] \.]+)"([-[:alnum:]=\" \.\/:\,\(\);#]*)>/<svg viewBox="\2"\1\3>/' $i
	sed -ri 's/\r/\n/g' $i

    #Define file as a variable
    export h=$(sed -r 's/<svg viewBox="([-[:digit:]]+) ([-[:digit:]]+) ([[:digit:]]+)\.([[:digit:]])([[:digit:]]*) ([[:digit:]]+)\.([[:digit:]])([[:digit:]]*)"([-[:alnum:]=\" \.\/:\,\(\)_;]+)>/<svg viewBox="\1 \2 \3\4.\50 \6\7.\80"\9><g transform="scale(10)">/' $i)

    #Reading out the relevant line
    export j=$(ls -l|grep -E "viewBox=\"[-[:digit:].]{1,8} [-[:digit:].]{1,8} [[:digit:].]{2,11} [[:digit:].]{2,11}" $i)

    #Insert a special character to define the point of splitting
    export l=$(echo $j | sed -e "s/viewBox=\"/>/g" )

    #split at this special character and take the part afterwards
    export m=$(echo $l | cut -f2 -d">")

    #Multiply the four numbers by a factor of 10
    export n=$(echo $m | awk  '{printf "%f %f %f %f\n",$1*10,$2*10,$3*10,$4*10}')

    #Replace the old four numbers with the new four numbers
    sed -ri "s/<svg([-[:alnum:]=\" \.\/:;\,#]*) viewBox=\"[-[:digit:]\.]+ [-[:digit:]\.]+ [[:digit:]\.]+ [[:digit:]\.]+\"([-[:alnum:]=\" \.\/:\,#\(\)_;]+)>/<svg\1 viewBox=\"$n\"\2>\n<g transform=\"scale(10)\">/" $i
 #----

  sed -ri 's/<\/svg>/<\/g>\n<\/svg>/' $i
fi

# ---- END ----

cp -f $i $2

#cp $i Output226.svg

# python /data/project/shared/pywikipedia/core/scripts/upload.py $i -keep -ignorewarn -noverify -descfile WorkaroundBotsvg2validsvg.sh

# rm $i

