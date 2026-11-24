# Plan de prevención de riesgos laborales y riesgos técnicos

**Proyecto:** P.0-ASIXc2A-G03 — Desplegament d'infraestructura per a una aplicació multicapa  
**Equipo:** ASIXc2A-G03  
**Integrantes:** Taylor Uriña y Steephen Garcia  
**Ámbito:** trabajo de planificación, configuración, despliegue, pruebas y documentación de la infraestructura virtualizada  
**Documento relacionado:** `Doc_Proceso_Proyecto/Planificacion_Recursos_Riesgos.md`

---

## 1. Objetivo

Este documento identifica los riesgos laborales y técnicos asociados a las tareas realizadas durante el proyecto P.0-ASIXc2A-G03 y establece medidas preventivas para reducir su probabilidad e impacto.

El plan se adapta al trabajo descrito en el repositorio: uso de IsardVDI y máquinas virtuales, administración de Ubuntu Server, configuración de redes y servicios, pruebas desde clientes Windows y Linux, uso de terminales, documentación en GitHub y seguimiento de tareas mediante ProofHub.

La rúbrica del proyecto, en el apartado RA3, solicita identificar los riesgos inherentes a la ejecución, definir un plan de prevención y concretar los medios necesarios. Para alcanzar el nivel más alto también se deben indicar medidas concretas, responsables y recursos.

> **Alcance:** la infraestructura documentada está desplegada en un entorno virtualizado. Por tanto, no se presupone que el equipo manipule físicamente servidores de un centro de datos, racks o instalaciones eléctricas industriales. Los riesgos físicos descritos se limitan al puesto de trabajo informático y a la manipulación ocasional de equipos periféricos.

## 2. Descripción de las actividades y del entorno de trabajo

Las actividades que pueden generar riesgos son:

- Planificación de tareas y coordinación del equipo mediante ProofHub.
- Creación y administración de máquinas virtuales en IsardVDI.
- Configuración de R-NCC (routing, DHCP, DNS, NAT y firewall).
- Administración de W-NCC (NGINX, PHP, PHP-FPM y aplicación web).
- Administración de B-NCC (MySQL y red backend privada).
- Configuración de F-NCC (servicio FTP).
- Pruebas desde clientes Windows y Linux.
- Uso de terminal Linux, PowerShell y navegador web.
- Edición, revisión y publicación de documentación y configuraciones en GitHub.

El trabajo se realiza principalmente con ordenador y pantalla durante sesiones de duración variable. Puede implicar periodos prolongados sentado, repetición de movimientos con teclado y ratón, concentración visual y presión por completar tareas y pruebas dentro de los plazos.

## 3. Criterio de valoración

Se utiliza una valoración cualitativa para priorizar las medidas preventivas:

| Nivel | Probabilidad | Gravedad |
|---|---|---|
| Bajo | Poco probable en condiciones normales | Molestias o incidente leve |
| Medio | Puede ocurrir durante el proyecto | Lesión o afectación que requiere atención o interrupción del trabajo |
| Alto | Es probable si no se aplican controles o puede tener consecuencias importantes | Daño grave, pérdida importante de información o interrupción relevante |

El nivel de riesgo indicado es una estimación preventiva para organizar el trabajo del equipo, no una evaluación oficial realizada por un servicio de prevención. Debe revisarse si cambian las condiciones, el espacio o las tareas.

## 4. Identificación de riesgos laborales

### 4.1 Riesgos ergonómicos y derivados del uso de pantallas

