# Configuraciones del proyecto

Esta carpeta contiene extractos de configuración que corresponden a elementos realmente utilizados durante el despliegue.

El objetivo no es duplicar toda la documentación de administrador, sino conservar configuraciones clave que ayudan a reproducir o verificar la infraestructura.

## Archivos

- [B-NCC-netplan.yaml](./B-NCC-netplan.yaml)  
  Configuración final de red de B-NCC después de eliminar la interfaz Default de IsardVDI.

- [R-NCC-nat-ufw.txt](./R-NCC-nat-ufw.txt)  
  Fragmento de las reglas NAT persistentes utilizadas en R-NCC.

## Nota de seguridad

No se incluyen:

- contraseñas
- hashes sensibles
- claves privadas
- secretos
- credenciales de servicios

La documentación completa se encuentra en [Doc_Administrador](../Doc_Administrador/).
