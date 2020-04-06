#!/bin/bash
# M3U8 PLAYLIST DOWNLOADER
# BY https://github.com/vitutiv
declare -a lines # Array that stores each line of the file as a string.
line_count=0 # Content Line (Name, URL) Count
conversion_count=0 # Conversion Count
folder_delimiter="FOLDER=" # This pattern tells the program the output folder for the next files
output_folder="" # The output folder name for the next files is saved here

if [[ -z "$1" ]];
then

    echo "Usage: $0 read_filename optional_outputfolder optional_numbering(-y, -n)"

else

    echo "" >> "$1" # Inserts a new line on the file to avoid glitches
    
	while IFS= read -r line; # Read each line of the given file and store in an array
    do
        
		lines[$line_count]="$line"
        line_count=$(($line_count+1))

    done < "$1"
    
	line_count=0 # Reset line count
    filename="" # Reset file name

    for line in "${lines[@]}"; #Read each line of the array
    do
		filepath="" # Reset file path
		
		if [[ "$line" =~ ^"$folder_delimiter" ]]; # If a line has an output folder, save the new files in it
		then

			output_folder=$(echo $line | cut -f2 -d=)
			echo "Folder changed to: $output_folder"
			conversion_count=0
		elif [[ ! -z "$line" ]]; # If a line has a non-empty string, work on it
		then

			if (( "$line_count" % 2 )); # If the line count is odd (should contain an URL), save it to the previously read filename
			then

				if [[ ! -z "$2" ]]; # If the user sent a folder as an argument, it'll be used as a parent folder
				then

					if [[ ! -d "$2" ]]; # Create parent folder if it does not exist
					then
						mkdir "$2"
					fi

					if [[ ! -d "$2/$output_folder" ]]; #Create output folder if it does not exist
					then
						mkdir "$2/$output_folder"
					fi

					filepath=$filepath"$2/$output_folder/" #Set the file path

				else
					
					if [[ ! -d "$output_folder" ]];
					then

						mkdir "$output_folder"

					fi

					filepath=$filepath"/$output_folder/"

				fi

				conversion_count=$(($conversion_count+1))
				
				if [[ ! -z "$3" ]]; then

					filepath="$filepath$conversion_count. "

				fi
				
				filepath=$filepath$filename
				
				echo "Saving in: $filepath.mp4"
				echo "Please wait..."
				#echo $(ffmpeg -y -i "$line" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "$filepath".mp4 -hide_banner -loglevel panic) #This line is what makes all the magic happen :O
				echo $(ffmpeg -y -i "$line" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "$filepath".mp4) #This line is what makes all the magic happen :O
				echo "Done! Check if the file was created because I'm too lazy to check it for you."
				echo "----------------------------"
			
			else # else, store the line as a file name
			
				filename="$line"
			
			fi
			
			line_count=$(($line_count+1)) #increment line count
		
		fi
    
	done

fi