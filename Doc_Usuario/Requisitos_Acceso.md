# Requisitos de acceso

Para utilizar los servicios del proyecto no es necesario instalar software especializado.

## 1. Equipo conectado a la Intranet

El equipo debe estar conectado a:

```text
192.168.20.0/24
```

Los clientes utilizados en el proyecto son Windows y Linux.

R-NCC actúa como gateway:

```text
192.168.20.1
```

## 2. Configuración de red

El cliente debe disponer de:

- dirección IP válida
- gateway correcto
- servidor DNS
- conectividad con R-NCC

R-NCC proporciona DHCP a los clientes.

Durante las pruebas, Windows recibió:

```text
IP:      192.168.20.100
Gateway: 192.168.20.1
DNS:     192.168.20.1
```

La dirección exacta del cliente puede variar.

## 3. Navegador

Se puede utilizar un navegador moderno como Firefox, Chrome o Edge.

## 4. Credenciales

La aplicación requiere usuario y contraseña.

Los roles disponibles son:

```text
lector
admin
```

Los permisos dependen del rol asignado.

## 5. Dirección de la aplicación

Por IP:

```text
http://192.168.10.10/
```

Por DNS:

```text
http://w-ncc.asix3jyt.local/
```

## 6. FTP

Servidor:

```text
192.168.10.20
```

Nombre DNS:

```text
f-ncc.asix3jyt.local
```

Puerto:

```text
21/TCP
```

Consulta [Manual FTP](./Manual_FTP.md) para utilizar el servicio.

## Checklist

- [ ] estoy conectado a la Intranet
- [ ] tengo una IP válida
- [ ] utilizo R-NCC como gateway
- [ ] tengo navegador
- [ ] conozco la dirección de la aplicación
- [ ] tengo credenciales válidas

Si se cumplen estos puntos, continúa con el [Manual de uso](./Manual_Uso.md).
