#! /bin/bash

declare -a clustertype
declare -a group
declare -a host_address
declare -a device_dsn
declare -a domains
declare -a kill_array


declare -a gapless_array
declare -a offset_array
declare -a drm_array
declare -a tidal_array


whaddump=0

datedelete=$( TZ='Asia/Kolkata' date +'%d%b_%H_%M_%S' )
touch delete_${datedelete}.txt
chmod 666 delete_${datedelete}.txt


echo "labone2six" | sudo -S rm "delete.txt" "reboot.sh" "logrun.sh"  "logkill.sh" "checkdump.sh" "checkostype.sh" "checkplaying.sh" "startmusic.sh" "stopmusic.sh" >delete_${datedelete}.txt  2>&1
echo "labone2six" | sudo -S rm "killgapless.sh" "killoffset.sh"  "killdrm.sh" "killtidal.sh" "killdrmtidal.sh" "drmtidal.sh" "gapless.sh" "offset.sh" "tidal.sh" "drm.sh" >delete_${datedelete}.txt  2>&1

rm "delete.txt" "reboot.sh" "logrun.sh"  "logkill.sh" "deletefiles.sh" "checkdump.sh" "checkostype.sh" "checkplaying.sh" "startmusic.sh" "stopmusic.sh" >delete_${datedelete}.txt  2>&1
rm "killgapless.sh" "killoffset.sh"  "killdrm.sh" "killtidal.sh" "killdrmtidal.sh" "drmtidal.sh" "gapless.sh" "offset.sh" "tidal.sh" "drm.sh" >delete_${datedelete}.txt  2>&1

touch delete.txt
chmod 666 delete.txt
rm delete_${datedelete}.txt >delete.txt 2>&1



currenthost=$( echo $(hostname) | cut -d "." -f 1 )
line=$(  tr -d " \t\n\r" <./config.txt )

domainpermission=0



#Function that gets WHAD Dump from ADM DSN

whaddumpfunc() 
{
logrunhost=$( echo ${admhost} | cut -d "@" -f 2 )



touch checkdump.sh
chmod 777 ./checkdump.sh
 
 
 if [[ "${logrunhost}" == "${currenthost}"  ]]; then

checkostype
cat ./checkostype.sh >>checkdump.sh
echo "checkos ">>checkdump.sh
echo "touch ./${folder}/WhadDump.txt">>checkdump.sh
echo "chmod 666 ./${folder}/WhadDump.txt">>checkdump.sh
echo "echo \${ostype}">>checkdump.sh
echo "echo ${device_dsn[0]}">>checkdump.sh
echo "    if [[ \"\${ostype}\" ==  \"puffin\" ]] ; then">>checkdump.sh
echo "       adb -s  ${admdsn} shell lipc-get-prop com.doppler.whad localCluster >./${folder}/WhadDump.txt">>checkdump.sh 
echo "    else">>checkdump.sh 
echo "       adb -s  ${admdsn} shell  dumpsys activity service WhadService >./${folder}/WhadDump.txt">>checkdump.sh 
echo "     fi">>checkdump.sh

sed -i  "s/dsn/${admdsn}/g"  checkdump.sh
sed -i  "s/interrupt/break/g"  checkdump.sh

source ./checkdump.sh >delete.txt 
rm  ./checkostype.sh ./checkdump.sh


else

checkostype
cat ./checkostype.sh >>checkdump.sh
echo "checkos ">>checkdump.sh
echo "touch ./Desktop/${folder}/WhadDump.txt">>checkdump.sh
echo "chmod 666 ./Desktop/${folder}/WhadDump.txt">>checkdump.sh
echo "echo \${ostype}">>checkdump.sh
echo "echo ${device_dsn[0]}">>checkdump.sh
echo "    if [[ \"\${ostype}\" ==  \"puffin\" ]] ; then">>checkdump.sh
echo "       adb -s  ${admdsn} shell lipc-get-prop com.doppler.whad localCluster >./Desktop/${folder}/WhadDump.txt">>checkdump.sh 
echo "exit">>checkdump.sh 
echo "    else">>checkdump.sh 
echo "       adb -s  ${admdsn} shell  dumpsys activity service WhadService >./Desktop/${folder}/WhadDump.txt">>checkdump.sh 
echo "exit">>checkdump.sh 
echo "     fi">>checkdump.sh

sed -i  "s/dsn/${admdsn}/g"  checkdump.sh
sed -i  "s/interrupt/break/g"  checkdump.sh



ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./checkdump.sh  >delete.txt


ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/WhadDump.txt" ./${folder}/  >delete.txt

#Deleting WhadDump file on admhost
touch deletefiles.sh
chmod 777 deletefiles.sh

echo "echo \"labone2six\" | sudo -S rm  ./Desktop/${folder}/WhadDump.txt ; exit" >>deletefiles.sh
echo "exit" >>deletefiles.sh

ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./deletefiles.sh >delete.txt

rm  ./checkostype.sh  ./checkdump.sh ./deletefiles.sh 

fi

}




#function for running logs

logrun()
{


logrunhost=$( echo ${host_address[k]} | cut -d "@" -f 2 )

if [[ "${logrunhost}" == "${currenthost}"  ]]; then

tmplogpath="${folder}/${log_name}/${device_dsn[k]}_${log_name}"

echo ${tmplogpath}
adb -s ${device_dsn[k]} logcat -c
adb -s ${device_dsn[k]} logcat -c
sleep 1

adb -s ${device_dsn[k]} logcat -v threadtime >./${tmplogpath}.txt  </dev/null  2>/dev/null & 
tmp=$( echo "$!" ) 
chmod  666 ./${tmplogpath}.txt
  sleep 4
  disown  $!
  shopt -u huponexit
  kill_array+=( $tmp )




if [[ ${domainpermission} -eq 0 ]];then
chmod 777 ./${folder}/${log_name}
domainpermission=1
fi





else


if  [[  -d  logrun.sh ]]; then

rm logrun.sh

fi 
touch logrun.sh
chmod 777 logrun.sh

echo "cd Desktop/">>logrun.sh
echo "if  [[ ! -d  ${folder} ]]; then">>logrun.sh
echo "  echo \"labone2six\" | sudo -S mkdir ${folder}">>logrun.sh
echo "echo \"labone2six\" | sudo -S chmod 777 ${folder}">>logrun.sh
echo "fi">>logrun.sh 
echo "adb -s ${device_dsn[k]} logcat -c">>logrun.sh
echo "adb -s ${device_dsn[k]} logcat -c">>logrun.sh
echo "adb -s ${device_dsn[k]} logcat -v threadtime >./${folder}/${device_dsn[k]}_${log_name}.txt  </dev/null  2>/dev/null  &">>logrun.sh
echo "echo  \$! >./${folder}/kill_${device_dsn[k]}_${log_name}.txt">>logrun.sh
echo "sleep 4">>logrun.sh
echo "disown \$!">>logrun.sh
echo "shopt -u huponexit">>logrun.sh
echo "echo \"labone2six\" | sudo -S chmod 666 ./${folder}/kill_${device_dsn[k]}_${log_name}.txt  ./${folder}/${device_dsn[k]}_${log_name}.txt">>logrun.sh
echo "sleep 2">>logrun.sh
echo "exit">>logrun.sh



ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${host_address[k]}" 'bash -s'<./logrun.sh  >delete.txt

ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${host_address[k]}:./Desktop/${folder}/kill_${device_dsn[k]}_${log_name}.txt" ./  >delete.txt


tmp=$( cat kill_${device_dsn[k]}_${log_name}.txt )
kill_array+=( ${tmp} )
 

rm  "kill_${device_dsn[k]}_${log_name}.txt" "logrun.sh"

fi

echo ${kill_array[k]}

}


#function which creates logkill.sh, for killing logs

logkill() {


logrunhost=$( echo ${host_address[m]} | cut -d "@" -f 2 )

#if DSN is in current host , no need of creating logkill.sh 

if [[ "${logrunhost}" == "${currenthost}"  ]]; then

echo "labone2six" | sudo -S kill -9  "${kill_array[m]}" 
kill -9 "${kill_array[m]}" 
ps -ef  | grep  "${device_dsn[m]}" | tr -s ' ' | cut -d' ' -f2 | tr '\n\r' ' ' | xargs kill -9

else

if [[ -e logkill.sh ]]
then
rm logkill.sh
fi
touch logkill.sh
chmod 777 logkill.sh

echo " echo \"labone2six\" | sudo -S kill -9 killarray ">>logkill.sh
echo "kill -9 killarray ">>logkill.sh
echo "rm ./Desktop/${folder}/kill_${device_dsn[m]}_${log_name}.txt delete.txt">>logkill.sh
echo "ps  -ef  | grep  ${device_dsn[m]} | tr -s ' ' | cut -d' ' -f2 | tr '\n\r' ' ' | xargs kill -9 ;exit">>logkill.sh
echo "exit">>logkill.sh

sed  -i "s/killarray/${kill_array[m]}/g" logkill.sh


ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no  "${host_address[m]}" 'bash -s'<./logkill.sh >delete.txt


ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six scp -o StrictHostKeyChecking=no "${host_address[m]}:./Desktop/${folder}/${device_dsn[m]}_${log_name}.txt" ./${folder}/${log_name}/  >delete.txt


rm logkill.sh

fi

 

}

logdelete() {


local g=0

while [[ ${g} -lt ${dsnlen} ]]
do

logrunhost=$( echo ${host_address[g]} | cut -d "@" -f 2 )

if [[ "${logrunhost}" != "${currenthost}"  ]]; then

#Deleting logs in different host after moving that to current host
if [[ -e deletefiles.sh ]]; then rm ./deletefiles.sh;  fi
touch deletefiles.sh
chmod 777 deletefiles.sh

echo "echo \"labone2six\" | sudo -S  rm  ./Desktop/${folder}/${device_dsn[g]}_${log_name}.txt ">>deletefiles.sh
echo  "rm  ./Desktop/${folder}/${device_dsn[g]}_${log_name}.txt; exit" >>deletefiles.sh
echo "exit" >>deletefiles.sh


ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${host_address[g]}" 'bash -s'<./deletefiles.sh >delete.txt

echo "deleted ${device_dsn[g]}_${log_name}.txt logfile in  ${host_address[g]} after moving to current host"

fi

((++g))

done

rm ./deletefiles.sh
}         



