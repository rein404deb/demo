systemctl enable --now sshd
echo ‘ zone “au-team.irpo” {
	type master;
	file “au-team.irpo”;
	};
zone “162.192.in-addr.arpa” {
	type master;
	file “162.192.in-addr.arpa”;
	};’ >> /etc/bind/local.conf
cp /etc/bind/zone/localdomain /etc/bind/zone/au-team.irpo
cp /etc/bind/zone/127.in-addr.irpo /etc/bind/zone/168.192.in-addr.arpa
chown named /etc/bind/zone/au-team.irpo
chown named /etc/bind/zone/168.192.in-addr.arpa
chmod 600 /etc/bind/zone/au-team.irpo
chmod 600 /etc/bind/zone/168.192.in-addr.arpa
sed -i ‘s//listen-on port 53 {127.0.0.1; 192.168.0.1;};/’  /etc/bind/options.conf 
sed -i ‘s//listen-on-v6 { none; };/’  /etc/bind/options.conf 
echo ‘Forward only;’ >> /etc/bind/options.conf 
echo ‘forwarders { 77.88.8.7; };’ >> /etc/bind/options.conf 
echo ‘allow-query { any; };’ >> /etc/bind/options.conf 
echo ‘dnssec-validation yes;’ >> /etc/bind/options.conf 
rndc-confgen /etc/bind/rndc.key
sed -i ‘6,$d’ >> /etc/bind/rndc.key
sed -i ‘s/localhost. root.localhost./au-team.irpo. root.au-team.irpo./’  /etc/bind/zone/au-team.irpo
sed -i ‘s/localhost./au-team.irpo./’  /etc/bind/zone/au-team.irpo
sed -i ‘s/127.0.0.0/192.168.0.0/’  /etc/bind/zone/au-team.irpo
sed -i ‘s/localhost	IN	CNAME	localhost./hq-srv	IN	A	192.168.0.1’  /etc/bind/zone/au-team.irpo
echo ‘hq-rtr		IN	A	192.168.0.62
hq-cli		IN	A	192.168.0.65
br-rtr		IN	A	192.168.1.30
br-srv		IN	A	192.168.1.1
web.au-team.irpi		IN	A	172.16.2.14
docker.au-team.irpo		IN	A	172.16.1.14’ >> /etc/bind/zone/au-team.irpo
sed -i ‘s/localhost. root.localhost./au-team.irpo. root.au-team.irpo./’ /etc/bind/zone/168.192.in-addr.arpa
sed -i ‘s/localhost./au-team.irpo./’   /etc/bind/zone/168.192.in-addr.arpa
sed -i ‘s/0.0.0	IN	PTR	localdomain./0.0	IN	PTR	au-team.irpo/’ /etc/bind/zone/168.192.in-addr.arpa
sed -i ‘s/1.0.0	IN	PTR	localhost./1.0	IN	PTR	hq-srv.au-team.irpo/’  /etc/bind/zone/168.192.in-addr.arpa
echo ‘62.0	IN	PTR	hq-rtr.au-team.irpo
65.0	IN	PTR	hq-cli.au-team.irpo’ >> /etc/bind/zone/168.192.in-addr.arpa
systemctl enable --now bind 
