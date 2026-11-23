# Manual de uso

Este documento explica cómo utilizar la aplicación web del proyecto **P.0-ASIXc2A-G03**.

## 1. Acceso a la aplicación

Desde un equipo conectado a la Intranet, abre un navegador y accede a:

```text
http://192.168.10.10/
```

También se puede utilizar el nombre DNS interno:

```text
http://w-ncc.asix3jyt.local/
```

📸 **CAPTURA RECOMENDADA:** pantalla inicial o login de la aplicación.

## 2. Inicio de sesión

La aplicación requiere autenticación.

Introduce:

- nombre de usuario
- contraseña

Si las credenciales son correctas, se crea una sesión y se accede al listado de equipamientos.

## 3. Roles

Existen dos roles:

```text
lector
admin
```

### Usuario lector

Puede:

- iniciar sesión
- consultar equipamientos
- navegar por las páginas
- cerrar sesión

No puede crear, editar ni eliminar.

### Usuario administrador

Puede:

- consultar equipamientos
- crear registros
- editar registros
- eliminar registros
- cerrar sesión

📸 **CAPTURA RECOMENDADA:** comparar la vista del lector con la vista del administrador.

## 4. Consulta de equipamientos

Después del login se muestra el listado de equipamientos almacenados en la base de datos.

La tabla original contiene **889 filas**. La aplicación agrupa resultados por `register_id`, por lo que el número de equipamientos mostrados en la web es inferior al número de filas originales.

La página utiliza paginación y muestra aproximadamente **25 elementos por página**.

## 5. Crear un equipamiento

Solo el administrador puede crear registros.

Pasos:

1. iniciar sesión como administrador
2. pulsar la opción para añadir un equipamiento
3. completar el formulario
4. revisar los datos
5. guardar

El formulario utiliza listas desplegables en algunos campos para reducir errores de escritura.

## 6. Editar un equipamiento

Solo el administrador puede modificar registros.

Pasos:

1. localizar el equipamiento
2. pulsar `Editar`
3. modificar los campos necesarios
4. guardar los cambios

Durante las pruebas se obtuvo el mensaje:

```text
Equipamiento modificado correctamente.
```

## 7. Eliminar un equipamiento

Solo el administrador puede eliminar registros.

La aplicación muestra una confirmación antes de realizar la operación.

## 8. Protección de acceso

Ocultar los botones no es la única medida de seguridad.

Si un lector intenta acceder directamente a una ruta administrativa, la aplicación responde:

```text
Acceso denegado. Se requieren permisos de administrador.
```

con código:

```text
HTTP 403
```

📸 **CAPTURA RECOMENDADA:** error 403 utilizando el usuario lector.

## 9. Cerrar sesión

Cuando termines de utilizar la aplicación, usa la opción de logout.

La aplicación dispone de:

```text
/logout.php
```

Después de cerrar sesión será necesario autenticarse de nuevo para acceder a las páginas protegidas.

## 10. Buenas prácticas

- no compartir las credenciales
- cerrar sesión al terminar
- revisar los datos antes de guardar cambios
- comprobar el registro antes de eliminarlo
- utilizar una cuenta administrativa solo cuando sea necesario

## 11. Problemas

Si el acceso por nombre DNS falla, prueba temporalmente:

```text
http://192.168.10.10/
```

Si por IP funciona pero por nombre no, puede existir un problema DNS.

Para más casos consulta [Problemas frecuentes](./Problemas_Frecuentes.md).

## Evidencias pendientes

📸 login  
📸 vista lector  
📸 vista administrador  
📸 formulario de creación  
📸 modificación correcta  
📸 confirmación de eliminación  
📸 error HTTP 403