gaplessoffsetdrmloglines()
{

logrunhost=$( echo ${admhost} | cut -d "@" -f 2 )


if [[ "${logrunhost}" == "${currenthost}"  ]]; then
      
      if [[  "${domain_name}" == "gapless"   ]] ; then
           
		  touch ./${folder}/Error_loglines_${admdsn}.txt  ./${folder}/Gapless_loglines_${admdsn}.txt  ./${folder}/Katana_loglines_${admdsn}.txt 
          chmod 666  ./${folder}/Error_loglines_${admdsn}.txt  ./${folder}/Gapless_loglines_${admdsn}.txt  ./${folder}/Katana_loglines_${admdsn}.txt 
		  
		  
		  
		  timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep --line-buffered -i  'processGaplessMuxEndOfStream'>./${folder}/Error_loglines_${admdsn}.txt &
		  tmp=$( echo "$!" )
		  echo "Error loglines id: ${tmp}"
		  sleep 4
          disown -h $!
          gapless_array+=( $tmp )
		  
		  
		  timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep --line-buffered -i  'processGaplessMuxNewTrackSameStream'>./${folder}/Gapless_loglines_${admdsn}.txt &
		  tmp=$( echo "$!" ) 
		  echo "gapless loglines id: ${tmp}"
		  sleep 4
          disown -h $!
          gapless_array+=( $tmp )
          
		  
		  timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep --line-buffered -i 'PlaylistVariantManager:addVariant' >./${folder}/Katana_loglines_${admdsn}.txt  &
		  tmp=$( echo "$!" )
		  echo "katana loglines id: ${tmp}"
		  sleep 4
          disown -h $!
          gapless_array+=( $tmp )


       elif [[ "${domain_name}" == "offset"   ]] ; then
	  
	      touch ./${folder}/Offset_loglines_${admdsn}.txt 
		  chmod 666 ./${folder}/Offset_loglines_${admdsn}.txt 
		  
	      timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep  -E --line-buffered  'processAudioDownload\:reason=newPipeline|shouldKeepFrame|setupStreamOffsets' >./${folder}/Offset_loglines_${admdsn}.txt &
		  tmp=$( echo "$!" ) 
		  echo "offset loglines id: ${tmp}"
		  sleep 4
          disown -h $!
          offset_array+=( $tmp )
	  
	   elif [[ "${domain_name}" == "drm"   ]] ; then
		     
		  cd ${folder} 
		  touch ./Drm_loglines_${admdsn}.txt
		  chmod 666 ./Drm_loglines_${admdsn}.txt
		  
		  checkostype
		  echo "checkos">>checkostype.sh
		  echo "touch admos.txt">>checkostype.sh
		  echo "chmod 666 ./admos.txt">>checkostype.sh
		  sed -i  "s/dsn/${admdsn}/g"  checkostype.sh
		  sed -i  "s/interrupt/break/g" checkostype.sh
		  echo "echo \${ostype}>>admos.txt">> checkostype.sh
		  
		  #running checkostype to figure out the ostype of ADM and store it in admos.txt file
		  source ./checkostype.sh >delete.txt
		  tmp=$( cat ./admos.txt | tr -d '\n\r' )
		  echo "******Checking Playback Information in ADM ${admdsn} for every 2 Minutes upto 30 minutes*****">>./Drm_loglines_${admdsn}.txt
		     if [[ ${tmp} == "puffin" ]]; then

			      watch -n 120 "adb -s ${admdsn} shell lipc-get-prop com.doppler.whad audioPlayerTrackProtectionType | tee -a ./Drm_loglines_${admdsn}.txt" &>/dev/null &
				  tmp=$( echo "$!" ) 
		          sleep 2
                  disown -h $!
				  sleep 2
                  drm_array+=( $tmp )
			else
			   
			    watch -n 120 "adb -s ${admdsn} shell dumpsys activity service WhadService | grep -i  'trackProtectionName:' | tee -a ./Drm_loglines_${admdsn}.txt" &>/dev/null &
				tmp=$( echo "$!" ) 
		          sleep 2
                  disown -h $!
				  sleep 2
                  drm_array+=( $tmp )
			
			fi
		     
		    rm "checkostype.sh" "admos.txt"
			cd ..
		 
	    elif [[  "${domain_name}" == "tidal"  ]] ; then
		  
          cd ${folder} 
		  touch ./Tidal_loglines_${admdsn}.txt
		  chmod 666 ./Tidal_loglines_${admdsn}.txt
		  
		  checkostype
		  echo "checkos">>checkostype.sh
		  echo "touch admos.txt">>checkostype.sh
		  echo "chmod 666 ./admos.txt">>checkostype.sh
		  sed -i  "s/dsn/${admdsn}/g"  checkostype.sh
		  sed -i  "s/interrupt/break/g" checkostype.sh
		  echo "echo \${ostype}>>admos.txt">> checkostype.sh
		  
		  #running checkostype to figure out the ostype of ADM and store it in admos.txt file
		  source ./checkostype.sh >delete.txt
		  tmp=$( cat ./admos.txt | tr -d '\n\r' )
		  echo "******Checking Playback Information in ADM ${admdsn} for every 2 Minutes upto 30 minutes*****">>./Tidal_loglines_${admdsn}.txt 
		     if [[ ${tmp} == "puffin" ]]; then

			      watch -n 120 "adb -s ${admdsn} shell lipc-get-prop com.doppler.whad audioPlayerTrackProtectionType | tee -a ./Tidal_loglines_${admdsn}.txt" &>/dev/null &
				  tmp=$( echo "$!" ) 
		          sleep 2
                  disown -h $!
				  sleep 2
                  tidal_array+=( $tmp )
			else
			   
			    watch -n 120 "adb -s ${admdsn} shell dumpsys activity service WhadService | grep -i  'trackProtectionName:' | tee -a ./Tidal_loglines_${admdsn}.txt" &>/dev/null &
				tmp=$( echo "$!" ) 
		          sleep 2
                  disown -h $!
				  sleep 2
                  tidal_array+=( $tmp )
			
			fi
		     rm "checkostype.sh" "admos.txt"
		    cd ..
      
	  fi
		 
		 
		 

else

     if [[  "${domain_name}" == "gapless"   ]] ; then
	   
	      if [[ -e gapless.sh ]]; then rm ./gapless.sh; touch ./gapless.sh; else touch ./gapless.sh; fi 
	      chmod 777 gapless.sh
		  
		  
		  
		  echo "cd Desktop/${folder}/">>gapless.sh
		  echo "touch  Error_loglines_${admdsn}.txt   Gapless_loglines_${admdsn}.txt   Katana_loglines_${admdsn}.txt ">>gapless.sh
          echo "chmod  666  Error_loglines_${admdsn}.txt   Gapless_loglines_${admdsn}.txt   Katana_loglines_${admdsn}.txt">>gapless.sh
		  
		  echo "timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep --line-buffered -i  'processGaplessMuxEndOfStream'>./Error_loglines_${admdsn}.txt &">>gapless.sh
		  echo "echo  \$! >./kill_Error_loglines_${admdsn}.txt">>gapless.sh
          echo "sleep 4">>gapless.sh
		  echo "disown -h \$!">>gapless.sh
		  echo "sleep 2">>gapless.sh
		  
		  
		  echo "chmod  666  ./kill_Error_loglines_${admdsn}.txt">>gapless.sh
		  echo "exit">>gapless.sh
		  
		  
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./gapless.sh  >delete.txt
		  
		  
		  if [[ -e gapless.sh ]]; then rm ./gapless.sh; touch ./gapless.sh; else touch ./gapless.sh; fi 
	      chmod 777 gapless.sh
		  
          echo "cd Desktop/${folder}/">>gapless.sh
		  echo "touch kill_Gapless_loglines_${admdsn}.txt">>gapless.sh
		  echo "chmod 666  kill_Gapless_loglines_${admdsn}.txt ">>gapless.sh
		  echo "timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep --line-buffered -i  'processGaplessMuxNewTrackSameStream'>./Gapless_loglines_${admdsn}.txt &">>gapless.sh
		  echo "echo  \$! >./kill_Gapless_loglines_${admdsn}.txt">>gapless.sh
          echo "sleep 4">>gapless.sh
		  echo "disown -h \$!">>gapless.sh
		  echo "sleep 2">>gapless.sh
		  
		  echo "exit">>gapless.sh
		  
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./gapless.sh  >delete.txt
		  
		  
		  if [[ -e gapless.sh ]]; then rm ./gapless.sh; touch ./gapless.sh; else touch ./gapless.sh; fi
		  chmod 777 gapless.sh
		  
		   
		  echo "cd Desktop/${folder}/">>gapless.sh
		  echo "touch kill_Katana_loglines_${admdsn}.txt">>gapless.sh
		  echo "chmod 666  kill_Katana_loglines_${admdsn}.txt ">>gapless.sh
		  echo "timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep  -i --line-buffered 'PlaylistVariantManager:addVariant' >./Katana_loglines_${admdsn}.txt  &">>gapless.sh
		  echo "echo  \$! >./kill_Katana_loglines_${admdsn}.txt">>gapless.sh
          echo "sleep 4">>gapless.sh
		  echo "disown -h \$!">>gapless.sh
		  echo "sleep 2">>gapless.sh
          
		  
          echo "exit">>gapless.sh
		

          
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./gapless.sh  >delete.txt

          
          ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		  sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/kill_Error_loglines_${admdsn}.txt" ./  >delete.txt 	
          
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		  sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/kill_Gapless_loglines_${admdsn}.txt"   ./  >delete.txt
           
		   ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		   sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/kill_Katana_loglines_${admdsn}.txt"  ./   >delete.txt	
		  
		  
		  
		  tmp=$( cat kill_Error_loglines_${admdsn}.txt )
		  gapless_array+=( ${tmp} )
		  
		  tmp=$( cat kill_Gapless_loglines_${admdsn}.txt  )
		  gapless_array+=( ${tmp} )
		  
		  tmp=$( cat kill_Katana_loglines_${admdsn}.txt  )
		  gapless_array+=( ${tmp} )
		  
		  
		  rm  "kill_Katana_loglines_${admdsn}.txt"  "kill_Gapless_loglines_${admdsn}.txt"  "kill_Error_loglines_${admdsn}.txt" "gapless.sh"
		  
     elif [[ "${domain_name}" == "offset"   ]] ; then
	    
          if [[ -e offset.sh ]]; then rm ./offset.sh; touch ./offset.sh; else touch ./offset.sh; fi 
          chmod 777 offset.sh
		 
		  
		  echo "cd Desktop/${folder}/">>offset.sh 
		  echo "touch  Offset_loglines_${admdsn}.txt   kill_Offset_loglines_${admdsn}.txt ">>offset.sh
		  echo "chmod 666  Offset_loglines_${admdsn}.txt   kill_Offset_loglines_${admdsn}.txt ">>offset.sh
	      
		  echo "timeout 30m adb -s ${admdsn} shell  logcat -v threadtime | grep  -E  --line-buffered  'processAudioDownload\:reason=newPipeline|shouldKeepFrame|setupStreamOffsets' >./Offset_loglines_${admdsn}.txt &">>offset.sh
		  echo "echo  \$! >./kill_Offset_loglines_${admdsn}.txt">>offset.sh
          echo "sleep 4">>offset.sh
          echo "disown -h \$!">>offset.sh
		  echo "sleep 2">>offset.sh
          
		  echo "exit">>offset.sh
		  
		  
		  
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six  ssh  -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./offset.sh  >delete.txt

          ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/kill_Offset_loglines_${admdsn}.txt" ./  >delete.txt
		  
		  
		  tmp=$( cat kill_Offset_loglines_${admdsn}.txt )
		  offset_array+=( ${tmp} )
		   
		  rm  "kill_Offset_loglines_${admdsn}.txt" "offset.sh"

     elif [[ "${domain_name}" == "drm"   ]] ; then
	      
		  if [[ -e drm.sh ]]; then rm ./drm.sh;  fi 
		  touch ./drm.sh
          chmod 777 drm.sh
		  
		  echo "cd Desktop/${folder}">>drm.sh 
		  echo "touch  Drm_loglines_${admdsn}.txt   kill_Drm_loglines_${admdsn}.txt">>drm.sh
		  echo "chmod 666  Drm_loglines_${admdsn}.txt  kill_Drm_loglines_${admdsn}.txt  " >>drm.sh
		  echo "echo \"******Checking Playback Information in ADM ${admdsn} for every 2 Minutes upto 30 minutes***** \">>Drm_loglines_${admdsn}.txt">>drm.sh
		  checkostype
		  cat ./checkostype.sh >>drm.sh
		  echo "checkos">>drm.sh
		  sed -i  "s/dsn/${admdsn}/g"  drm.sh
		  sed -i  "s/interrupt/break/g" drm.sh
		  
		 echo "    if [[ \${ostype} == \"puffin\" ]]; then">>drm.sh

	     echo "          watch -n 120 \"adb -s ${admdsn} shell lipc-get-prop com.doppler.whad audioPlayerTrackProtectionType | tee -a ./Drm_loglines_${admdsn}.txt\" &>/dev/null &">>drm.sh
				 echo "echo  \$! >./kill_Drm_loglines_${admdsn}.txt">>drm.sh
                 echo "sleep 4">>drm.sh
                 echo "disown -h \$!">>drm.sh
		         echo "sleep 2">>drm.sh
				 echo "exit">>drm.sh
		echo "	else">>drm.sh
			   
		echo "	    watch -n 120 \"adb -s ${admdsn} shell dumpsys activity service WhadService | grep -i  'trackProtectionName:' | tee -a ./Drm_loglines_${admdsn}.txt\" &>/dev/null & ">>drm.sh
				echo "echo  \$! >./kill_Drm_loglines_${admdsn}.txt">>drm.sh
                 echo "sleep 4">>drm.sh
                 echo "disown -h \$!">>drm.sh
		         echo "sleep 2">>drm.sh
			     echo "exit">>drm.sh
		  echo "	fi ">>drm.sh
		echo "exit">>drm.sh
		    rm "checkostype.sh" 
		  
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./drm.sh  >delete.txt
		  
		  
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/kill_Drm_loglines_${admdsn}.txt" ./  >delete.txt
		  
		  
		  tmp=$( cat kill_Drm_loglines_${admdsn}.txt )
		  drm_array+=( ${tmp} )
		   
		  rm  "kill_Drm_loglines_${admdsn}.txt" "drm.sh"

         
	    elif [[ "${domain_name}" == "tidal"   ]] ; then
	       
		    
		  if [[ -e tidal.sh ]]; then rm ./tidal.sh;  fi 
		  touch ./tidal.sh
          chmod 777 tidal.sh
		  
		  echo "cd Desktop/${folder}">>tidal.sh 
		  echo "touch  Tidal_loglines_${admdsn}.txt   kill_Tidal_loglines_${admdsn}.txt ">>tidal.sh 
		  echo "chmod 666  Tidal_loglines_${admdsn}.txt  kill_Tidal_loglines_${admdsn}.txt" >>tidal.sh 
		  echo "echo \"******Checking Playback Information in ADM ${admdsn} for every 2 Minutes upto 30 minutes***** \">>Tidal_loglines_${admdsn}.txt">>tidal.sh 
		  checkostype
		  cat ./checkostype.sh >>tidal.sh 
		  echo "checkos">>tidal.sh 
		  sed -i  "s/dsn/${admdsn}/g"  tidal.sh 
		  sed -i  "s/interrupt/break/g" tidal.sh 
		  
		 echo "    if [[ \${ostype} == \"puffin\" ]]; then">>tidal.sh 

	      echo "          watch -n 120 \"adb -s ${admdsn} shell lipc-get-prop com.doppler.whad audioPlayerTrackProtectionType | tee -a ./Tidal_loglines_${admdsn}.txt\" &>/dev/null &">>tidal.sh 
				 echo "echo  \$! >./kill_Tidal_loglines_${admdsn}.txt">>tidal.sh 
                 echo "sleep 4">>tidal.sh 
                 echo "disown -h \$!">>tidal.sh 
		         echo "sleep 2">>tidal.sh 
				 echo "exit">>tidal.sh 
		 echo "	else">>tidal.sh 
			   
		 echo "	    watch -n 120 \"adb -s ${admdsn} shell dumpsys activity service WhadService | grep -i  'trackProtectionName:' | tee -a ./Tidal_loglines_${admdsn}.txt\" &>/dev/null & ">>tidal.sh 
				 echo "echo  \$! >./kill_Tidal_loglines_${admdsn}.txt">>tidal.sh 
                 echo "sleep 4">>tidal.sh 
                 echo "disown -h \$!">>tidal.sh 
		         echo "sleep 2">>tidal.sh 
			     echo "exit">>tidal.sh 
		       echo "	fi ">>tidal.sh 
		       echo "exit">>tidal.sh 
		    
		        rm "checkostype.sh" 
		   
		    ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./tidal.sh  >delete.txt
	 
	 
	      ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
          sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/kill_Tidal_loglines_${admdsn}.txt" ./  >delete.txt
		  
		  
		  tmp=$( cat kill_Tidal_loglines_${admdsn}.txt )
		  tidal_array+=( ${tmp} )
		   
		  rm  "kill_Tidal_loglines_${admdsn}.txt" "tidal.sh"
	 
	   fi



fi


rm ./${folder}/delete.txt


}

