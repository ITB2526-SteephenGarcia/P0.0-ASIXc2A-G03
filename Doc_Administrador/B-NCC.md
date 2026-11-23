# B-NCC

## 1. Función de B-NCC

B-NCC es el servidor de base de datos del proyecto **P.0-ASIXc2A-G03**.

Su función principal es almacenar y gestionar los datos utilizados por la aplicación web.

B-NCC utiliza:

- Ubuntu Server
- MySQL 8
- UFW
- SSH restringido
- una red backend privada

La característica principal de su diseño es que **no está conectado directamente a R-NCC**.

Esto permite mantener la base de datos aislada de la DMZ y de la Intranet.

---

## 2. Ubicación dentro de la arquitectura

B-NCC se encuentra en la red backend privada.

```text id="c1yt3g"
Backend
192.168.30.0/24
```

Dirección de B-NCC:

```text id="p08un6"
192.168.30.10/24
```

Dirección de W-NCC en esta red:

```text id="f8yxgl"
192.168.30.1/24
```

El esquema de comunicación es:

```text id="e0f31o"
W-NCC
192.168.30.1
      |
      |
Backend privado
192.168.30.0/24
      |
      |
B-NCC
192.168.30.10
```

---

## 3. Aislamiento de B-NCC

Durante el despliegue inicial, B-NCC disponía también de una interfaz conectada a la red exterior de IsardVDI.

Para mejorar la seguridad, esa interfaz fue eliminada.

La configuración final mantiene únicamente:

- WireGuard
- red backend privada

De esta manera, B-NCC no dispone de una conexión directa a la DMZ ni a la Intranet.

Tampoco depende de R-NCC para comunicarse con W-NCC.

---

## 4. Cambio de interfaces

Después de eliminar la interfaz Default de IsardVDI, la numeración de interfaces cambió.

La configuración final quedó con:

```text id="upw3tn"
enp1s0 -> WireGuard
enp2s0 -> Backend
```

La interfaz backend utiliza:

```text id="5xj42h"
192.168.30.10/24
```

---

## 5. Configuración de red

La configuración de red se realizó mediante Netplan.

Ejemplo de configuración final:

```yaml id="e1v0me"
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: true

    enp2s0:
      dhcp4: false
      addresses:
        - 192.168.30.10/24
```

Después de aplicar los cambios:

```bash id="1fnq0a"
sudo netplan apply
```

se verificó la dirección IP mediante:

```bash id="2jvrua"
ip a
```

y la tabla de rutas mediante:

```bash id="6gnq7n"
ip route
```

---

## 6. Ruta backend

B-NCC dispone de una ruta directa hacia:

```text id="6jkp0i"
192.168.30.0/24
```

La interfaz utilizada es:

```text id="10ze0p"
enp2s0
```

Origen:

```text id="7v767w"
192.168.30.10
```

Esto permite la comunicación directa con W-NCC.

---

## 7. MySQL

B-NCC utiliza:

```text id="wgmxq2"
MySQL 8
```

La base de datos principal es:

```text id="2nu1u3"
equipaments
```

La tabla principal también se llama:

```text id="cu63ll"
equipaments
```

---

## 8. Datos importados

Los datos utilizados proceden de Barcelona Open Data.

El archivo original estaba en formato CSV.

Antes de la importación fue necesario convertir la codificación de:

```text id="6zjueg"
UTF-16
```

a:

```text id="f7xn5c"
UTF-8
```

La tabla contiene:

```text id="n9e0iz"
889 registros
```

La comprobación se realizó mediante:

```sql id="n8d7ns"
USE equipaments;
SELECT COUNT(*) FROM equipaments;
```

Resultado:

```text id="fow1kl"
889
```

---

## 9. Bind address

MySQL no escucha en todas las interfaces.

La configuración se encuentra en:

```text id="i7xk4n"
/etc/mysql/mysql.conf.d/mysqld.cnf
```

La opción utilizada es:

```text id="uq4ew3"
bind-address = 192.168.30.10
```

Esto hace que MySQL escuche únicamente en la interfaz backend.

---

## 10. Puertos de MySQL

La comprobación del puerto se realiza mediante:

```bash id="m2q2gl"
sudo ss -lntp | grep 3306
```

El resultado esperado es:

```text id="5eruot"
192.168.30.10:3306
```

También puede aparecer el servicio MySQL X en localhost.

```text id="7wwc26"
127.0.0.1:33060
```

