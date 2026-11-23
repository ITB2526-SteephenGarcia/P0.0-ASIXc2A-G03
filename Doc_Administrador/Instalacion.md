# Instal·lació i desplegament

## 1. Objectiu

Aquest document descriu el procés general de desplegament de la infraestructura del projecte **P.0-ASIXc2A-G03**.

L'objectiu és que un administrador pugui entendre l'ordre d'instal·lació i reproduir els components principals del projecte.

La infraestructura està formada per:

- R-NCC
- W-NCC
- B-NCC
- F-NCC
- client Windows
- client Linux

---

# 2. Ordre recomanat de desplegament

Per evitar problemes de dependències, es recomana seguir aquest ordre:

```text
1. Crear les xarxes
        |
        v
2. Configurar R-NCC
        |
        v
3. Configurar W-NCC
        |
        v
4. Configurar B-NCC
        |
        v
5. Configurar F-NCC
        |
        v
6. Configurar els clients
        |
        v
7. Desplegar l'aplicació web
        |
        v
8. Realitzar proves
        |
        v
9. Aplicar mesures de seguretat
```

---

# 3. Xarxes necessàries

Abans de configurar els serveis, s'han de preparar les xarxes del projecte.

## DMZ

```text
192.168.10.0/24
```

Gateway:

```text
192.168.10.1
```

---

## Intranet

```text
192.168.20.0/24
```

Gateway:

```text
192.168.20.1
```

---

## Backend

```text
192.168.30.0/24
```

Aquesta xarxa connecta exclusivament W-NCC i B-NCC.

---

# 4. Creació de les màquines

S'han de crear les màquines virtuals necessàries a IsardVDI.

| Màquina | Funció |
|---|---|
| R-NCC | Router i serveis de xarxa |
| W-NCC | Servidor web |
| B-NCC | Servidor MySQL |
| F-NCC | Servidor FTP |
| Windows | Client |
| Linux | Client |

Les màquines Linux del projecte utilitzen principalment Ubuntu Server.

---

# 5. Instal·lació de R-NCC

R-NCC s'ha de configurar abans que la resta dels equips que depenen dels seus serveis.

Les seves funcions són:

- routing
- DHCP
- DNS
- NAT
- firewall

---

# 6. Configuració de les interfícies de R-NCC

R-NCC necessita una interfície per a cada xarxa principal.

Configuració del projecte:

```text
Exterior  -> interfície proporcionada per IsardVDI
Intranet  -> 192.168.20.1/24
DMZ       -> 192.168.10.1/24
```

La xarxa backend no es connecta a R-NCC.

---

# 7. Activació del routing

R-NCC necessita IPv4 forwarding.

Comprovació:

```bash
sysctl net.ipv4.ip_forward
```

Resultat necessari:

```text
net.ipv4.ip_forward = 1
```

Si no està habilitat, cal activar-lo de manera persistent mitjançant la configuració del sistema.

---

# 8. Instal·lació de DHCP

Actualitzar els repositoris:

```bash
sudo apt update
```

Instal·lar el servidor:

```bash
sudo apt install isc-dhcp-server
```

El servei ha de proporcionar als clients de la Intranet:

```text
Xarxa:   192.168.20.0/24
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

Després de configurar-lo:

```bash
sudo systemctl restart isc-dhcp-server
```

Comprovació:

```bash
sudo systemctl status isc-dhcp-server
```

---

# 9. Instal·lació de DNS

El servei DNS utilitza BIND9.

Instal·lació:

```bash
sudo apt install bind9 bind9-utils
```

Domini intern:

```text
asix3jyt.local
```

Registres principals:

```text
r-ncc.asix3jyt.local -> 192.168.20.1
w-ncc.asix3jyt.local -> 192.168.10.10
f-ncc.asix3jyt.local -> 192.168.10.20
```

Després de configurar BIND9:

```bash
sudo systemctl restart bind9
```

Comprovació:

```bash
sudo systemctl status bind9
```

---

# 10. Configuració del firewall de R-NCC

Instal·lar UFW si no està disponible:

```bash
sudo apt install ufw
```

Activar-lo:

```bash
sudo ufw enable
```

S'han d'autoritzar els serveis necessaris per al projecte.

Entre ells:

```text
SSH
DNS
DHCP
HTTP cap a W-NCC
FTP cap a F-NCC
```

També s'han de configurar les regles de forwarding necessàries entre Intranet i DMZ.

---

# 11. Configuració del NAT

R-NCC realitza NAT per permetre la sortida a Internet.

Les xarxes internes són:

```text
192.168.20.0/24
192.168.10.0/24
```

Regles:

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.20.0/24 -o enp1s0 -j MASQUERADE
```

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp1s0 -j MASQUERADE
```

Per fer-les persistents s'inclouen a:

```text
/etc/ufw/before.rules
```

Exemple:

```text
*nat
:POSTROUTING ACCEPT [0:0]

-A POSTROUTING -s 192.168.20.0/24 -o enp1s0 -j MASQUERADE
-A POSTROUTING -s 192.168.10.0/24 -o enp1s0 -j MASQUERADE

