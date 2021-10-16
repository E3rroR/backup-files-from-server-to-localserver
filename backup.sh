#!/bin/bash
	if [ -z `which sshpass` ]; then
			sudo apt-get install sshpass -y
	fi
# Save-log
savelog=0
logfile="rsync-log.txt"

#Config
passwd=""
user=""
host=""
sciezkaremotez="" # (folder/file) to backup
sciezkalocalsave="" # save (local)

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

# Script
echo -e "$COL_GREEN Started backup$COL_RESET"
DATE="`date +%Y-%m-%d-%H-%M`"
sshpass -p $passwd ssh $user@$host tar -cvf /home/$user/latestbackup.tar $sciezkaremotez
echo -e "$COL_GREEN Downloading from host $host $COL_RESET"
if [ "$savelog" -eq "1" ]; then
touch $logfile
sshpass -p $passwd rsync -avz --progress --log-file=$logfile $user@$host:/home/$user/latestbackup.tar $sciezkalocalsave/backup-$DATE.tar
else
    sshpass -p $passwd rsync -avz $user@$host:/home/$user/latestbackup.tar $sciezkalocalsave/backup-$DATE.tar
fi
sshpass -p $passwd ssh $user@$host rm /home/$user/latestbackup.tar
echo -e "$COL_GREEN Backup ended at$COL_MAGENTA $DATE $COL_RESET"
