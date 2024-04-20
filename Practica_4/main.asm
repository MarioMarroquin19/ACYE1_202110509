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
    LOCAL Barra1, Barra2, Barra3, Barra4, SalirTablero, ContinuarBarra2, ContinuarBarra3, ContinuarBarra4
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
    ImprimirCadenaPersonalizada textoInfo, 0, 0Ah, 142, 0, 5
    ImprimirCadenaPersonalizada textoInfo1, 0, 09h, 77, 0, 8
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
    LOCAL MensajesEntrada, AlertaFilaAnuncio, AlertaColumnaAnuncio, SalirMovs
    
    MensajesEntrada:
        ImprimirCadenaPersonalizada textoIngreseMov, 0, 0Bh, 38, 0, 0
        CapturarOpcion fila    ; Captura el valor de 'fila' en formato ASCII

        CMP fila, 49   
        JB AlertaFilaAnuncio   

        CMP fila, 51
        JA AlertaFilaAnuncio

        ImprimirCadenaPersonalizada puntoYcoma, 0, 0Bh, 1, 39, 0
        CapturarOpcion columna ; Captura el valor de 'columna' en formato ASCII

        CMP columna, 49
        JB AlertaColumnaAnuncio

        CMP columna, 51
        JA AlertaColumnaAnuncio   

    MOV AL, fila    ; Mueve el valor ASCII de 'fila' a AL
    MOV BL, columna ; Mueve el valor ASCII de 'columna' a BL
    SUB AL, 49      ; Convierte AL de ASCII a índice numérico (0 basado)
    SUB BL, 49      ; Convierte BL de ASCII a índice numérico (0 basado)
    MOV fila, AL    ; Devuelve el valor convertido a la variable 'fila'
    MOV columna, BL ; Devuelve el valor convertido a la variable 'columna'
    MOV AH, 0       ; Limpia AH para usar AX completo
    MOV CL, 3       ; Establece 3 como el número de columnas en el tablero
    MUL CL          ; Multiplica AL por 3 (número de columnas)
    ADD AX, BX      ; Suma el resultado con BL (columna convertida)
    MOV SI, AX      ; Mueve el resultado final a SI
    JMP SalirMovs  

    AlertaFilaAnuncio:
        ImprimirCadenaPersonalizada textoFilaInvalida, 0, 0Eh, 23, 0, 3
        CapturarOpcion opcion
        BorrarPantalla
        JMP MensajesEntrada

    AlertaColumnaAnuncio:
        ImprimirCadenaPersonalizada textoColumnaInvalida, 0, 0Eh, 26, 0, 3
        CapturarOpcion opcion
        BorrarPantalla
        JMP MensajesEntrada
    
    SalirMovs:

ENDM

; Macro para imprimir el valor de SI como decimal
ImprimirSI MACRO
    LOCAL convertLoop, printChar

    ; Prepara el buffer para el número convertido a string
    LEA BX, bufferSI
    MOV CX, 0           ; Contador de dígitos

    ; Dividir SI por 10 y convertir el resto a ASCII
    MOV AX, SI
    MOV DX, 0           ; Clear DX antes de la división

    convertLoop:
        DIV WORD PTR decimales  ; Divide AX por 10, resultado en AX, resto en DX
        ADD DL, '0'             ; Convertir el número a ASCII
        MOV [BX], DL            ; Almacenar el dígito en el buffer
        INC BX
        INC CX
        MOV DX, 0               ; Clear DX para la siguiente división
        CMP AX, 0
        JNE convertLoop

    ; La cadena está al revés, imprimir al revés
    DEC BX
    printChar:
        MOV DL, [BX]
        MOV AH, 02h             ; Función DOS para imprimir carácter
        INT 21h
        DEC BX
        LOOP printChar

    ; Imprimir un salto de línea
    MOV DL, 13
    INT 21h
    MOV DL, 10
    INT 21h
ENDM

ImprimirTablero MACRO
    LOCAL filaActual, columnaActual

    MOV BX, 0
    XOR SI, SI

    MostrarTexto tituloColumnas
    MostrarTexto ln
    MostrarTexto serparacionColumnas
    MOV CL, 0; índice de la columna (A-C)

    filaActual:
        MostrarTexto ln
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

            CMP CL, 3 ; si no ha pasado por las 8 columnas, refrescar a la etiqueta columnaActual
            JB columnaActual; salto a columnaActual

            MOV CL, 0 ; reiniciar el contador de columnas
            INC BX; incrementar índice indicador de filas BX en 1 -> BX++

            CMP BX, 3; Si no ha pasado por todas las filas que refrese a la etiqueta filaActual
            JB filaActual
    
    MostrarTexto ln
    MostrarTexto serparacionColumnas
    MostrarTexto ln
    MostrarTexto tituloColumnas 

