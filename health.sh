#!/bin/bash


HEALTH_LOG="Health_log.txt"
RECOMMENDATIONS=""

print_menu(){
echo "Select health checks:"
echo "1. Disk Space"
echo "2. Memory Usage"
echo "3. Running Services"
echo "4. Recent System Updates"
echo "5. Print recommendations"
echo "6. Exit"
}

check_disk_space(){
echo "Disk space check completed."	
df -h 	
df -h >> "$HEALTH_LOG"
}

check_memory_usage(){
echo "Memory usage check completed."
free -m	
free -m >> "$HEALTH_LOG"

available_memory=$(free -m | awk 'NR==2{print $7}')
if [ "$available_memory" -lt 100 ]; 
then
	RECOMMENDATIONS+="Recommendation: Low available memory. Upgrade RAM.\n"
fi	
}

check_running_services(){
echo "Running services check completed."	
systemctl list-units --type=service --state=running
systemctl list-units --type=service --state=running >> "$HEALTH_LOG"

running_services=$(systemctl list-units --type=service --state=running --no-legend | wc -l)
if [ "$running_services" -gt 10 ];
then
        RECOMMENDATIONS+="Recommendation: High number of services running. Optimize services.\n"
fi

}

check_system_updates(){
echo "System updates check completed."
if command -v apt $> /dev/null;
then
	apt list --upgradable
	apt list --upgradable >> "$HEALTH_LOG"
elif command -v yum &> /dev/null;
then
	yum list updates
	yum list updates >> "$HEALTH_LOG"
else
	echo "Unsupported package manager. Unable to check System updates."
return
fi

}

print_recommendations(){
echo -e "Displaying available recommendations:"
if [ -z "$RECOMMENDATIONS" ];
then
	echo "No recommendations. Everything looks good!!"
else
	echo -e "$RECOMMENDATIONS"
fi	
}

while true; do
	print_menu
	read -p "Enter your (1-6): " choice

	case $choice in
		1)
			check_disk_space
			;;
		2)
			check_memory_usage
			;;
		3)
			check_running_services
			;;
		4)
			check_system_updates
			;;

		5)	print_recommendations
			;;

		6)
			echo "Exiting..."
			exit 0
			;;
		*)
			echo "Invalid option. Enter an option between 1 and 5"
			;;
	esac

done