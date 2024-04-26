PrintCadena MACRO cadena
    MOV AH, 09h
    LEA DX, cadena
    INT 21h
ENDM

OpenFile MACRO
    LOCAL ErrorToOpen, ExitOpenFile
    MOV AL, 2
    MOV DX, OFFSET filename + 2
    MOV AH, 3Dh
    INT 21h

    JC ErrorToOpen

    MOV handlerFile, AX
    PrintCadena salto
    PrintCadena exitOpenFileMsg
    JMP ExitOpenFile

    ErrorToOpen:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintCadena salto
        PrintCadena errorOpenFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h

    ExitOpenFile:
ENDM

CloseFile MACRO handler
    LOCAL ErrorToClose, ExitCloseFile
    MOV AH, 3Eh
    MOV BX, handler
    INT 21h

    JC ErrorToClose

    PrintCadena salto
    PrintCadena exitCloseFileMsg
    JMP ExitCloseFile

    ErrorToClose:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintCadena salto
        PrintCadena errorCloseFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h
    
    ExitCloseFile:
ENDM

ReadCSV MACRO handler, buffer
    LOCAL LeerByte, ErrorReadCSV, ExitReadCSV

    MOV BX, handler
    MOV CX, 1
    MOV DX, OFFSET buffer

    LeerByte:
        MOV AX, 3F00h
        INT 21h

        JC ErrorReadCSV

        INC DX
        MOV SI, DX
        SUB SI, 1

        SUB SI, OFFSET buffer

        CMP buffer[SI], 2Ch
        JNE LeerByte
        
        PUSH BX
        ConvertirNumero
        MOV DX, OFFSET buffer

        PUSH CX
        PUSH DX

        obtenerPosApuntador handler, 1, posApuntador

        POP DX
        POP CX
        POP BX
        MOV AX, posApuntador

        CMP extensionArchivo, AX
        JBE ExitReadCSV
        JMP LeerByte

    ErrorReadCSV:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintCadena salto
        PrintCadena errorReadFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h

    ExitReadCSV:
ENDM

ConvertirNumero MACRO
    LOCAL DosDigitosNum, FinConvertirNumero
    XOR AX, AX
    XOR BX, BX

    MOV DI, 0
    CMP SI, 2
    JNE UnDigitoNum

    DosDigitosNum:
        MOV AL, numCSV[DI]
        SUB AL, 48
        MOV BL, 10
        MUL BL
        INC DI

    UnDigitoNum:
        MOV BL, numCSV[DI]
        SUB BL, 48
        ADD AL, BL

    FinConvertirNumero:
        XOR BX, BX
        MOV BX, indexDatos
        MOV bufferDatos[BX], AL
        INC BX
        MOV indexDatos, BX

        MOV BX, numDatos
        INC BX
        MOV numDatos, BX
ENDM

GetSizeFile MACRO handler
    LOCAL ErrorGetSize, ExitGetSize
    obtenerPosApuntador handler, 2, extensionArchivo
    JC ErrorGetSize

    MOV extensionArchivo, AX
    obtenerPosApuntador handler, 0, posApuntador
    JC ErrorGetSize

    PrintCadena salto
    PrintCadena exitSizeFileMsg
    JMP ExitGetSize

    ErrorGetSize:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintCadena salto
        PrintCadena errorSizeFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h

    ExitGetSize:
ENDM

obtenerPosApuntador MACRO handler, posActual, bufferPos
    MOV AH, 42h
    MOV AL, posActual
    MOV BX, handler
    MOV CX, 0
    MOV DX, 0
    INT 21h

    MOV bufferPos, AX
ENDM

PedirCadena MACRO buffer
    LEA DX, buffer
    MOV AH, 0Ah
    INT 21h

    XOR BX, BX
    MOV SI, 2
    MOV BL, filename[1]
    ADD SI, BX
    MOV filename[SI], 0
ENDM

