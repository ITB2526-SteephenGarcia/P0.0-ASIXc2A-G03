# P.0-ASIXc2A-G03

## Desplegament d'infraestructura per a una aplicació multicapa

Aquest repositori recull el desenvolupament, la configuració, les proves i la documentació del projecte **P.0-ASIXc2A-G03**, orientat al desplegament d'una infraestructura de xarxa segmentada per donar servei a una aplicació multicapa.

El projecte s'ha desplegat sobre **IsardVDI** i s'ha gestionat mitjançant una metodologia de treball basada en **SCRUM**, utilitzant **ProofHub** per al seguiment de tasques i **GitHub** com a repositori de documentació, configuracions i scripts.

---

## 1. Objectius del projecte

Els objectius principals són:

- desplegar una arquitectura separada en **DMZ**, **Intranet** i una xarxa backend privada;
- configurar un router central amb encaminament, tallafoc, DHCP, DNS i NAT;
- desplegar un servidor web accessible des de la Intranet;
- desplegar un servidor MySQL aïllat de la resta de la xarxa;
- importar dades reals de Barcelona Open Data;
- desplegar un servidor FTP;
- disposar de clients Windows i Linux per validar la infraestructura;
- implementar una aplicació web connectada a la base de dades;
- aplicar autenticació, rols i control de permisos;
- documentar el procés de treball, l'arquitectura, les configuracions i les proves.

---

## 2. Arquitectura final

La infraestructura s'ha dissenyat amb separació de xarxes per reduir l'exposició dels serveis interns.

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

### Principi de disseny

**B-NCC no està connectat directament a R-NCC.**

La base de dades només és accessible des de **W-NCC** a través de la xarxa privada `192.168.30.0/24`.

Aquesta decisió permet:

- separar la capa web de la capa de dades;
- reduir la superfície d'exposició de MySQL;
- aplicar el principi de mínim privilegi;
- limitar l'accés administratiu i de base de dades a un únic origen autoritzat.

---

## 3. Inventari de màquines

| Equip | Funció | Xarxa / IP principal |
|---|---|---|
| **R-NCC** | Router, firewall, DHCP, DNS i NAT | 192.168.20.1 / 192.168.10.1 |
| **W-NCC** | Servidor web NGINX + PHP | 192.168.10.10 |
| **W-NCC backend** | Accés privat a B-NCC | 192.168.30.1 |
| **B-NCC** | Servidor MySQL | 192.168.30.10 |
| **F-NCC** | Servidor FTP | 192.168.10.20 |
| **Windows** | Client Intranet | DHCP, actualment 192.168.20.100 |
| **Linux** | Client Intranet | Xarxa 192.168.20.0/24 |

---

## 4. Serveis desplegats

| Servei | Equip | Estat |
|---|---|---|
| Routing IPv4 | R-NCC | ✅ Funcionant |
| Firewall UFW | R-NCC / B-NCC | ✅ Funcionant |
| NAT / MASQUERADE | R-NCC | ✅ Funcionant |
| DHCP | R-NCC | ✅ Funcionant |
| DNS BIND9 | R-NCC | ✅ Funcionant |
| NGINX | W-NCC | ✅ Funcionant |
| PHP-FPM | W-NCC | ✅ Funcionant |
| Aplicació web | W-NCC | ✅ Funcionant |
| MySQL | B-NCC | ✅ Funcionant |
| FTP | F-NCC | ✅ Funcionant |
| SSH | Servidors | ✅ Funcionant |
| Client Windows | Intranet | ✅ Validat |
| Client Linux | Intranet | ✅ Desplegat |

---

## 5. R-NCC: routing, DHCP, DNS i NAT

R-NCC és el punt central de comunicació entre les xarxes del projecte.

### Xarxes

- DMZ: `192.168.10.0/24`
- Intranet: `192.168.20.0/24`

### IPv4 forwarding

El reenviament de paquets està habilitat:

