#Refind Setup
#Modifies /boot/EFI/BOOT/refind.conf
#Sets my personal defaults
#Keeps the example stanzas

ENABLE_OPTS=("enable_mouse" "use_graphics_for" "resolution max")
REPLACE_OPTS=("timeout" "timeout 10" "showtools" "showtools")
REFIND_FILE="/boot/EFI/BOOT/refind.conf"
REFIND_CONFIG=$(cat $REFIND_FILE)

update(){
  REFIND_CONFIG=$(echo "$REFIND_CONFIG" | $1 "$2")
}

#Enable commented out options
for i in "${ENABLE_OPTS[@]}"
 do
  update sed "/#$i/s/#//"
done

#Replace default options
for ((i = 0; i<${#REPLACE_OPTS[@]}; i+=2 ))
 do
  update sed "s/^${REPLACE_OPTS[i]}.*/${REPLACE_OPTS[i+1]}/"
done

update sed "root=PARTUUID="
#Remove comments
update sed '/^#/d'

#Condense Blank Lines down to one blank line
update awk '!NF{if(++n<=1)print;next};{n=0;print}' 

#Replace the config with our edits
rm $REFIND_FILE
touch $REFIND_FILE
echo "$REFIND_CONFIG" >> $REFIND_FILE

#Cleanup by trimming file
sed -i -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' $REFIND_FILE
