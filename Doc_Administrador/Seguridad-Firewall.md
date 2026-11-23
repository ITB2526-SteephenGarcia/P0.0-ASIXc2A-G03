# Seguretat i Firewall

## 1. Objectiu

Aquest document descriu les mesures de seguretat aplicades a la infraestructura del projecte **P.0-ASIXc2A-G03**.

La seguretat del projecte es basa principalment en:

- segmentació de xarxes
- separació de serveis
- principi de mínim privilegi
- control del trànsit amb UFW
- restricció de MySQL
- restricció de SSH
- control d'accés a l'aplicació web
- separació de rols
- contrasenyes web emmagatzemades mitjançant hash
- validació d'accessos permesos i bloquejats

L'objectiu no és només permetre que els serveis funcionin, sinó limitar qui pot accedir a cada servei.

---

## 2. Segmentació de xarxes

La infraestructura està dividida en diferents xarxes.

### DMZ

```text id="5i4rvu"
192.168.10.0/24
```

Conté:

```text id="yto5rt"
W-NCC
F-NCC
```

### Intranet

```text id="wr779o"
192.168.20.0/24
```

Conté:

```text id="9lnxl4"
Client Windows
Client Linux
```

### Backend

```text id="26p6fz"
192.168.30.0/24
```

Conté:

```text id="ynxs2u"
W-NCC
B-NCC
```

La xarxa backend és privada i s'utilitza només per a la comunicació entre la capa web i la base de dades.

---

## 3. Objectiu de la segmentació

La segmentació evita que tots els equips comparteixin una única xarxa.

Això permet aplicar diferents polítiques de seguretat segons la funció de cada màquina.

Per exemple:

```text id="8osytz"
Client Windows
      |
      X
      |
    B-NCC
```

El client Windows no necessita accedir directament a MySQL.

En canvi:

```text id="orxaj6"
W-NCC
      |
      |
    B-NCC
```

W-NCC sí necessita accés a MySQL.

Per aquest motiu, només aquesta comunicació està autoritzada.

---

# 4. Principi de mínim privilegi

La configuració segueix el principi de mínim privilegi.

Aquest principi consisteix a donar a cada:

- usuari
- servei
- equip
- procés

únicament els permisos necessaris per realitzar la seva funció.

Aquest criteri s'aplica tant a la xarxa com a MySQL i a l'aplicació web.

---

# 5. Firewall principal

R-NCC utilitza:

```text id="gn0b3l"
UFW
```

R-NCC actua com a punt central de control entre:

```text id="ypxlg1"
Intranet
DMZ
Exterior
```

El firewall s'encarrega de controlar:

- serveis disponibles al router
- forwarding entre xarxes
- accés a W-NCC
- accés a F-NCC
- trànsit cap a Internet

---

# 6. Estat del firewall

L'estat es comprova mitjançant:

```bash id="w2s00z"
sudo ufw status
```

El resultat esperat és:

```text id="budywk"
Status: active
```

---

# 7. Serveis de R-NCC

R-NCC necessita permetre determinats serveis per poder complir la seva funció.

Entre ells:

### DNS

```text id="xgvzi9"
53/TCP
53/UDP
```

### DHCP

```text id="82sq7f"
67/UDP
```

### SSH

```text id="q3cmse"
22/TCP
```

### Forwarding

Trànsit autoritzat entre la Intranet i determinats servidors de la DMZ.

---

# 8. Accés HTTP

Els clients de la Intranet necessiten accedir a W-NCC.

Flux permès:

```text id="z3sv3b"
192.168.20.0/24
       |
       |
       v
192.168.10.10:80
```

Aquest trànsit permet utilitzar l'aplicació web.

---

# 9. Accés FTP

Els clients també necessiten accedir a F-NCC.

Flux permès:

```text id="xr598i"
192.168.20.0/24
       |
       |
       v
192.168.10.20:21
```

R-NCC permet aquest trànsit mitjançant regles de forwarding.

