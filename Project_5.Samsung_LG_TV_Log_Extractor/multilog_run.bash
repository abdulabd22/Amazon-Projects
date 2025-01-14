#! /bin/bash


pd=$( pwd )
sdb_path="${pd}"


linux_sdb_path=$( echo "$sdb_path" | sed 's/\\/\//g' | sed 's/://' )

echo ${linux_sdb_path}



touch  tmp.txt 2>&1
rm reboot_lg.sh  reboot_sam.sh root_on_sam.sh root_on_lg.sh kill_sam.sh kill_lg.sh logrun_lg1.sh logrun_lg2.sh  logrun_lg3.sh logrun_lg5.sh logrun_lg6.sh logrun1.sh logrun2.sh  logrun3.sh logrun4.sh  logrun5.sh   >tmp.txt 2>&1


read -p "Type TV IP addess and then enter: " ip_address
read -p "Type 1 for Samsung (or) 2 for LG : " tv_type


	
	
	if [[ ${tv_type} -eq 1 || ${tv_type} == 1 ]]; then
	
		tv="samsung"
		#sdb connect ${ip_address}
		#echo "Connect devices"
		#sdb devices -l
		
	elif [[ ${tv_type} -eq 2 || ${tv_type} == 2 ]]; then
	
		tv="LG"
		#ssh root@${ip_address}
		#echo "Connect devices"
		#ssh devices -l
	
		
	fi

	

samsung_logs()
{
	

if [[ ${tv} == "samsung" ]]; then


				echo ${tv}
		
				rm logrun1.sh > tmp.txt 2>&1
				touch  logrun1.sh > tmp.txt 2>&1
				echo "#! /bin/bash -l">logrun1.sh
				
				echo "export PATH=\"$PATH:${linux_sdb_path}\"">>logrun1.sh
				echo "sdb connect ${ip_address}" >>logrun1.sh
				echo "sdb root on" >>logrun1.sh
				echo "echo 'DR1_screen_Full.log is running'">>logrun1.sh
				echo "sdb -s ${ip_address} shell \"dlogutil -v threadtime alexa-client ALEXA_FULLAPP MVA_VIEWER Starfish >> /tmp/DR1_screen_Full.log\"" >> logrun1.sh
				echo "trap 'sdb -s ${ip_address} pull //tmp/DR1_screen_Full.log ./${folder}' SIGINT SIGHUP EXIT " >>logrun1.sh
		        start logrun1.sh
				sleep 1.5s
			   
			
			
				rm logrun2.sh > tmp.txt 2>&1
				touch  logrun2.sh > tmp.txt 2>&1
				echo "#! /bin/bash -l">logrun2.sh
				echo "export PATH=\"$PATH:${linux_sdb_path}\"">>logrun2.sh
				echo "sdb connect ${ip_address}" >>logrun2.sh
				echo "sdb root on" >>logrun2.sh
				echo "echo 'DR2_starfish.log is running'">>logrun2.sh
				echo "sdb -s ${ip_address} shell \"dlogutil -v kerneltime alexa-client MVA_VIEWER Starfish | grep console >> /tmp/DR2_starfish.log\"" >> logrun2.sh
				echo "trap 'sdb -s ${ip_address}  pull //tmp/DR2_starfish.log ./${folder}' SIGINT SIGHUP EXIT " >> logrun2.sh
				start logrun2.sh
				sleep 1.5s
				
			
			
				rm logrun3.sh > tmp.txt 2>&1
				touch  logrun3.sh > tmp.txt 2>&1
				echo "#! /bin/bash -l">logrun3.sh
				echo "export PATH=\"$PATH:${linux_sdb_path}\"">>logrun3.sh
				echo "sdb connect ${ip_address}" >>logrun3.sh
				echo "sdb root on" >>logrun3.sh
				echo "echo 'DR3_Chromium_full.log is running'">>logrun3.sh
				echo "sdb -s ${ip_address} shell \"dlogutil -v threadtime alexa-client ALEXA_FULLAPP CHROMIUM CHROMIUM_NETWORK >> /tmp/DR3_Chromium_full.log\"" >> logrun3.sh
				echo "trap 'sdb -s ${ip_address} pull //tmp/DR3_Chromium_full.log ./${folder}' SIGINT SIGHUP EXIT " >> logrun3.sh	
				start logrun3.sh
				sleep 1.5s
				
			
				rm logrun4.sh > tmp.txt 2>&1
				touch  logrun4.sh  > tmp.txt 2>&1
				echo "#! /bin/bash -l">logrun4.sh
				echo "export PATH=\"$PATH:${linux_sdb_path}\"">>logrun4.sh
				echo "sdb connect ${ip_address}" >>logrun4.sh
				echo "sdb root on" >>logrun4.sh
				echo "echo 'DR4_testclientfull.log is running'">>logrun4.sh
				echo "sdb -s ${ip_address} shell \"dlogutil TEST_CLIENT alexa-client ALEXA_FULLAPP >> /tmp/DR4_testclientfull.log\"" >> logrun4.sh
				echo "trap 'sdb -s ${ip_address} pull //tmp/DR4_testclientfull.log ./${folder}' SIGINT SIGHUP EXIT " >> logrun4.sh
				start logrun4.sh
				sleep 1.5s
				
			
					
				rm logrun5.sh > tmp.txt  2>&1
				touch  logrun5.sh > tmp.txt 2>&1
				echo "#! /bin/bash -l">logrun5.sh
				echo "export PATH=\"$PATH:${linux_sdb_path}\"">>logrun5.sh
				echo "sdb connect ${ip_address}" >>logrun5.sh
				echo "sdb root on" >>logrun5.sh
				echo "echo 'DR5_native.log is running'">>logrun5.sh
				echo "sdb -s ${ip_address} shell \"dlogutil alexa-client >> /tmp/DR5_native.log\"" >> logrun5.sh
				echo "trap 'sdb  -s ${ip_address} pull //tmp/DR5_native.log ./${folder}' SIGINT SIGHUP EXIT " >> logrun5.sh
				start logrun5.sh
				sleep 1.5s
				
		
fi


}



