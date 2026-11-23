# **Sprint 2 - 03/11/2026**

**Integrantes:** Taylor Uriña y Steephen Garcia  
**Sprint:** Sprint 2  
**Fecha:** 03/11/2026

## **Objetivo de la sesión**

Durante esta sesión se continuó mejorando la documentación técnica de la infraestructura y se amplió la información sobre los principales servidores y servicios.

El objetivo fue que la documentación reflejara con mayor detalle cómo se estaban desplegando los componentes del proyecto y qué función cumplía cada uno.

## **Ampliación de W-NCC**

Se actualizó la documentación de W-NCC para describir mejor su función como servidor web.

Se documentaron aspectos como:

- NGINX
- estructura del servidor web
- comunicación con otros componentes
- función de la capa web dentro de la arquitectura

En esta fase W-NCC pasó a estar documentado como uno de los componentes centrales de la aplicación multicapa.

## **Ampliación de B-NCC**

También se amplió la documentación de B-NCC.

Se añadieron apartados relacionados con:

- instalación de MySQL
- función del servidor de base de datos
- base de datos `equipaments`
- importación de datos
- consultas de comprobación
- mantenimiento del servicio

La base de datos contenía:

```text
889 registros
```

procedentes del CSV utilizado en el proyecto.

## **Cliente Linux**

Se añadió documentación específica para el cliente Linux.

El cliente se utilizaba como equipo de pruebas dentro de la Intranet y permitía comprobar:

- conectividad
- routing
- acceso a servicios
- SSH
- funcionamiento general de la red

## **Servicios de la infraestructura**

También se añadió una documentación conjunta de servicios.

Se empezaron a recoger servicios como:

- SSH
- NGINX
- MySQL
- FTP
- DNS
- DHCP
- firewall

La intención era disponer de una visión general que complementara los documentos individuales de cada máquina.

## **Mejora de la trazabilidad**

La documentación empezó a incluir con más claridad:

- función de cada servicio
- puerto utilizado
- máquina responsable
- relación entre componentes
- comprobaciones básicas
- dependencias

Esto facilita tanto la administración como la evaluación del proyecto.

## **Resultado de la sesión**

Al finalizar la sesión del 03/11/2026:

- W-NCC estaba mejor documentado
- B-NCC disponía de una documentación más completa
- el cliente Linux tenía un apartado propio
- se documentaron conjuntamente los principales servicios de red
- la estructura técnica del repositorio era más clara

La documentación todavía seguiría evolucionando, ya que posteriormente se realizaron cambios importantes en la arquitectura, seguridad, autenticación y comunicación entre servidores.

## **Evidencias**

📷 Historial de commits del 03/11/2026.

📷 Documentación de W-NCC.

📷 Documentación de B-NCC.

📷 Documento de servicios.
