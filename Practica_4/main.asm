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

MostrarTextoColor MACRO registroTexto, color, caracteres
    mov ah, 9
    mov bl, color; el color
    mov cx, caracteres ; numero de caracteres
    int 10h
    mov DX,OFFSET registroTexto
    int 21H

ENDM

CambiarModoVideo MACRO
    MOV AL, 13h
    MOV AH, 00h
    INT 10h    
ENDM

CambiarModoTexto MACRO
    MOV AL, 03h
    MOV AH, 00h
    INT 10h
ENDM

ImprimirCadenaPersonalizada MACRO cadena, pagina, color, caracteres, columna, fila
    MOV AH, 13h         ; Interrupcion
    MOV AL, 1           ; 00000011 -> MOV AL, 2 Modo Escritura
    MOV BH, pagina      ; Pagina a Utilizar
    MOV BL, color       ; Color de la Letra
    MOV CX, caracteres  ; Cantidad De Caracteres 
    MOV DL, columna     ; Columna 
    MOV DH, fila        ; Fila 
    LEA BP, cadena      ; Offset de la segunda cadena 2 en B
    INT 10h
ENDM

DibujarTableroTotito MACRO
    MOV AL, 09h   
    MOV CX, 45     ; columna
    MOV DX, 0       ; fila
    MOV AH, 0Ch   

    Barra1:
        INT 10h
        INC DX
        CMP DX, 145
        JB Barra1
        INC CX
        CMP CX, 50
        JA ContinuarBarra2
        MOV DX, 0
        JMP Barra1
    
    ContinuarBarra2:
            MOV CX, 95
            MOV AL, 09h
            MOV DX, 0

    Barra2:
        INT 10h
        INC DX
        CMP DX, 145
        JB Barra2
        INC CX
        CMP CX, 100
        JA ContinuarBarra3
        MOV DX, 0
        JMP Barra2
    
    ContinuarBarra3:
        MOV CX, 0
        MOV AL, 09h
        MOV DX, 45
    
    Barra3:
        INT 10h
        INC CX
        CMP CX, 145
        JB Barra3
        INC DX
        CMP DX, 50
        JA ContinuarBarra4
        MOV CX, 0
        JMP Barra3

    ContinuarBarra4:
        MOV CX, 0
        MOV AL, 09h
        MOV DX, 95

    Barra4:
        INT 10h
        INC CX
        CMP CX, 145
        JB Barra4
        INC DX
        CMP DX, 100
        JA TableroTerminado
        MOV CX, 0
        JMP Barra4
    
    TableroTerminado:
        MOV AH, 86h
        MOV CX, 20
        INT 15h
        MOV CX, 0
        MOV DX, 0
        MOV AL, 03h
        MOV AH, 00h
        INT 10h

ENDM

Delay MACRO tiempo
    MOV AH, 86h
    MOV CX, tiempo
    INT 15h
ENDM

CapturarFilaColumna MACRO buffer, tamBuffer
    ; Asumimos que 'buffer' es donde se almacenará la cadena introducida
    ; y 'tamBuffer' es el tamaño del búfer de entrada.

    ; Inicializar variables
    MOV DI, 0                 ; Índice para el búfer

    LeerEntrada:
        MOV AH, 00h          ; Función de lectura de teclado
        INT 16h              ; Llamar a la interrupción del teclado
        CMP AL, 13           ; Verificar si se presionó Enter (retorno de carro)
        JE FinCaptura         ; Si es Enter, terminar la captura
        CMP AL, 8            ; Verificar si se presionó Backspace
        JE BorrarCaracter    ; Si es Backspace, borrar el último carácter

        ; Comprobar si el búfer está lleno
        CMP DI, tamBuffer
        JE LeerEntrada       ; Si está lleno, ignorar la entrada

        ; Almacenar el carácter leído en el búfer
        MOV [buffer + DI], AL
        INC DI               ; Incrementar el índice del búfer

        ; Mostrar el carácter (opcional)
        MOV AH, 0Eh          ; Función de video para mostrar carácter
        INT 10h              ; Llamar a la interrupción de video

        JMP LeerEntrada      ; Leer el siguiente carácter

    BorrarCaracter:
        ; Verificar si hay algo que borrar
        CMP DI, 0
        JE LeerEntrada      ; Si el índice es 0, no hay nada que borrar
        DEC DI              ; Decrementar el índice del búfer
        JMP LeerEntrada     ; Continuar con la lectura de entrada

    FinCaptura:
        ; Agregar el carácter nulo al final de la cadena
        MOV BYTE PTR [buffer + DI], 0

        ; En este punto, 'buffer' contiene la cadena de entrada.
        ; Ahora podrías convertir los caracteres numéricos a valores reales
        ; y separarlos en dos variables 'fila' y 'columna'.
ENDM


.MODEL small
.STACK 64h

