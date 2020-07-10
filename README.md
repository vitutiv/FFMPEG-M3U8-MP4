# FFMPEG-M3U8-list-to-MP4
A simple bash script that reads a file with the title and url of the videos desired to be downloaded and then saves them as MP4.
---

It's quite easy to use!
A list file example named "list_file_example" is included with the project
---
Then open it in shell like this:

$ ffmpeg-m3u8-mp4.sh "LIST_FILE" "PARENT_OUTPUT_FOLDER" ( -prefix | -noprefix ) ( -nobeep | -singlebeep | -repeatbeep "TIME_IN_SECONDS" )

Example:

$ ffmpeg-m3u8-mp4.sh downloadlist.txt \videos\downloads\ -prefix -repeatbeep 5