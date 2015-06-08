# brew cask install xquartz && brew install librsvg

# Remove all prior generated SVG imagesets
rm -rf SVG-*.imageset

# Capture filename and base size
# For example, AppIcon_29.svg will be created as SVG-AppIcon.imageset with sizes 29, 58, 87
regex="([A-Za-z0-9_]+)_([0-9]+).svg"

for f in $( ls SVGSource/*.svg ); do

  [[ $f =~ $regex ]]
  name="${BASH_REMATCH[1]}"

  # If SVG filename doesn't match regex, whine
  if [ "$name" == "" ]; then
    echo Unable to parse SVG filename $f
  else # Otherwise compute sizes and generate
    size1x="${BASH_REMATCH[2]}"
    size2x=`expr $size1x \* 2`
    size3x=`expr $size1x \* 3`
    echo Processing $f, name $name, sizes $size1x, $size2x, $size3x
    mkdir SVG-${name}.imageset
    rsvg-convert -h $size1x $f > SVG-${name}.imageset/$name.png
    rsvg-convert -h $size2x $f > SVG-${name}.imageset/$name@2x.png
    rsvg-convert -h $size3x $f > SVG-${name}.imageset/$name@3x.png
    cat << EOF > SVG-${name}.imageset/Contents.json
{
  "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x",
      "filename" : "$name.png"
    },
    {
      "idiom" : "universal",
      "scale" : "2x",
      "filename" : "$name@2x.png"
    },
    {
      "idiom" : "universal",
      "scale" : "3x",
      "filename" : "$name@3x.png"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}

EOF
  fi

done

