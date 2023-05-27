# Organizacion del Computador 1

## OC1-Snake-2S-2020

### BREVE EXPLICACION DE LA CONSIGNA
En base a un template que nos proporciona la "interfaz grafica" crear el juego de Snake en el lenguaje Assembly para procesadores ARM

#### ACLARACIONES
1\) Cada linea de codigo esta explicada en el propio codigo <br>
2\) Para ejecutar y probar el codigo se utilizo una QEMU con Raspberri Pi OS y PuTTY <br>
3\) Es un programa en lenguaje ensamblador ARM, por lo cual debe ser ejecutado en un procesador ARM o dentro de un emulador. <br>

#### COMO CORRER EL JUEGO
Abrir una consola dentro de Raspbian y ejecutar los sigueintes comandos: <br>
1\) as -g -o snake.o snake.asm <br>
2\) gcc -o snake snake.o <br>
3\) ./snake <br>

#### COMO JUGAR
El juego solo acepta una de estas 5 opciones y tiene un maximo de 5 niveles
- W (Arriba)
- S (Abajo)
- D (Derecha)
- A (Izquierda)
- Enter (hacer movimiento seleccionado)

[VIDEO DEMO](https://youtu.be/708RPzuk68g)
