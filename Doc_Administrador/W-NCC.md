# W-NCC

## 1. Función de W-NCC

W-NCC es el servidor web principal de la infraestructura del proyecto **P.0-ASIXc2A-G03**.

Su función es alojar la aplicación web y actuar como punto intermedio entre los clientes y la base de datos.

W-NCC está situado en la DMZ y dispone además de una segunda interfaz conectada a la red backend privada.

Sus funciones principales son:

- servidor web NGINX
- ejecución de PHP
- acceso a la base de datos MySQL
- autenticación de usuarios
- gestión de sesiones
- control de roles
- operaciones CRUD
- acceso privado a B-NCC

---

## 2. Redes de W-NCC

W-NCC dispone de dos interfaces principales dentro de la arquitectura del proyecto.

### Interfaz DMZ

Dirección:

```text
192.168.10.10/24
```

Esta interfaz permite que los clientes de la Intranet accedan a la aplicación web.

La comunicación pasa por R-NCC.

---

### Interfaz backend

Dirección:

```text
192.168.30.1/24
```

Esta interfaz conecta W-NCC directamente con B-NCC.

La red utilizada es:

```text
192.168.30.0/24
```

La función de esta red es permitir la comunicación con MySQL sin exponer B-NCC directamente a la DMZ o a la Intranet.

---

## 3. Esquema de comunicación

El flujo principal de la aplicación es:

```text
Cliente Windows / Linux
        |
        |
     R-NCC
        |
        |
     W-NCC
192.168.10.10
        |
        |
Backend privado
192.168.30.0/24
        |
        |
     B-NCC
192.168.30.10
```

W-NCC es el único servidor de la aplicación que accede directamente a MySQL.

---

## 4. Tecnologías utilizadas

Las tecnologías principales utilizadas en W-NCC son:

- Ubuntu Server
- NGINX
- PHP 8.1
- PHP-FPM
- PDO MySQL
- HTML
- sesiones PHP
- MySQL como sistema de datos externo

Estas tecnologías permiten separar la capa de presentación de la capa de datos.

---

## 5. NGINX

NGINX se utiliza como servidor web.

Su función es recibir las peticiones HTTP y entregar el contenido de la aplicación.

También se encarga de enviar los archivos PHP hacia PHP-FPM para su procesamiento.

El directorio principal utilizado por la aplicación es:

```text
/var/www/html/
```

---

## 6. Estructura principal de la aplicación

La aplicación contiene diferentes archivos organizados según su función.

```text
/var/www/html/
|
|-- login.php
|-- logout.php
|-- dbtest.php
|
|-- includes/
|   |
|   |-- auth.php
|
|-- equipaments/
    |
    |-- index.php
    |-- create.php
    |-- edit.php
    |-- delete.php
```

Además, las configuraciones de conexión a MySQL están separadas del directorio público.

```text
/var/www/config/
|
|-- database.php
|-- database_admin.php
```

Esto evita guardar la configuración de conexión directamente dentro de los archivos principales de la aplicación.

---

## 7. Configuración de NGINX

La configuración de NGINX permite servir contenido PHP.

El servidor debe enviar los archivos `.php` hacia PHP-FPM.

Durante el despliegue se detectó un problema causado por una configuración duplicada dentro de:

```text
/etc/nginx/sites-enabled/
```

Existía una copia:

```text
default.backup
```

NGINX intentaba cargar tanto el archivo principal como la copia.

La solución fue mover el archivo de backup fuera de `sites-enabled`.

```bash
sudo mv /etc/nginx/sites-enabled/default.backup /etc/nginx/default.backup
```

Posteriormente se validó la configuración de NGINX.

```bash
sudo nginx -t
```

Después de corregir el problema, la configuración fue válida.

---

## 8. PHP

La aplicación utiliza PHP para procesar las peticiones del usuario y comunicarse con la base de datos.

Versión utilizada:

```text
PHP 8.1
```

