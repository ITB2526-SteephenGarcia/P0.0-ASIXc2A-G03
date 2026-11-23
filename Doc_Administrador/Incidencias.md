# Incidències del projecte

## 1. Objectiu

Aquest document recull les principals incidències tècniques detectades durant el desenvolupament del projecte **P.0-ASIXc2A-G03**.

L'objectiu és deixar constància de:

1. quin problema es va detectar
2. quin símptoma presentava
3. quina causa tenia
4. quina solució es va aplicar
5. com es va verificar que el problema havia quedat resolt

Aquest registre és útil tant per documentar el procés real del projecte com per facilitar la resolució de problemes similars en el futur.

---

# 2. Incidència 1. NGINX carregava una configuració duplicada

## Símptoma

NGINX mostrava avisos relacionats amb una configuració duplicada.

La configuració del servidor no quedava neta encara que el fitxer principal fos correcte.

## Causa

Dins de:

```text
/etc/nginx/sites-enabled/
```

hi havia un fitxer de còpia anomenat:

```text
default.backup
```

NGINX carregava aquest fitxer igual que la configuració principal.

## Solució

Es va moure el fitxer fora de `sites-enabled`.

```bash
sudo mv /etc/nginx/sites-enabled/default.backup /etc/nginx/default.backup
```

## Verificació

Es va executar:

```bash
sudo nginx -t
```

La configuració va quedar validada correctament.

---

# 3. Incidència 2. PHP no es processava correctament

## Símptoma

La web no interpretava correctament els fitxers PHP.

## Causa

NGINX necessitava estar configurat per enviar els fitxers PHP cap a PHP-FPM.

## Solució

Es va revisar la configuració del servidor web i la integració amb PHP-FPM.

També es va comprovar que el servei:

```text
php8.1-fpm
```

estigués actiu.

## Verificació

Es va validar la configuració amb:

```bash
sudo nginx -t
```

i es va comprovar l'estat de PHP-FPM:

```bash
sudo systemctl status php8.1-fpm
```

Finalment, els fitxers PHP es van executar correctament.

---

# 4. Incidència 3. Hash de contrasenya incorrecte

## Símptoma

L'usuari:

```text
bchecker
```

no podia iniciar sessió correctament encara que s'introduís la contrasenya esperada.

## Causa

El valor emmagatzemat a:

```text
password_hash
```

no corresponia correctament a la contrasenya configurada.

## Solució

Es va generar un hash bcrypt correcte.

Per seguretat, la contrasenya real no es publica a la documentació.

Es va generar un nou hash bcrypt corresponent a la contrasenya configurada per a l'usuari.

## Verificació

Es va comprovar mitjançant:

```php
password_verify()
```

que la contrasenya coincidís amb el hash.

El resultat va ser correcte.

Després d'això, el login va funcionar.

---

# 5. Incidència 4. Diferència entre usuaris web i usuaris MySQL

## Símptoma

Durant la configuració podia existir confusió entre:

```text
bchecker
web_admin
```

com a usuaris de l'aplicació i com a comptes MySQL.

## Causa

Els mateixos noms es van utilitzar en dos sistemes d'autenticació diferents.

## Solució

Es va documentar clarament la separació.

### Usuaris web

S'emmagatzemen a:

```text
equipaments.usuarios
```

S'utilitzen per:

- login
- sessions
- rols

### Usuaris MySQL

S'utilitzen per:

- connexions PHP
- permisos sobre la base de dades

## Verificació

L'aplicació pot autenticar un usuari web i, de manera independent, utilitzar un compte MySQL per accedir a les dades.

---

# 6. Incidència 5. B-NCC tenia una interfície exterior innecessària

## Símptoma

B-NCC disposava inicialment d'una interfície connectada a la xarxa Default d'IsardVDI.

Això donava al servidor de base de dades més connectivitat de la necessària.

## Causa

La màquina s'havia creat amb una interfície exterior per defecte.

## Solució

Es va eliminar la interfície Default de B-NCC.

La configuració final manté:

```text
WireGuard
Backend
```

## Verificació

Després del canvi, B-NCC només disposava de la xarxa backend del projecte:

```text
192.168.30.10/24
```

Això va millorar l'aïllament del servidor.

---

# 7. Incidència 6. Canvi de nom de les interfícies de B-NCC

## Símptoma

Després d'eliminar una interfície de xarxa, la configuració de Netplan deixava de coincidir amb el nom real de la interfície backend.

## Causa

Linux va renumerar les interfícies.