reboot_device()
{

if [[ ${tv} == "samsung" ]]; then

		rm reboot_sam.sh > tmp.txt 2>&1
		touch  reboot_sam.sh > tmp.txt 2>&1
		echo "#! /bin/bash -l">reboot_sam.sh 
		echo "export PATH=\"$PATH:${linux_sdb_path}\"">>reboot_sam.sh
		echo "echo 'Rebooting ${tv} Device'">>reboot_sam.sh 
		echo "sdb connect ${ip_address}" >>reboot_sam.sh 
		echo "sdb root on" >>reboot_sam.sh
		echo "echo 'Rebooting Device'">>reboot_sam.sh 
		echo "sdb -s ${ip_address} shell \"reboot\"" >> reboot_sam.sh 
		start reboot_sam.sh

elif [[ ${tv} == "LG" ]]; then

	
	rm reboot_lg.sh > tmp.txt 2>&1
	touch  reboot_lg.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">reboot_lg.sh
	echo "echo 'Rebooting ${tv} Device'">>reboot_lg.sh  
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} '/sbin/reboot'" >> reboot_lg.sh 
	start reboot_lg.sh



fi


}

root_on()
{



if [[ ${tv} == "samsung" ]]; then
	
	rm root_on_sam.sh > tmp.txt 2>&1
	touch  root_on_sam.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">root_on_sam.sh
	echo "export PATH=\"$PATH:${linux_sdb_path}\"">>root_on_sam.sh 
	echo "sdb connect ${ip_address}" >>root_on_sam.sh 
	echo "sdb root on" >>root_on_sam.sh 
	start root_on_sam.sh

elif [[ ${tv} == "LG" ]]; then

	
	rm root_on_lg.sh > tmp.txt 2>&1
	touch  root_on_lg.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">root_on_lg.sh
	echo "echo 'Rooting ${tv} Device'">>root_on_lg.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address}" >> root_on_lg.sh 
	start root_on_lg.sh

fi



}


kill_logs()
{

if [[ ${tv} == "samsung" ]]; then

	rm kill_sam.sh > tmp.txt 2>&1
	touch   kill_sam.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">kill_sam.sh
	echo "export PATH=\"$PATH:${linux_sdb_path}\"">>kill_sam.sh
	echo "echo 'Killing logs in ${tv} Device'">>kill_sam.sh	
	echo "sdb connect ${ip_address}" >>kill_sam.sh
	echo "sdb root on" >>kill_sam.sh	
	echo "sdb -s ${ip_address} shell \"pidof alexa-client | xargs kill -9\"" >> kill_sam.sh
	start kill_sam.sh
	
	
	
	
elif [[ ${tv} == "LG" ]]; then

	
	rm kill_lg.sh > tmp.txt 2>&1
	touch   kill_lg.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">kill_lg.sh
	echo "echo 'Killing logs in ${tv} Device'">>kill_lg.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} \"/usr/sbin/ls-monitor -l | grep amazon | tr -s ' ' | cut -d' ' -f1  |  xargs kill ; exit\"" >>kill_lg.sh
	start kill_lg.sh 

