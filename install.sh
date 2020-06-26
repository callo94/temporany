#!/bin/bash
echo "Ciao NERD, forza, ora installiamo ngrok e settiamo un reverse tunneling al boot."
echo "Alla fine di questo processo il Raspy si riavvierà. E' questo il momento per fermare tutto se hai finestre aperte".
read -p "Vuoi continuare? (Y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then 
echo "Ok allora fermo tutto"
[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
echo "Ricordati di lanciare install.sh con sudo bash install.sh, inoltre di settargli chmod+x prima di farlo."
echo "Prima di tutto devi collegare il tuo account con ./ngrok authtoken <YOUR_AUTH_TOKEN>"
read -p "L'hai già fatto? (Y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
echo "Allora fallo e riprova!"
[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
thefile="ngrok-stable-linux-arm.zip"
wget https://bin.equinox.io/c/4VmDzA7iaHb/$thefile

if [ ! -s ./$thefile ] ; then
	echo "Problemone... non ho scaricato il file! controlla la connessione oppure il percorso presente in install.sh"
	exit 0
fi
unzip $thefile
echo "File unzippato!"
echo "Che porta usiamo? ad es 22901"
read porta
echo "#!/bin/sh" >> startngrok.sh
echo /home/pi/ngrok tcp -config=/home/pi/.ngrok2/ngrok.yml --region=eu --remote-addr 1.tcp.eu.ngrok.io:$porta 22 >> startngrok.sh
chmod +x startngrok.sh
echo "ok, ora settiamo l'rc.local"
autost="/home/pi/startngrok.sh > /home/pi/ngroklog &"
sed -i '$i\'"$autost" "/etc/rc.local"
echo "OK FATTO!!!"
echo "Ora riavvio... a fra un po'"
reboot
exit 0
