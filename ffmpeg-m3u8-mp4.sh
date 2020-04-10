#!/bin/bash
# M3U8 2 MP4 PLAYLIST DOWNLOADER
# BY https://github.com/vitutiv
readonly folder_delimiter="FOLDER=" # This constant tells the program the output folder for the next files
readonly url_delimiter="http"
listfile_name_argument=$1 # The playlist file (or * for all txt files in folder)
parent_folder_argument=$2 # The parent folder is specified by the user when calling the script
numeric_prefix_argument=$3 # Wheter the file names will have a numeric prefix on them
beep_option_argument=$4 # Stores the beep option
beep_interval_argument=$5 #Stores the interval between beeps
url="" # This variable stores the file url
line_count=0 # Content Line (Name, URL) Count
conversion_count=0 # Number of files converted
error_count=0
alert_color=`tput setaf 3` # Yellow
error_color=`tput setaf 1` # Red
success_color=`tput setaf 2` # Green
no_color=`tput sgr0` # No Color
output_path="" # This variable is a string that stores the output file path.
output_folder="" # The output folder name for the next files is saved here
output_file_name="" #The output file name

declare -a line_array # Array that stores each line of the file as a string.

make_dir_if_not_exists() { # Creates the folder if it doesnt exist
	if [[ ! -d "$output_path" ]]; # Create folder if it does not exist
	then
		mkdir "$output_path"
	fi
}

check_if_downloaded_file_exists(){
	if [[ -f $output_path ]];
	then
		echo "$success_color""File Downloaded Successfully!""$no_color"
	else
		echo "$error_color""Error in Download! Please try another URL.""$no_color"
		error_count=$(($error_count+1))
	fi
}

savefile() { # Saves the file in the desired path

	echo "Saving in: $output_path.mp4"
	echo "Please wait..."
	echo $(ffmpeg -y -i "$url" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "$output_path".mp4 -hide_banner -loglevel panic) # -loglevel panic This line is what makes all the magic happen :O
	check_if_downloaded_file_exists
	echo "----------------------------"

}

read_lines_from_list_file() { # Reads each line of the list file and store it in the array

	listfile_name="$1"
 	line_count=0
	echo "" >> "$listfile_name" # Inserts a new line on the file to avoid glitches
    
	while IFS= read -r line; # Read each line of the given file and store in an array
    do
        if [[ ! -z $line ]];
		then
			line_array[$line_count]="$line"
			line_count=$(($line_count+1))
		fi
    done < "$listfile_name"

}

build_file_path(){ # Store the output file path string

	parent_folder=$parent_folder_argument
	output_path=""

	if [[ ! -z "$parent_folder" ]]; # If the user sent a folder as an argument, it'll be used as a parent folder
	then

		output_path="$output_path""$parent_folder" # Add parent folder name to the path string
		make_dir_if_not_exists # Create parent folder if it does not exist	
		output_path="$output_path/"
		
	fi

	if [[ ! -z "$output_folder" ]]; # If a folder was read inside the file, it'll be used as the child (output) folder
	then

		output_path="$output_path""$output_folder" # Add output folder name to the path string		
		make_dir_if_not_exists # Create output folder if it does not exist
		output_path="$output_path/"

	fi

	if [[ "$numeric_prefix_argument" == "y" || "$numeric_prefix_argument" == "-y" ]]; then # If the numeric prefix is enabled add it to path string

		output_path="$output_path""$conversion_count. "

	fi

	output_path="$output_path""$output_file_name" # Add file name to output path

	#echo "OUTPUT FILE NAME: $output_file_name"	#"DEBUGGING" PURPOSES
	#echo "OUTPUT FOLDER: $output_folder"
	#echo "PARENT FOLDER: $parent_folder"
	#echo "OUTPUT PATH: $output_path"

}

convert() { # Method that triggers all the file conversion related methods
	
	line_count=0 # Reset line count
    file_name=$1 # Set file name to the argument
	read_lines_from_list_file "$file_name"

    for line in "${line_array[@]}"; #Read each line of the array
    do

		if [[ ! -z "$line" ]]; # If a line has a non-empty string, work on it
		then
				
			if [[ "$line" =~ ^"$folder_delimiter" ]]; # If a line has an output folder, save the new files in it
			then

				output_folder=$(echo $line | cut -f2 -d=)
				echo -e "$alert_color""FOLDER CHANGED TO $output_folder""$no_color"
				conversion_count=0

			elif [[ "$line"  =~ ^"$url_delimiter" ]]; # If the line count is odd (should contain an URL), save it to the previously read file name
			then

				conversion_count=$(($conversion_count+1))
				url="$line" # URL
				build_file_path # Sets the output_file_path variable
				savefile  # Saves the file

			else # else, store the line as a file name
				output_file_name="$line"
			fi
			
			line_count=$(($line_count+1)) #increment line count

		fi
    
	done

}

if [[ -z "$listfile_name_argument" ]]; #IF the user doesnt give even the first argument, show how to use
then

    echo "Usage: $0 read_filename optional_outputfolder optional_numbering(-y, -n)"

elif [[ "$listfile_name_argument" == "-all" ]]; #IF the file name argument is "-all", open each file on folder
then

	for file in *.txt; do

		echo "=========================================="
		echo "$alert_color""PLAYLIST OPEN: ""$file""$no_color"
		echo "=========================================="
		convert "$file"

	done

else #Else, just convert the single file name

	convert "$listfile_name_argument"
	
fi

if [[ "$error_count" -eq 0 ]]; 
then #Show finished message according to error count
	echo "$success_color""Download finished! All files downloaded.""$no_color"
else

	echo "$warning_color""Download finished with warnings! ""$error_count "" tasks of ""$conversion_count"" failed.""$no_color"

fi

if [[ -z "$beep_option_argument" || "$beep_option_argument" != "-nobeep" ]]; #If user doesnt ask for "nobeep" on argument 4, make the beep noise after all conversions are finished
then

	if [[ "$beep_option_argument" == "-singlebeep" ]];
	then
		echo -ne '\007'
	elif [[ -z "$beep_option_argument" || "$beep_option_argument" == "-repeat" ]];
	then
		while [[ $1 == $1 ]]; 
		do
			echo -ne '\007'
			if [[ ! -z "$beep_interval_argument" ]];
			then
				sleep "$beep_interval_argument"
			else
				sleep 5
			fi
		done
	fi

fi