Abans, la xarxa backend utilitzava una interfície diferent.

Després del canvi, la configuració final va quedar:

```text
enp1s0 -> WireGuard
enp2s0 -> Backend
```

## Solució

Es va modificar Netplan perquè utilitzés:

```text
enp2s0
```

amb:

```text
192.168.30.10/24
```

## Verificació

Es va executar:

```bash
sudo netplan apply
```

i després:

```bash
ip a
ip route
```

La IP backend va aparèixer correctament a `enp2s0`.

---

# 8. Incidència 7. Avís d'Open vSwitch en aplicar Netplan

## Símptoma

En executar:

```bash
sudo netplan apply
```

va aparèixer un avís relacionat amb:

```text
ovsdb-server.service is not running
```

## Causa

Netplan va intentar comprovar components d'Open vSwitch encara que no fossin necessaris per a la configuració utilitzada.

## Solució

Es va comprovar la configuració real de xarxa després d'aplicar Netplan.

## Verificació

Malgrat l'avís:

```bash
ip a
```

mostrava:

```text
192.168.30.10/24
```

a la interfície correcta.

Per tant, la configuració de xarxa s'havia aplicat.

---

# 9. Incidència 8. SSH de B-NCC estava massa obert

## Símptoma

UFW permetia inicialment:

```text
22/tcp
```

des de qualsevol origen.

També existia una regla IPv6 oberta.

## Causa

La configuració inicial d'SSH era genèrica.

## Solució

Es va crear una regla específica:

```bash
sudo ufw allow from 192.168.30.1 to any port 22 proto tcp
```

Posteriorment es van eliminar les regles obertes.

## Verificació

La configuració final de B-NCC permet:

```text
22/tcp des de 192.168.30.1
3306/tcp des de 192.168.30.1
```

Això limita l'administració i MySQL a W-NCC.

---

# 10. Incidència 9. MySQL rebutjava una connexió des de B-NCC

## Símptoma

En provar el compte:

```text
bchecker
```

des de B-NCC, MySQL retornava:

```text
ERROR 1130
Host 'B-NCC' is not allowed to connect to this MySQL server
```

## Causa

El compte estava configurat correctament per acceptar connexions només des de:

```text
192.168.30.1
```

## Solució

No es va modificar la configuració.

Aquest comportament era l'esperat.

## Verificació

Des de W-NCC:

```bash
mysql -h 192.168.30.10 -u bchecker -p
```

funcionava correctament.

Aquesta incidència es va convertir en una prova de seguretat.

---

# 11. Incidència 10. El client lector podia intentar entrar per URL directa

## Símptoma

Encara que els botons administratius no fossin visibles, un usuari podia intentar escriure manualment una URL com:

```text
/equipaments/delete.php?id=756
```

## Causa

Ocultar botons no és suficient com a control de seguretat.

## Solució

Les pàgines administratives utilitzen:

```php
requireAdmin()
```

## Verificació

Amb l'usuari lector es va obtenir:

```text
Acceso denegado. Se requieren permisos de administrador.
```

Codi:

```text
HTTP 403
```

Això confirma que la protecció es realitza al servidor.

---

# 12. Incidència 11. Diferència entre 889 registres i 622 equipaments

## Símptoma

MySQL mostrava:

```text
889
```

registres.

La web mostrava aproximadament:

```text
622
```

equipaments.

## Causa

La taula conté diverses files que poden compartir el mateix:

```text
register_id
```

La web agrupa els registres mitjançant:

```sql
COUNT(DISTINCT register_id)
```

## Solució

No es va eliminar cap registre.

Es va documentar que la diferència és conseqüència de l'agrupament de la vista.

## Verificació

MySQL continua mostrant 889 files.

La web mostra els equipaments agrupats.

---

# 13. Incidència 12. NAT no estava configurat a R-NCC

## Símptoma

La taula NAT de `iptables` no contenia regles de `POSTROUTING`.

## Causa

Encara no s'havien creat les regles MASQUERADE.

## Solució

Es van afegir:

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.20.0/24 -o enp1s0 -j MASQUERADE
```

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp1s0 -j MASQUERADE
```

## Verificació

Es va executar:

```bash
sudo iptables -t nat -L POSTROUTING -n -v
```

Les dues regles van aparèixer correctament.

---

# 14. Incidència 13. Les regles NAT no eren persistents

## Símptoma

Les regles creades directament amb `iptables` podien desaparèixer després d'una recàrrega o reinici.

## Causa