ENDM

ComprobarCasilla MACRO
    MOV AL, fila    ; Mueve el valor ASCII de 'fila' a AL
    MOV BL, columna ; Mueve el valor ASCII de 'columna' a BL

    ; Calcular el índice lineal para un tablero de 3x3
    MOV AH, 0       ; Limpia AH para usar AX completo
    MOV CL, 3       ; Establece 3 como el número de columnas en el tablero
    MUL CL          ; Multiplica AL por 3 (número de columnas)
    ADD AX, BX      ; Suma el resultado con BL (columna convertida)

    MOV SI, AX      ; Mueve el resultado final a SI

    CMP tablero[SI], 32
    JE casillaVacia
    JMP casillaOcupada
    
    casillaVacia:
        JMP casillaVaciaFin
    
    casillaOcupada:
        ImprimirCadenaPersonalizada textoCasillaOcupada, 0, 0Bh, 23, 0, 1
        CapturarOpcion opcion
        BorrarPantalla
        JMP PedirMovs1
    
    PedirMovs1:
        PedirMovs

    casillaVaciaFin:
ENDM

SalirMacro MACRO 
    MOV AH, 4Ch
    INT 21h
ENDM

JuegoVsJugadorMacro MACRO
    MOV AL, fila
    MOV AH, 0
    MOV BL, columna
    MOV BH, 0

    PUSH SI
    PUSH AX
    PUSH BX

    MOV AL, 13h
    MOV AH, 00h
    INT 10h

    MOV SI, 0

    DibujarTableroTotito
    JMP ContadorBX

    ContadorBX:
        CMP SI, 9
        JB PintarTableroTotito
        JMP Continuar
    
    ContadorBX1:
        INC SI
        JMP ContadorBX

    ;comprobar tablero[SI] para dibujar X o O en DibujarTableroTotito
    PintarTableroTotito:
        MOV CL, tablero[SI]       

        CMP CL, 32
        JE ContadorBX1

        CMP CL, 88
        JE PintarX

        CMP CL, 79
        JE PintarO

        PintarX:
            MOV AX, SI
            MOV BX, 3
            XOR DX, DX

            DIV BX

            MOV fila, AL
            MOV columna, DL
            DibujarXenTablero
            INC SI
            JMP ContadorBX
        
        PintarO:
            MOV AX, SI
            MOV BX, 3
            XOR DX, DX

            DIV BX

            MOV fila, AL
            MOV columna, DL

            DibujarOenTablero
            INC SI
            JMP ContadorBX

    ;DibujarTableroTotito

    Continuar:
        POP BX
        POP AX
        POP SI

        MOV fila, AL
        MOV columna, BL

        CMP turno, 0
        JE PintarSpriteX

        CMP turno, 1
        JE PintarSpriteO

    PintarSpriteX:
        MOV tablero[SI], 88
        DibujarXenTablero
        MOV AL, turno
        INC AL
        MOV turno, AL
        JMP ContinuarModoVideo

    PintarSpriteO:
        MOV tablero[SI], 79
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

IniciarTablero MACRO
    MOV SI, 0

    bucle:
        MOV tablero[SI], 32
        MOV tableroIA[SI], 32
        INC SI
        CMP SI, 9
        JE finIniciarTablero
        JNE bucle

    finIniciarTablero:
ENDM

