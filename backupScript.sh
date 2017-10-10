#!/bin/bash
#Purpose = Backup of Important Data
#Created on 10-02-2017
#Author = Smruti Ranjan
#Version 1.0
#START
 
app_name=   XYZ      # your App name 
backup_dir=/home/smruti/allBackups	
backup_filename=$app_name-backup-`date +%Y-%m-%d`
backup_filename_tar="$backup_filename".tar.gz
app_home=/var/lib/tomcat7/webapps/ehr
app_filename_tar=XYZ.tar
 
# Print status
echo "Backing up $appname..."
 
echo "Archiving Client Registry Software"
cd $app_home
tar cf $backup_dir/$app_filename_tar .
 
cd $backup_dir
 
# Backup all the things - config files and databases
#---------------------------------------------------
 
# Backup the Postgress database
db_user="root"           # your databse username
db_password="root"       # your database  password
db_name="abcd"           # your  database name

backup_filename_sql=$backup_filename".sql"

export PGPASSWORD=$db_password
echo "Backing up the Database Instance for App_Home into $backup_filename_sql"
/usr/bin/mysqldump -u $db_user -p$db_password $db_name > $backup_filename_sql

# Archive all the things
#-----------------------
echo "Archiving the dabatase backup and App software distribution"
cd $backup_dir
tar czf $backup_filename_tar $backup_filename_sql  $app_filename_tar
 
# Cleanup
#--------
 
# Clean up file that aren't needed here...
echo "Cleaning up backup file in $backup_dir/$backup_filename_sql"
rm $backup_dir/$backup_filename_sql $backup_dir/$app_filename_tar 
 
# Finalise
 
# Print status
echo "Done backing up $app_name."
 
# Display created backup file
echo "Created backup file: " $backup_filename_tar " in " $backup_dir
 
# Copy to off site server 
# If you want to store in another server for safety.
remote_user="username"    
remote_pass="password"
remote_host="www.xyz.com"
remote_dir="/home/username"
# scp $backup_dir/$backup_filename_tar $remote_user@$remote_host:$remote_dir            #uncomment it if you need 
echo "Copied backup file to remote server: " $backup_filename_tar
 
# Cleanup old backup files
# - keep previous 30 days backups and the backup from the first of every month
find $backup_dir -name "$app_name-backup-*" -mtime +10 -not -name "$app_name-backup*-01.tar.gz" -exec rm {} \;
