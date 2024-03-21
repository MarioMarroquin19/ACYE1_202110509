BorrarPantalla MACRO
    MOV AX, 03h
    INT 10h
ENDM

MostrarTexto MACRO registroTexto
    MOV AH, 09h
    LEA DX, registroTexto
    INT 21h    
ENDM

CapturarOpcion MACRO regSeleccion
    MOV AH, 01h
    INT 21h
    MOV regSeleccion, AL
ENDM

DibujarTablero MACRO
    LOCAL filaActual, columnaActual 

    MOV BX, 0 ; índice del indicador de fila (1-8)
    XOR SI, SI ; índice del tablero (0-63)

    MostrarTexto tituloColumnas
    MOV CL, 0; índice de la columna (A-H)

    filaActual: 
        MostrarTexto saltoLinea
        MOV AH, 02h; código interrupción, imprimir un carácter
        MOV DL, etiquetaFila[BX]; carácter a imprimir
        INT 21h; llamar interrupción

        MOV DL, 32 ; carácter espacio en blanco 
        INT 21h

        columnaActual: 
            MOV DL, tablero[SI]; recorrido del tablero
            INT 21h

            MOV DL, 124; carácter |
            INT 21h

            INC CL; incrementar CL en 1 -> CL++
            INC SI; incrementar SI en 1 -> SI++

            CMP CL, 8 ; si no ha pasado por las 8 columnas, refrescar a la etiqueta columnaActual
            JB columnaActual; salto a columnaActual

            MOV CL, 0 ; reiniciar el contador de columnas
            INC BX; incrementar índice indicador de filas BX en 1 -> BX++

            CMP BX, 8; Si no ha pasado por todas las filas que refrese a la etiqueta filaActual
            JB filaActual
            
ENDM

RellenarTablero MACRO 
    LOCAL rellenarPeonBlanco, rellenarPeonNegro, PiezasBlancas, PiezasNegras


    MOV SI, 0; índice del tablero
    MOV CH, 0; CONTADOR DE PEONES

    PiezasBlancas:
        MOV DL, 116; carácter a guardar en el tablero
        MOV tablero[SI], DL; escribir carácter en el tablero
        PUSH DX; guardamos el registro en la pila
        INC SI; incrementamos el índice del tablero

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
        MOV tablero[SI], DL; escribimos el carácter en el tablero
        INC SI; incrementamos índice del tablero -> SI++

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

    rellenarPeonBlanco:
        MOV tablero[SI], 112; escribimos el carácter en el tablero
        INC SI ; incrementamos índice del tablero
        INC CH; incrementamos el contador de peones

        CMP CH, 8 ; si es menor que regrese a la etiqueta rellenarPeonBlanco, caso contrario a rellenarPeonNegro
        JB rellenarPeonBlanco

        MOV CH, 0; CONTADOR DE PEONES
        MOV SI, 48
    
    rellenarPeonNegro:
        MOV tablero[SI], 80
        INC SI
        INC CH

        CMP CH, 8
        JB rellenarPeonNegro

    PiezasNegras:
        MOV DL, 84 ; "T" en ASCII
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 67 ; "C" en ASCII
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 65 ; "A" en ASCII
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 82 ; "R" en ASCII
        MOV tablero[SI], DL
        INC SI

        MOV DX, 42 ; "*" en ASCII
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

CapturarNombre MACRO regNombre
    MOV AH, 3fh
    MOV BX, 00H
    MOV CX, 10
    MOV DX, OFFSET regNombre
    INT 21h
ENDM

NuevoArchivo MACRO nombreArchivo, handle



    LOCAL error, crearArchivo

    MOV BL, 0

    MOV AH, 3ch; interrupcion para crear un archivo
    MOV CX, 00h ; atributos del archivo
    LEA DX, nombreArchivo ; nombre del archivo
    INT 21h ; llamada a la interrupcion

    MOV handle, AX ; guardamos el manejador del archivo
    RCL BL, 1 ; guardamos el registro de banderas
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE error
    JMP crearArchivo

    error: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion

    crearArchivo:



ENDM

AbrirArchi MACRO nombreArchivo, handle

    LOCAL error, abrirArchivo
    
    MOV BL, 0

    MOV AH, 3Dh ; abrir archivo
    MOV AL, 00h ; modo de lectura
    LEA DX, nombreArchivo ; nombre del archivo
    INT 21h ; llamada a la interrupcion

    MOV handle, AX ; guardamos el manejador del archivo
    RCL BL, 1 ; guardamos el registro de banderas
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE error
    JMP abrirArchivo

    error: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion
    
    abrirArchivo:


