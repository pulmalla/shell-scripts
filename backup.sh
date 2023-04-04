#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1] set variables to command arguments
targetDirectory=$1
destinationDirectory=$2

# [TASK 2] print directory paths to user
echo "The target directory is $targetDirectory"
echo "The destination directory is $destinationDirectory"

# [TASK 3] set currentTS variable to current timestamp, in seconds
currentTS=`date +%s`

# [TASK 4] set backupFileName using timestamp
backupFileName="backup-$currentTS.tar.gz"

# [TASK 5] define origAbsPath directory
origAbsPath=`pwd`

# [TASK 6] define destAbsPath directory
cd $destinationDirectory
destAbsPath=`pwd`

# [TASK 7] change cwd to target directory
cd $origAbsPath
cd $targetDirectory

# [TASK 8]  set yesterdayTS to 24 hours before currentTS
yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in $(ls) # [TASK 9] list all files and directories
do
  # [TASK 10] check if file was updated in the past 24 hours
  if ((`date -r $file +%s` > $yesterdayTS))
  then 
    # [TASK 11] add the name of files updated within last 24 hours to the toBackup array
    toBackup+=($file)
  fi
done

# [TASK 12] create archived and compressed backup file containing all files in toBackup

tar -czvf $backupFileName ${toBackup[@]}

# [TASK 13] move the backup file to destination directory

mv $backupFileName $destAbsPath