PHP se ejecuta mediante PHP-FPM.

Las funciones principales implementadas con PHP son:

- autenticación
- sesiones
- acceso a MySQL
- control de roles
- consulta de datos
- creación de registros
- modificación de registros
- eliminación de registros

---

## 9. Conexión con B-NCC

W-NCC accede a la base de datos mediante la interfaz backend.

Servidor MySQL:

```text
192.168.30.10
```

Puerto:

```text
3306
```

El origen utilizado por W-NCC es:

```text
192.168.30.1
```

B-NCC únicamente permite conexiones MySQL desde esta dirección.

---

## 10. Archivos de conexión

La aplicación utiliza dos archivos diferentes para conectarse a la base de datos.

### `database.php`

Este archivo utiliza el usuario MySQL de lectura.

Usuario:

```text
bchecker
```

Su función principal es realizar consultas.

Permiso principal:

```text
SELECT
```

---

### `database_admin.php`

Este archivo utiliza el usuario MySQL administrativo de la aplicación.

Usuario:

```text
web_admin
```

Permisos:

```text
SELECT
INSERT
UPDATE
DELETE
```

Este usuario se utiliza para las operaciones CRUD administrativas.

---

## 11. Separación de permisos

La separación entre los dos usuarios MySQL permite aplicar el principio de mínimo privilegio.

El usuario normal no necesita permisos de modificación.

Por esta razón:

```text
bchecker
```

solo dispone de permisos de lectura.

Las operaciones de modificación utilizan:

```text
web_admin
```

Esto evita utilizar una cuenta con permisos elevados para todas las consultas.

---

## 12. Autenticación web

La aplicación dispone de un sistema de login.

Archivo principal:

```text
/login.php
```

El usuario introduce sus credenciales.

La aplicación consulta la tabla:

```text
usuarios
```

Si las credenciales son correctas, se crea una sesión PHP.

---

## 13. Tabla de usuarios

La tabla utilizada para la autenticación contiene los siguientes campos principales:

```text
id
username
password_hash
rol
```

Los roles disponibles son:

```text
lector
admin
```

Las contraseñas no se guardan en texto plano.

Se utilizan funciones de PHP para gestionar los hashes.

```php
password_hash()
password_verify()
```

---

## 14. Usuarios de la aplicación

### Usuario lector

```text
bchecker
```

Rol:

```text
lector
```

Este usuario puede:

- iniciar sesión
- consultar equipamientos
- navegar por la tabla
- cambiar de página

No puede:

- crear registros
- editar registros
- eliminar registros

---

### Usuario administrador

```text
web_admin
```

Rol:

```text
admin
```

Este usuario puede:

- consultar datos
- crear equipamientos
- editar equipamientos
- eliminar equipamientos

---

## 15. Control de sesiones

El archivo:

```text
/includes/auth.php
```

se encarga de gestionar el control de acceso.

La aplicación utiliza sesiones PHP.

Las funciones principales son equivalentes a:

```php
requireLogin()
requireAdmin()
isAdmin()
```

---

## 16. `requireLogin()`

Esta función comprueba que exista una sesión válida.

Si el usuario no ha iniciado sesión, se redirige hacia:

```text
/login.php
```

Esto evita acceder directamente a las páginas internas sin autenticación.

---

## 17. `requireAdmin()`

Esta función comprueba que el usuario tenga rol administrativo.

La condición utilizada es:

```php
$_SESSION['rol'] === 'admin'
```

Si un usuario lector intenta acceder a una página administrativa, la aplicación responde con:

```text
Acceso denegado. Se requieren permisos de administrador.
```

Además se devuelve un código HTTP:

```text
403
```

Esto demuestra que el control de acceso no depende únicamente de ocultar botones en la interfaz.

---

## 18. Protección de rutas

Las páginas administrativas están protegidas individualmente.

Entre ellas:

