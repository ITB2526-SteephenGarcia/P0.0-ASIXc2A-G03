# F-NCC

## 1. Función de F-NCC

F-NCC es el servidor FTP de la infraestructura del proyecto **P.0-ASIXc2A-G03**.

Su función es proporcionar un servicio de transferencia de archivos accesible desde los clientes de la Intranet.

F-NCC se encuentra dentro de la DMZ y utiliza la siguiente dirección:

```text
192.168.10.20/24
```

El acceso desde los clientes internos pasa a través de R-NCC.

---

## 2. Ubicación en la arquitectura

F-NCC pertenece a la red:

```text
192.168.10.0/24
```

Esta red corresponde a la DMZ.

El esquema de comunicación es:

```text
Cliente Windows / Linux
        |
        |
   192.168.20.0/24
        |
      R-NCC
        |
        |
   192.168.10.0/24
        |
      F-NCC
   192.168.10.20
```

---

## 3. Dirección IP

La dirección configurada en F-NCC es:

```text
192.168.10.20/24
```

El gateway utilizado para comunicarse con otras redes es R-NCC:

```text
192.168.10.1
```

---

## 4. Servicio FTP

F-NCC proporciona un servicio FTP.

Durante las pruebas, el banner del servidor mostró:

```text
F-NCC.asix3jyt.local FTP server
Version 6.4/OpenBSD/Linux-ftpd-0.17
```

El puerto principal utilizado por FTP es:

```text
21/tcp
```

---

## 5. Acceso desde la Intranet

Los clientes de la Intranet no están conectados directamente a F-NCC.

El tráfico sigue este recorrido:

```text
Windows
192.168.20.100
        |
        |
      R-NCC
192.168.20.1 / 192.168.10.1
        |
        |
      F-NCC
192.168.10.20
```

R-NCC controla el tráfico entre ambas redes.

---

## 6. Ruta de retorno

Durante la configuración se detectó que F-NCC necesitaba una ruta para poder responder correctamente a los clientes de la Intranet.

La red de los clientes es:

```text
192.168.20.0/24
```

La ruta añadida fue:

```bash
sudo ip route add 192.168.20.0/24 via 192.168.10.1 dev enp3s0
```

Esta ruta indica que cualquier tráfico destinado a la Intranet debe enviarse hacia R-NCC.

---

## 7. Persistencia de la ruta

Para evitar perder la ruta después de reiniciar la máquina, se configuró de forma persistente mediante NetworkManager.

Se utilizó:

```bash
sudo nmcli connection modify "Conexión cableada 3" +ipv4.routes "192.168.20.0/24 192.168.10.1"
```

Después se aplicó el cambio:

```bash
sudo nmcli device reapply enp3s0
```

Esto permite mantener la conectividad con la Intranet después de reiniciar.

---

## 8. Comprobación de rutas

La configuración se puede validar mediante:

```bash
ip route
```

Debe existir una ruta similar a:

```text
192.168.20.0/24 via 192.168.10.1
```

Esta ruta es necesaria para que las respuestas lleguen correctamente a los clientes internos.

---

## 9. Resolución DNS

F-NCC dispone de un registro DNS interno.

Nombre:

```text
f-ncc.asix3jyt.local
```

Dirección:

```text
192.168.10.20
```

Este registro permite que los clientes puedan localizar el servidor mediante nombre en lugar de utilizar únicamente la dirección IP.

---

## 10. Comprobación del puerto FTP

Desde Windows se comprobó que el puerto 21 era accesible.

Comando utilizado:

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

Resultado obtenido:

```text
TcpTestSucceeded : True
```

Esto demuestra que:

- el servicio está escuchando
- R-NCC permite el tráfico
- existe conectividad entre Intranet y DMZ

---

## 11. Conexión FTP desde Windows

Desde el cliente Windows se utilizó:

```powershell
ftp 192.168.10.20
```

La conexión al servidor fue correcta.

Se utilizó una cuenta válida del sistema para realizar las pruebas.

Una vez autenticado, el cliente pudo ejecutar comandos FTP.

---

## 12. Listado de archivos

Dentro de la sesión FTP se ejecutó:

```text
ls
```

El servidor devolvió correctamente el listado de archivos.

Esto demuestra que:

- la autenticación funciona
- existe comunicación bidireccional
- el cliente puede consultar el contenido remoto

---

## 13. Descarga de archivos

Para comprobar la descarga se utilizó un archivo de prueba:

```text
prueba_ftp.txt
```

Desde Windows se ejecutó:

```text
get prueba_ftp.txt
```

La transferencia se completó correctamente.

Después se comprobó la existencia del archivo en Windows.

También se verificó su contenido.

El archivo contenía:

```text
Prueba FTP Proyecto ASICX2
```

---

## 14. Subida de archivos

También se comprobó la transferencia en sentido contrario.

Se creó un archivo desde Windows:

```text
subida_windows.txt
```

Posteriormente se ejecutó:

```text
put subida_windows.txt
```

La transferencia se completó correctamente.

Esto demuestra que el cliente puede tanto descargar como subir archivos.

---

## 15. Validación bidireccional

