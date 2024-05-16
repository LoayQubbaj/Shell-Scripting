#!/bin/bash

LOG_FILE="backup_log.txt"
print_menu(){
 echo "Select :"
 echo "1. Run Backup"
 echo "2. Check Backup Status"
 echo "3. Check Backup Size"
 echo "4. Exit"
}

run_backup(){
 echo "Backup started at $(date)" >> "$LOG_FILE"
if [ "$#" -gt 0 ];
 then
	if tar -cvzf backedUp_files.tar "$@" >> "$LOG_FILE" 2>&1;
 then
 	echo "Backup completed successfully."
	echo "Backup completed successfully." >> "$LOG_FILE"
 else
 	echo "Error during backup. Check the log file for more details."
 fi
else
       echo "Please enter at least one directory to backup" >> "$LOG_FILE"
fi       
}
check_backup_status(){
 echo "Backup Status:"
 cat "$LOG_FILE"
 echo
}

check_backup_size(){
 echo "Size of the backup:"
 if [ -f "backedUp_files.tar" ];
 then
	 du -h backedUp_files.tar | cut -f1
else
	echo "Backup file not found."
 fi
echo 
}

while true; do
	print_menu
	read -p "Enter your choice : " choice
	case $choice in
		1)
			read -p "Enter the directory to backup: " backup_directory
			run_backup "$backup_directory"
			;;
		2)
			check_backup_status
			;;
		3)
			check_backup_size
			;;
		4)
			echo "Exiting..."
			exit 0
			;;
		*)
			echo "Invalid input, Enter a value between 1 and 4."
			;;
	esac
	
done