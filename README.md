# FFMPEG-M3U8-list-to-MP4
A simple bash script that reads a file with the title and url of the videos desired to be downloaded and then saves them as MP4.
=======

It's quite easy to use!
First, save a text file with all the file names and links you wish to download each in a line. e.g:
-----

FILE1
URL1
FILE2
URL2
FILE3
URL3

----
YOU CAN SET FOLDERS TOO! THIS WAY:
-----

FOLDER1=FOLDER_NAME1
FILE1
URL1
FILE2
URL2
FOLDER=FOLDER_NAME2
FILE3
URL3

-----

This program ignores empty lines, so you don't need to worry if your file looks like this:
------

FOLDER1=FOLDER_NAME1
FILE1
URL1

FILE2

URL2
FOLDER=FOLDER_NAME2

FILE3

URL3

-----

Finally, after saving your list file, you can run the script on the linux shell:
-----

FFMPEG-M3U8-list-to-MP4.sh inputfilename.txt parentfolder(optional) numberedfiles(optional, -y OR -n)

------
It only works if you have FFMPEG installed.