Las pruebas realizadas permiten confirmar los dos sentidos de transferencia.

```text
F-NCC -> Windows
       GET
       ✅

Windows -> F-NCC
       PUT
       ✅
```

Esto es importante porque no basta con comprobar únicamente la conexión al puerto 21.

La transferencia real demuestra que el servicio funciona correctamente.

---

## 16. Reglas de R-NCC

R-NCC permite tráfico FTP desde la Intranet hacia F-NCC.

La comunicación principal utiliza:

```text
192.168.20.0/24
        |
        |
        v
192.168.10.20:21
```

También se configuró forwarding relacionado con el tráfico FTP de retorno.

Esto permite mantener una comunicación funcional entre ambas redes.

---

## 17. Seguridad

F-NCC está situado en la DMZ.

Esto evita colocar el servidor FTP directamente dentro de la red de clientes.

La separación permite que R-NCC controle qué tráfico puede llegar hasta F-NCC.

El acceso desde la Intranet se limita al tráfico necesario para el servicio.

---

## 18. Firewall local

Durante las comprobaciones realizadas, UFW en F-NCC aparecía inicialmente inactivo.

La principal protección del tráfico entre Intranet y F-NCC se realiza actualmente desde R-NCC mediante reglas de forwarding.

Esta situación debe quedar documentada para diferenciar claramente entre:

- firewall del router
- firewall local del servidor

Si posteriormente se activa UFW en F-NCC, será necesario permitir correctamente el tráfico FTP y comprobar que no se interrumpen las transferencias.

---

## 19. Dependencias

F-NCC depende principalmente de:

### R-NCC

R-NCC permite la comunicación entre la Intranet y la DMZ.

Si R-NCC falla, los clientes internos no podrán acceder a F-NCC.

### Routing

La ruta hacia:

```text
192.168.20.0/24
```

es necesaria para que F-NCC responda correctamente a los clientes.

### Servicio FTP

Si el servicio deja de escuchar en el puerto 21, las conexiones FTP fallarán.

---

## 20. Riesgos

### Error en la ruta de retorno

El cliente puede iniciar una conexión, pero las respuestas pueden no volver correctamente.

### Error en R-NCC

El tráfico entre Intranet y DMZ puede quedar bloqueado.

### Servicio FTP detenido

El puerto 21 dejará de responder.

### Firewall incorrecto

Una regla demasiado restrictiva puede bloquear las transferencias.

Una regla demasiado abierta puede exponer servicios innecesarios.

---

## 21. Diagnóstico

### Comprobar interfaces

```bash
ip a
```

### Comprobar rutas

```bash
ip route
```

### Comprobar puerto FTP

```bash
sudo ss -lntp | grep :21
```

### Comprobar conectividad con R-NCC

```bash
ping 192.168.10.1
```

### Comprobar ruta hacia la Intranet

```bash
ip route | grep 192.168.20
```

---

## 22. Diagnóstico desde Windows

### Comprobar puerto

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

### Iniciar FTP

```powershell
ftp 192.168.10.20
```

### Listar archivos

```text
ls
```

### Descargar

```text
get prueba_ftp.txt
```

### Subir

```text
put subida_windows.txt
```

---

## 23. Pruebas realizadas

Las pruebas completadas son:

- [x] conexión al puerto 21
- [x] autenticación FTP
- [x] listado de archivos
- [x] descarga mediante `get`
- [x] comprobación del archivo descargado
- [x] subida mediante `put`
- [x] comunicación Intranet → DMZ
- [x] ruta de retorno configurada
- [x] persistencia de la ruta

---

## 24. Criterios de validación

F-NCC se considera funcional cuando:

- [x] tiene la dirección `192.168.10.20`
- [x] pertenece a la DMZ
- [x] tiene ruta hacia la Intranet
- [x] la ruta es persistente
- [x] el puerto 21 responde
- [x] los clientes pueden autenticarse
- [x] se pueden listar archivos
- [x] se pueden descargar archivos
- [x] se pueden subir archivos

---

## 25. Evidencias pendientes

Las capturas reales se añadirán en la fase final.

Las evidencias recomendadas son:

📸 `ip route` mostrando la ruta hacia `192.168.20.0/24`

📸 `ss -lntp | grep :21`

📸 `Test-NetConnection 192.168.10.20 -Port 21`

📸 conexión FTP iniciada

📸 resultado de `ls`

📸 descarga de `prueba_ftp.txt`

📸 comprobación del contenido del archivo

📸 subida de `subida_windows.txt`

Estas capturas permitirán demostrar que el FTP no solo responde, sino que permite transferencias reales en ambos sentidos.

---

## 26. Conclusión

F-NCC proporciona el servicio FTP de la infraestructura.

Está situado en la DMZ y recibe conexiones desde los clientes de la Intranet mediante R-NCC.

La configuración de routing permite mantener comunicación bidireccional.

Las pruebas de conexión, listado, descarga y subida confirman que el servicio funciona correctamente.

El uso de una red separada para los servidores permite mantener una arquitectura más ordenada y controlada que si el servicio FTP estuviera situado directamente dentro de la Intranet.