---

# 10. Firewall de B-NCC

B-NCC també utilitza UFW.

Aquest firewall és especialment important perquè protegeix la base de dades.

La configuració final permet únicament:

```text id="s2ci6k"
3306/tcp des de 192.168.30.1
22/tcp des de 192.168.30.1
```

La direcció:

```text id="pklrm4"
192.168.30.1
```

correspon a W-NCC.

---

# 11. MySQL restringit

El servei MySQL utilitza:

```text id="o46vv9"
3306/TCP
```

Aquest port només pot ser utilitzat des de W-NCC.

Per tant:

```text id="0pqk7e"
W-NCC -> MySQL ✅
Windows -> MySQL ❌
Linux -> MySQL ❌
F-NCC -> MySQL ❌
```

Això redueix considerablement la superfície d'exposició de la base de dades.

---

# 12. SSH restringit a B-NCC

El servei SSH utilitza:

```text id="dxl2xv"
22/TCP
```

A B-NCC només està permès des de:

```text id="4wxd5n"
192.168.30.1
```

Per tant:

```text id="li7i0s"
W-NCC -> SSH B-NCC ✅
Altres equips -> SSH B-NCC ❌
```

Aquesta configuració obliga a passar per W-NCC per administrar B-NCC des de la xarxa del projecte.

---

# 13. Eliminació de regles obertes

Durant el desplegament inicial existien regles SSH més obertes.

Aquestes regles permetien connexions des de qualsevol origen.

Posteriorment es va afegir la regla específica:

```text id="v9obn9"
192.168.30.1 -> 22/TCP
```

i es van eliminar les regles generals.

Això representa una millora respecte a la configuració inicial.

---

# 14. Aïllament físic de B-NCC

La protecció de B-NCC no depèn únicament del firewall.

També es va eliminar la interfície Default d'IsardVDI.

La configuració final manté:

```text id="bcikn5"
WireGuard
Backend
```

i elimina la connexió directa a la xarxa exterior.

Això proporciona una capa addicional d'aïllament.

---

# 15. Bind address de MySQL

MySQL està configurat per escoltar únicament a:

```text id="mk5x06"
192.168.30.10
```

Configuració:

```text id="1i5893"
bind-address = 192.168.30.10
```

Per tant, MySQL no escolta en totes les interfícies.

---

# 16. Seguretat en MySQL

La seguretat de MySQL combina diferents capes.

### Capa 1. Xarxa backend

```text id="uu0h8j"
192.168.30.0/24
```

### Capa 2. Bind address

```text id="vhvoj0"
192.168.30.10
```

### Capa 3. UFW

```text id="wltc9i"
3306/TCP només des de 192.168.30.1
```

### Capa 4. Restricció de l'usuari MySQL

Els comptes estan limitats al host:

```text id="6fxgvc"
192.168.30.1
```

Aquestes capes redueixen la possibilitat d'accés no autoritzat.

---

# 17. Usuaris MySQL i mínim privilegi

La base de dades utilitza dos comptes principals.

## bchecker

Permisos:

```text id="ab70gf"
SELECT
```

Funció:

```text id="v7mcx7"
lectura
```

No pot modificar les dades.

---

## web_admin

Permisos:

```text id="9w9vef"
SELECT
INSERT
UPDATE
DELETE
```

Funció:

```text id="k6u8un"
operacions administratives de l'aplicació
```

No s'utilitza per a les consultes normals.

---

# 18. Diferència entre rols web i permisos MySQL

La seguretat de l'aplicació té dues capes diferents.

### Rols web

```text id="lmm6ab"
lector
admin
```

Controlen què pot fer l'usuari dins de la web.

### Comptes MySQL

```text id="h3t1yt"
bchecker
web_admin
```

Controlen què pot fer la connexió PHP sobre la base de dades.

Aquests dos sistemes són independents.

---

# 19. Seguretat de l'autenticació web