killgaplessoffsetdrm() 
{

logrunhost=$( echo ${admhost} | cut -d "@" -f 2 )



#if DSN is in current host 

     if [[ "${logrunhost}" == "${currenthost}"  ]]; then
	       if [[  "${domain_name}" == "gapless"   ]] ; then
				local le=0
				while [[ ${le} -lt 3 ]]
				do
					echo "labone2six" | sudo -S kill -9  "${gapless_array[le]}" >delete.txt 2>&1
					kill -9 "${gapless_array[le]}" >delete.txt 2>&1
					((++le))
				done
		   elif [[ "${domain_name}" == "offset"   ]] ; then
		        echo "labone2six" | sudo -S kill -9  "${offset_array[0]}">delete.txt 2>&1
			    kill -9 "${offset_array[0]}" >delete.txt 2>&1
		             
           elif [[ "${domain_name}" == "drm"  ]] ; then
			      
				echo "labone2six" | sudo -S kill -9  "${drm_array[0]}">delete.txt 2>&1
			    kill -9 "${drm_array[0]}" >delete.txt 2>&1
				
			elif [[  "${domain_name}" == "tidal"  ]] ; then 
					 echo "labone2six" | sudo -S kill -9  "${tidal_array[0]}">delete.txt 2>&1
			         kill -9 "${tidal_array[0]}" >delete.txt 2>&1
	          
			fi
			
			
	else
        if [[  "${domain_name}" == "gapless"   ]] ; then
			if [[ -e killgapless.sh ]]; then rm ./killgapless.sh; touch ./killgapless.sh; else touch ./killgapless.sh; fi    
			chmod 777 killgapless.sh
			
			echo " echo \"labone2six\" | sudo -S kill -9 ${gapless_array[0]}  ">>killgapless.sh
			echo "kill -9 ${gapless_array[0]} ">>killgapless.sh
       
			echo " echo \"labone2six\" | sudo -S kill -9 ${gapless_array[1]} ">>killgapless.sh
			echo "kill -9 ${gapless_array[1]}">>killgapless.sh
		   
			echo " echo \"labone2six\" | sudo -S kill -9 ${gapless_array[2]} ">>killgapless.sh
			echo "kill -9 ${gapless_array[2]} ">>killgapless.sh
			echo "cd ./Desktop/${folder} ">>killgapless.sh
			echo " echo \"labone2six\" | sudo  -S  rm ./kill_Gapless_loglines_${admdsn}.txt ">>killgapless.sh
            echo "echo \"labone2six\" | sudo  -S  rm ./kill_Error_loglines_${admdsn}.txt">>killgapless.sh
			echo "echo \"labone2six\" | sudo  -S  rm ./kill_Katana_loglines_${admdsn}.txt">>killgapless.sh
			echo "rm ./kill_Gapless_loglines_${admdsn}.txt  ./kill_Error_loglines_${admdsn}.txt ./kill_Katana_loglines_${admdsn}.txt;exit">>killgapless.sh
			echo "exit">>killgapless.sh

			ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
			sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./killgapless.sh  >delete.txt
			


		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		  sshpass -p labone2six scp -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/Katana_loglines_${admdsn}.txt" ./${folder}/ >delete.txt
		  
		  
		  ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		  sshpass -p labone2six scp -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/Error_loglines_${admdsn}.txt" ./${folder}/ >delete.txt

          ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		  sshpass -p labone2six scp -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/Gapless_loglines_${admdsn}.txt" ./${folder}/ >delete.txt
            
		 
		 rm "killgapless.sh"  
			
		elif [[ "${domain_name}" == "offset"   ]] ; then
		    
			if [[ -e killoffset.sh ]]; then rm ./killoffset.sh; touch ./killoffset.sh; else touch ./killoffset.sh; fi    
			chmod 777 killoffset.sh
			
			echo " echo \"labone2six\" | sudo -S kill -9 ${offset_array[0]} ">>killoffset.sh
			echo "kill -9 ${offset_array[0]}">>killoffset.sh
			echo "cd ./Desktop/${folder} ">>killoffset.sh
		    echo "echo \"labone2six\" | sudo -S rm  kill_Offset_loglines_${admdsn}.txt">>killoffset.sh
		    echo "rm  kill_Offset_loglines_${admdsn}.txt;exit">>killoffset.sh
			echo "exit">>killoffset.sh
			
			ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
			sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./killoffset.sh  >delete.txt
   
           ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		   sshpass -p labone2six scp -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/Offset_loglines_${admdsn}.txt" ./${folder}/ >delete.txt
			
	    
		 
		   rm "killoffset.sh" 
			 
	 elif [[ "${domain_name}" == "drm"   ]] ; then
		    
			if [[ -e killdrm.sh ]]; then rm ./killdrm.sh; fi    
			chmod 777 killdrm.sh
		  
		    echo " echo \"labone2six\" | sudo -S kill -9  "${drm_array[0]}" ">>killdrm.sh 
			echo " kill -9 "${drm_array[0]}" ">>killdrm.sh
			echo "cd ./Desktop/${folder}">>killdrm.sh
			echo "echo \"labone2six\" | sudo -S rm  kill_Drm_loglines_${admdsn}.txt">>killdrm.sh
			echo "rm  kill_Drm_loglines_${admdsn}.txt; exit">>killdrm.sh
			echo "exit">>killdrm.sh
			
			ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
			sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./killdrm.sh >delete.txt
   
           ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		   sshpass -p labone2six scp -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/Drm_loglines_${admdsn}.txt" ./${folder}/ >delete.txt
		  
		  
		    rm  "killdrm.sh"
	 
	 elif [[  "${domain_name}" == "tidal"  ]] ; then
		
		if [[ -e killtidal.sh ]]; then rm ./killtidal.sh; fi    
			chmod 777 killtidal.sh
		
		  
		    echo " echo \"labone2six\" | sudo -S kill -9  "${tidal_array[0]}" ">>killtidal.sh 
			echo " kill -9 "${tidal_array[0]}" ">>killtidal.sh
			echo "cd Desktop/${folder}/ ">>killtidal.sh
			echo "echo \"labone2six\" | sudo -S rm  kill_Tidal_loglines_${admdsn}.txt">>killtidal.sh
			echo "rm  kill_Tidal_loglines_${admdsn}.txt;exit">>killtidal.sh
			echo "exit">>killtidal.sh
			
			ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
			sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./killtidal.sh >delete.txt
   
           ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
		   sshpass -p labone2six scp -o StrictHostKeyChecking=no "${admhost}:./Desktop/${folder}/Tidal_loglines_${admdsn}.txt" ./${folder}/ >delete.txt
		
		    rm  "killtidal.sh" 
		
		
	fi




 fi


}




