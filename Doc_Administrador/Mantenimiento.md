# Manteniment de la infraestructura

## 1. Objectiu

Aquest document descriu les tasques de manteniment recomanades per conservar operativa la infraestructura del projecte **P.0-ASIXc2A-G03**.

L'objectiu és facilitar la revisió periòdica dels serveis i detectar problemes abans que afectin el funcionament general.

Les tasques de manteniment inclouen:

- revisió de serveis
- revisió de xarxa
- comprovació de routing
- comprovació de DHCP
- comprovació de DNS
- comprovació de NAT
- revisió del firewall
- comprovació de NGINX
- comprovació de PHP
- comprovació de MySQL
- comprovació de FTP
- revisió de logs
- revisió d'espai en disc
- còpies de seguretat
- validació dels clients

---

# 2. Manteniment per màquina

La infraestructura es pot revisar dividint les tasques per equip.

```text id="lq6ru8"
R-NCC
W-NCC
B-NCC
F-NCC
Windows
Linux
```

Cada màquina té funcions diferents i requereix comprovacions específiques.

---

# 3. R-NCC

R-NCC és una de les màquines més importants perquè concentra gran part dels serveis de xarxa.

Cal revisar:

- interfícies
- rutes
- IPv4 forwarding
- DHCP
- DNS
- UFW
- NAT
- connectivitat exterior

---

# 4. Revisió de les interfícies de R-NCC

Comanda:

```bash id="8w34hf"
ip a
```

S'ha de comprovar que continuïn existint:

```text id="1bcwbc"
192.168.10.1
192.168.20.1
```

Si una interfície desapareix o canvia de nom, poden fallar:

- routing
- DHCP
- NAT
- forwarding
- DNS

---

# 5. Revisió del routing

Comanda:

```bash id="aqn4uo"
ip route
```

S'han de comprovar:

- ruta per defecte
- ruta de la DMZ
- ruta de la Intranet

Les xarxes principals han de continuar sent:

```text id="tiurgv"
192.168.10.0/24
192.168.20.0/24
```

---

# 6. Revisió de IPv4 forwarding

Comanda:

```bash id="v8zp72"
sysctl net.ipv4.ip_forward
```

Resultat esperat:

```text id="r7s2xc"
net.ipv4.ip_forward = 1
```

Si el valor és `0`, R-NCC deixarà de funcionar correctament com a router.

---

# 7. Revisió del DHCP

Comprovar el servei:

```bash id="1j0jm8"
sudo systemctl status isc-dhcp-server
```

El servei ha d'aparèixer com:

```text id="qchuhl"
active (running)
```

També es poden revisar els logs:

```bash id="98w0yy"
sudo journalctl -u isc-dhcp-server
```

S'han de buscar processos com:

```text id="v2k17z"
DHCPREQUEST
DHCPACK
```

---

# 8. Revisió del DNS

Comprovar BIND9:

```bash id="ws8p6a"
sudo systemctl status bind9
```

Des d'un client es pot validar amb:

```bash id="ghqxab"
nslookup w-ncc.asix3jyt.local
```

i:

```bash id="5w80p3"
nslookup f-ncc.asix3jyt.local
```

---

# 9. Revisió del firewall de R-NCC

Comanda:

```bash id="465b35"
sudo ufw status
```

S'ha de comprovar que:

```text id="hvq4ga"
Status: active
```

També s'ha de verificar que continuïn existint les regles necessàries per:

- DNS
- DHCP
- HTTP
- FTP
- forwarding

---

# 10. Revisió del NAT

Comanda:

```bash id="kna3ei"
sudo iptables -t nat -L POSTROUTING -n -v
```

S'han de veure les regles MASQUERADE per:

```text id="sjuupz"
192.168.20.0/24
192.168.10.0/24
```

Si desapareixen després d'un reinici, s'ha de revisar:

```text id="un87tk"
/etc/ufw/before.rules
```

---

# 11. W-NCC

W-NCC proporciona la capa web.

Cal revisar:

- interfícies
- NGINX
- PHP-FPM
- fitxers de l'aplicació
- connexió MySQL
- espai en disc
- logs

---

# 12. Revisió de NGINX

Comanda:

