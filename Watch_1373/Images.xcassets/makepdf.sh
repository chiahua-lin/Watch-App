# brew install svg2pdf

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
    size="${BASH_REMATCH[2]}"
    echo Processing $f, name $name, size $size
    mkdir SVG-${name}.imageset
    svg2pdf -w $size -w $size $f > SVG-${name}.imageset/$name.pdf
    cat << EOF > SVG-${name}.imageset/Contents.json
{
  "images" : [
    {
      "idiom" : "universal",
      "filename" : "$name.pdf"
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

