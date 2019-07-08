#!/bin/bash

# sessions="$(lsof -Pi | grep ":22")" # to show domain
sessions="$(lsof -i :22 -n)" # to show ip

if [ -n "$sessions" ]; then
    count=$(($(echo "$sessions" | wc -l)-1))
    result="%{F#30a9de}%{F-} $count%{F#0ff}/ %{F-}"
    for i in $(echo "$sessions" | cut -d ">" -f 2 | cut -d " " -f 1 | cut -d ":" -f 1)
    do
        if [ $i != "COMMAND" ]; then
            result=$result$i"%{F#0ff}/ %{F-}"
        fi
    done
    echo $result
else
    echo ""
fi
