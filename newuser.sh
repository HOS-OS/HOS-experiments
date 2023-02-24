#!/bin/bash
# by Hunter Null
# clone a user
# usage:
# if you named this as below then
# change to the directory and run this command
# sudo bash clone-user.sh

echo "============="
echo "this script will create a new user"
echo "based on an existing user profile"
echo " you will need to be root to run this script"
echo
echo "This will download a preconfigerd user profile"
echo "You will be asked for the new user's name, their password"
echo "============="
echo
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username"
		[ $? -eq 0 ] && clear; echo "The user profile configuration file needs to be Downloaded:"; read -rsp $'Press any key to allow the download or ctrl-c to exit...\n' -n1 key ||clear; echo "Failed to add a user! Please check if user is already added or you are root user to run this script."
	fi
	echo "Downloading user profile configuration: ";
	git clone https://github.com/HOS-OS/HOS-newusers.git;
	cd /home/$USER/HOS-newusers/;
	unzip backup.zip;
	cd /home/$USER/HOS-newusers/backup;
	cp -r /home/$USER/HOS-newusers/backup/\. /home/$username;
	chown -R $username:$username /home/$username;
	usermod -aG sudo $username ; 
	clear;
	echo "Done!!!!";
	echo "Do you see your new users name below?";
	echo;
	awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd;
	echo;
	read -rsp $'If the new user is present, press any key to continue' -n1 key;
	echo;
	echo "-------------------";
	echo "Cleaning up system:";
	echo "-------------------";
	rm -rf /home/$USER/HOS-newusers/;
	echo ;
	clear;
	echo "---------------------------------------------";
	echo "Done!!!!!!";
	echo "You can logout and see your new user profile";
	echo "---------------------------------------------";
	read -rsp $'Press any key to exit...\n' -n1 key



else
	echo "Only root may add a user to the system"
	exit 2
fi