El puerto importante para la aplicación es:

```text id="v4638f"
3306
```

---

## 11. Usuarios MySQL

Se utilizan diferentes cuentas para separar permisos.

### Usuario de lectura

Usuario:

```text id="8r835l"
bchecker
```

Origen permitido:

```text id="r4o4u5"
192.168.30.1
```

Permisos:

```text id="mhqut6"
SELECT
```

Este usuario se utiliza para las consultas normales de la aplicación.

---

## 12. Usuario administrativo

Usuario:

```text id="zt9xwq"
web_admin
```

Origen permitido:

```text id="pk0url"
192.168.30.1
```

Permisos:

```text id="5j7jdx"
SELECT
INSERT
UPDATE
DELETE
```

Esta cuenta se utiliza únicamente para operaciones administrativas del CRUD.

---

## 13. Restricción por origen

Los usuarios MySQL no están creados para cualquier origen.

Están limitados a:

```text id="v2dpt5"
192.168.30.1
```

Esto significa que solamente W-NCC puede autenticarse utilizando esas cuentas.

Este control añade una segunda capa de seguridad además del firewall.

---

## 14. Prueba de acceso permitido

Desde W-NCC se comprobó la conexión MySQL.

Ejemplo:

```bash id="h6nrsk"
mysql -h 192.168.30.10 -u bchecker -p
```

Después se ejecutó:

```sql id="gdt88u"
USE equipaments;
SELECT COUNT(*) FROM equipaments;
```

Resultado:

```text id="n48cvr"
889
```

Esto demuestra que W-NCC puede comunicarse correctamente con B-NCC.

---

## 15. Prueba de acceso no permitido

También se realizó una prueba desde B-NCC utilizando la cuenta `bchecker`.

El servidor rechazó la conexión con un mensaje similar a:

```text id="ol2mto"
ERROR 1130
Host 'B-NCC' is not allowed to connect to this MySQL server
```

Este resultado es correcto.

La cuenta `bchecker` solo está autorizada desde:

```text id="s1gwdl"
192.168.30.1
```

por lo que ni siquiera B-NCC puede utilizar esa cuenta desde otro origen.

Esta prueba ayuda a demostrar que la restricción por host funciona.

---

## 16. Firewall UFW

B-NCC utiliza UFW para limitar el acceso.

El firewall está activo y restringe los servicios principales.

Las reglas finales permiten:

```text id="i2g55u"
3306/tcp desde 192.168.30.1
22/tcp desde 192.168.30.1
```

Esto significa que W-NCC es el único equipo autorizado para acceder a:

- MySQL
- SSH

---

## 17. MySQL restringido

El puerto:

```text id="88iu5t"
3306/tcp
```

solo está permitido desde:

```text id="tqclqu"
192.168.30.1
```

Esto evita que otros equipos puedan intentar conectarse directamente al servidor de base de datos.

---

## 18. SSH restringido

El puerto:

```text id="6ep27u"
22/tcp
```

también está limitado a:

```text id="8pggl1"
192.168.30.1
```

Esto significa que la administración remota de B-NCC desde la red del proyecto debe realizarse a través de W-NCC.

---

## 19. Mejora de seguridad aplicada

Inicialmente existían reglas SSH más abiertas.

Se permitió temporalmente SSH desde cualquier origen.

Después se añadió la regla específica para W-NCC y se eliminaron las reglas generales.

La configuración final mantiene únicamente el acceso desde:

```text id="hz0y0k"
192.168.30.1
```

Esta mejora reduce la superficie de exposición.

---

## 20. Esquema de seguridad

```text id="2zddwm"
                Otros equipos
                    |
                    X
                    |
              B-NCC bloqueado

W-NCC 192.168.30.1
        |
        +------ SSH 22 ------> B-NCC
        |
        +------ MySQL 3306 --> B-NCC
```

El símbolo `X` representa tráfico no permitido.

---

## 21. Base de datos de usuarios web

Además de la tabla de equipamientos, se utiliza una tabla:

```text id="1fl10e"
usuarios
```

Campos principales:

```text id="0aj37t"
id
username
password_hash
rol
```

Los roles utilizados son:

```text id="q87y69"
lector
admin
```

---

## 22. Contraseñas

Las contraseñas web se almacenan mediante hashes.

Se utiliza bcrypt a través de PHP.

La longitud observada del hash es:

```text id="ka6dpu"
60 caracteres
```

La validación se realiza mediante:

