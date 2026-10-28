# R-NCC - Router principal

## Función

`R-NCC` es el router principal de la infraestructura.

Su función es conectar las diferentes redes del proyecto y permitir la comunicación controlada entre ellas.

Actualmente está conectado a:

- Red exterior proporcionada por Isard.
- Red DMZ.
- Red Intranet.

También tiene habilitado el reenvío de paquetes IP para poder realizar funciones de routing.

---

## Sistema operativo

El router utiliza:

```text
Ubuntu Server
```

La máquina está desplegada en Isard.

---

## Hostname

El nombre configurado para la máquina es:

```text
R-NCC
```

Se puede comprobar con:

```bash
hostname
```

---

## Interfaces de red

Actualmente `R-NCC` dispone de varias interfaces.

La distribución utilizada es:

| Interfaz | Red | Dirección |
|---|---|---|
| Exterior | Red Isard | DHCP |
| DMZ | `192.168.10.0/24` | `192.168.10.1/24` |
| Intranet | `192.168.20.0/24` | `192.168.20.1/24` |

> El nombre exacto de las interfaces puede variar según la máquina virtual. Se recomienda comprobarlo siempre con `ip a`.

---

## Comprobación de interfaces

Para consultar las interfaces y direcciones IP:

```bash
ip a
```

Esto permite comprobar:

- qué interfaces están activas;
- qué IP tiene cada interfaz;
- qué red corresponde a cada conexión.

---

## Tabla de rutas

La tabla de rutas se puede consultar con:

```bash
ip route
```

Este comando permite ver por qué interfaz se enviará el tráfico dependiendo de la red de destino.

Por ejemplo, deben aparecer rutas correspondientes a:

```text
192.168.10.0/24
192.168.20.0/24
```

Además de una ruta por defecto hacia la red exterior.

---

## IP Forwarding

Para que Ubuntu pueda reenviar paquetes entre interfaces, se ha habilitado el IP forwarding.

Se puede comprobar con:

```bash
sysctl net.ipv4.ip_forward
```

El resultado esperado es:

```text
net.ipv4.ip_forward = 1
```

Si aparece `1`, el sistema está preparado para enrutar tráfico entre diferentes redes.

---

## Configuración persistente del routing

Para mantener el IP forwarding activo después de reiniciar el sistema, se configura:

```text
net.ipv4.ip_forward=1
```

en:

```text
/etc/sysctl.conf
```

Después se aplican los cambios con:

```bash
sudo sysctl -p
```

---

## Usuario de administración

El usuario utilizado para las tareas de administración es:

```text
bchecker
```

Este usuario permite acceder al sistema y realizar tareas administrativas cuando sea necesario.

---

## Acceso SSH

El router permite administración remota mediante SSH.

Ejemplo:

```bash
ssh bchecker@192.168.20.1
```

Esto permite administrar `R-NCC` desde un equipo conectado a la Intranet.

---

## Pruebas de conectividad

Para comprobar que el router tiene acceso a los equipos de cada red se pueden realizar pruebas mediante `ping`.

### Cliente Linux

```bash
ping -c 4 192.168.20.20
```

### Cliente Windows

```bash
ping -c 4 192.168.20.30
```

### Servidor web W-NCC

```bash
ping -c 4 192.168.10.10
```

Estas pruebas permiten comprobar que `R-NCC` tiene conectividad con equipos de la DMZ y de la Intranet.

---

## Servicios relacionados

Actualmente R-NCC participa en:

- Routing entre redes.
- Acceso SSH.
- Conectividad entre DMZ e Intranet.
- Salida hacia la red exterior.

Durante los siguientes sprints también tendrá un papel importante en:

- Firewall.
- Reglas de acceso entre redes.
- NAT.
- Control de tráfico.
- Seguridad de la infraestructura.

---

## Seguridad

La configuración de seguridad del router se ampliará durante los siguientes sprints.

Está previsto aplicar reglas de firewall para controlar qué conexiones están permitidas entre:

```text
Exterior
DMZ
Intranet
```

El servidor de base de datos `B-NCC` no formará parte directa de estas redes en la arquitectura final.

La conexión de `B-NCC` se realizará mediante una red privada aislada conectada únicamente a `W-NCC`.

---

## Dependencias

Para que el router funcione correctamente se necesita:

- Interfaces de red configuradas.
- IP forwarding habilitado.
- Direcciones IP correctas.
- Rutas configuradas.
- Servicios de red activos.
- Firewall configurado correctamente cuando se implemente.

---

## Comandos de comprobación rápida

```bash
hostname
ip a
ip route
sysctl net.ipv4.ip_forward
systemctl status ssh
```

Estos comandos permiten realizar una revisión rápida del estado del router.

---

## Mantenimiento básico

Durante el mantenimiento se recomienda comprobar:

```bash
ip a
```

para revisar las interfaces.

```bash
ip route
```

para comprobar las rutas.

```bash
sysctl net.ipv4.ip_forward
```

para verificar que el routing está habilitado.

También se recomienda comprobar el estado de SSH:

```bash
sudo systemctl status ssh
```

---

## Problemas habituales

### No existe conectividad con una red

Comprobar:

```bash
ip a
ip route
```

Revisar que la interfaz correspondiente tenga la dirección IP correcta.

### El router no reenvía tráfico

Comprobar:

```bash
sysctl net.ipv4.ip_forward
```

Debe devolver:

```text
net.ipv4.ip_forward = 1
```

### No funciona SSH

Comprobar:

```bash
sudo systemctl status ssh
```

Si el servicio está detenido:

```bash
sudo systemctl restart ssh
```

---

## Evidencias

> 📷 Añadir captura de `ip a` mostrando las interfaces de R-NCC.

> 📷 Añadir captura de `ip route`.

> 📷 Añadir captura de `sysctl net.ipv4.ip_forward`.

> 📷 Añadir captura de una prueba de conectividad con W-NCC o un cliente de la Intranet.

---

[← Volver a Documentación de Administrador](README.md)
