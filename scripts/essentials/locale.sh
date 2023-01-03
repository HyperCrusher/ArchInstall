# Set Locale and prompt for japanese
sed -i "/$LOCALE UTF-8/s/^#//g" /etc/locale.gen

if confirm "Install Japanese Locale?"
then
  sed -i '/ja_JP.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
fi

locale-gen
echo "LANG=$LOCALE" >> /etc/locale.conf
