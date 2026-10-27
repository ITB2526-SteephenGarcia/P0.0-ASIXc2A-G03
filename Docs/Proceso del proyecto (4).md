# **MVP 1 - Infraestructura básica funcional**

## **Objetivo del MVP**

El objetivo de este primer MVP es demostrar que la infraestructura básica del proyecto ya está desplegada y que los principales equipos pueden comunicarse correctamente entre ellos.

En este punto queremos demostrar principalmente:

* Que el router R-NCC tiene configuradas la Intranet y la DMZ.
* Que los clientes pueden comunicarse dentro de la Intranet.
* Que el servidor web W-NCC está conectado a la DMZ.
* Que existe conectividad entre W-NCC y el router.
* Que B-NCC tiene MySQL instalado y funcionando.
* Que el CSV proporcionado para el proyecto se ha importado correctamente en MySQL.
* Que los datos almacenados en la base de datos pueden consultarse.

La conexión entre el servidor web y la base de datos se realizará en una siguiente iteración.

# **1. Comprobar la configuración del router**

Primero mostramos que R-NCC tiene las interfaces correspondientes a las diferentes redes.

En el router ejecutamos:

ip a

Queremos comprobar principalmente que aparecen las direcciones:

Intranet: 192.168.20.1/24

DMZ:      192.168.10.1/24

### **¿Qué queremos demostrar?**

Con esta prueba demostramos que R-NCC está conectado a las dos redes principales de nuestra infraestructura y que puede actuar como punto de unión entre ellas.

📷 Añadir captura de ip a en R-NCC.

# **2. Comprobar la conectividad de la Intranet**

Desde el cliente Linux podemos comprobar que existe comunicación con el router.

Ejecutamos:

ping 192.168.20.1

También podemos comprobar la comunicación con el servidor de base de datos:

ping 192.168.20.10

Si recibimos respuesta, significa que los equipos están correctamente conectados dentro de la Intranet.

### **Direccionamiento utilizado**

R-NCC:          192.168.20.1

B-NCC:          192.168.20.10

Cliente Linux:  192.168.20.20

Cliente Windows:192.168.20.30

### **¿Qué queremos demostrar?**

Que la red 192.168.20.0/24 funciona y que los equipos de la Intranet pueden comunicarse entre ellos.

📷 Añadir captura del ping desde el cliente Linux.

# **3. Comprobar el cliente Windows**

Desde Windows podemos comprobar también la configuración de red.

Ejecutamos:

ipconfig

Buscamos la interfaz conectada a la Intranet y comprobamos que tenga la dirección:

192.168.20.30/24

Después probamos la conectividad:

ping 192.168.20.10

Con esto comprobamos que el cliente Windows puede comunicarse con B-NCC.

### **¿Qué queremos demostrar?**

Que tenemos los dos clientes necesarios, Linux y Windows, funcionando dentro de la red interna.

📷 Añadir captura de ipconfig y del ping correcto.

# **4. Comprobar SSH**

También podemos demostrar que existe acceso remoto entre las máquinas.

Por ejemplo, desde uno de los clientes podemos ejecutar:

ssh bchecker@192.168.20.10

Si la conexión funciona, accederemos al servidor B-NCC.

Podemos comprobarlo con:

hostname

El resultado debería ser:

B-NCC

### **¿Qué queremos demostrar?**

Con esta prueba demostramos dos cosas:

* Que existe conectividad de red.
* Que el servicio SSH está funcionando correctamente.

📷 Añadir captura de la conexión SSH.

# **5. Comprobar el servidor web en la DMZ**

El servidor web W-NCC está conectado a la red DMZ.

Su direccionamiento es:

W-NCC: 192.168.10.10/24

R-NCC: 192.168.10.1/24

Desde W-NCC podemos comprobar la comunicación con el router:

ping 192.168.10.1

Si recibimos respuesta, significa que el servidor web está correctamente conectado a la DMZ.

También podemos comprobar el estado del servidor web:

sudo systemctl status nginx

El servicio debería aparecer como:

active (running)

Finalmente podemos acceder a la página desde un navegador utilizando la dirección del servidor.

### **¿Qué queremos demostrar?**

Que la DMZ está funcionando y que ya tenemos un servidor web operativo dentro de esta red.

📷 Añadir captura del ping.

📷 Añadir captura de NGINX funcionando.

📷 Añadir captura de la página web.

# **6. Comprobar el servidor de base de datos**

Entramos en B-NCC y comprobamos que MySQL está instalado y funcionando.

Podemos ejecutar:

sudo systemctl status mysql

Después accedemos a MySQL:

sudo mysql

Dentro de MySQL seleccionamos la base de datos:

USE equipaments;

Y mostramos las tablas:

SHOW TABLES;

Debería aparecer:

equipaments

### **¿Qué queremos demostrar?**

Que B-NCC está funcionando como servidor de base de datos y que MySQL tiene creada nuestra base de datos.

# **7. Comprobar que el CSV está importado**

El CSV proporcionado para el proyecto ya ha sido importado dentro de MySQL.

Podemos comprobar el número de registros con:

SELECT COUNT(*) FROM equipaments;

Actualmente el resultado es:

889

Con esto demostramos que hay **889 registros almacenados dentro de la tabla**.

Después podemos mostrar algunos datos reales:

SELECT name, addresses_district_name

FROM equipaments

LIMIT 10;

Esto debería mostrar diferentes centros educativos junto con su distrito.

Por ejemplo:

Facultat de Nàutica - UPC

Metàfora Centre d'Estudis

Escola Universitària Mediterrani

Institut Salvador Seguí

...

### **¿Qué queremos demostrar?**

Esta es una de las pruebas más importantes del MVP.

Demostramos que:

- El CSV fue descargado correctamente.
- Los datos fueron importados a MySQL.
- La información está almacenada dentro de B-NCC.
- Podemos realizar consultas sobre esos datos.

📷 Añadir captura del SELECT COUNT(*).

📷 Añadir captura mostrando varios registros.

# **8. Arquitectura demostrada en este MVP**

Actualmente W-NCC y B-NCC todavía no están integrados entre sí.

La conexión:

W-NCC → R-NCC → B-NCC → MySQL

se realizará en la siguiente iteración.

# **9. Resultado del MVP**

Al finalizar este primer MVP hemos conseguido tener una infraestructura básica funcional.

Actualmente tenemos:

* R-NCC conectado a la Intranet y a la DMZ.
* Cliente Linux funcionando dentro de la Intranet.
* Cliente Windows funcionando dentro de la Intranet.
* Comunicación mediante ping entre diferentes máquinas.
* Acceso remoto mediante SSH.
* W-NCC conectado a la DMZ.
* NGINX funcionando en W-NCC.
* Página web básica funcionando.
* B-NCC conectado a la Intranet.
* MySQL funcionando en B-NCC.
* Base de datos equipaments.
* CSV importado correctamente.
* 889 registros disponibles para realizar consultas.

Con este MVP comprobamos que la base de la infraestructura funciona antes de comenzar a conectar los diferentes servicios entre sí.

# **Siguiente MVP**

El siguiente objetivo será conectar el servidor web con el servidor de base de datos.

La comunicación que queremos conseguir será:

Una vez conseguida esta comunicación, la página web podrá consultar MySQL y mostrar los datos almacenados en la base de datos.

