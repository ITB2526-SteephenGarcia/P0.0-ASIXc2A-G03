# Manual de uso

Este manual explica cómo se usará la web del proyecto para consultar los equipamientos educativos.

> ⚠️ **Estado actual:** la página web funciona y la base de datos está cargada, pero la **conexión entre ambas todavía está en desarrollo**. Este manual está escrito pensando en el funcionamiento final. Las partes que aún no existen están marcadas como **(previsto)**.

## 1. Cómo acceder a la aplicación

1. Comprueba que cumples los [requisitos de acceso](Requisitos_Acceso.md).
2. Abre el navegador.
3. Escribe en la barra de direcciones la dirección de la web del proyecto.
4. Pulsa **Enter**.

> 📷 Añadir aquí una captura del navegador con la dirección escrita en la barra.

Si todo va bien, se cargará la página principal.

## 2. Qué te vas a encontrar

### Estado actual

Una página de inicio básica que confirma que el servidor web funciona.

> 📷 Añadir aquí una captura de la página principal actual.

### Funcionamiento final previsto

Está previsto que la página permita consultar la información de los equipamientos guardada en la base de datos, mostrándola en pantalla de forma ordenada.

> 📷 Añadir aquí una captura de la página con los datos de los equipamientos (cuando esté disponible).

## 3. Qué información se podrá consultar

La información viene de la tabla **equipaments**, que contiene **889 registros** de equipamientos educativos. Los campos concretos que se verán en pantalla se definirán cuando termine la integración.

> 🛠️ **Pendiente de definir:** lista exacta de columnas que se mostrarán al usuario.

## 4. Cómo consultar la información

**(Previsto)** Al entrar en la web, el usuario podrá ver el listado de equipamientos que haya cargado la página.

Pasos esperados:

1. Entrar en la página principal.
2. Ver los datos de los equipamientos en pantalla.
3. Desplazarse por la página para ver más registros.

> ℹ️ Funciones como buscadores, filtros u ordenación **no están definidas** todavía. Si se añaden, se explicarán aquí.

> 📷 Añadir aquí una captura de un ejemplo de consulta con resultados.

## 5. Cómo volver al inicio

- Pulsa el enlace de inicio de la página, si existe.
- Si no, vuelve a escribir la dirección de la web en el navegador.

## 6. Cómo se espera que se comporte el sistema

- La página debería cargar en pocos segundos.
- Los datos mostrados deben coincidir con los de la base de datos.
- Si hay un fallo, debería aparecer un mensaje de error en lugar de una página en blanco **(previsto)**.
- El usuario **solo consulta**: no modifica los datos. *(Está por confirmar si habrá otras funciones.)*

## 7. Qué hacer si algo no funciona

Consulta [Problemas frecuentes](Problemas_Frecuentes.md). Si no se soluciona, avisa al administrador.

## 8. Funciones previstas para más adelante

| Función | Estado |
|---------|--------|
| Mostrar los equipamientos de la base de datos en la web | 🛠️ En desarrollo |
| Acceso mediante un nombre de dominio | 📅 Previsto |
| Mejoras de seguridad en el acceso | 📅 Previsto (siguiente sprint) |
