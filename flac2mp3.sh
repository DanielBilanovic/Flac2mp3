#!/usr/bin/env zsh
# $1: Source Directory (aka where the FLACs are)
# $2: Destination Directory (aka where the mp3s will be)

# Check if lame is installed and in PATH
if ! command -v lame > /dev/null 2>&1 ; then
    echo "lame is needed to convert, but it could not be found.
    Please install lame or add its location to your path and rerun the script!"
    exit 1
fi

# Check if $2 has a trailing slash, and if so remove it
BASEOUTDIR=$2
if [[ $BASEOUTDIR[-1] = "/" ]] then
    BASEOUTDIR=${BASEOUTDIR:0:-1}
fi

# Create target directories exactly as in the source
DIRECTORIES=("${(@f)$(find $1 -type d)}")
for i in $DIRECTORIES ; do
    mkdir -p "$BASEOUTDIR/$i"
done

# Find all files and edit filename
ALLFILES=("${(@f)$(find $1 -type f -name "*.flac")}")

# Encode
for i in $ALLFILES ; do
    ARTIST=`metaflac --show-tag=ARTIST $i | sed "s/^.*=//g"`
    DATE=`metaflac --show-tag=DATE $i | sed "s/^.*=//g"`
    ALBUM=`metaflac --show-tag=ALBUM $i | sed "s/^.*=//g"`
    TRACKNUMBER=`metaflac --show-tag=TRACKNUMBER $i | sed "s/^.*=//g"`
    TRACKNUMBER=$TRACKNUMBER/`metaflac --show-tag=TRACKTOTAL $i | sed "s/^.*=//g"`
    TITLE=`metaflac --show-tag=TITLE $i | sed "s/^.*=//g"`
    GENRE=`metaflac --show-tag=GENRE $i | sed "s/^.*=//g"`

    TEMP=$i:gs/.flac/
    lame --preset insane --id3v2-only --ta "$ARTIST" --ty "$DATE" --tl "$ALBUM" --tn "$TRACKNUMBER" --tt "$TITLE" --tg "$GENRE" "$TEMP.flac" "$BASEOUTDIR/$TEMP.mp3"
done