| ID | Riesgo y situación | Posibles consecuencias | Nivel inicial | Medidas preventivas | Responsable |
|---|---|---|---|---|---|
| L01 | Mantener una postura sentada durante sesiones prolongadas de configuración, programación o documentación. | Dolor cervical, lumbar y muscular; fatiga postural. | Medio | Ajustar silla y mesa; apoyar la espalda; mantener los pies apoyados; colocar la pantalla frente al usuario y evitar trabajar con el portátil demasiado bajo durante periodos largos. Alternar postura y levantarse periódicamente. | Ambos |
| L02 | Uso continuado de pantalla al revisar terminales, paneles de IsardVDI, documentación y pruebas. | Fatiga visual, sequedad ocular, dolor de cabeza. | Medio | Ajustar brillo y tamaño de texto; evitar reflejos; mantener una distancia cómoda; realizar pausas visuales periódicas y alternar tareas de pantalla con revisión o planificación fuera de ella. | Ambos |
| L03 | Uso repetitivo de teclado y ratón durante configuración de servicios y escritura de documentación. | Molestias en muñecas, manos y antebrazos. | Bajo/Medio | Mantener muñecas en posición neutra; colocar teclado y ratón cerca; evitar apoyos con presión prolongada; hacer pausas y variar las tareas. | Ambos |
| L04 | Espacio de trabajo mal iluminado, con reflejos o pantalla mal colocada. | Cansancio visual, posturas forzadas y dolor de cabeza. | Bajo/Medio | Situar la pantalla evitando reflejos directos; disponer de iluminación suficiente y ajustar la orientación del puesto. | Ambos |

### 4.2 Riesgos eléctricos y del espacio de trabajo

| ID | Riesgo y situación | Posibles consecuencias | Nivel inicial | Medidas preventivas | Responsable |
|---|---|---|---|---|---|
| L05 | Cables de alimentación, cargadores o periféricos atravesando zonas de paso o desordenados en el puesto. | Tropiezos, caídas y desconexiones accidentales. | Bajo/Medio | Mantener los cables recogidos y fuera de zonas de paso; no sobrecargar regletas; revisar visualmente cables y conectores; no utilizar elementos dañados. | Ambos |
| L06 | Manipulación de cargadores, regletas o equipos eléctricos dañados o con las manos húmedas. | Descarga eléctrica, quemaduras o daños en el equipo. | Bajo/Alto | No manipular conexiones con las manos húmedas; retirar de uso cables o cargadores deteriorados; desconectar tirando de la clavija y no del cable; no abrir fuentes de alimentación ni equipos eléctricos. | Ambos |
| L07 | Bebidas o líquidos cerca del ordenador y periféricos. | Cortocircuito, daño del equipo o riesgo eléctrico. | Bajo/Medio | Mantener líquidos separados del equipo y de las regletas; limpiar derrames solo cuando sea seguro y con el equipo desconectado por una persona competente. | Ambos |
| L08 | Traslado ocasional de portátil, monitor u otros periféricos sin cuidado. | Golpes, caída de equipos o sobreesfuerzo. | Bajo | Transportar los equipos apagados y de forma estable; no apilar material de forma insegura; pedir ayuda si el peso o volumen dificulta el traslado. | Ambos |

### 4.3 Riesgos psicosociales y organizativos

| ID | Riesgo y situación | Posibles consecuencias | Nivel inicial | Medidas preventivas | Responsable |
|---|---|---|---|---|---|
| L09 | Acumulación de tareas técnicas y documentación cerca de las fechas de entrega. | Estrés, fatiga mental, errores y conflictos de coordinación. | Medio | Dividir el trabajo en tareas pequeñas; mantener actualizado ProofHub; revisar prioridades y bloqueos; repartir la carga y comunicar con antelación los retrasos. | Ambos |
| L10 | Interrupciones, cambios de configuración o falta de coordinación entre integrantes. | Pérdida de concentración, repetición de trabajo y errores. | Medio | Registrar cambios en GitHub; acordar quién modifica cada componente; revisar conjuntamente cambios importantes y dejar constancia de las decisiones. | Ambos |
| L11 | Trabajo prolongado sin descansos o con concentración intensa durante diagnósticos. | Cansancio mental, disminución de atención y errores de administración. | Medio | Planificar pausas; alternar tareas; detener cambios cuando exista fatiga; realizar una revisión antes de aplicar modificaciones críticas. | Ambos |

## 5. Riesgos técnicos y operativos del proyecto

