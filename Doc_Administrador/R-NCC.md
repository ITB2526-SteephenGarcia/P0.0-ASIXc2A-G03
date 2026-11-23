# R-NCC

## 1. Función de R-NCC

R-NCC es el router principal de la infraestructura del proyecto **P.0-ASIXc2A-G03**.

Su función es centralizar los servicios de red necesarios para comunicar la Intranet, la DMZ y la red exterior.

Los principales servicios configurados en R-NCC son:

- routing IPv4
- forwarding
- DHCP
- DNS
- NAT
- firewall UFW
- control del tráfico entre redes
- salida a Internet

R-NCC actúa como puerta de enlace para los clientes de la Intranet y para los servidores situados en la DMZ.

---

## 2. Redes conectadas

R-NCC está conectado a las siguientes redes:

| Red | Dirección de R-NCC | Función |
|---|---|---|
| Exterior | Asignada por IsardVDI | Salida a Internet |
| DMZ | 192.168.10.1/24 | Red de servidores |
| Intranet | 192.168.20.1/24 | Red de clientes |

La red backend `192.168.30.0/24` no está conectada directamente a R-NCC.

Esa red pertenece exclusivamente a la comunicación entre W-NCC y B-NCC.

---

## 3. Interfaces de red

Durante la configuración final se utilizaron principalmente las siguientes interfaces:

```text
enp1s0 -> Red exterior
enp3s0 -> Intranet
enp4s0 -> DMZ
```

Las direcciones configuradas son:

```text
Intranet -> 192.168.20.1/24
DMZ      -> 192.168.10.1/24
```

La interfaz exterior obtiene una dirección de la red proporcionada por IsardVDI.

---

## 4. Comprobación de direcciones

Para comprobar las interfaces configuradas se utiliza:

```bash
ip a
```

Este comando permite verificar:

- nombre de las interfaces
- direcciones IPv4
- estado de las interfaces
- máscaras de red

📸 **CAPTURA RECOMENDADA**

Ejecutar:

```bash
ip a
```

La captura debe mostrar claramente:

```text
192.168.20.1
192.168.10.1
```

y las interfaces correspondientes.

---

## 5. Tabla de rutas

La tabla de routing de R-NCC debe incluir las redes directamente conectadas y la ruta de salida a Internet.

Comando:

```bash
ip route
```

La configuración utilizada contiene rutas similares a:

```text
default via 192.168.120.1 dev enp1s0
192.168.10.0/24 dev enp4s0 src 192.168.10.1
192.168.20.0/24 dev enp3s0 src 192.168.20.1
```

La dirección exacta de la red exterior puede cambiar porque depende de IsardVDI.

Lo importante es que existan:

- una ruta por defecto hacia Internet
- una ruta para la DMZ
- una ruta para la Intranet

📸 **CAPTURA RECOMENDADA**

Ejecutar:

```bash
ip route
```

Guardar una captura donde se vean las rutas de:

```text
192.168.10.0/24
192.168.20.0/24
default
```

---

## 6. IPv4 forwarding

Para que R-NCC pueda actuar como router es necesario permitir el reenvío de paquetes IPv4.

La configuración activa se comprueba con:

```bash
sysctl net.ipv4.ip_forward
```

Resultado esperado:

```text
net.ipv4.ip_forward = 1
```

Esto permite que R-NCC reciba tráfico por una interfaz y lo reenvíe hacia otra.

📸 **CAPTURA RECOMENDADA**

Ejecutar:

```bash
sysctl net.ipv4.ip_forward
```

La captura debe mostrar:

```text
net.ipv4.ip_forward = 1
```

---

## 7. DHCP

R-NCC proporciona el servicio DHCP a los clientes de la Intranet.

El servicio utilizado es:

```text
isc-dhcp-server
```

Su función es proporcionar automáticamente:

- dirección IP
- máscara de red
- gateway
- servidor DNS
- dominio interno