deletedrmtidalgaplessoffset()

{
  logrunhost=$( echo ${admhost} | cut -d "@" -f 2 )
  
  
if [[  "${domain_name}" == "gapless"   ]] ; then
# deleting gapless , Katana and error loglines file in admhost
		 if [[ -e deletefiles.sh ]]; then rm ./deletefiles.sh;  fi
		 touch deletefiles.sh
         chmod 777 deletefiles.sh
         
		 echo "cd ./Desktop/${folder} ">>deletefiles.sh
         echo "echo \"labone2six\" | sudo -S  rm  Katana_loglines_${admdsn}.txt" >>deletefiles.sh
		 echo "echo \"labone2six\" | sudo -S rm   Error_loglines_${admdsn}.txt" >>deletefiles.sh
		 echo "echo \"labone2six\" | sudo -S rm   Gapless_loglines_${admdsn}.txt">>deletefiles.sh
         echo " rm Katana_loglines_${admdsn}.txt   Error_loglines_${admdsn}.txt Gapless_loglines_${admdsn}.txt;exit">>deletefiles.sh
		 echo "exit" >>deletefiles.sh

        ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
        sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./deletefiles.sh >delete.txt


elif [[ "${domain_name}" == "offset"   ]] ; then
 # deleting offset loglines file in admhost
	     if [[ -e deletefiles.sh ]]; then rm ./deletefiles.sh;  fi
		 touch deletefiles.sh
         chmod 777 deletefiles.sh
         echo "cd ./Desktop/${folder} ">>deletefiles.sh
         echo "echo \"labone2six\" | sudo -S  rm  Offset_loglines_${admdsn}.txt" >>deletefiles.sh
		 echo "rm Offset_loglines_${admdsn}.txt;exit" >>deletefiles.sh
		 echo "exit" >>deletefiles.sh

        ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
        sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./deletefiles.sh >delete.txt
		 
		 
elif [[ "${domain_name}" == "drm"   ]] ; then
# deleting drm loglines file in admhost
		 if [[ -e deletefiles.sh ]]; then rm ./deletefiles.sh;  fi
		 touch deletefiles.sh
         chmod 777 deletefiles.sh
         
		 echo "cd ./Desktop/${folder}">>deletefiles.sh
         echo "echo \"labone2six\" | sudo -S  rm  Drm_loglines_${admdsn}.txt" >>deletefiles.sh
		 echo "rm  Drm_loglines_${admdsn}.txt ;exit" >>deletefiles.sh
		 echo "exit" >>deletefiles.sh

        ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
        sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./deletefiles.sh >delete.txt
		
elif [[  "${domain_name}" == "tidal"  ]] ; then


 # deleting tidal loglines file in admhost
		 if [[ -e deletefiles.sh ]]; then rm ./deletefiles.sh;  fi
		 touch deletefiles.sh
         chmod 777 deletefiles.sh
         echo "cd Desktop/${folder}/ ">>deletefiles.sh
         echo "echo \"labone2six\" | sudo -S  rm  Tidal_loglines_${admdsn}.txt">>deletefiles.sh
		 echo " rm  Tidal_loglines_${admdsn}.txt ; exit">>deletefiles.sh
		 echo "exit" >>deletefiles.sh

        ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
        sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${admhost}" 'bash -s'<./deletefiles.sh >delete.txt





fi

}








#function to create checkostype.sh at runtime, which determines OS type of any DSN

checkostype() {

if [[ -e checkostype.sh ]]
then
rm checkostype.sh
fi
touch checkostype.sh
chmod 777 checkostype.sh


echo "declare -a fos5">>checkostype.sh
echo "declare -a fos6">>checkostype.sh
echo "declare -a fos7">>checkostype.sh
echo "declare -a puffin">>checkostype.sh
echo "     ">>checkostype.sh
echo "     ">>checkostype.sh
echo "fos5=( \"biscuit\" \"sonar\" \"radar\"  \"bishop\" \"rook\" \"knight\" )">>checkostype.sh
echo "fos6=( \"donut\" \"lidar\" \"cupcake\" \"pablo\" \"octave\" \"kyanite\" \"sapphire\" \"checkers\" \"crown\" \"mantis\" \"needle\" \"stark\"  \"cronos\" )">>checkostype.sh
echo "fos7=( \"raven\" \"theia\" \"athena\" \"sheldon\" \"sheldonp\" )">>checkostype.sh
echo "puffin=( \"doebrite\" \"crumpet\" \"pascal\" \"croissant\" \"laser\" \"brownie\" \"ganache\" )" >>checkostype.sh
echo "     ">>checkostype.sh
echo "     ">>checkostype.sh
echo "ostype=\"none\"">>checkostype.sh

echo "if [[ -e dev.txt ]] ; then" >>checkostype.sh
echo "rm dev.txt"  >>checkostype.sh
echo "touch dev.txt">>checkostype.sh
echo "else" >>checkostype.sh
echo "touch dev.txt">>checkostype.sh
echo "chmod 666 ./dev.txt">>checkostype.sh
echo "fi" >>checkostype.sh


echo "adb devices -l | tr -s \" \" | cut -d \" \" -f 1,6 | sed '1d'| sed '$d' | sed 's/ device:/_/g' >dev.txt">>checkostype.sh
echo "device=\$( cat ./dev.txt | grep -i dsn | cut -d \"_\" -f 2 | tr -d ' \n\r' )">>checkostype.sh
echo "rm ./dev.txt">>checkostype.sh


echo " echo \"\${device}\"">>checkostype.sh


echo "checkos() {">>checkostype.sh
echo "                       ">>checkostype.sh
echo "   local check">>checkostype.sh
echo "   check=( \"fos5\" \"fos6\" \"fos7\" \"puffin\" )">>checkostype.sh
echo "   local flag=0">>checkostype.sh
echo "                        ">>checkostype.sh
echo "   for a in \${check[@]}">>checkostype.sh
echo "   do">>checkostype.sh
echo "                          ">>checkostype.sh
echo "      abd=\"\${a}[@]\"">>checkostype.sh
echo "      for each in \${!abd}">>checkostype.sh
echo "      do">>checkostype.sh
echo "                          ">>checkostype.sh
echo "         if [[ \"\${each}\" == \"\${device}\" ]]; then">>checkostype.sh
echo "         ((++flag))">>checkostype.sh
echo "          interrupt">>checkostype.sh
echo "          fi">>checkostype.sh      
echo "      done">>checkostype.sh
echo "    if [[ \"\${flag}\" -eq 1 ]]; then">>checkostype.sh
echo "                                  ">>checkostype.sh         
echo "       if [[ \"\${a}\" == \"fos5\" ||  \"\${a}\" == \"fos6\" ]]; then">>checkostype.sh
echo "                                     ">>checkostype.sh 
echo "          ostype=\"fos5_6\"">>checkostype.sh 
echo "       else">>checkostype.sh  
echo "          ostype=\"\${a}\"">>checkostype.sh 
echo "       fi">>checkostype.sh 
echo "       interrupt">>checkostype.sh 
echo "    fi">>checkostype.sh 
echo "   done">>checkostype.sh 
echo "                          ">>checkostype.sh
echo " }">>checkostype.sh 



}



