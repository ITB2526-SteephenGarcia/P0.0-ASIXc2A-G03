# Serveis de la infraestructura

## 1. Objectiu

Aquest document resumeix els serveis desplegats al projecte **P.0-ASIXc2A-G03**.

L'objectiu és disposar d'una visió ràpida de:

- quin servei executa cada màquina
- quin port utilitza
- quina funció té
- quins equips hi accedeixen
- quines dependències té
- com es pot comprovar el seu funcionament

---

## 2. Resum general

| Servei | Màquina | Port principal | Funció |
|---|---|---:|---|
| Routing | R-NCC | — | Comunicació entre xarxes |
| DHCP | R-NCC | 67/UDP | Assignació automàtica de xarxa |
| DNS | R-NCC | 53/TCP i 53/UDP | Resolució de noms |
| NAT | R-NCC | — | Sortida a Internet |
| Firewall | R-NCC | — | Control de trànsit |
| HTTP | W-NCC | 80/TCP | Aplicació web |
| PHP-FPM | W-NCC | intern | Execució de PHP |
| SSH | W-NCC | 22/TCP | Administració remota |
| MySQL | B-NCC | 3306/TCP | Base de dades |
| SSH | B-NCC | 22/TCP | Administració des de W-NCC |
| FTP | F-NCC | 21/TCP | Transferència de fitxers |
| SSH | Diferents servidors | 22/TCP | Administració remota |

---

# 3. Routing

## Màquina

```text
R-NCC
```

## Funció

R-NCC permet la comunicació entre:

```text
Intranet
192.168.20.0/24
```

i:

```text
DMZ
192.168.10.0/24
```

També permet la sortida cap a la xarxa exterior.

---

## Requisit principal

El reenviament IPv4 ha d'estar habilitat.

```bash
sysctl net.ipv4.ip_forward
```

Resultat esperat:

```text
net.ipv4.ip_forward = 1
```

---

# 4. DHCP

## Màquina

```text
R-NCC
```

## Servei

```text
isc-dhcp-server
```

## Port

```text
67/UDP
```

## Funció

Assignar automàticament configuració de xarxa als clients de la Intranet.

La configuració proporcionada inclou:

- IP
- màscara
- gateway
- DNS
- domini intern

---

## Exemple validat

El client Windows va obtenir:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

---

## Comprovació

```bash
sudo systemctl status isc-dhcp-server
```

---

# 5. DNS

## Màquina

```text
R-NCC
```

## Servei

```text
BIND9
```

## Ports

```text
53/TCP
53/UDP
```

## Funció

Resoldre els noms interns del projecte.

Domini:

```text
asix3jyt.local
```

---

## Registres principals

```text
r-ncc.asix3jyt.local -> 192.168.20.1
w-ncc.asix3jyt.local -> 192.168.10.10
f-ncc.asix3jyt.local -> 192.168.10.20
```

---

## Comprovació

Des d'un client:

```bash
nslookup w-ncc.asix3jyt.local
```

o:

```bash
dig w-ncc.asix3jyt.local
```

---

# 6. NAT

## Màquina

```text
R-NCC
```

## Funció

Permetre que les xarxes internes puguin sortir a Internet utilitzant la interfície exterior de R-NCC.

Xarxes configurades:

```text
192.168.20.0/24
192.168.10.0/24
```

---

## Regles principals

```bash
-A POSTROUTING -s 192.168.20.0/24 -o enp1s0 -j MASQUERADE
```

```bash
-A POSTROUTING -s 192.168.10.0/24 -o enp1s0 -j MASQUERADE
```

---

## Persistència

Les regles es troben a:

```text
/etc/ufw/before.rules
```

---

## Comprovació

```bash
sudo iptables -t nat -L POSTROUTING -n -v
```

---

# 7. Firewall

## Màquines

El firewall s'utilitza principalment a:

```text
R-NCC
B-NCC
```

Tecnologia:

```text
UFW
```

---

## Funció de R-NCC

Controlar:

- accés als serveis de xarxa
- trànsit entre Intranet i DMZ
- forwarding cap a W-NCC
- forwarding cap a F-NCC

---

## Funció de B-NCC

Limitar els accessos a:

```text
MySQL 3306/TCP
SSH 22/TCP
```

únicament des de:

```text
192.168.30.1
```

corresponent a W-NCC.

---

## Comprovació

```bash
sudo ufw status
```

---

# 8. HTTP

## Màquina

```text
W-NCC
```

## Servei

```text
NGINX
```

## Port

```text
80/TCP
```

## Funció

Proporcionar accés a l'aplicació web.

---

## Adreça del servidor

```text
192.168.10.10
```

Els clients de la Intranet accedeixen a W-NCC mitjançant R-NCC.

---

## Comprovació

Des de Linux:

```bash
curl http://192.168.10.10
```

Des de Windows:

```powershell
Test-NetConnection 192.168.10.10 -Port 80
```

També es pot utilitzar un navegador.

---

# 9. PHP

## Màquina

```text
W-NCC
```

## Versió

```text
PHP 8.1
```

## Funció

PHP processa la lògica de l'aplicació.

Entre les seves funcions hi ha:

- login
- sessions
- rols
- connexió MySQL
- consulta de dades
- creació de registres
- edició de registres
- eliminació de registres

---

# 10. PHP-FPM

## Màquina

```text
W-NCC
```

## Funció

PHP-FPM rep les peticions PHP enviades per NGINX.

Sense PHP-FPM, NGINX no pot processar correctament els fitxers PHP de l'aplicació.

---

## Comprovació

```bash
sudo systemctl status php8.1-fpm
```

---

# 11. Aplicació web

## Màquina

```text
W-NCC
```