ComprobarGanador MACRO
    MOV SI, 0
    MOV CL, 0 ; CONTADOR DE COLUMNAS
    MOV CH, 0 ; CONTADOR DE FILAS
    MOV DL, 0; CONTADOR DE DIAGONALES
    MOV DH, 0; CONTADOR DE EQUIS
    MOV BL, 0; CONTADOR DE X
    MOV BH, 0; CONTADOR DE O
    
    ContarColumnas:
        CMP SI, 3
        JB ComprobarFila1
        JE ComprobarFila21
    
    ComprobarFila21:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 3
        JMP auxFila2

    ComprobarFila1:
        MOV AL, tablero[SI]
        INC SI
        CMP AL, 88
        JE contarX
        CMP AL, 79
        JE contarO
        CMP AL, 32; si es espacio en blanco
        JE ComprobarFila21
    
    contarX:
        INC BL
        CMP BL, 3
        JE GanadorFilaX
        JMP ContarColumnas
    
    auxFila2:
        JMP auxFila3

    contarO:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
        JMP ContarColumnas

    GanadorFilaX:
        ImprimirCadenaPersonalizada GanadorX , 0, 0Ah, 18, 10, 1
        ImprimirCadenaPersonalizada PerderO , 0, 0Ah, 21, 10, 3
        CapturarOpcion opcion
        JMP SalirGanador
    
    auxFila3:
        JMP ComprobarFila2
    
    GanadorFilaO:
        ImprimirCadenaPersonalizada GanadorO , 0, 0Ah, 19, 10, 1
        ImprimirCadenaPersonalizada PerderX , 0, 0Ah, 20, 10, 3
        CapturarOpcion opcion
        JMP SalirGanador
    
    ContarColumnas1:
        CMP SI, 6
        JB ComprobarFila2
        JE ComprobarFila31
    
    ComprobarFila31:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 6
        JMP auxFila31
    
    auxGanadorFilaX:
        JMP GanadorFilaX
    
    auxGanadorFilaO:
        JMP GanadorFilaO
    
    ComprobarFila2:
        MOV AL, tablero[SI]
        INC SI
        CMP AL, 88
        JE contarX1
        CMP AL, 79
        JE contarO1
        CMP AL, 32; si es espacio en blanco
        JE ComprobarFila31

    contarX1:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX
        JMP ContarColumnas1
    
    auxFila31:
        JMP ComprobarFila3
    
    contarO1:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO
        JMP ContarColumnas1

    ContarColumnas2:
        CMP SI, 9
        JB ComprobarFila3
        JE ReiniciarColumnas

    ComprobarFila3:
        MOV AL, tablero[SI]
        INC SI
        CMP AL, 88
        JE contarX2
        CMP AL, 79
        JE contarO2
        CMP AL, 32; si es espacio en blanco
        JE ReiniciarColumnas
    
    contarX2:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX
        JMP ContarColumnas2
    
    contarO2:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO
        JMP ContarColumnas2
    
    ;AHORA LAS COLUMNAS
    ReiniciarColumnas:
        MOV SI, 0
        MOV CL, 0 ; CONTADOR DE COLUMNAS
        MOV CH, 0 ; CONTADOR DE FILAS
        MOV DL, 0; CONTADOR DE DIAGONALES
        MOV DH, 0; CONTADOR DE EQUIS
        MOV BL, 0; CONTADOR DE X
        MOV BH, 0; CONTADOR DE O
        JMP ContarColumnas31
    
    ContarColumnas31:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 0
        JMP ContarColumnas3
    
    auxGanadorFilaX1:
        JMP GanadorFilaX
    
    auxGanadorFilaO1:
        JMP GanadorFilaO

    ContarColumnas3:
        CMP SI, 7
        JB ComprobarColumna1
        JE ComprobarColumna21

    ComprobarColumna1:
        MOV AL, tablero[SI]
        ADD SI, 3
        CMP AL, 88
        JE contarX3
        CMP AL, 79
        JE contarO3
        CMP AL, 32; si es espacio en blanco
        JE ComprobarColumna21   
    
    contarX3:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX1
        JMP ContarColumnas3
    
    contarO3:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO1
        JMP ContarColumnas3

    
    auxGanadorFilaX2:
        JMP GanadorFilaX
    
    auxGanadorFilaO2:
        JMP GanadorFilaO


    ComprobarColumna21:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 1
        JMP ComprobarColumna2

    ContarColumnas4:
        CMP SI, 8
        JB ComprobarColumna2
        JE ComprobarColumna31
    
    ComprobarColumna2:
        MOV AL, tablero[SI]
        ADD SI, 3
        CMP AL, 88
        JE contarX4
        CMP AL, 79
        JE contarO4
        CMP AL, 32; si es espacio en blanco
        JE ComprobarColumna31
    
    contarX4:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX2
        JMP ContarColumnas4
    
    contarO4:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO2
        JMP ContarColumnas4


    ContarColumnas5:
        CMP SI, 9
        JB ComprobarColumna3
        JE Reiniciar1

    ComprobarColumna31:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 2
        JMP ComprobarColumna3
    
    auxGanadorFilaX3:
        JMP GanadorFilaX
    
    auxGanadorFilaO3:
        JMP GanadorFilaO

    ComprobarColumna3:
        MOV AL, tablero[SI]
        ADD SI, 3
        CMP AL, 88
        JE contarX5
        CMP AL, 79
        JE contarO5
        CMP AL, 32; si es espacio en blanco
        JE Reiniciar1
    
    contarX5:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX3
        JMP ContarColumnas5
    
    contarO5:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO3
        JMP ContarColumnas5

        ;Diagonales ahora
    Reiniciar1:
        MOV SI, 0
        MOV CL, 0 ; CONTADOR DE COLUMNAS
        MOV CH, 0 ; CONTADOR DE FILAS
        MOV DL, 0; CONTADOR DE DIAGONALES
        MOV DH, 0; CONTADOR DE EQUIS
        MOV BL, 0; CONTADOR DE X
        MOV BH, 0; CONTADOR DE O
        JMP ComprobarDiagonalIzq1

    ComprobarDiagonalIzq1:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 0
        JMP ContarDiagonales
    
    auxGanadorFilaX4:
        JMP GanadorFilaX
    
    auxGanadorFilaO4:
        JMP GanadorFilaO
    
    ContarDiagonales:
        CMP SI, 9
        JB ComprobarDiagonalIzq
        JE ComprobarDiagonalDer1

    ComprobarDiagonalIzq:
        MOV AL, tablero[SI]
        ADD SI, 4
        CMP AL, 88
        JE contarX6
        CMP AL, 79
        JE contarO6
        CMP AL, 32; si es espacio en blanco
        JE ComprobarDiagonalDer1
    
    contarX6:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX4
        JMP ContarDiagonales
    
    contarO6:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO4
        JMP ContarDiagonales
    
    ComprobarDiagonalDer1:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 2
        JMP ContarDiagonales1
    
    ContarDiagonales1:
        CMP SI, 7
        JB ComprobarDiagonalDer
        JE ConsiderarEmpate

    auxGanadorFilaX5:
        JMP GanadorFilaX
    
    auxGanadorFilaO5:
        JMP GanadorFilaO

    ComprobarDiagonalDer:
        MOV AL, tablero[SI]
        ADD SI, 2
        CMP AL, 88
        JE contarX7
        CMP AL, 79
        JE contarO7
        CMP AL, 32; si es espacio en blanco
        JE ConsiderarEmpate
    
    contarX7:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX5
        JMP ContarDiagonales1
    
    contarO7:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO5
        JMP ContarDiagonales1
    
    ConsiderarEmpate:
        MOV SI, 0

        EmpateE:
            INC SI
            CMP tablero[SI], 32
            JE SalirGanador
            JMP casillaOcupadaEmpate
        
        casillaOcupadaEmpate:
            CMP SI, 8
            JE EmpateGanador
            JNE EmpateE

        EmpateGanador:
            ImprimirCadenaPersonalizada Empate , 0, 0Ah, 6, 10, 1
            CapturarOpcion opcion
            JMP SalirGanador

    SalirGanador:
