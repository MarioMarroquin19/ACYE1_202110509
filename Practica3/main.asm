LimpiarConsola MACRO
    MOV AX, 03h
    INT 10h
ENDM

ImprimirCadena MACRO registroPrint
    MOV AH, 09h
    LEA DX, registroPrint
    INT 21h    
ENDM

obtenerOpcion MACRO regOpcion
    MOV AH, 01h
    INT 21h
    MOV regOpcion, AL
ENDM

ImprimirTableJuego MACRO
    LOCAL fila, columna 

    MOV BX, 0 ; indice del indicador de fila (1-8)
    XOR SI, SI ; indice del tablero (0-63)

    ImprimirCadena indicadorColumnas
    MOV CL, 0; indice de la columna (A-H)

    fila: 
        ImprimirCadena salto
        MOV AH, 02h; código interrupcion, imprimir un caracter
        MOV DL, identificadorFila[BX]; caracter a imprimir
        INT 21h; llamar interrupcion

        MOV DL, 32 ; caracter espacio en blanco 
        INT 21h

        columna: 
            MOV DL, tablero[SI]; recorrido del tablero
            INT 21h

            MOV DL, 124; caracter |
            INT 21h

            INC CL; incrementar CL en 1 -> CL++
            INC SI; incrementar SI en 1 -> SI++

            CMP CL, 8 ; si no ha pasado por las 8 columnas, refrescar a la etiqueta columna
            JB columna; salto a columna

            MOV CL, 0 ; reiniciar el contador de columnas
            INC BX; incrementar indice indicador de filas BX en 1 -> BX++

            CMP BX, 8; Si no ha pasado por todas las filas que refrese a la etiqueta fila
            JB fila
            
ENDM


LlenarTablero MACRO 
    LOCAL llenarPeon1, llenarPeon2, Piezas1, Piezas2


    MOV SI, 0; indice del tablero
    MOV CH, 0; CONTADOR DE PEONES

    Piezas1:
        MOV DL, 116; caracter a guardar en el tablero
        MOV tablero[SI], DL; escribir caracter en el tablero
        PUSH DX; guardamos el registro en la pila
        INC SI; incrementamos el indice del tablero

        MOV DX, 99
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 97
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 114
        MOV tablero[SI], DL
        INC SI

        MOV DX, 35
        MOV tablero[SI], DL
        INC SI

        POP DX ; extraemos registro de la pila y lo almacenamos en DX
        MOV tablero[SI], DL; esribimos el caracter en el tablero
        INC SI; incrementamos indice del tablero -> si++

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

    llenarPeon1:
        MOV tablero[SI], 112; esribimos el caracter en el tablero
        INC SI ; incrementamos indice del tablero
        INC CH; incrementamos el contador de peones

        CMP CH, 8 ; si es menor que regrese a la etiqueta llenarPeon1, caso contrario a llenarPeon2
        JB llenarPeon1

        MOV CH, 0; CONTADOR DE PEONES
        MOV SI, 48
    
    llenarPeon2:
        MOV tablero[SI], 80
        INC SI
        INC CH

        CMP CH, 8
        JB llenarPeon2

    Piezas2:
        MOV DL, 116
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 99
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 97
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 114
        MOV tablero[SI], DL
        INC SI

        MOV DX, 35
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

ENDM


.MODEL small

.STACK 64h

.DATA
    salto db 10, 13, "$"
    mensajeIncio db "Universidad de San Carlos de Guatemala", 10, 13, "Facultad de Ingenieria", 10, 13, "ECYS", 10, 13, "$"
    mensajeMenu db "1.Nuevo Juego", 10, 13, "2.Puntajes", 10, 13, "3.Reportes", 10, 13, "4.Salir", 10, 13, ">>Ingrese una opcion: ", "$"
    opcion db 1 dup("32"); 32 es vacío en ascii
    indicadorColumnas db "  A B C D E F G H", "$"
    identificadorFila db "12345678", "$"
    tablero db 64 dup(32) ; row-major o column-major
.CODE

    MOV AX, @data
    MOV DS, AX

    Main PROC
        LimpiarConsola
        ImprimirCadena mensajeIncio

        Menu:
            ImprimirCadena mensajeMenu
            obtenerOpcion opcion            ;obtener la opcion que el usuario elije

            CMP opcion, 49 ; 49 es el valor ascii de 1, estamos estimulando el registro de banderas
            JE ImprimirTablero
            
            CMP opcion, 50 ; 50 es el valor ascii de 2, estamos estimulando el registro de banderas
            JE ImprimirPuntajes

            CMP opcion, 51 ; 51 es el valor ascii de 3, estamos estimulando el registro de banderas
            JE ImprimirReportes

            CMP opcion, 52 ; 52 es el valor ascii de 4, estamos estimulando el registro de banderas
            JE Salir
            
            
            JMP Menu


        
        ImprimirTablero:
            LimpiarConsola
            LlenarTablero
            ImprimirTableJuego

        ImprimirPuntajes:


        ImprimirReportes:


       Salir: 
            MOV AX, 4C00h ;terminar el programa(interrupcion)
            INT 21h

    Main ENDP
END