# **Sprint 2 - 23/11/2026**

**Integrantes:** Taylor Uriña y Steephen Garcia  
**Sprint:** Sprint 2  
**Fecha:** 23/11/2026

## **Objetivo de la sesión**

Esta sesión se centró en consolidar la infraestructura final, validar los servicios y actualizar la documentación para que reflejara el estado real del proyecto.

Durante esta fase se revisaron R-NCC, W-NCC, B-NCC, F-NCC y los clientes. También se completaron pruebas de seguridad, autenticación, CRUD, FTP, DHCP, DNS y NAT.

## **Arquitectura final**

La arquitectura quedó dividida en tres redes principales del proyecto:

```text
DMZ      -> 192.168.10.0/24
Intranet -> 192.168.20.0/24
Backend  -> 192.168.30.0/24
```

La distribución final es:

```text
Internet
   |
 R-NCC
   |
   +---------- DMZ 192.168.10.0/24
   |              |
   |              +-- W-NCC 192.168.10.10
   |              +-- F-NCC 192.168.10.20
   |
   +---------- Intranet 192.168.20.0/24
                  |
                  +-- Windows
                  +-- Linux

W-NCC 192.168.30.1
        |
        | Backend 192.168.30.0/24
        |
B-NCC 192.168.30.10
```

Una decisión importante fue que B-NCC no quedara conectado directamente a R-NCC.

## **Aislamiento de B-NCC**

B-NCC se dejó dentro de una red backend privada.

Se eliminó su interfaz Default de IsardVDI y la configuración final mantuvo la interfaz backend:

```text
192.168.30.10/24
```

W-NCC utiliza:

```text
192.168.30.1/24
```

para acceder a la base de datos.

Esto permite que la base de datos no sea accesible directamente desde la Intranet o la DMZ.

## **Seguridad de MySQL**

MySQL se configuró para escuchar en:

```text
192.168.30.10:3306
```

mediante:

```text
bind-address = 192.168.30.10
```

También se restringieron los accesos con UFW.

Las reglas principales permiten únicamente desde W-NCC:

```text
3306/tcp desde 192.168.30.1
22/tcp   desde 192.168.30.1
```

Se comprobó además una prueba negativa donde un origen no autorizado recibió:

```text
ERROR 1130
Host is not allowed to connect
```

Esta prueba demostró que la restricción por origen funcionaba.

## **Integración W-NCC y B-NCC**

La aplicación web quedó conectada con la base de datos mediante la red backend.

Desde W-NCC se comprobó:

```sql
SELECT COUNT(*) FROM equipaments;
```

Resultado:

```text
889
```

Con esto se completó uno de los objetivos que había quedado pendiente en el MVP anterior: integrar la capa web con la capa de datos.

## **Autenticación web**

Se implementó autenticación mediante una tabla de usuarios.

Los roles utilizados son:

```text
lector
admin
```

Las contraseñas web se almacenan mediante hashes bcrypt y se validan con `password_verify()`.

El usuario lector puede consultar información.

El administrador puede realizar operaciones CRUD.

## **Control de permisos**

Las rutas administrativas se protegieron en el servidor.

Un usuario lector que intenta acceder directamente a una ruta administrativa recibe:

```text
HTTP 403
Acceso denegado. Se requieren permisos de administrador.
```

Esto demuestra que la seguridad no depende únicamente de ocultar botones de la interfaz.

## **CRUD**

La aplicación permite:

- CREATE
- READ
- UPDATE
- DELETE

Se validaron operaciones de creación y modificación.

La edición mostró correctamente:

```text
Equipamiento modificado correctamente.
```

También se comprobó la protección de la eliminación frente a usuarios sin permisos.

## **Datos mostrados en la web**

La tabla MySQL contiene:

```text
889 filas
```

La aplicación agrupa registros por `register_id`, por lo que la vista web muestra aproximadamente 622 equipamientos distintos.

