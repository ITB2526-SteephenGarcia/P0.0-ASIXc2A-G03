# Arquitectura de la infraestructura

## 1. Introducción

La infraestructura del proyecto **P.0-ASIXc2A-G03** se ha diseñado siguiendo una arquitectura segmentada en distintas redes para separar funciones, reducir la exposición de los servicios y facilitar la administración.

El diseño final utiliza tres redes principales del proyecto:

- DMZ
- Intranet
- Backend privado

Además, R-NCC dispone de conectividad hacia la red exterior proporcionada por IsardVDI.

La separación entre redes permite aplicar controles de acceso diferentes según el tipo de servicio y evita que todos los equipos puedan comunicarse directamente entre sí.

---

## 2. Esquema general

<img width="1448" height="1086" alt="imatge" src="https://github.com/user-attachments/assets/d8b333e6-60ec-48cc-be4b-fa7ac9c803e6" />

---

## 3. Redes utilizadas

### 3.1 Red DMZ

Rango:

```text
192.168.10.0/24
```

Gateway:

```text
192.168.10.1
```

La DMZ contiene los servidores que deben ofrecer servicios a otros equipos de la infraestructura.

Equipos principales:

```text
W-NCC -> 192.168.10.10
F-NCC -> 192.168.10.20
R-NCC -> 192.168.10.1
```

W-NCC ofrece el servicio web.

F-NCC ofrece el servicio FTP.

R-NCC controla el tráfico entre esta red y la Intranet.

---

### 3.2 Red Intranet

Rango:

```text
192.168.20.0/24
```

Gateway:

```text
192.168.20.1
```

La Intranet contiene los clientes internos.

Equipos principales:

```text
R-NCC -> 192.168.20.1
Windows -> DHCP
Linux -> 192.168.20.0/24
```

Durante las pruebas, el cliente Windows recibió:

```text
192.168.20.100
```

La Intranet utiliza R-NCC como gateway principal.

---

### 3.3 Red backend

Rango:

```text
192.168.30.0/24
```

La red backend se utiliza exclusivamente para la comunicación entre W-NCC y B-NCC.

Direcciones:

```text
W-NCC -> 192.168.30.1
B-NCC -> 192.168.30.10
```

Esta red no está conectada directamente a R-NCC.

Su función es aislar la base de datos de las redes de usuarios y de la DMZ.

---

## 4. R-NCC

R-NCC actúa como elemento central de red.

Sus principales funciones son:

- routing entre DMZ e Intranet
- DHCP
- DNS
- NAT
- firewall
- forwarding
- salida hacia Internet

Interfaces principales del proyecto:

```text
DMZ      -> 192.168.10.1
Intranet -> 192.168.20.1
```

Además, dispone de una interfaz exterior conectada a la red proporcionada por IsardVDI.

R-NCC tiene habilitado el reenvío IPv4.

```bash
net.ipv4.ip_forward = 1
```

---

## 5. W-NCC

W-NCC es el servidor web.

Dispone de dos interfaces relevantes para la arquitectura.

### Interfaz DMZ

```text
192.168.10.10
```

Permite que los clientes accedan a la aplicación web.

### Interfaz backend

```text
192.168.30.1
```

Permite la comunicación con B-NCC.

Esta segunda interfaz es especialmente importante porque hace posible mantener la base de datos fuera de la DMZ.

---

## 6. B-NCC

B-NCC es el servidor de base de datos MySQL.

Dirección:

```text
192.168.30.10
```

B-NCC no está conectado directamente a R-NCC.

La comunicación se produce mediante:

```text
W-NCC 192.168.30.1
        |
        |
B-NCC 192.168.30.10
```

Esta decisión se tomó para evitar que la base de datos pudiera ser alcanzada directamente desde la Intranet o desde la DMZ.

---

## 7. F-NCC

F-NCC es el servidor FTP.

Dirección:

```text
192.168.10.20
```

Está situado en la DMZ.

Los clientes de la Intranet acceden a F-NCC pasando por R-NCC.

El tráfico FTP se controla mediante las reglas de forwarding configuradas en el router.

---

## 8. Clientes

### Cliente Windows

El cliente Windows se encuentra en la Intranet.

Durante las pruebas se utilizó:

```text
IP: 192.168.20.100
Gateway: 192.168.20.1
DNS: 192.168.20.1
```

La configuración se obtiene mediante DHCP.

Desde este equipo se han realizado pruebas de:

- DHCP
- DNS
- acceso web
- FTP
- NAT
- routing
- autenticación
- CRUD

---

### Cliente Linux

El cliente Linux también se encuentra en la Intranet.

Se utiliza como segundo cliente para validar:

- conectividad
- DNS
- acceso a servicios
- funcionamiento general de la red

---

## 9. Flujo de comunicación

### Cliente hacia servidor web

```text
Windows/Linux
      |
      |
192.168.20.0/24
      |
    R-NCC
      |
192.168.10.0/24
      |
    W-NCC
```

