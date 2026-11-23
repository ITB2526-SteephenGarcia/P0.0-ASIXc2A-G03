# Planificación, recursos, responsables y riesgos

## 1. Objetivo

Este documento consolida la planificación del proyecto **P.0-ASIXc2A-G03** para dejar en un único lugar las fases, responsables, recursos, cronología y principales riesgos.

Complementa la documentación por sprints y el seguimiento realizado mediante ProofHub.

## 2. Integrantes

- Taylor Uriña
- Steephen Garcia

## 3. Reparto general de responsabilidades

| Área | Responsable principal | Apoyo |
|---|---|---|
| Infraestructura de servidores | Taylor | Steephen |
| R-NCC, routing, DHCP, DNS, NAT | Taylor | Steephen |
| W-NCC y aplicación web | Taylor | Steephen |
| B-NCC y MySQL | Taylor | Steephen |
| F-NCC y FTP | Taylor | Steephen |
| Cliente Linux | Steephen | Taylor |
| Cliente Windows | Taylor | Steephen |
| Documentación | Ambos | Ambos |
| Pruebas y validación | Ambos | Ambos |
| Seguimiento en ProofHub | Ambos | Ambos |

## 4. Fases del proyecto

### Fase 1 — Análisis y planificación
- entender el enunciado
- identificar servidores, clientes y servicios
- definir redes
- organizar tareas
- preparar ProofHub

### Fase 2 — Despliegue de red
- crear Intranet
- crear DMZ
- configurar R-NCC
- probar conectividad

### Fase 3 — Servicios principales
- desplegar W-NCC
- instalar NGINX
- desplegar B-NCC
- instalar MySQL
- importar 889 registros

### Fase 4 — Integración multicapa

```text
W-NCC 192.168.30.1
        |
Backend 192.168.30.0/24
        |
B-NCC 192.168.30.10
```

### Fase 5 — Servicios de red
- DHCP
- DNS
- NAT
- firewall
- FTP

### Fase 6 — Aplicación web y seguridad
- login
- sesiones
- roles
- CRUD
- protección de rutas
- separación de permisos MySQL

### Fase 7 — Validación y documentación
- pruebas
- incidencias
- manuales
- revisión de rúbrica
- evidencias finales

## 5. Cronología real

| Fecha | Trabajo principal |
|---|---|
| 07/10/2026 | Análisis inicial y planificación |
| 14/10/2026 | Revisión de planificación |
| 20/10/2026 | Inicio de infraestructura y redes |
| 21/10/2026 | W-NCC y NGINX |
| 27/10/2026 | MVP 1 |
| 28/10/2026 | Reorganización de documentación |
| 03/11/2026 | Ampliación técnica |
| 23/11/2026 | Integración, seguridad y validación |

El detalle de cada sesión se encuentra en [Doc.md](./Doc.md).

## 6. Recursos utilizados

### Infraestructura
- IsardVDI
- máquinas virtuales Linux
- cliente Windows
- cliente Linux
- redes virtuales

### Software
- Ubuntu Server
- Windows
- NGINX
- PHP 8.1
- PHP-FPM
- MySQL 8
- BIND9
- isc-dhcp-server
- UFW
- SSH
- FTP

### Herramientas de gestión
- ProofHub
- GitHub
- navegador web
- terminal Linux
- PowerShell

## 7. Dependencias principales

| Componente | Depende de |
|---|---|
| Clientes | R-NCC |
| W-NCC | R-NCC y B-NCC |
| B-NCC | W-NCC para acceso autorizado |
| F-NCC | R-NCC |
| Aplicación web | NGINX, PHP-FPM, MySQL |
| Resolución interna | BIND9 |
| Configuración de clientes | DHCP |
| Salida a Internet | NAT de R-NCC |

## 8. Riesgos técnicos

| Riesgo | Impacto | Medida de mitigación |
|---|---|---|
| Error de routing | Alto | Validar rutas y gateways |
| MySQL expuesto | Alto | Backend privado, bind-address y UFW |
| Error DNS | Medio | Probar por IP y después por nombre |
| NAT incorrecto | Alto | Probar con R-NCC como único gateway |
| Configuración no persistente | Alto | Guardar reglas y rutas persistentes |
| Pérdida de datos | Alto | Copias de seguridad de configuración y BD |
| Permisos web incorrectos | Alto | Roles y protección en servidor |
| FTP bloqueado | Medio | Validar puerto, routing y transferencia real |
| Dependencia de R-NCC | Alto | Documentar recuperación y diagnóstico |

## 9. Riesgos organizativos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Reparto desigual de tareas | Medio | Revisión conjunta en ProofHub |
| Documentación atrasada | Alto | Documentar por sprints |
| Cambios no registrados | Medio | Uso de GitHub |
| Falta de evidencias | Alto | Lista final de capturas pendientes |
| Configuraciones diferentes entre integrantes | Medio | Documentación centralizada |

## 10. Seguimiento

```text
Backlog -> To Do -> In Progress -> Test / Review -> Done
```

## 11. Estado actual

### Completado
- arquitectura
- routing
- DHCP
- DNS
- NAT
- web
- MySQL
- FTP
- autenticación
- roles
- CRUD
- segmentación
- documentación principal

### Pendiente
- capturas finales
- métricas cuantitativas de rendimiento
- revalidación final del cliente Linux
- preparación de la defensa

## 12. Conclusión

Este documento consolida responsables, fases, recursos, riesgos y estado actual del proyecto.
