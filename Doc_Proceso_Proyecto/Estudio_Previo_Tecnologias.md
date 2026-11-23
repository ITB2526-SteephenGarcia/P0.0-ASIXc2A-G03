# Estudio previo y justificación de tecnologías

## Índice rápido

- [1. Objetivo](#1-objetivo)
- [2. Necesidades del proyecto](#2-necesidades-del-proyecto)
- [3. Virtualización](#3-virtualización)
  - [IsardVDI](#32-isardvdi)
  - [Proxmox VE](#33-proxmox-ve)
  - [Oracle VirtualBox](#34-oracle-virtualbox)
  - [VMware vSphere](#35-vmware-vsphere)
  - [Comparación](#36-comparación)
  - [Por qué utilizamos IsardVDI](#37-por-qué-utilizamos-isardvdi)
- [4. Servidor web](#4-servidor-web)
- [5. Base de datos](#5-base-de-datos)
- [6. PHP y PHP-FPM](#6-php-y-php-fpm)
- [7. DNS](#7-dns)
- [8. DHCP](#8-dhcp)
- [9. Firewall](#9-firewall)
- [10. SSH](#10-ssh)
- [11. FTP](#11-ftp)
- [12. Análisis de soluciones y oportunidad del proyecto](#12-análisis-de-soluciones-y-oportunidad-del-proyecto)
- [13. Decisiones finales](#13-decisiones-finales)
- [14. Fuentes consultadas](#14-fuentes-consultadas)
- [15. Conclusión](#15-conclusión)

---

## 1. Objetivo

Antes de desplegar la infraestructura del proyecto **P.0-ASIXc2A-G03** se analizaron distintas tecnologías que podían utilizarse para virtualización, servidor web, base de datos, DNS, DHCP, firewall y acceso remoto.

El objetivo de este documento es justificar las decisiones tomadas y mostrar que las herramientas utilizadas no se escogieron únicamente porque estaban disponibles, sino porque encajaban con las necesidades técnicas y educativas del proyecto.

---

## 2. Necesidades del proyecto

La solución debía permitir:

- crear varias máquinas virtuales
- conectar máquinas a diferentes redes
- separar DMZ, Intranet y backend
- desplegar servidores Linux y clientes Windows/Linux
- configurar routing, NAT y firewall
- alojar una aplicación web
- disponer de una base de datos
- ofrecer DNS y DHCP
- disponer de un servicio FTP
- poder administrar servidores mediante SSH
- realizar pruebas reales de conectividad y seguridad

También era importante que el entorno pudiera ser utilizado por estudiantes sin necesidad de disponer de un servidor físico propio.

---

# 3. Virtualización

## 3.1 Alternativas estudiadas

Se tuvieron en cuenta principalmente:

- IsardVDI
- Proxmox VE
- Oracle VirtualBox
- VMware vSphere

## 3.2 IsardVDI

IsardVDI es una plataforma VDI abierta orientada a la gestión centralizada de escritorios y máquinas virtuales.

Su propia documentación destaca aspectos como:

- plataforma abierta
- gestión centralizada
- acceso desde distintos dispositivos
- orientación a educación y organizaciones
- integración con tecnologías abiertas

En nuestro caso, además, era la plataforma disponible en el centro y ya proporcionaba la infraestructura necesaria para crear las máquinas y redes del proyecto.

### Ventajas para nuestro proyecto

- acceso desde navegador
- no requiere disponer de hardware propio
- permite trabajar desde diferentes equipos
- permite crear varias máquinas
- permite conectar varias interfaces de red
- facilita montar Intranet, DMZ y backend
- entorno ya preparado por el centro
- permite que ambos integrantes trabajen sobre la misma infraestructura educativa

---

## 3.3 Proxmox VE

Proxmox VE es una plataforma de virtualización de servidores basada en KVM y LXC.

Ofrece características avanzadas como:

- máquinas virtuales KVM
- contenedores LXC
- interfaz web centralizada
- gestión de almacenamiento
- networking
- alta disponibilidad
- copias de seguridad y recuperación

### Ventajas

- muy potente para entornos de servidor
- software abierto
- administración centralizada
- permite configuraciones de red complejas
- apropiado para laboratorios y producción

### Inconvenientes para este proyecto

Para utilizar Proxmox directamente habríamos necesitado disponer de:

- un servidor físico o una máquina con virtualización anidada
- instalación y mantenimiento del hipervisor
- almacenamiento propio
- configuración de red del host

Esto habría añadido trabajo que no era el objetivo principal del proyecto.

---

## 3.4 Oracle VirtualBox

VirtualBox es un hipervisor de tipo 2 que se instala sobre un sistema operativo existente.

Permite ejecutar diferentes máquinas virtuales dentro de un ordenador personal.

### Ventajas

- fácil de instalar
- funciona en Windows, Linux y macOS
- adecuado para laboratorios pequeños
- permite crear redes virtuales
- útil para desarrollo y pruebas

### Inconvenientes para este proyecto

- depende de los recursos del ordenador personal
- cada integrante tendría su propio entorno local
- compartir una misma infraestructura sería más complicado
- menos cómodo para trabajar desde distintos equipos
- requiere mantener localmente todas las máquinas virtuales

Para un proyecto con varios servidores y varias redes, esto podía consumir una cantidad importante de RAM y almacenamiento en los equipos personales.

---

## 3.5 VMware vSphere

VMware vSphere es una solución empresarial de virtualización orientada a centros de datos.

Dispone de funciones avanzadas de:

- gestión de máquinas virtuales
- seguridad
- disponibilidad
- integración con infraestructura empresarial
- gestión centralizada

### Ventajas

- solución profesional
- gran cantidad de funciones empresariales
- utilizada en infraestructuras reales

### Inconvenientes para nuestro proyecto

- mayor complejidad de despliegue
- orientada a infraestructuras empresariales
- requiere recursos e infraestructura propia
- ofrece muchas funciones que no necesitamos para este proyecto

---

## 3.6 Comparación

| Tecnología | Gestión centralizada | Requiere hardware propio | Adecuada para educación | Redes complejas | Adecuación al proyecto |
|---|---|---:|---:|---:|---:|
| IsardVDI | Sí | No para el alumno | Muy alta | Sí | Muy alta |
| Proxmox VE | Sí | Sí | Alta | Sí | Alta |
| VirtualBox | Principalmente local | Sí | Alta | Sí | Media |
| VMware vSphere | Sí | Sí | Media | Sí | Media |

---

## 3.7 ¿Por qué utilizamos IsardVDI?

La elección de IsardVDI se realizó principalmente porque era la solución que mejor se adaptaba al contexto del proyecto.

No significa que sea siempre mejor que Proxmox, VirtualBox o VMware.

En nuestro caso ofrecía una ventaja clara:

> permitía centrarnos en desplegar y administrar la infraestructura sin tener que montar primero nuestra propia plataforma de virtualización.

Además:

- estaba disponible en el centro
- permitía acceso remoto
- permitía crear las máquinas necesarias
- soportaba varias interfaces de red
- facilitaba el trabajo en un entorno educativo compartido
- evitaba depender de la potencia de nuestros ordenadores personales

Por estos motivos fue la opción más práctica para este proyecto.

---

# 4. Servidor web

## 4.1 Alternativas consideradas

Las dos alternativas más habituales eran:

- NGINX
- Apache HTTP Server

## 4.2 NGINX

NGINX puede actuar como:

- servidor HTTP
- reverse proxy
- caché
- balanceador
- proxy TCP/UDP

También destaca por su bajo consumo de recursos y buen rendimiento.

En nuestro proyecto se utiliza junto a PHP-FPM.

### Motivos de elección

- configuración relativamente sencilla
- buen rendimiento
- bajo consumo
- integración directa con PHP-FPM
- suficiente para la aplicación desarrollada

## 4.3 Apache

Apache también habría sido una opción válida.

Ofrece:

- arquitectura modular
- virtual hosts
- módulos de autenticación
- proxy
- TLS
- configuración mediante .htaccess

### Por qué no se eligió

No existía una necesidad específica de utilizar características como `.htaccess`.

Para una aplicación PHP sencilla desplegada en un único servidor, NGINX cumplía todos los requisitos.

---

# 5. Base de datos

## 5.1 Alternativas

Se podían utilizar soluciones como:

- MySQL
- MariaDB
- PostgreSQL

## 5.2 MySQL

MySQL es un sistema de gestión de bases de datos relacional ampliamente utilizado en aplicaciones web.

Para el proyecto necesitábamos:

- importar un CSV
- realizar consultas SQL
- gestionar usuarios y permisos
- permitir conexiones remotas controladas
- utilizar PHP para acceder a los datos

MySQL cumplía todos estos requisitos.

## 5.3 PostgreSQL

PostgreSQL también era una alternativa totalmente válida.

Destaca por:

- fiabilidad
- integridad de datos
- extensibilidad
- soporte avanzado de SQL
- gran cantidad de funciones

Para nuestro proyecto estas capacidades adicionales no eran necesarias.

## 5.4 Motivo de elección

Se eligió MySQL porque:

- cubría todos los requisitos
- era adecuado para PHP
- permitía gestionar fácilmente permisos por usuario
- era conocido por el equipo
- facilitaba la importación y consulta de los datos del proyecto

---

# 6. PHP y PHP-FPM

PHP se utiliza para desarrollar la lógica de la aplicación.

Permite implementar:

- login
- sesiones
- conexión a MySQL
- consultas
- CRUD
- control de roles

PHP-FPM se utiliza para ejecutar PHP junto a NGINX.

Se eligió esta combinación porque permite separar el servidor HTTP de la ejecución del código PHP.

---

# 7. DNS

## 7.1 Tecnología utilizada

Se utiliza BIND9.

BIND es una solución DNS completa y ampliamente utilizada.

Permite crear una zona interna y definir registros propios.

Dominio utilizado:

```text
asix3jyt.local
```

Ejemplos:

```text
w-ncc.asix3jyt.local
f-ncc.asix3jyt.local
r-ncc.asix3jyt.local
```

## 7.2 Motivo de elección

Se escogió porque:

- permite trabajar con zonas DNS reales
- es adecuado para una infraestructura con varios servidores
- permite aprender una configuración DNS similar a la utilizada en entornos profesionales

---

# 8. DHCP

El proyecto utiliza `isc-dhcp-server`.

Su función es proporcionar automáticamente:

- dirección IP
- máscara
- gateway
- DNS

a los clientes de la Intranet.

## Alternativas

Una alternativa actual es **Kea DHCP**, también desarrollada por ISC.

Kea ofrece una arquitectura más moderna y modular.

Sin embargo, para este laboratorio se utilizó `isc-dhcp-server` porque:

- estaba disponible en Ubuntu utilizado en el proyecto
- era suficiente para una red pequeña
- la configuración era conocida por el equipo
- cumplía correctamente los requisitos del proyecto

Debe tenerse en cuenta que ISC considera ISC DHCP un producto antiguo y recomienda Kea para nuevos despliegues.

---

# 9. Firewall

Se utiliza UFW como interfaz de gestión del firewall en Linux.

UFW permite definir reglas de forma sencilla sin trabajar directamente con toda la sintaxis de bajo nivel.

Se utiliza principalmente para:

- restringir accesos
- controlar puertos
- limitar MySQL a W-NCC
- limitar SSH en B-NCC
- controlar tráfico en R-NCC

## Alternativas

Podrían haberse utilizado directamente:

- nftables
- iptables

Estas opciones ofrecen mayor control, pero también requieren configuraciones más complejas.

Para este proyecto UFW facilitaba aplicar políticas claras y fáciles de documentar.

---

# 10. SSH

SSH se utiliza para administración remota.

Permite:

- acceder a servidores
- ejecutar comandos
- administrar máquinas sin utilizar directamente la consola de IsardVDI

También permitió validar conectividad entre equipos.

---

# 11. FTP

F-NCC proporciona un servicio FTP.

FTP se utiliza en el proyecto porque forma parte de los servicios que debían desplegarse y permite practicar:

- autenticación
- transferencia de archivos
- routing
- firewall
- comunicación entre Intranet y DMZ

Desde el punto de vista de seguridad, FTP tradicional no cifra el tráfico.

En un entorno de producción sería preferible utilizar soluciones como:

- SFTP
- FTPS

En este proyecto se utiliza FTP dentro del laboratorio para cumplir el objetivo académico y estudiar su funcionamiento.

---

# 12. Análisis de soluciones y oportunidad del proyecto

En una infraestructura real existen muchas soluciones comerciales y abiertas capaces de proporcionar los mismos servicios.

El valor de nuestro proyecto no está en crear una alternativa comercial a Proxmox, VMware o servicios cloud.

El objetivo es integrar diferentes tecnologías en una única infraestructura y demostrar conocimientos de:

- sistemas
- redes
- virtualización
- seguridad
- bases de datos
- servicios
- desarrollo web

El proyecto reproduce a pequeña escala una arquitectura multicapa real.

La necesidad que cubre es disponer de un entorno donde:

- los usuarios están separados de los servidores
- la aplicación web se encuentra en una DMZ
- la base de datos está aislada
- el router controla la comunicación
- cada servicio tiene una función concreta

Esto permite aplicar en un laboratorio conceptos habituales en infraestructuras empresariales.

---

# 13. Decisiones finales

| Necesidad | Tecnología elegida | Motivo principal |
|---|---|---|
| Virtualización | IsardVDI | Entorno educativo centralizado y ya disponible |
| Router | Ubuntu + UFW | Flexibilidad y aprendizaje de routing Linux |
| Web | NGINX | Rendimiento, simplicidad y PHP-FPM |
| Aplicación | PHP | Integración sencilla con sesiones y MySQL |
| Base de datos | MySQL | Adecuada para aplicación web y permisos |
| DNS | BIND9 | Servidor DNS completo |
| DHCP | isc-dhcp-server | Suficiente para el laboratorio |
| Firewall | UFW | Configuración clara y sencilla |
| Administración | SSH | Administración remota estándar |
| FTP | Linux-ftpd | Servicio requerido por el proyecto |

---

# 14. Fuentes consultadas

Las fuentes utilizadas para comparar y justificar las tecnologías son principalmente documentación oficial.

- IsardVDI: https://www.isardvdi.com/
- Proxmox VE: https://www.proxmox.com/en/products/proxmox-virtual-environment/features
- Oracle VirtualBox: https://docs.oracle.com/en/virtualization/virtualbox/
- VMware vSphere: https://www.vmware.com/products/cloud-infrastructure/vsphere
- NGINX: https://nginx.org/en/
- Apache HTTP Server: https://httpd.apache.org/
- MySQL: https://www.mysql.com/
- PostgreSQL: https://www.postgresql.org/about/
- BIND9 / ISC: https://www.isc.org/bind/
- ISC DHCP / Kea: https://www.isc.org/

---

# 15. Conclusión

El estudio previo permitió comparar diferentes soluciones antes de justificar las utilizadas.

La elección de tecnologías se realizó buscando un equilibrio entre:

- requisitos del proyecto
- recursos disponibles
- facilidad de administración
- valor educativo
- seguridad
- compatibilidad entre servicios

La elección de **IsardVDI** fue especialmente importante porque permitió desplegar toda la infraestructura sin depender de hardware propio y facilitó trabajar con múltiples máquinas y redes dentro del entorno proporcionado por el centro.
