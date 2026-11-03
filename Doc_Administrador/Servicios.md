# Servicios de la infraestructura

## Introducción

La infraestructura del proyecto utiliza diferentes servicios de red y administración.

Cada servicio tiene una función concreta dentro de la arquitectura y se encuentra asociado a una o varias máquinas.

Este documento sirve como resumen general del estado de los servicios.

La configuración detallada de cada uno se documentará en los archivos correspondientes de cada máquina o servicio.

---

## Resumen de servicios

| Servicio | Máquina principal | Puerto | Estado |
|---|---|---:|---|
| SSH | R-NCC / servidores Linux | 22/TCP | Implementado |
| HTTP | W-NCC | 80/TCP | Implementado |
| HTTPS | W-NCC | 443/TCP | Pendiente |
| MySQL | B-NCC | 3306/TCP | Implementado |
| FTP | F-NCC | 21/TCP | Pendiente |
| DNS | Pendiente de definir | 53/TCP-UDP | Pendiente |
| DHCP | Pendiente de definir | 67-68/UDP | Pendiente |
| Firewall | R-NCC / W-NCC / B-NCC | — | Pendiente de completar |

> El estado de esta tabla se irá actualizando a medida que avance el Sprint 2.

---

# SSH

## Función

SSH se utiliza para acceder de forma remota a los servidores y realizar tareas de administración.

Actualmente se ha utilizado para acceder a máquinas como:

- `R-NCC`
- `B-NCC`

desde clientes de la Intranet.

---

## Puerto

```text
22/TCP
```

---

## Usuario utilizado

El usuario principal utilizado para las conexiones es:

```text
bchecker
```

---

## Ejemplo de conexión

```bash
ssh bchecker@192.168.20.10
```

---

## Comprobación

Para comprobar el estado del servicio:

```bash
sudo systemctl status ssh
```

---

# NGINX / HTTP

## Función

NGINX está instalado en `W-NCC`.

Su función es alojar la página web del proyecto y atender las peticiones de los usuarios.

Actualmente el servidor web funciona de forma independiente de la base de datos.

En una fase posterior la aplicación web realizará consultas a `B-NCC`.

---

## Puerto

HTTP:

```text
80/TCP
```

HTTPS:

```text
443/TCP
```

El uso de HTTPS se añadirá posteriormente.

---

## Comprobación

```bash
sudo systemctl status nginx
```

También se puede comprobar utilizando:

```bash
curl http://192.168.10.10
```

---

# MySQL

## Función

MySQL está instalado en `B-NCC`.

Se utiliza para almacenar la información utilizada por la aplicación web.

Actualmente contiene:

```text
Base de datos: equipaments
Tabla: equipaments
Registros: 889
```

---

## Puerto

```text
3306/TCP
```

---

## Comprobación

Estado del servicio:

```bash
sudo systemctl status mysql
```

Acceso local:

```bash
sudo mysql
```

Dentro de MySQL:

```sql
USE equipaments;
SELECT COUNT(*) FROM equipaments;
```

---

## Acceso previsto

En la arquitectura final, MySQL solo será accesible desde:

```text
W-NCC
```

Los clientes Linux y Windows no podrán acceder directamente al puerto `3306`.

---

# FTP

## Estado

```text
Pendiente de implementación
```

El servicio FTP estará alojado en:

```text
F-NCC
```

Su función será permitir la transferencia de archivos dentro de la infraestructura siguiendo las reglas de acceso que se definan.

La configuración se documentará cuando se despliegue durante el Sprint 2.

---

## Puerto principal previsto

```text
21/TCP
```

---

# DNS

## Estado

```text
Pendiente de implementación
```

El servicio DNS permitirá resolver nombres de las máquinas y servicios de la infraestructura.

La configuración concreta se definirá durante el Sprint 2.

El proyecto deberá permitir resolver nombres como:

```text
R-NCC
R
```

según los requisitos definidos para la infraestructura.

---

## Puerto

```text
53/UDP
53/TCP
```

---

# DHCP

## Estado

```text
Pendiente de implementación
```

DHCP se utilizará para asignar automáticamente parámetros de red a los clientes cuando corresponda.

La configuración se realizará durante el Sprint 2.

---

## Puertos

```text
67/UDP
68/UDP
```

---

# Firewall

## Función

El firewall tendrá como objetivo controlar qué comunicaciones están permitidas entre las diferentes zonas de la infraestructura.

Las principales zonas serán:

- Exterior.
- DMZ.
- Intranet.
- Red backend aislada.

---

## Reglas previstas

Entre las reglas principales se encuentran:

```text
Clientes → W-NCC              PERMITIDO
W-NCC → B-NCC:3306            PERMITIDO

Cliente Linux → B-NCC:3306    BLOQUEADO
Cliente Windows → B-NCC:3306  BLOQUEADO
Exterior → B-NCC              BLOQUEADO
```

La configuración completa se documentará en:

[Seguridad y Firewall](Seguridad-Firewall.md)

---

# Dependencias entre servicios

Algunos servicios necesitan que otros componentes estén disponibles.

## Aplicación web

La aplicación web dependerá de:

```text
NGINX
   |
   v
Aplicación Web
   |
   v
MySQL
```

Para funcionar correctamente será necesario que:

- `W-NCC` esté operativo.
- NGINX esté activo.
- La red backend esté disponible.
- El firewall permita la conexión.
- `B-NCC` esté operativo.
- MySQL esté activo.

---

## Acceso SSH

SSH depende principalmente de:

- conectividad de red;
- servicio SSH activo;
- usuario autorizado;
- firewall permitiendo el puerto correspondiente.

---

## DNS y DHCP

Estos servicios dependerán de una configuración correcta de la red y de los clientes.

Su funcionamiento se documentará una vez implementados.

---

# Comprobaciones rápidas

## SSH

```bash
sudo systemctl status ssh
```

## NGINX

```bash
sudo systemctl status nginx
```

## MySQL

```bash
sudo systemctl status mysql
```

---

# Estado actual

Actualmente se encuentran funcionando:

- SSH.
- NGINX.
- MySQL.

Durante el Sprint 2 está previsto completar:

- FTP.
- DNS.
- DHCP.
- Firewall.
- HTTPS.
- Integración entre W-NCC y B-NCC.

El objetivo es finalizar los servicios principales durante el Sprint 2 y utilizar el Sprint 3 para realizar mejoras, pruebas y optimizaciones.

---

[← Volver a Documentación de Administrador](README.md)
