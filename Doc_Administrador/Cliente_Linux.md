# Client Linux

## 1. Funció del client Linux

El client Linux forma part de la Intranet del projecte **P.0-ASIXc2A-G03**.

La seva funció és actuar com a segon equip de validació de la infraestructura i permetre comprovar que els serveis desplegats no depenen únicament d'un client Windows.

Aquest equip s'utilitza principalment per validar:

- connectivitat de xarxa
- routing
- DNS
- accés a la DMZ
- accés al servidor web
- accés als serveis interns
- funcionament general de la Intranet

---

## 2. Xarxa utilitzada

El client Linux està connectat a:

```text
192.168.20.0/24
```

Aquesta xarxa correspon a la Intranet.

La porta d'enllaç de la xarxa és:

```text
192.168.20.1
```

corresponent a R-NCC.

---

## 3. Adreça IP

Durant el desplegament s'ha utilitzat una adreça dins de la xarxa:

```text
192.168.20.0/24
```

Una de les adreces utilitzades durant les proves va ser:

```text
192.168.20.20
```

L'adreça exacta pot variar segons la configuració final del client.

L'important és que el client:

- pertanyi a la Intranet
- utilitzi R-NCC com a gateway
- pugui accedir als serveis autoritzats

---

## 4. Esquema de comunicació

```text
Client Linux
192.168.20.0/24
      |
      |
    R-NCC
      |
      +----------> W-NCC
      |            192.168.10.10
      |
      +----------> F-NCC
                   192.168.10.20
```

El client Linux no accedeix directament a B-NCC.

La base de dades està separada en la xarxa backend privada.

---

## 5. Comprovació de la configuració de xarxa

Per veure les interfícies es pot utilitzar:

```bash
ip a
```

Per consultar les rutes:

```bash
ip route
```

La configuració ha de mostrar una adreça dins de:

```text
192.168.20.0/24
```

i una ruta cap al gateway:

```text
192.168.20.1
```

---

## 6. Comprovació del gateway

Per validar la comunicació amb R-NCC:

```bash
ping 192.168.20.1
```

Si la resposta és correcta, el client té connectivitat amb el router de la Intranet.

---

## 7. Accés a W-NCC

W-NCC està situat a:

```text
192.168.10.10
```

El client Linux ha de poder arribar-hi passant per R-NCC.

Prova de connectivitat:

```bash
ping 192.168.10.10
```

També es pot comprovar el servei web amb:

```bash
curl http://192.168.10.10
```

o mitjançant un navegador.

---

## 8. Accés a F-NCC

F-NCC està situat a:

```text
192.168.10.20
```

El client Linux ha de poder arribar al servidor FTP a través de R-NCC.

Es pot comprovar amb:

```bash
ping 192.168.10.20
```

Per validar el port FTP es pot utilitzar:

```bash
nc -zv 192.168.10.20 21
```

Si el port està disponible, la connexió TCP serà correcta.

---

## 9. DNS

El client Linux ha d'utilitzar R-NCC com a servidor DNS.

Servidor DNS:

```text
192.168.20.1
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

---

## 10. Proves DNS

Es poden utilitzar:

```bash
nslookup w-ncc.asix3jyt.local
```

o:

```bash
dig w-ncc.asix3jyt.local
```

Resultat esperat:

```text
192.168.10.10
```

Per F-NCC:

```bash
nslookup f-ncc.asix3jyt.local
```

Resultat esperat:

```text
192.168.10.20
```

---

## 11. Accés web mitjançant DNS

Una vegada validada la resolució DNS, el client pot accedir a la web utilitzant el nom intern.

Exemple:

```text
http://w-ncc.asix3jyt.local/
```

Això permet comprovar conjuntament:

- DNS
- routing
- HTTP
- disponibilitat de W-NCC

---

## 12. NAT i sortida a Internet

El client Linux també ha d'utilitzar R-NCC per sortir a Internet.

El recorregut és:

```text
Client Linux
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

Una prova bàsica es pot realitzar amb:

```bash
ping 8.8.8.8
```

