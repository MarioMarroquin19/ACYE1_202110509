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
    MostrarTexto saltoLinea
    MostrarTexto serparacionColumnas
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
    
    MostrarTexto saltoLinea
    MostrarTexto serparacionColumnas
    MostrarTexto saltoLinea
    MostrarTexto tituloColumnas
            
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
    MOV CX, 5
    MOV DX, OFFSET regNombre
    INT 21h
ENDM

NuevoArchivo MACRO nombreArchivo, handleArchivo
    LOCAL errorNuevo, crearArchivo

    MOV AH, 3ch; interrupcion para crear un archivo
    MOV CX, 00h ; atributos del archivo
    LEA DX, nombreArchivo ; nombre del archivo
    INT 21h ; llamada a la interrupcion

    MOV handleArchivo, AX ; guardamos el manejador del archivo
    RCL BL, 1 ; guardamos el registro de banderas
    AND BL, 1 
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE errorNuevo
    JMP crearArchivo

    errorNuevo: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion seleccion

    crearArchivo:
ENDM

AbrirArchi MACRO nombreArchivo, handleArchivo
    LOCAL errorAbrir, abrirArchivo
    
    MOV BL, 0

    MOV AH, 3Dh ; abrir archivo
    MOV AL, 00h ; modo de lectura
    LEA DX, nombreArchivo ; nombre del archivo
    INT 21h ; llamada a la interrupcion

    MOV handleArchivo, AX ; guardamos el manejador del archivo
    RCL BL, 1 ; guardamos el registro de banderas
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE errorAbrir
    JMP abrirArchivo

    errorAbrir: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion seleccion
    
    abrirArchivo:


ENDM

CerrarArchi MACRO handleArchivo
    LOCAL errorCerrar, CerrarArchivo

    MOV AH, 3Eh ; cerrar archivo
    MOV BX, handleArchivo ; manejador del archivo
    INT 21h ; llamada a la interrupcion

    RCL BL, 1 ; guardamos el registro de banderas
    AND BL, 1
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE errorCerrar
    JMP CerrarArchivo

    errorCerrar: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion seleccion

    CerrarArchivo:

ENDM

LeerArchi MACRO buffer, handleArchivo
    LOCAL errorLeer, leerArchivo

    MOV AH, 3Fh ; leer archivo
    MOV BX, handleArchivo ; manejador del archivo
    MOV CX, 300 ; cantidad de bytes a leer
    LEA DX, buffer ; dirección del buffer
    INT 21h ; llamada a la interrupción

    MOV BL, 0
    RCL BL, 1 ; guardamos el registro de banderas
    CMP BL, 1; si hay un error, refrescar a la etiqueta error
    JE errorLeer
    JMP leerArchivo

    errorLeer: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion seleccion
    
    leerArchivo:
    
ENDM

EscribirArchi MACRO archivo, handleArchivo
    LOCAL errorEscribir, escribirArchivo

    MOV AH, 40h ; escribir en archivo
    MOV BX, handleArchivo ; manejador del archivo
    MOV CX, 56 ; cantidad de bytes a escribir, debe irse modificando dependiendo de cuanto vamos a escribir, si no salen simbolos raros
    LEA DX, archivo ; dirección del archivo
    INT 21h ; llamada a la interrupción

    RCL BL, 1 ; guardamos el registro de banderas
    AND BL, 1 ; si hay un error, refrescar a la etiqueta error
    CMP BL, 1
    JE errorEscribir
    JMP escribirArchivo

    errorEscribir: 
        MostrarTexto saltoLinea
        MostrarTexto textoErrorArchivo
        CapturarOpcion seleccion
    
    escribirArchivo:
    
ENDM

PosicionFinalApuntador MACRO handleArchivo
    MOV AH, 42h ; mover el apuntador de archivo
    MOV AL, 02h ; desde el final
    MOV BX, handleArchivo ; manejador del archivo
    MOV CX, 00h ; desplazamiento
    MOV DX, 00h ; desplazamiento
    INT 21h ; llamada a la interrupción
    
