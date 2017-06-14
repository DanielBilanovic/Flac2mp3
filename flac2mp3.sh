#!/usr/bin/env zsh
# $1: Source Directory (aka where the FLACs are)
# $2: Destination Directory (aka where the mp3s will be)

# TODO: Get id3 tag from directories and files

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
    TEMP=$i:gs/.flac/
    lame --preset insane "$TEMP.flac" "$BASEOUTDIR/$TEMP.mp3"
done
