# Arquitectura de la infraestructura

## Introducción

La infraestructura del proyecto está desplegada mediante máquinas virtuales en Isard.

La red se ha dividido en diferentes zonas para separar los equipos internos de los servicios que están más expuestos.

Actualmente trabajamos principalmente con:

- Una red **DMZ**.
- Una red **Intranet**.
- Una conexión exterior proporcionada por Isard.
- Un router principal encargado de conectar las diferentes redes.

La arquitectura irá evolucionando durante los siguientes sprints, especialmente en la parte de seguridad y aislamiento de la base de datos.

---

## Arquitectura actual

La infraestructura actual está formada por las siguientes máquinas:

| Máquina | Función | Red | Dirección IP |
|---|---|---|---|
| R-NCC | Router principal | DMZ | `192.168.10.1/24` |
| R-NCC | Router principal | Intranet | `192.168.20.1/24` |
| W-NCC | Servidor web | DMZ | `192.168.10.10/24` |
| B-NCC | Servidor de base de datos | Intranet | `192.168.20.10/24` |
| Cliente Linux | Cliente | Intranet | `192.168.20.20/24` |
| Cliente Windows | Cliente | Intranet | `192.168.20.30/24` |
| F-NCC | Servidor FTP | DMZ | `192.168.10.20/24` |

> Algunas máquinas o servicios todavía se encuentran en desarrollo y se irán completando durante los siguientes sprints.

---

## Red DMZ

La red DMZ utiliza:

```text
192.168.10.0/24
```

La interfaz de `R-NCC` conectada a esta red utiliza:

```text
192.168.10.1/24
```

Actualmente dentro de la DMZ se encuentra el servidor web:

```text
W-NCC: 192.168.10.10/24
```

También está previsto utilizar esta zona para el servidor FTP:

```text
F-NCC: 192.168.10.20/24
```

La función principal de la DMZ es separar los servicios más expuestos de los equipos internos de la Intranet.

---

## Red Intranet

La red interna utiliza:

```text
192.168.20.0/24
```

La interfaz de `R-NCC` conectada a esta red utiliza:

```text
192.168.20.1/24
```

Actualmente están conectados a esta red:

```text
B-NCC:           192.168.20.10
Cliente Linux:   192.168.20.20
Cliente Windows: 192.168.20.30
```

La Intranet se utiliza para alojar los equipos internos y permitir la comunicación entre clientes y servicios privados.

---

## Router R-NCC

`R-NCC` es el equipo encargado de conectar las diferentes redes de la infraestructura.

Actualmente dispone de interfaces conectadas a:

- Red exterior.
- DMZ.
- Intranet.

Además, tiene activado el reenvío de paquetes IP mediante:

```text
net.ipv4.ip_forward = 1
```

Esto permite que el sistema esté preparado para realizar funciones de routing entre diferentes interfaces.

Las reglas de acceso entre redes y el firewall se irán configurando durante los siguientes sprints.

---

## Servidor Web W-NCC

`W-NCC` está ubicado dentro de la DMZ.

Actualmente tiene instalado un servidor web NGINX y puede comunicarse con `R-NCC`.

Su función será alojar la aplicación web del proyecto.

En una fase posterior, la aplicación web realizará consultas al servidor de base de datos y mostrará los resultados al usuario.

---

## Servidor de Base de Datos B-NCC

Actualmente `B-NCC` se encuentra en la Intranet con la dirección:

```text
192.168.20.10/24
```

Tiene instalado MySQL y contiene la base de datos:

```text
equipaments
```

Dentro de esta base de datos se ha importado el CSV proporcionado para el proyecto, con un total de:

```text
889 registros
```

Actualmente la base de datos funciona de forma independiente del servidor web.

---

## Clientes

### Cliente Linux

Dirección:

```text
192.168.20.20/24
```

Se utiliza para realizar pruebas de conectividad, acceso remoto mediante SSH y comprobaciones de los diferentes servicios.

### Cliente Windows

Dirección:

```text
192.168.20.30/24
```

Se utiliza también para realizar pruebas de red y acceso remoto a los servidores.

---

## Comunicación entre equipos

Actualmente se han realizado pruebas de conectividad entre diferentes máquinas utilizando `ping` y SSH.

Por ejemplo:

```text
R-NCC → W-NCC
R-NCC → Cliente Linux
Windows → B-NCC
Linux → B-NCC
```

También se ha comprobado el acceso remoto mediante SSH a servidores como `B-NCC`.

---

## Evolución prevista de la arquitectura

Después de revisar el primer MVP, se ha decidido mejorar la seguridad del servidor de base de datos.

La idea prevista para una siguiente fase es que `B-NCC` deje de estar accesible directamente desde la Intranet.

La arquitectura prevista sería:
<img width="650" height="680" alt="imatge" src="https://github.com/user-attachments/assets/33270da2-1b0a-4364-addb-ac8622c47d0a" />



`W-NCC` tendría una segunda interfaz conectada a una red privada donde estaría `B-NCC`.

De esta manera:

- Los clientes no podrían acceder directamente a MySQL.
- `B-NCC` quedaría aislado.
- Solo `W-NCC` podría realizar consultas a la base de datos.
- El acceso al puerto MySQL se controlaría mediante firewall.

Esta modificación todavía no se ha implementado y se documentará cuando se realice.

---

## Diagrama de arquitectura

> 📷 Añadir aquí el diagrama de arquitectura general del proyecto.

El diagrama debe mostrar como mínimo:

- Red exterior.
- R-NCC.
- DMZ.
- Intranet.
- W-NCC.
- B-NCC.
- F-NCC.
- Cliente Linux.
- Cliente Windows.
- Direcciones IP principales.

---

## Estado actual

Actualmente la infraestructura dispone de una base funcional con:

- Router configurado.
- DMZ operativa.
- Intranet operativa.
- Cliente Linux.
- Cliente Windows.
- Servidor web.
- Servidor de base de datos.
- SSH.
- MySQL.
- NGINX.

Durante los siguientes sprints se completarán los servicios restantes y se aplicarán mejoras de seguridad y segmentación.
