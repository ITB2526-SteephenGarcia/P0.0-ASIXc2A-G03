# **Sprint 1 - 21/10/2026**

**Integrantes:** Taylor Uriña y Steephen Garcia**Sprint:** Sprint 1**Fecha:** 21/10/2026

## **Objetivo de la sesión**

Durante esta sesión continuamos ampliando la infraestructura que habíamos empezado a montar el día anterior.

El objetivo principal fue empezar a trabajar con el **servidor web ****W-NCC**, conectarlo correctamente a la red DMZ y comprobar que podía comunicarse con el router.

También se instaló y configuró el servicio web para poder mostrar una primera página desde el servidor.

## **Creación del servidor web W-NCC**

Se creó una nueva máquina virtual que tendría la función de **servidor web** dentro de la infraestructura.

Este servidor se llamó:

W-NCC

La máquina se conectó a la red DMZ, ya que esta red estaba pensada para alojar los servicios que estarían más expuestos que los equipos de la Intranet.

La dirección prevista para este servidor dentro de la DMZ fue:

W-NCC: 192.168.10.10/24

La red DMZ utilizada era:

192.168.10.0/24

y el router dentro de esta red tenía la dirección:

R-NCC: 192.168.10.1/24

## **Conexión del servidor a la DMZ**

Una vez creada la máquina, se configuró su interfaz de red para que estuviera conectada a la DMZ.

Después se comprobó la configuración de red y se realizaron pruebas para verificar que el servidor podía comunicarse correctamente con R-NCC.

Una de las pruebas realizadas fue:

ping 192.168.10.1

Con esta prueba pudimos comprobar que W-NCC tenía conectividad con la interfaz DMZ del router.

Esto confirmaba que la máquina estaba conectada correctamente a la red que habíamos preparado.

📷 Añadir captura del ping entre W-NCC y R-NCC.

## **Instalación de NGINX**

Una vez comprobada la conexión de red, se instaló **NGINX** como servidor web.

NGINX sería el servicio encargado de responder a las peticiones HTTP y mostrar la página web alojada en W-NCC.

La instalación se realizó utilizando el gestor de paquetes del sistema.

sudo apt update

sudo apt install nginx -y

Después de la instalación se comprobó que el servicio estaba funcionando.

Por ejemplo:

sudo systemctl status nginx

Con esto pudimos verificar que NGINX se había iniciado correctamente.

📷 Añadir captura del estado del servicio NGINX.

## 

## **Primera página web**

Con NGINX funcionando se preparó una primera página web básica.

En esta fase el objetivo no era todavía conectar la página con la base de datos, sino comprobar primero que el servidor web era capaz de mostrar contenido correctamente.

Al acceder al servidor web desde un navegador se pudo comprobar que la página respondía correctamente.

Esto nos permitió confirmar que:

* El servidor W-NCC estaba operativo.
* La configuración de red funcionaba.
* NGINX estaba instalado.
* El servicio HTTP respondía correctamente.

📷 Añadir captura de la página abierta desde un navegador.

## **Situación de la conexión con la base de datos**

La idea final del proyecto es que el servidor web pueda obtener información de la base de datos y mostrarla en la página.

La comunicación prevista será:

W-NCC

  |

  | DMZ

  |

R-NCC

  |

  | Intranet

  |

B-NCC

  |

 MySQL

En esta sesión todavía no se configuró esta conexión.

Por ahora dejamos funcionando el servidor web de forma independiente y la conexión entre W-NCC y la base de datos se realizaría más adelante como una nueva mejora del proyecto.

## 

## **Pruebas realizadas**

Durante esta sesión se realizaron varias comprobaciones para verificar el funcionamiento del servidor.

### **Conectividad con el router**

Se comprobó que W-NCC podía comunicarse con R-NCC mediante la red DMZ:

ping 192.168.10.1

### **Estado de NGINX**

Se comprobó que el servicio estaba iniciado:

sudo systemctl status nginx

### **Acceso web**

Finalmente se accedió a la dirección del servidor desde un navegador para comprobar que la página web se mostraba correctamente.

## **Seguimiento en ProofHub**

También se actualizaron las tareas relacionadas con el servidor web.

Se reflejó el progreso de tareas como:

* Creación de W-NCC.
* Configuración de su conexión a la DMZ.
* Instalación de NGINX.
* Configuración inicial del servidor web.
* Pruebas de funcionamiento.

📷 Añadir captura de las tareas relacionadas con W-NCC en ProofHub.

## 

## 

## 

## **Resultado de la sesión**

Al finalizar la sesión del **21/10/2026** ya disponíamos de un servidor web funcionando dentro de la DMZ.

Se consiguió:

* Crear el servidor W-NCC.
* Conectarlo a la red 192.168.10.0/24.
* Configurar su dirección IP.
* Comprobar la conexión con R-NCC.
* Instalar NGINX.
* Comprobar que el servicio web estaba activo.
* Mostrar una primera página web.
* Actualizar las tareas correspondientes en ProofHub.

Con esto ya teníamos funcionando una nueva parte de la infraestructura.

La conexión entre el servidor web y la base de datos quedaría para una siguiente fase.

## **Evidencias**

### **W-NCC**

### **Conectividad con R-NCC**

### **NGINX**

### **Página web**

### **ProofHub**

