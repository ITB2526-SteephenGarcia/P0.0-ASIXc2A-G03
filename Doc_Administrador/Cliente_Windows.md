# Client Windows

## 1. Funció del client Windows

El client Windows forma part de la Intranet del projecte **P.0-ASIXc2A-G03**.

La seva funció principal és actuar com a equip de proves per validar els serveis desplegats a la infraestructura.

S'ha utilitzat per comprovar:

- DHCP
- DNS
- routing
- accés a la DMZ
- accés a W-NCC
- autenticació web
- CRUD
- FTP
- NAT
- sortida a Internet

---

## 2. Xarxa utilitzada

El client Windows està connectat a la xarxa:

```text
192.168.20.0/24
```

Aquesta xarxa correspon a la Intranet.

Durant les proves, el client va obtenir la configuració següent:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

La configuració es rep mitjançant DHCP.

---

## 3. DHCP

El client Windows no utilitza una configuració manual per a la seva interfície principal de la Intranet.

R-NCC proporciona automàticament:

- direcció IP
- màscara
- gateway
- DNS
- domini intern

Durant les proves, R-NCC va assignar:

```text
192.168.20.100
```

El servidor DHCP és:

```text
192.168.20.1
```

---

## 4. Comprovació de la configuració

A Windows es pot comprovar la configuració amb:

```powershell
ipconfig /all
```

La informació important que s'ha de validar és:

```text
IPv4 Address: 192.168.20.100
Default Gateway: 192.168.20.1
DNS Server: 192.168.20.1
```

Això confirma que el client està utilitzant R-NCC com a punt central de xarxa.

---

## 5. Interfaces de xarxa

Durant les proves, Windows disposava de diverses interfícies.

Entre elles:

- interfície de la Intranet
- interfície de WireGuard
- interfície Default d'IsardVDI

La interfície important per al projecte és la de la Intranet.

La configuració utilitzada va ser:

```text
192.168.20.100/24
```

amb gateway:

```text
192.168.20.1
```

---

## 6. Problema de múltiples gateways

Durant les proves es va detectar que Windows tenia dues rutes per defecte.

Una sortia directament per la xarxa Default d'IsardVDI.

L'altra utilitzava R-NCC.

Això provocava que una prova d'Internet no demostrés necessàriament que el trànsit estava passant per R-NCC.

Per fer una prova correcta es va eliminar temporalment la ruta directa.

---

## 7. Eliminació de la ruta directa

Es va executar:

```powershell
route delete 0.0.0.0 mask 0.0.0.0 192.168.120.1
```

Després d'això, la ruta per defecte va quedar apuntant a:

```text
192.168.20.1
```

Això va obligar Windows a utilitzar R-NCC com a gateway real.

---

## 8. Comprovació de rutes

La taula de rutes es pot consultar amb:

```powershell
route print -4
```

Després de corregir la configuració, la ruta principal era similar a:

```text
0.0.0.0
0.0.0.0
192.168.20.1
192.168.20.100
```

Això indica que el trànsit de sortida passa per R-NCC.

---

## 9. Ruta cap a la DMZ

Per garantir l'accés als servidors de la DMZ es va utilitzar una ruta cap a:

```text
192.168.10.0/24
```

Gateway:

```text
192.168.20.1
```

Aquesta ruta permet accedir a:

```text
W-NCC -> 192.168.10.10
F-NCC -> 192.168.10.20
```

---

## 10. Prova de connectivitat amb R-NCC

El client pot comprovar la comunicació amb el gateway mitjançant:

```powershell
ping 192.168.20.1
```

Una resposta correcta demostra que existeix connectivitat dins de la Intranet.

---

## 11. Prova de connectivitat amb W-NCC

El servidor web està situat a:

```text
192.168.10.10
```

Es pot comprovar mitjançant:

```powershell
ping 192.168.10.10
```

També es pot provar el port HTTP:

```powershell
Test-NetConnection 192.168.10.10 -Port 80
```

El resultat esperat és:

```text
TcpTestSucceeded : True
```

---

## 12. Accés a l'aplicació web

Des del navegador de Windows es pot accedir a:

```text
http://192.168.10.10/
```

o directament a l'aplicació.

El client s'ha utilitzat per validar:

- pantalla de login
- autenticació
- navegació
- rols
- CRUD
- protecció de rutes

---

## 13. Usuari lector

Des de Windows es va provar l'usuari:

```text
bchecker
```

Rol:

```text
lector
```

Aquest usuari pot:

- iniciar sessió
- consultar equipaments
- navegar per les pàgines

No pot:

- crear
- editar
- eliminar

---

## 14. Validació del bloqueig administratiu

Una de les proves més importants va consistir a intentar accedir directament a una ruta administrativa amb l'usuari lector.

Per exemple:

```text
/equipaments/delete.php?id=756
```

La resposta obtinguda va ser:

```text
Acceso denegado. Se requieren permisos de administrador.
```

amb codi HTTP:

```text
403
```

Això demostra que el sistema de permisos no depèn només de la interfície gràfica.

---

## 15. Usuari administrador

També es va provar l'usuari:

```text
web_admin
```

Rol:

```text
admin
```

Aquest usuari pot:

- consultar dades
- crear registres
- editar registres
- eliminar registres

---

## 16. Proves CRUD

Windows s'ha utilitzat per validar les operacions de l'aplicació.

### CREATE

L'administrador pot afegir un nou equipament.

### READ

Els usuaris autenticats poden consultar els equipaments.

### UPDATE

L'administrador pot modificar registres existents.

### DELETE

L'administrador pot eliminar registres.

Aquestes proves confirmen el funcionament de la capa web connectada amb B-NCC.