#function which creates checkplaying.sh at runtime , for checking whether the particular DSN is still playing WHA music

checkplaying() {




logrunhost=$( echo ${host_address[num]} | cut -d "@" -f 2 | tr -d " \n\r" )

checkostype

if [[ -e checkplaying.sh ]]
then
rm checkplaying.sh
fi
touch checkplaying.sh
chmod 777 checkplaying.sh


#adds checkostype.sh into checkplaying.sh

cat ./checkostype.sh>checkplaying.sh




if [[ "${logrunhost}" == "${currenthost}"  ]]; then

echo "cd ./folder">>checkplaying.sh
echo "if [[ -e playbackstate.txt ]] ; then" >>checkplaying.sh
echo "rm playbackstate.txt"  >>checkplaying.sh
echo "touch playbackstate.txt" >>checkplaying.sh
echo "else" >>checkplaying.sh
echo "touch playbackstate.txt" >>checkplaying.sh
echo "fi">>checkplaying.sh

echo "if [[ -e tmp.txt ]] ; then" >>checkplaying.sh
echo "rm tmp.txt"  >>checkplaying.sh
echo "touch tmp.txt">>checkplaying.sh
echo "else" >>checkplaying.sh
echo "touch tmp.txt">>checkplaying.sh
echo "fi">>checkplaying.sh

echo "if [[ -e logtrace.txt ]]; then rm ./logtrace.txt;touch ./logtrace.txt; else touch ./logtrace.txt; fi " >>checkplaying.sh

echo "chmod 666  playbackstate.txt tmp.txt logtrace.txt">>checkplaying.sh

else

echo "cd Desktop/folder">>checkplaying.sh
echo "if [[ -e playbackstate.txt ]] ; then" >>checkplaying.sh
echo "rm playbackstate.txt"  >>checkplaying.sh
echo "fi" >>checkplaying.sh
echo "touch playbackstate.txt" >>checkplaying.sh

echo "if [[ -e tmp.txt ]] ; then" >>checkplaying.sh
echo "rm tmp.txt"  >>checkplaying.sh
echo "fi" >>checkplaying.sh
echo "touch tmp.txt">>checkplaying.sh



echo "if [[ -e logtrace.txt ]]; then rm ./logtrace.txt;touch ./logtrace.txt; else touch ./logtrace.txt; fi " >>checkplaying.sh

echo "chmod 666  playbackstate.txt tmp.txt logtrace.txt">>checkplaying.sh

fi

echo "                          ">>checkplaying.sh
echo "checkos">>checkplaying.sh 
echo "echo \"\${ostype}\"">>checkplaying.sh 
echo "                          ">>checkplaying.sh
echo "p=0">>checkplaying.sh   
echo "while true">>checkplaying.sh 
echo "do">>checkplaying.sh 
echo "                          ">>checkplaying.sh
echo "  #getting playingstate based on OS">>checkplaying.sh
echo "  if [[ \${ostype} == \"fos5_6\" ]] ; then">>checkplaying.sh
echo "                          ">>checkplaying.sh



echo "          adb -s dsn shell dumpsys media_session | grep -i \"state=PlaybackState\"  >tmp.txt">>checkplaying.sh
echo "          state=\$( cat ./tmp.txt |  tr -d  \" \\n\\r\" | sed -n \"1p\" | cut -d \"{\" -f 2- | cut -d\",\" -f1 )">>checkplaying.sh


echo "                          ">>checkplaying.sh
echo "  elif [[  \${ostype} == \"fos7\"  ]] ; then">>checkplaying.sh
echo "                          ">>checkplaying.sh



echo "                          ">>checkplaying.sh
echo "          adb -s dsn shell dumpsys audio | grep -i \"content=CONTENT_TYPE_MUSIC\"  >tmp.txt">>checkplaying.sh
echo "          state=\$(  cat ./tmp.txt |  grep -i  \"state:\"  | tail -1 | tr -d \" \\n\\r\" | tr -s \"-\" | cut -d\"-\" -f 4 | cut -d\":\" -f2  )">>checkplaying.sh
echo "     state=\"\${state,,}\"">>checkplaying.sh
echo "  else">>checkplaying.sh


echo "        adb -s dsn shell lipc-get-prop com.doppler.whad playbackState | grep -i \"state:\"  >tmp.txt">>checkplaying.sh
echo "        state=\$( cat ./tmp.txt |  tr -d  \" \\n\\r\" | cut -d\":\" -f2 )">>checkplaying.sh

echo "     state=\"\${state,,}\"">>checkplaying.sh
echo "  fi">>checkplaying.sh
echo "                          ">>checkplaying.sh
echo " echo \"\${state}\"">>checkplaying.sh
echo "  #Checking Playing or not">>checkplaying.sh
echo "                          ">>checkplaying.sh
echo "  if [[ \"\${state}\" == \"state=3\" ]] || [[ \"\${state}\" ==  \"started\" ]] || [[ \"\${state}\" ==  \"playing\" ]]; then">>checkplaying.sh
echo "                          ">>checkplaying.sh
echo "     echo \"playingfine\">./playbackstate.txt">>checkplaying.sh
echo  "    if [[  -d  /proc/processid/  ]]; then  echo \"PID: processid : Log still running for dsn\">logtrace.txt; elif [[ ! -d /proc/processid/ ]]; then echo \"PID: processid : Log stopped for dsn\">logtrace.txt; fi">>checkplaying.sh
echo "     rm ./tmp.txt">>checkplaying.sh
echo "     break">>checkplaying.sh
echo "  else">>checkplaying.sh
echo "     if [[ \${p} -lt 4  ]]; then">>checkplaying.sh
echo "        ((++p))">>checkplaying.sh
echo "	      sleep 45s">>checkplaying.sh
echo "	      continue">>checkplaying.sh
echo "     else">>checkplaying.sh
echo "                          ">>checkplaying.sh
echo "        echo \"playbackstopped\">./playbackstate.txt">>checkplaying.sh
echo  "    if [[  -d  /proc/processid/  ]]; then echo \"PID: processid : Log still running for dsn\">logtrace.txt; elif [[ ! -d /proc/processid/ ]]; then echo \"PID: processid : Log stopped for dsn\">logtrace.txt; fi">>checkplaying.sh
echo "        rm ./tmp.txt">>checkplaying.sh
echo "        break">>checkplaying.sh
echo "     fi">>checkplaying.sh
echo "  fi">>checkplaying.sh
echo "                ">>checkplaying.sh
echo "done">>checkplaying.sh 
echo "                ">>checkplaying.sh




sed -i  "s/dsn/${device_dsn[num]}/g"  checkplaying.sh
sed -i  "s/folder/${folder}/g"  checkplaying.sh
sed  -i "s/processid/${kill_array[num]}/g" checkplaying.sh

if [[ "${logrunhost}" == "${currenthost}"  ]]; then


sed -i  "s/interrupt/break/g"  checkplaying.sh
echo "cd ..">>checkplaying.sh
source ./checkplaying.sh >delete.txt 


else

sed -i  "s/break/exit/g"  checkplaying.sh
sed -i  "s/interrupt/break/g"  checkplaying.sh

ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no   "${host_address[num]}" 'bash -s'<./checkplaying.sh >delete.txt

ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}"
sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${host_address[num]}:./Desktop/${folder}/playbackstate.txt" ./${folder}/ >>delete.txt
sshpass -p labone2six scp  -o StrictHostKeyChecking=no "${host_address[num]}:./Desktop/${folder}/logtrace.txt" ./${folder}/ >>delete.txt


# deleting playback related files in different host
 if [[ -e deletefiles.sh ]]; then rm ./deletefiles.sh;  fi
touch deletefiles.sh
chmod 777 deletefiles.sh

echo "echo \"labone2six\" | sudo -S  rm  ./Desktop/${folder}/playbackstate.txt" >>deletefiles.sh
echo "echo \"labone2six\" | sudo -S  rm  ./Desktop/${folder}/logtrace.txt;exit" >>deletefiles.sh
echo "exit" >>deletefiles.sh

ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six  ssh -tt -o StrictHostKeyChecking=no  "${host_address[num]}" 'bash -s'<./deletefiles.sh >delete.txt

rm "deletefiles.sh"

fi

rm  ./checkostype.sh ./checkplaying.sh

}



