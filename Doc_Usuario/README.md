# Documentación de Usuario

Esta carpeta contiene la documentación destinada a los usuarios finales del proyecto **P.0-ASIXc2A-G03**.

La infraestructura permite utilizar una aplicación web de equipamientos y un servicio FTP desde los clientes de la Intranet, sin necesidad de conocer la configuración interna de los servidores.

## Servicios disponibles

Los usuarios pueden utilizar:

- aplicación web en W-NCC
- autenticación mediante usuario y contraseña
- consulta de equipamientos
- operaciones administrativas según el rol
- servicio FTP en F-NCC
- resolución de nombres mediante DNS interno

## Aplicación web

Servidor:

```text
192.168.10.10
```

Nombre DNS:

```text
w-ncc.asix3jyt.local
```

Acceso:

```text
http://192.168.10.10/
http://w-ncc.asix3jyt.local/
```

## Roles

La aplicación dispone de dos roles:

```text
lector
admin
```

### Lector

Puede iniciar sesión, consultar equipamientos, navegar por el listado y cerrar sesión.

No puede crear, editar ni eliminar registros.

### Administrador

Puede consultar, crear, editar y eliminar equipamientos.

Las funciones administrativas están protegidas también en el servidor. Un lector que intenta acceder directamente a una ruta administrativa recibe un error HTTP 403.

## Estado actual

| Componente | Estado |
|---|---|
| Red interna | ✅ Funcionando |
| DHCP | ✅ Funcionando |
| DNS interno | ✅ Funcionando |
| NAT y salida a Internet | ✅ Funcionando |
| Servidor web | ✅ Funcionando |
| Web conectada con MySQL | ✅ Funcionando |
| Login | ✅ Funcionando |
| Roles lector y administrador | ✅ Funcionando |
| Consulta de equipamientos | ✅ Funcionando |
| CREATE | ✅ Funcionando |
| UPDATE | ✅ Funcionando |
| DELETE y protección de acceso | ✅ Funcionando |
| FTP | ✅ Funcionando |

## Servicio FTP

Servidor:

```text
192.168.10.20
```

Nombre DNS:

```text
f-ncc.asix3jyt.local
```

Puerto principal:

```text
21/TCP
```

El servicio permite listar, descargar y subir archivos.

## Documentos

- [Requisitos de acceso](./Requisitos_Acceso.md)
- [Manual de uso](./Manual_Uso.md)
- [Manual FTP](./Manual_FTP.md)
- [Mantenimiento básico](./Mantenimiento_Basico.md)
- [Problemas frecuentes](./Problemas_Frecuentes.md)

## Seguridad para el usuario

Se recomienda:

- no compartir credenciales
- cerrar sesión al terminar
- no modificar configuraciones de red o servidores
- utilizar únicamente las funciones permitidas por el rol
- comunicar errores al administrador

La configuración técnica se encuentra en la [Documentación de Administrador](../Doc_Administrador/).
