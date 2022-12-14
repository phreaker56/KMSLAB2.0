#!/bin/bash
fun_bar (){
	comando[0]="$1"
	comando[1]="$2"
( [[ -e $HOME/fim ]] && rm $HOME/fim
	${comando[0]} > /dev/null 2>&1
	${comando[1]} > /dev/null 2>&1
	touch $HOME/fim ) > /dev/null 2>&1 &  tput civis
 echo -ne "\033[1;33mWAIT \033[1;37m- \033[1;33m["
 while true; do
 	for((i=0; i<18; i++)); do
 		echo -ne "\033[1;31m."    
 		sleep 0.1s
 	done
 	[[ -e $HOME/fim ]] && rm $HOME/fim && break
 	echo -e "\033[1;33m]"    
 	sleep 1s    
 	tput cuu1 
	tput dl1
 	echo -ne "\033[1;33mWAIT \033[1;37m- \033[1;33m["
 done
 echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m" 
 tput cnorm 
}

clear 
export
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
MYIP="$(wget -qO- ipv4.icanhazip.com); MYIP2="s/xxxxxxxxx/$MYIP/g";
echo ""
echo -e "\033[1;32mWELCOME TO THE OPEN_VPN INSTALLER"
echo""
echo -ne "\033[01;37mENTER TO CONTINUE..."; read ENTER
echo""
echo -e "\033[1;32mINSTALLING OPEN_VPN..."
echo""

int_open() { 
apt-get install openvpn -y }
fun_bar "int_open"
echo"" echo -e "\033[1;32mEXTRACTING FILES..."
echo""

ex_arqui() {
	wget -O /etc/openvpn/openvpn.tar "https://github.com/phreaker56/OPENVPN/raw/master/openvpn-debian.tar" 
	cd /etc/openvpn/ tar xf openvpn.tar
	wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/phreaker56/OPENVPN/master/1194.conf"
	service openvpn restart }
}

fun_bar "ex_arqui" 
echo""
echo -e "\033[1;32mCONFIGURING OPEN_VPN..."
echo""

conf_open() {
	sysctl -w net.ipv4.ip_forward=1
	sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
	iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
	iptables-save > /etc/iptables_yg_baru_dibikin.conf
	wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/phreaker56/OPENVPN/master/iptables"
	chmod +x /etc/network/if-up.d/iptables
	service openvpn@1194 restart
	service openvpn@1194 start 
}

fun_bar "conf_open"
echo""
# openvpn configuration
echo -e "\033[1;32mGENERATING OVPN FILE..."
echo""

conf_ovpn() {
	cd /etc/openvpn/ 
	wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/phreaker56/OPENVPN/master/client-1194.conf"
	sed -i $MYIP2 /etc/openvpn/client.ovpn;
	cp client.ovpn /root/ 
	rm -rf $HOME/openmod && cat
	/dev/null > ~/.bash_history && history -c 
}

fun_bar "conf_ovpn"
echo""
echo -e "\033[1;32mOPEN_VPN CONFIGURED SUCCESSFULLY."
echo""
./openmod