OrderData MACRO
    LOCAL for1, for2, Intercambio, terminarFor2
    XOR AX, AX
    XOR CX, CX
    XOR DX, DX

    MOV CX, numDatos
    DEC CX
    MOV DL, 0
    for1:
        PUSH CX

        MOV CX, numDatos
        DEC CX
        SUB CX, DX
        MOV BX, 0
        for2:
            MOV AL, bufferDatos[BX]
            MOV AH, bufferDatos[BX + 1]
            CMP AL, AH
            JA Intercambio
            INC BX
            LOOP for2
            JMP terminarFor2

            Intercambio:
                XCHG AL, AH
                MOV bufferDatos[BX], AL
                MOV bufferDatos[BX + 1], AH
                INC BX

            LOOP for2

        terminarFor2:
            POP CX
            INC DL
            LOOP for1
ENDM

Promedio MACRO
    LOCAL Sumatoria, CicloDecimal, ContinuarProm
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV CX, numDatos
    Sumatoria:
        MOV DL, bufferDatos[BX]
        ADD AX, DX
        INC BX
        MOV DX, 0
        LOOP Sumatoria
    
    MOV DX, 0
    MOV BX, numDatos
    DIV BX
    MOV entero, AX
    MOV decimal, DX
    MOV SI, 0

    CrearCadena entero, cadenaResult

    MOV cadenaResult[SI], 46
    INC SI

    CMP decimal, 0
    JNE CicloDecimal

    MOV cadenaResult[SI], 48
    INC SI
    MOV cadenaResult[SI], 48
    JMP ContinuarProm

    CicloDecimal:
        MOV AX, decimal
        MOV BX, 10
        MOV DX, 0
        MUL BX

        MOV BX, numDatos
        MOV DX, 0
        DIV BX

        MOV decimal, DX
        MOV entero, AX
        CrearCadena entero, cadenaResult
        MOV AL, cantDecimal
        INC AL
        MOV cantDecimal, AL
        CMP AL, 2
        JNE CicloDecimal

    ContinuarProm:
        MOV cantDecimal, 0
        PrintCadena salto
        PrintCadena msgPromedio
        PrintCadena cadenaResult
ENDM

CrearCadena MACRO valor, cadena
    LOCAL CICLO, DIVBASE, SALIRCC, ADDZERO, ADDZERO2

    CICLO:
        MOV DX, 0
        MOV CX, valor
        CMP CX, base
        JB DIVBASE

        MOV BX, base
        MOV AX, valor
        DIV BX
        MOV cadena[SI], AL
        ADD cadena[SI], 48
        INC SI

        MUL BX
        SUB valor, AX

        CMP base, 1
        JE SALIRCC
        
        DIVBASE:
            CMP valor, 0
            JE ADDZERO

            MOV AX, base
            MOV BX, 10
            DIV BX
            MOV base, AX
            JMP CICLO
            
            ADDZERO:
                MOV cadena[SI], 48
                INC SI
    SALIRCC:
ENDM

Maximo MACRO
    XOR AX, AX
    MOV BX, numDatos
    DEC BX
    MOV AL, bufferDatos[BX]
    MOV entero, AX
    MOV SI, 0

    CrearCadena entero, cadenaResult
    MOV cadenaResult[SI], 46
    INC SI
    MOV cadenaResult[SI], 48
    INC SI
    MOV cadenaResult[SI], 48
    INC SI
    MOV cadenaResult[SI], 36

    PrintCadena salto
    PrintCadena msgMaximo
    PrintCadena cadenaResult
ENDM

Minimo MACRO
    XOR AX, AX
    MOV AL, bufferDatos[0]
    MOV entero, AX
    MOV SI, 0

    CrearCadena entero, cadenaResult
    MOV cadenaResult[SI], 46
    INC SI
    MOV cadenaResult[SI], 48
    INC SI
    MOV cadenaResult[SI], 48
    INC SI
    MOV cadenaResult[SI], 36

    PrintCadena salto
    PrintCadena msgMinimo
    PrintCadena cadenaResult
