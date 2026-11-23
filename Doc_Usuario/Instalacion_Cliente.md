# Instalación y preparación del cliente

## 1. Objetivo

Este documento explica cómo preparar un equipo cliente para utilizar los servicios del proyecto **P.0-ASIXc2A-G03**.

No es necesario instalar software especializado para acceder a la aplicación web.

## 2. Requisitos previos

El equipo debe:

- estar conectado a la Intranet
- disponer de un navegador moderno
- poder obtener configuración de red
- disponer de credenciales válidas

Red:

```text
192.168.20.0/24
```

Gateway y DNS:

```text
192.168.20.1
```

## 3. Preparación de Windows

La interfaz de la Intranet debe obtener automáticamente dirección IP, gateway y DNS mediante DHCP.

Comprobación:

```powershell
ipconfig /all
```

Durante las pruebas se obtuvo:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

La dirección IP puede variar.

📸 **CAPTURA RECOMENDADA:** `ipconfig /all`.

## 4. Preparación de Linux

El cliente Linux debe tener una dirección dentro de:

```text
192.168.20.0/24
```

y utilizar R-NCC como gateway.

```bash
ip a
ip route
```

> ⚠️ La validación final del cliente Linux queda pendiente de repetirse y documentarse con evidencias actuales.

## 5. Navegador

Se puede utilizar Firefox, Chrome o Edge.

## 6. Acceso a la aplicación

```text
http://192.168.10.10/
http://w-ncc.asix3jyt.local/
```

## 7. Comprobaciones iniciales

### Windows

```powershell
ping 192.168.20.1
Test-NetConnection 192.168.10.10 -Port 80
nslookup w-ncc.asix3jyt.local
```

### Linux

```bash
ping 192.168.20.1
curl http://192.168.10.10/
nslookup w-ncc.asix3jyt.local
```

## 8. Credenciales

La aplicación utiliza los roles:

```text
lector
admin
```

Las contraseñas reales no deben publicarse en la documentación.

## 9. FTP

```powershell
ftp 192.168.10.20
```

Consulta [Manual FTP](./Manual_FTP.md).

## 10. Checklist

- [ ] el cliente tiene una IP válida de la Intranet
- [ ] utiliza R-NCC como gateway
- [ ] utiliza R-NCC como DNS
- [ ] puede comunicarse con R-NCC
- [ ] puede abrir W-NCC
- [ ] puede resolver el nombre de W-NCC
- [ ] puede iniciar sesión

## 11. Problemas

Consulta [Problemas frecuentes](./Problemas_Frecuentes.md).

## 12. Conclusión

La preparación del cliente consiste en integrarlo correctamente en la Intranet y comprobar que puede utilizar los servicios autorizados.
