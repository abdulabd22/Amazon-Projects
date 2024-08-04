#! /bin/bash


echo "================================================================================"
echo "                               OTA SECTION                          "
echo "--------------------------------------------------------------------------------"
printf '\n'
printf '\n'
echo "================================================================================="
echo "                            SUPPORTED DEVICES                                  "
printf '\n'
echo "              FOS5: BISCUIT, SONAR, RADAR, BISHOP, ROOK, KNIGHT                 "
echo "                    FOS6(FTV): MANTIS, NEEDLE, STARK                            "
echo "FOS6:CRONOS, DONUT, LIDAR, CUPCAKE, PABLO ,OCTAVE, KYANITE, SAPPHIRE, CHECKERS, "
echo "                       CROWN, CANNOLI, CHEESCAKE, CHURRO."
echo "              FOS7: RAVEN, SHELDON, SHELDON PLUS, THEIA, ATHENA, HOYA              "
echo "        PUFFIN: DOEBRITE, CRUMPET, PASCAL, CROISSANT, LASER, BROWNIE, GANACHE, HYPNOS   "
echo "----------------------------------------------------------------------------------"
printf "\n"



read -p "Enter the LDAP userid (for Kota login): " ldapuserid
read -s -p "Enter LDAP password (for Kota login) - Password is hidden: " ldappassword
printf "\n"

skip_delete_hop="no"
printf "\n"
if [[ ${ldapuserid} != "" && ${ldappassword} != "" ]]; then

#Array which has "DeviceName_DeviceType_PackageName"

fos5=( "biscuit_A3S5BH2HU6VAYF_com.amazon.biscuit.android.os" "sonar_A2M35JJZWCQOMZ_com.amazon.sonar.android.os" "radar_A7WXQPH584YP_com.amazon.radar.android.os"  "bishop_AWZZ5CVHX2CD_com.amazon.bishop.android.os" "rook_A10A33FOX2NUBK_com.amazon.rook.android.os" "knight_A1NL4BVLQ4L3N3_com.amazon.knight.android.os" )
fos6=( "cronos_A1XWJRHALS1REP_com.amazon.cronos.android.os" "donut_A32DOYMUN6DTXA_com.amazon.donut.android.os" "lidar_A18O6U1UQFJ0XK_com.amazon.lidar.android.os" "cupcake_A1JJ0KFC4ZPNJ3_com.amazon.cupcake.android.os" "pablo_A3SSG6GR8UU7SN_com.amazon.pablo.android.os" "octave_A3RBAYBE7VM004_com.amazon.octave.android.os" "kyanite_A2RU4B77X9R9NZ_com.amazon.kyanite.android.os" "sapphire_A27VEYGQBW3YR5_com.amazon.sapphire.android.os" "checkers_A4ZP7ZC4PI6TO_com.amazon.checkers.android.os" "crown_A1Z88NGR2BK6A2_com.amazon.crown.android.os" "mantis_AKPGW064GI9HE_com.amazon.mantis.android.os" "needle_A2GFL5ZMWNE0PX_com.amazon.needle.android.os" "stark_A3HF4YRA2L7XGC_com.amazon.stark.android.os" "cannoli_A4ZXE0RM7LQ7A_com.amazon.cannoli.android.os" "cheesecake_A2DS1Q2TPDJ48U_com.amazon.cheesecake.android.os" "churro_ASQZWP4GPYUT7_com.amazon.churro.android.os" )
fos7=( "raven_A2JKHJ0PX4J3L3_com.amazon.raven.android.os" "theia_AIPK7MM90V7TB_com.amazon.theia.android.os" "athena_A15996VY63BQ2D_com.amazon.athena.android.os" "sheldon_A31DTMEEVDDOIV_com.amazon.sheldon.android.os" "sheldonp_A265XOI9586NML_com.amazon.sheldonp.android.os" "brandenburg_A8MCGN45KMHDH_com.amazon.brandenburg.android.os"  "rhodes_A2UONLFQW0PADH_com.amazon.rhodes.android.os" )
puffin=( "doebrite_A30YDR2MK8HMRV_com.amazon.doebrite.android.os" "crumpet_A1RABVCI4QCIKC_com.amazon.crumpet.android.os" "pascal_A3FX4UWTP28V1P_com.amazon.pascal.android.os" "croissant_A3VRME03NAXFUB_com.amazon.croissant.android.os" "laser_A3RMGO6LYLH7YN_com.amazon.laser.android.os" "brownie_A2U21SRK4QGSE1_com.amazon.brownie.android.os" "ganache_A2H4LV5GIZ1JFT_com.amazon.ganache.android.os" "hoya_A1EIANJ7PNB0Q7_com.amazon.hoya.android.os" "hypnos_A11QM4H9HGV71H_com.amazon.hypnos.kepler.os" )