```bash id="qo3n3s"
sudo systemctl status nginx
```

Validació de configuració:

```bash id="jv4wtq"
sudo nginx -t
```

La configuració ha de ser vàlida abans de reiniciar el servei.

---

# 13. Reinici de NGINX

Si és necessari:

```bash id="hm5tps"
sudo systemctl restart nginx
```

Després:

```bash id="sg0ehw"
sudo systemctl status nginx
```

---

# 14. Revisió de PHP-FPM

Comanda:

```bash id="ivh0y8"
sudo systemctl status php8.1-fpm
```

Si està aturat:

```bash id="vuq5gm"
sudo systemctl restart php8.1-fpm
```

---

# 15. Revisió de la web

Des del mateix servidor:

```bash id="5pw74l"
curl http://localhost
```

Des d'un client:

```bash id="soj0be"
curl http://192.168.10.10
```

També es pot comprovar des d'un navegador.

---

# 16. Revisió de la connexió amb B-NCC

Des de W-NCC:

```bash id="p1vlmh"
mysql -h 192.168.30.10 -u bchecker -p
```

Després:

```sql id="c1770d"
USE equipaments;
SELECT COUNT(*) FROM equipaments;
```

El resultat actual esperat és:

```text id="7n64tn"
889
```

---

# 17. Revisió dels fitxers web

Cal comprovar que continuïn existint els fitxers principals.

```text id="w0afqe"
/var/www/html/login.php
/var/www/html/logout.php
/var/www/html/includes/auth.php
/var/www/html/equipaments/index.php
/var/www/html/equipaments/create.php
/var/www/html/equipaments/edit.php
/var/www/html/equipaments/delete.php
```

També:

```text id="1k0z1p"
/var/www/config/database.php
/var/www/config/database_admin.php
```

---

# 18. Logs de NGINX

Els logs són útils per detectar errors.

Normalment es poden consultar a:

```text id="h12wy7"
/var/log/nginx/access.log
/var/log/nginx/error.log
```

Exemple:

```bash id="ayqr8m"
sudo tail -n 50 /var/log/nginx/error.log
```

---

# 19. B-NCC

B-NCC necessita manteniment especialment a:

- MySQL
- xarxa backend
- UFW
- usuaris
- permisos
- espai en disc
- còpies de seguretat

---

# 20. Revisió de MySQL

Comanda:

```bash id="rvlbm3"
sudo systemctl status mysql
```

Si està aturat:

```bash id="k3t6o0"
sudo systemctl restart mysql
```

---

# 21. Revisió del port MySQL

Comanda:

```bash id="ykmxfe"
sudo ss -lntp | grep 3306
```

S'ha de comprovar que MySQL escolti a:

```text id="2v1m0z"
192.168.30.10:3306
```

---

# 22. Revisió de bind-address

Comanda:

```bash id="gsbw2x"
grep bind-address /etc/mysql/mysql.conf.d/mysqld.cnf
```

Resultat esperat:

```text id="1wocnu"
bind-address = 192.168.30.10
```

---

# 23. Revisió del firewall de B-NCC

Comanda:

```bash id="x9x3hh"
sudo ufw status
```

Les regles principals han de continuar limitades a:

```text id="csw094"
192.168.30.1
```

Serveis:

```text id="kzu8to"
22/TCP
3306/TCP
```

---

# 24. Revisió dels usuaris MySQL

Comanda:

```sql id="yqq69a"
SELECT user, host FROM mysql.user;
```

S'ha de comprovar que els comptes utilitzats per l'aplicació continuïn limitats a:

```text id="6u1bch"
192.168.30.1
```

---

# 25. Revisió dels permisos

Es poden comprovar amb:

```sql id="3ibqb2"
SHOW GRANTS FOR 'bchecker'@'192.168.30.1';
```

i:

```sql id="t1pgmx"
SHOW GRANTS FOR 'web_admin'@'192.168.30.1';
```

`bchecker` ha de mantenir permisos de lectura.

`web_admin` ha de mantenir els permisos CRUD necessaris.

---

# 26. F-NCC

F-NCC necessita revisió de:

- interfície
- routing
- ruta cap a la Intranet
- servei FTP
- port 21
- espai en disc