L'aplicació no guarda les contrasenyes web directament.

La taula:

```text id="0ev0e2"
usuarios
```

conté:

```text id="ud5zfh"
password_hash
```

Les contrasenyes es validen mitjançant:

```php id="lwfnt8"
password_verify()
```

Això evita guardar la contrasenya original en text pla.

---

# 20. Sessions

Quan l'usuari inicia sessió correctament, l'aplicació utilitza sessions PHP.

La sessió permet conservar informació com:

```text id="6rxz1f"
username
rol
```

Les pàgines protegides comproven aquesta sessió abans de mostrar el contingut.

---

# 21. Control d'accés

L'aplicació utilitza funcions com:

```php id="108z8w"
requireLogin()
requireAdmin()
isAdmin()
```

Aquestes funcions permeten controlar l'accés a les diferents pàgines.

---

# 22. Protecció del login

Si un usuari no ha iniciat sessió i intenta accedir a una pàgina protegida, és redirigit a:

```text id="p7llrb"
/login.php
```

Això impedeix l'accés anònim als equipaments.

---

# 23. Protecció de les funcions administratives

Les pàgines:

```text id="47htv3"
/equipaments/create.php
/equipaments/edit.php
/equipaments/delete.php
```

requereixen permisos d'administrador.

Si el rol no és:

```text id="5o3o3n"
admin
```

la petició és rebutjada.

---

# 24. Prova d'accés denegat

Es va validar una ruta administrativa amb el compte lector.

Exemple:

```text id="ev127j"
/equipaments/delete.php?id=756
```

La resposta va ser:

```text id="bq3h76"
Acceso denegado. Se requieren permisos de administrador.
```

Codi:

```text id="fgrdzl"
HTTP 403
```

Aquesta prova és important perquè demostra que no n'hi ha prou amb ocultar els botons d'administració.

---

# 25. Protecció en profunditat

La infraestructura utilitza diferents capes de protecció.

```text id="l2zhqw"
Client
  |
  v
Firewall R-NCC
  |
  v
W-NCC
  |
  v
Control de rol
  |
  v
Compte MySQL
  |
  v
Firewall B-NCC
  |
  v
MySQL
```

Això permet que un únic control de seguretat no sigui l'única barrera.

---

# 26. NAT i seguretat

R-NCC utilitza NAT per permetre la sortida de les xarxes internes.

Les xarxes internes no necessiten utilitzar directament la IP exterior.

Regles:

```text id="rv41me"
192.168.20.0/24 -> MASQUERADE
192.168.10.0/24 -> MASQUERADE
```

El NAT no substitueix un firewall, però forma part del disseny de xarxa.

---

# 27. Comunicacions autoritzades

| Origen | Destí | Servei | Estat |
|---|---|---|---|
| Intranet | R-NCC | DNS | ✅ |
| Intranet | R-NCC | DHCP | ✅ |
| Intranet | W-NCC | HTTP | ✅ |
| Intranet | F-NCC | FTP | ✅ |
| W-NCC | B-NCC | MySQL | ✅ |
| W-NCC | B-NCC | SSH | ✅ |

---

# 28. Comunicacions no necessàries

| Origen | Destí | Servei | Estat esperat |
|---|---|---|---|
| Windows | B-NCC | MySQL | ❌ |
| Linux | B-NCC | MySQL | ❌ |
| F-NCC | B-NCC | MySQL | ❌ |
| Windows | B-NCC | SSH | ❌ |
| Linux | B-NCC | SSH | ❌ |

Aquestes comunicacions no són necessàries per al funcionament normal del projecte.

---

# 29. Riscos de seguretat

## Regles massa obertes

Una regla com:

```text id="5ydfw8"
ALLOW FROM ANYWHERE
```

pot exposar serveis innecessaris.

Per aquest motiu es prefereixen regles basades en origen.

---

## Credencials amb massa permisos

Una aplicació que utilitzi sempre un usuari MySQL administratiu augmenta el risc.

