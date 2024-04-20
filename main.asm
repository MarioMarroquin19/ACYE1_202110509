ComprobarGanadorIA MACRO
    LOCAL ContarColumnas, ContarColumnas1, ContarColumnas2, ContarColumnas3, ContarColumnas4, ContarColumnas5, ContarColumnas31
    LOCAL ComprobarFila1, ComprobarFila2, ComprobarFila21, ComprobarFila3, ComprobarFila31
    LOCAL ComprobarColumna1, ComprobarColumna2, ComprobarColumna21, ComprobarColumna3, ComprobarColumna31
    LOCAL ComprobarDiagonalIzq, ComprobarDiagonalDer, ComprobarDiagonalIzq1, ComprobarDiagonalDer1
    LOCAL ContarDiagonales, ContarDiagonales1, ConsiderarEmpate, casillaOcupadaEmpate, EmpateE, EmpateGanador
    LOCAL GanadorFilaX, GanadorFilaO, SalirGanador
    LOCAL contarX, contarO, contarX1, contarO1, contarX2, contarO2, contarX3, contarO3, contarX4, contarO4, contarX5, contarO5, contarX6, contarO6, contarX7, contarO7
    LOCAL ReiniciarColumnas, Reiniciar1
    
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
        JMP ComprobarFila2

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
        JMP ComprobarFila3
    
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
        JE GanadorFilaX
        JMP ContarColumnas1
    
    contarO1:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
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
        JE GanadorFilaX
        JMP ContarColumnas2
    
    contarO2:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
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
        JE GanadorFilaX
        JMP ContarColumnas3
    
    contarO3:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
        JMP ContarColumnas3


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
        JE GanadorFilaX
        JMP ContarColumnas4
    
    contarO4:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
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
        JE GanadorFilaX
        JMP ContarColumnas5
    
    contarO5:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
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
        JE GanadorFilaX
        JMP ContarDiagonales
    
    contarO6:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
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
        JE GanadorFilaX
        JMP ContarDiagonales1
    
    contarO7:
        INC BH
        CMP BH, 3
        JE GanadorFilaO
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