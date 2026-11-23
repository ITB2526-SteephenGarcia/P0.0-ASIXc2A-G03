# Documentació d'Administrador

Aquesta carpeta conté la documentació tècnica destinada a l'administració, manteniment i resolució d'incidències de la infraestructura desplegada al projecte **P.0-ASIXc2A-G03**.

L'objectiu és que una persona amb coneixements d'administració de sistemes pugui entendre l'arquitectura, identificar cada servei, revisar configuracions, validar el funcionament de la infraestructura i aplicar tasques bàsiques de manteniment o recuperació.

---

## 1. Abast de la documentació

La documentació d'administració inclou:

- arquitectura general de la infraestructura;
- configuració de xarxes;
- funció de cada màquina;
- serveis instal·lats;
- dependències;
- routing;
- DHCP;
- DNS;
- NAT;
- firewall;
- servidor web;
- base de dades;
- FTP;
- clients;
- instal·lació;
- manteniment;
- incidències;
- proves;
- mesures de seguretat.

Aquesta documentació està orientada a deixar constància tècnica del desplegament realitzat i facilitar-ne l'administració posterior.

---

## 2. Arquitectura general

La infraestructura principal està formada per:

```text
                         Internet
                            |
                          R-NCC
                 Router / Firewall / NAT
                    /               \
                   /                 \
            DMZ 192.168.10.0/24   Intranet 192.168.20.0/24
              /          \               |
             /            \              |
         W-NCC           F-NCC      Clients Windows/Linux
      192.168.10.10   192.168.10.20
             |
             | Interfície backend
             | 192.168.30.1
             |
      Backend 192.168.30.0/24
             |
           B-NCC
       192.168.30.10
          MySQL
```

### Separació de la base de dades

B-NCC no està connectat directament a R-NCC.

La comunicació amb MySQL es realitza exclusivament mitjançant W-NCC:

```text
W-NCC
192.168.30.1
    |
    |
Backend privat
192.168.30.0/24
    |
    |
B-NCC
192.168.30.10
```

Aquesta separació permet reduir l'exposició del servidor de base de dades.

---

## 3. Xarxes utilitzades

| Xarxa | Rang | Funció |
|---|---|---|
| Exterior | Proporcionada per IsardVDI | Sortida a Internet de R-NCC |
| DMZ | 192.168.10.0/24 | Servidors W-NCC i F-NCC |
| Intranet | 192.168.20.0/24 | Clients Windows i Linux |
| Backend | 192.168.30.0/24 | Comunicació privada W-NCC ↔ B-NCC |

---

## 4. Màquines de la infraestructura

| Hostname | Funció principal |
|---|---|
| R-NCC | Router, firewall, DHCP, DNS i NAT |
| W-NCC | Servidor web i aplicació |
| B-NCC | Servidor MySQL |
| F-NCC | Servidor FTP |
| Windows | Client de validació |
| Linux | Client de validació |

---

## 5. Serveis principals

### R-NCC

R-NCC concentra els serveis de xarxa principals:

- routing IPv4;
- forwarding;
- DHCP;
- DNS;
- firewall UFW;
- NAT;
- control del trànsit entre DMZ i Intranet.

### W-NCC

W-NCC conté:

- NGINX;
- PHP;
- PHP-FPM;
- PDO MySQL;
- SSH;
- aplicació web;
- interfície privada cap a B-NCC.

### B-NCC

B-NCC conté:

- MySQL 8;
- base de dades `equipaments`;
- usuaris MySQL diferenciats;
- UFW;
- SSH restringit;
- xarxa backend privada.

### F-NCC

F-NCC proporciona:

- servei FTP;
- autenticació;
- pujada de fitxers;
- descàrrega de fitxers.

---

## 6. Seguretat aplicada

Les principals mesures de seguretat desplegades són:

- segmentació de xarxes;
- DMZ separada de la Intranet;
- backend privat per a B-NCC;
- firewall UFW;
- forwarding restringit;
- NAT a R-NCC;
- MySQL accessible només des de W-NCC;
- SSH de B-NCC accessible només des de W-NCC;
- usuaris MySQL amb permisos diferenciats;
- autenticació web;
- control de rols;
- protecció de rutes administratives;
- contrasenyes web emmagatzemades mitjançant hash.

Aquestes decisions tenen com a objectiu aplicar el principi de mínim privilegi i limitar els serveis exposats.

---

## 7. Índex de documentació

### Infraestructura i arquitectura

- [Arquitectura](./Arquitectura.md)  
  Descripció detallada de la topologia, xarxes, comunicacions, segmentació i decisions de disseny.

### Servidors

- [R-NCC](./R-NCC.md)  
  Configuració d'interfícies, routing, DHCP, DNS, firewall, forwarding i NAT.

- [W-NCC](./W-NCC.md)  
  Configuració del servidor web, NGINX, PHP, aplicació multicapa i connexió amb B-NCC.

- [B-NCC](./B-NCC.md)  
  Configuració de MySQL, xarxa backend, usuaris, permisos, bind-address, UFW i aïllament.

- [F-NCC](./F-NCC.md)  
  Configuració del servidor FTP i proves de transferència.

### Clients

