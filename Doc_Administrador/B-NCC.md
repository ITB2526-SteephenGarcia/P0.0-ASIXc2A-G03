# B-NCC - Servidor de Base de Datos

## Función

`B-NCC` es el servidor de base de datos del proyecto.

Su función principal es almacenar y gestionar los datos utilizados por la aplicación web.

Actualmente utiliza MySQL y contiene la base de datos `equipaments`, donde se ha importado el CSV proporcionado para el proyecto.

En la arquitectura final, `B-NCC` estará dentro de una red backend privada y aislada, accesible únicamente desde `W-NCC`.

---

## Sistema operativo

`B-NCC` está desplegado como máquina virtual en Isard.

El sistema operativo utilizado es:

```text
Ubuntu Server
```

---

## Hostname

El nombre configurado para la máquina es:

```text
B-NCC
```

Se puede comprobar con:

```bash
hostname
```

---

## Dirección IP actual

Actualmente `B-NCC` está conectado a la red Intranet con la dirección:

```text
192.168.20.10/24
```

Esta configuración corresponde al estado actual del proyecto.

---

## Dirección IP prevista

En la arquitectura final, `B-NCC` se moverá a una red backend privada:

```text
192.168.30.0/24
```

La dirección prevista para el servidor será:

```text
192.168.30.10/24
```

Esta red estará conectada únicamente con `W-NCC`.

Los clientes Linux y Windows no tendrán acceso directo a esta red.

---

## Red backend aislada

La comunicación prevista será:

```text
W-NCC
   |
   | Red Backend privada
   |
Firewall
   |
   v
B-NCC
```

La base de datos solo aceptará conexiones MySQL procedentes de `W-NCC`.

El puerto utilizado será:

```text
TCP 3306
```

El resto de accesos deberán quedar bloqueados mediante firewall.

---

## Instalación de MySQL

MySQL se instala con:

```bash
sudo apt update
sudo apt install mysql-server -y
```

---

## Comprobación del servicio

Para comprobar que MySQL está funcionando:

```bash
sudo systemctl status mysql
```

El estado esperado es:

```text
active (running)
```

---

## Inicio y reinicio de MySQL

Iniciar el servicio:

```bash
sudo systemctl start mysql
```

Reiniciarlo:

```bash
sudo systemctl restart mysql
```

Habilitarlo al iniciar el sistema:

```bash
sudo systemctl enable mysql
```

---

## Acceso a MySQL

Para acceder al servidor MySQL de forma local:

```bash
sudo mysql
```

---

## Base de datos

La base de datos creada para el proyecto se llama:

```text
equipaments
```

Se puede comprobar con:

```sql
SHOW DATABASES;
```

Después:

```sql
USE equipaments;
```

---

## Tabla principal

Actualmente la base de datos contiene la tabla:

```text
equipaments
```

Se puede comprobar con:

```sql
SHOW TABLES;
```

---

## Datos importados

Los datos utilizados proceden del CSV proporcionado para el proyecto.

El archivo original estaba codificado en UTF-16, por lo que fue necesario convertirlo a UTF-8 antes de importarlo.

Ejemplo de conversión:

```bash
iconv -f UTF-16 -t UTF-8 equipaments.csv > equipaments_utf8.csv
```

Después se importaron los datos en MySQL.

---

## Número de registros

Actualmente la tabla contiene:

```text
889 registros
```

Se puede comprobar con:

```sql
SELECT COUNT(*) FROM equipaments;
```

---

## Consulta de ejemplo

Para comprobar que los datos están correctamente almacenados:

```sql
SELECT name, addresses_district_name
FROM equipaments
LIMIT 10;
```

Esta consulta muestra el nombre de diferentes equipamientos junto con su distrito.

---

## Estructura de los datos

La tabla contiene las columnas importadas directamente desde el CSV original.

En esta primera fase se mantuvo una estructura sencilla para asegurar una importación correcta.

Todavía no se ha aplicado un modelo relacional completo ni una normalización avanzada.

Estas mejoras se podrán realizar durante los siguientes sprints.

---

## Dependencias

Para que `B-NCC` funcione correctamente se necesita:

- Sistema operativo Ubuntu Server.
- MySQL Server instalado.
- Servicio MySQL activo.
- Red backend correctamente configurada.
- Conectividad con `W-NCC`.
- Firewall correctamente configurado.
- Usuario MySQL autorizado.
- Base de datos `equipaments`.

---

## Seguridad

En la arquitectura final se aplicarán las siguientes medidas:

- `B-NCC` estará fuera de la Intranet.
- Estará conectado únicamente a una red backend privada.
- Solo `W-NCC` podrá acceder a MySQL.
- El puerto `3306` estará bloqueado para el resto de equipos.
- No se permitirá acceso directo desde los clientes.
- Las reglas de firewall limitarán el tráfico autorizado.

Las reglas concretas se documentarán en:

[Seguridad y Firewall](Seguridad-Firewall.md)

---

## Comprobaciones rápidas

Estado de MySQL:

```bash
sudo systemctl status mysql
```

Comprobar IP:

```bash
ip a
```

Comprobar rutas:

```bash
ip route
```

Acceder a MySQL:

```bash
sudo mysql
```

Comprobar base de datos:

```sql
SHOW DATABASES;
USE equipaments;
SHOW TABLES;
SELECT COUNT(*) FROM equipaments;
```

---

## Mantenimiento básico

Durante el mantenimiento se recomienda comprobar regularmente:

```bash
sudo systemctl status mysql
```

En caso de problemas:

```bash
sudo systemctl restart mysql
```

También se pueden revisar los logs:

```bash
sudo journalctl -u mysql
```

---

## Copias de seguridad

Está previsto añadir un sistema de copias de seguridad de la base de datos.

Un método posible será utilizar:

```bash
mysqldump
```

Por ejemplo:

```bash
mysqldump equipaments > equipaments_backup.sql
```

> Este procedimiento se completará y probará durante una fase posterior del proyecto.

---

## Problemas habituales

### MySQL no está iniciado

Comprobar:

```bash
sudo systemctl status mysql
```

Si está detenido:

```bash
sudo systemctl restart mysql
```

### No aparece la base de datos

Entrar en MySQL:

```bash
sudo mysql
```

Y comprobar:

```sql
SHOW DATABASES;
```

### La tabla no contiene datos

Comprobar:

```sql
SELECT COUNT(*) FROM equipaments;
```

Si devuelve `0`, revisar el proceso de importación.

### W-NCC no puede acceder a MySQL

Cuando se implemente la red backend, revisar:

- dirección IP de B-NCC;
- interfaz backend de W-NCC;
- firewall;
- puerto `3306`;
- usuario MySQL;
- estado del servicio MySQL.

---

## Evidencias

> 📷 Pendiente: captura de `ip a`.

> 📷 Pendiente: captura de `systemctl status mysql`.

> 📷 Pendiente: captura de `SHOW DATABASES`.

> 📷 Pendiente: captura de `SELECT COUNT(*) FROM equipaments`.

> 📷 Pendiente: consulta mostrando registros de la base de datos.

Las evidencias se añadirán una vez completado el MVP 2.

---

[← Volver a Documentación de Administrador](README.md)