Durante las pruebas, el cliente Windows obtuvo:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

---

## 8. Estado del servicio DHCP

El estado del servicio se comprueba con:

```bash
sudo systemctl status isc-dhcp-server
```

El servicio debe aparecer como:

```text
active (running)
```

También debe estar habilitado para arrancar automáticamente.

Puede comprobarse mediante:

```bash
sudo systemctl is-enabled isc-dhcp-server
```

Resultado esperado:

```text
enabled
```

📸 **CAPTURA RECOMENDADA**

Ejecutar:

```bash
sudo systemctl status isc-dhcp-server
```

La captura debe mostrar el servicio como:

```text
active (running)
```

---

## 9. Validación de DHCP

Los logs permiten comprobar el proceso real de concesión de direcciones.

Se puede utilizar:

```bash
sudo journalctl -u isc-dhcp-server
```

Durante las pruebas se registró una concesión al cliente Windows.

El proceso observado fue:

```text
DHCPDISCOVER
DHCPOFFER
DHCPREQUEST
DHCPACK
```

El cliente recibió:

```text
192.168.20.100
```

Esto demuestra que la asignación no se realizó manualmente.

📸 **CAPTURA RECOMENDADA**

Mostrar una parte del log donde aparezca:

```text
DHCPREQUEST
DHCPACK
192.168.20.100
```

Esta captura es especialmente útil como evidencia para la rúbrica.

---

## 10. DNS

R-NCC también proporciona resolución DNS interna.

El servicio utilizado es:

```text
BIND9
```

El dominio interno configurado es:

```text
asix3jyt.local
```

Los registros principales son:

```text
r-ncc.asix3jyt.local -> 192.168.20.1
w-ncc.asix3jyt.local -> 192.168.10.10
f-ncc.asix3jyt.local -> 192.168.10.20
```

---

## 11. Estado de BIND9

El servicio DNS se comprueba mediante:

```bash
sudo systemctl status bind9
```

Debe aparecer como:

```text
active (running)
```

También se puede comprobar el inicio automático:

```bash
sudo systemctl is-enabled bind9
```

Resultado esperado:

```text
enabled
```

---

## 12. Pruebas DNS

Desde un equipo cliente se pueden realizar consultas con:

```bash
nslookup w-ncc.asix3jyt.local
```

```bash
nslookup f-ncc.asix3jyt.local
```

También puede utilizarse:

```bash
dig w-ncc.asix3jyt.local
```

Resultados esperados:

```text
w-ncc.asix3jyt.local -> 192.168.10.10
f-ncc.asix3jyt.local -> 192.168.10.20
```

📸 **CAPTURA RECOMENDADA**

Desde Windows o Linux, mostrar una consulta DNS correcta.

Por ejemplo:

```powershell
nslookup w-ncc.asix3jyt.local
```

La captura debería mostrar:

```text
192.168.10.10
```

---

## 13. NAT

R-NCC proporciona acceso a Internet mediante NAT.

Las redes internas que utilizan NAT son:

```text
192.168.20.0/24
192.168.10.0/24
```

Se utilizan reglas `MASQUERADE` sobre la interfaz exterior.

Las reglas son equivalentes a:

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.20.0/24 -o enp1s0 -j MASQUERADE
```

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp1s0 -j MASQUERADE
```

---

## 14. Persistencia de NAT

Para evitar perder las reglas después de reiniciar UFW, las reglas NAT se añadieron a:

```text
/etc/ufw/before.rules
```

Configuración utilizada:

```text
*nat
:POSTROUTING ACCEPT [0:0]

-A POSTROUTING -s 192.168.20.0/24 -o enp1s0 -j MASQUERADE
-A POSTROUTING -s 192.168.10.0/24 -o enp1s0 -j MASQUERADE

COMMIT
```

Después de modificar el archivo se recargó UFW.

```bash
sudo ufw disable
sudo ufw enable
```

