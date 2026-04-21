#!/bin/bash

URL="$1"

if [ -z "$URL" ]; then
    echo "Usage: $0 <calendar_ics_url>" >&2
    exit 1
fi

curl -Ls "$URL" | tr -d '\r' | awk -F: '
BEGIN{
    print "["
    first=1
}

/BEGIN:VEVENT/{
    title=""
    start=""
    end=""
}

$1=="SUMMARY"{
    title=$2
}

$1~/DTSTART/{
    match($2,/([0-9]{6})$/,a)
    start=a[1]
}

$1~/DTEND/{
    match($2,/([0-9]{6})$/,a)
    end=a[1]
}

/END:VEVENT/{
    if(title!=""){
        if(!first) printf(",\n")
        first=0
        printf "{\"title\":\"%s\",\"start\":\"%s\",\"end\":\"%s\"}",title,start,end
    }
}

END{
    print "\n]"
}
'