Se documentó esta diferencia para evitar interpretarla como una pérdida de información.

## **DHCP en R-NCC**

R-NCC proporciona DHCP a la Intranet.

Durante las pruebas, Windows recibió:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

Los logs de `isc-dhcp-server` mostraron el proceso de concesión.

## **DNS interno**

R-NCC utiliza BIND9.

Dominio:

```text
asix3jyt.local
```

Registros principales:

```text
r-ncc.asix3jyt.local -> 192.168.20.1
w-ncc.asix3jyt.local -> 192.168.10.10
f-ncc.asix3jyt.local -> 192.168.10.20
```

## **NAT y salida a Internet**

Se configuraron reglas MASQUERADE para:

```text
192.168.20.0/24
192.168.10.0/24
```

Las reglas se hicieron persistentes mediante:

```text
/etc/ufw/before.rules
```

Para validar realmente el NAT desde Windows se eliminó temporalmente la ruta directa de IsardVDI.

Después Windows utilizó:

```text
192.168.20.1
```

como gateway y pudo hacer:

```text
ping 8.8.8.8
```

Los contadores NAT de R-NCC confirmaron que el tráfico atravesaba el router.

## **FTP en F-NCC**

F-NCC quedó configurado en:

```text
192.168.10.20
```

Se añadió una ruta de retorno hacia:

```text
192.168.20.0/24 via 192.168.10.1
```

La ruta se hizo persistente.

Desde Windows se validó:

```text
Test-NetConnection 192.168.10.20 -Port 21
```

y una sesión FTP real.

Se probaron:

```text
ls
get prueba_ftp.txt
put subida_windows.txt
```

Esto demostró transferencia bidireccional.

## **Revisión de documentación**

Durante la misma sesión se realizó una revisión importante del repositorio.

Se actualizaron:

- README principal
- arquitectura
- R-NCC
- W-NCC
- B-NCC
- F-NCC
- cliente Windows
- cliente Linux
- servicios
- seguridad y firewall
- instalación
- mantenimiento
- incidencias
- documentación de usuario

También se añadió un manual FTP para el usuario.

## **Incidencias documentadas**

Se recopilaron problemas reales encontrados durante el proyecto, entre ellos:

- configuración duplicada de NGINX
- hash de contraseña incorrecto
- interfaz exterior innecesaria en B-NCC
- cambio de numeración de interfaces
- SSH demasiado abierto
- NAT no configurado o no persistente
- doble gateway en Windows
- ruta de retorno de F-NCC
- diferencia entre 889 filas y equipamientos agrupados

Cada incidencia quedó asociada a su solución o explicación.

## **Resultado de la sesión**

Al finalizar el 23/11/2026 se consiguió una infraestructura mucho más cercana al estado final del proyecto.

Quedaron validados:

- arquitectura segmentada
- DHCP
- DNS
- routing
- NAT
- NGINX
- PHP
- MySQL
- conexión W-NCC → B-NCC
- autenticación
- roles
- CRUD
- FTP
- restricciones de seguridad
- documentación de administrador
- documentación de usuario

## **Trabajo pendiente**

El principal trabajo pendiente es recopilar las evidencias visuales definitivas:

📷 capturas de servicios activos  
📷 pruebas DHCP y DNS  
📷 contadores NAT  
📷 UFW  
📷 login y roles  
📷 CRUD  
📷 FTP  
📷 pruebas negativas  

También queda realizar una revisión final contra la rúbrica y mantener ProofHub actualizado con el estado real de las tareas.

## **Conclusión**

Esta sesión permitió pasar de una infraestructura básica del primer MVP a una arquitectura multicapa integrada y documentada.

La principal evolución respecto al MVP anterior es que W-NCC y B-NCC ya están comunicados mediante una red backend privada, la aplicación dispone de autenticación y CRUD, y los servicios de red han sido validados mediante pruebas reales.
