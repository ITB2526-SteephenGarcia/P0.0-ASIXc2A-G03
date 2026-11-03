# W-NCC - Servidor Web

## Función

`W-NCC` es el servidor web principal del proyecto.

Está ubicado dentro de la red DMZ y su función es alojar la aplicación web que utilizarán los usuarios para consultar la información del proyecto.

Actualmente utiliza NGINX como servidor web.

En la arquitectura final, `W-NCC` también será la única máquina autorizada para acceder al servidor de base de datos `B-NCC`.

---

## Sistema operativo

`W-NCC` está desplegado como máquina virtual en Isard.

El sistema operativo utilizado es:

```text
Ubuntu Server
```

---

## Hostname

El nombre configurado para esta máquina es:

```text
W-NCC
```

Se puede comprobar con:

```bash
hostname
```

---

## Red principal

`W-NCC` está conectado a la red DMZ:

```text
192.168.10.0/24
```

Su dirección IP es:

```text
192.168.10.10/24
```

La puerta de enlace de esta red corresponde a `R-NCC`:

```text
192.168.10.1
```

---

## Red backend aislada

En la arquitectura final está previsto añadir una segunda interfaz de red a `W-NCC`.

Esta interfaz se utilizará únicamente para conectar el servidor web con `B-NCC`.

La red prevista será:

```text
192.168.30.0/24
```

La conexión seguirá esta estructura:

```text
W-NCC
   |
   | Red Backend
   |
Firewall
   |
   v
B-NCC
```

Esta red no estará conectada directamente a `R-NCC`.

El objetivo es que solo `W-NCC` pueda acceder al servidor MySQL.

---

## Servicio web

El servidor utiliza:

```text
NGINX
```

Su función es atender peticiones HTTP/HTTPS y mostrar la aplicación web.

Los puertos principales serán:

```text
80   HTTP
443  HTTPS
```

---

## Instalación de NGINX

NGINX se puede instalar con:

```bash
sudo apt update
sudo apt install nginx -y
```

---

## Comprobación del servicio

Para comprobar si NGINX está funcionando:

```bash
sudo systemctl status nginx
```

El estado esperado es:

```text
active (running)
```

---

## Inicio y reinicio del servicio

Para iniciar NGINX:

```bash
sudo systemctl start nginx
```

Para reiniciarlo:

```bash
sudo systemctl restart nginx
```

Para habilitarlo al iniciar el sistema:

```bash
sudo systemctl enable nginx
```

---

## Directorio web

La ubicación habitual del contenido web de NGINX es:

```text
/var/www/html/
```

En esta carpeta se almacenará la página o aplicación web del proyecto.

---

## Conexión con B-NCC

En el estado final del proyecto, la aplicación web realizará consultas al servidor de base de datos `B-NCC`.

La comunicación será:

```text
W-NCC → B-NCC
```

mediante:

```text
MySQL
Puerto TCP 3306
```

Esta conexión estará permitida únicamente desde `W-NCC`.

Los clientes no podrán conectarse directamente al servidor de base de datos.

---

## Dependencias

Para que `W-NCC` funcione correctamente se necesita:

- Red DMZ operativa.
- Conectividad con `R-NCC`.
- NGINX instalado.
- Aplicación web desplegada.
- Red backend configurada.
- Conectividad con `B-NCC`.
- Firewall configurado correctamente.
- MySQL disponible en `B-NCC`.

---

## Pruebas de conectividad

Para comprobar la conexión con el router:

```bash
ping -c 4 192.168.10.1
```

Para comprobar la configuración de red:

```bash
ip a
```

---

## Comprobación web

Desde otro equipo con acceso a la DMZ se puede comprobar el servidor mediante navegador.

También se puede utilizar:

```bash
curl http://192.168.10.10
```

Si NGINX está funcionando, debería devolver contenido HTML.

---

## Seguridad

`W-NCC` será uno de los puntos principales de seguridad del proyecto.

Está previsto:

- Permitir tráfico HTTP/HTTPS hacia el servidor web.
- Limitar el acceso SSH.
- Bloquear conexiones no necesarias.
- Crear una red backend aislada para la base de datos.
- Permitir únicamente conexiones MySQL desde `W-NCC` hacia `B-NCC`.
- Evitar que los clientes tengan acceso directo a MySQL.

Las reglas concretas se documentarán en:

[Seguridad y Firewall](Seguridad-Firewall.md)

---

## Mantenimiento básico

Comprobar estado de NGINX:

```bash
sudo systemctl status nginx
```

Reiniciar el servicio:

```bash
sudo systemctl restart nginx
```

Comprobar interfaces:

```bash
ip a
```

Comprobar rutas:

```bash
ip route
```

Comprobar los últimos mensajes del servicio:

```bash
sudo journalctl -u nginx
```

---

## Problemas habituales

### La página web no responde

Comprobar:

```bash
sudo systemctl status nginx
```

También revisar:

```bash
ip a
ping -c 4 192.168.10.1
```

### NGINX está detenido

Reiniciar:

```bash
sudo systemctl restart nginx
```

### La web no puede consultar la base de datos

Cuando se implemente la integración, comprobar:

- interfaz backend;
- conectividad con `B-NCC`;
- puerto `3306`;
- firewall;
- usuario MySQL;
- estado del servicio MySQL.

---

## Evidencias

> 📷 Pendiente: captura de `ip a`.

> 📷 Pendiente: captura de `systemctl status nginx`.

> 📷 Pendiente: captura de la página web.

> 📷 Pendiente: prueba de conexión entre W-NCC y B-NCC.

Las evidencias se añadirán una vez completado el MVP 2.

---

[← Volver a Documentación de Administrador](README.md)
