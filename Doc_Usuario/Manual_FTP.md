# Manual FTP

Este documento explica cómo utilizar el servicio FTP del proyecto **P.0-ASIXc2A-G03**.

## 1. Servidor FTP

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

El servicio permite listar, descargar y subir archivos.

## 2. Comprobar el puerto desde Windows

Abre PowerShell y ejecuta:

```powershell
Test-NetConnection 192.168.10.20 -Port 21
```

El resultado correcto debe incluir:

```text
TcpTestSucceeded : True
```

📸 **CAPTURA RECOMENDADA:** resultado de la comprobación del puerto.

## 3. Conectar

Ejecuta:

```powershell
ftp 192.168.10.20
```

También se puede utilizar:

```powershell
ftp f-ncc.asix3jyt.local
```

Introduce las credenciales proporcionadas por el administrador.

No muestres la contraseña en capturas.

## 4. Listar archivos

Dentro de la sesión FTP:

```text
ls
```

Durante las pruebas se utilizó:

```text
prueba_ftp.txt
```

## 5. Descargar

Para descargar:

```text
get prueba_ftp.txt
```

El archivo probado contenía:

```text
Prueba FTP Proyecto ASICX2
```

## 6. Subir

Durante las pruebas se utilizó:

```text
subida_windows.txt
```

Comando:

```text
put subida_windows.txt
```

La subida se completó correctamente.

## 7. Comandos básicos

| Comando | Función |
|---|---|
| `ls` | Mostrar archivos |
| `get archivo` | Descargar |
| `put archivo` | Subir |
| `pwd` | Mostrar directorio remoto |
| `lcd` | Consultar o cambiar directorio local |
| `bye` | Cerrar la sesión |
| `quit` | Cerrar la sesión |

## 8. Cerrar la conexión

Utiliza:

```text
bye
```

o:

```text
quit
```

## 9. Problemas habituales

Si el servidor no responde, comprueba primero el puerto 21.

Si `get` falla, revisa que el archivo exista.

Si `put` falla, comprueba que el archivo exista en el directorio local y que tengas permisos.

Consulta también [Problemas frecuentes](./Problemas_Frecuentes.md).

## 10. Seguridad

FTP tradicional no cifra las credenciales ni el tráfico como protocolos más modernos.

En este proyecto se utiliza dentro de la infraestructura de prácticas.

El usuario debe:

- utilizar solo sus credenciales
- no compartir contraseñas
- no subir archivos innecesarios
- cerrar la sesión al terminar

## Evidencias pendientes

📸 comprobación del puerto 21  
📸 login FTP  
📸 resultado de `ls`  
📸 descarga con `get`  
📸 subida con `put`