#Options to Display
declare -a options
ostype="none"
family=""
package=""
devicetype=""


read -p "Enter OTA Group Name (in small or CAPS ): " otagroup
otagroup=${otagroup^^}
printf "\n"

read -p "Press '1' and enter for 'accelerated OTA' (OR) any number for 'standard OTA' : " otatype
if [[ ${otatype} -eq 1 || ${otatype} == "1" ]]; then
priority="accelerated"
else
priority="standard"
fi
printf "\n"

read -p "Press '1' and enter for 'Forced OTA' (OR) any number for 'Normal OTA' : " forced
printf "\n"
if [[ ${forced} -eq 1 || ${forced} == "1" ]]; then
	force="true"
else
	force="false"
fi

#gets the DeviceType and Package info using Device name
checkdevice() {
   ostype="none"
   family=""
   package=""
   devicetype=""
   local newdevice="$1"              
   local check
   check=( "fos5" "fos6" "fos7" "puffin" )
   local flag=0
                        
   for a in ${check[@]}
   do
                          
      abd="${a}[@]"
      for each in ${!abd}
      do
          each_device=$( echo ${each} | cut -d"_" -f1 )  
		#wildcard character to check if a substring is inside the string syntax  - "$STR" == *"$SUB"* 
         if [[ "${newdevice}" == *"${each_device}"* ]]; then
		   
		   family=$( echo ${each} | cut -d"_" -f1 )
		   echo ${family}
		   devicetype=$( echo ${each} | cut -d"_" -f2 )
		   echo ${devicetype}
		   package=$( echo ${each} | cut -d"_" -f3 )
		   echo ${package}
		   ostype=${a}
		   #echo ${ostype}
		   ((++flag))
           break
         fi
     done
     
	 if [[ "${flag}" -eq 1 ]]; then
         break
     fi
  done
                          
}