ENDM

RowMajorMatriz MACRO 
    MOV AL, filaPosible
    MOV BL, columnaPosible
    
    SUB AL, 49
    SUB BL, 97
    
    MOV BH, 8
    
    MUL BH
    ADD AL, BL
    
    MOV SI, AX
    MOV tablero[SI], 64
ENDM

MovimientoPiezas MACRO 
    MOV AL, filaPosible
    MOV BL, columnaPosible
    
    SUB AL, 49
    SUB BL, 97
    
    MOV BH, 8
    
    MUL BH
    ADD AL, BL
    MOV DL, AL ; Guardar el valor original de AL
    
    ; Después de la operación row-major
    MOV SI, AX

    ; Verificar qué pieza está en esa posición

    CMP tablero[SI], 84 ; Si es un torre (T en ASCII)
    MOV CH, 84; CH = T en ASCII
    JE VerificarCasillaTorreAdelante

    CMP tablero[SI], 67 ; Si es un caballo (C en ASCII)
    MOV CH, 67; CH = C en ASCII


    CMP tablero[SI], 65 ; Si es un alfil (A en ASCII)
    MOV CH, 65; CH = A en ASCII


    CMP tablero[SI], 82 ; Si es un rey  (R en ASCII)
    MOV CH, 82; CH = R en ASCII


    CMP tablero[SI], 42 ; Si es una reina (* en ASCII)
    MOV CH, 42; CH = * en ASCII


    CMP tablero[SI], 80 ; Si es un peón blanco (P en ASCII)
    MOV CH, 80; CH = P en ASCII
    JE VerificarCasillaPeonAdelante



    VerificarCasillaPeonAdelante:
        SUB AL, 16; Restar 16 a AL
        MOV SI, AX
        CMP tablero[SI], 32 ; Verifica si la casilla está vacía
        JE MoverPeonBlanco

        MOV AL, DL ; Restaurar el valor original de AL
        SUB AL, 8; Restar 8 a AL
        MOV SI, AX
        CMP tablero[SI], 32 ; Verifica si la casilla está vacía
        JE MoverPeonBlanco

        JMP SalidaMOV
    
        MoverPeonBlanco:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            MOV AL, DL ; Restaurar el valor original de AL
            SUB AL, 8; Restar 8 a AL
            MOV SI, AX
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP SalidaMOV
    
    VerificarCasillaTorreAdelante:
        MOV AL, DL ; Restaurar el valor original de AL
        SUB AL, 8; Restar 8 a AL
        MOV CL, 8
        MOV SI, AX
        CMP tablero[SI], 32 ; Verifica si la casilla está vacía
        JE MoverTorreBlancaAdelante
        JMP SalidaMOV
        
        MoverTorreBlancaAdelante:
            MOV AL, DL ; Restaurar el valor original de AL
            SUB AL, CL; Restar CL a AL
            ADD CL, 8; CL = CL + 8	
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XTorreBlanca
            JMP VerificarCasillaTorreDerecha

        XTorreBlanca:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverTorreBlancaAdelante
        
    VerificarCasillaTorreDerecha:
        MOV AL, DL ; Restaurar el valor original de AL
        ADD AL, 1; Sumar 1 a AL
        MOV CL, 1
        MOV SI, AX
        CMP tablero[SI], 32 ; Verifica si la casilla está vacía
        JE MoverTorreBlancaDerecha
        JMP SalidaMOV
        
        MoverTorreBlancaDerecha:
            MOV AL, DL ; Restaurar el valor original de AL
            ADD AL, CL; Sumar CL a AL
            INC CL; CL++
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XTorreBlancaDerecha
            JMP SalidaMOV

        XTorreBlancaDerecha:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverTorreBlancaDerecha


    SalidaMOV:

ENDM