## Funcions principals

La web permet:

- autenticació
- consulta d'equipaments
- control de rols
- CREATE
- READ
- UPDATE
- DELETE
- logout

---

## Rols

```text
lector
admin
```

El lector només pot consultar.

L'administrador pot gestionar els registres.

---

# 12. MySQL

## Màquina

```text
B-NCC
```

## Port

```text
3306/TCP
```

## Adreça

```text
192.168.30.10
```

## Funció

Emmagatzemar les dades de l'aplicació.

Base de dades:

```text
equipaments
```

---

## Registres

La taula principal conté:

```text
889
```

files.

---

## Restricció d'accés

El port 3306 només està permès des de:

```text
192.168.30.1
```

corresponent a W-NCC.

---

## Comprovació

Des de W-NCC:

```bash
mysql -h 192.168.30.10 -u bchecker -p
```

---

# 13. Usuaris MySQL

## bchecker

Funció:

```text
lectura
```

Permís principal:

```text
SELECT
```

---

## web_admin

Funció:

```text
administració de l'aplicació
```

Permisos:

```text
SELECT
INSERT
UPDATE
DELETE
```

Els dos usuaris estan restringits a:

```text
192.168.30.1
```

---

# 14. SSH

## Port

```text
22/TCP
```

## Funció

Permetre administració remota dels servidors.

---

## B-NCC

A B-NCC, SSH està especialment restringit.

Només està permès des de:

```text
192.168.30.1
```

Això obliga a utilitzar W-NCC com a punt d'administració dins de la xarxa backend.

---

# 15. FTP

## Màquina

```text
F-NCC
```

## Adreça

```text
192.168.10.20
```

## Port

```text
21/TCP
```

## Funció

Permetre transferència de fitxers entre els clients i F-NCC.

---

## Operacions validades

```text
login
ls
get
put
```

Es va comprovar tant la descàrrega com la pujada de fitxers.

---

# 16. Relacions entre serveis

La infraestructura funciona com una cadena de serveis.

```text
Client
  |
  v
R-NCC
  |
  +------ DNS
  |
  +------ DHCP
  |
  +------ NAT
  |
  +------ Routing
  |
  v
W-NCC
  |
  v
B-NCC
```

En paral·lel:

```text
Client
  |
R-NCC
  |
F-NCC
```

---

# 17. Dependències del servei web

Perquè l'aplicació funcioni completament són necessaris:

```text
R-NCC
   |
W-NCC
   |
B-NCC
```

### R-NCC

Permet l'accés dels clients.

### W-NCC

Executa l'aplicació.

### B-NCC

Proporciona les dades.

---

# 18. Dependències del servei FTP

Perquè els clients de la Intranet puguin utilitzar FTP són necessaris:

```text
Client
  |
R-NCC
  |
F-NCC
```

També és necessària una ruta correcta de retorn a F-NCC.

---

# 19. Ports principals

| Port | Protocol | Servei | Màquina |
|---:|---|---|---|
| 22 | TCP | SSH | Servidors |
| 21 | TCP | FTP | F-NCC |
| 53 | TCP/UDP | DNS | R-NCC |
| 67 | UDP | DHCP | R-NCC |
| 80 | TCP | HTTP | W-NCC |
| 3306 | TCP | MySQL | B-NCC |

---

# 20. Relacions de xarxa

| Origen | Destí | Servei | Permès |
|---|---|---|---|
| Intranet | R-NCC | DHCP/DNS | ✅ |
| Intranet | W-NCC | HTTP | ✅ |
| Intranet | F-NCC | FTP | ✅ |
| W-NCC | B-NCC | MySQL | ✅ |
| W-NCC | B-NCC | SSH | ✅ |
| Intranet | B-NCC | MySQL | ❌ |
| Intranet | B-NCC | SSH | ❌ |
| F-NCC | B-NCC | MySQL | ❌ |

Aquesta taula resumeix la política de comunicacions prevista al projecte.

---

# 21. Comprovació ràpida dels serveis

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

# 22. Criteris de disponibilitat

Es considera que un servei està disponible quan:

- el procés està actiu
- el port esperat està escoltant
- el client autoritzat pot connectar-se
- la funcionalitat real respon correctament

Per exemple, en FTP no és suficient comprovar només el port 21.

També s'ha de validar:

```text
login
ls
get
put
```

De la mateixa manera, per MySQL no és suficient veure el port 3306.

També s'ha de comprovar una consulta real.

---

# 23. Criteris de seguretat

Es considera que un servei està correctament protegit quan:

- només està exposat a les xarxes necessàries
- només els equips autoritzats poden accedir
- els usuaris tenen els permisos mínims necessaris
- el firewall bloqueja accessos no desitjats
- les credencials de l'aplicació no s'emmagatzemen en text pla

---

# 24. Evidències pendents

Les captures es recopilaran en la fase final de documentació.

Les evidències principals seran:

📸 estat del DHCP

📸 estat del DNS

📸 regles NAT

📸 UFW de R-NCC

📸 NGINX i PHP-FPM

📸 MySQL escoltant a `192.168.30.10:3306`

📸 UFW de B-NCC

📸 FTP funcionant

📸 connexions reals des dels clients

---

# 25. Conclusió

Els serveis del projecte estan distribuïts entre diferents màquines segons la seva funció.

R-NCC centralitza els serveis de xarxa.

W-NCC proporciona la capa web.

B-NCC proporciona la capa de dades.

F-NCC proporciona el servei FTP.

Els clients Windows i Linux permeten comprovar que els serveis funcionen des de la Intranet.

Aquesta separació facilita l'administració i permet aplicar polítiques de seguretat diferents a cada capa.