Además de los riesgos laborales, el proyecto tiene riesgos técnicos que pueden afectar a la seguridad, disponibilidad e integridad de la infraestructura. Se incluyen porque la rúbrica RA3 solicita identificar los riesgos inherentes a la ejecución del proyecto.

| ID | Riesgo técnico | Impacto posible | Nivel inicial | Medidas preventivas y de respuesta | Responsable principal |
|---|---|---|---|---|---|
| T01 | Error de routing, gateway o interfaces de red. | Pérdida de conectividad entre Intranet, DMZ y servicios. | Alto | Comprobar `ip a` e `ip route`; validar cada red por separado; documentar las rutas y gateways antes de cambiar la configuración. | Taylor |
| T02 | Exposición de MySQL o SSH a orígenes no autorizados. | Acceso indebido a la base de datos o al servidor. | Alto | Mantener B-NCC en la red backend; limitar UFW y las cuentas MySQL al origen W-NCC (`192.168.30.1`); revisar reglas IPv4 e IPv6. | Taylor |
| T03 | Error en DHCP o DNS. | Clientes sin configuración correcta o incapacidad para resolver nombres internos. | Medio | Comprobar el estado de `isc-dhcp-server` y BIND9; validar concesiones DHCP y resoluciones DNS; probar por IP para aislar el origen del fallo. | Taylor |
| T04 | Configuración NAT incorrecta o no persistente en R-NCC. | Pérdida de salida a Internet o enrutamiento no esperado. | Alto | Validar reglas MASQUERADE y contadores; mantener la configuración persistente en `/etc/ufw/before.rules`; probar con R-NCC como gateway. | Taylor |
| T05 | Pérdida de datos o cambios accidentales en MySQL. | Pérdida de registros o necesidad de reconstruir la base de datos. | Alto | Realizar copias de seguridad antes de cambios relevantes; verificar los ficheros de copia; limitar permisos y documentar la recuperación. | Taylor |
| T06 | Permisos incorrectos en la aplicación web. | Un lector podría ejecutar acciones administrativas o un usuario autorizado podría quedar bloqueado. | Alto | Mantener roles diferenciados; validar permisos en el servidor con `requireAdmin()`; probar acceso autorizado y pruebas negativas HTTP 403. | Taylor |
| T07 | Caída de NGINX, PHP-FPM, MySQL o FTP. | Indisponibilidad parcial o total de los servicios. | Medio/Alto | Revisar `systemctl status`, logs y puertos; validar NGINX con `nginx -t`; documentar dependencias y orden de recuperación. | Taylor |
| T08 | Cambios de configuración no registrados o incompatibles entre integrantes. | Pérdida de trazabilidad, errores repetidos o configuración divergente. | Medio | Centralizar configuraciones y documentación en GitHub; revisar cambios antes de integrarlos; registrar incidencias y decisiones. | Ambos |
| T09 | Dependencia de R-NCC como punto central de comunicación. | Una avería puede afectar a varios servicios y clientes. | Alto | Mantener documentadas las configuraciones; disponer de copias de seguridad; registrar el procedimiento de diagnóstico y recuperación. | Taylor |
| T10 | Pruebas incompletas que den una falsa sensación de seguridad. | Dar por válido un servicio que solo responde parcialmente. | Medio | Probar funcionalidad completa: FTP con login, `ls`, `get` y `put`; MySQL desde origen permitido y no permitido; aplicación con roles distintos; documentar resultados reales. | Ambos |
| T11 | Pérdida de acceso o indisponibilidad del entorno IsardVDI. | Imposibilidad temporal de administrar o validar las máquinas virtuales. | Medio | Mantener documentación y configuraciones fuera de las máquinas; guardar cambios en GitHub; registrar el estado y los pasos necesarios para reanudar el trabajo. | Ambos |
| T12 | Configuraciones temporales que desaparezcan tras reinicio. | Servicios o rutas dejan de funcionar después de reiniciar. | Medio/Alto | Identificar qué cambios deben ser persistentes; comprobarlos tras reinicio o recarga controlada; documentar Netplan, UFW y rutas persistentes. | Taylor |