.DATA
    ln db 10, 13, "$"
    textoInicio db "|M|E|N|U| |P|R|I|N|C|I|P|A|L|", "$"
    textoAdorno db "+-+-+-+-+ +-+-+-+-+-+-+-+-+-+", "$"
    textoOpciones db "|1.| NUEVO JUEGO", 10,13,10,13, "|2.| ANIMACION", 10,13,10,13, "|3.| INFORMACION", 10,13,10,13, "|4.| SALIR", 10,13,10,13, ">>Ingrese una opcion: ", "$"
    textoInfo db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10,13, "FACULTAD DE INGENIERIA", 10, 13, "ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", "$"
    textoInfo1 db 10, 13,"SECCION A", 10, 13, "Primer Semestre 2024", 10, 13, "Mario Ernesto Marroquin Perez", 10, 13, "202110509", 10,13,"$"
    textoPractica db "****  P R A C T I C A   4  ****","$"
    textoPracticaAdorno db "*******************************", "$"
    opcion db 1 dup(32);
    textoRegresar db "Presione una tecla para regresar al menu: ", "$"
    textoOpcion db "**** INGRESE UNA OPCION ****", "$"
    textoIngresarOpcion db ">>Ingrese una opcion: ","$"
    opcionTotito1 db "|1.| 1 vs CPU", "$"
    opcionTotito2 db "|2.| 1 vs 1", "$"
    opcionTotito3 db "|3.| Reportes", "$"
    opcionTotito4 db "|4.| Regresar", "$"
    textoIngreseMov db "Ingrese su movimiento (fila;columna): ", "$"
    MAX_TAM_BUFFER EQU 5         ; Asume 5 para "1:3" y el carácter de terminación
    bufferEntrada  DB MAX_TAM_BUFFER DUP(?) ; Define el buffer con el tamaño máximo


.CODE

    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    MOV AX, 03h ; Definimos el modo video AH = 0h | AL = 03h
    INT 10h


    Principal PROC
        BorrarPantalla

        Menu:
            BorrarPantalla
            MostrarTextoColor textoAdorno, 0Bh, 29
            MostrarTexto ln
            MostrarTextoColor textoInicio, 0Bh, 29
            MostrarTexto ln
            MostrarTextoColor textoAdorno, 0Bh, 29
            MostrarTexto ln
            MostrarTexto ln
            MostrarTexto textoOpciones
            CapturarOpcion opcion

            CMP opcion, 49
            JE NuevoJuego

            CMP opcion, 50
            JE Animacion2

            CMP opcion, 51
            JE Informacion2

            CMP opcion, 52
            JE Salir2

            JMP Menu

            Animacion2:
                JMP Animacion3

            Informacion2:
                JMP Informacion3
            
            Salir2:
                JMP Salir3

            NuevoJuego:
                BorrarPantalla
                CambiarModoTexto
                ImprimirCadenaPersonalizada textoOpcion, 0, 0Bh, 28, 0, 1
                ImprimirCadenaPersonalizada opcionTotito1, 0, 0Ch, 13, 0, 3
                ImprimirCadenaPersonalizada opcionTotito2, 0, 0Ah, 11, 0, 5
                ImprimirCadenaPersonalizada opcionTotito3, 0, 0Dh, 13, 0, 7
                ImprimirCadenaPersonalizada opcionTotito4, 0, 0Eh, 13, 0, 9
                ImprimirCadenaPersonalizada textoIngresarOpcion, 0, 0Fh, 22, 0, 11
                CapturarOpcion opcion ;evniarme al modo de juego seleccionado

                CMP opcion, 49; (1) 1 vs CPU
                    JE JuegoVsIA

                CMP opcion, 50; (2) 1 vs 1
                    JE auxJuegoVsJugador
                    ;Debo ir al modo video y dibujar el tablero de totito 

                CMP opcion, 51; (3) Reportes
                    JE auxReportesJuego
                    ;Debo ir al modo video y dibujar el tablero de totito 

                CMP opcion, 52; (4) Regresar 
                    ;regresar al modo texto y volver al menu principal
                    CambiarModoTexto
                    JMP Menu

            auxJuegoVsJugador:
                JMP JuegoVsJugador

            auxReportesJuego:
                JMP ReportesJuego

            JuegoVsIA:
                BorrarPantalla
                CambiarModoVideo
                DibujarTableroTotito
                CambiarModoTexto
                BorrarPantalla
                CambiarModoTexto
                ImprimirCadenaPersonalizada textoIngreseMov, 0, 0Fh, 38, 0, 0
                CapturarFilaColumna bufferEntrada, MAX_TAM_BUFFER 
                JMP Menu
            
            auxMenu:
                JMP Menu

            JuegoVsJugador:
                JE auxMenu

            ReportesJuego:
                JE auxMenu

            Animacion3:
                JMP Animacion

            Informacion3:
                JMP Informacion
            
            Salir3:
                JMP Salir

            Animacion: 
                BorrarPantalla
                JMP Menu

            Informacion:
                BorrarPantalla
                MostrarTextoColor textoPracticaAdorno, 0Bh, 31
                MostrarTexto ln
                MostrarTextoColor textoPractica, 0Bh, 31
                MostrarTexto ln
                MostrarTextoColor textoPracticaAdorno, 0Bh, 31
                MostrarTexto ln
                MostrarTexto ln
                MostrarTexto textoInfo
                MostrarTexto textoInfo1
                MostrarTexto ln
                MostrarTexto ln
                MostrarTexto textoRegresar
                CapturarOpcion opcion
                JMP Menu

            Salir:  
                MOV AH, 4Ch
                INT 21h
                
    Principal ENDP
END