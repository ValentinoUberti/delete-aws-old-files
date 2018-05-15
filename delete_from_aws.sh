#!/bin/bash
export AWS_ACCESS_KEY_ID=######                                                                           
export AWS_SECRET_ACCESS_KEY=######                                                           
export AWS_DEFAULT_REGION=######
MY_BUCKET="######"
ENDPOINT="######"

#filelist as an array
filelist=($(aws --endpoint-url=$ENDPOINT s3 ls $MY_BUCKET | sort | awk '{print $1";"$4}'))

for fileinfo in "${filelist[@]}"
    do
      
      info=($(echo $fileinfo | tr ";" "\n"))
      date_to_check="${info[0]}"
      file_name="${info[1]}"      
      seconds_to_check=$(date -d "$date_to_check" +%s)
      seconds_14_days_ago=$(date --date="13 day ago" +%s)
     
      #seconds_to_check="${seconds_to_check//[$'\t\r\n ']}" 
      


      if [ "$seconds_to_check" -lt "$seconds_14_days_ago" ]; then
         echo "Deleting file $file_name"
         file_to_delete=$MY_BUCKET$file_name
         echo $file_to_delete
         cmd=$(aws --endpoint-url=$ENDPOINT s3 rm s3://$file_to_delete)
         echo $cmd
      fi      


      
    done