#function which creates startmusic.sh at runtime for specific domain, for initiating music in target Host&DSN
startmusic() {


checkostype

if [[ -e startmusic.sh ]]
then
rm startmusic.sh
fi

touch startmusic.sh
chmod 777 startmusic.sh


cat ./checkostype.sh>./startmusic.sh
echo "checkos">>./startmusic.sh

logrunhost=$( echo ${targethost} | cut -d "@" -f 2 | tr -d " \n\r" )

if [[ "${logrunhost}" == "${currenthost}"  ]]; then

echo "cd folder">>startmusic.sh
echo " if [[ -e tmp.txt ]] ; then">>startmusic.sh
echo " rm tmp.txt">>startmusic.sh
echo "touch tmp.txt">>startmusic.sh
echo "else"  >>startmusic.sh
echo "touch tmp.txt">>startmusic.sh
echo "fi"  >>startmusic.sh

echo "chmod 666 tmp.txt">>startmusic.sh

else

echo "cd Desktop/folder">>startmusic.sh
echo " if [[ -e tmp.txt ]] ; then">>startmusic.sh
echo " rm tmp.txt">>startmusic.sh
echo "touch tmp.txt">>startmusic.sh
echo "else"  >>startmusic.sh
echo "touch tmp.txt">>startmusic.sh
echo "fi">>startmusic.sh
echo "chmod 666 tmp.txt">>startmusic.sh
fi

echo " echo domain_name">>startmusic.sh
echo "echo group">>startmusic.sh
echo "                          ">>startmusic.sh
echo "echo \${ostype}">>startmusic.sh 
echo "                          ">>startmusic.sh
echo "flagcheck=0">>startmusic.sh 
echo "count=0">>startmusic.sh 
echo "while [[ \"\${count}\" -lt 3 ]]">>startmusic.sh 
echo "do">>startmusic.sh 
echo "    if [[ \"\${ostype}\" == \"fos5_6\" ]] ; then">>startmusic.sh
echo "                          ">>startmusic.sh
echo "#pushing wav file and initiating playbackState">>startmusic.sh
echo "                          ">>startmusic.sh
echo "          if [[ \"\${flagcheck}\" -eq 0 ]] ; then">>startmusic.sh
echo "               adb -s dsn push /usr/speech/group/loopmodeon.wav /sdcard/">>startmusic.sh
echo "               adb -s dsn push /usr/speech/group/stop.wav /sdcard/">>startmusic.sh
echo "               adb -s dsn push /usr/speech/group/domain_name.wav /sdcard/">>startmusic.sh 
echo "               adb -s dsn push /usr/speech/group/yes.wav /sdcard/">>startmusic.sh
echo "               ((++flagcheck))">>startmusic.sh
echo "          fi">>startmusic.sh
echo "                          ">>startmusic.sh
echo "#initiating current  playback">>startmusic.sh
echo "          adb -s dsn shell am startservice -n com.amazon.knight.test.support/.SpeechInjectorService">>startmusic.sh
echo "          adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/domain_name.wav">>startmusic.sh
echo "          sleep 10">>startmusic.sh
if [[ "${domain_name}" == "siriusxm"   ]] ; then
echo "          adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/yes.wav">>startmusic.sh
echo "          sleep 15">>startmusic.sh
fi
echo "                          ">>startmusic.sh
echo " sleep 15">>startmusic.sh
echo "                          ">>startmusic.sh
echo "#Checking state after VUI injection">>startmusic.sh
echo "                          ">>startmusic.sh
echo "          adb -s dsn shell dumpsys media_session | grep -i \"state=PlaybackState\"  >tmp.txt">>startmusic.sh
echo "          state=\$( cat ./tmp.txt |  tr -d  \" \\n\\r\" | sed -n \"1p\" | cut -d \"{\" -f 2- | cut -d\",\" -f1 )">>startmusic.sh
echo "                          ">>startmusic.sh
echo "                          ">>startmusic.sh



echo "                          ">>startmusic.sh
echo "    elif [[  \"\${ostype}\" == \"fos7\"  ]] ; then">>startmusic.sh
echo "                          ">>startmusic.sh
echo "#pushing wav file and initiating playback, wait for few seconds">>startmusic.sh
echo "                          ">>startmusic.sh
echo "          if [[ \"\${flagcheck}\" -eq  0 ]]; then">>startmusic.sh
echo "               adb -s dsn push /usr/speech/group/loopmodeon.wav /sdcard/">>startmusic.sh
echo "              adb -s dsn push /usr/speech/group/stop.wav /sdcard/">>startmusic.sh
echo "              adb -s dsn push /usr/speech/group/domain_name.wav /sdcard/">>startmusic.sh
echo "               adb -s dsn push /usr/speech/group/yes.wav /sdcard/">>startmusic.sh
echo "              ((++flagcheck))">>startmusic.sh
echo "          fi">>startmusic.sh
echo "                          ">>startmusic.sh
echo "                          ">>startmusic.sh
echo "#initiating current playback">>startmusic.sh
echo "          adb -s dsn shell am startservice -n com.amazon.knight.test.support/.SpeechInjectorService">>startmusic.sh
echo "          adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/domain_name.wav">>startmusic.sh
echo "          sleep 10">>startmusic.sh

if [[  "${domain_name}" == "siriusxm"   ]] ; then
echo "          adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/yes.wav">>startmusic.sh
echo "          sleep 15">>startmusic.sh
fi

echo " sleep 15">>startmusic.sh



echo "#Checking state after VUI injection">>startmusic.sh
echo "                          ">>startmusic.sh
echo "          adb -s dsn shell dumpsys audio | grep -i \"content=CONTENT_TYPE_MUSIC\"  >tmp.txt">>startmusic.sh
echo "          state=\$(  cat ./tmp.txt |  grep -i  \"state:\"  | tail -1 | tr -d \" \\n\\r\" | tr -s \"-\" | cut -d\"-\" -f 4 | cut -d\":\" -f2  )">>startmusic.sh

echo "                          ">>startmusic.sh
echo "   else ">>startmusic.sh

echo "         if [[ \"\${flagcheck}\" -eq  0 ]] ; then">>startmusic.sh

echo "              adb -s dsn push /usr/speech/group/stop.wav /data/mixer_meta/">>startmusic.sh
echo "              adb -s dsn push /usr/speech/group/loopmodeon.wav /data/mixer_meta/">>startmusic.sh
echo "              adb -s dsn push  /usr/speech/group/domain_name.wav  /data/mixer_meta/">>startmusic.sh
echo "              adb -s dsn push  /usr/speech/group/yes.wav  /data/mixer_meta/">>startmusic.sh
echo "              ((++flagcheck))">>startmusic.sh
echo "         fi">>startmusic.sh
echo "                          ">>startmusic.sh
echo "                          ">>startmusic.sh
echo "#initiating Current playback">>startmusic.sh
echo "        adb -s dsn shell lipc-set-prop -s com.doppler.audiod PassThrough  /data/mixer_meta/domain_name.wav">>startmusic.sh
echo "          sleep 10">>startmusic.sh
if [[   "${domain_name}" == "siriusxm"  ]] ; then
echo "        adb -s dsn shell lipc-set-prop -s com.doppler.audiod PassThrough  /data/mixer_meta/yes.wav">>startmusic.sh
echo "        sleep 15">>startmusic.sh
fi
echo "                          ">>startmusic.sh
echo " sleep 15">>startmusic.sh
echo "#Checking state after VUI injection">>startmusic.sh
echo "        adb -s dsn shell lipc-get-prop com.doppler.whad playbackState | grep -i \"state:\"  >tmp.txt">>startmusic.sh
echo "        state=\$( cat ./tmp.txt |  tr -d  \" \\n\\r\" | cut -d\":\" -f2 )">>startmusic.sh

echo "                          ">>startmusic.sh
echo "   fi">>startmusic.sh


echo "state=\"\${state,,}\"">>startmusic.sh

echo " #Checking Playing or not, After initiating" >>startmusic.sh
echo "                          ">>startmusic.sh
echo "if [[ \"\${state}\" ==  \"state=3\"  ||  \"\${state}\" ==  \"started\"  ||  \"\${state}\" ==  \"playing\" ]]; then">>startmusic.sh
echo "   echo \"playingfine\"">>startmusic.sh
echo "   rm  ./tmp.txt">>startmusic.sh

if [[  "${domain_name}" ==  "katana"  ||  "${domain_name}" ==  "tidal" ]]; then

echo "       if [[ \"\${ostype}\" == \"fos5_6\" || \"\${ostype}\" == \"fos7\" ]] ; then">>startmusic.sh
echo "           adb -s dsn shell am startservice -n com.amazon.knight.test.support/.SpeechInjectorService">>startmusic.sh
echo "           adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/loopmodeon.wav">>startmusic.sh
echo "           sleep 15">>startmusic.sh
echo "       else">>startmusic.sh
echo "           adb -s dsn shell lipc-set-prop -s com.doppler.audiod PassThrough  /data/mixer_meta/loopmodeon.wav">>startmusic.sh
echo "            sleep 15">>startmusic.sh
echo "       fi">>startmusic.sh
fi


if [[  "${domain_name}" ==  "audible" ]]; then

echo "       if [[ \"\${ostype}\" == \"fos5_6\" || \"\${ostype}\" == \"fos7\" ]] ; then">>startmusic.sh
echo "           adb -s dsn shell am startservice -n com.amazon.knight.test.support/.SpeechInjectorService">>startmusic.sh
echo "           adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/chapterone.wav">>startmusic.sh
echo "           sleep 15">>startmusic.sh
echo "       else">>startmusic.sh
echo "           adb -s dsn shell lipc-set-prop -s com.doppler.audiod PassThrough  /data/mixer_meta/chapterone.wav">>startmusic.sh
echo "            sleep 15">>startmusic.sh
echo "       fi">>startmusic.sh
fi


echo "   break">>startmusic.sh
echo "else">>startmusic.sh
echo " ((++count)) ">>startmusic.sh
echo "  if [[ \"\${count}\" -eq 3 ]]; then ">>startmusic.sh
echo "    echo 'cant initiate playback'">>startmusic.sh
echo "     rm  ./tmp.txt">>startmusic.sh
echo "    break ">>startmusic.sh
echo "  fi">>startmusic.sh
echo " continue ">>startmusic.sh
echo "fi">>startmusic.sh

echo "done ">>startmusic.sh






sed -i  "s/dsn/${targetdsn}/g" startmusic.sh
sed -i  "s/group/${group}/g" startmusic.sh
sed -i  "s/domain_name/${domain_name}/g" startmusic.sh
sed -i  "s/folder/${folder}/g"  startmusic.sh




if [[ "${logrunhost}" == "${currenthost}"  ]]; then
sed -i  "s/interrupt/break/g"  startmusic.sh
echo "cd ..">>startmusic.sh
source  ./startmusic.sh >../delete.txt
echo "Music initiated from inside"

#recording playback starting time
echo " ${domain_name}">>./${folder}/playbacktime.txt
echo "Starting time">>./${folder}/playbacktime.txt
TZ='Asia/Kolkata' date>>./${folder}/playbacktime.txt



else

sed -i  "s/break/exit/g"  startmusic.sh
sed -i  "s/interrupt/break/g"  startmusic.sh
ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >./delete.txt
sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no  "${targethost}" 'bash -s'< ./startmusic.sh  >delete.txt
echo "Music initiated from outside"

#recording playback starting time
echo " ${domain_name}">>./${folder}/playbacktime.txt
echo "Starting time">>./${folder}/playbacktime.txt
TZ='Asia/Kolkata' date>>./${folder}/playbacktime.txt

fi

rm ./delete.txt   ./checkostype.sh ./startmusic.sh

}



