#!/bin/bash

mkdir -p raws
for raceId in $(cat races.txt); do

    URL="http://keiba.cc/result/${raceId}?all=1"
    HTML="raws/${raceId}.html"
    echo $HTML >&2

    if [ ! -s $HTML ]; then
        curl -s "$URL" > $HTML
    fi

    TAN_ODDS=$(
        cat $HTML | grep -A 20 "<tr class=.win.>" |
            grep '<td>[0-9]' | sed 's/<.?td>//g' | grep -o '[0-9]*\.[0-9]' | tac |
            tr '\n' , | sed 's/,$//g'
    )

    RENPUKU_ODDS=$(
        cat $HTML |
            grep -A 5 '→[0-9]*→' |
            grep 円 | grep -o '[0-9][0-9,]*' | head -1 | tr -d , |
            awk '{printf "%.2f", ($1/100)}'
    )

    ORDER=$(
        cat $HTML | sed 's/\r//g' |
            grep -A 900 "headlineB" | grep '<td' | awk 'NR % 10 == 3' | grep '<td>[0-9][0-9]*</td>' | sed 's/\t*//g; s/<td>//g; s/<.td>//g; s/^ *//g' |
            tr '\n' ',' | sed 's/,$//g'
    )

    printf "%s\t%s\t%s\t%s\n" $raceId ${TAN_ODDS} ${RENPUKU_ODDS} $ORDER

done
