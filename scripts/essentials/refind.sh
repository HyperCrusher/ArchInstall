#Setup refind
#Does not delete example stanzas

#Setup refind.conf options
ENABLE_OPTS=("enable_mouse" "use_graphics_for" "resolution max")
REPLACE_OPTS=("timeout" "timeout 10" "showtools" "showtools")

#Refind Files
REFIND_CONF="/boot/EFI/BOOT/refind.conf"
REFIND_LINUX="/boot/refind_linux.conf"

#Remove archiso entries
sed -i /archiso/d $REFIND_LINUX   

REFIND_CONFIG=$(cat $REFIND_CONF)

#function to update refind_config with single param commands
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

#Remove comments
update sed '/^#/d'

#Condense Blank Lines down to one blank line
update awk '!NF{if(++n<=1)print;next};{n=0;print}' 

#Replace the config with our edits
rm $REFIND_FILE
touch $REFIND_FILE
echo "$REFIND_CONFIG" >> $REFIND_FILE

#Cleanup by trimming files
sed -i -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' $REFIND_CONF
sed -i -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' $REFIND_LINUX