#function which stops the playback at Target Host&DSN
stopmusic() {

checkostype

if [[ -e stopmusic.sh ]]
then
rm stopmusic.sh
fi
touch stopmusic.sh
chmod 777 stopmusic.sh

cat ./checkostype.sh>>./stopmusic.sh
echo "checkos">>./stopmusic.sh

logrunhost=$( echo ${targethost} | cut -d "@" -f 2 | tr -d " \n\r" )

if [[ "${logrunhost}" == "${currenthost}"  ]]; then

echo "cd folder">>stopmusic.sh
echo " if [[ -e tmp.txt ]] ; then">>stopmusic.sh
echo " rm tmp.txt">>stopmusic.sh
echo "fi"  >>stopmusic.sh
echo "touch tmp.txt">>stopmusic.sh
echo " chmod 666 tmp.txt">>stopmusic.sh

else

echo "cd Desktop/folder">>stopmusic.sh
echo " if [[ -e tmp.txt ]] ; then">>stopmusic.sh
echo " rm tmp.txt">>stopmusic.sh
echo "fi"  >>stopmusic.sh
echo "touch tmp.txt">>stopmusic.sh
echo " chmod 666 tmp.txt">>stopmusic.sh

fi




echo " echo domain_name">>stopmusic.sh
echo "echo group">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "echo \${ostype}">>stopmusic.sh 
echo "                          ">>stopmusic.sh
echo "u=0">>stopmusic.sh
echo "flagcheck=0">>stopmusic.sh   
echo "while true">>stopmusic.sh 
echo "do">>stopmusic.sh 
echo "    if [[ \"\${ostype}\" == \"fos5_6\" ]] ; then">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "#pushing stop wav file ">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "          if [[ \"\${flagcheck}\" -eq 0 ]] ; then">>stopmusic.sh
echo "               adb -s dsn push /usr/speech/group/stop.wav /sdcard/">>stopmusic.sh
echo "               ((++flagcheck))">>stopmusic.sh
echo "          fi">>stopmusic.sh
echo "          #issuing stop utterance                ">>stopmusic.sh
echo "           adb -s dsn shell am startservice -n com.amazon.knight.test.support/.SpeechInjectorService">>stopmusic.sh 
echo "           adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/stop.wav">>stopmusic.sh
echo "           sleep 20">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "#Checking state after Stop">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "          adb -s dsn shell dumpsys media_session | grep -i \"state=PlaybackState\"  >tmp.txt">>stopmusic.sh
echo "          state=\$( cat ./tmp.txt | sed -n \"1p\" | cut -d \"{\" -f 2- | cut -d\",\" -f1 )">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "    elif [[  \"\${ostype}\" == \"fos7\"  ]] ; then">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "#pushing stop wav file ">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "          if [[ \"\${flagcheck}\" -eq 0 ]]; then">>stopmusic.sh
echo "              adb -s dsn push /usr/speech/group/stop.wav /sdcard/">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "              ((++flagcheck))">>stopmusic.sh
echo "          fi">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "          adb -s dsn shell am startservice -n com.amazon.knight.test.support/.SpeechInjectorService">>stopmusic.sh
echo "          adb -s dsn shell am broadcast -a amazon.speech.SEND_FILE_TO_WW --es audioPath  /sdcard/stop.wav">>stopmusic.sh
echo "          sleep 20">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "#Checking state after Stop">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "          adb -s dsn shell dumpsys audio | grep -i \"content=CONTENT_TYPE_MUSIC\"  >tmp.txt">>stopmusic.sh
echo "          state=\$(  cat ./tmp.txt | grep -i  \"state:\"  | tail -1 | tr -d \" \\n\\r\" | tr -s \"-\" | cut -d\"-\" -f 4 | cut -d\":\" -f2  )">>stopmusic.sh

echo "                          ">>stopmusic.sh
echo "   else ">>stopmusic.sh

echo "         if [[ \"\${flagcheck}\" -eq 0 ]] ; then">>stopmusic.sh

echo "              adb -s dsn push /usr/speech/group/stop.wav /data/mixer_meta/">>stopmusic.sh

echo "              ((++flagcheck))">>stopmusic.sh
echo "         fi">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "#issuing stopping  utterance">>stopmusic.sh
echo "        adb -s dsn shell lipc-set-prop -s com.doppler.audiod PassThrough  /data/mixer_meta/stop.wav">>stopmusic.sh
echo "        sleep 20">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "#Checking state after Stop">>stopmusic.sh
echo "        adb -s dsn shell lipc-get-prop com.doppler.whad playbackState | grep -i \"state:\"  >tmp.txt">>stopmusic.sh
echo "        state=\$( cat ./tmp.txt |  tr -d \" \" | cut -d\":\" -f2 )">>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "   fi">>stopmusic.sh


echo "state=\"\${state,,}\"">>stopmusic.sh

echo " #Checking Stopped or not, After issuing Stop utterance" >>stopmusic.sh
echo "                          ">>stopmusic.sh
echo "if [[ \"\${state}\" ==  \"state=3\"  ||  \"\${state}\" ==  \"started\"  ||  \"\${state}\" ==  \"playing\" ]]; then">>stopmusic.sh
echo "   echo \"still playing\"">>stopmusic.sh
echo "        ((++u))">>stopmusic.sh
echo "        if [[ \${u} -lt 2 ]]; then">>stopmusic.sh
echo "           continue">>stopmusic.sh	
echo "        else">>stopmusic.sh
echo "               echo \"cant Stop\"">>stopmusic.sh
echo "                rm ./tmp.txt">>stopmusic.sh
echo "               break">>stopmusic.sh
echo "        fi">>stopmusic.sh			 
echo "else">>stopmusic.sh
echo "      echo  \"stopped\"">>stopmusic.sh
echo "      rm ./tmp.txt">>stopmusic.sh
echo "     break">>stopmusic.sh
echo "fi">>stopmusic.sh

echo "done ">>stopmusic.sh


sed -i  "s/dsn/${targetdsn}/g" stopmusic.sh
sed -i  "s/folder/${folder}/g"  stopmusic.sh








if [[ "${logrunhost}" == "${currenthost}"  ]]; then

sed -i  "s/interrupt/break/g"  stopmusic.sh
echo "cd ..">>stopmusic.sh
source ./stopmusic.sh >delete.txt
echo "Music stopped from inside"

#recording playback ending time
echo "Ending time">>./${folder}/playbacktime.txt
TZ='Asia/Kolkata' date>>./${folder}/playbacktime.txt
printf "\n">>./${folder}/playbacktime.txt
printf "\n">>./${folder}/playbacktime.txt

else

sed -i  "s/break/exit/g"  stopmusic.sh
sed -i  "s/interrupt/break/g"  stopmusic.sh
ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >./delete.txt
sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no ${targethost} 'bash -s'< ./stopmusic.sh >./delete.txt
echo "Music stopped from outside"

#recording playback ending time
echo "Ending time">>./${folder}/playbacktime.txt
TZ='Asia/Kolkata' date>>./${folder}/playbacktime.txt
printf "\n">>./${folder}/playbacktime.txt
printf "\n">>./${folder}/playbacktime.txt


fi


rm  ./checkostype.sh ./stopmusic.sh


}