El cliente accede al servidor web mediante R-NCC.

---

### Servidor web hacia base de datos

```text
W-NCC
192.168.30.1
      |
      |
B-NCC
192.168.30.10
```

Esta comunicación no pasa por R-NCC.

La red backend es una conexión privada entre ambas máquinas.

---

### Cliente hacia FTP

```text
Windows/Linux
      |
    R-NCC
      |
    F-NCC
192.168.10.20
```

R-NCC permite el acceso FTP desde la Intranet hacia F-NCC.

---

### Cliente hacia Internet

```text
Cliente
  |
R-NCC
  |
NAT
  |
Internet
```

R-NCC realiza NAT mediante reglas MASQUERADE.

---

## 10. Decisiones de diseño

### Separación de la base de datos

La decisión más importante de la arquitectura fue aislar B-NCC en una red propia.

Ventajas:

- MySQL no está expuesto a la Intranet
- MySQL no está expuesto directamente a la DMZ
- solo W-NCC puede conectarse
- se reduce la superficie de ataque
- se aplica el principio de mínimo privilegio

---

### Uso de una DMZ

W-NCC y F-NCC están situados en una red separada de los clientes.

Esto permite diferenciar los servidores de los equipos de usuario.

También facilita aplicar reglas de tráfico específicas.

---

### R-NCC como gateway central

Los clientes utilizan R-NCC como gateway principal.

Esto permite centralizar:

- routing
- NAT
- DNS
- DHCP
- firewall

De esta forma, el comportamiento de la red se controla desde un único punto.

---

## 11. Dependencias entre equipos

La infraestructura tiene las siguientes dependencias:

```text
Windows/Linux
      |
      v
    R-NCC
   /     \
  v       v
W-NCC   F-NCC
  |
  v
B-NCC
```

Si R-NCC falla, los clientes pueden perder acceso a la DMZ, DNS, DHCP y salida a Internet.

Si W-NCC falla, la aplicación web deja de estar disponible.

Si B-NCC falla, la aplicación no puede consultar la base de datos.

Si F-NCC falla, el servicio FTP deja de estar disponible.

---

## 12. Seguridad de la arquitectura

Las principales medidas de seguridad asociadas al diseño son:

- segmentación de redes
- separación entre clientes y servidores
- backend privado
- firewall UFW
- forwarding limitado
- MySQL restringido a W-NCC
- SSH de B-NCC restringido a W-NCC
- control de acceso mediante roles
- NAT centralizado

La arquitectura no se basa únicamente en que los servicios funcionen, sino también en limitar quién puede acceder a cada servicio.

---

## 13. Pruebas de validación

Para validar la arquitectura se han realizado pruebas de:

### Routing

```bash
ping
ip route
```

### DNS

```bash
nslookup
dig
```

### DHCP

Revisión de logs del servidor DHCP.

### NAT

```bash
iptables -t nat -L -n -v
```

### Puertos

```bash
ss -lntp
```

Desde Windows:

```powershell
Test-NetConnection
```

### MySQL

Conexión desde W-NCC hacia:

```text
192.168.30.10:3306
```

### FTP

Pruebas de:

```text
login
ls
get
put
```

---

## 14. Validación del aislamiento de B-NCC

Una de las pruebas más importantes es comprobar que B-NCC solo acepta conexiones desde W-NCC.

El firewall de B-NCC permite:

```text
3306/tcp desde 192.168.30.1
22/tcp desde 192.168.30.1
```

Esto demuestra que la arquitectura backend no solo está separada físicamente a nivel de red, sino también protegida mediante firewall.

📸 **CAPTURA RECOMENDADA**

Aquí conviene añadir una captura de:

```bash
sudo ufw status
```

ejecutado en B-NCC.

La captura debería mostrar las reglas de SSH y MySQL limitadas a:

```text
192.168.30.1
```

---

## 15. Riesgos de la arquitectura

Los principales riesgos identificados son:

### Fallo de R-NCC

Puede afectar a:

- routing
- DHCP
- DNS
- NAT
- acceso entre redes

### Fallo de W-NCC

La aplicación web deja de estar disponible.

### Fallo de B-NCC

La aplicación web puede cargar, pero no podrá consultar los datos.

### Error en firewall

Una regla incorrecta puede bloquear servicios necesarios o permitir tráfico no deseado.

### Error de routing

Una ruta incorrecta puede provocar que dos equipos no puedan comunicarse aunque estén correctamente configurados.

---

## 16. Conclusión

La arquitectura final permite separar los diferentes servicios según su función.

R-NCC centraliza los servicios de red.

W-NCC y F-NCC se encuentran en la DMZ.

Los clientes se encuentran en la Intranet.

B-NCC utiliza una red backend privada accesible únicamente desde W-NCC.

Esta distribución permite mantener una infraestructura funcional, organizada y con mejores controles de seguridad que una red plana donde todos los equipos estuvieran conectados directamente entre sí.