ENDM

; Macro para generar un número aleatorio entre 0 y 8
RANDOM_INDEX MACRO
    mov ah, 00h       ; Función del BIOS para obtener el tiempo del sistema
    int 1Ah           ; Interrupción del reloj del sistema BIOS
    mov ax, dx        ; Usar DX que contiene el contador de tiempo
    mov bx, 9         ; Divisor para obtener rango de 0 a 8
    div bx            ; Divide DX:AX por 9, resultado en AX, residuo en DX
    mov al, dl        ; El residuo, que es el número aleatorio, ahora está en AL
    MOV SI, ax
ENDM

ComprobarCasillaIA MACRO
    LOCAL casillaVacia, casillaOcupada, casillaVaciaFin, PedirMovs1
    
    MOV AL, fila    ; Mueve el valor ASCII de 'fila' a AL
    MOV BL, columna ; Mueve el valor ASCII de 'columna' a BL

    ; Calcular el índice lineal para un tablero de 3x3
    MOV AH, 0       ; Limpia AH para usar AX completo
    MOV CL, 3       ; Establece 3 como el número de columnas en el tablero
    MUL CL          ; Multiplica AL por 3 (número de columnas)
    ADD AX, BX      ; Suma el resultado con BL (columna convertida)

    MOV SI, AX      ; Mueve el resultado final a SI

    CMP tableroIA[SI], 32
    JE casillaVacia
    JMP casillaOcupada
    
    casillaVacia:
        JMP casillaVaciaFin
    
    casillaOcupada:
        ImprimirCadenaPersonalizada textoCasillaOcupada, 0, 0Bh, 23, 0, 1
        CapturarOpcion opcion
        BorrarPantalla
        JMP PedirMovs1
    
    PedirMovs1:
        PedirMovs

    casillaVaciaFin:
    
ENDM