rebootdevices() {

j=0
dsnlen=${#device_dsn[@]}

while [[ ${j} -lt ${dsnlen} ]]
do

logrunhost=$( echo ${host_address[j]} | cut -d "@" -f 2 | tr -d " \n\r" )

if [[ "${logrunhost}" == "${currenthost}"  ]]; then

adb -s "${device_dsn[j]}" shell reboot >delete.txt

((++j))

else

#rebooting devices in different host

 if [[ -e reboot.sh ]] ; then
rm reboot.sh
fi

touch reboot.sh
chmod 777 reboot.sh


echo "adb -s ${device_dsn[j]} shell reboot ;exit">reboot.sh
echo "exit">>reboot.sh
ssh-keygen -f "/root/.ssh/known_hosts" -R  "${logrunhost}" >delete.txt
sshpass -p labone2six ssh -tt -o StrictHostKeyChecking=no   "${host_address[j]}" 'bash -s'<./reboot.sh >delete.txt

rm "reboot.sh"
((++j))

fi


done


echo "Rebooting all devices. After 5 Minutes, Logs will start run and then playback will be initiated from Target device ${targetdsn}"

sleep 5m


}



clusterinfo="Clusterinfo"
deviceinfo="Deviceinfo"
groupinfo="Groupinfo"
domainsinfo="Domains"
target="Target"
adminfo="ADM"
IFS="}"

for word in $line
do

 if  [[ "$word" == *"$clusterinfo"* ]] ; then
   
   tmp=$(  echo $word | cut -d":" -f 2 )
   clustertype+=( $tmp )
   echo ${clustertype}
  fi

if  [[ "$word" == *"$groupinfo"* ]]; then
   
   tmp=$( echo $word | cut -d":" -f 2 | tr -d " \n\r" )
    group+=( $tmp )
   echo ${group} 

fi

if  [[ "$word" == *"$adminfo"* ]] ; then
   
   word1=$(  echo $word  | cut -d ":" -f 2- | tr -d "[]" )
	admhost=$( echo $word1 | tr -d " \n\r" | cut -d ":" -f 1 )
	admdsn=$( echo $word1 | tr -d " \n\r" | cut -d ":" -f 2 )
fi

 
if [[ "$word" == *"$deviceinfo"* ]] ; then
   
   word1=$(  echo $word  | cut -d":" -f 2-  ) 
   IFS="["
   for host_dsn in $word1 
   do
       tmp=$(  echo $host_dsn | cut -d ":" -f 1 )
       host_address+=( $tmp )
       tmp=$( echo  $host_dsn | cut -d ":" -f 2 | tr -d "]"   )
       device_dsn+=( $tmp )
	  
	   
   done
    
fi

if  [[ "$word" ==  *"$domainsinfo"* ]]; then
  
    word1=$(  echo $word  | cut -d":" -f 2- )
    
    IFS="["
    
   for dom in  $word1
   do 
      tmp=$( echo ${dom,,}  | tr -d "]" )
      domains+=( $tmp )  
   done 
  
fi
  
if [[ "${word}" == *"$target"* ]]; then

    word1=$(  echo $word  | cut -d ":" -f 2- | tr -d "[]" )
	targethost=$( echo $word1 | tr -d " \n\r" | cut -d ":" -f 1 )
	targetdsn=$( echo $word1 | tr -d " \n\r" | cut -d ":" -f 2 )
		


fi
  
  
  IFS="}"

done

echo ${clustertype}
echo ${group}
echo "Target device(injecting utterance): ${targethost},${targetdsn}"
echo "ADM: ${admhost}, ${admdsn}"
echo "Started initiating Longevity"

i=0

domlen=${#domains[@]}
dsnlen=${#device_dsn[@]}
date_1=$( TZ='Asia/Kolkata' date +'%d%b_%H_%M_%S' )
folder="Longevity_${date_1}"
mkdir ${folder}
chmod 777 ${folder}
echo "domain length: ${domlen}"
echo "dsn length: ${dsnlen}"

touch ./${folder}/playbacktime.txt
touch ./${folder}/checkstates.txt
chmod 666 ./${folder}/playbacktime.txt  ./${folder}/checkstates.txt

while [[ $i -lt ${domlen} ]]
do

dt=$( TZ='Asia/Kolkata' date +'%d%b_%H_%M_%S' )
domain_name=$( echo ${domains[i],,} | tr -d " \r\n" )
log_name="${domain_name}_${dt}" 
mkdir ./${folder}/${log_name}


# Reboot all devices and wait for 5 minutes before running logs and initiating music
rebootdevices


echo "starting ${domain_name}"

#Running logs for each device DSN
k=0
while [[ ${k} -lt ${dsnlen} ]]
do

echo "Host and DSN ${host_address[k]}:${device_dsn[k]}"
  logrun
  
  
 ((++k))

done

echo "Logs started running for all devices"


#getting WHAD Dump info from ADM and store it inside Longevity_* folder

if [[  ${whaddump} -eq 0 ]]; then

whaddump=1
whaddumpfunc

fi

#Grepping gapless/offset loglines in adm host
if [[  "${domain_name}" == "gapless"  || "${domain_name}" == "offset"  || "${domain_name}" == "drm" || "${domain_name}" == "tidal"   ]] ; then


gaplessoffsetdrmloglines

fi



sleep 30s

#initiating playback in target host &DSN
startmusic



startcount=0

#determining no of hours to be played for each domain

if [[ "${domain_name}" == "primemusic"  ||  "${domain_name}" == "siriusxm" ||  "${domain_name}" == "beatsone"  ]] ; then

#4hours
endcount=16
elif [[ "${domain_name}" == "katana" ]] ; then
#6 hours
endcount=24
else
#8 hours
endcount=32
fi



#checking playing state of target host&DSN for every 15 minutes (15min*32times=8hours , 15min*16times=4 hours and 15min*24times=4 hours), during 8 hour span
#if playback stopped inbetween,it goes for next domain instead of waiting for 8 hour completion

killedgaplessoffsetdrm=0
stopped=0
echo "started checking ${domains[i]}">>./${folder}/checkstates.txt

while [[ ${startcount} -lt ${endcount} ]]
do

  (( ++startcount ))
  sleep 15m
      # After First 30 minutes killing and getting gapless/offset loglines
     
	 
		if [[  "${domain_name}" == "gapless"  || "${domain_name}" == "offset" || "${domain_name}" == "drm" || "${domain_name}" == "tidal"  ]] && [[ ${startcount} -eq 2 ]] ; then
           
			if [[  ${killedgaplessoffsetdrm} -eq 0 ]]; then
		 
				killgaplessoffsetdrm
				killedgaplessoffsetdrm=1
			fi
		fi
  
   num=0
   TZ='Asia/Kolkata' date>>./${folder}/checkstates.txt
    number=$(( ${startcount} * 15 ))
    echo "Checkplaying ${domains[i]} after ${number} minutes (15minutes*${startcount} times):">>./${folder}/checkstates.txt
  while [[ ${num} -lt ${dsnlen} ]]
  do

     checkplaying    
	 
	 if [[ -e  ./${folder}/playbackstate.txt ]] ; then
       
	   playback_state=$( cat ./${folder}/playbackstate.txt | tr -d " \n\r" )
	   log_state=$( cat ./${folder}/logtrace.txt | tr -d "\n\r" )
	   echo "${host_address[num]}:${device_dsn[num]} -- ${playback_state} ">>./${folder}/checkstates.txt
	   echo "${host_address[num]}:${device_dsn[num]} -- ${log_state} ">>./${folder}/checkstates.txt
	  
	 else
        echo "${host_address[num]}:${device_dsn[num]} -- Cant reach this device">>./${folder}/checkstates.txt
		echo "${host_address[num]}:${device_dsn[num]} -- ${log_state} ">>./${folder}/checkstates.txt
		rm ./${folder}/logtrace.txt  
		((++num))
		continue
     fi
     
	 if [[ ${playback_state} == "playbackstopped" ]]; then
	    stopped=1
	 fi
	 
	 ((++num))
	  rm ./${folder}/playbackstate.txt  ./${folder}/logtrace.txt  
   done 
	printf "\n">>./${folder}/checkstates.txt
	if [[ ${stopped} -eq 1 ]]; then
	   break
	fi
      
done 




#stop the playback
stopmusic

echo "${domain_name} playback stopped"
sleep 1m
sleep 20s

#kills all the device DSN processes
m=0
while [[ ${m} -lt ${dsnlen} ]]
do
  logkill
 ((++m))

done


echo " All logs are killed and moved inside the ${folder}/${log_name} "

#validates using script and stores all the logs , script result inside local folder

python /usr/script/ParseLongevityLogsV15.py ./${folder}/${log_name}/  >./${folder}/script_analysis_${log_name}.txt
mv ./${folder}/script_analysis_${log_name}.txt  ./${folder}/${log_name}/


echo " Script validation done for the domain ${folder}/${log_name}"
 
#Zipping files

zip -j ${log_name}.zip ./${folder}/${log_name}/*
zip -d ${log_name}.zip script_analysis_${log_name}.txt
mv ./${log_name}.zip ./${folder}/${log_name}/

echo "${domain_name} logs are zipped as ${log_name}.zip"
 



#clear all the logs processes data
k=0
while [[ ${k} -lt ${dsnlen} ]]
do

unset -v 'kill_array[k]'
((++k))

done


#Moving Drm, Tidal and Offset Loglines files inside their domain folder

if [[  "${domain_name}" == "gapless"  ]] ; then

chmod 666  ./${folder}/Error_loglines_${admdsn}.txt  ./${folder}/Gapless_loglines_${admdsn}.txt  ./${folder}/Katana_loglines_${admdsn}.txt
mv  ./${folder}/Error_loglines_${admdsn}.txt   ./${folder}/${log_name}/
mv  ./${folder}/Gapless_loglines_${admdsn}.txt  ./${folder}/${log_name}/
mv  ./${folder}/Katana_loglines_${admdsn}.txt  ./${folder}/${log_name}/


elif [[ "${domain_name}" == "offset" ]] ; then

chmod 666 ./${folder}/Offset_loglines_${admdsn}.txt
mv ./${folder}/Offset_loglines_${admdsn}.txt   ./${folder}/${log_name}/

elif [[ "${domain_name}" == "drm" ]] ; then

chmod 666  ./${folder}/Drm_loglines_${admdsn}.txt
mv ./${folder}/Drm_loglines_${admdsn}.txt  ./${folder}/${log_name}/

elif [[ "${domain_name}" == "tidal"  ]] ; then

chmod 666  ./${folder}/Tidal_loglines_${admdsn}.txt
mv  ./${folder}/Tidal_loglines_${admdsn}.txt  ./${folder}/${log_name}/

fi


if [[  "${domain_name}" == "gapless" || "${domain_name}" == "offset"  ||  "${domain_name}" == "drm" || "${domain_name}" == "tidal" ]] ; then

deleteloglineshost=$( echo ${admhost} | cut -d "@" -f 2 )

if [[ "${deleteloglineshost}" !=  "${currenthost}"  ]]; then

deletedrmtidalgaplessoffset

fi

fi

# deleting log files outside of the current host
logdelete

echo "${domain_name} done"


#goes for next domain





((++i))


domainpermission=0

done
rm ./delete.txt