fi



}

install_apk()
{


	read -p "drag and drop the file path: " filepath
	rm install_apk_sam.sh > tmp.txt 2>&1
	touch   install_apk_sam.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">install_apk_sam.sh
	echo "export PATH=\"$PATH:${linux_sdb_path}\"">>install_apk_sam.sh
	echo "echo 'Installing apk in ${tv} Device'">>install_apk_sam.sh	
	echo "sdb connect ${ip_address}" >>install_apk_sam.sh
	echo "sdb root on" >>install_apk_sam.sh	
	echo "echo 'Started installing apk'" >>install_apk_sam.sh
	echo "sdb -s ${ip_address} install '${filepath}'" >> install_apk_sam.sh
	echo "echo 'Checking apk version'" >>install_apk_sam.sh
	echo "sdb -s ${ip_address} shell \"pkgcmd -l | grep alexa\"" >> install_apk_sam.sh
	
	echo "read -p 'press any key to exit: ' tmp" >> install_apk_sam.sh
	start install_apk_sam.sh
	

}


uninstall_apk()
{

	rm uninstall_apk_sam.sh > tmp.txt 2>&1
	touch   uninstall_apk_sam.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">install_apk_sam.sh
	echo "export PATH=\"$PATH:${linux_sdb_path}\"">> uninstall_apk_sam.sh
	echo "echo 'Uninstalling apk in ${tv} Device'">> uninstall_apk_sam.sh	
	echo "sdb connect ${ip_address}" >> uninstall_apk_sam.sh
	echo "sdb root on" >> uninstall_apk_sam.sh	
	echo "sdb -s ${ip_address} uninstall com.samsung.tv.alexa-client" >> uninstall_apk_sam.sh
	echo "read -p 'press any key to exit: ' tmp" >> uninstall_apk_sam.sh
	start uninstall_apk_sam.sh

}

create_json()
{

	rm AlexaConfig.json > tmp.txt 2>&1
	touch   AlexaConfig.json > tmp.txt 2>&1
	echo  "{" > AlexaConfig.json
	
	if [[ ${gamma_beta} -eq 1 || ${gamma_beta} == 1 ]]; then
		echo "\"AppStage\": \"GAMMA\"," >> AlexaConfig.json
	else
	
		echo "\"AppStage\": \"BETA\"," >> AlexaConfig.json
	fi
	
    echo "\"TokenUpgradeASAP\": true">> AlexaConfig.json
	echo "}" >> AlexaConfig.json
   
   
}

gamma_beta_setup()
{

	create_json
	rm gamma_beta.sh > tmp.txt 2>&1
	touch   gamma_beta.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l">    gamma_beta.sh
	echo "export PATH=\"$PATH:${linux_sdb_path}\"">> gamma_beta.sh
	echo "echo 'Gamma/Beta setup in ${tv} Device'">> gamma_beta.sh	
	echo "sdb connect ${ip_address}" >> gamma_beta.sh
	echo "sdb root on" >> gamma_beta.sh
	echo "sdb -s ${ip_address} push  AlexaConfig.json '//opt\\usr\\home\\owner\\apps_rw\\com.samsung.tv.alexa-client\\res\\'" >> gamma_beta.sh
	echo "sdb -s ${ip_address} shell \"cat //opt\\usr\\home\\owner\\apps_rw\\com.samsung.tv.alexa-client\\res\\ \"" >> gamma_beta.sh
	echo "read -p 'press any key to exit: ' tmp" >> gamma_beta.sh
	
	start gamma_beta.sh
	read -p "Wait for a time: " tmp 


}


