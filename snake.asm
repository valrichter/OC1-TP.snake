
.data
@ ------------ definicion de datos

mapa: .asciz "+------------------------------------------------+\n|               ****************                 |\n|               *** VIBORITA ***                 |\n|               ****************                 |\n+------------------------------------------------+\n|                                                |\n|                                                |\n|         @***                                   |\n|                                                |\n|                    M                           |\n|                                                |\n|                                                |\n|                                                |\n|                                                |\n+------------------------------------------------+\n| Puntaje:                      Nivel:           |\n+------------------------------------------------+\n"      @ \n enter
longitud = . - mapa

cls: .asciz "\x1b[H\x1b[2J" @una manera de borrar la pantalla usando ansi escape codes
lencls = .-cls

posManzanasX: .word 10, 42, 9, 38
posManzanasY: .word 6, 8, 10, 12
posActual: .word 0
posAnterior: .word 0
posCola: .word 0
posNivel: .word 0
posPuntaje: .word 0

nivel: .word 1
puntaje: .word 0

mensaje: .ascii "Moverse:\n"
letraDireccion: .ascii " "
mensajePerdio: .ascii "\n__GAME OVER__\n"

.text @ defincion de codigo del programa
@ ------------ codigo de las funciones

imprimirMapa:
      	.fnstart

	@parametros inputs: 
	@r1=puntero al string que queremos imprimir
	@r2=longitud de lo que queremos imprimir

	mov r7, #4   	@salida por pantalla  
	mov r0, #1    	@indicamos a SWI que sera una cadena           
	swi 0    	@SWI, software interrup
	
	bx lr		@salimos de la funcion 
	.fnend

leerTecla:
	.fnstart

	@imprimir por pantalla "Mensaje:\n"
	mov r7, #4  	@salida por pantalla
	mov r0, #1  	@salida cadena
	mov r2, #9 	@tamanio de la cadena
	ldr r1, =mensaje 
	swi 0       	@SWI, software interrup

	@leer el input del usuario
	mov r7, #3   	@lectura x teclado
	mov r0, #0  	@ingreso de cadena
	mov r2, #4   	@leer # caracteres
	ldr r1, =letraDireccion 	@donde se guarda la cadena ingresada
	
	swi 0   	@SWI, software interrup
	bx lr 		@salimos de la funcion 
	.fnend

calcularPosicion:
	.fnstart
	push {lr}

	@input, recibe como parametro r0 y r1 (fila y columna)
		
	ldr r3, =mapa 	@puntero a la matrix
	
	@calculamos el indice a la fila solicitada
	mov r4, #51
	mul r4, r0, r4  @r4=numero de fila * tamaño de fila
	add r3, r4

	@desplazarme hacia la columna correcta
	add r3,r1  	@r3= puntero a fila + columna
	
	@output r3 posicion calculada
	
	pop {lr}
	bx lr		@volvemos a donde nos llamaron
	.fnend
	
obtenerNuevaPosicion:
	.fnstart
	push {lr}	@push para no perder el indice
	
	@guardamos la posAnterior
	ldr r5, =posActual
	ldr r3, [r5]

	ldr r4, =posAnterior
	str r3, [r4]
			
	@recibe r1 como parametro

	cmp r1, #119 	@ascci W
	beq casoW 	@compara si son iguales y salta a la funcion

	cmp r1, #115 	@ascci S
	beq casoS 	@compara si son iguales y salta a la funcion

	cmp r1, #97 	@ascci A
	beq casoA 	@compara si son iguales y salta a la funcion

	cmp r1, #100 	@ascci D
	beq casoD 	@compara si son iguales y salta a la funcion

	cmp r1, #101 	@ascci E (para salir del juego)
	beq fin 	@compara si son iguales y salta a la funcion
	
	pop {lr}	@pop para volver al main
	bx lr
	.fnend

casoW:	
	.fnstart
	push {lr}

	sub r3, #51 	@suma la longitud de la lista con la posicion de la viborita
	str r3, [r5]	@actualizo la posActual en la memoria

	pop {lr}
	bx lr		@volvemos a donde nos llamaron
	.fnend

casoS:	
	.fnstart
	push {lr}

	add r3, #51 	@suma la longitud de la lista con la posicion de la viborita
	str r3, [r5]	@actualizo la posActual en la memoria

	pop {lr}
	bx lr		@volvemos a donde nos llamaron
	.fnend