COMMIT
```

---

# 12. Instal·lació de W-NCC

W-NCC necessita dues interfícies.

```text
DMZ     -> 192.168.10.10/24
Backend -> 192.168.30.1/24
```

La primera permet l'accés dels clients.

La segona permet comunicar-se amb B-NCC.

---

# 13. Instal·lació de NGINX

Actualitzar repositoris:

```bash
sudo apt update
```

Instal·lar NGINX:

```bash
sudo apt install nginx
```

Comprovar:

```bash
sudo systemctl status nginx
```

Validar la configuració:

```bash
sudo nginx -t
```

---

# 14. Instal·lació de PHP

Instal·lar PHP i els components necessaris.

```bash
sudo apt install php8.1 php8.1-fpm php8.1-mysql
```

Comprovar PHP-FPM:

```bash
sudo systemctl status php8.1-fpm
```

NGINX s'ha de configurar perquè enviï els fitxers PHP a PHP-FPM.

---

# 15. Directori de l'aplicació

La web es desplega principalment a:

```text
/var/www/html/
```

Estructura principal:

```text
/var/www/html/
|
|-- login.php
|-- logout.php
|-- dbtest.php
|
|-- includes/
|   |
|   |-- auth.php
|
|-- equipaments/
    |
    |-- index.php
    |-- create.php
    |-- edit.php
    |-- delete.php
```

---

# 16. Configuració de connexió

Les dades de connexió amb MySQL es guarden fora de la carpeta principal.

```text
/var/www/config/
```

Fitxers:

```text
database.php
database_admin.php
```

`database.php` s'utilitza per a consultes de lectura.

`database_admin.php` s'utilitza per a operacions administratives.

---

# 17. Instal·lació de B-NCC

B-NCC es configura a:

```text
192.168.30.10/24
```

La seva connexió principal de projecte és amb W-NCC.

No s'ha de connectar directament a R-NCC.

---

# 18. Configuració de Netplan a B-NCC

La configuració final utilitzada és similar a:

```yaml
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: true

    enp2s0:
      dhcp4: false
      addresses:
        - 192.168.30.10/24