lg_operations()
{

if [[ ${tv} == "LG" ]]; then

 if [[ ${lg_option} -eq 1 || ${lg_option} == 1 ]]; then
	
	#device - tail logs
	
	echo "${tv}"
	rm logrun_lg1.sh > tmp.txt 2>&1
    touch  logrun_lg1.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l" >logrun_lg1.sh
	echo "echo 'Device - tail log is running'">>logrun_lg1.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} 'rm file1.log'" >> logrun_lg1.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} 'tail -f /media/internal/avs/AlexaApplication.log  | tee file1.log'" >> logrun_lg1.sh
	
	echo "trap 'scp -oHostKeyAlgorithms=+ssh-rsa -O root@${ip_address}:/home/root/file1.log ./${folder}/' SIGINT SIGHUP EXIT  " >> logrun_lg1.sh
	start logrun_lg1.sh
	

 
 
  
 elif [[ ${lg_option} -eq 3 || ${lg_option} == 3 ]]; then
 
	
	#Crash Logs
	echo "${tv}"
	rm logrun_lg3.sh > tmp.txt 2>&1
    touch  logrun_lg3.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l" >logrun_lg3.sh
	echo "echo 'Crash log is running'">>logrun_lg3.sh
	
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} 'collect_alllogs.sh /tmp/crashLogs'" >> logrun_lg3.sh
	echo "scp -oHostKeyAlgorithms=+ssh-rsa -O root@${ip_address}:/tmp/crashLogs.tgz ./ " >> logrun_lg3.sh
	start logrun_lg3.sh
	
	
elif [[ ${lg_option} -eq 4 || ${lg_option} == 4 ]]; then
	
	#LG - Device/Application Logs
	echo "${tv}"
	rm logrun_lg4.sh > tmp.txt 2>&1
    touch  logrun_lg4.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l" >logrun_lg4.sh
	echo "echo 'Grepping Device/Application Logs'">>logrun_lg4.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} 'rm /media/internal/avs/AlexaApplication.log '" >> logrun_lg4.sh
	echo "scp -oHostKeyAlgorithms=+ssh-rsa -O root@${ip_address}:/media/internal/avs/AlexaApplication.log ./ " >> logrun_lg4.sh
	start logrun_lg4.sh
 
 
 elif [[ ${lg_option} -eq 5 || ${lg_option} == 5 ]]; then
 
	#LG - Adapter command
	
	rm logrun_lg5.sh > tmp.txt 2>&1
    touch  logrun_lg5.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l" >logrun_lg5.sh
	echo "echo 'Initializing Alexa App via adapter command'">>logrun_lg5.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} '/usr/sbin/amazon-alexa-adapter'" >> logrun_lg5.sh
	start logrun_lg5.sh
 
 
 
 
 
  elif [[ ${lg_option} -eq 6 || ${lg_option} == 6 ]]; then
 
    #LG - ssh keygen command
	
	echo "${tv}"
	rm logrun_lg6.sh > tmp.txt 2>&1
    touch  logrun_lg6.sh > tmp.txt 2>&1
	echo "#! /bin/bash -l" >logrun_lg6.sh
	echo "echo 'Running  ssh-keygen -R ${ip_address} command'">>logrun_lg6.sh
	echo "ssh-keygen -R  ${ip_address}" >> logrun_lg6.sh
	start logrun_lg6.sh
 
 
 
  elif [[ ${lg_option} -eq 7 || ${lg_option} == 7 ]]; then
 
    #LG - .so file mounting
	echo "${tv}"
	echo "#! /bin/bash -l" >logrun_lg7.sh
	echo "read -p 'After moving files to pendrive, inject into the TV - then enter any key to start installing .so files: ' new" >> logrun_lg7.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} 'touch /var/luna/preferences/devmode_enabled; sync; touch /var/luna/preferences/debug_system_apps; sync; touch /var/luna/preferences/debug_system_apps; sync;'" >> logrun_lg7.sh
	echo "echo 'Killing Amazon Adapter command'">> logrun_lg7.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} 'pidof amazon-alexa-adapter | xargs kill -9 >tmp.txt 2>&1 '" >> logrun_lg7.sh
	echo "echo 'Started installing .so files'">> logrun_lg7.sh
	
	
	read -p "press 1 for single file (or) any key  for multiple files - then enter " option_mount
	
	
	if [[ ${option_mount} -eq 1 || ${option_mount} == 1 ]]; then
	
			read -p "After inserting pendrive into LG , type the file name and then enter " file_name
			echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address}  \"mount --rbind '/tmp/usb/sda/sda1/myLocalLib/${file_name}' '/usr/lib/${file_name}' \"" >> logrun_lg7.sh

	else
	
		echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} 'array=\$( ls /tmp/usb/sda/sda1/myLocalLib | xargs -n 1 basename ); for f in \${array} ; do mount --rbind /tmp/usb/sda/sda1/myLocalLib/\$f /usr/lib/\$f; done'">> logrun_lg7.sh
	
	fi	
	
	
	
	
	echo "echo 'Injecting Alexa Adapter command'">> logrun_lg7.sh
	echo "ssh -oHostKeyAlgorithms=+ssh-rsa root@${ip_address} '/usr/sbin/amazon-alexa-adapter'" >> logrun_lg7.sh
	echo " read -p 'enter any key to exit: ' new" >> logrun_lg7.sh
	start logrun_lg7.sh
 
 fi
 
 

