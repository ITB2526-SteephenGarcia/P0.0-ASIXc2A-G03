# Juego de pruebas — P.0-ASIXc2A-G03

**Equipo:** ASIXc2A-G03 · **Integrantes:** Taylor Uriña y Steephen Garcia  
**Fecha:** 25/11/2026 · **Versión:** 1.0 · **Entorno:** IsardVDI

## 1. Objetivo

Este documento define un conjunto de pruebas funcionales y técnicas para verificar la infraestructura multicapa, los servicios de red, los servidores, los clientes y la aplicación web.

**Importante:** es un plan y registro de pruebas. Un resultado esperado no demuestra que la prueba se haya ejecutado. Solo se marcará como superada cuando se complete la ejecución y se adjunte evidencia real.

## 2. Arquitectura de referencia

| Elemento | Dirección / función |
|---|---|
| R-NCC Intranet | 192.168.20.1/24 |
| R-NCC DMZ | 192.168.10.1/24 |
| W-NCC DMZ | 192.168.10.10/24 — NGINX/PHP |
| W-NCC Backend | 192.168.30.1/24 |
| B-NCC | 192.168.30.10/24 — MySQL 8 |
| F-NCC | 192.168.10.20/24 — FTP |
| Intranet | 192.168.20.0/24 |
| DNS interno | asix3jyt.local |
| Base de datos | equipaments — 889 filas documentadas |

## 3. Estados

- **Documentada:** un documento o sprint afirma que se realizó.
- **Pendiente de evidencia:** ejecución descrita, falta adjuntar captura/log.
- **Pendiente de ejecución:** no consta ejecución confirmada.
- **No superada:** ejecutada y resultado distinto del esperado.

No incluir contraseñas, hashes, tokens ni datos sensibles en las evidencias.

## 4. Casos de prueba

| ID | Área y tipo | Procedimiento | Resultado esperado | Estado documental inicial |
|---|---|---|---|---|
| PT-001 | R-NCC · Positiva | Ejecutar `ip a`. | Interfaces con 192.168.20.1/24 y 192.168.10.1/24. | Pendiente de evidencia |
| PT-002 | Routing · Positiva | Ejecutar `ip route`. | Rutas conectadas a 192.168.10.0/24 y 192.168.20.0/24 y ruta por defecto exterior. | Pendiente de evidencia |
| PT-003 | Forwarding · Positiva | Ejecutar `sysctl net.ipv4.ip_forward`. | `net.ipv4.ip_forward = 1`. | Pendiente de evidencia |
| PT-004 | DHCP · Positiva | En R-NCC: `sudo systemctl status isc-dhcp-server` y `sudo systemctl is-enabled isc-dhcp-server`. | Servicio active (running) y enabled. | Pendiente de evidencia |
| PT-005 | DHCP Windows · Integración | En PowerShell: `ipconfig /release`, `ipconfig /renew`, `ipconfig /all`. | IP 192.168.20.0/24, gateway y DNS 192.168.20.1. La IP 192.168.20.100 consta en una prueba anterior, pero puede variar. | Documentada en Sprint 2; adjuntar captura |
| PT-006 | DNS · Positiva | En R-NCC: `sudo systemctl status bind9` y `sudo systemctl is-enabled bind9`. | BIND9 active (running) y enabled. | Pendiente de evidencia |
| PT-007 | DNS · Integración | Desde un cliente: `nslookup w-ncc.asix3jyt.local` y `nslookup f-ncc.asix3jyt.local`. | W-NCC → 192.168.10.10; F-NCC → 192.168.10.20. | Descrita en documentación; adjuntar captura |
| PT-008 | NAT · Integración | Comprobar gateway del cliente; ejecutar `ping 8.8.8.8`; en R-NCC consultar `sudo iptables -t nat -L POSTROUTING -n -v` antes/después. | Salida a Internet y aumento de contadores MASQUERADE para 192.168.20.0/24. ICMP puede estar filtrado; documentar alternativa si procede. | Validada en Sprint 2; adjuntar evidencia |
| PT-009 | Firewall · Positiva | En R-NCC y B-NCC: `sudo ufw status verbose`. | UFW activo y reglas coherentes con Seguridad-Firewall.md. | Pendiente de evidencia |
| PT-010 | MySQL · Negativa | Desde Windows probar `Test-NetConnection 192.168.30.10 -Port 3306`, si existe ruta de prueba. | No se establece conexión. Distinguir bloqueo por falta de ruta de bloqueo por firewall. | Pendiente de ejecución/evidencia |
| PT-011 | W-NCC · Positiva | Ejecutar `sudo nginx -t`, `sudo systemctl status nginx` y `sudo systemctl status php8.1-fpm`. | Sintaxis correcta y servicios activos. | Pendiente de evidencia |
| PT-012 | Web · Integración | Desde Intranet abrir `http://192.168.10.10/` y `http://w-ncc.asix3jyt.local/`. | Se muestra la aplicación/login y funciona la resolución por nombre. | Funcionalidad descrita; adjuntar captura |
| PT-013 | Login lector · Positiva | Iniciar sesión con cuenta de rol lector y consultar listado/paginación. | Puede consultar, sin acciones administrativas. | Documentada en Sprint 2; adjuntar captura |
| PT-014 | Permisos · Negativa | Con sesión de lector, introducir directamente una URL administrativa. | HTTP 403 y mensaje de acceso denegado. | Documentada en Sprint 2; adjuntar captura |
| PT-015 | Login admin · Positiva | Iniciar sesión con cuenta admin y abrir funciones CRUD. | Acciones de crear, editar y eliminar disponibles. | Documentada en Sprint 2; adjuntar captura |
| PT-016 | CRUD · Integración | Con admin y un registro temporal autorizado: crear, consultar, editar y eliminar ese registro. | Las cuatro operaciones funcionan. No borrar ni alterar equipamientos reales. | Creación/modificación descritas; completar evidencia del ciclo |
| PT-017 | Sesión · Positiva | Cerrar sesión y volver a una URL protegida/recargar. | La aplicación solicita autenticación de nuevo. | Pendiente de ejecución |
| PT-018 | MySQL · Integración | Desde W-NCC: `mysql -h 192.168.30.10 -u bchecker -p`; luego `USE equipaments;` y `SELECT COUNT(*) FROM equipaments;`. | Conexión correcta y 889 filas. | Documentada; adjuntar captura |
| PT-019 | MySQL · Negativa | Intentar conexión desde un origen distinto de 192.168.30.1 con cuenta restringida a W-NCC. | MySQL rechaza el origen; se documentó ERROR 1130 en una prueba anterior. | Documentada; adjuntar captura |
| PT-020 | MySQL · Positiva | En B-NCC: `sudo ss -lntp \| grep 3306`. | Listener en 192.168.30.10:3306. | Pendiente de evidencia |
| PT-021 | FTP · Integración | En Windows: `Test-NetConnection 192.168.10.20 -Port 21`. | `TcpTestSucceeded : True`. | Documentada; adjuntar captura |
| PT-022 | FTP · Integración | Conectar con `ftp 192.168.10.20`; ejecutar `ls`, `get prueba_ftp.txt`, `put subida_windows.txt` y `bye`. | Login, listado, descarga y subida correctos. | Documentada; adjuntar capturas sin contraseña |
| PT-023 | Cliente Linux · Integración | Ejecutar `ip a`, `ip route`, `ping 192.168.20.1`, `nslookup w-ncc.asix3jyt.local`, `curl http://w-ncc.asix3jyt.local` y `nc -zv 192.168.10.20 21`. | IP de Intranet, gateway R-NCC, DNS, HTTP y FTP accesibles. | Validación final pendiente según README |

