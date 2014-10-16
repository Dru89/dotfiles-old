#!/bin/env zsh
DIRECTORY=$(echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" | sed 's:/$::')
ME=$DIRECTORY/$(basename $0)

find $DIRECTORY -type f | grep -Pv "(?:.git/|$ME)" | perl -pe "s:\Q$DIRECTORY\E/?::" | while read FILENAME; do
    DIRNAME=$(dirname $FILENAME | sed "s:^\.$::")
    OUTFILE=$(echo $FILENAME | sed "s:\<$DIRECTORY\>::")
    if [ ! -z $DIRNAME ]; then
        if [ ! -d $DIRNAME ]; then
            mkdir -p "$HOME/$DIRNAME"
        fi
    fi
    if [ ! -f "$HOME/$OUTFILE" ]; then
        ln -s $DIRECTORY/$FILENAME "$HOME/$OUTFILE"
    else
        read -q "OVERWRITE?$HOME/$OUTFILE already exists.  Would you like to overwrite it? (y/N)"
        if [[ ($OVERWRITE == y* || $OVERWRITE == Y*) ]]; then
            echo " ... overwriting"
            rm "$HOME/$OUTFILE"
            ln -s $DIRECTORY/$FILENAME "$HOME/$OUTFILE"
        else
            echo " ... not overwriting"
        fi
    fi
done