else

	echo "Cannot Run logs as TV type specified is in 'Samsung'"



fi

}


trap 'rm reboot_lg.sh  reboot_sam.sh root_on_sam.sh root_on_lg.sh kill_sam.sh kill_lg.sh logrun_lg1.sh logrun_lg2.sh  logrun_lg3.sh logrun_lg5.sh logrun_lg6.sh  logrun_lg7.sh logrun1.sh logrun2.sh  logrun3.sh logrun4.sh  logrun5.sh   uninstall_apk_sam.sh install_apk_sam.sh gamma_beta.sh >tmp.txt 2>&1; exit' SIGINT SIGHUP EXIT 



options=( "Samsung_logs" "LG_Tail_Logs" "LG_Crash_Logs"  "LG_Device/Application_Logs" "LG_Adapter_Command" "LG_keygen_command" "LG_Mounting_command" 
"Samsung_install_apk" "Samsung_uninstall_apk" "Samsung_Beta_setup" "Samsung_Gamma_setup"  "Reboot_LG/Samsung" "Root_Device_LG/Samsung" "Kill_Command_LG/Samsung" "Quit" )

printf "\n"

exitcheck=0


while true
do

	PS3="Choose the option(number) and Enter: "
	select option in ${options[@]}
	do
		
	printf "\n"
	case ${option} in
	"Samsung_logs" )
	
		read -p "Start running logs for ${tv} with ip address ${ip_address} again - Type any key and enter?: " 
		pd=$( pwd )
		TSTAMP=$( date +'%d%b_%H_%M_%S' )
	
		folder=${TSTAMP}
		mkdir ${folder}
		chmod 777 ${folder}
		
		samsung_logs
	
	;;
		
	"LG_Tail_Logs" )
		read -p "Start running logs for ${tv} with ip address ${ip_address} again - Type any key and enter?: " 
		pd=$( pwd )
		TSTAMP=$( date +'%d%b_%H_%M_%S' )
	
		folder=${TSTAMP}
		mkdir ${folder}
		chmod 777 ${folder}
		lg_option=1
		lg_operations
		
	;;
	
	"LG_Crash_Logs" )
		lg_option=3
		lg_operations
	;;
	
	"LG_Device/Application_Logs" )
		lg_option=4
		lg_operations
	
	;;
	
	"LG_Adapter_Command")
	
		lg_option=5
		lg_operations
	 
	;;
	
	"LG_keygen_command" )
		lg_option=6
		lg_operations
	
	;;
	
	"LG_Mounting_command" )
		lg_option=7
		lg_operations
	
	;;
	
	"Samsung_install_apk" )
		install_apk
	;;
	
	
	"Samsung_uninstall_apk" )
		uninstall_apk
	
	;;
	
	
	"Samsung_Gamma_setup" )
		
		gamma_beta=1
		gamma_beta_setup
	
	;;
	
	"Samsung_Beta_setup" )
		gamma_beta=2
		gamma_beta_setup
	
	;;

	"Reboot_LG/Samsung" )
		printf "\n"
		reboot_device				
	;;
	
	
	"Root_Device_LG/Samsung" )
		printf "\n"
		root_on						
	;;
	
	"Kill_Command_LG/Samsung")
		printf "\n"
		kill_logs						
	;;
	
	
	"Quit")
		printf "\n"
		exitcheck=1
		break
	;;

	
	*)		
		echo "ERROR.....Please choose correct option (Select Number Between  1..${optionslen})!"
		printf '\n'
		break
	;;	
	esac
	

	done
	if [[ ${exitcheck} -eq 1 || ${exitcheck} == 1 ]]; then
		break
	
	fi
		
done
rm reboot_lg.sh  reboot_sam.sh root_on_sam.sh root_on_lg.sh kill_sam.sh kill_lg.sh logrun_lg1.sh logrun_lg2.sh  logrun_lg3.sh logrun_lg5.sh logrun_lg6.sh  logrun_lg7.sh logrun1.sh logrun2.sh  logrun3.sh logrun4.sh  logrun5.sh   >tmp.txt 2>&1
rm uninstall_apk_sam.sh install_apk_sam.sh gamma_beta.sh >tmp.txt 2>&1