```text
/equipaments/create.php
/equipaments/edit.php
/equipaments/delete.php
```

Aunque un usuario lector escriba manualmente estas URLs, no puede ejecutar operaciones administrativas.

Esta medida evita saltarse el sistema de permisos mediante acceso directo.

---

## 19. Lectura de datos

La página principal de equipamientos es:

```text
/equipaments/index.php
```

La aplicación muestra los datos almacenados en MySQL.

La base de datos contiene:

```text
889 registros
```

La vista web agrupa los registros mediante:

```sql
COUNT(DISTINCT register_id)
```

Por esta razón, la interfaz muestra aproximadamente:

```text
622 equipamientos
```

mientras que la tabla original contiene 889 filas.

Esto no representa una pérdida de datos.

Es una consecuencia del agrupamiento utilizado en la vista.

---

## 20. Paginación

La aplicación utiliza paginación para evitar mostrar todos los registros en una única página.

Número de elementos por página:

```text
25
```

Esto mejora la navegación y evita generar una página excesivamente grande.

---

## 21. CRUD

La aplicación implementa las cuatro operaciones principales de gestión de datos.

```text
CREATE
READ
UPDATE
DELETE
```

---

## 22. CREATE

Archivo:

```text
/equipaments/create.php
```

Permite añadir nuevos equipamientos.

Solo los usuarios con rol:

```text
admin
```

pueden acceder.

El formulario incluye campos para introducir la información del equipamiento.

Algunos campos utilizan listas desplegables para reducir errores de escritura.

---

## 23. Distritos disponibles

El formulario de creación utiliza una selección de distritos.

Entre ellos:

```text
Ciutat Vella
Eixample
Gràcia
Horta-Guinardó
Les Corts
Nou Barris
Sant Andreu
Sant Martí
Sants-Montjuïc
Sarrià-Sant Gervasi
```

---

## 24. Municipios disponibles

El campo de municipio permite seleccionar:

```text
BARCELONA
SANT ADRIA BESOS
```

Esto permite mantener valores consistentes dentro de la base de datos.

---

## 25. READ

La consulta principal se realiza desde:

```text
/equipaments/index.php
```

Puede ser utilizada tanto por:

```text
lector
admin
```

La diferencia es que el administrador visualiza además las acciones de modificación.

---

## 26. UPDATE

Archivo:

```text
/equipaments/edit.php
```

Permite modificar un registro existente.

Solo puede acceder un usuario administrador.

Durante las pruebas se verificó la modificación de un equipamiento.

La aplicación mostró el mensaje:

```text
Equipamiento modificado correctamente.
```

---

## 27. DELETE

Archivo:

```text
/equipaments/delete.php
```

Permite eliminar un registro.

La operación está protegida mediante:

```text
requireAdmin()
```

Antes de eliminar el registro se muestra una confirmación.

Esto reduce el riesgo de borrar información accidentalmente.

---

## 28. Logout

La aplicación dispone de:

```text
/logout.php
```

Su función es cerrar la sesión activa.

Después del logout, el usuario debe volver a autenticarse para entrar en las páginas protegidas.

---

## 29. Prueba del usuario lector

El comportamiento esperado del lector es:

```text
Login correcto
      |
      v
Consulta de equipamientos
      |
      v
Sin opciones de edición
```

Si intenta entrar manualmente a una ruta administrativa:

```text
HTTP 403
Acceso denegado
```

Esto confirma que el control de permisos funciona en el servidor.

---

## 30. Prueba del usuario administrador

El comportamiento esperado del administrador es:

```text
Login correcto
      |
      v
Consulta de equipamientos
      |
      +-- Crear
      |
      +-- Editar
      |
      +-- Eliminar
```

Las pruebas realizadas confirmaron las operaciones CRUD.

---

## 31. Comunicación MySQL

Desde W-NCC se comprobó la conexión hacia B-NCC.

Servidor:

```text
192.168.30.10
```

