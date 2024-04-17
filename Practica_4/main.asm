BorrarPantalla MACRO
    MOV AX, 03h
    INT 10h
ENDM

MostrarTexto MACRO registroTexto
    MOV AH, 09h
    LEA DX, registroTexto
    INT 21h    
ENDM

MostrarTextoColor MACRO registroTexto, color, caracteres
    mov ah, 9
    mov bl, color; el color
    mov cx, caracteres ; numero de caracteres
    int 10h
    mov DX,OFFSET registroTexto
    int 21H

ENDM

CapturarOpcion MACRO regSeleccion
    MOV AH, 01h
    INT 21h
    MOV regSeleccion, AL
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
    LOCAL Barra1, Barra2, Barra3, Barra4, SalirTablero
    XOR AX, AX
    XOR CX, CX
    XOR DX, DX

    MOV AL, 09h
    MOV CX, 45
    MOV DX, 0
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
        MOV DX, 95

    Barra4:
        INT 10h

        INC CX

        CMP CX, 145
        JB Barra4

        INC DX

        CMP DX, 100
        JA SalirTablero
        MOV CX, 0
        JMP Barra4

    SalirTablero:
ENDM

DibujarXenTablero MACRO
    LOCAL Ciclo1, Ciclo2
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV BL, columna
    MOV CL, posicionesColumna[BX]

    MOV BL, fila
    MOV DL, posicionesFila[BX]

    MOV AL, 6
    MOV AH, 0Ch
    MOV BL, 0

    Ciclo1:
        INT 10h

        INC CX
        INC DX
        INC BL
        CMP BL, 30
        JNE Ciclo1

    MOV BL, columna
    MOV CL, posicionesColumna[BX]
    ADD CL, 30

    MOV BL, fila
    MOV DL, posicionesFila[BX]

    MOV BL, 0

    Ciclo2:
        INT 10h

        DEC CX
        INC DX
        INC BL
        CMP BL, 30
        JNE Ciclo2
ENDM

DibujarOenTablero MACRO 
    LOCAL Part1, Part2, Part3, Part4
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV AL, 10
    MOV AH, 0Ch

    MOV BL, columna
    MOV CL, posicionesColumna[BX]
    
    MOV BL, fila
    MOV DL, posicionesFila[BX]

    MOV BL, 0

    Part1:
        INT 10h

        INC CX
        INC BL
        CMP BL, 31
        JNE Part1

    MOV BL, columna
    MOV CL, posicionesColumna[BX]

    MOV BL, 0

    Part2:
        INT 10h

        INC DX
        INC BL
        CMP BL, 31
        JNE Part2

    MOV BL, columna
    MOV CL, posicionesColumna[BX]
    ADD CL, 30
    
    MOV BL, fila
    MOV DL, posicionesFila[BX]
    ADD DL, 30

    MOV BL, 0

    Part3:
        INT 10h

        DEC CX
        INC BL
        CMP BL, 31
        JNE Part3

    MOV BL, columna
    MOV CL, posicionesColumna[BX]
    ADD CL, 30

    MOV BL, 0

    Part4:
        INT 10h

        DEC DX
        INC BL
        CMP BL, 31
        JNE Part4
ENDM

InfoEstudiante MACRO
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
ENDM

Delay MACRO tiempo
    MOV AH, 86h
    MOV CX, tiempo
    INT 15h
ENDM

PedirMovs MACRO 
    ImprimirCadenaPersonalizada textoIngreseMov, 0, 0Fh, 38, 0, 0
    CapturarOpcion fila
    
    SUB AL, 49
    MOV fila, AL

    ;posición del cursor
    MOV AH, 03h   ; Función para leer la posición del cursor
    MOV BH, 0     ; Número de página
    INT 10h       ; Interrupción del BIOS para video

    ; DL = posición del cursor en columna, DH = posición del cursor en fila

    ; Imprimir el punto y coma en la posición actual del cursor
    ImprimirCadenaPersonalizada puntoYcoma, 0, 0Fh, 1, DL, DH

    ; Incrementar la posición de la columna para no sobrescribir el ;
    INC DL

    CapturarOpcion columna
    SUB AL, 49
    MOV columna, AL


