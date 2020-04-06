# FFMPEG-M3U8-list-to-MP4
A simple bash script that reads a file with the title and url of the videos desired to be downloaded and then saves them as MP4.
=======

It's quite easy to use!
First, save a text file with all the file names and links you wish to download each in a line. e.g:

FOLDER=folder_name_1 [OPTIONAL]
file_name1
url1
file_name2
url2
file_name3
url3
FOLDER=folder_name_2
file_name_4
url4
...

=========
Then open it in shell like this: ffmpeg-m3u8-mp4.sh read_filename optional_outputfolder optional_number_prefix(-y, -n)"