Per aquest motiu s'han separat els permisos de lectura dels permisos CRUD.

---

## Accés directe a B-NCC

Permetre que els clients arribin directament a MySQL eliminaria part de l'aïllament de la infraestructura.

---

## Error en els rols

Si les rutes administratives no validessin el rol al servidor, un usuari podria intentar accedir directament a les URLs.

---

# 30. Comprovacions de seguretat

## UFW de R-NCC

```bash id="22qzfl"
sudo ufw status
```

## UFW de B-NCC

```bash id="y32ibj"
sudo ufw status
```

## Ports MySQL

```bash id="qes0ik"
sudo ss -lntp | grep 3306
```

## Bind address

```bash id="3khh57"
grep bind-address /etc/mysql/mysql.conf.d/mysqld.cnf
```

## Usuaris MySQL

```sql id="k5q9fo"
SELECT user, host FROM mysql.user;
```

## Permisos

```sql id="k7nkwi"
SHOW GRANTS;
```

---

# 31. Proves negatives

Una infraestructura segura no només s'ha de provar amb accions que funcionen.

També és important demostrar que les accions no autoritzades fallen.

Les proves negatives principals són:

### Lector intentant eliminar

Resultat:

```text id="htktne"
HTTP 403
```

### Compte MySQL des d'un origen no autoritzat

Resultat observat:

```text id="8fo0ir"
ERROR 1130
Host is not allowed to connect
```

Aquestes proves reforcen la validació de seguretat.

---

# 32. Criteris de validació

La seguretat de la infraestructura es considera correcta quan:

- [x] la infraestructura està segmentada
- [x] B-NCC utilitza una xarxa privada
- [x] B-NCC no està connectat directament a R-NCC
- [x] MySQL escolta únicament al backend
- [x] UFW està actiu a B-NCC
- [x] MySQL només és accessible des de W-NCC
- [x] SSH de B-NCC només és accessible des de W-NCC
- [x] els comptes MySQL tenen permisos diferenciats
- [x] les contrasenyes web utilitzen hash
- [x] existeixen rols de lector i administrador
- [x] les rutes administratives estan protegides
- [x] el lector rep HTTP 403 en accedir a funcions administratives
- [x] existeixen proves d'accessos permesos i denegats

---

# 33. Evidències pendents

Les captures reals es recopilaran al final.

Les principals són:

📸 `ufw status` de R-NCC

📸 `ufw status` de B-NCC

📸 MySQL escoltant a `192.168.30.10:3306`

📸 `bind-address = 192.168.30.10`

📸 permisos de `bchecker`

📸 permisos de `web_admin`

📸 error `ERROR 1130`

📸 error HTTP 403 del lector

📸 vista administrativa correcta amb `web_admin`

Aquestes evidències permetran demostrar tant accessos correctes com bloquejos.

---

# 34. Millores futures

Algunes millores possibles serien:

- restringir encara més l'accés SSH a R-NCC
- revisar les regles IPv6 no utilitzades
- utilitzar HTTPS per a la web
- utilitzar un protocol segur en lloc de FTP tradicional
- implantar monitorització de seguretat
- centralitzar logs
- automatitzar còpies de seguretat
- aplicar actualitzacions de seguretat periòdiques

Aquestes millores no substitueixen les mesures actuals, sinó que permetrien reforçar encara més la infraestructura.

---

# 35. Conclusió

La seguretat del projecte es basa en diferents capes.

La segmentació de xarxes separa els clients, els serveis públics i la base de dades.

R-NCC controla el trànsit entre xarxes.

B-NCC limita MySQL i SSH exclusivament a W-NCC.

L'aplicació aplica autenticació, sessions i rols.

MySQL utilitza comptes amb privilegis diferenciats.

Aquest conjunt de mesures permet reduir accessos innecessaris i aplicar el principi de mínim privilegi a diferents nivells de la infraestructura.