ENDM

CerrarArchi MACRO handle
    LOCAL error, CerrarArchivo

    MOV AH, 3Eh ; cerrar archivo
    MOV BX, handle ; manejador del archivo
    INT 21h ; llamada a la interrupcion

    MOV BL, 0
    RCL BL, 1 ; guardamos el registro de banderas
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE error
    JMP CerrarArchivo

    error: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion

    CerrarArchivo:

ENDM

LeerArchi MACRO buffer, handle
    LOCAL error, leerArchivo

    MOV AH, 3Fh ; leer archivo
    MOV BX, handle ; manejador del archivo
    MOV CX, 70 ; cantidad de bytes a leer
    LEA DX, buffer ; dirección del buffer
    INT 21h ; llamada a la interrupción

    MOV BL, 0
    RCL BL, 1 ; guardamos el registro de banderas
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE error
    JMP leerArchivo

    error: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion
    
    leerArchivo:
    
ENDM

EscribirArchi MACRO archivo, handle

    LOCAL error, escribirArchivo

    MOV AH, 40h ; escribir en archivo
    MOV BX, handle ; manejador del archivo
    MOV CX, 56 ; cantidad de bytes a escribir
    LEA DX, archivo ; dirección del archivo
    INT 21h ; llamada a la interrupción

    RCL BL, 1 ; guardamos el registro de banderas
    AND BL, 1 ; si hay un error, refrescar a la etiqueta error
    CMP BL, 1
    JE error
    JMP escribirArchivo

    error: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion
    
    escribirArchivo:
    
ENDM


.MODEL small

.STACK 64h

.DATA
    saltoLinea db 10, 13, "$"
    textoInicio db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10, 13, "FACULTAD DE INGENIERIA", 10, 13, "ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", 10, 13, "SECCION A", 10, 13, "Primer Semestre 2024", 10, 13, "Mario Ernesto Marroquin Perez", 10, 13, "202110509", 10, 13, "Practica 3",10,13,10,13, "$"
    textoMenu db 10,13,"-----MENU PRINCIPAL-----", 10, 13, "1.Nuevo Juego", 10, 13, "2.Puntajes", 10, 13, "3.Reportes", 10, 13, "4.Salir", 10, 13, ">>Ingrese una opcion: ", "$"
    seleccion db 1 dup("32"); 32 es vacío en ASCII
    tituloColumnas db "  A B C D E F G H", "$"
    etiquetaFila db "12345678", "$"
    tablero db 64 dup(32) ; row-major o column-major
    textoNombreJugador db "Ingrese su nombre: ", "$"
    nombreJugador db 10 dup(' '),'$'
    textoInicioJuego db "   vs  IA      Turno: ", 10, 13, "$"
    handleArchivo dw ? 
    textoArchivo db "puntajes.txt", 0
    textoErrorArchivo db "Error con el archivo", '$'
    buffer db 70 dup("$")
    contenidoPrueba db "Este es un texto de prueba a almacenar"

.CODE

    MOV AX, @data
    MOV DS, AX

    Principal PROC
        BorrarPantalla
        MostrarTexto textoInicio

        Menu:
            MostrarTexto textoMenu
            CapturarOpcion seleccion            ;obtener la opción que el usuario elige

            CMP seleccion, 49 ; 49 es el valor ASCII de 1, estamos estimulando el registro de banderas
            JE MostrarTablero
            
            CMP seleccion, 50 ; 50 es el valor ASCII de 2, estamos estimulando el registro de banderas
            JE MostrarPuntajes

            CMP seleccion, 51 ; 51 es el valor ASCII de 3, estamos estimulando el registro de banderas
            JE MostrarReportes

            CMP seleccion, 52 ; 52 es el valor ASCII de 4, estamos estimulando el registro de banderas
            JE Salida
                        
            JMP Menu

        MostrarTablero:
            BorrarPantalla
            MostrarTexto textoNombreJugador
            CapturarNombre nombreJugador ; captura el nombre con un máximo de 20 caracteres
            BorrarPantalla
            MostrarTexto nombreJugador
            MostrarTexto textoInicioJuego
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            RellenarTablero
            DibujarTablero

        MostrarPuntajes:


        MostrarReportes:


        Salida: 
            MOV AX, 4C00h ;terminar el programa(interrupción)
            INT 21h

    Principal ENDP
END