ENDM

SalirMacro MACRO 
    MOV AH, 4Ch
    INT 21h
ENDM

JuegoVsJugadorMacro MACRO
    MOV AL, 13h
    MOV AH, 00h
    INT 10h

    DibujarTableroTotito

    CMP turno, 0
    JE PintarSpriteX

    CMP turno, 1
    JE PintarSpriteO

    PintarSpriteX:
        DibujarXenTablero
        MOV AL, turno
        INC AL
        MOV turno, AL
        JMP ContinuarModoVideo

    PintarSpriteO:
        DibujarOenTablero
        MOV AL, turno
        DEC AL
        MOV turno, AL

    ContinuarModoVideo:
        MOV AH, 10h
        INT 16h

        MOV AL, 03h
        MOV AH, 00h
        INT 10h
ENDM

.MODEL small
.STACK 100h

.DATA
    posicionesColumna db 8, 57, 107
    posicionesFila db 6, 57, 105
    ln db 10, 13, "$"
    textoInicio db "|M|E|N|U| |P|R|I|N|C|I|P|A|L|", "$"
    textoAdorno db "+-+-+-+-+ +-+-+-+-+-+-+-+-+-+", "$"
    textoOpciones db "|1.| NUEVO JUEGO", 10,13,10,13, "|2.| ANIMACION", 10,13,10,13, "|3.| INFORMACION", 10,13,10,13, "|4.| SALIR", 10,13,10,13, ">>Ingrese una opcion: ", "$"
    textoInfo db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10,13, "FACULTAD DE INGENIERIA", 10, 13, "ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", "$"
    textoInfo1 db 10, 13,"SECCION A", 10, 13, "Primer Semestre 2024", 10, 13, "Mario Ernesto Marroquin Perez", 10, 13, "202110509", 10,13,"$"
    textoPractica db "****  P R A C T I C A   4  ****","$"
    textoPracticaAdorno db "*******************************", "$"
    opcion db 1 dup(32);
    fila db 0
    columna db 0
    textoRegresar db "Presione una tecla para regresar al menu: ", "$"
    textoOpcion db "**** INGRESE UNA OPCION ****", "$"
    textoIngresarOpcion db ">>Ingrese una opcion: ","$"
    opcionTotito1 db "|1.| 1 vs CPU", "$"
    opcionTotito2 db "|2.| 1 vs 1", "$"
    opcionTotito3 db "|3.| Reportes", "$"
    opcionTotito4 db "|4.| Regresar", "$"
    textoIngreseMov db "Ingrese su movimiento (fila;columna): ", "$"
    puntoYcoma db ";", "$"
    jugadores db "JUGADOR 1 ES X, JUGADOR 2 ES []", "$"
    textoSalida db "Presione ESC para finalizar la partida", "$"
    turno db 0
    gameBoard db 9 DUP(0) ; Inicia el tablero con 0

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
                SalirMacro

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

                CMP opcion, 51; (3) Reportes
                    JE auxReportesJuego

                CMP opcion, 52; (4) Regresar 
                    CambiarModoTexto
                    JMP Menu

            auxJuegoVsJugador:
                JMP JuegoVsJugador

            auxReportesJuego:
                JMP ReportesJuego

            JuegoVsIA:
                JMP Menu
            
            auxMenu:
                JMP Menu

            JuegoVsJugador:
                BorrarPantalla
                CambiarModoTexto
                ImprimirCadenaPersonalizada jugadores, 0, 0Eh, 31, 0, 0
                ImprimirCadenaPersonalizada textoSalida, 0, 0Ah, 38, 0, 3
                CapturarOpcion opcion
                CMP opcion, 27
                JE NuevoJuego
                BorrarPantalla
                PedirMovs
                JuegoVsJugadorMacro
                JMP JuegoVsJugador

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
                InfoEstudiante
                CapturarOpcion opcion
                JMP Menu

            Salir:  
                MOV AH, 4Ch
                INT 21h
                
    Principal ENDP
END