## 5. Registro de ejecución

Completar una fila por ejecución. No marcar como superada sin resultado real y evidencia.

| ID | Fecha | Ejecutor | Resultado real | Estado final | Evidencia/incidencia |
|---|---|---|---|---|---|
| PT-001 a PT-023 | | | | Pendiente | |

## 6. Criterios de aceptación

1. Ejecutar todos los casos aplicables.
2. Registrar resultado real, estado y evidencia.
3. Las pruebas negativas deben demostrar que los accesos no autorizados se rechazan.
4. Relacionar los fallos con una incidencia y repetir la prueba tras corregirlos.
5. Identificar capturas/logs con el ID correspondiente.
6. Completar la validación del cliente Linux o documentar la limitación.
7. No publicar credenciales ni secretos.

Una prueba solo se considera superada si el resultado real coincide con el esperado y existe evidencia.

## 7. Organización de evidencias

Crear `Doc_Proceso_Proyecto/Evidencias_Pruebas/` y guardar capturas reales con nombres como:

- `PT-001_R-NCC-interfaces.png`
- `PT-005_DHCP-Windows.png`
- `PT-007_DNS-cliente.png`
- `PT-008_NAT.png`
- `PT-014_Lector-HTTP403.png`
- `PT-018_MySQL-W-NCC.png`
- `PT-019_MySQL-rechazo.png`
- `PT-022_FTP-transferencias.png`
- `PT-023_Cliente-Linux/`

## 8. Documentación relacionada

- [README](../README.md)
- [Arquitectura](../Doc_Administrador/Arquitectura.md)
- [R-NCC](../Doc_Administrador/R-NCC.md)
- [W-NCC](../Doc_Administrador/W-NCC.md)
- [B-NCC](../Doc_Administrador/B-NCC.md)
- [F-NCC](../Doc_Administrador/F-NCC.md)
- [Seguridad y firewall](../Doc_Administrador/Seguridad-Firewall.md)
- [Servicios](../Doc_Administrador/Servicios.md)
- [Cliente Windows](../Doc_Administrador/Cliente_Windows.md)
- [Cliente Linux](../Doc_Administrador/Cliente_Linux.md)
- [Manual de uso](../Doc_Usuario/Manual_Uso.md)
- [Manual FTP](../Doc_Usuario/Manual_FTP.md)
- [Incidencias](../Doc_Administrador/Incidencias.md)
- [Sprint 2 — 23/11/2026](./Sprint.2_23_11_26.md)
