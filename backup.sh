#!/bin/bash
# !NOTE: Setup cronjob following this shit https://www.geeksforgeeks.org/how-to-setup-cron-jobs-in-ubuntu/

TG_BOT="" # Bot Token
TG_GROUP_ID="" # Group id for backup
FILE_NAME="BACKUP$(date +"%Y%m%d-%H%M")"

echo "Starting backup..."

# Do something here...
# Move all backup files to data directory


# Zipping data in data folder
echo "Zipping backup files"
# Split backup file by 49MB because telegram allow upload file upto 50MB
zip -s 49m -r "$FILE_NAME.zip" "data"

curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": "'$TG_GROUP_ID'", "text": "#'"$FILE_NAME"'"}' \
     https://api.telegram.org/bot$TG_BOT/sendMessage > /dev/null

echo "Uploading files to telegram"

for FILE in "$FILE_NAME"*; do
    echo "Upload $FILE"

    curl -F document=@"$FILE" https://api.telegram.org/bot$TG_BOT/sendDocument?chat_id=$TG_GROUP_ID > /dev/null
done


echo "Uploaded success $(ls -1q "$FILE_NAME"* | wc -l) files"

echo "Remove files"
rm "$FILE_NAME"*

echo "Done!"