Tras la recarga, las reglas continuaron activas.

Esto confirma que la configuración es persistente.

---

## 15. Comprobación de NAT

Las reglas se comprueban mediante:

```bash
sudo iptables -t nat -L POSTROUTING -n -v
```

La salida debe mostrar las dos reglas MASQUERADE.

Además, los contadores permiten comprobar si existe tráfico real atravesando las reglas.

Durante la prueba del cliente Windows se observó tráfico en la regla correspondiente a:

```text
192.168.20.0/24
```

📸 **CAPTURA MUY RECOMENDADA**

Ejecutar:

```bash
sudo iptables -t nat -L POSTROUTING -n -v
```

La captura debería mostrar:

```text
192.168.20.0/24
192.168.10.0/24
MASQUERADE
```

y al menos un contador diferente de cero para la Intranet.

Esta captura demuestra que NAT está funcionando realmente.

---

## 16. Prueba real de salida a Internet

El cliente Windows tenía inicialmente más de una ruta por defecto.

Esto podía provocar que la salida a Internet no utilizara R-NCC.

Para realizar una prueba real se eliminó temporalmente la ruta directa hacia la red exterior.

En Windows se ejecutó:

```powershell
route delete 0.0.0.0 mask 0.0.0.0 192.168.120.1
```

Después de eliminar esa ruta, la ruta por defecto quedó:

```text
0.0.0.0 -> 192.168.20.1
```

Posteriormente se ejecutó:

```powershell
ping 8.8.8.8
```

La prueba fue correcta.

Después se comprobaron los contadores NAT en R-NCC y se observó tráfico.

Esto permite demostrar el recorrido:

```text
Windows
192.168.20.100
      |
      v
R-NCC
192.168.20.1
      |
      v
NAT
      |
      v
Internet
```

---

## 17. Firewall UFW

R-NCC utiliza UFW para controlar el acceso y el forwarding entre redes.

El estado se comprueba mediante:

```bash
sudo ufw status
```

El firewall debe aparecer como:

```text
Status: active
```

R-NCC permite los servicios necesarios para el funcionamiento del proyecto.

Entre ellos:

- SSH
- DNS TCP
- DNS UDP
- DHCP
- HTTP hacia W-NCC
- FTP hacia F-NCC
- forwarding específico entre redes

---

## 18. Forwarding hacia W-NCC

El cliente de la Intranet debe poder acceder al servidor web situado en la DMZ.

El flujo es:

```text
192.168.20.0/24
       |
       v
     R-NCC
       |
       v
192.168.10.10:80
```

Se permite tráfico HTTP hacia W-NCC.

Esto hace posible acceder a la aplicación desde los clientes internos.

---

## 19. Forwarding hacia F-NCC

El tráfico FTP desde la Intranet hacia F-NCC también pasa por R-NCC.

Flujo:

```text
192.168.20.0/24
       |
       v
     R-NCC
       |
       v
192.168.10.20:21
```

Durante las pruebas se validó desde Windows la conexión al puerto 21.

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

Resultado:

```text
TcpTestSucceeded : True
```

Posteriormente se realizaron pruebas FTP reales.

---

## 20. Comprobación del firewall

Para visualizar las reglas activas:

```bash
sudo ufw status
```

📸 **CAPTURA RECOMENDADA**

La captura debe mostrar:

```text
Status: active
```

y las reglas principales relacionadas con:

- DNS
- DHCP
- HTTP
- FTP
- forwarding

---

## 21. Dependencias

R-NCC es una de las máquinas más críticas del proyecto.

Los siguientes servicios dependen de su correcto funcionamiento:

### Clientes

Dependen de R-NCC para:

- DHCP
- DNS
- gateway
- NAT
- acceso a la DMZ

### W-NCC

Depende de R-NCC para el acceso desde la Intranet.

### F-NCC

Depende de R-NCC para que los clientes de la Intranet puedan acceder al servicio FTP.

