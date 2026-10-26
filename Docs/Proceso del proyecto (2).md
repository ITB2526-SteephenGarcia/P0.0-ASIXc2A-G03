# **Sprint 1 - 20/10/2026**

**Integrantes:** Taylor Uriña y Steephen Garcia**Sprint:** Sprint 1**Fecha:** 20/10/2026

## **Objetivo de la sesión**

Después de las primeras sesiones de planificación, en esta clase empezamos con el despliegue técnico de la infraestructura.

El objetivo principal fue crear las primeras máquinas virtuales, empezar a configurar las redes del proyecto y comprobar que existía conectividad entre los equipos.

## **Inicio de la infraestructura**

Durante esta sesión empezamos a montar en Isard la arquitectura que habíamos planteado anteriormente.

Nos centramos principalmente en:

* Preparar la red Intranet.
* Preparar la red DMZ.
* Configurar las primeras interfaces de red.
* Crear el cliente Linux.
* Realizar pruebas de conectividad.
* Empezar a trabajar con SSH.

La idea era comprobar primero que la comunicación entre máquinas funcionaba correctamente antes de continuar con la instalación de más servicios.

## **Configuración inicial de la DMZ**

Se empezó a preparar la red **DMZ**, que más adelante utilizaríamos para alojar servicios como el servidor web.

La red definida fue:

192.168.10.0/24

La interfaz del router conectada a esta red tendría la dirección:

R-NCC - DMZ: 192.168.10.1/24

De esta forma, los servicios de la DMZ quedarían separados de la red interna.

Esta separación será importante más adelante, ya que el servidor web estará situado en la DMZ, mientras que otros servicios internos, como la base de datos, estarán dentro de la Intranet.

📷 Añadir captura de la configuración de la interfaz DMZ en Isard o en el router.

## **Configuración inicial de la Intranet**

También se empezó a preparar la red **Intranet**, que sería utilizada por los clientes y los servidores internos.

La red definida fue:

192.168.20.0/24

La dirección del router dentro de esta red sería:

R-NCC - Intranet: 192.168.20.1/24

Dentro de esta red se irían conectando posteriormente:

* Cliente Linux.
* Cliente Windows.
* Servidor de base de datos B-NCC.

El router R-NCC sería el equipo encargado de comunicar las diferentes redes del proyecto.

## **Creación y configuración del cliente Linux**

Durante esta sesión también se creó el **cliente Linux** dentro de Isard.

Este equipo se conectó a la red Intranet y se configuró con la siguiente dirección:

192.168.20.20/24

El cliente Linux se utilizaría principalmente para:

* Realizar pruebas de red.
* Comprobar conectividad con otros equipos.
* Acceder de forma remota a servidores mediante SSH.
* Probar posteriormente otros servicios de la infraestructura.

## **Pruebas de conectividad**

Una vez configuradas las primeras direcciones IP, se realizaron pruebas utilizando el comando ping.

Por ejemplo:

ping 192.168.20.1

Con estas pruebas comprobamos que el cliente podía comunicarse correctamente con el router dentro de la red Intranet.

También se fueron revisando las interfaces de red de las máquinas para comprobar qué dirección IP tenía asignada cada una.

En Linux utilizamos comandos como:

ip a

Esto nos permitió verificar las interfaces disponibles y comprobar que cada una estaba conectada a la red correspondiente.

## **Configuración inicial de SSH**

Durante esta sesión también empezamos a trabajar con **SSH** para poder administrar las máquinas de forma remota.

Una conexión SSH se realiza utilizando:

ssh usuario@IP

Por ejemplo:

ssh bchecker@192.168.20.1

El uso de SSH nos permitiría trabajar con los servidores desde los clientes sin tener que abrir directamente la consola de cada máquina en Isard.

Además, conseguir una conexión SSH correcta nos servía como una segunda prueba de que la conectividad entre los equipos funcionaba.

📷 Añadir captura de una conexión SSH correcta.

## **Comprobación de interfaces y direcciones IP**

Durante la configuración fue necesario revisar varias veces las interfaces de red de las máquinas.

Como las máquinas virtuales podían tener más de una interfaz, era importante comprobar cuál correspondía a cada red.

Para ello utilizamos principalmente:

ip a

y pruebas de conectividad con:

ping IP_DESTINO

Antes de continuar con otros servicios, comprobamos que las direcciones IP configuradas coincidían con el direccionamiento que habíamos definido para la infraestructura.

## **Seguimiento en ProofHub**

Durante la sesión también fuimos actualizando ProofHub según avanzábamos con las tareas.

Las tareas relacionadas con redes, cliente Linux y SSH empezaron a pasar de pendientes a tareas en progreso o completadas.

ProofHub nos servía para ver de forma rápida:

* Qué tareas estaban hechas.
* Cuáles estaban en proceso.
* Qué configuraciones quedaban pendientes.
* Qué partes del Sprint todavía no habíamos empezado.

📷 Añadir captura del estado de ProofHub durante esta sesión.

## **Resultado de la sesión**

Al finalizar la sesión del **20/10/2026** ya teníamos una primera parte de la infraestructura desplegada.

Se consiguió avanzar en:

* Configuración inicial de la red DMZ 192.168.10.0/24.
* Configuración inicial de la Intranet 192.168.20.0/24.
* Configuración de las interfaces del router.
* Creación del cliente Linux.
* Asignación de la dirección 192.168.20.20/24.
* Pruebas de conectividad mediante ping.
* Revisión de interfaces mediante ip a.
* Primeras conexiones mediante SSH.
* Seguimiento de las tareas mediante ProofHub.

Con estas pruebas ya disponíamos de una base de red funcional para continuar añadiendo servidores y servicios durante las siguientes sesiones.

## **Evidencias**

### **Configuración de red**

### **Cliente Linux**

### **Prueba de conectividad**

### **SSH**

### **ProofHub**

