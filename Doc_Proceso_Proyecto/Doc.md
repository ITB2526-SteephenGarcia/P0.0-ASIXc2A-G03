# **Proceso del proyecto**

Esta carpeta recoge la evolución cronológica del proyecto **P.0-ASIXc2A-G03**.

La documentación de proceso permite ver cómo la infraestructura ha evolucionado desde la planificación inicial hasta una arquitectura multicapa integrada.

## **Integrantes**

- Taylor Uriña
- Steephen Garcia

## **Estudio previo**

- [Estudio previo y justificación de tecnologías](./Estudio_Previo_Tecnologias.md)

## **Planificación consolidada**

- [Planificación, recursos, responsables y riesgos](./Planificacion_Recursos_Riesgos.md)

## **Cronología**

### Sprint 1

- [07/10/2026 - Planificación inicial](./Sprint.1_07_10_26.md)
- [14/10/2026 - Revisión y cierre de planificación](./Sprint.1_14_10_26.md)
- [20/10/2026 - Inicio del despliegue técnico](./Sprint.1_20_10_26.md)
- [21/10/2026 - W-NCC y NGINX](./Sprint.1_21_10_26.md)
- [27/10/2026 - MVP 1](./Sprint.1_27_10_26_mvp.md)

### Sprint 2

- [28/10/2026 - Reorganización de documentación y arquitectura](./Sprint.2_28_10_26.md)
- [03/11/2026 - Ampliación de documentación técnica](./Sprint.2_03_11_26.md)
- [23/11/2026 - Integración, seguridad y validación final](./Sprint.2_23_11_26.md)

## **Evolución general**

### Primera fase

El proyecto comenzó con la planificación y organización de tareas mediante ProofHub.

### Segunda fase

Se desplegaron las redes principales, R-NCC, los clientes y W-NCC.

### Primer MVP

Se demostró una infraestructura básica con:

- Intranet
- DMZ
- NGINX
- MySQL
- 889 registros importados
- conectividad básica

En ese momento W-NCC y B-NCC todavía no estaban integrados.

### Evolución posterior

La arquitectura se mejoró mediante una red backend privada:

```text
192.168.30.0/24
```

W-NCC quedó como único equipo autorizado para acceder directamente a B-NCC.

También se implementaron y validaron:

- DHCP
- DNS
- NAT
- FTP
- autenticación
- sesiones
- roles
- CRUD
- UFW
- restricciones MySQL
- pruebas negativas

## **Herramientas de seguimiento**

Durante el proyecto se han utilizado principalmente:

- ProofHub para planificación y seguimiento
- GitHub para documentación y control de cambios
- IsardVDI para la infraestructura virtual
- terminales Linux y Windows para configuración y pruebas

## **Objetivo de esta documentación**

Esta carpeta no pretende sustituir la documentación técnica.

Su objetivo es mostrar:

- qué se hizo en cada sesión
- cómo evolucionó la arquitectura
- qué problemas aparecieron
- qué decisiones se tomaron
- qué tareas quedaron pendientes
- cómo se llegó al estado final del proyecto

La documentación técnica completa se encuentra en [Doc_Administrador](../Doc_Administrador/).
