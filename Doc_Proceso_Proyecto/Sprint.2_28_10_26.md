# **Sprint 2 - 28/10/2026**

**Integrantes:** Taylor Uriña y Steephen Garcia  
**Sprint:** Sprint 2  
**Fecha:** 28/10/2026

## **Objetivo de la sesión**

Después de completar el primer MVP, durante esta sesión comenzamos una nueva fase centrada en ordenar la documentación y revisar la arquitectura antes de continuar ampliando los servicios.

El objetivo principal fue dejar una estructura de documentación más clara en GitHub y corregir algunos elementos de la arquitectura que habían quedado representados de forma demasiado simplificada durante el primer MVP.

## **Reorganización de la documentación**

Durante esta sesión se reorganizaron las carpetas del repositorio para separar mejor la información según su destinatario y función.

Se empezó a estructurar la documentación en apartados como:

- documentación de administrador
- documentación de usuario
- documentación del proceso del proyecto
- configuraciones
- scripts

Dentro de la documentación de administrador se crearon archivos específicos para:

- arquitectura
- R-NCC
- W-NCC
- B-NCC
- F-NCC
- cliente Linux
- cliente Windows
- servicios
- seguridad y firewall
- instalación
- mantenimiento
- incidencias

Esta separación facilita localizar la información y evita concentrar todo el proyecto en un único README.

## **Revisión de la arquitectura**

También se revisó el esquema de red.

Las redes principales continuaron siendo:

```text
DMZ      -> 192.168.10.0/24
Intranet -> 192.168.20.0/24
```

Durante esta fase empezó a quedar más clara la necesidad de separar la base de datos de la red de clientes.

La arquitectura evolucionaría posteriormente hasta utilizar una red backend privada:

```text
192.168.30.0/24
```

para la comunicación entre W-NCC y B-NCC.

Esta decisión permitió mejorar el aislamiento de la base de datos.

## **Documentación de administrador**

Se creó la estructura inicial de la documentación técnica.

El objetivo era que cada máquina tuviera su propio documento y que un administrador pudiera consultar de forma independiente:

- función del equipo
- red utilizada
- servicios
- configuración
- pruebas
- mantenimiento
- seguridad

## **Documentación de usuario**

También se creó una primera versión de la documentación destinada al usuario.

En ese momento todavía existían partes del proyecto que estaban pendientes de integración, por lo que algunos textos se redactaron inicialmente como funciones previstas.

Más adelante esta documentación se actualizaría para reflejar el funcionamiento real de la aplicación.

## **Cambios registrados en GitHub**

Durante esta sesión se realizaron múltiples cambios en la estructura del repositorio.

Entre ellos:

- reorganización de carpetas
- creación de archivos de documentación
- corrección de nombres de archivos
- revisión del esquema de arquitectura
- creación de documentación de usuario
- creación de documentación de administrador

El historial de GitHub permite comprobar estos cambios realizados durante el 28/10/2026.

## **Resultado de la sesión**

Al finalizar la sesión:

- la documentación estaba mejor organizada
- cada servidor disponía de un apartado propio
- se separó documentación técnica y documentación de usuario
- se revisó la representación de la arquitectura
- se preparó el repositorio para documentar las siguientes mejoras técnicas

Esta sesión fue importante porque permitió pasar de una documentación inicial del MVP a una estructura más mantenible para el resto del proyecto.

## **Evidencias**

📷 Captura de la estructura del repositorio después de la reorganización.

📷 Captura del historial de commits del 28/10/2026.

📷 Captura del diagrama de arquitectura revisado.