casoA:	
	.fnstart
	push {lr}

	sub r3, #1 	@suma la longitud de la lista con la posicion de la viborita
	str r3, [r5]	@actualizo la posActual en la memoria

	pop {lr}
	bx lr		@volvemos a donde nos llamaron
	.fnend

casoD:	
	.fnstart
	push {lr}

	add r3, #1 	@suma la longitud de la lista con la posicion de la viborita
	str r3, [r5]	@actualizo la posActual en la memoria

	pop {lr}
	bx lr		@volvemos a donde nos llamaron
	.fnend

hayObstaculo:
	.fnstart
	@recibe como parametro r1

	cmp r1, #45	@ascci del -
	beq  fin	@si r1 == 45

	cmp r1, #124	@ascci del |
	beq  fin	@si r1 == 124
	
	cmp r1, #42	@ascci del *
	beq  fin	@si r1 == 42

	bx lr		@volvemos a donde nos llamaron
	.fnend

hayManzana:
	.fnstart
	push {lr}

	@recibe como parametro r1
	
	cmp r1, #77		@ascci del M
	beq  comerManzana	@si r1 == 77

	pop {lr}
	bx lr			@volvemos a donde nos llamaron
	.fnend

comerManzana:
	.fnstart
	push {lr}

	ldr r0, =puntaje	@sumamos 12 a la variable puntaje
	ldr r1, [r0]
	add r1, #12
	str r1, [r0]		@cargamos el valor modificado en memoria
	
	ldr r0, =nivel		@sumamos 1 a la variable nivel
	ldr r1, [r0]
	add r1, #1
	str r1, [r0]		@cargamos el valor modificado en memoria

	ldr r0, =posCola	
	ldr r1, [r0]		@r1 = posCola
	mov r2, #42 		@cod ascci del *
	add r1, #1
	str r1, [r0]
	strb r2, [r1]		@r0 = posCola
	
	bl generarComida

	pop {lr}
	bx lr			@volvemos a donde nos llamaron
	.fnend

convertir:
	.fnstart
	push {lr}
	
	mov r1, r0		@r1=A
	mov r2, #10	@r2=B
	bl division	@r0= A/B, r1=resto(A/B)
	mov r2, r0		@r2 = r0/10 //en r2 tenemos las decenas  

	mov r0, r1		@r0 = resto(r0/10)

	@calculamos las unidades
	mov r1, r0		@r1 = r0
	
        pop {lr}
        bx lr
	.fnend

division:		
	.fnstart
	push {lr}

	@input: 
	@r1 = A, r2 = B

	 mov r0, #0 	@en r0 vamos a contar cuantas veces entra B en A, es decir, r0 contentrá la división A/B

ciclo:			@while( A >= B )
        cmp r1, r2
        bcc finCiclo	@si A<B
        sub r1, r1, r2	@A = A - B
        add r0, r0, #1	@C = C + 1
        b ciclo

finCiclo:
	@r0=la division A/B , lo guardamos en la memoria C
	@en r1 quedaria el resto

	@output
	@r0 = A/B, r1 = resto(A/B)
	@C = 0

        pop {lr}
        bx lr
	.fnend

actualizarInfoBar:	
	.fnstart
	
	ldr r0, =posPuntaje
	ldr r0, [r0]	@r0 = posPuntajeDecena
	add r2, #48	@pasamos a ascci el int que esta en r2
	strb r2, [r0]	@ponesmos el ascci en posPuntajeDecena

	add r0, #1		@r0 = posPuntajeUnidad
	add r1, #48	@@pasamos a ascci el int que esta en r1
	strb r1, [r0]	@ponesmos el ascci en posPuntajeUnidad
	ldr r0, =posNivel
	ldr r0, [r0]	@r0 = posNivel
	ldr r1, =nivel	
	ldr r1, [r1]		@cargamos el valor del nivel
	add r1, #48	@pasamos a ascci el int que esta en r1
	strb r1, [r0]	@r0 = posNivel
  
	bx lr		@volvemos a donde nos llamaron
	.fnend

avanzarANuevaPosicionViborita:
	.fnstart
	push {lr}

	ldr r2, =posAnterior
	ldr r3, [r2]
	mov r1, #42 	@ascci del *
	strb r1, [r3]	@r3 = posAnterior

	ldr r2, =posActual
	ldr r3, [r2]
	mov r1, #64 	@ascci del @
	strb r1, [r3]	@r3 = posActual

	pop {lr}
	bx lr		
	.fnend 		

generarComida:
	.fnstart
	push {lr}
	
	ldr r0, [r8]	@numero de fila
	ldr r1, [r9]	@numero de columna
	bl calcularPosicion