ENDM

Mediana MACRO
    LOCAL CalcPromedio, ExitCalcMediana, CicloDecimal
    XOR AX, AX
    XOR BX, BX
    XOR DX, DX

    MOV AX, numDatos
    MOV BX, 2
    DIV BX

    MOV BX, AX

    CMP DX, 0
    JZ CalcPromedio
    
    XOR DX, DX
    MOV DL, bufferDatos[BX]
    MOV entero, DX
    MOV SI, 0

    CrearCadena entero, cadenaResult

    MOV cadenaResult[SI], 46
    INC SI
    MOV cadenaResult[SI], 48
    INC SI
    MOV cadenaResult[SI], 48
    INC SI
    MOV cadenaResult[SI], 36
    JMP ExitCalcMediana

    CalcPromedio:
        XOR AX, AX
        DEC BX
        ADD AL, bufferDatos[BX]
        ADD AL, bufferDatos[BX + 1]
        MOV DX, 0
        MOV BX, 2
        DIV BX
        MOV entero, AX
        MOV decimal, DX
        MOV SI, 0

        CrearCadena entero, cadenaResult

        MOV cadenaResult[SI], 46
        INC SI

        CMP decimal, 0
        JNE CicloDecimal

        MOV cadenaResult[SI], 48
        INC SI
        MOV cadenaResult[SI], 48
        INC SI
        MOV cadenaResult[SI], 36
        JMP ExitCalcMediana

        CicloDecimal:
            MOV AX, decimal
            MOV BX, 10
            MOV DX, 0
            MUL BX

            MOV BX, 2
            MOV DX, 0
            DIV BX

            MOV decimal, DX
            MOV entero, AX
            CrearCadena entero, cadenaResult
            MOV AL, cantDecimal
            INC AL
            MOV cantDecimal, AL
            CMP AL, 2
            JNE CicloDecimal

    ExitCalcMediana:
        MOV cantDecimal, 0
        PrintCadena salto
        PrintCadena msgMediana
        PrintCadena cadenaResult

ENDM

ContadorDatos MACRO
    XOR AX, AX
    MOV AX, numDatos
    MOV entero, AX
    MOV SI, 0

    CrearCadena entero, cadenaResult

    MOV cadenaResult[SI], 36

    PrintCadena salto
    PrintCadena msgContadorDatos
    PrintCadena cadenaResult
ENDM

BuildTablaFrecuencias MACRO
    LOCAL forDatos, saveFrecuencia, ExitModa
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR SI, SI

    MOV CX, numDatos
    MOV AH, bufferDatos[BX]
    forDatos:
        CMP AH, bufferDatos[BX]
        JNE saveFrecuencia

        INC AL
        INC BX
        LOOP forDatos

        MOV tablaFrecuencias[SI], AH
        INC SI
        MOV tablaFrecuencias[SI], AL
        INC SI 

        JMP ExitModa

        saveFrecuencia:
            MOV tablaFrecuencias[SI], AH
            INC SI
            MOV tablaFrecuencias[SI], AL
            INC SI

            MOV AH, numEntradas
            INC AH
            MOV numEntradas, AH

            MOV AH, bufferDatos[BX]
            MOV AL, 0
        
        JMP forDatos

    ExitModa:
ENDM

OrderFrecuencies MACRO
    LOCAL for1, for2, Intercambio, terminarFor2
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV CL, numEntradas
    DEC CX
    MOV DL, 0
    for1:
        PUSH CX

        MOV CL, numEntradas
        DEC CX
        SUB CX, DX
        MOV SI, 0
        for2:
            MOV AH, tablaFrecuencias[SI]
            MOV AL, tablaFrecuencias[SI + 1]
            MOV BH, tablaFrecuencias[SI + 2]
            MOV BL, tablaFrecuencias[SI + 3]

            CMP AL, BL
            JA Intercambio
            ADD SI, 2
            LOOP for2
            JMP terminarFor2

            Intercambio:
                XCHG AX, BX
                MOV tablaFrecuencias[SI], AH
                MOV tablaFrecuencias[SI + 1], AL
                MOV tablaFrecuencias[SI + 2], BH
                MOV tablaFrecuencias[SI + 3], BL
                ADD SI, 2

            LOOP for2
        
        terminarFor2:
            POP CX
            INC DL
            LOOP for1