```bash
net.ipv4.ip_forward = 1
```

### DHCP

El servei utilitzat és:

```text
isc-dhcp-server
```

El servidor assigna automàticament configuració de xarxa als clients de la Intranet.

Durant les proves, el client Windows ha rebut correctament:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

S'ha observat el procés complet de concessió:

```text
DHCPDISCOVER
DHCPOFFER
DHCPREQUEST
DHCPACK
```

### DNS

El servei DNS utilitza:

```text
BIND9
```

Domini intern:

```text
asix3jyt.local
```

Resolucions validades:

```text
r-ncc.asix3jyt.local -> 192.168.20.1
w-ncc.asix3jyt.local -> 192.168.10.10
f-ncc.asix3jyt.local -> 192.168.10.20
```

Els clients utilitzen `192.168.20.1` com a servidor DNS.

### NAT

R-NCC realitza NAT per permetre sortida a Internet des de les xarxes internes.

```text
192.168.20.0/24 -> MASQUERADE -> interfície exterior
192.168.10.0/24 -> MASQUERADE -> interfície exterior
```

La configuració persistent es troba a:

```text
/etc/ufw/before.rules
```

La prova de NAT s'ha realitzat eliminant la ruta directa del client Windows i mantenint com a gateway únic:

```text
192.168.20.1
```

El client ha continuat tenint accés a Internet i els comptadors de la regla `MASQUERADE` han augmentat, demostrant que el trànsit passava realment per R-NCC.

---

## 6. W-NCC i aplicació web

W-NCC es troba a la DMZ i té dues interfícies de projecte:

```text
DMZ:     192.168.10.10/24
Backend: 192.168.30.1/24
```

Tecnologies principals:

- Ubuntu Server
- NGINX
- PHP 8.1
- PHP-FPM
- PDO MySQL
- SSH

L'aplicació web consulta la base de dades de B-NCC a través de la xarxa backend privada.

### Funcionalitats implementades

- autenticació d'usuaris;
- sessions PHP;
- diferenciació de rols;
- consulta paginada d'equipaments;
- alta de registres;
- modificació de registres;
- eliminació de registres;
- protecció de rutes administratives.

---

## 7. Rols de l'aplicació

### Lector

Usuari:

```text
bchecker
```

Permisos:

- iniciar sessió;
- consultar dades;
- navegar per la taula.

No pot:

- crear;
- editar;
- eliminar registres.

Les rutes administratives també estan protegides al servidor.

Per tant, encara que el lector intenti accedir directament a una URL administrativa, el servidor rebutja la petició.

### Administrador

Usuari:

```text
web_admin
```

Permisos:

- consultar;
- crear;
- editar;
- eliminar.

Això permet demostrar un CRUD complet amb control d'accés per rol.

---

## 8. B-NCC i seguretat de MySQL

B-NCC utilitza **MySQL 8** i es troba a la xarxa backend:

```text
192.168.30.10/24
```

MySQL escolta a:

```text
192.168.30.10:3306
```

El firewall de B-NCC limita els accessos:

```text
3306/tcp -> només 192.168.30.1
22/tcp   -> només 192.168.30.1
```

Per tant:

```text
W-NCC -> MySQL ✅
W-NCC -> SSH   ✅

Altres equips -> MySQL ❌
Altres equips -> SSH   ❌
```

La interfície Default d'IsardVDI es va eliminar de B-NCC per reduir accessos directes innecessaris.

---

## 9. Base de dades

La base de dades utilitza dades d'equipaments procedents de **Barcelona Open Data**.

El CSV original estava codificat en UTF-16 i es va convertir a UTF-8 abans de la importació.

Base de dades:

```text
equipaments
```

Taula principal:

```text
equipaments
```

Registres importats:

```text
889
```

Prova executada des de W-NCC:

```sql
USE equipaments;
SELECT COUNT(*) FROM equipaments;
```