## 6. Plan de prevención: medidas, recursos y responsables

### 6.1 Medidas preventivas generales

1. Mantener el puesto de trabajo ordenado, con cables recogidos y sin líquidos junto a los equipos.
2. Ajustar silla, pantalla, teclado y ratón para evitar posturas forzadas.
3. Realizar pausas periódicas y alternar tareas de administración, pruebas y documentación.
4. No manipular equipos eléctricos dañados ni abrir fuentes de alimentación.
5. Distribuir las tareas mediante ProofHub y comunicar bloqueos o sobrecargas.
6. Registrar en GitHub los cambios de configuración y documentación.
7. Antes de modificar routing, firewall, NAT o MySQL, guardar la configuración actual y definir cómo volver atrás.
8. Aplicar cambios críticos de forma controlada y comprobar el resultado antes de continuar.
9. No considerar una prueba superada si no existe un resultado verificable.
10. Mantener copias de seguridad de configuraciones y datos importantes y comprobar que pueden recuperarse.

### 6.2 Responsables

| Responsable | Funciones preventivas |
|---|---|
| Taylor Uriña | Responsable principal de infraestructura, R-NCC, W-NCC, B-NCC, F-NCC y cliente Windows. Debe revisar las medidas de seguridad y las configuraciones de red y servicios de su ámbito. |
| Steephen Garcia | Responsable principal del cliente Linux y apoyo en infraestructura, pruebas y documentación. Debe revisar las medidas preventivas de las tareas compartidas y comunicar incidencias. |
| Ambos integrantes | Mantener el puesto seguro, respetar pausas, actualizar ProofHub y GitHub, revisar cambios, realizar pruebas y comunicar riesgos o incidentes. |

La asignación anterior sigue el reparto de responsabilidades recogido en `Planificacion_Recursos_Riesgos.md`. No sustituye la responsabilidad del centro educativo o de la entidad responsable del espacio de trabajo en materia de prevención.

### 6.3 Recursos necesarios

| Recurso | Uso preventivo |
|---|---|
| Silla y mesa adecuadas | Mantener una postura de trabajo cómoda y estable. |
| Pantalla, teclado y ratón | Permitir una disposición ergonómica del puesto. |
| Iluminación adecuada | Reducir reflejos y fatiga visual. |
| Regleta y cargadores en buen estado | Alimentar los equipos sin conexiones deterioradas o sobrecargas. |
| Organizadores de cables | Evitar tropiezos y desconexiones accidentales. |
| IsardVDI | Realizar el despliegue en máquinas virtuales, sin necesidad de manipular servidores físicos. |
| GitHub | Mantener versiones de documentación y configuraciones. |
| ProofHub | Organizar tareas, responsables, prioridades y seguimiento. |
| Terminal Linux y PowerShell | Ejecutar comprobaciones técnicas y diagnósticos. |
| Copias de seguridad | Recuperar configuraciones y datos ante errores o pérdidas. |

## 7. Procedimiento de trabajo seguro para cambios técnicos

Antes de realizar cambios que puedan afectar a la conectividad o disponibilidad:

1. Identificar el equipo afectado (R-NCC, W-NCC, B-NCC o F-NCC).
2. Consultar la documentación y el estado actual del servicio.
3. Guardar una copia de la configuración que se vaya a modificar.
4. Comprobar que se dispone de acceso alternativo o de un procedimiento de recuperación.
5. Aplicar un único cambio cada vez.
6. Validar el resultado con comandos y pruebas funcionales.
7. Si el resultado es incorrecto, revertir el cambio o aplicar el procedimiento de recuperación.
8. Registrar la incidencia, la solución y la evidencia en la documentación del proyecto.

Comprobaciones habituales:

```bash
ip a
ip route
sudo ufw status verbose
sudo systemctl status <servicio>
sudo nginx -t
sudo ss -lntp
```

En Windows:

```powershell
ipconfig /all
route print -4
Test-NetConnection <destino> -Port <puerto>
nslookup <nombre>
```

