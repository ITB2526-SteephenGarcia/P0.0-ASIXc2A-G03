# Cliente Linux

## Función

El cliente Linux es uno de los equipos de usuario de la infraestructura.

Está conectado a la red Intranet y se utiliza principalmente para realizar pruebas de conectividad y comprobar el funcionamiento de los diferentes servicios desplegados.

También permite realizar conexiones remotas mediante SSH hacia los servidores autorizados.

---

## Sistema operativo

El cliente está desplegado como máquina virtual en Isard y utiliza un sistema Linux.

---

## Red

El cliente Linux está conectado a la red:

```text
192.168.20.0/24
```

Su dirección IP es:

```text
192.168.20.20/24
```

El router de la Intranet es:

```text
R-NCC: 192.168.20.1
```

---

## Comprobación de red

Para comprobar las interfaces disponibles:

```bash
ip a
```

La interfaz conectada a la Intranet debe mostrar:

```text
192.168.20.20/24
```

---

## Tabla de rutas

Para comprobar las rutas configuradas:

```bash
ip route
```

Este comando permite verificar por qué interfaz se envía el tráfico del cliente.

---

## Pruebas de conectividad

### Conexión con R-NCC

```bash
ping -c 4 192.168.20.1
```

Esta prueba permite comprobar la comunicación entre el cliente Linux y el router.

### Conexión con B-NCC

En la arquitectura actual también se puede comprobar la conexión con el servidor de base de datos:

```bash
ping -c 4 192.168.20.10
```

> Esta prueba corresponde a la arquitectura actual. En la arquitectura final B-NCC estará aislado y los clientes no podrán acceder directamente a él.

---

## Acceso mediante SSH

El cliente Linux se utiliza también para realizar conexiones SSH hacia servidores de la infraestructura.

Por ejemplo:

```bash
ssh bchecker@192.168.20.1
```

para conectarse a `R-NCC`.

También se ha utilizado para realizar pruebas de acceso remoto hacia otros servidores.

---

## Usuario utilizado

El usuario utilizado para las pruebas y administración es:

```text
bchecker
```

---

## Herramientas utilizadas

Las principales herramientas utilizadas desde este cliente son:

- `ping`
- `ssh`
- `ip`
- herramientas de diagnóstico de red

Más adelante podrán añadirse clientes específicos para comprobar servicios como:

- DNS
- DHCP
- FTP
- HTTP/HTTPS

---

## Dependencias

Para que el cliente funcione correctamente necesita:

- Estar conectado a la Intranet.
- Tener una dirección IP válida.
- Tener conectividad con R-NCC.
- Tener las rutas correctamente configuradas.
- Disponer de las herramientas necesarias para realizar las pruebas.

---

## Seguridad

El cliente Linux pertenece a la red interna y no debe tener acceso directo a servicios que se encuentren aislados.

En la arquitectura final:

```text
Cliente Linux ✗ B-NCC:3306
```

El acceso directo a MySQL estará bloqueado.

Las consultas a la base de datos deberán realizarse a través de la aplicación alojada en `W-NCC`.

---

## Comandos de comprobación rápida

```bash
ip a
ip route
ping -c 4 192.168.20.1
```

Para comprobar SSH:

```bash
ssh bchecker@192.168.20.1
```

---

## Mantenimiento básico

Si el cliente pierde conectividad, comprobar primero:

```bash
ip a
```

Después revisar las rutas:

```bash
ip route
```

Y realizar una prueba contra el router:

```bash
ping -c 4 192.168.20.1
```

---

## Problemas habituales

### El cliente no puede comunicarse con R-NCC

Comprobar que la dirección IP pertenece a la red:

```text
192.168.20.0/24
```

Después comprobar:

```bash
ip a
ip route
```

### El comando ping no está disponible

En instalaciones mínimas de Ubuntu puede ser necesario instalar:

```bash
sudo apt update
sudo apt install iputils-ping -y
```

### SSH no conecta

Comprobar primero la conectividad:

```bash
ping -c 4 DIRECCION_IP
```

Después verificar que se está utilizando el usuario y la dirección correctos.

---

## Evidencias

> 📷 Pendiente: captura de `ip a`.

> 📷 Pendiente: prueba de ping con R-NCC.

> 📷 Pendiente: conexión SSH realizada correctamente.

Las evidencias se añadirán después de completar el MVP 2.

---

[← Volver a Documentación de Administrador](README.md)