Les regles s'havien creat en temps d'execució.

## Solució

Es van afegir a:

```text
/etc/ufw/before.rules
```

Configuració:

```text
*nat
:POSTROUTING ACCEPT [0:0]

-A POSTROUTING -s 192.168.20.0/24 -o enp1s0 -j MASQUERADE
-A POSTROUTING -s 192.168.10.0/24 -o enp1s0 -j MASQUERADE

COMMIT
```

## Verificació

Es va recarregar UFW:

```bash
sudo ufw disable
sudo ufw enable
```

Posteriorment:

```bash
sudo iptables -t nat -L POSTROUTING -n -v
```

continuava mostrant les regles.

---

# 15. Incidència 14. Windows tenia dues rutes per defecte

## Símptoma

Windows disposava simultàniament de:

```text
Gateway 192.168.120.1
```

i:

```text
Gateway 192.168.20.1
```

Això impedia saber si el trànsit d'Internet passava realment per R-NCC.

## Causa

La màquina Windows mantenia una interfície connectada a la xarxa Default d'IsardVDI.

## Solució

Per fer la prova de NAT es va eliminar temporalment la ruta directa.

```powershell
route delete 0.0.0.0 mask 0.0.0.0 192.168.120.1
```

## Verificació

Amb:

```powershell
route print -4
```

va quedar com a ruta per defecte:

```text
192.168.20.1
```

Després:

```powershell
ping 8.8.8.8
```

va funcionar.

Els comptadors NAT de R-NCC també van augmentar.

---

# 16. Incidència 15. F-NCC no podia respondre correctament a la Intranet

## Símptoma

La connexió FTP podia arribar a F-NCC, però existien problemes amb la comunicació de retorn.

## Causa

F-NCC no disposava d'una ruta correcta cap a:

```text
192.168.20.0/24
```

## Solució

Es va afegir:

```bash
sudo ip route add 192.168.20.0/24 via 192.168.10.1 dev enp3s0
```

## Verificació

Després del canvi, des de Windows:

```powershell
ftp 192.168.10.20
```

va funcionar.

També es van poder executar:

```text
ls
get
put
```

---

# 17. Incidència 16. La ruta de F-NCC no era persistent

## Símptoma

Una ruta creada amb:

```bash
ip route add
```

es pot perdre després d'un reinici.

## Causa

La ruta s'havia afegit només a la taula de routing activa.

## Solució

Es va configurar mitjançant NetworkManager:

```bash
sudo nmcli connection modify "Conexión cableada 3" +ipv4.routes "192.168.20.0/24 192.168.10.1"
```

Després:

```bash
sudo nmcli device reapply enp3s0
```

## Verificació

La ruta es va mantenir configurada a la connexió de xarxa.

---

# 18. Incidència 17. UFW de F-NCC estava inactiu

## Símptoma

En revisar F-NCC es va observar que:

```text
UFW
```

no estava actiu.

## Causa

La protecció principal del trànsit FTP s'havia configurat a R-NCC.

## Solució actual

S'ha documentat que el control principal es realitza des del router.

Abans d'activar UFW local a F-NCC s'han de revisar correctament:

- port 21
- connexions FTP
- comportament del mode de transferència

per evitar bloquejar un servei que actualment funciona.

## Verificació

R-NCC controla l'accés des de la Intranet i les proves FTP funcionen.

---

# 19. Incidència 18. Prova FTP incompleta amb només el port 21

## Símptoma

Un resultat:

```text
TcpTestSucceeded : True
```

només demostrava que el port 21 era accessible.

## Causa

Comprovar un port no demostra que la funcionalitat completa del servei funcioni.

## Solució

Es van realitzar proves reals:

```text
login
ls
get prueba_ftp.txt
put subida_windows.txt
```

## Verificació

Es va descarregar correctament:

```text
prueba_ftp.txt
```

i es va pujar:

```text
subida_windows.txt
```

Això valida el servei de manera funcional.

---

# 20. Incidència 19. Necessitat de separar compte lector i compte administratiu

## Símptoma

Utilitzar un únic compte MySQL amb permisos CRUD per a tota l'aplicació donaria més privilegis dels necessaris.

## Causa

La lectura normal de dades no necessita permisos d'escriptura.

## Solució

Es van separar els comptes.

### Lectura

```text
bchecker
```

Permís:

```text
SELECT
```

### Administració

```text
web_admin
```

Permisos:

```text
SELECT
INSERT
UPDATE
DELETE
```

## Verificació