MoverPieza MACRO 
    MOV AL, filaMov
    MOV BL, columnaMov
    
    SUB AL, 49
    SUB BL, 97
    
    MOV BH, 8
    
    MUL BH
    ADD AL, BL
    MOV DL, AL ; Guardar el valor original de AL
    
    ; Después de la operación row-major
    MOV SI, AX; a donde estoy moviendo la pieza

    ; Verificar qué pieza está en esa posición (P en ASCII)
    CMP CH, 80
    JE moverPeon

    CMP CH, 84 ; Si es un torre (T en ASCII)
    JE moverTorre

    CMP CH, 67 ; Si es un caballo (C en ASCII)
    JE moverCaballo

    CMP CH, 65 ; Si es un alfil (A en ASCII)
    JE moverAlfil

    CMP CH, 82 ; Si es un rey  (R en ASCII)
    JE moverRey

    CMP CH, 42 ; Si es una reina (* en ASCII)
    JE moverReina

    JMP SalidaMoverPieza

    moverCaballo:

    moverAlfil:

    moverRey:

    moverReina:

    moverTorre:
        MOV tablero[SI], 84

        MOV AL, filaPosible
        MOV BL, columnaPosible
        
        SUB AL, 49
        SUB BL, 97
        
        MOV BH, 8
        
        MUL BH
        ADD AL, BL
        MOV SI, AX
        MOV tablero[SI], 32

        JMP SalidaMoverPieza


    moverPeon:
        MOV tablero[SI], 80

        MOV AL, filaPosible
        MOV BL, columnaPosible
        
        SUB AL, 49
        SUB BL, 97
        
        MOV BH, 8
        
        MUL BH
        ADD AL, BL
        MOV SI, AX
        MOV tablero[SI], 32

        JMP SalidaMoverPieza

    SalidaMoverPieza:

ENDM

LimpiarTablero MACRO
    LOCAL RecorrerTablero, ReemplazarX

    MOV SI, 0

    RecorrerTablero:
        MOV DL, tablero[SI]; recorrido del tablero
        CMP DL, 120 ; Compara si el carácter es "x"
        JE ReemplazarX
        JNE Siguiente ; Si no es "x", salta a Siguiente

    ReemplazarX:
        MOV tablero[SI], 32; Reemplaza "x" por un espacio en blanco

    Siguiente:
        INC SI; incrementar SI en 1 -> SI++
        CMP SI, 64 ; si no ha pasado por todas las casillas, refrescar a la etiqueta RecorrerTablero
        JB RecorrerTablero; salto a RecorrerTablero si el índice es menor a 64
ENDM

.MODEL small

.STACK 64h

.DATA
    saltoLinea db 10, 13, "$" 
    textoInicio db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10,13, "FACULTAD DE INGENIERIA", 10, 13, "ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", "$"
    textoInicio1 db 10, 13,"SECCION A", 10, 13, "Primer Semestre 2024", 10, 13, "Mario Ernesto Marroquin Perez", 10, 13, "202110509", 10, 13, "Practica 3",10,13,10,13,"$"
    textoMenu db 10,13,"-----MENU PRINCIPAL-----", 10, 13, "1.Nuevo Juego", 10, 13, "2.Puntajes", 10, 13, "3.Reportes", 10, 13, "4.Salir", 10, 13, ">>Ingrese una opcion: ", "$"
    seleccion db 1 dup(32); 32 es vacío en ASCII
    filaPosible db 1 dup("$")
    columnaPosible db 1 dup("$")
    filaMov db 1 dup(32), "$"
    columnaMov db 1 dup(32), "$"
    tituloColumnas db "  A B C D E F G H", "$"
    serparacionColumnas db " |-|-|-|-|-|-|-|-|", "$"
    etiquetaFila db "12345678", "$"
    tablero db 64 dup(32) ; row-major o column-major
    textoNombreJugador db "Ingrese nickname (5 letras): ", "$"
    nombreJugador db 5 dup(' '),'$'; 5 caracteres para el nombre
    textoInicioJuego db "   vs  IA      Turno: ", 10, 13, "$"
    handleArchivo DW ? ; Define handleArchivo como una variable de palabra (word) manejador del archivo de 16 bits
    nombreArchivo db "puntajes.txt", 00h ; nombre del archivo, terminar con 00h
    textoErrorArchivo db "Error con el archivo", '$'
    textoCreacion db 10, 13, "El Archivo Se Creo Correctamente", "$"
    contenidoPrueba db "Este es un texto de prueba para escribir en los archivos"
    buffer db 300 dup("$") ; Buffer para almacenar el contenido leido de un archivo
    textoIngreseFila db "Ingrese la fila: ", "$"
    textoIngreseColumna db "Ingrese la columna (letra minuscula): ", "$"
    textoMovimientos db "Seleccione una pieza para visualizar los posibles movimientos", "$"
    textoMovimiento db "Elija el movimiento a realizar", "$"