JugadorVsIaMacro MACRO
    LOCAL ContadorBX, ContadorBX1, PintarTableroTotito, PintarX, PintarO, Continuar, PintarSpriteX, PintarSpriteO, ContinuarModoVideo
    
    MOV AL, fila
    MOV AH, 0
    MOV BL, columna
    MOV BH, 0

    PUSH SI
    PUSH AX
    PUSH BX

    MOV AL, 13h
    MOV AH, 00h
    INT 10h

    MOV SI, 0

    DibujarTableroTotito
    JMP ContadorBX

    ContadorBX:
        CMP SI, 9
        JB PintarTableroTotito
        JMP Continuar
    
    ContadorBX1:
        INC SI
        JMP ContadorBX

    ;comprobar tablero[SI] para dibujar X o O en DibujarTableroTotito
    PintarTableroTotito:
        MOV CL, tableroIA[SI]       

        CMP CL, 32
        JE ContadorBX1

        CMP CL, 88
        JE PintarX

        CMP CL, 79
        JE PintarO

        PintarX:
            MOV AX, SI
            MOV BX, 3
            XOR DX, DX

            DIV BX

            MOV fila, AL
            MOV columna, DL
            DibujarXenTablero
            INC SI
            JMP ContadorBX
        
        PintarO:
            MOV AX, SI
            MOV BX, 3
            XOR DX, DX

            DIV BX

            MOV fila, AL
            MOV columna, DL

            DibujarOenTablero
            INC SI
            JMP ContadorBX

    ;DibujarTableroTotito

    Continuar:
        POP BX
        POP AX
        POP SI

        MOV fila, AL
        MOV columna, BL

        CMP turno, 0
        JE PintarSpriteX

        CMP turno, 1
        JE PintarSpriteO

    PintarSpriteX:
        MOV tableroIA[SI], 88
        DibujarXenTablero
        MOV AL, turno
        INC AL
        MOV turno, AL
        JMP ContinuarModoVideo

    PintarSpriteO:
        CambiarModoTexto
    ; Generar un número aleatorio entre 0 y 8
        PUSH AX            ; Guardar AX para preservar el estado
        PUSH DX            ; Guardar DX para preservar el estado
        PUSH BX            ; Guardar BX para preservar el estado
        mov ah, 00h        ; Función del BIOS para obtener el tiempo del sistema
        int 1Ah            ; Interrupción del reloj del sistema BIOS
        mov ax, dx         ; Usar DX que contiene el contador de tiempo
        mov bx, 9          ; Divisor para obtener rango de 0 a 8
        xor dx, dx         ; Asegurar que DX esté limpio antes de la división
        div bx             ; Divide DX:AX por BX, resultado en AX, residuo en DX
        mov si, dx         ; El residuo (0-8) es ahora nuestro índice aleatorio
        POP BX             ; Restaurar BX
        POP DX             ; Restaurar DX
        POP AX             ; Restaurar AX
        CambiarModoVideo
        MOV tableroIA[SI], 79
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