---

## 17. DNS

Windows utilitza R-NCC com a servidor DNS.

Servidor configurat:

```text
192.168.20.1
```

Domini intern:

```text
asix3jyt.local
```

Els noms principals són:

```text
r-ncc.asix3jyt.local
w-ncc.asix3jyt.local
f-ncc.asix3jyt.local
```

---

## 18. Proves DNS

Es pot utilitzar:

```powershell
nslookup w-ncc.asix3jyt.local
```

Resultat esperat:

```text
192.168.10.10
```

També:

```powershell
nslookup f-ncc.asix3jyt.local
```

Resultat esperat:

```text
192.168.10.20
```

Aquestes proves demostren que Windows està utilitzant el DNS intern.

---

## 19. FTP

Windows també s'ha utilitzat per validar F-NCC.

Servidor FTP:

```text
192.168.10.20
```

Primer es va comprovar el port:

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

El resultat va ser correcte.

---

## 20. Connexió FTP

La connexió es va iniciar amb:

```powershell
ftp 192.168.10.20
```

Després d'autenticar-se es va comprovar el llistat de fitxers.

```text
ls
```

---

## 21. Descàrrega FTP

Es va utilitzar:

```text
get prueba_ftp.txt
```

La transferència es va completar correctament.

Posteriorment es va comprovar que l'arxiu existia al client Windows.

El contingut del fitxer era:

```text
Prueba FTP Proyecto ASICX2
```

---

## 22. Pujada FTP

També es va validar la transferència en sentit contrari.

Fitxer:

```text
subida_windows.txt
```

Comanda FTP:

```text
put subida_windows.txt
```

La pujada es va completar correctament.

Això confirma transferència bidireccional.

---

## 23. NAT

Windows també es va utilitzar per comprovar el NAT de R-NCC.

Després d'eliminar la ruta directa d'IsardVDI, el client només disposava de:

```text
Gateway -> 192.168.20.1
```

Es va executar:

```powershell
ping 8.8.8.8
```

La prova va funcionar.

Posteriorment, a R-NCC es van observar comptadors a la regla MASQUERADE.

Això demostra el recorregut:

```text
Windows
192.168.20.100
      |
      |
    R-NCC
      |
      |
     NAT
      |
      |
   Internet
```

---

## 24. Importància de la prova NAT

Un simple `ping 8.8.8.8` no era suficient mentre Windows disposava d'una segona sortida directa a Internet.

Per aquest motiu es va eliminar la ruta alternativa abans de fer la prova.

Aquesta comprovació permet assegurar que el trànsit estava utilitzant realment la infraestructura del projecte.

---

## 25. Dependències

El client Windows depèn de R-NCC per:

- DHCP
- DNS
- gateway
- routing cap a la DMZ
- NAT
- accés a Internet

També depèn de:

### W-NCC

Per utilitzar l'aplicació web.

### F-NCC

Per utilitzar FTP.

---

## 26. Riscos

### DHCP incorrecte

El client pot rebre una configuració de xarxa incorrecta o no rebre cap IP.

### DNS incorrecte

El client pot accedir als serveis per IP però no per nom.

### Ruta per defecte incorrecta

El trànsit pot evitar R-NCC i invalidar les proves de NAT.

### Error de routing

El client pot perdre accés a la DMZ.

### Error de firewall

Els ports web o FTP poden quedar bloquejats.

---

## 27. Comandes de diagnòstic

### Configuració IP

```powershell
ipconfig /all
```

### Rutes

```powershell
route print -4
```

### Gateway

```powershell
ping 192.168.20.1
```

### DNS

```powershell
nslookup w-ncc.asix3jyt.local
```

### HTTP

```powershell
Test-NetConnection 192.168.10.10 -Port 80
```

### FTP

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

### Internet

```powershell
ping 8.8.8.8
```

---

## 28. Criteris de validació

El client Windows es considera correctament integrat quan:

- [x] obté una IP per DHCP
- [x] utilitza `192.168.20.1` com a gateway
- [x] utilitza R-NCC com a DNS
- [x] pot comunicar-se amb R-NCC
- [x] pot accedir a la DMZ
- [x] pot accedir a W-NCC
- [x] pot utilitzar l'aplicació web
- [x] pot iniciar sessió com a lector
- [x] el lector queda bloquejat en rutes administratives
- [x] l'administrador pot utilitzar el CRUD
- [x] pot accedir a F-NCC
- [x] pot descarregar fitxers per FTP
- [x] pot pujar fitxers per FTP
- [x] resol noms DNS interns
- [x] pot sortir a Internet mitjançant NAT de R-NCC

---

## 29. Evidències pendents

Les captures reals s'afegiran en la fase final.

Les principals evidències recomanades són:

📸 `ipconfig /all`

📸 `route print -4`

📸 `nslookup w-ncc.asix3jyt.local`

📸 `Test-NetConnection 192.168.10.10 -Port 80`

📸 `Test-NetConnection 192.168.10.20 -Port 21`

📸 login com a lector

📸 error 403 amb el lector

📸 login com a administrador

📸 prova de CREATE

📸 prova de UPDATE

📸 prova de DELETE

📸 `get prueba_ftp.txt`

📸 `put subida_windows.txt`

📸 `ping 8.8.8.8` utilitzant R-NCC com a gateway

---

## 30. Conclusió

El client Windows s'ha utilitzat com a principal punt de validació de la infraestructura.

Des d'aquest equip s'han comprovat els serveis més importants del projecte.

Les proves de DHCP, DNS, web, rols, CRUD, FTP i NAT demostren que el client pot utilitzar correctament els serveis desplegats a través de R-NCC.