devicelist()
{
	#getting devices details and stores each and every "dsn"_"devicename" into array
	list=$(   adb devices -l | tr -s " " | cut -d " " -f 1,3 | sed '1d'| sed '$d' | sed 's/ product:/_/g' )
	list_arr=( $list )
	list_arr+=( 'Quit' )
	listlen=${#list_arr[@]}
	let "quit = ${listlen}"

	PS3="Type the number behind DSN_DEVICE(above) or Type number ${quit} (to Quit), and Click Enter:  "
	select name in ${list_arr[@]}
	do    
		
		
		if [[ $name == "Quit" ]]; then
			PS3="1)RegisterBuildFromKBITS=>CreateHop=>MoveDevice=>initiateOTA(issueSync) 2)CreateHop=>Movedevice=>initiateOTA(issueSync) 3)RegisterBuildFromKBITS=>CreateHop=>Movedevices 4)CreateHop=>Movedevices  5)MoveDevices  6)LookupDevices 7)ListHops 8)DeleteHops 9)DevicesInOTAGroup  10)Quit..: "
			  break
		fi
		
		dsn=$(  echo $name |  cut -d "_" -f 1 )
		device=$(  echo $name |  cut -d "_" -f 2 )
		
		
		if [[ ${dsn} == "" && ${device} == ""  ]]; then
			  
			echo "ERROR.....Please enter the option between 1..${quit}:   " 
			printf '\n'
			continue
		fi
		printf '\n'
		
		if [[ "${device}" != "mopac" ]]; then
			checkdevice "${device}"
			break
		else
		   echo "Cant initiate OTA for Mopac"
		   break
		fi
		printf '\n'
		
    done

}


confirmGroup()

{
choice=""

read -p "Confirm your OTA group ${tmpgroup}, 1)yes 2)no : " choice

	if  [[ ${choice} -eq 2 ]] ; then 

		read -p "Type name of your OTA group (in Small or Caps) and Enter: " tmpgroup 
		tmpgroup=${tmpgroup^^}

	fi

}

registerhop()
{

#Registering Build ${target} for ${device}
    if [[ -f list.txt ]] ; then rm list.txt; touch list.txt; fi 
	echo "==============================================================="
	echo "Started registering ${target} build for ${device}.Please Wait."
	echo "---------------------------------------------------------------"
 
	printf "\n"

	curl  -# -k -X POST  -u  ${ldapuserid}:${ldappassword} -F kbits_url="${build_link}" -F json="true"  https://kota-qa-pdx.pdx.proxy.amazon.com/v1/register  >list.txt
	printf "\n"
	echo "===================================================="
	echo "Registered  ${target} build ${device} successfully."
	echo "----------------------------------------------------"
	printf "\n"
    printf "\n"

}
 


devicesInOTAGroup()
{

tmpgroup=${otagroup}

if [[ -f tar.txt ]] ; then rm tar.txt; touch tar.txt; fi
if [[ -f list.txt ]] ; then rm list.txt; touch list.txt; fi
if [[ -f file1.txt ]] ; then rm file1.txt; touch file1.txt; fi
if [[ -f file2.txt ]] ; then rm file2.txt; touch file2.txt; fi


while true
do

	
	confirmGroup
	printf "\n"
	
	if  [[ ${choice} -eq 1 || ${choice} -eq 2 ]] ; then 
		
		
		curl -# -k -X POST -u ${ldapuserid}:${ldappassword}  -F otagroup=${tmpgroup}  https://kota-qa-pdx.pdx.proxy.amazon.com/v1/otagroup_lookup >list.txt
		
		echo "_____________ _______">tar.txt 
		echo "|DEVICE_NAME|  |DSN|" >>tar.txt
		echo "============= =======">>tar.txt
		cat list.txt | grep name | cut -d':' -f2 | tr -d ',"' >file1.txt
		cat list.txt | grep dsn | cut -d':' -f2 | tr -d ',"' >file2.txt
		paste file1.txt file2.txt >>tar.txt
		printf "\n"
		echo "Devices in ${tmpgroup} Group" 
		cat tar.txt | column -t 
		printf "\n"
		rm file1.txt file2.txt tar.txt >delete.txt
		rm delete.txt
		
		break
		
		
	
	elif [[ ${choice} -eq 3 ]] ; then 
		rm file1.txt file2.txt tar.txt >delete.txt
		rm delete.txt
	
		break
	else

		echo "Enter the correct option 1..3"
		continue
	fi
	

done

}

lookupDevices()
{
while true
do

	if [[ -f tar.txt ]] ; then rm tar.txt; touch tar.txt; fi
	if [[ -f list.txt ]] ; then rm list.txt; touch list.txt; fi
	if [[ -f file1.txt ]] ; then rm file1.txt; touch file1.txt; fi
	if [[ -f file2.txt ]] ; then rm file2.txt; touch file2.txt; fi
	if [[ -f file3.txt ]] ; then rm file3.txt; touch file3.txt; fi

   
	adb devices -l | tr -s " " | cut -d " " -f 1,3 | sed '1d'| sed '$d' | sed 's/ product:/_/g' > tmp.txt

	listdevices=$(   adb devices -l | tr -s " " | cut -d " " -f 1,3 | sed '1d'| sed '$d' | sed 's/ product:/_/g' )
	list_arrdevices=( ${listdevices} )
	listlendevices=${#list_arr[@]}

      if [[ ${listlendevices} -gt  0 ]] ; then 
			
			echo "List of devices attached"
			cat tmp.txt
			printf "\n"
	  fi

    
   read -p '''Copy paste DSNs separated by commas and Enter (e.g: G0B18W050294001Q,G0B18W0402040028 )
(or) To Quit, type 'quit' and Enter: ''' dsns
	
	dsns=$( echo ${dsns} | tr -d ' \n\r' )
	if [[ ${dsns} == "quit" || ${dsns} == "Quit" || ${dsns} == "QUIT" ]]; then
	 
		break
	 
	fi


	 if [[ ${dsns} -eq ${listlendevices} ]] ; then
		for dsn in ${list_arrdevices[@]}
		do
				tmp=$(  echo $dsn |  cut -d "_" -f 1 )
				
				if [[ ${i} -eq 0 ]]; then
					dsns=$( echo "${tmp}" )
					((++i))
				else
				
					dsns=$( echo "${dsns},${tmp}" )
				
				fi
				
				
		done
				 
			
	 fi

	dsns=$( echo ${dsns} |  tr -d ' \n\r' )

	curl -# -k -X POST -u ${ldapuserid}:${ldappassword} -F dsns=${dsns} https://kota-qa-pdx.pdx.proxy.amazon.com/v1/device_lookup > list.txt
	echo "_____________  _____  ___________">tar.txt 
	echo "|DEVICE_NAME|  |DSN|  |OTA_GROUP|">>tar.txt
	echo "=============  =====  ===========">>tar.txt
	 
	 
	IFS=","
	for dsn in ${dsns}
	do
		echo "${dsn}" >>file2.txt
	done
	cat list.txt | grep name | cut -d':' -f2 | tr -d ',"' >file1.txt
	cat list.txt | grep otagroup | cut -d':' -f2 | tr -d ',"' >file3.txt
	
	paste file1.txt file2.txt  file3.txt >>tar.txt
	IFS=$' \t\n'
	cat tar.txt | column -t 

	printf "\n"
	rm file1.txt file2.txt file3.txt tar.txt list.txt >delete.txt
	rm delete.txt
	break
	



done



}

listHops()
{

tmpgroup=${otagroup^^}

while true
do

if [[ -f tar.txt ]] ; then rm tar.txt; touch tar.txt; fi
if [[ -f list.txt ]] ; then rm list.txt; touch list.txt; fi
if [[ -f file1.txt ]] ; then rm file1.txt; touch file1.txt; fi
if [[ -f file2.txt ]] ; then rm file2.txt; touch file2.txt; fi
if [[ -f file3.txt ]] ; then rm file3.txt; touch file3.txt; fi
if [[ -f file4.txt ]] ; then rm file4.txt; touch file4.txt; fi
if [[ -f file5.txt ]] ; then rm file5.txt; touch file5.txt; fi
if [[ -f file6.txt ]] ; then rm file6.txt; touch file6.txt; fi


	confirmGroup 
	printf "\n"
	if [[ ${choice} -eq 1 || ${choice} -eq 2 ]]; then
		curl -# -k -X POST  -u ${ldapuserid}:${ldappassword}  -F otagroup=${tmpgroup}  -F json='true'  https://kota-qa-pdx.pdx.proxy.amazon.com/v1/hops > list.txt
		
	

		printf "\n"
		
		echo "__________________  ___________  ________   ________   ____________ __________">tar.txt 
		echo "|DEVICE_TYPE_NAME|  |SIGN_TYPE|  |SOURCE|   |TARGET|   |OOBE_FORCE| |PRIORITY|" >>tar.txt 
		echo "==================  ===========  ========   ========   ============ ==========">>tar.txt 
		cat list.txt | grep device_type_name | cut -d':' -f2 | tr -d ',"' >file1.txt
		cat list.txt | grep target_sign_type | cut -d':' -f2 | tr -d ',"' >file2.txt
		cat list.txt | grep source | cut -d':' -f2 | tr -d ',' >file3.txt
		cat list.txt | grep  '\"target\":' | cut -d':' -f2 | tr -d ',"' >file4.txt
		cat list.txt | grep oobe_force | cut -d':' -f2 | tr -d ',"' >file5.txt
		cat list.txt | grep priority | cut -d':' -f2 | tr -d ',"' >file6.txt
		paste file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt >>tar.txt 
        echo "            Here is the list of available Hops in ${tmpgroup}                 "
		cat -n tar.txt | column -t 
		rm  file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt tar.txt >delete.txt
		rm delete.txt
		
		break
		


	elif [[ ${choice} -eq 3 ]]; then
			rm  file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt tar.txt >delete.txt
			rm delete.txt

		  break
	else

		echo "Please Enter the options..between 1..3"
		continue
	fi

done

}

deleteHops()
{
tmpgroup=${otagroup^^}
deleteexit=0

if [[ -f tar.txt ]] ; then rm tar.txt; touch tar.txt; fi
if [[ -f list.txt ]] ; then rm list.txt; touch list.txt; fi
if [[ -f file1.txt ]] ; then rm file1.txt; touch file1.txt; fi
if [[ -f file2.txt ]] ; then rm file2.txt; touch file2.txt; fi
if [[ -f file3.txt ]] ; then rm file3.txt; touch file3.txt; fi
if [[ -f file4.txt ]] ; then rm file4.txt; touch file4.txt; fi
if [[ -f file5.txt ]] ; then rm file5.txt; touch file5.txt; fi
if [[ -f file6.txt ]] ; then rm file6.txt; touch file6.txt; fi



while true
do
	confirmGroup
	printf "\n"
	if  [[ ${choice} -eq 1 || ${choice} -eq 2 ]] ; then
	
		read -p "Type number and Enter 1)DeleteAllHops 2)DeleteAllHopsofSpecificDevice 3)DeleteAllHopsbyTargetBuildNumber 4)Quit: " deletechoice
		if  [[ ${deletechoice} -eq 1 ]] ; then
		
			curl -# -k -X POST -u ${ldapuserid}:${ldappassword}  -F otagroup=${tmpgroup} -F json='true'   https://kota-qa-pdx.pdx.proxy.amazon.com/v1/unpublish > list.txt
			printf "\n"
			
			echo "__________________  ___________  ________   ________   ____________ __________">tar.txt 
			echo "|DEVICE_TYPE_NAME|  |SIGN_TYPE|  |SOURCE|   |TARGET|   |OOBE_FORCE| |PRIORITY|" >>tar.txt 
			echo "==================  ===========  ========   ========   ============ ==========">>tar.txt 
			cat list.txt | grep device_type_name | cut -d':' -f2 | tr -d ',"' >file1.txt
			cat list.txt | grep target_sign_type | cut -d':' -f2 | tr -d ',"' >file2.txt
			cat list.txt | grep source | cut -d':' -f2 | tr -d ',' >file3.txt
			cat list.txt | grep  '\"target\":' | cut -d':' -f2 | tr -d ',"' >file4.txt
			cat list.txt | grep oobe_force | cut -d':' -f2 | tr -d ',"' >file5.txt
			cat list.txt | grep priority | cut -d':' -f2 | tr -d ',"' >file6.txt
			paste file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt >>tar.txt 
			echo "            Here is the list of All Removed Hops in ${tmpgroup}                 "
			cat -n tar.txt | column -t 
			rm  file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt tar.txt
			echo "All OTA Hops in ${tmpgroup} is deleted"
			printf "\n"
			break
			
			
		elif  [[ ${deletechoice} -eq 2 ]] ; then
			while true
			do
				read -p "Type the Device name (in caps or small) (e.g: sheldonp ). (or) Type 1 to Quit: " device
				
				if [[ "${device}" -eq 1 ]] ; then
				    deleteexit=1
					break
				else
				
					device=${device,,}
					checkdevice "${device}"
				fi
				if [[ "${device}" == "${family}" && "${device}" != "" ]] ; then
					curl -# -k -X POST -u ${ldapuserid}:${ldappassword}  -F otagroup=${tmpgroup} -F device_type=${device_type} -F package=${package}  -F json='true'   https://kota-qa-pdx.pdx.proxy.amazon.com/v1/unpublish > list.txt
					printf "\n"
					echo "__________________  ___________  ________   ________   ____________ __________">tar.txt 
					echo "|DEVICE_TYPE_NAME|  |SIGN_TYPE|  |SOURCE|   |TARGET|   |OOBE_FORCE| |PRIORITY|" >>tar.txt 
					echo "==================  ===========  ========   ========   ============ ==========">>tar.txt 
					cat list.txt | grep device_type_name | cut -d':' -f2 | tr -d ',"' >file1.txt
					cat list.txt | grep target_sign_type | cut -d':' -f2 | tr -d ',"' >file2.txt
					cat list.txt | grep source | cut -d':' -f2 | tr -d ',' >file3.txt
					cat list.txt | grep  '\"target\":' | cut -d':' -f2 | tr -d ',"' >file4.txt
					cat list.txt | grep oobe_force | cut -d':' -f2 | tr -d ',"' >file5.txt
					cat list.txt | grep priority | cut -d':' -f2 | tr -d ',"' >file6.txt
					paste file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt >>tar.txt 
					echo "            Here is the list of Removed Hops of ${device} in ${tmpgroup}      "
					cat -n tar.txt | column -t 
					rm  file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt tar.txt
					read -p "Do you want to delete any different device's Hops in same ${tmpgroup} OTAgroup 1)yes 2)No : " goahead
					if [[ ${goahead} -eq 1 ||  ${goahead} == "1" ]]; then 
						printf "\n"
						continue
					else
						deleteexit=1
						break
					fi
				else
					echo "Please Enter the correct Device name"
					continue
				fi
			done
			if [[ ${deleteexit} -eq 1 ]] ; then 
				break
			fi
		elif  [[ ${deletechoice} -eq 3 ]] ; then
				
				read -p "Paste the target number and Enter (or) Press 2 (to Quit) : " num
				
				if [[ ${num} -eq 2 ]] ; then
					break
				fi
					
				
				curl -# -k -X POST -u ${ldapuserid}:${ldappassword}  -F otagroup=${tmpgroup} -F target_version="${num}"  -F json='true'   https://kota-qa-pdx.pdx.proxy.amazon.com/v1/unpublish  > list.txt
				printf "\n"
				echo "__________________  ___________  ________   ________   ____________ __________">tar.txt 
				echo "|DEVICE_TYPE_NAME|  |SIGN_TYPE|  |SOURCE|   |TARGET|   |OOBE_FORCE| |PRIORITY|" >>tar.txt 
				echo "==================  ===========  ========   ========   ============ ==========">>tar.txt 
				cat list.txt | grep device_type_name | cut -d':' -f2 | tr -d ',"' >file1.txt
				cat list.txt | grep target_sign_type | cut -d':' -f2 | tr -d ',"' >file2.txt
				cat list.txt | grep source | cut -d':' -f2 | tr -d ',' >file3.txt
				cat list.txt | grep  '\"target\":' | cut -d':' -f2 | tr -d ',"' >file4.txt
				cat list.txt | grep oobe_force | cut -d':' -f2 | tr -d ',"' >file5.txt
				cat list.txt | grep priority | cut -d':' -f2 | tr -d ',"' >file6.txt
				paste file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt >>tar.txt 
			
				echo "            Here is the list of Removed Hops of All devices in ${num} build in ${tmpgroup}      "
				cat -n tar.txt | column -t 
				rm  file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt tar.txt
				break
		else

			break
		fi
	
	elif  [[ ${choice} -eq 3 ]] ; then
			rm  file1.txt file2.txt file3.txt file4.txt file5.txt file6.txt tar.txt >delete.txt
			rm delete.txt
			break
	else

		echo "Please Enter the options..between 1..3"
		continue
	fi

done

 
}


moveDevices()
{


	destinationgroup=${tmpgroup}
	printf "\n"
	echo ${dsns}	
	curl -# -k -X POST -u ${ldapuserid}:${ldappassword} -F dsns=${dsns} -F otagroup=${destinationgroup}  https://kota-qa-pdx.pdx.proxy.amazon.com/v1/move_devices > list.txt
	
	echo "_____________  _____  ____________________  ___________________">tar.txt 
	echo "|DEVICE_NAME|  |DSN|  |PREVIOUS_OTA_GROUP|  |CURRENT_OTA_GROUP|">>tar.txt
	echo "=============  =====  ====================  ===================">>tar.txt
	 
	 
	IFS=","
	for dsn in ${dsns}
	do
	    
		#getting device type from the result.
		device=$( cat list.txt | grep "dsn ${dsn} of type"  | tr -s ' ' | tr -d '"\n,' | cut -d' ' -f6 )
		
		
		
		#If the device type is empty, then the device is moved to destination hop
		if [[ ${device} == "" ]]; then
		
		   cat list.txt  | grep -A 3 ${dsn} >tmp.txt
			name=$( cat tmp.txt | grep name | cut -d':' -f2 | tr -s ' ' | tr -d '",\n' )
			prev_otagroup=$( cat tmp.txt | grep prev_otagroup | cut -d':' -f2 | tr -s ' ' | tr -d '",\n' )
			new_otagroup=$( cat tmp.txt | grep new_otagroup | cut -d':' -f2 | tr -s ' ' | tr -d '",\n' )
		     
		    variable=$( echo "${name}	${dsn}	${prev_otagroup}	${new_otagroup}"  )
			 echo "${variable}">>tar.txt
			 
		 
		#If the device type is not empty, then the device is in destination hop itself
		else
			checkdevice "${device}"
			variable=$( echo "${family}	${dsn}	${destinationgroup}		${destinationgroup}" | tr -s ' '  )
		    echo "${variable}">>tar.txt
			
		    
		fi
	
	
	
	done
	IFS=$' \t\n'
	cat -n tar.txt | column -t
	rm list.txt tar.txt  >delete.txt
	rm delete.txt
 	printf "\n"
		


}
getdetails()
{

	read -p "Copy Paste the kbits link and Enter: "  build_link
	tmpgroup=${otagroup^^}
	confirmGroup
	printf "\n"
	adb devices -l
	read -p '''Copy paste DSN. If multiple devices, each must be separated by commas and Enter (e.g: G0B18W050294001Q,G0B18W0402040028 ): ''' dsns
	dsns=$( echo ${dsns} | tr -d ' \n\r' )
	printf "\n"
	
	
	
}

getdetailsFromBuild_function()
{
	#getting url and target from the kbits link 
	build_link=$( echo ${build_link} | tr -d "\n\r" )
	target=$( echo ${build_link} | awk -F "_" '{print $NF}'  | cut -d"." -f1 | tr -d "\n\r" )
	tmp=$( echo ${target} | awk -F "-" '{print $NF}' )
	
	sign=$( echo ${build_link} |  awk -F "/" '{print $9}' )
	device=$( echo ${build_link} |  awk -F "/" '{print $6}' )
	
	# echo "sign: ${sign}"
	# echo "device: ${device}"
	
	if [[ "${sign}" == "userdebug" || "${sign}" == "userdevsigned" ]]; then
			sign="debug"
	elif [[ "${sign}" == "user" ]]; then
			sign="release"
	else
		sign=""
	
	fi
	checkdevice "${device}"
	
}

createhop()
{



#Deleting all previous hops of the device 
	echo "=================================================================================="
	echo "Started Deleting all Previous hops for ${device^^} in ${tmpgroup}.Please wait"
	echo "----------------------------------------------------------------------------------"
	printf "\n"

	curl  -# -k -X POST -u ${ldapuserid}:${ldappassword} -F otagroup="${tmpgroup}"  -F device_type="${devicetype}"  -F  package="${package}"  -F sign_type="${sign}" -F json="true" https://kota-qa-pdx.pdx.proxy.amazon.com/v1/unpublish  >delete.txt
	printf "\n"
	echo "================================================================================"
	echo "     All Previous hops for ${device^^} in ${tmpgroup} is been deleted     "
	echo "--------------------------------------------------------------------------------"
	 
	printf "\n"
	printf "\n"

	#Creating a new Hop for the device 
	echo "============================================================================================"
	echo "Started Creating New hop for ${device^^} to target ${target} in ${sign^^} build in ${tmpgroup}.Please wait"
	echo "---------------------------------------------------------------------------------------------"
	printf "\n"

	 
	curl -# -k -X POST  -u ${ldapuserid}:${ldappassword} -F otagroup="${tmpgroup}"  -F device_type="${devicetype}"  -F package="${package}"  -F target_version="${target}"  -F sign_type="${sign}" -F force="${force}"  -F  priority="${priority}"  -F   json='true'  https://kota-qa-pdx.pdx.proxy.amazon.com/v1/publish  >delete.txt
	printf "\n"
	echo "==================================================================================================="
	echo "Created New Hop for ${device^^} to target ${target} in ${sign^^} build in ${tmpgroup} successfully"
	echo "---------------------------------------------------------------------------------------------------"
	printf "\n"
	printf "\n"


}


create_a_hop()
{

     echo ${build_link}

	#getdetailsFromBuild 
	getdetailsFromBuild_function
	if [[ ${family} == "" || ${family} == " " || ${sign} == ""  || ${sign} == " " ]]; then
	   echo "Cannot Create Hop for this type of KBITS Build link"
	   printf "\n"
	  
	else
	   if [[ ${register_hop} -eq 1 ]]; then
		 #Registering Build ${target} for ${device}
	     registerhop
	   fi
	
	   #Create Hop
	   createhop
	
	fi


}

registerandCreateMultipleHops()
{

tmpgroup=${otagroup^^}
confirmGroup
printf "\n"
read -p "How many hops you want to create and Enter (e.g: 6  ): " count
printf "\n"
echo "Let get started to create ${count} different Hops in ${tmpgroup} "
declare -a hopslist

k=0
while [[ ${k} -lt ${count} ]] 
do
	echo "${k}"
	let "tmp = k + 1"
	build_link=""
	read -p "Copy Paste the kbits link and Enter for build no ${tmp}: "  build_link
	hopslist[${k}]="${build_link}"	

	((++k))
done	

	
k=0
printf "\n"
while [[ ${k} -lt ${count} ]] 
do

	build_link="${hopslist[${k}]}"

	#Create a hop for the build link
	create_a_hop

	((++k))

done

}


createMultipleHops()
{
tmpgroup=${otagroup^^}
	
	confirmGroup
	printf "\n"
	
read -p "How many hops you want to create and Enter (e.g: 6  ): " count
printf "\n"
echo "Let get started to create ${count} different Hops in ${tmpgroup} "
declare -a hopslist

k=0
while [[ ${k} -lt ${count} ]] 
do
	echo "${k}"
	let "tmp = k + 1"
	build_link=""
	read -p "Copy Paste the kbits link and Enter for build no ${tmp}: "  build_link
	hopslist[${k}]="${build_link}"	

	((++k))
done	



k=0
printf "\n"
while [[ ${k} -lt ${count} ]] 
do

	build_link="${hopslist[${k}]}"

	#Create a hop for the build link
	create_a_hop

	
	((++k))

done

}




file_Register_And_Create_Multiple_Hops()
{

pd=$( pwd )


if [[ -s config.txt ]];  then 
  cat config.txt
  read -p "Confirm the config.txt  file and hops creation will begin immediately. Press "1" for Yes (or) any number for No: " yes_or_no
  printf "\n"
  if [[ ${yes_or_no} == 1 ]]; then 
	tmpgroup=${otagroup^^}
	confirmGroup
	printf "\n"
  else
	clear
	printf "\n"
	echo "Open 'config.txt' text file in the current location ${pd} and edit the file - one build link per line and SAVE the file ctrl+s "
	printf "\n"
	return 1
   fi
else

  touch config.txt
  clear
  printf "\n"
  echo "No config file available or empty . please edit and run again"
  echo "Open 'config.txt'text file in the current location ${pd} and copy paste the build links - one build link per line and SAVE the file ctrl+s ,  then choose this option"

  printf "\n"
 return 1
 
fi
 

 
file="config.txt"
echo "Started creatig hops from the config.txt file..."
while read -r line; do

	
	build_link=$( echo "$line" | tr -d " \t\n\r" )
	#Create a hop for the build link
	create_a_hop

	
done <$file



}

file_Create_Multiple_Hops()
{


pd=$( pwd )

if [[ -s config.txt ]];  then 
  cat config.txt
  read -p "Confirm the config.txt  file and hops creation will begin immediately. Press "1" for Yes (or) any number for No: " yes_or_no
  printf "\n"
  if [[ ${yes_or_no} == 1 ]]; then 
	tmpgroup=${otagroup^^}
	confirmGroup
	printf "\n"
  else
	clear
	printf "\n"
	echo "Open 'config.txt' text file in the current location ${pd} and edit the file - one build link per line and SAVE the file ctrl+s, then choose this option "
	printf "\n"
	return 1
   fi
else

  touch config.txt
  clear
  printf "\n"
  echo "No config file available or empty . please edit and run again"
  echo "Open 'config.txt' text file in the current location ${pd} and copy paste the build links - one build link per line and SAVE the file ctrl+s "
  printf "\n"
 return 1
 
fi
 

 
file="config.txt"
echo "Started creatig hops from the config.txt file..."
while read -r line; do

	
	build_link=$( echo "$line" | tr -d " \t\n\r" )
	#Create a hop for the build link
	 create_a_hop
	
done <$file



}


options=(  "Register_And_Create_Hop=>Move_Device(single_hop)" "Create_Hop=>Move_Device(single_hop)"  "Move_Devices"  "Lookup_Devices" "List_Hops" "Delete_Hops" "Devices_In_OTAGroup" "Register_And_Create_Multiple_Hops" "Create_Multiple_Hops" "Config_File_Register_And_Create_Multiple_Hops" "Config_File_Create_Multiple_Hops" "Clear_Screen"  "Quit" )
optionslen=${#options[@]}


printf "\n"


exitcheck=0
while true  
do  
	PS3="Choose the option(number) and Enter: "
	select option in ${options[@]}
	do
		

		printf "\n"
		case ${option} in
				
				"Register_And_Create_Hop=>Move_Device(single_hop)") 
						register_hop=1
						#get details from build and dsn details
						getdetails
						
						#Create a hop for the build link
						create_a_hop
									
						#Moving devices to the hop
					     moveDevices
						
						
						printf '\n'
						printf '\n'
						
						break
						
					
					;;		
				
				"Create_Hop=>Move_Device(single_hop)")
				        register_hop=0
						#get details from build and dsn details
						getdetails
						
						#Create a hop for the build link
						create_a_hop
						
						#Moving devices to the hop
					     moveDevices
						
						
						printf '\n'
						printf '\n'
						break
					
				
				;;
				
				"Move_Devices")
					tmpgroup=${otagroup^^}
					echo "Devices Connected"
					adb devices -l    
					read -p '''Copy paste DSNs separated by commas and Enter (e.g: G0B18W050294001Q,G0B18W0402040028 ) (or) To Quit, type 'quit' and Enter: ''' dsns
					printf "\n"
					dsns=$( echo ${dsns} | tr -d ' \n\r' )

					confirmGroup					
					#Moving devices to the hop
					moveDevices
					printf '\n'
					printf '\n'
					break
				
				;;
				
				"Lookup_Devices")
				#Looking Up devices in the hop
				   lookupDevices
				   printf '\n'
				   
				   break
				   
				;;
				"List_Hops")
					#Looking Up devices in the hop
					listHops
					printf '\n'
					printf '\n'
					break
				
				;;
				
				"Delete_Hops")
					#Deleting Hops in the hop
					   deleteHops
					   printf '\n'
					   printf '\n'
					   break
				   
				;;
				
				"Devices_In_OTAGroup")
					#Checking Devices in any OTA group
					devicesInOTAGroup
					printf '\n'
					printf '\n'
					
					break
				;;
				"Register_And_Create_Multiple_Hops")
						#Register and Create Multiple Hops
						register_hop=1
				       registerandCreateMultipleHops
					   break
				
				;;
				"Create_Multiple_Hops")
				  #Creat Multiple Hops ( no register)
				    register_hop=0
					createMultipleHops
					break
				;;
				"Config_File_Register_And_Create_Multiple_Hops")

				  #Register and Create Multiple Hops  from the config file
				    register_hop=1
					file_Register_And_Create_Multiple_Hops
					break
				;;
				"Config_File_Create_Multiple_Hops")
				
				  #Creat Multiple Hops ( no register) from the config file
					register_hop=0
					file_Create_Multiple_Hops
					break
				;;
				
				"Clear_Screen")
				
					clear
					printf "\n"
					
					break
				
				 ;;
				"Quit")
					#Exit
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
	if [[ ${exitcheck} -eq 1 ]] ; then
		echo "adios, see you next time,"
		break
	fi
   
done

else
 pd=$( pwd )
 echo "ldap - user id (or) password is empty"
 echo "open the file location ${pd} , edit the script by filling up 'ldapuserid' and 'ldappassword' with valid credentials"

fi