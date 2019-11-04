#!/bin/bash

for Y in {2015..2019}; do
    for m in {1..12}; do
        for d in {1..31}; do
            DATE="$(printf "%04d%02d%02d\n" $Y $m $d)"
            case $(LC_ALL=C date -d $DATE 2>&1) in
                Sat* | Sun* )
                    echo $DATE
                    ;;
            esac
        done
    done
done | tac |
    while read date; do
        echo "http://keiba.cc/racelist/${date}/" >&2
        curl -s "http://keiba.cc/racelist/${date}/" |
            grep -o 'result/[0-9]*' |
            sort | uniq |
            grep "${date}" |
            sed 's#result/##g'
    done