```

Aplicar:

```bash
sudo netplan apply
```

Comprovar:

```bash
ip a
```

---

# 19. Instal·lació de MySQL

Instal·lar MySQL:

```bash
sudo apt update
sudo apt install mysql-server
```

Comprovar:

```bash
sudo systemctl status mysql
```

---

# 20. Configuració de MySQL

Fitxer principal:

```text
/etc/mysql/mysql.conf.d/mysqld.cnf
```

Configurar:

```text
bind-address = 192.168.30.10
```

Reiniciar MySQL:

```bash
sudo systemctl restart mysql
```

Comprovar el port:

```bash
sudo ss -lntp | grep 3306
```

---

# 21. Creació de la base de dades

Base de dades:

```sql
CREATE DATABASE equipaments;
```

Seleccionar-la:

```sql
USE equipaments;
```

Posteriorment s'ha de crear l'estructura necessària i importar les dades.

---

# 22. Preparació del CSV

Les dades procedeixen de Barcelona Open Data.

El fitxer original estava en:

```text
UTF-16
```

Abans de la importació es va convertir a:

```text
UTF-8
```

Això evita problemes de codificació durant la càrrega.

---

# 23. Validació de la importació

Després d'importar les dades:

```sql
SELECT COUNT(*) FROM equipaments;
```

Resultat esperat:

```text
889
```

---

# 24. Creació dels usuaris MySQL

## Usuari de lectura

```text
bchecker
```

Origen:

```text
192.168.30.1
```

Permís:

```text
SELECT
```

---

## Usuari administratiu

```text
web_admin
```

Origen:

```text
192.168.30.1
```

Permisos:

```text
SELECT
INSERT
UPDATE
DELETE
```

---

# 25. Firewall de B-NCC

Activar UFW:

```bash
sudo ufw enable
```

Permetre MySQL només des de W-NCC:

```bash
sudo ufw allow from 192.168.30.1 to any port 3306 proto tcp
```

Permetre SSH només des de W-NCC:

```bash
sudo ufw allow from 192.168.30.1 to any port 22 proto tcp
```

Comprovar:

```bash
sudo ufw status
```

La configuració final no ha de mantenir regles SSH obertes a qualsevol origen.

---

# 26. Instal·lació de F-NCC

F-NCC s'ha de configurar dins de la DMZ.

Direcció:

```text
192.168.10.20/24
```

Gateway:

```text
192.168.10.1
```

La seva funció és proporcionar FTP.

---

# 27. Ruta cap a la Intranet

F-NCC necessita saber com arribar a:

```text
192.168.20.0/24
```

Ruta:

```bash
sudo ip route add 192.168.20.0/24 via 192.168.10.1 dev enp3s0
```

Per fer-la persistent:

```bash
sudo nmcli connection modify "Conexión cableada 3" +ipv4.routes "192.168.20.0/24 192.168.10.1"
```

Aplicar:

```bash
sudo nmcli device reapply enp3s0
```

---

# 28. Comprovació de FTP

El port principal és:

```text
21/TCP
```

Des del client Windows:

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

Després:

```powershell
ftp 192.168.10.20
```

Proves:

```text
ls
get prueba_ftp.txt
put subida_windows.txt
```

---

# 29. Configuració del client Windows

El client Windows es connecta a la Intranet.

La configuració es rep mitjançant DHCP.

Durant les proves:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

---

# 30. Validació del client Windows

Comprovar:

```powershell
ipconfig /all
```

Rutes:

```powershell
route print -4
```

DNS:

```powershell
nslookup w-ncc.asix3jyt.local
```

Web:

```powershell
Test-NetConnection 192.168.10.10 -Port 80
```

FTP:

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

Internet:

```powershell
ping 8.8.8.8
```

---

# 31. Configuració del client Linux

El client Linux també es connecta a:

```text
192.168.20.0/24
```

Gateway:

```text
192.168.20.1
```

DNS:

```text
192.168.20.1
```

---

# 32. Validació del client Linux

Comprovar la xarxa:

```bash
ip a
```

Rutes:

```bash
ip route
```

Gateway:

```bash
ping 192.168.20.1
```

DNS:

```bash
nslookup w-ncc.asix3jyt.local
```

Web:

```bash
curl http://w-ncc.asix3jyt.local
```

---

# 33. Desplegament de l'autenticació

La base de dades ha de contenir la taula:

```text
usuarios
```

Camps principals:

```text
id
username
password_hash
rol
```

Rols:

```text
lector
admin
```

Les contrasenyes web s'han d'emmagatzemar mitjançant hash.

---

# 34. Desplegament del CRUD

La carpeta:

```text
/equipaments/
```

conté:

```text
index.php
create.php
edit.php
delete.php
```

Les rutes de creació, edició i eliminació han d'utilitzar control administratiu.

---

# 35. Validació de rols

## Lector

Ha de poder:

- iniciar sessió
- consultar dades

No ha de poder:

- crear
- editar
- eliminar

---

## Administrador

Ha de poder:

- consultar
- crear
- editar
- eliminar

---

# 36. Validació de seguretat

Una vegada desplegada la infraestructura s'han de provar tant accessos correctes com accessos incorrectes.

### Accés correcte

```text
W-NCC -> B-NCC MySQL
```

### Accés incorrecte

```text
Client -> B-NCC MySQL
```

### Aplicació

```text
lector -> DELETE -> HTTP 403
```

Aquestes proves demostren que els controls de seguretat funcionen.

---

# 37. Comprovació final dels serveis

## R-NCC

```bash
sudo systemctl status isc-dhcp-server
sudo systemctl status bind9
sudo ufw status
sudo iptables -t nat -L POSTROUTING -n -v
```

## W-NCC

```bash
sudo systemctl status nginx
sudo systemctl status php8.1-fpm
sudo nginx -t
```

## B-NCC

```bash
sudo systemctl status mysql
sudo ss -lntp | grep 3306
sudo ufw status
```

## F-NCC

```bash
sudo ss -lntp | grep :21
```

---

# 38. Ordre de proves final

Després del desplegament es recomana validar en aquest ordre:

```text
1. Interfaces
2. Routing
3. DHCP
4. DNS
5. Firewall
6. NAT
7. HTTP
8. MySQL
9. FTP
10. Login
11. Rols
12. CRUD
13. Proves negatives
```

Aquest ordre facilita detectar en quin punt apareix una incidència.

---

# 39. Criteris de desplegament complet

La instal·lació es considera completada quan:

- [x] les xarxes estan creades
- [x] R-NCC actua com a router
- [x] DHCP funciona
- [x] DNS funciona
- [x] NAT funciona
- [x] UFW està configurat
- [x] W-NCC serveix la web
- [x] PHP funciona
- [x] B-NCC executa MySQL
- [x] W-NCC pot accedir a B-NCC
- [x] B-NCC està restringit
- [x] F-NCC proporciona FTP
- [x] Windows està integrat
- [x] Linux està integrat
- [x] l'autenticació funciona
- [x] els rols funcionen
- [x] el CRUD funciona

---

# 40. Evidències

Les captures de la instal·lació i les proves es recopilaran durant la revisió final.

Les evidències més útils seran:

📸 serveis actius

📸 configuració de xarxa

📸 DHCP entregant una IP

📸 DNS resolent noms

📸 NAT amb trànsit

📸 NGINX funcionant

📸 connexió W-NCC → B-NCC

📸 UFW de B-NCC

📸 FTP funcional

📸 login i rols

📸 CRUD complet

---

# 41. Conclusió

El desplegament de la infraestructura s'ha de realitzar de manera ordenada perquè existeixen dependències entre els diferents serveis.

R-NCC s'ha de preparar abans dels clients i dels servidors de la DMZ.

W-NCC i B-NCC formen conjuntament la capa d'aplicació i dades.

F-NCC proporciona el servei FTP.

Finalment, els clients permeten validar que tota la infraestructura funciona correctament des de la Intranet.

La documentació d'aquest procés facilita la reproducció, manteniment i recuperació de la infraestructura.
