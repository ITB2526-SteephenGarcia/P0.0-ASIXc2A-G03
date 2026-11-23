# Problemas frecuentes

Antes de avisar al administrador, se pueden realizar algunas comprobaciones sencillas.

## 1. La web no carga

Prueba:

```text
http://192.168.10.10/
```

Si tampoco funciona, comprueba que el equipo siga conectado a la red.

Si el problema continúa, contacta con el administrador.

## 2. La IP funciona pero el nombre no

Si funciona:

```text
http://192.168.10.10/
```

pero no funciona:

```text
http://w-ncc.asix3jyt.local/
```

probablemente existe un problema de resolución DNS.

## 3. El login no funciona

Comprueba:

- nombre de usuario
- contraseña
- mayúsculas y minúsculas
- espacios introducidos por error

Si continúa fallando, contacta con el administrador.

## 4. Aparece "Acceso denegado"

Mensaje:

```text
Acceso denegado. Se requieren permisos de administrador.
```

Esto significa que la cuenta actual no dispone de permisos administrativos.

Un lector no puede crear, editar ni eliminar.

## 5. La web carga pero no aparecen datos

Puede existir un problema de comunicación entre W-NCC y B-NCC.

No modifiques la configuración. Comunica el problema al administrador.

## 6. El navegador muestra información antigua

Prueba una recarga sin caché:

```text
Ctrl + F5
```

## 7. FTP no conecta

Comprueba que utilizas:

```text
192.168.10.20
```

Si no responde, puede existir un problema de red, routing, R-NCC, F-NCC o del propio servicio FTP.

## 8. FTP conecta pero no transfiere

Si puedes iniciar sesión pero `get` o `put` fallan, indica al administrador:

- nombre del archivo
- operación realizada
- mensaje de error

## 9. Información para el administrador

Cuando comuniques una incidencia indica:

- qué estabas haciendo
- qué error apareció
- desde qué equipo
- hora aproximada
- captura de pantalla si es posible

📸 **CAPTURA RECOMENDADA:** ejemplo de un error real.

## 10. Qué no debe hacer el usuario

No se debe:

- reiniciar servidores
- modificar direcciones IP
- cambiar reglas de firewall
- modificar MySQL
- cambiar configuraciones internas
- compartir credenciales