---

## 22. Riesgos asociados

### Caída de R-NCC

Puede provocar pérdida de:

- acceso entre Intranet y DMZ
- DNS
- DHCP
- NAT
- acceso a Internet

### Error en UFW

Una regla incorrecta puede bloquear servicios necesarios.

También puede permitir tráfico que debería estar restringido.

### Error en NAT

Los clientes pueden mantener comunicación interna, pero perder la salida a Internet.

### Error en DNS

Los servicios pueden continuar funcionando por IP, pero dejar de funcionar mediante nombres.

### Error en DHCP

Los clientes nuevos pueden quedarse sin configuración de red.

---

## 23. Comandos principales de diagnóstico

### Interfaces

```bash
ip a
```

### Routing

```bash
ip route
```

### Forwarding

```bash
sysctl net.ipv4.ip_forward
```

### DHCP

```bash
sudo systemctl status isc-dhcp-server
```

### DNS

```bash
sudo systemctl status bind9
```

### Firewall

```bash
sudo ufw status
```

### NAT

```bash
sudo iptables -t nat -L POSTROUTING -n -v
```

### Puertos

```bash
sudo ss -lntup
```

### Logs DHCP

```bash
sudo journalctl -u isc-dhcp-server
```

### Logs DNS

```bash
sudo journalctl -u bind9
```

---

## 24. Criterios de validación

R-NCC se considera correctamente configurado cuando se cumplen los siguientes puntos:

- [x] dispone de interfaz en la DMZ
- [x] dispone de interfaz en la Intranet
- [x] dispone de salida hacia la red exterior
- [x] IPv4 forwarding está activo
- [x] DHCP está activo
- [x] Windows obtiene una dirección mediante DHCP
- [x] DNS está activo
- [x] los nombres internos resuelven correctamente
- [x] UFW está activo
- [x] existe forwarding entre redes autorizadas
- [x] NAT está configurado
- [x] NAT es persistente
- [x] Windows puede salir a Internet usando R-NCC como gateway
- [x] los clientes pueden acceder a W-NCC
- [x] los clientes pueden acceder a F-NCC

---

## 25. Evidencias recomendadas

Para demostrar el funcionamiento de R-NCC conviene conservar las siguientes capturas reales:

📸 **EVIDENCIA 1**

```bash
ip a
```

Debe mostrar `192.168.10.1` y `192.168.20.1`.

📸 **EVIDENCIA 2**

```bash
ip route
```

Debe mostrar DMZ, Intranet y ruta por defecto.

📸 **EVIDENCIA 3**

```bash
sysctl net.ipv4.ip_forward
```

Debe mostrar valor `1`.

📸 **EVIDENCIA 4**

```bash
sudo systemctl status isc-dhcp-server
```

Debe aparecer `active (running)`.

📸 **EVIDENCIA 5**

Logs DHCP mostrando la concesión de `192.168.20.100`.

📸 **EVIDENCIA 6**

Resolución DNS correcta desde un cliente.

📸 **EVIDENCIA 7**

```bash
sudo ufw status
```

📸 **EVIDENCIA 8**

```bash
sudo iptables -t nat -L POSTROUTING -n -v
```

Debe mostrar las reglas MASQUERADE y tráfico real.

📸 **EVIDENCIA 9**

Desde Windows:

```powershell
ping 8.8.8.8
```

usando R-NCC como gateway.

Estas evidencias ayudan a demostrar que la configuración no solo está documentada, sino también probada.

---

## 26. Conclusión

R-NCC es el núcleo de comunicaciones de la infraestructura.

Centraliza el routing, DHCP, DNS, NAT y firewall.

Su configuración permite que los clientes de la Intranet puedan comunicarse con los servidores de la DMZ y acceder a Internet de forma controlada.

Las pruebas realizadas confirman que los servicios principales funcionan y que el tráfico pasa realmente a través del router.
