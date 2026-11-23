#!/usr/bin/env bash

# Comprobaciones auxiliares de la infraestructura P.0-ASIXc2A-G03
# Script de solo lectura preparado para la validación final.

echo "=== Interfaces ==="
ip -brief address

echo
echo "=== Rutas ==="
ip route

echo
echo "=== Gateway R-NCC ==="
ping -c 4 192.168.20.1 || true

echo
echo "=== W-NCC HTTP ==="
if command -v curl >/dev/null 2>&1; then
  curl -I --max-time 5 http://192.168.10.10/ || true
else
  echo "curl no está instalado"
fi

echo
echo "=== F-NCC puerto 21 ==="
if command -v nc >/dev/null 2>&1; then
  nc -zv -w 5 192.168.10.20 21 || true
else
  echo "nc no está instalado"
fi

echo
echo "=== DNS interno ==="
if command -v getent >/dev/null 2>&1; then
  getent hosts w-ncc.asix3jyt.local || true
  getent hosts f-ncc.asix3jyt.local || true
fi

echo
echo "=== Fin de comprobaciones ==="