ComprobarGanadorIA MACRO
    LOCAL ContarColumnas, ContarColumnas1, ContarColumnas2, ContarColumnas3, ContarColumnas4, ContarColumnas5, ContarColumnas31
    LOCAL ComprobarFila1, ComprobarFila2, ComprobarFila21, ComprobarFila3, ComprobarFila31
    LOCAL ComprobarColumna1, ComprobarColumna2, ComprobarColumna21, ComprobarColumna3, ComprobarColumna31
    LOCAL ComprobarDiagonalIzq, ComprobarDiagonalDer, ComprobarDiagonalIzq1, ComprobarDiagonalDer1
    LOCAL ContarDiagonales, ContarDiagonales1, ConsiderarEmpate, casillaOcupadaEmpate, EmpateE, EmpateGanador
    LOCAL GanadorFilaX, GanadorFilaO, SalirGanador
    LOCAL contarX, contarO, contarX1, contarO1, contarX2, contarO2, contarX3, contarO3, contarX4, contarO4, contarX5, contarO5, contarX6, contarO6, contarX7, contarO7
    LOCAL ReiniciarColumnas, Reiniciar1
    LOCAL auxFila2, auxFila3, auxFila31, auxGanadorFilaX, auxGanadorFilaO, auxGanadorFilaX1, auxGanadorFilaO1, auxGanadorFilaX2
    LOCAL auxGanadorFilaO2, auxGanadorFilaX3, auxGanadorFilaO3, auxGanadorFilaX4, auxGanadorFilaO4, auxGanadorFilaX5, auxGanadorFilaO5
    
    MOV SI, 0
    MOV CL, 0 ; CONTADOR DE COLUMNAS
    MOV CH, 0 ; CONTADOR DE FILAS
    MOV DL, 0; CONTADOR DE DIAGONALES
    MOV DH, 0; CONTADOR DE EQUIS
    MOV BL, 0; CONTADOR DE X
    MOV BH, 0; CONTADOR DE O
    
    ContarColumnas:
        CMP SI, 3
        JB ComprobarFila1
        JE ComprobarFila21
    
    ComprobarFila21:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 3
        JMP auxFila2

    ComprobarFila1:
        MOV AL, tableroIA[SI]
        INC SI
        CMP AL, 88
        JE contarX
        CMP AL, 79
        JE contarO
        CMP AL, 32; si es espacio en blanco
        JE ComprobarFila21
    
    contarX:
        INC BL
        CMP BL, 3
        JE GanadorFilaX
        JMP ContarColumnas
    
    auxFila2:
        JMP auxFila3

    contarO:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
        JMP ContarColumnas

    GanadorFilaX:
        ImprimirCadenaPersonalizada GanadorX , 0, 0Ah, 18, 10, 1
        ImprimirCadenaPersonalizada PerderO , 0, 0Ah, 21, 10, 3
        CapturarOpcion opcion
        JMP SalirGanador
    
    auxFila3:
        JMP ComprobarFila2
    
    GanadorFilaO:
        ImprimirCadenaPersonalizada GanadorO , 0, 0Ah, 19, 10, 1
        ImprimirCadenaPersonalizada PerderX , 0, 0Ah, 20, 10, 3
        CapturarOpcion opcion
        JMP SalirGanador
    
    ContarColumnas1:
        CMP SI, 6
        JB ComprobarFila2
        JE ComprobarFila31
    
    ComprobarFila31:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 6
        JMP auxFila31
    
    auxGanadorFilaX:
        JMP GanadorFilaX
    
    auxGanadorFilaO:
        JMP GanadorFilaO
    
    ComprobarFila2:
        MOV AL, tableroIA[SI]
        INC SI
        CMP AL, 88
        JE contarX1
        CMP AL, 79
        JE contarO1
        CMP AL, 32; si es espacio en blanco
        JE ComprobarFila31

    contarX1:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX
        JMP ContarColumnas1
    
    auxFila31:
        JMP ComprobarFila3
    
    contarO1:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO
        JMP ContarColumnas1

    ContarColumnas2:
        CMP SI, 9
        JB ComprobarFila3
        JE ReiniciarColumnas

    ComprobarFila3:
        MOV AL, tableroIA[SI]
        INC SI
        CMP AL, 88
        JE contarX2
        CMP AL, 79
        JE contarO2
        CMP AL, 32; si es espacio en blanco
        JE ReiniciarColumnas
    
    contarX2:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX
        JMP ContarColumnas2
    
    contarO2:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO
        JMP ContarColumnas2
    
    ;AHORA LAS COLUMNAS
    ReiniciarColumnas:
        MOV SI, 0
        MOV CL, 0 ; CONTADOR DE COLUMNAS
        MOV CH, 0 ; CONTADOR DE FILAS
        MOV DL, 0; CONTADOR DE DIAGONALES
        MOV DH, 0; CONTADOR DE EQUIS
        MOV BL, 0; CONTADOR DE X
        MOV BH, 0; CONTADOR DE O
        JMP ContarColumnas31
    
    ContarColumnas31:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 0
        JMP ContarColumnas3
    
    auxGanadorFilaX1:
        JMP GanadorFilaX
    
    auxGanadorFilaO1:
        JMP GanadorFilaO

    ContarColumnas3:
        CMP SI, 7
        JB ComprobarColumna1
        JE ComprobarColumna21

    ComprobarColumna1:
        MOV AL, tableroIA[SI]
        ADD SI, 3
        CMP AL, 88
        JE contarX3
        CMP AL, 79
        JE contarO3
        CMP AL, 32; si es espacio en blanco
        JE ComprobarColumna21   
    
    contarX3:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX1
        JMP ContarColumnas3
    
    contarO3:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO1
        JMP ContarColumnas3

    auxGanadorFilaX2:
        JMP GanadorFilaX
    
    auxGanadorFilaO2:
        JMP GanadorFilaO

    ComprobarColumna21:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 1
        JMP ComprobarColumna2

    ContarColumnas4:
        CMP SI, 8
        JB ComprobarColumna2
        JE ComprobarColumna31
    
    ComprobarColumna2:
        MOV AL, tableroIA[SI]
        ADD SI, 3
        CMP AL, 88
        JE contarX4
        CMP AL, 79
        JE contarO4
        CMP AL, 32; si es espacio en blanco
        JE ComprobarColumna31
    
    contarX4:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX2
        JMP ContarColumnas4
    
    contarO4:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO2
        JMP ContarColumnas4

    ContarColumnas5:
        CMP SI, 9
        JB ComprobarColumna3
        JE Reiniciar1

    ComprobarColumna31:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 2
        JMP ComprobarColumna3
    
    auxGanadorFilaX3:
        JMP GanadorFilaX
    
    auxGanadorFilaO3:
        JMP GanadorFilaO

    ComprobarColumna3:
        MOV AL, tableroIA[SI]
        ADD SI, 3
        CMP AL, 88
        JE contarX5
        CMP AL, 79
        JE contarO5
        CMP AL, 32; si es espacio en blanco
        JE Reiniciar1
    
    contarX5:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX3
        JMP ContarColumnas5
    
    contarO5:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO3
        JMP ContarColumnas5

        ;Diagonales ahora
    Reiniciar1:
        MOV SI, 0
        MOV CL, 0 ; CONTADOR DE COLUMNAS
        MOV CH, 0 ; CONTADOR DE FILAS
        MOV DL, 0; CONTADOR DE DIAGONALES
        MOV DH, 0; CONTADOR DE EQUIS
        MOV BL, 0; CONTADOR DE X
        MOV BH, 0; CONTADOR DE O
        JMP ComprobarDiagonalIzq1

    ComprobarDiagonalIzq1:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 0
        JMP ContarDiagonales
    
    auxGanadorFilaX4:
        JMP GanadorFilaX
    
    auxGanadorFilaO4:
        JMP GanadorFilaO
    
    ContarDiagonales:
        CMP SI, 9
        JB ComprobarDiagonalIzq
        JE ComprobarDiagonalDer1

    ComprobarDiagonalIzq:
        MOV AL, tableroIA[SI]
        ADD SI, 4
        CMP AL, 88
        JE contarX6
        CMP AL, 79
        JE contarO6
        CMP AL, 32; si es espacio en blanco
        JE ComprobarDiagonalDer1
    
    contarX6:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX4
        JMP ContarDiagonales
    
    contarO6:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO4
        JMP ContarDiagonales

    ComprobarDiagonalDer1:
        MOV BL, 0
        MOV BH, 0
        MOV SI, 2
        JMP ContarDiagonales1
    
    ContarDiagonales1:
        CMP SI, 7
        JB ComprobarDiagonalDer
        JE ConsiderarEmpate

    auxGanadorFilaX5:
        JMP GanadorFilaX
    
    auxGanadorFilaO5:
        JMP GanadorFilaO

    ComprobarDiagonalDer:
        MOV AL, tableroIA[SI]
        ADD SI, 2
        CMP AL, 88
        JE contarX7
        CMP AL, 79
        JE contarO7
        CMP AL, 32; si es espacio en blanco
        JE ConsiderarEmpate
    
    contarX7:
        INC BL
        CMP BL, 3
        JE auxGanadorFilaX5
        JMP ContarDiagonales1
    
    contarO7:
        INC BH
        CMP BH, 3
        JE auxGanadorFilaO5
        JMP ContarDiagonales1
    
    ConsiderarEmpate:
        MOV SI, 0

        EmpateE:
            INC SI
            CMP tableroIA[SI], 32
            JE SalirGanador
            JMP casillaOcupadaEmpate
        
        casillaOcupadaEmpate:
            CMP SI, 8
            JE EmpateGanador
            JNE EmpateE

        EmpateGanador:
            ImprimirCadenaPersonalizada Empate , 0, 0Ah, 6, 10, 1
            CapturarOpcion opcion
            JMP SalirGanador

    SalirGanador:
