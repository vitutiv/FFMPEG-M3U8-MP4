#!/bin/bash
#M3U8 PLAYLIST DOWNLOADER
#BY VITUTIV.GITHUB.IO
#NO RIGHTS RESERVED
if [ -z "$1" ];
then
    echo "Usage: $0 read_filename optional_outputfolder optional_numbering(-y, -n)"
else
    declare -a lines
    line_count=0
    conversion_count=0
    echo "" >> "$1"
    while IFS= read -r line; 
    do
        lines[$line_count]="$line"
        line_count=$(($line_count+1))
    done < "$1"
    line_count=0
    filename=""
    for line in "${lines[@]}";
    do
        if (( $line_count % 2 ));
        then
            filepath=""
            if [ ! -z "$2" ];
            then
                if [ ! -d "$2" ];
                then
                    mkdir "$2"
                fi
                filepath=$filepath"$2/"
            fi
            conversion_count=$(($conversion_count+1))
            if [ ! -z "$3" ]; then
                filepath="$filepath$conversion_count. "
            fi
            filepath=$filepath$filename
            echo "Saving in: $filepath"
            echo "Please wait..."
            echo $(ffmpeg -y -i "$line" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "$filepath".mp4 -hide_banner -loglevel panic)
            echo "Done! Please check if the file was created."
            echo "----------------------------"
        else
            filename="$line"
        fi
        line_count=$(($line_count+1))
    done
fi