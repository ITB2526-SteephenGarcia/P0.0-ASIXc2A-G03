# Documentación de Usuario

## ¿Qué es este proyecto?

Es una pequeña infraestructura de servicios montada en un entorno virtualizado (Isard) que nos permite consultar, desde una página web, información sobre **equipamientos educativos** (centros, instalaciones y otros espacios). Los datos están guardados en una base de datos y se han cargado a partir de un archivo CSV con **889 registros**.

## ¿Para qué sirve?

El objetivo es que cualquier usuario autorizado pueda abrir el navegador, entrar en la web del proyecto y consultar esa información sin necesidad de saber cómo funciona todo lo que hay por detrás.

## ¿Qué puede hacer el usuario?

- Acceder a la página web del proyecto desde un equipo de la red (Linux o Windows).
- Consultar la información de los equipamientos *(previsto: la conexión de la web con la base de datos todavía está en desarrollo)*.
- Volver a la página de inicio y repetir consultas.
- Avisar al administrador si algo no funciona.

## Estado actual del proyecto

| Parte | Estado |
|-------|--------|
| Red interna y conectividad entre equipos | ✅ Funcionando |
| Página web básica | ✅ Funcionando |
| Base de datos con los 889 equipamientos | ✅ Funcionando (de forma independiente) |
| Mostrar los datos de la base de datos en la web | 🛠️ En desarrollo |
| Mejoras de seguridad y servicios adicionales | 📅 Previsto para el siguiente sprint |

> Esta documentación describe el funcionamiento **final previsto**. Donde una función aún no existe, lo indicamos como *previsto* o *en desarrollo*.

## ¿Cómo está organizada esta documentación?

| Documento | Qué encontrarás |
|-----------|-----------------|
| [Requisitos_Acceso.md](Requisitos_Acceso.md) | Qué necesitas para poder usar el servicio |
| [Manual_Uso.md](Manual_Uso.md) | Cómo usar la página web paso a paso |
| [Mantenimiento_Basico.md](Mantenimiento_Basico.md) | Buenas prácticas sencillas para que todo vaya bien |
| [Problemas_Frecuentes.md](Problemas_Frecuentes.md) | Qué hacer si algo falla |

Orden recomendado de lectura: **Requisitos → Manual de uso → Mantenimiento → Problemas frecuentes**.

> ℹ️ Esta documentación es solo para usuarios. La configuración interna de los servidores está en la documentación de administrador.