Usuario de prueba:

```text
bchecker
```

La consulta utilizada fue:

```sql
USE equipaments;
SELECT COUNT(*) FROM equipaments;
```

Resultado:

```text
889
```

Esto demuestra la comunicación entre la capa web y la capa de datos.

---

## 32. Seguridad de la comunicación

La conexión MySQL no utiliza la interfaz de la DMZ.

El flujo es:

```text
W-NCC
192.168.30.1
      |
      |
B-NCC
192.168.30.10
```

La comunicación se mantiene dentro de la red backend.

Además, B-NCC limita el puerto 3306 a:

```text
192.168.30.1
```

Esto impide conexiones MySQL desde otros equipos.

---

## 33. Dependencias

W-NCC depende principalmente de:

### R-NCC

Para recibir conexiones desde los clientes de la Intranet.

### B-NCC

Para consultar y modificar la base de datos.

### NGINX

Para atender las peticiones HTTP.

### PHP-FPM

Para ejecutar los archivos PHP.

### MySQL

Para obtener los datos de la aplicación.

---

## 34. Riesgos

### Caída de NGINX

La aplicación deja de estar disponible.

### Caída de PHP-FPM

NGINX puede seguir funcionando, pero los archivos PHP no se procesarán correctamente.

### Caída de B-NCC

La aplicación puede responder, pero no podrá acceder a los datos.

### Error de permisos

Una mala configuración puede dar acceso administrativo a un usuario incorrecto.

### Error de configuración de NGINX

Puede impedir la ejecución de PHP.

### Pérdida de la interfaz backend

W-NCC deja de poder acceder a MySQL.

---

## 35. Diagnóstico

### Comprobar interfaces

```bash
ip a
```

### Comprobar rutas

```bash
ip route
```

### Comprobar NGINX

```bash
sudo systemctl status nginx
```

### Validar NGINX

```bash
sudo nginx -t
```

### Comprobar PHP-FPM

```bash
sudo systemctl status php8.1-fpm
```

### Comprobar puerto web

```bash
sudo ss -lntp
```

### Comprobar conexión a MySQL

```bash
mysql -h 192.168.30.10 -u bchecker -p
```

---

## 36. Criterios de validación

W-NCC se considera correctamente configurado cuando:

- [x] dispone de dirección en la DMZ
- [x] dispone de dirección en la red backend
- [x] NGINX funciona
- [x] PHP funciona
- [x] PHP-FPM funciona
- [x] puede conectarse con B-NCC
- [x] la aplicación muestra los datos
- [x] el login funciona
- [x] las sesiones funcionan
- [x] el usuario lector puede consultar
- [x] el lector no puede modificar
- [x] el administrador puede crear
- [x] el administrador puede editar
- [x] el administrador puede eliminar
- [x] las rutas administrativas están protegidas
- [x] el logout funciona

---

## 37. Evidencias pendientes de añadir

Las capturas reales se añadirán en la fase final de documentación.

Las principales evidencias que conviene guardar son:

📸 NGINX activo.

📸 Resultado de:

```bash
sudo nginx -t
```

📸 Conexión MySQL desde W-NCC mostrando los 889 registros.

📸 Pantalla de login.

📸 Vista del usuario lector.

📸 Error 403 al intentar entrar como lector a una ruta administrativa.

📸 Vista del usuario administrador.

📸 Formulario de creación.

📸 Modificación correcta.

📸 Confirmación de eliminación.

Estas evidencias se incorporarán cuando se realice la revisión final de capturas.

---

## 38. Conclusión

W-NCC representa la capa web de la arquitectura multicapa.

Recibe las peticiones de los clientes desde la DMZ y se comunica con B-NCC mediante una red backend privada.

La separación de usuarios, roles y cuentas MySQL permite controlar mejor los permisos.

La aplicación implementa autenticación, sesiones y un CRUD completo, manteniendo la base de datos separada de las redes de usuario.