---

# 27. Revisió de la ruta de F-NCC

Comanda:

```bash id="b6c7v9"
ip route
```

S'ha de comprovar una ruta cap a:

```text id="u4ajye"
192.168.20.0/24
```

mitjançant:

```text id="w43gxz"
192.168.10.1
```

---

# 28. Revisió del port FTP

Comanda:

```bash id="csk4w8"
sudo ss -lntp | grep :21
```

El port 21 ha d'estar escoltant.

---

# 29. Prova real del FTP

Des d'un client:

```text id="ujyba9"
ftp 192.168.10.20
```

Proves recomanades:

```text id="kjhuem"
ls
get prueba_ftp.txt
put subida_windows.txt
```

Una prova completa ha d'incloure pujada i descàrrega.

---

# 30. Client Windows

El client Windows s'ha de revisar per comprovar:

- IP
- gateway
- DNS
- rutes
- accés web
- FTP
- Internet

---

# 31. Revisió de Windows

Comanda:

```powershell id="sqfyyf"
ipconfig /all
```

Valors esperats durant la configuració actual:

```text id="1vs4kw"
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

---

# 32. Revisió de rutes a Windows

Comanda:

```powershell id="k0it8f"
route print -4
```

La ruta principal del projecte ha d'utilitzar:

```text id="lhzu7d"
192.168.20.1
```

---

# 33. Proves des de Windows

DNS:

```powershell id="6cz46q"
nslookup w-ncc.asix3jyt.local
```

Web:

```powershell id="pt5hrb"
Test-NetConnection 192.168.10.10 -Port 80
```

FTP:

```powershell id="gzsuec"
Test-NetConnection 192.168.10.20 -Port 21
```

Internet:

```powershell id="sh8vms"
ping 8.8.8.8
```

---

# 34. Client Linux

Cal comprovar:

```bash id="883b46"
ip a
ip route
```

Gateway:

```bash id="5nre4j"
ping 192.168.20.1
```

DNS:

```bash id="81vwgj"
nslookup w-ncc.asix3jyt.local
```

Web:

```bash id="26fhde"
curl http://w-ncc.asix3jyt.local
```

---

# 35. Revisió d'espai en disc

En tots els servidors Linux és recomanable executar:

```bash id="b7s2oz"
df -h
```

Aquesta comanda permet detectar particions gairebé plenes.

Un disc ple pot provocar problemes en:

- logs
- MySQL
- aplicació
- actualitzacions
- serveis

---

# 36. Revisió de memòria

Comanda:

```bash id="x9a60f"
free -h
```

Permet comprovar l'ús de RAM.

---

# 37. Revisió de processos

Comanda:

```bash id="y96y9r"
top
```

o:

```bash id="rdtmg1"
htop
```

si està instal·lat.

Això permet detectar processos amb un consum elevat.

---

# 38. Revisió de serveis fallits

Comanda:

```bash id="d2fhxx"
systemctl --failed
```

Aquest comandament mostra serveis que han fallat.

És útil com a comprovació ràpida després d'un reinici.

---

# 39. Revisió de logs

Els logs s'han de consultar quan existeix una incidència.

Exemples:

### DHCP

```bash id="hnns14"
sudo journalctl -u isc-dhcp-server
```

### DNS

```bash id="9q4nw4"
sudo journalctl -u bind9
```

### NGINX

```bash id="xu2yhv"
sudo journalctl -u nginx
```

### MySQL

```bash id="mr0rww"
sudo journalctl -u mysql
```

---

# 40. Actualitzacions del sistema

És recomanable revisar periòdicament les actualitzacions disponibles.

```bash id="ho7ggm"
sudo apt update
```

Per veure paquets actualitzables:

```bash id="7o4yak"
apt list --upgradable
```

Les actualitzacions s'han d'aplicar de manera controlada per evitar afectar serveis crítics.

---

# 41. Còpies de seguretat

La base de dades és un dels elements més importants a protegir.

Una còpia es pot crear amb:

```bash id="h7t8vm"
mysqldump -u root -p equipaments > equipaments_backup.sql
```

Aquest fitxer ha d'emmagatzemar-se en una ubicació segura.

---

# 42. Restauració de la base de dades

Una còpia SQL es pot restaurar mitjançant:

```bash id="ijcn2k"
mysql -u root -p equipaments < equipaments_backup.sql
```

Abans de restaurar una base de dades real és recomanable validar la còpia.

---

# 43. Còpia de configuracions

També és recomanable guardar còpies dels fitxers importants.

### R-NCC

```text id="mkjz7y"
/etc/ufw/
/etc/bind/
/etc/dhcp/
```

### W-NCC

```text id="u1jdcn"
/etc/nginx/
/var/www/html/
/var/www/config/
```

### B-NCC

```text id="x4i8mp"
/etc/mysql/
/etc/netplan/
```

Les configuracions principals també es poden conservar al repositori Git quan no continguin credencials sensibles.

---

# 44. Credencials i GitHub

No s'han de publicar al repositori:

- contrasenyes reals
- claus privades
- tokens
- secrets
- credencials administratives

Els fitxers de configuració publicats han d'evitar exposar informació sensible.

---

# 45. Freqüència recomanada

| Tasca | Freqüència recomanada |
|---|---|
| Revisar serveis | Cada setmana |
| Revisar logs | Cada setmana o quan existeixi un error |
| Revisar espai en disc | Cada setmana |
| Revisar firewall | Després de qualsevol canvi |
| Provar DNS | Després de canvis de xarxa |
| Provar DHCP | Després de canvis al servei |
| Provar NAT | Després de canvis al router |
| Revisar MySQL | Cada setmana |
| Còpia de MySQL | Periòdicament i abans de canvis importants |
| Revisar actualitzacions | Cada setmana |
| Prova completa | Després de canvis importants |

---

# 46. Prova ràpida de manteniment

Una revisió ràpida pot seguir aquest ordre:

```text id="8l3vme"
1. Comprovar R-NCC
2. Comprovar routing
3. Comprovar DHCP
4. Comprovar DNS
5. Comprovar NAT
6. Comprovar W-NCC
7. Comprovar B-NCC
8. Comprovar F-NCC
9. Comprovar Windows
10. Comprovar Linux
```

---

# 47. Checklist de manteniment

## R-NCC

- [ ] interfícies correctes
- [ ] routing correcte
- [ ] forwarding actiu
- [ ] DHCP actiu
- [ ] DNS actiu
- [ ] UFW actiu
- [ ] NAT actiu

## W-NCC

- [ ] NGINX actiu
- [ ] configuració NGINX correcta
- [ ] PHP-FPM actiu
- [ ] connexió MySQL correcta
- [ ] web accessible

## B-NCC

- [ ] MySQL actiu
- [ ] port 3306 correcte
- [ ] bind-address correcte
- [ ] UFW actiu
- [ ] usuaris i permisos correctes
- [ ] còpia de seguretat disponible

## F-NCC

- [ ] ruta cap a la Intranet
- [ ] port 21 actiu
- [ ] login FTP
- [ ] descàrrega correcta
- [ ] pujada correcta

## Clients

- [ ] IP correcta
- [ ] gateway correcte
- [ ] DNS correcte
- [ ] web accessible
- [ ] FTP accessible
- [ ] Internet accessible

---

# 48. Evidències pendents

Les evidències reals de manteniment es poden afegir a la fase final.

Les més útils serien:

📸 `systemctl --failed`

📸 `df -h`

📸 serveis principals actius

📸 còpia de seguretat creada

📸 comprovació de MySQL

📸 prova web després d'un reinici

📸 prova DNS després d'un reinici

Aquestes captures poden demostrar que la infraestructura continua funcionant després del desplegament inicial.

---

# 49. Conclusió

El manteniment de la infraestructura requereix revisar tant els serveis com la connectivitat entre màquines.

R-NCC és especialment crític perquè concentra routing, DHCP, DNS, NAT i firewall.

W-NCC necessita NGINX, PHP i connectivitat amb B-NCC.

B-NCC necessita mantenir MySQL protegit i disposar de còpies de seguretat.

F-NCC necessita mantenir el servei FTP i les rutes correctes.

Una revisió periòdica permet detectar errors abans que afectin tota la infraestructura.