Resultat:

```text
889
```

### Comptes MySQL de l'aplicació

#### `bchecker`

Permisos:

```text
SELECT
```

#### `web_admin`

Permisos:

```text
SELECT
INSERT
UPDATE
DELETE
```

Els dos comptes estan restringits a l'origen:

```text
192.168.30.1
```

corresponent a W-NCC.

---

## 10. Usuaris web

La base de dades conté una taula:

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

Les contrasenyes de l'aplicació no s'emmagatzemen en text pla.

Es validen mitjançant:

```php
password_hash()
password_verify()
```

Rols disponibles:

```text
lector
admin
```

---

## 11. F-NCC

F-NCC és el servidor FTP situat a la DMZ:

```text
192.168.10.20
```

Port principal:

```text
21/tcp
```

S'han realitzat proves de:

- connexió al servidor;
- autenticació;
- llistat de fitxers;
- descàrrega;
- pujada de fitxers.

La comunicació entre Intranet i F-NCC passa per R-NCC i les regles de forwarding configurades.

---

## 12. Client Windows

El client Windows es troba a la Intranet.

La configuració es rep mitjançant DHCP.

Durant les proves:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

Des de Windows s'ha validat:

- DHCP;
- DNS;
- comunicació amb la DMZ;
- accés a W-NCC;
- accés a l'aplicació web;
- autenticació;
- permisos de lector;
- permisos d'administrador;
- FTP;
- sortida a Internet mitjançant NAT de R-NCC.

---

## 13. Client Linux

També es disposa d'un client Linux connectat a la Intranet.

S'utilitza per comprovar:

- connectivitat;
- resolució DNS;
- accés a serveis;
- comunicació entre xarxes;
- comportament general de la infraestructura.

---

## 14. Criteris de rendiment i disponibilitat

Per validar el funcionament de la infraestructura s'han definit criteris objectius.

| Criteri | Validació |
|---|---|
| Connectivitat entre xarxes autoritzades | ping / connexions TCP |
| Assignació DHCP | IP, gateway i DNS correctes |
| Resolució DNS | resolució dels noms interns |
| Disponibilitat web | accés HTTP a W-NCC |
| Disponibilitat MySQL | connexió W-NCC → B-NCC |
| Aïllament MySQL | bloqueig des d'orígens no autoritzats |
| FTP | login, llistat, pujada i descàrrega |
| NAT | accés a Internet amb R-NCC com a gateway |
| Persistència | serveis habilitats i configuracions persistents |

Aquests criteris permeten comprovar de manera mesurable si la infraestructura funciona correctament.

---

## 15. Seguretat aplicada

Mesures implementades:

- segmentació entre Intranet i DMZ;
- xarxa backend independent;
- B-NCC sense connexió directa a R-NCC;
- UFW;
- forwarding restringit;
- NAT a R-NCC;
- MySQL limitat a W-NCC;
- SSH de B-NCC limitat a W-NCC;
- usuaris MySQL amb privilegis diferenciats;
- autenticació web;
- hashes de contrasenya;
- control de rols;
- protecció de rutes administratives.

Aquestes decisions busquen aplicar el principi de mínim privilegi i limitar els serveis exposats.

---

## 16. Metodologia i seguiment

El projecte s'ha treballat per sprints utilitzant una metodologia basada en **SCRUM**.

Eina de seguiment:

```text
ProofHub
```

Flux utilitzat:

```text
Backlog -> To Do -> In Progress -> Test/Review -> Done
```

El repositori conté documentació del procés i dels sprints per deixar constància de:

- planificació;
- tasques;
- treball realitzat;
- problemes trobats;
- decisions tècniques;
- proves;
- evolució de la solució.

Aquesta traçabilitat permet demostrar que el projecte s'ha desenvolupat de manera progressiva.

---

## 17. Planificació, recursos i riscos

La documentació del projecte inclou o ha d'incloure:

### Planificació

- fases del projecte;
- sprints;
- tasques;
- responsables;
- estat de cada tasca;
- cronologia real.

### Recursos

- màquines virtuals;
- xarxes;
- sistemes operatius;
- serveis;
- eines de gestió;
- repositori GitHub;
- ProofHub.

### Riscos

Alguns riscos principals identificats durant el projecte:

- pèrdua de connectivitat per una mala configuració de rutes;
- exposició excessiva de MySQL;
- errors de DNS;
- problemes de NAT;
- dependència d'una única màquina;
- configuracions no persistents;
- pèrdua de dades;
- accés indegut a funcions administratives.

Les mesures de mitigació s'han anat aplicant durant el desplegament.

---

## 18. Estructura del repositori

```text
P0.0-ASIXc2A-G03/
|
|-- Config/
|-- Doc_Administrador/
|-- Doc_Proceso/
|-- Doc_Proceso_Proyecto/
|-- Doc_Usuario/
|-- Scripts/
|-- README.md
```

### `Config`

Conté configuracions rellevants dels serveis desplegats.

### `Doc_Administrador`

Documentació tècnica per a l'administrador:

- arquitectura;
- màquines;
- configuracions;
- dependències;
- instal·lació;
- seguretat;
- manteniment;
- incidències;
- serveis.

### `Doc_Usuario`

Documentació adaptada a l'usuari final:

- accés;
- ús de l'aplicació;
- operacions disponibles;
- manteniment bàsic;
- resolució de problemes.

### `Doc_Proceso` / `Doc_Proceso_Proyecto`

Documentació del procés:

- sprints;
- planificació;
- seguiment;
- decisions;
- proves;
- evolució.

### `Scripts`

Scripts i automatitzacions utilitzats durant el desplegament.

---

## 19. Proves i evidències

Durant el projecte s'han realitzat proves de:

- routing;
- DHCP;
- DNS;
- NAT;
- firewall;
- connectivitat DMZ/Intranet;
- SSH;
- FTP;
- HTTP;
- MySQL;
- aïllament de B-NCC;
- autenticació web;
- permisos de lector;
- permisos d'administrador;
- CRUD.

Les proves de:

- automatització;
- contingència;
- monitorització;
- seguretat;

s'han de documentar amb evidències reals i no es consideraran completades fins que existeixi una prova verificable.

---

## 20. Documentació orientada a la rúbrica

La documentació del repositori s'està estructurant per poder demostrar els criteris principals d'avaluació:

- recerca i justificació de tecnologies;
- planificació completa;
- recursos;
- riscos;
- criteris mesurables de rendiment i disponibilitat;
- seguiment real de tasques;
- execució tècnica;
- documentació funcional;
- documentació tècnica;
- proves;
- documentació d'usuari;
- documentació d'administrador;
- aplicació correcta de tecnologies;
- autonomia i traçabilitat del treball.

---

## 21. Estat actual del projecte

### Funcionalitat principal completada

- [x] R-NCC
- [x] DMZ
- [x] Intranet
- [x] DHCP
- [x] DNS
- [x] NAT
- [x] Firewall
- [x] W-NCC
- [x] B-NCC
- [x] MySQL
- [x] Importació de dades
- [x] F-NCC
- [x] FTP
- [x] Client Windows
- [x] Client Linux
- [x] Aplicació web
- [x] Login
- [x] Rols
- [x] CRUD
- [x] Aïllament de B-NCC

### Fase final

El treball restant se centra principalment en:

- completar tota la documentació;
- ordenar evidències;
- completar les proves exigides per la rúbrica;
- revisar riscos;
- revisar contingència;
- revisar monitorització;
- revisar automatització;
- millorar la presentació visual de l'aplicació;
- preparar la defensa final.

---

## 22. Autoria

Projecte desenvolupat per l'equip **ASIXc2A-G03** dins del projecte intermodular d'ASIX.