ENDM

Moda MACRO
    LOCAL CicloModa, ExitCalcModa
    XOR AX, AX
    XOR BX, BX
    MOV AL, numEntradas
    MOV BL, 2
    MUL BL
    MOV DI, AX
    DEC DI

    CicloModa:
        XOR AX, AX
        XOR BX, BX

        MOV AL, tablaFrecuencias[DI] ; ? Frecuencia
        DEC DI
        MOV BL, tablaFrecuencias[DI] ; ? Valor
        DEC DI
        
        PUSH AX
        MOV entero, BX
        MOV SI, 0
        MOV base, 10000
        CrearCadena entero, cadenaResult
        MOV cadenaResult[SI], 36

        PrintCadena salto
        PrintCadena msgModa1
        PrintCadena cadenaResult
        POP AX
        MOV entero, AX
        
        PUSH AX
        MOV SI, 0
        MOV base, 10000

        CrearCadena entero, cadenaResult
        MOV cadenaResult[SI], 36

        PrintCadena salto
        PrintCadena msgModa2
        PrintCadena cadenaResult

        POP AX
        
        CMP AL, tablaFrecuencias[DI]
        JA ExitCalcModa
        JMP CicloModa

    ExitCalcModa:
ENDM

PrintTablaFrecuencias MACRO
    LOCAL tabla, ExitPrintTabla
    PrintCadena salto
    PrintCadena msgEncabezadoTabla
    PrintCadena salto

    XOR AX, AX
    XOR BX, BX
    MOV AL, numEntradas
    MOV CX, AX
    MOV BL, 2
    MUL BL
    MOV DI, AX
    DEC DI

    tabla:
        PUSH CX
        XOR AX, AX
        XOR BX, BX

        MOV AL, tablaFrecuencias[DI]
        DEC DI
        MOV BL, tablaFrecuencias[DI]  
        DEC DI

        PUSH AX
        MOV entero, BX
        MOV SI, 0
        MOV base, 10000
        CrearCadena entero, cadenaResult
        MOV cadenaResult[SI], 36
        PrintCadena espacios
        PrintCadena cadenaResult

        POP AX
        MOV entero, AX
        
        MOV SI, 0
        MOV base, 10000
        CrearCadena entero, cadenaResult
        MOV cadenaResult[SI], 36
        PrintCadena espacios

        MOV AH, 2
        MOV DL, 124
        INT 21h

        PrintCadena espacios
        PrintCadena cadenaResult
        PrintCadena salto

        POP CX
        DEC CX
        CMP CX, 0
        JE ExitPrintTabla
        JMP tabla

    ExitPrintTabla:
ENDM

obtenerCaracter MACRO
    MOV AH, 01h
    INT 21h
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

CapturarComando MACRO buffer
    LOCAL obtenerChar, endTexto
    XOR SI, SI

    obtenerChar:
        obtenerCaracter
        CMP AL, 0DH
        JE endTexto
        MOV buffer[SI], AL
        INC SI
        JMP obtenerChar

    endTexto:
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

BorrarPantalla MACRO
    MOV AX, 03h
    INT 10h
ENDM

Salir MACRO
    MOV AH, 4Ch
    INT 21h
ENDM