Aquesta prova només és vàlida si el client utilitza realment:

```text
192.168.20.1
```

com a gateway principal.

---

## 13. Resolució externa

També es pot comprovar la resolución DNS externa.

Exemple:

```bash
ping google.com
```

Si funciona, demuestra que:

- existe conectividad exterior
- NAT funciona
- DNS externo también puede resolverse

---

## 14. Relación con R-NCC

El cliente Linux depende de R-NCC para:

- gateway
- routing
- DNS
- NAT
- acceso a la DMZ

Si R-NCC deja de funcionar, el cliente pierde gran parte de la conectividad de la infraestructura.

---

## 15. Relación con W-NCC

El cliente Linux utiliza W-NCC para acceder a la aplicación web.

Puede probarse mediante:

```bash
curl http://192.168.10.10
```

También puede utilizarse el nombre DNS:

```bash
curl http://w-ncc.asix3jyt.local
```

---

## 16. Relación con F-NCC

El cliente Linux puede utilizar el servicio FTP de F-NCC.

La conectividad se dirige hacia:

```text
192.168.10.20:21
```

a través de R-NCC.

---

## 17. Seguridad

El cliente Linux pertenece a la Intranet.

No debe disponer de acceso directo a B-NCC.

La base de datos se encuentra en:

```text
192.168.30.10
```

pero esta red no forma parte de la Intranet.

La comunicación con la base de datos debe realizarse siempre a través de W-NCC.

---

## 18. Riesgos

### Gateway incorrecto

Si el gateway no apunta a R-NCC, el cliente puede perder acceso a la DMZ y a Internet.

### DNS incorrecto

El cliente puede tener conectividad por IP pero no resolver nombres internos.

### Ruta incorrecta

Puede impedir la comunicación con W-NCC o F-NCC.

### Servicio de red detenido

Una interfaz deshabilitada puede dejar al equipo fuera de la Intranet.

---

## 19. Comandos de diagnóstico

### Interfaces

```bash
ip a
```

### Rutas

```bash
ip route
```

### Gateway

```bash
ping 192.168.20.1
```

### W-NCC

```bash
ping 192.168.10.10
```

### F-NCC

```bash
ping 192.168.10.20
```

### DNS

```bash
nslookup w-ncc.asix3jyt.local
```

### Web

```bash
curl http://192.168.10.10
```

### Puerto FTP

```bash
nc -zv 192.168.10.20 21
```

### Internet

```bash
ping 8.8.8.8
```

---

## 20. Criterios de validación

> ⚠️ La validación final de este cliente está pendiente de repetirse y documentarse con evidencias actuales. Por este motivo los siguientes puntos no se marcan como completados hasta disponer de las pruebas reales.

El cliente Linux se considera correctamente integrado cuando:

- [ ] pertenece a la red `192.168.20.0/24`
- [ ] puede comunicarse con R-NCC
- [ ] puede acceder a W-NCC
- [ ] puede acceder a F-NCC
- [ ] utiliza R-NCC como gateway
- [ ] puede resolver nombres internos
- [ ] puede acceder a la aplicación web
- [ ] no necesita acceso directo a B-NCC
- [ ] forma parte de la Intranet

---

## 21. Evidencias pendientes

Las capturas reales se añadirán en la fase final.

Las evidencias recomendadas son:

📸 `ip a`

📸 `ip route`

📸 `ping 192.168.20.1`

📸 `nslookup w-ncc.asix3jyt.local`

📸 `curl http://w-ncc.asix3jyt.local`

📸 prueba de acceso a F-NCC

📸 prueba de salida a Internet

Estas pruebas permitirán demostrar que el cliente Linux está correctamente integrado en la infraestructura.

---

## 22. Conclusión

El cliente Linux actúa como segundo punto de validación de la Intranet.

Permite comprobar que los servicios de red, DNS, routing y acceso a la DMZ funcionan también desde un sistema Linux.

Su integración refuerza la validación de la infraestructura y demuestra que los servicios no dependen de un único tipo de cliente.