La lectura normal funciona amb `bchecker`.

Les operacions CRUD administratives utilitzen `web_admin`.

---

# 21. Incidència 20. Necessitat de protegir les contrasenyes web

## Símptoma

Guardar contrasenyes directament a la base de dades seria una mala pràctica de seguretat.

## Solució

Es va utilitzar:

```php
password_hash()
```

per generar hashes.

La validació es realitza mitjançant:

```php
password_verify()
```

## Verificació

Els valors emmagatzemats a:

```text
password_hash
```

són hashes bcrypt i no contrasenyes en text pla.

---

# 22. Resum de les incidències

| Incidència | Component | Estat |
|---|---|---|
| Configuració NGINX duplicada | W-NCC | ✅ Resolta |
| PHP no processat correctament | W-NCC | ✅ Resolta |
| Hash incorrecte | Aplicació | ✅ Resolta |
| Confusió usuaris web/MySQL | Aplicació / DB | ✅ Documentada |
| Interfície exterior de B-NCC | B-NCC | ✅ Eliminada |
| Renumeració d'interfícies | B-NCC | ✅ Resolta |
| Avís Open vSwitch | B-NCC | ✅ Verificat |
| SSH massa obert | B-NCC | ✅ Resolt |
| MySQL rebutja origen incorrecte | B-NCC | ✅ Comportament esperat |
| Accés directe del lector | Web | ✅ Bloquejat |
| 889 vs 622 | Base de dades | ✅ Explicat |
| NAT inexistent | R-NCC | ✅ Resolt |
| NAT no persistent | R-NCC | ✅ Resolt |
| Dos gateways a Windows | Windows | ✅ Corregit per a la prova |
| Ruta de retorn FTP | F-NCC | ✅ Resolta |
| Ruta FTP no persistent | F-NCC | ✅ Resolta |
| UFW F-NCC inactiu | F-NCC | ⚠️ Documentat |
| Prova FTP insuficient | FTP | ✅ Ampliada |
| Privilegis MySQL | B-NCC | ✅ Separats |
| Hash de contrasenyes | Aplicació | ✅ Implementat |

---

# 23. Metodologia de resolució

Durant el projecte s'ha seguit un procés similar per resoldre incidències.

```text
Problema
   |
   v
Observació del símptoma
   |
   v
Comprovació de xarxa o servei
   |
   v
Revisió de configuració
   |
   v
Aplicació de la solució
   |
   v
Nova prova
   |
   v
Documentació
```

Aquest procés evita aplicar canvis sense verificar posteriorment el resultat.

---

# 24. Comandes utilitzades per al diagnòstic

Entre les comandes més utilitzades durant el projecte hi ha:

```bash
ip a
ip route
ping
ss -lntp
systemctl status
journalctl
ufw status
iptables
nginx -t
```

En Windows:

```powershell
ipconfig /all
route print -4
Test-NetConnection
ping
nslookup
```

En MySQL:

```sql
SHOW DATABASES;
SHOW GRANTS;
SELECT COUNT(*);
SELECT user, host FROM mysql.user;
```

---

# 25. Valor de les proves negatives

Algunes incidències han servit per comprovar que la seguretat funciona.

Exemples:

```text
ERROR 1130
```

des d'un origen MySQL no autoritzat.

I:

```text
HTTP 403
```

quan un lector intenta entrar a una funció administrativa.

Aquest tipus de prova és especialment útil perquè demostra que els accessos incorrectes també estan controlats.

---

# 26. Evidències pendents

Les captures reals es recopilaran en la fase final.

Les incidències que més interessa demostrar visualment són:

📸 error HTTP 403 del lector

📸 `ERROR 1130` de MySQL

📸 UFW final de B-NCC

📸 NAT amb comptadors

📸 rutes de Windows

📸 ruta de F-NCC cap a la Intranet

📸 FTP amb `get` i `put`

📸 validació de NGINX amb `nginx -t`

No és necessari incloure una captura de totes les incidències.

És preferible seleccionar les que mejor demuestren diagnóstico y solución.

---

# 27. Conclusió

Les incidències registrades formen part del procés real de desplegament.

Els problemes principals han estat relacionats amb:

- routing
- NAT
- interfaces
- NGINX
- MySQL
- permisos
- autenticació
- FTP
- firewall

La resolució d'aquestes incidències ha permès millorar progressivament la infraestructura.

Documentar tant els errors com les solucions facilita el manteniment futur i demostra que la configuració final és resultat d'un procés de proves i validació.