Mensaje MACRO
    BorrarPantalla
    CambiarModoTexto
    ImprimirCadenaPersonalizada wolfram1, 0, 0Ch, 55, 04, 1
    ImprimirCadenaPersonalizada wolfram2, 0, 0Ch, 55, 04, 2
    ImprimirCadenaPersonalizada wolfram3, 0, 0Ch, 55, 04, 3
    ImprimirCadenaPersonalizada wolfram4, 0, 0Ch, 55, 04, 4
    ImprimirCadenaPersonalizada wolfram5, 0, 0Ch, 55, 04, 5
    ImprimirCadenaPersonalizada wolfram6, 0, 0Ch, 55, 04, 6
    ImprimirCadenaPersonalizada wolfram7, 0, 0Ch, 55, 04, 7

    ImprimirCadenaPersonalizada PedirComando, 0, 15, 33, 04, 10
ENDM

CapturarOpcion MACRO regSeleccion
    MOV AH, 01h
    INT 21h
    MOV regSeleccion, AL
ENDM

InfoEstudiante MACRO
    BorrarPantalla
    ImprimirCadenaPersonalizada textoInfo, 0, 0Ah, 142, 0, 5
    ImprimirCadenaPersonalizada textoInfo1, 0, 09h, 77, 0, 8
    PrintCadena ln
    PrintCadena ln
    PrintCadena textoRegresar
    CapturarOpcion enter
ENDM

CompararCadenas MACRO buffer, cadena, etiqueta
    LOCAL comparar, noEsCadena

    lea si, buffer
    lea di, cadena
    cld ; Limpiar la dirección

    comparar:
        lodsb ; Cargar byte en AL y aumentar SI
        cmp al, [di] ; Comparar con byte en DI
        jne noEsCadena ; Saltar si no son iguales
        inc di ; Aumentar DI
        cmp al, 0 ; Comprobar si hemos llegado al final de la cadena
        jne comparar ; Si no, seguir comparando

    ; Si llegamos aquí, la cadena es igual a 'cadena'
    jmp etiqueta ; Saltar a la etiqueta especificada

    noEsCadena:
    ; Si llegamos aquí, la cadena no es igual a 'cadena'
    ; ...
ENDM


.MODEL small
.STACK 100h
.DATA
    handlerFile         dw ?
    filename            db 30 dup(32)
    bufferDatos         db 300 dup (?)
    errorCode           db ?
    errorOpenFile       db "Ocurrio Un Error Al Abrir El Archivo - ERRCODE: ", "$"
    errorCloseFile      db "Ocurrio Un Error Al Cerrar El Archivo - ERRCODE: ", "$"
    errorReadFile       db "Ocurrio Un Error Al Leer El CSV - ERRCODE: ", "$"
    errorSizeFile       db "Ocurrio Un Error Obteniendo El Size Del Archivo - ERRCODE: ", "$"
    exitOpenFileMsg     db "El Archivo Se Abrio Correctamente", "$"
    exitCloseFileMsg    db "El Archivo Se Cerro Correctamente", "$"
    exitSizeFileMsg     db "Se Obtuvo La Longitud Correctamente", "$"
    msgToRequestFile    db "Ingrese El Nombre Del Archivo CSV: ", "$"
    msgPromedio         db "El Promedio De Los Datos Es: ", "$"
    msgMaximo           db "El Valor Maximo De Los Datos Es: ", "$"
    msgMinimo           db "El Valor Minimo De Los Datos Es: ", "$"
    msgMediana          db "El Valor De la Mediana De Los Datos Es: ", "$"
    msgContadorDatos    db "El Total De Datos Utilizados Ha Sido De: ", "$"
    PedirComando        db ">>Ingrese El Comando A Realizar: ", "$"
    comandoIngreso      db 30 dup(?), 0
    enter               db 1 dup(32);

    wolfram1 db "#     # ####### #       ####### ######     #    #     #",10,13,"$"
    wolfram2 db "#  #  # #     # #       #       #     #   # #   ##   ##",10,13,"$"
    wolfram3 db "#  #  # #     # #       #       #     #  #   #  # # # #",10,13,"$"
    wolfram4 db "#  #  # #     # #       #####   ######  #     # #  #  #",10,13,"$"
    wolfram5 db "#  #  # #     # #       #       #   #   ####### #     #",10,13,"$"
    wolfram6 db "#  #  # #     # #       #       #    #  #     # #     #",10,13,"$"
    wolfram7 db " ## ##  ####### ####### #       #     # #     # #     #",10,13,"$"

    textoInfo db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10,13, "FACULTAD DE INGENIERIA", 10, 13, "ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", "$"
    textoInfo1 db 10, 13,"SECCION A", 10, 13, "Primer Semestre 2024", 10, 13, "Mario Ernesto Marroquin Perez", 10, 13, "202110509", 10,13,"$"
    textoRegresar db "Presione una tecla para regresar al menu: ", "$"
    ln db 10, 13, "$"

    msgModa1            db "La Moda De Los Datos Es: ", "$"
    msgModa2            db "Con Una Frecuencia De: ", "$"
    msgEncabezadoTabla  db "-> Valor    -> Frecuencia", "$"
    salto               db 10, 13, "$"
    espacios            db 32, 32, 32, 32, 32, "$"
    numCSV              db 3 dup(?)
    cadenaResult        db 6 dup("$")
    tablaFrecuencias    db 100 dup(?)
    numEntradas         db 1
    indexDatos          dw 0
    extensionArchivo    dw 0
    posApuntador        dw 0
    numDatos            dw 0
    base                dw 10000
    entero              dw ?
    decimal             dw ?
    cantDecimal         db 0

    ;comandos
    comando1           db "prom", 0
    comando2           db "mediana", 0
    comando3           db "moda", 0
    comando4           db "max", 0
    comando5           db "min", 0
    comando6           db "contador", 0
    comando7           db "graf_barra_asc", 0
    comando8           db "graf_barra_desc", 0
    comando9           db "graf_linea", 0
    comando10          db "abrir_", 0
    comando11          db "limpiar", 0
    comando12          db "reporte", 0
    comando13          db "info", 0
    comando14          db "salir", 0