ENDM

CapturarNombre MACRO regNombre
    MOV AH, 3fh
    MOV BX, 00H
    MOV CX, 5
    MOV DX, OFFSET regNombre
    INT 21h
ENDM

PedirNombre1 MACRO 
    CambiarModoTexto
    ImprimirCadenaPersonalizada textoNombreJugador1, 0, 0Ah, 30, 5, 1
    CapturarNombre nombreJugador1
    CambiarModoTexto    
ENDM

PedirNombre MACRO
    CambiarModoTexto
    ImprimirCadenaPersonalizada textoNombreJugador1, 0, 0Ah, 30, 5, 1
    CapturarNombre nombreJugador1
    CambiarModoTexto
    ImprimirCadenaPersonalizada textoNombreJugador2, 0, 0Ah, 30, 5, 3
    CapturarNombre nombreJugador2
ENDM


.MODEL small
.STACK 100h

.DATA
    textoColumnaInvalida db "Numero de columna invalida", "$"
    textoFilaInvalida db "Numero de fila invalida", "$"
    equis db "Hay una equis", "$"
    circulo db "Hay un circulo", "$"
    GanadorX db "GANO JUGADOR 1 (X)", "$"
    GanadorO db "GANO JUGADOR 2 ([])", "$"
    PerderX db "PERDIO JUGADOR 1 (X)", "$"
    PerderO db "PERDIO JUGADOR 2 ([])", "$"
    Empate db "EMPATE", "$"
    bufferSI DB 5 DUP(0)  ; Buffer para 5 dígitos
    decimales DW 10       ; Constante para la división decimal
    tituloColumnas db "  A B C ", "$"
    serparacionColumnas db " |-|-|-|", "$"
    etiquetaFila db "123", "$"
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
    textoModoIA db "JUGADOR 1 ES X, CPU ES []", "$"
    jugadores db "JUGADOR 1 ES X, JUGADOR 2 ES []", "$"
    textoSalida db "Presione ESC para finalizar la partida", "$"
    turno db 0
    tablero db 9 dup(32) 
    tableroIA db 9 dup(32)
    textoCasillaOcupada db "La casilla esta ocupada", "$"
    textoNombreJugador1 db "Ingrese nickname1 (5 letras): ", "$"
    textoNombreJugador2 db "Ingrese nickname2 (5 letras): ", "$"
    nombreJugador1 db 5 dup(' '),'$'
    nombreJugador2 db 5 dup(' '),'$'
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
            ImprimirCadenaPersonalizada textoOpciones 0, 0Eh, 94, 0, 4
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
                IniciarTablero
                MOV turno, 0
                ImprimirCadenaPersonalizada textoOpcion, 0, 0Bh, 28, 0, 1
                ImprimirCadenaPersonalizada opcionTotito1, 0, 0Ch, 13, 0, 3
                ImprimirCadenaPersonalizada opcionTotito2, 0, 0Ah, 11, 0, 5
                ImprimirCadenaPersonalizada opcionTotito3, 0, 0Dh, 13, 0, 7
                ImprimirCadenaPersonalizada opcionTotito4, 0, 0Eh, 13, 0, 9
                ImprimirCadenaPersonalizada textoIngresarOpcion, 0, 0Fh, 22, 0, 11
                CapturarOpcion opcion ;evniarme al modo de juego seleccionado
                CMP opcion, 49; (1) 1 vs CPU
                JE UNOvIA
                CMP opcion, 50; (2) 1 vs 1
                JE UNOvUNO
                CMP opcion, 51; (3) Reportes
                JE AuxMenu1
                CMP opcion, 52; (4) Regresar 
                JE AuxMenu1
            
            AuxMenu1: 
                JMP Menu
            
            UNOvIA:
                PedirNombre1
                JMP JuegoVsIA
            
            UNOvUNO:
                PedirNombre
                JMP auxJuegoVsJugador

            auxNuevoJuego:
                JMP NuevoJuego

            auxJuegoVsJugador:
                JMP JuegoVsJugador

            JuegoVsIA:
                BorrarPantalla
                CambiarModoTexto
                ImprimirCadenaPersonalizada textoModoIA, 0, 0Eh, 25, 0, 0
                ImprimirCadenaPersonalizada textoSalida, 0, 0Ah, 38, 0, 3
                CapturarOpcion opcion
                CMP opcion, 27
                JE auxNuevoJuego ;arreglar salto fuera de rango 
                BorrarPantalla
                PedirMovs 
                BorrarPantalla
                ComprobarCasillaIA
                BorrarPantalla
                JugadorVsIaMacro  
                BorrarPantalla
                ComprobarGanadorIA       ;saltos fuera de rango
                JMP JuegoVsIA
            
            auxNuevoJuego1:
                JMP auxNuevoJuego

            JuegoVsJugador:
                BorrarPantalla
                CambiarModoTexto
                ImprimirCadenaPersonalizada jugadores, 0, 0Eh, 31, 0, 0
                ImprimirCadenaPersonalizada textoSalida, 0, 0Ah, 38, 0, 3
                CapturarOpcion opcion
                CMP opcion, 27
                JE auxNuevoJuego1 
                BorrarPantalla
                PedirMovs
                BorrarPantalla
                ComprobarCasilla
                BorrarPantalla
                JuegoVsJugadorMacro
                BorrarPantalla
                ComprobarGanador ;saltos fuera de rango xd
                JMP JuegoVsJugador
            
            auxMenu:
                JMP Menu

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