Needed to write a multiplatform (should work on both windows and linux) powershell script that takes 2 parameters -InputDirectory and -OutputDirectory as input. The script should find all files in the InputDirectory and subdirectories and generate a report in any text format containing the top 10 largest file types by extensions, sorted by total size in descending order. Report example:

Extension    Summary Value in Mb
.mkv            21210
.avi              15787
.zip             12747
.rar             1347
.mp3          1187
.psd            989
.bmp          900
.gz             812
.jpg           784
no_extenstion 20

When the script finishes, the report should go to the directory specified in the OutputDirectory parameter

# example
.\sort_files_by_type.ps1 C:\Users\User\Desktop\test C:\Users\User\Desktop