.CODE
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    MOV AX, 03h ; Definimos el modo video AH = 0h | AL = 03h
    INT 10h

    Main PROC
        BorrarPantalla

        Inicio:
            Mensaje
            CapturarComando comandoIngreso

            CompararCadenas comandoIngreso, comando1, promedioEtq
            CompararCadenas comandoIngreso, comando2, medianaEtq
            CompararCadenas comandoIngreso, comando3, modaEtq
            CompararCadenas comandoIngreso, comando4, maximoEtq
            CompararCadenas comandoIngreso, comando5, minimoEtq
            CompararCadenas comandoIngreso, comando6, contadorEtq
            CompararCadenas comandoIngreso, comando7, grafBarraAscEtq
            CompararCadenas comandoIngreso, comando8, grafBarraDescEtq
            CompararCadenas comandoIngreso, comando9, grafLineaEtq
            CompararCadenas comandoIngreso, comando10, abrirEtq
            CompararCadenas comandoIngreso, comando11, limpiarEtq
            CompararCadenas comandoIngreso, comando12, reporteEtq
            CompararCadenas comandoIngreso, comando13, infoEtq
            CompararCadenas comandoIngreso, comando14, SalirEtq

            promedioEtq:
                JMP Inicio
            
            medianaEtq:
                JMP Inicio

            modaEtq:
                JMP Inicio
            
            maximoEtq:
                JMP Inicio
            
            minimoEtq:
                JMP Inicio
            
            contadorEtq:
                JMP Inicio
            
            grafBarraAscEtq:
                JMP Inicio

            grafBarraDescEtq:
                JMP Inicio

            grafLineaEtq:
                JMP Inicio

            abrirEtq:
                JMP Inicio

            limpiarEtq:
                BorrarPantalla
                JMP Inicio
            
            reporteEtq:
                JMP Inicio

            infoEtq:
                InfoEstudiante
                CapturarOpcion enter
                JMP Inicio

            SalirEtq:
                Salir

    Main ENDP
END