.CODE

    MOV AX, @data
    MOV DS, AX

    Principal PROC
        BorrarPantalla
        MostrarTexto textoInicio
        MostrarTexto textoInicio1

        Menu:
            MostrarTexto textoMenu
            CapturarOpcion seleccion            ;obtener la opción que el usuario elige

            CMP seleccion, 49 ; 49 es el valor ASCII de 1, estamos estimulando el registro de banderas
            JE MostrarTablero
            
            ;CMP seleccion, 50 ; 50 es el valor ASCII de 2, estamos estimulando el registro de banderas
            ;JE MostrarPuntajes

            CMP seleccion, 51 ; 51 es el valor ASCII de 3, estamos estimulando el registro de banderas
            JE MostrarReportes1

            CMP seleccion, 52 ; 52 es el valor ASCII de 4, estamos estimulando el registro de banderas
            JE SalidaRapida2
                        
            JMP Menu

        SalidaRapida2:
            JMP Salida
        
        MostrarReportes1:
            JMP MostrarReportes

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
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            JMP Jugar
        
        Jugar:
            MostrarTexto textoMovimientos
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto textoIngreseFila
            CapturarOpcion filaPosible
            MostrarTexto saltoLinea
            MostrarTexto textoIngreseColumna
            CapturarOpcion columnaPosible
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea

            ; aqui poner de nuevo el tablero con los movimientos posibles de dicha pieza
            MovimientoPiezas
            DibujarTablero


            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto textoMovimiento
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto textoIngreseFila
            CapturarOpcion filaMov ; elegir uno de los movimientos posibles
            MostrarTexto saltoLinea
            MostrarTexto textoIngreseColumna
            CapturarOpcion columnaMov
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea

            ; aqui poner de nuevo el tablero con el movimiento de la pieza
            LimpiarTablero
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MoverPieza
            DibujarTablero
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea


            ;CapturarOpcion seleccion
            JMP Jugar

        
        SalidaRapida: ; Salida rápida (salto corto)
            JMP Salida


        MostrarReportes:
            NuevoArchivo nombreArchivo, handleArchivo
            CMP seleccion, 13 ;verificamos que no exista error
            JE SalidaRapida

            ;PosicionFinalApuntador handleArchivo
            EscribirArchi contenidoPrueba, handleArchivo
            CMP seleccion, 13
            JE SalidaRapida3

            CerrarArchi handleArchivo
            CMP seleccion, 13
            JE SalidaRapida3
            JMP SeguirArchivos

        SalidaRapida3:
            JMP Salida

        SeguirArchivos: 
            MostrarTexto textoCreacion
            CapturarOpcion seleccion

            AbrirArchi nombreArchivo, handleArchivo
            CMP seleccion, 13
            JE SalidaRapida3

            LeerArchi buffer, handleArchivo
            CMP seleccion, 13
            JE Salida

            CerrarArchi handleArchivo
            CMP seleccion, 13
            JE Salida


        Salida: 
            MostrarTexto buffer
            MOV AX, 4C00h ;terminar el programa(interrupción)
            INT 21h

    Principal ENDP
END