# Documentación de Usuario

## ¿Qué es este proyecto?

El proyecto **P.0-ASIXc2A-G03** consiste en una infraestructura multicapa desplegada en un entorno virtualizado mediante IsardVDI.

La infraestructura permite que los usuarios de la red interna puedan utilizar diferentes servicios, principalmente:

- aplicación web de equipamientos
- autenticación de usuarios
- consulta de información
- gestión de equipamientos según permisos
- servicio FTP
- resolución de nombres mediante DNS
- acceso a Internet mediante R-NCC

La aplicación web utiliza una base de datos MySQL con información de equipamientos obtenida originalmente a partir de datos abiertos de Barcelona.

---

## ¿Qué puede hacer el usuario?

Un usuario autorizado puede:

- acceder a la aplicación web
- iniciar sesión
- consultar equipamientos
- navegar por las diferentes páginas de resultados
- cerrar sesión
- utilizar las funciones permitidas por su rol
- acceder al servicio FTP cuando sea necesario

Existen dos roles principales:

```text
lector
admin
```

---

## Usuario lector

El usuario lector puede:

- iniciar sesión
- consultar equipamientos
- navegar por el listado
- cerrar sesión

No puede:

- crear equipamientos
- modificar equipamientos
- eliminar equipamientos

---

## Usuario administrador

El administrador puede:

- consultar equipamientos
- crear nuevos registros
- modificar registros
- eliminar registros
- cerrar sesión

Las operaciones administrativas están protegidas por el sistema de permisos de la aplicación.

---

## Estado actual del proyecto

| Parte | Estado |
|---|---|
| Red interna | ✅ Funcionando |
| DHCP | ✅ Funcionando |
| DNS interno | ✅ Funcionando |
| Acceso a Internet mediante R-NCC | ✅ Funcionando |
| Servidor web | ✅ Funcionando |
| Conexión web con la base de datos | ✅ Funcionando |
| Base de datos | ✅ Funcionando |
| Login | ✅ Funcionando |
| Roles lector y administrador | ✅ Funcionando |
| Consulta de equipamientos | ✅ Funcionando |
| CREATE | ✅ Funcionando |
| UPDATE | ✅ Funcionando |
| DELETE y control de permisos | ✅ Funcionando |
| FTP | ✅ Funcionando |

La documentación ya describe el funcionamiento actual de la infraestructura y no únicamente una versión prevista.

---

## Dirección de la aplicación

El servidor web W-NCC utiliza:

```text
192.168.10.10
```

Nombre DNS interno:

```text
w-ncc.asix3jyt.local
```

Desde un cliente de la Intranet se puede acceder mediante:

```text
http://192.168.10.10/
```

o:

```text
http://w-ncc.asix3jyt.local/
```

---

## Servicio FTP

El servidor FTP es F-NCC.

Dirección:

```text
192.168.10.20
```

Nombre DNS interno:

```text
f-ncc.asix3jyt.local
```

Puerto principal:

```text
21/TCP
```

El servicio permite realizar transferencias de archivos desde los clientes autorizados.

---

## Organización de la documentación

| Documento | Contenido |
|---|---|
| [Requisitos_Acceso.md](./Requisitos_Acceso.md) | Requisitos necesarios para utilizar los servicios |
| [Manual_Uso.md](./Manual_Uso.md) | Uso de la aplicación web paso a paso |
| [Mantenimiento_Basico.md](./Mantenimiento_Basico.md) | Buenas prácticas para el usuario |
| [Problemas_Frecuentes.md](./Problemas_Frecuentes.md) | Solución de los problemas más habituales |

Orden recomendado:

```text
Requisitos de acceso
        |
        v
Manual de uso
        |
        v
Mantenimiento básico
        |
        v
Problemas frecuentes
```

---

## Seguridad

El usuario debe:

- mantener sus credenciales privadas
- no compartir cuentas
- cerrar sesión al terminar
- no intentar modificar configuraciones de los servidores
- utilizar únicamente las funciones permitidas por su rol
- comunicar cualquier problema al administrador

Si un usuario intenta utilizar una función sin permisos suficientes, la aplicación puede mostrar:

```text
Acceso denegado. Se requieren permisos de administrador.
```

Esto indica que el sistema de permisos está funcionando correctamente.

---

## Documentación técnica

Esta carpeta está destinada al usuario final.

La configuración técnica de servidores, firewall, MySQL, DHCP, DNS y routing se encuentra en:

[Documentación de Administrador](../Doc_Administrador/)

---

## Objetivo

El objetivo de esta documentación es permitir que un usuario pueda utilizar los servicios principales del proyecto sin necesidad de conocer la configuración interna de la infraestructura.
