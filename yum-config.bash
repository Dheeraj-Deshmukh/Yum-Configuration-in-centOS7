#!/bin/bash
# file name     : yum-config.bash
# last modified : 27 Aug 2020
# Topic         : Yum Configuration in Centos-7 (online/offline)
#		*	run this script to configure yum
#		*	you can configure yum online or offline both from this script
#		*	run this script as root user
#		*	you can use iso file or any bootable media to configure offline yum
#
#
USER=$(whoami) #to check that the user is root or not
if [[ $USER != root ]] ; then
	echo
	echo "cant run this scrip with normal user"
	echo
	echo "Please switch to root user and run again this script..."
	echo
	sleep 1
	exit 
fi
select VAR in "yum_offline" "yum_online" "exit" #first select loop for yum online or offline configuration
do
	case $VAR in 
		yum_offline)  #for yum offline configuration
			echo "yum offline configuration will start soon....."
			sleep 1
			echo
			echo "---Press Ctrl-D to go back"
			echo
			select VAR2 in "You have ISO file" "You Dont have ISO file" "Exit" #second select loop to know user have iso or not
			do
				case $VAR2 in
					"You have ISO file")
						echo "Enter location of your iso file  :  "
						read x
						echo $x | grep iso
						if [ $? -ne 0 ];then
        						echo "Please Enter Valid iso file"
        						exit 1
						fi
						mount -t iso9660 $x /mnt
						cd /
						mkdir centos7
						cp -vr /mnt/* /centos7
						umount /mnt
						mkdir /home/repo
						cp /etc/yum.repo.d/* /home/repo
						cd /centos7/Packages
						rpm -ivh createrepo-0.9.9-28.el7.noarch.rpm
						createrepo --database /centos7/Packages
						cd /etc/yum.repos.d/
						echo "[centos-7]
						name=Centos7 Everything
						baseurl=file:/centos7
						gpgcheck =0" >> centoss7.repo
						cd
						yum repolist all
						echo
						echo "OFFLINE YUM CONFIGURATION COMPLETED !!"
						echo
						shift
					;;
					"You Dont have ISO file")
						echo "We have another option"
						sleep 1
						echo
						echo "---Press Ctrl-D to go back"
						echo
						select VAR3 in "You have bootable USB or CD" "YOU dont have any bootable media" "Exit" #third select  loop to know that you have bootable media or not
						do
							case $VAR3 in
								"You have bootable USB or CD") #extract iso from bootable media and configure yum
									echo "Enter location of your iso file  :  "
									read x
									df -h | grep $x
									if [ $? -ne 0 ];then #to check location is correct or not
        									echo " Please enter Correct location"
        									exit 2
									fi
									dd if=$x of=/home/Centos7-Everything.iso #extract iso file from bootable media
									mount -t iso9660 /home/Centos7-Everything.iso /mnt
			                                                cd /
        			                                        mkdir centos7
                	        		                        cp -vr /mnt/* /centos7
                        	                		        umount /mnt
                      			          	                mkdir /home/repo
                           			             	        cp /etc/yum.repo.d/* /home/repo
                                   			     	        cd /centos7/Packages
			                                                rpm -ivh createrepo-0.9.9-28.el7.noarch.rpm
									createrepo --database /centos7/Packages
			                                                cd /etc/yum.repos.d/
                        			                        echo "[centos-7]
									name=Centos7 Everything
									baseurl=file:/centos7
									gpgcheck =0" >> centoss7.repo
                                                			cd
                                              				yum repolist all
                                             				echo
                                            				echo "OFFLINE YUM CONFIGURATION COMPLETED !!"
                                             				echo
									shift
								;;
								"YOU dont have any bootable media")
										echo "Unable to configure.."
										echo ".....Sorry......Please select Exit"
										shift
								;;
								Exit)
									echo " GOOD BYE !!"
									exit
								;;
							esac
						done # third loop complete
						shift
					;;
					Exit)
						echo " GOOD BYE !!"
						exit
					;;
				esac
			done #second loop complete
		shift
		;;
		yum_online) # yum configuration via online 
			echo "Your Online Yum Configuration will start soon....."
			sleep 1
			echo
			echo "---Press Ctrl-D to go back"
			echo
			echo "==> select the option to configure online yum"
			select VAR4 in "epel" "rpmfusion" "remi" "elrepo" "all"
			do
				case $VAR4 in
					epel)
						echo
						echo "epel yum configuration starting....."
						sleep 1
						wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
						yum -y install epel-release-latest-7.noarch.rpm
						yum repolist all
						echo
						echo "Online epel Yum Configuration Completed..!"
						echo
						shift
						;;
					rpmfusion)
						echo
						echo "rpmfusion yum configuration starting....."
						sleep 1
						wget https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
						yum -y install rpmfusion-free-release-7.noarch.rpm
						yum repolist all
						echo
						echo "Online rpmfusion yum  configuration Completed..!"
						echo
						shift
						;;
					remi)
						echo
						echo "Online remi yum configuration starting...."
						sleep 1
						wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
						yum -y install remi-release-7.rpm
						yum repolist all
						echo
						echo "Online remi yum configuration Completed..!"
						echo
						shift
						;;
					elrepo)
						echo
						echo "Online elrepo yum configuration starting..."
						sleep 1
						wget https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
						yum install elrepo-release-7.el7.elrepo.noarch.rpm
						yum repolist all
						echo
						echo "Online elrepo yum configuration Completed..!"
						echo
						shift
						;;
					all)
						echo
						echo "Online all yum configuration will satarting soon ...."
						sleep 1
						wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
						yum -y install epel-release-latest-7.noarch.rpm
						wget https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
						yum -y install rpmfusion-free-release-7.noarch.rpm
						wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
						yum -y install remi-release-7.rpm
						wget https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
						yum -y install elrepo-release-7.el7.elrepo.noarch.rpm
						yum repolist all
						echo
						echo "Thank You For Waiting...."
						echo
						echo "Online yum configuration Completed..!"
						echo
						;;
				esac
			done
			shift
		;;
		exit)
                        echo "Have a nice Day..."
                        exit
                ;;

		*)
			echo "INVALID OPTION SELECTED...."
		;;

	esac
done