Los comandos se deben adaptar al equipo y servicio que se esté comprobando. No se deben ejecutar cambios destructivos o comandos de red sin entender su efecto.

## 8. Actuación ante incidentes

### 8.1 Incidente laboral

- Detener la actividad si existe un riesgo inmediato.
- Desconectar el equipo únicamente si puede hacerse sin exponerse a un peligro.
- Avisar al responsable del espacio de trabajo o al personal docente.
- No manipular cables, enchufes o equipos dañados.
- En caso de accidente o emergencia, seguir el procedimiento de emergencia del centro.

### 8.2 Incidente técnico

- Detener los cambios que puedan agravar el problema.
- Identificar el servicio y los equipos afectados.
- Consultar logs y estado de red o servicio.
- Recuperar la última configuración válida si procede.
- Comprobar el funcionamiento de los servicios dependientes.
- Documentar causa, solución y resultado en el registro de incidencias.

## 9. Seguimiento y revisión del plan

El plan se debe revisar:

- al comenzar una nueva fase o sprint;
- cuando se incorpore una nueva máquina, servicio o herramienta;
- después de una incidencia o accidente;
- cuando cambie el espacio o la forma de trabajo;
- antes de la entrega final del proyecto.

Se recomienda registrar el seguimiento en ProofHub y dejar constancia de los cambios técnicos en GitHub.

| Control | Frecuencia recomendada | Evidencia |
|---|---|---|
| Orden del puesto y estado de cables | Al inicio y final de cada sesión | Comprobación visual |
| Ergonomía y pausas | Durante cada sesión | Autocomprobación |
| Estado de tareas y carga de trabajo | En cada revisión de ProofHub | Tablero actualizado |
| Copias de configuraciones y datos | Antes de cambios importantes | Copia identificada y verificable |
| Revisión de firewall y permisos | Tras cambios de red o seguridad | Salida de UFW y pruebas de acceso |
| Pruebas de servicios | Después de cambios relevantes | Resultados documentados |
| Revisión de riesgos | Al cierre de cada fase o sprint | Actualización de este documento |

## 10. Relación con la rúbrica

Este documento da respuesta al criterio RA3 de identificación de riesgos inherentes al proyecto porque:

- identifica riesgos laborales relacionados con el uso prolongado de pantallas, ergonomía, electricidad, orden del puesto y organización del trabajo;
- identifica riesgos técnicos propios de la infraestructura multicapa;
- describe posibles consecuencias y asigna un nivel inicial de riesgo;
- propone medidas preventivas concretas;
- identifica responsables y recursos necesarios;
- establece procedimientos de actuación y seguimiento.

La rúbrica también valora que la planificación contemple fases, recursos y riesgos. Este documento complementa, pero no sustituye, la planificación general, el registro de sprints ni las evidencias de pruebas.

## 11. Limitaciones y aspectos pendientes de verificación

- No se dispone en el repositorio de una evaluación ergonómica presencial del puesto; las medidas laborales deben comprobarse en el espacio real donde trabaja cada integrante.
- No se documenta manipulación de servidores físicos ni trabajos eléctricos; por ello no se atribuyen esas tareas al proyecto.
- Las copias de seguridad y los procedimientos de recuperación deben acompañarse de evidencias de ejecución y restauración antes de considerarse plenamente validados.
- Los niveles de riesgo son una estimación cualitativa del equipo y no equivalen a una evaluación legal realizada por un técnico de prevención.

## 12. Documentación relacionada

- [Planificación, recursos, responsables y riesgos](./Planificacion_Recursos_Riesgos.md)
- [Proceso del proyecto](./Doc.md)
- [Instalación y despliegue](../Doc_Administrador/Instalacion.md)
- [Seguridad y firewall](../Doc_Administrador/Seguridad-Firewall.md)
- [Incidencias del proyecto](../Doc_Administrador/Incidencias.md)
- [Documentación general del proyecto](../README.md)

---

**Proyecto P.0-ASIXc2A-G03 — ASIXc2A**