sumar:
	mov r0, #32	@ascci del ' '
	add r3, #2	@sumamos 1 a la pos en r3=posManzanaNueva
	ldrb r2,[r3] 	
	cmp r2, r0
	bne sumar	@si no hay un espacio seguimos sumando 1 a la pos

	mov r1, #77	@ascci del M
	strb r1, [r3]	@r3 = pos de la manzana calculada
	
	add r8,r8, #4	@paso al siguiente numero en posManzanaY
	add r9,r9, #4	@paso al siguiente numero en posManzanaX

	pop {lr}
	bx lr
	.fnend

gameOver:
	.fnstart

	mov r7, #4      @salida por pantalla
	mov r0, #1      @salida cadena
	mov r2, #25     @tamanio de la cadena
	ldr r1, = mensajePerdio

	swi 0           @SWI, software interrup
	bx lr
	.fnend

limpiarPantalla:
	.fnstart

	mov r0, #1
      	ldr r1, =cls
      	ldr r2, =lencls
        mov r7, #4

        swi #0
	bx lr		
	.fnend

.global main @ global, visible en todo el programa
main:	
	@imprimimos el mapa
	ldr r1, =mapa		@Cargamos en r1 la direccion del mensaje
	ldr r2, =longitud	@Tamaño de la cadena 
	bl  imprimirMapa

	@calculamos la posicion inicial de la viborita
	mov r0, #7	@numero de fila
	mov r1, #10	@numero de columna
	bl calcularPosicion
   
	ldr r5, =posActual
	str r3, [r5]	@guardo el dato en posActual
   
	@calculamos la pos de la cola de la vibora para hacerla crecer
	mov r0, #7	@numero de fila
	mov r1, #13	@numero de columna
	bl calcularPosicion
   	
	ldr r5, =posCola
 	str r3, [r5]    	@guardo el dato en de donde esta la cola en posCola

	@calculamos la pos del Puntaje
	mov r0, #15	@numero de fila
	mov r1, #10	@numero de columna
 	bl calcularPosicion

	ldr r5, =posPuntaje
	str r3, [r5]    @guardo el dato en posPuntaje
   
	@calculamos la pos del Nivel
	mov r0, #15	@numero de fila
	mov r1, #38	@numero de columna
	bl calcularPosicion
   
	ldr r5, =posNivel
 	str r3, [r5]    @guardo el dato en posNivel
   	
	@obtenemos los punteros a las posiciones de las manzanas
	ldr r8, =posManzanasY	@puntero a memoria de las filas
	ldr r9, =posManzanasX	@puntero a memoria de las columnas

jugar:	
	@si el nivel es 5 da por terminado el juego
	ldr r0, =nivel
	ldr r0, [r0]
	cmp r0, #5
	beq fin	

	@leemos la tecla del usuario
	bl leerTecla

	@obtenemos la nueva poscicion a la que se muve la viborita
	ldr r1,	=letraDireccion
	ldrb r1, [r1]
	bl obtenerNuevaPosicion
	
	@nos fijamos si hay un obstaculo ('-' o '|' o '*')
	ldrb r1, [r3]
	bl hayObstaculo
	
	@nos fijamos si hay una manzana
	ldrb r1, [r3]
	bl hayManzana
	
	@avanzamos y ponemos la viborita en el mapa
	bl avanzarANuevaPosicionViborita
	
	@paso el entero puntaje a ascci
	ldr r0, =puntaje
	ldr r0, [r0]
	bl convertir

	@actualizo la barra de informacion
	bl actualizarInfoBar
	
	@limpiamos la pantalla
	bl limpiarPantalla
	
	@imprimimos el mapa
	ldr r1, =mapa  		@cargamos en r1 la direccion del mensaje
       	ldr r2, =longitud 	@tamanio de la cadena 
        bl  imprimirMapa

	@volvemos al ciclo
	bl jugar

fin:   
	
	@actualizo la barra de informacion
	@bl actualizarInfoBar
	
	@avanzamos y ponemos la viborita en el mapa
	bl avanzarANuevaPosicionViborita
	
	@limpiamos la pantalla
	bl limpiarPantalla	

	@imprimimos el mapa
	ldr r1, =mapa  		@cargamos en r1 la direccion del mensaje
	ldr r2, =longitud 	@tamanio de la cadena 
	bl  imprimirMapa

	@imprimimos el GAME OVER
	bl gameOver		

	mov r7, #1 		@salida al sistema
 	swi 0			@Syscall, interrumpcion de salida