```php id="ay8ygu"
password_verify()
```

Esto evita almacenar contraseñas web directamente en texto plano.

---

## 23. Diferencia entre usuarios web y MySQL

Es importante diferenciar dos tipos de usuarios.

### Usuarios web

Se almacenan en:

```text id="g4jr37"
equipaments.usuarios
```

Se utilizan para:

- login
- sesiones
- roles

Ejemplos:

```text id="w5bf40"
bchecker
web_admin
```

---

### Usuarios MySQL

Son cuentas del propio servidor MySQL.

Se utilizan para:

- establecer la conexión desde PHP
- consultar datos
- modificar datos

Aunque los nombres puedan coincidir, son mecanismos de autenticación diferentes.

---

## 24. Dependencias

B-NCC depende principalmente de:

### W-NCC

Es el único equipo que utiliza directamente los servicios de B-NCC.

### MySQL

La aplicación necesita que MySQL esté activo.

### Red backend

Si la interfaz:

```text id="jzo6c5"
192.168.30.10
```

deja de funcionar, W-NCC pierde la conexión con la base de datos.

---

## 25. Riesgos

### Caída de MySQL

La aplicación web deja de poder consultar y modificar datos.

### Error en UFW

Una regla incorrecta puede bloquear W-NCC o exponer MySQL.

### Error en bind-address

MySQL puede dejar de escuchar en la red backend o quedar expuesto en interfaces no deseadas.

### Pérdida de la interfaz backend

W-NCC no puede alcanzar la base de datos.

### Permisos excesivos

Una cuenta con permisos innecesarios puede aumentar el impacto de un posible fallo de seguridad.

---

## 26. Diagnóstico de red

### Interfaces

```bash id="nw6bqa"
ip a
```

### Rutas

```bash id="mzk1ld"
ip route
```

### Conectividad con W-NCC

```bash id="jjyp45"
ping 192.168.30.1
```

---

## 27. Diagnóstico de MySQL

### Estado del servicio

```bash id="znt4o9"
sudo systemctl status mysql
```

### Puerto

```bash id="c2xy08"
sudo ss -lntp | grep 3306
```

### Bind address

```bash id="7w00y6"
grep bind-address /etc/mysql/mysql.conf.d/mysqld.cnf
```

### Bases de datos

```sql id="019w70"
SHOW DATABASES;
```

### Usuarios

```sql id="g6j5fq"
SELECT user, host FROM mysql.user;
```

---

## 28. Diagnóstico del firewall

Estado:

```bash id="kxf8n3"
sudo ufw status
```

La configuración debe mostrar reglas similares a:

```text id="ct7g42"
3306/tcp ALLOW IN 192.168.30.1
22/tcp   ALLOW IN 192.168.30.1
```

---

## 29. Criterios de validación

B-NCC se considera correctamente configurado cuando:

- [x] utiliza la red backend
- [x] tiene la dirección 192.168.30.10
- [x] no dispone de acceso directo desde la DMZ
- [x] no dispone de acceso directo desde la Intranet
- [x] MySQL está activo
- [x] MySQL escucha en 192.168.30.10
- [x] la base de datos `equipaments` existe
- [x] existen 889 registros
- [x] W-NCC puede conectarse
- [x] los usuarios MySQL están limitados por origen
- [x] UFW está activo
- [x] MySQL solo permite acceso desde W-NCC
- [x] SSH solo permite acceso desde W-NCC
- [x] las contraseñas web se almacenan mediante hash

---

## 30. Evidencias pendientes

Las capturas reales se añadirán posteriormente.

Las evidencias recomendadas son:

📸 `ip a` mostrando `192.168.30.10`

📸 `ip route`

📸 `systemctl status mysql`

📸 `ss -lntp | grep 3306`

📸 `ufw status`

📸 `SELECT COUNT(*) FROM equipaments`

📸 conexión correcta desde W-NCC

📸 error `Host is not allowed` desde un origen no autorizado

Estas capturas se añadirán en la fase final de evidencias.

---

## 31. Conclusión

B-NCC representa la capa de datos de la arquitectura multicapa.

Su aislamiento mediante una red backend privada reduce la exposición de MySQL.

La combinación de:

- red privada
- bind-address
- usuarios restringidos por origen
- permisos diferenciados
- UFW
- SSH restringido

permite aplicar varias capas de seguridad.

La comunicación con la base de datos queda limitada a W-NCC, que actúa como único punto de acceso autorizado desde la aplicación web.