- [Client Windows](./Cliente_Windows.md)  
  Configuració DHCP, DNS, routing, accés web, FTP i proves de connectivitat.

- [Client Linux](./Cliente_Linux.md)  
  Configuració de xarxa, DNS i proves des del client Linux.

### Serveis i seguretat

- [Serveis](./Servicios.md)  
  Resum dels serveis desplegats, ports, dependències i relacions entre màquines.

- [Seguretat i Firewall](./Seguridad-Firewall.md)  
  Regles de firewall, control de trànsit, segmentació, mínim privilegi i mesures de protecció.

### Operació i manteniment

- [Instal·lació](./Instalacion.md)  
  Procediment general de desplegament de la infraestructura.

- [Manteniment](./Mantenimiento.md)  
  Tasques periòdiques, comprovació de serveis, logs, xarxa i base de dades.

- [Incidències](./Incidencias.md)  
  Problemes reals trobats durant el projecte i solucions aplicades.

---

## 8. Criteris de validació

Per considerar la infraestructura operativa es comproven els següents criteris:

| Element | Validació |
|---|---|
| Routing | connectivitat entre xarxes autoritzades |
| DHCP | assignació correcta d'IP, gateway i DNS |
| DNS | resolució correcta dels noms interns |
| NAT | sortida a Internet utilitzant R-NCC |
| Web | accés HTTP a W-NCC |
| MySQL | connexió W-NCC → B-NCC |
| Seguretat MySQL | bloqueig d'orígens no autoritzats |
| FTP | autenticació, llistat, pujada i descàrrega |
| Login web | autenticació correcta |
| Rols | separació entre lector i administrador |
| CRUD | alta, consulta, modificació i eliminació |
| Persistència | serveis i configuracions actives després de reinici |

---

## 9. Criteris de rendiment i disponibilitat

La validació de la infraestructura no es limita a comprovar que els serveis estan instal·lats.

També es tenen en compte criteris mesurables:

- resposta dels serveis esperats;
- disponibilitat dels ports configurats;
- resolució DNS correcta;
- assignació DHCP correcta;
- comunicació només entre xarxes autoritzades;
- accés MySQL restringit;
- persistència de NAT;
- disponibilitat de la web;
- funcionament de les transferències FTP;
- accés a Internet mitjançant el gateway del projecte.

Aquestes comprovacions permeten validar objectivament el funcionament del sistema.

---

## 10. Manteniment i recuperació

La documentació d'administració inclou procediments per:

- comprovar l'estat dels serveis;
- reiniciar serveis;
- validar fitxers de configuració;
- revisar logs;
- detectar errors de routing;
- comprovar DNS;
- verificar DHCP;
- revisar NAT;
- comprovar UFW;
- validar ports;
- comprovar MySQL;
- verificar connectivitat;
- recuperar comunicacions després d'un canvi de xarxa.

---

## 11. Registre d'incidències

Durant el projecte s'han produït incidències reals relacionades amb:

- rutes incorrectes;
- dues portes d'enllaç per defecte;
- errors de NAT;
- problemes de DNS;
- canvi de numeració d'interfícies;
- permisos MySQL;
- hashes incorrectes;
- configuració NGINX;
- forwarding FTP;
- routing de retorn;
- aïllament de B-NCC.

Aquestes incidències es documenten a:

- [Incidències](./Incidencias.md)

La finalitat no és només indicar l'error, sinó deixar constància de:

1. símptoma;
2. causa;
3. diagnòstic;
4. solució;
5. verificació posterior.

---

## 12. Proves i evidències

Les proves tècniques principals que formen part del projecte són:

- ping entre equips autoritzats;
- `ip route`;
- `ip a`;
- `systemctl status`;
- `ufw status`;
- `ss`;
- `nslookup`;
- `dig`;
- `Test-NetConnection`;
- connexió SSH;
- connexió MySQL;
- consultes SQL;
- proves FTP;
- navegació web;
- proves de rols;
- proves CRUD;
- contadors NAT.

📸 **CAPTURA RECOMANADA:** conservar captures de les proves importants, especialment:

- DHCP assignant IP;
- DNS resolent noms;
- NAT amb comptadors diferents de zero;
- UFW de B-NCC;
- MySQL amb `889` registres;
- FTP amb `get` i `put`;
- login lector;
- login administrador;
- accés denegat del lector a una ruta administrativa.

---

## 13. Relació amb la rúbrica

Aquesta documentació està estructurada per donar cobertura a criteris relacionats amb:

- arquitectura;
- configuracions;
- dependències;
- instal·lació;
- manteniment;
- resolució d'incidències;
- seguretat;
- proves;
- rendiment;
- disponibilitat;
- aplicació correcta de tecnologies;
- documentació tècnica exhaustiva.

La documentació d'administració no substitueix el seguiment de tasques ni la documentació d'usuari, sinó que forma part del conjunt documental del projecte.

---

## 14. Objectiu final

La finalitat d'aquesta carpeta és permetre que un administrador pugui:

- entendre la infraestructura;
- identificar ràpidament cada màquina;
- localitzar la documentació correcta;
- revisar configuracions;
- comprovar el funcionament dels serveis;
- aplicar manteniment;
- detectar incidències;
- revisar la seguretat;
- validar l'estat global del projecte.
