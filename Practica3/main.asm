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

TableroOriginal MACRO 
    MOV SI, 16

    TableroOriginal1:
    MOV tablero[SI], 32; espacio en blanco
    CMP SI, 48
    JB TableroOriginal2
    JMP SalirTableroOriginal
    TableroOriginal2:
        INC SI
        JMP TableroOriginal1
    SalirTableroOriginal:
    
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
    MOV CX, 150 ; cantidad de bytes a leer
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
    MOV CX, 150 ; cantidad de bytes a escribir, debe irse modificando dependiendo de cuanto vamos a escribir, si no salen simbolos raros
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
    MOV DH, BL ; Guardar el valor original de BL
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV DL, AL ; Guardar el valor original de AL
    ; Después de la operación row-major
    MOV SI, AX
    ; Verificar qué pieza está en esa posición

    CMP tablero[SI], 84 ; Si es un torre (T en ASCII)
    MOV CH, 84; CH = T en ASCII
    JE AuxTorreAdelante111

    CMP tablero[SI], 67 ; Si es un caballo (C en ASCII)
    MOV CH, 67; CH = C en ASCII
    JE VerificarCasillaCaballo11

    CMP tablero[SI], 65 ; Si es un alfil (A en ASCII)
    MOV CH, 65; CH = A en ASCII
    JE VerificarCasillaAlfil11

    CMP tablero[SI], 82 ; Si es un rey  (R en ASCII)
    MOV CH, 82; CH = R en ASCII
    JE VerificarCasillaRey1

    CMP tablero[SI], 42 ; Si es una reina (* en ASCII)
    MOV CH, 42; CH = * en ASCII
    JE VerificarCasillaReina

    CMP tablero[SI], 80 ; Si es un peón blanco (P en ASCII)
    MOV CH, 80; CH = P en ASCII
    JE AuxPeonAdelante

    VerificarCasillaReina:
        MOV AL, DL ; Restaurar el valor original de AL
        MOV BL, DH ; Restaurar el valor original de BL

        MoverRArriba1:
            SUB AL, 8
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRArriba1
            MOV AL, DL ; Restaurar el valor original de AL
            JMP MoverRAbajo1
        
    AuxTorreAdelante111:
        JMP AuxTorreAdelante11
    
    AuxPeonAdelante:
        JMP AuxPeonAdelante1
    
    VerificarCasillaCaballo11:
        JMP VerificarCasillaCaballo1
    
    VerificarCasillaAlfil11:
        JMP VerificarCasillaAlfil1

            XMoverRArriba1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRArriba1

        MoverRAbajo1: 
            ADD AL, 8
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRAbajo1
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverRDerecha1

            XMoverRAbajo1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRAbajo1

        MoverRDerecha1:
            ADD AL, 1
            ADD BL, 1
            CMP BL, 7
            JA ReiniciarValoresRIzquierda1
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDerecha1
            JMP ReiniciarValoresRIzquierda1

            XMoverRDerecha1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDerecha1

        ReiniciarValoresRIzquierda1: 
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverRIzquierda1

    VerificarCasillaRey1:
        JMP VerificarCasillaRey11
    
    VerificarCasillaCaballo1:
        JMP VerificarCasillaCaballo22
    
    VerificarCasillaAlfil1:
        JMP VerificarCasillaAlfil22
    
    AuxTorreAdelante11:
        JMP AuxTorreAdelante112
    
    AuxPeonAdelante1:
        JMP AuxPeonAdelante2

        MoverRIzquierda1:
            SUB AL, 1
            SUB BL, 1
            CMP BL, 0
            JL ReiniciarRDiagonalAD
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRIzquierda1
            JMP ReiniciarRDiagonalAD

            XMoverRIzquierda1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRIzquierda1

        ReiniciarRDiagonalAD:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverRDiagonalArribaDerecha1

        MoverRDiagonalArribaDerecha1:
            SUB AL, 7
            ADD BL, 1
            CMP BL, 7
            JA ReiniciarRDiagonalAIz
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalArribaDerecha1
            JMP ReiniciarRDiagonalAIz

    VerificarCasillaCaballo22:
        JMP VerificarCasillaCaballo2
    
    VerificarCasillaAlfil22:
        JMP VerificarCasillaAlfil2

    AuxTorreAdelante112:
        JMP AuxTorreAdelante1
    
    AuxPeonAdelante2:
        JMP AuxPeonAdelante3
    
    VerificarCasillaRey11:
        JMP VerificarCasillaRey2

            XMoverRDiagonalArribaDerecha1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalArribaDerecha1
        
        ReiniciarRDiagonalAIz:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverRDiagonalArribaIzquierda1

        MoverRDiagonalArribaIzquierda1:
            SUB AL, 9
            SUB BL, 1
            CMP BL, 0
            JL ReiniciarValoresRDiagonalAbajoDerecha1
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalArribaIzquierda1
            JMP ReiniciarValoresRDiagonalAbajoDerecha1

            XMoverRDiagonalArribaIzquierda1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalArribaIzquierda1
    
    VerificarCasillaRey2:
        JMP VerificarCasillaRey

    VerificarCasillaCaballo2:
        JMP VerificarCasillaCaballo3

    VerificarCasillaAlfil2:
        JMP VerificarCasillaAlfil3

    AuxTorreAdelante1:
            JMP AuxTorreAdelante2

    AuxPeonAdelante3:
        JMP AuxPeonAdelante4

        ReiniciarValoresRDiagonalAbajoDerecha1:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverRDiagonalAbajoDerecha1

        MoverRDiagonalAbajoDerecha1:
            ADD AL, 9
            ADD BL, 1
            CMP BL, 7
            JA ReiniciarValoresRDiagonalAbajoIzquierda1
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalAbajoDerecha1
            JMP ReiniciarValoresRDiagonalAbajoIzquierda1

            XMoverRDiagonalAbajoDerecha1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalAbajoDerecha1
        
        ReiniciarValoresRDiagonalAbajoIzquierda1:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverRDiagonalAbajoIzquierda1

        MoverRDiagonalAbajoIzquierda1:
            ADD AL, 7
            SUB BL, 1
            CMP BL, 0
            JL AuxSalidaMOV7
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalAbajoIzquierda1
            JMP AuxSalidaMOV7

            XMoverRDiagonalAbajoIzquierda1:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalAbajoIzquierda1
    
    AuxSalidaMOV7:
        JMP AuxSalidaMOV6

    VerificarCasillaRey:
        MOV AL, DL ; Restaurar el valor original de AL
        MOV BL, DH ; Restaurar el valor original de BL

        MoverRArriba:
            SUB AL, 8
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRArriba
            JMP MoverRAbajo

            XMoverRArriba:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRAbajo

    VerificarCasillaCaballo3:
        JMP VerificarCasillaCaballo4
    
    VerificarCasillaAlfil3: 
        JMP VerificarCasillaAlfil4

    AuxTorreAdelante2:
        JMP AuxTorreAdelante3
    
    AuxPeonAdelante4:
        JMP AuxPeonAdelante5

        MoverRAbajo:
            MOV AL, DL ; Restaurar el valor original de AL
            ADD AL, 8
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRAbajo
            JMP MoverRDerecha

            XMoverRAbajo:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDerecha

        MoverRDerecha:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            ADD AL, 1
            ADD BL, 1
            CMP BL, 7
            JA MoverRIzquierda
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDerecha
            JMP MoverRIzquierda

            XMoverRDerecha:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRIzquierda

        MoverRIzquierda:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            SUB AL, 1
            SUB BL, 1
            CMP BL, 0
            JL MoverRDiagonalArribaDerecha
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRIzquierda
            JMP MoverRDiagonalArribaDerecha

            XMoverRIzquierda:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalArribaDerecha

    VerificarCasillaCaballo4:
        JMP VerificarCasillaCaballo44

    VerificarCasillaAlfil4:
        JMP VerificarCasillaAlfil5

    AuxTorreAdelante3:
        JMP AuxTorreAdelante33
    
    AuxPeonAdelante5:
        JMP AuxPeonAdelante6

        MoverRDiagonalArribaDerecha:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            SUB AL, 7
            ADD BL, 1
            CMP BL, 7
            JA MoverRDiagonalArribaIzquierda
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalArribaDerecha
            JMP MoverRDiagonalArribaIzquierda

            XMoverRDiagonalArribaDerecha:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalArribaIzquierda

        MoverRDiagonalArribaIzquierda:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            SUB AL, 9
            SUB BL, 1
            CMP BL, 0
            JL MoverRDiagonalAbajoDerecha
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalArribaIzquierda
            JMP MoverRDiagonalAbajoDerecha

            XMoverRDiagonalArribaIzquierda:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalAbajoDerecha

    VerificarCasillaAlfil5:
        JMP VerificarCasillaAlfil

    AuxTorreAdelante33:
            JMP AuxTorreAdelante4
    
    AuxPeonAdelante6:
        JMP AuxPeonAdelante7

    VerificarCasillaCaballo44:
        JMP VerificarCasillaCaballo5

        MoverRDiagonalAbajoDerecha:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            ADD AL, 9
            ADD BL, 1
            CMP BL, 7
            JA MoverRDiagonalAbajoIzquierda
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalAbajoDerecha
            JMP MoverRDiagonalAbajoIzquierda

            XMoverRDiagonalAbajoDerecha:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverRDiagonalAbajoIzquierda

        MoverRDiagonalAbajoIzquierda:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            ADD AL, 7
            SUB BL, 1
            CMP BL, 0
            JL AuxSalidaMOV6
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverRDiagonalAbajoIzquierda
            JMP AuxSalidaMOV6

            XMoverRDiagonalAbajoIzquierda:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP AuxSalidaMOV6
    
    AuxSalidaMOV6:
        JMP AuxSalidaMOV5

    VerificarCasillaCaballo5:
        JMP VerificarCasillaCaballo6
    
    AuxTorreAdelante4:
            JMP AuxTorreAdelante5
    
    AuxPeonAdelante7:
        JMP AuxPeonAdelante8

    VerificarCasillaAlfil:
        MOV AL, DL ; Restaurar el valor original de AL
        MOV BL, DH ; Restaurar el valor original de BL

        MoverAlfilDerechaArriba:
            SUB AL, 8
            ADD AL, 1
            ADD BL, 1
            CMP BL, 7
            JG MoverAlfilDerechaAbajo
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverAlfilDerechaArriba
            JMP MoverAlfilDerechaAbajo
        
            XMoverAlfilDerechaArriba:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverAlfilDerechaArriba            

        MoverAlfilDerechaAbajo:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverAlfilDerechaAbajo1

            MoverAlfilDerechaAbajo1:
                ADD AL, 9
                ADD BL, 1
                CMP BL, 7
                JG MoverAlfilIzquierdaArriba
                MOV SI, AX
                CMP tablero[SI], 32 ; Verifica si la casilla está vacía
                JE XMoverAlfilDerechaAbajo
                JMP MoverAlfilIzquierdaArriba

            XMoverAlfilDerechaAbajo:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverAlfilDerechaAbajo1

        MoverAlfilIzquierdaArriba:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverAlfilIzquierdaArriba1

    VerificarCasillaCaballo6:
        JMP VerificarCasillaCaballo

    AuxTorreAdelante5:
        JMP AuxTorreAdelante66
    
    AuxPeonAdelante8:
        JMP AuxPeonAdelante9

            MoverAlfilIzquierdaArriba1:
                SUB AL, 9
                SUB BL, 1
                CMP BL, 0
                JL MoverAlfilIzquierdaAbajo
                MOV SI, AX
                CMP tablero[SI], 32 ; Verifica si la casilla está vacía
                JE XMoverAlfilIzquierdaArriba
                JMP MoverAlfilIzquierdaAbajo

            XMoverAlfilIzquierdaArriba:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverAlfilIzquierdaArriba1

        MoverAlfilIzquierdaAbajo:
            MOV AL, DL ; Restaurar el valor original de AL
            MOV BL, DH ; Restaurar el valor original de BL
            JMP MoverAlfilIzquierdaAbajo1

            MoverAlfilIzquierdaAbajo1:
                ADD AL, 7
                SUB BL, 1
                CMP BL, 0
                JL AuxSalidaMOV5
                MOV SI, AX
                CMP tablero[SI], 32 ; Verifica si la casilla está vacía
                JE XMoverAlfilIzquierdaAbajo
                JMP AuxSalidaMOV5

    AuxTorreAdelante66:
        JMP AuxTorreAdelante77
    
    AuxPeonAdelante9:
        JMP AuxPeonAdelante10

            XMoverAlfilIzquierdaAbajo:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverAlfilIzquierdaAbajo1

    AuxSalidaMOV5:
            JMP AuxSalidaMOV4

    VerificarCasillaCaballo:
        MOV AL, DL ; Restaurar el valor original de AL
        MOV BL, DH ; Restaurar el valor original de BL
        SUB AL, 16; Restar 16 a AL

        CMP BL,7
        JB MoverCaballoAdelanteDerecha
        JMP Izqui2

        Izqui2:
            CMP BL, 0
            JA MoverCaballoAdelanteIzquierda
            JMP MoverCaballoAtrasDerecha

        MoverCaballoAdelanteDerecha:
            ADD AL, 1
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverCaballoAdelanteDerecha
            JMP Izqui2
    
    AuxTorreAdelante77:
        JMP AuxTorreAdelante7
    
    AuxPeonAdelante10:
        JMP AuxPeonAdelante11

        MoverCaballoAdelanteIzquierda:
            MOV AL, DL ; Restaurar el valor original de AL
            SUB AL, 16
            SUB AL, 1
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverCaballoAdelanteIzquierda
            JMP MoverCaballoAtrasDerecha

        XMoverCaballoAdelanteDerecha:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            CMP BL, 0
            JA MoverCaballoAdelanteIzquierda
            JMP MoverCaballoAtrasDerecha
        
        XMoverCaballoAdelanteIzquierda:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverCaballoAtrasDerecha

        MoverCaballoAtrasDerecha:
            MOV AL, DL ; Restaurar el valor original de AL
            ADD AL, 16
            CMP BL, 7
            JB MoverCaballoAtrasDerechaX
            JMP AtrasIzquierda 

            AtrasIzquierda:
                CMP BL, 0
                JA MoverCaballoAtrasIzquierda
                JMP MoverCaballoDerecha

            MoverCaballoAtrasDerechaX:
                ADD AL, 1
                MOV SI, AX
                CMP tablero[SI], 32 ; Verifica si la casilla está vacía
                JE XMoverCaballoAtrasDerecha
                JMP AtrasIzquierda

    AuxTorreAdelante7:
        JMP AuxTorreAdelante8
    
    AuxPeonAdelante11:
        JMP AuxPeonAdelante12

            XMoverCaballoAtrasDerecha:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                CMP BL, 0
                JA MoverCaballoAtrasIzquierda
                JMP MoverCaballoDerecha
            
            MoverCaballoAtrasIzquierda:
                MOV AL, DL ; Restaurar el valor original de AL
                ADD AL, 16
                SUB AL, 1
                MOV SI, AX
                CMP tablero[SI], 32 ; Verifica si la casilla está vacía
                JE XMoverCaballoAtrasIzquierda
                JMP MoverCaballoDerecha
            
            XMoverCaballoAtrasIzquierda:
                MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
                JMP MoverCaballoDerecha

    MoverCaballoDerecha:
        MOV AL, DL
        ADD AL, 2

        CMP BL, 6
        JB MoverCaballoDerechaArriba
        JMP MoverCaballoIzq
        
        MoverCaballoDerechaArriba:
            SUB AL, 8
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverCaballoDerechaArriba
            JMP MoverCaballoDerechaAbajo

        XMoverCaballoDerechaArriba:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverCaballoDerechaAbajo
        
        MoverCaballoDerechaAbajo:
            MOV AL, DL
            ADD AL, 10
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverCaballoDerechaAbajo
            JMP MoverCaballoIzq

        XMoverCaballoDerechaAbajo:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverCaballoIzq

    AuxTorreAdelante8:
        JMP AuxTorreAdelante9
    
    AuxPeonAdelante12:
        JMP VerificarCasillaPeonAdelante

    MoverCaballoIzq:
        MOV AL, DL
        SUB AL, 2

        CMP BL, 1
        JA MoverCaballoIzqArriba
        JMP AuxSalidaMOV4
        
        MoverCaballoIzqArriba:
            SUB AL, 8
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverCaballoIzqArriba
            JMP MoverCaballoIzqAbajo

        XMoverCaballoIzqArriba:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverCaballoIzqAbajo
        
        MoverCaballoIzqAbajo:
            MOV AL, DL
            SUB AL, 2
            ADD AL, 8
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XMoverCaballoIzqAbajo
            JMP AuxSalidaMOV4

        XMoverCaballoIzqAbajo:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP AuxSalidaMOV4

    AuxSalidaMOV4:
        JMP AuxSalidaMOV3

    AuxTorreAdelante9:
            JMP VerificarCasillaTorreAdelante
    
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

        JMP AuxSalidaMOV3
    
        MoverPeonBlanco:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            MOV AL, DL ; Restaurar el valor original de AL
            SUB AL, 8; Restar 8 a AL
            MOV SI, AX
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP AuxSalidaMOV3
    
    AuxSalidaMOV3:
        JMP AuxSalidaMOV2

    VerificarCasillaTorreAdelante:
        MOV AL, DL ; Restaurar el valor original de AL
        SUB AL, 8; Restar 8 a AL
        MOV CL, 8
        MOV SI, AX
        CMP tablero[SI], 32 ; Verifica si la casilla está vacía
        JE MoverTorreBlancaAdelante
        JMP VerificarCasillaTorreAtras

        MoverTorreBlancaAdelante:
            MOV AL, DL ; Restaurar el valor original de AL
            SUB AL, CL; Restar CL a AL
            ADD CL, 8; CL = CL + 8	
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XTorreBlancaArriba
            JMP VerificarCasillaTorreAdelante

        XTorreBlancaArriba:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverTorreBlancaAdelante
    
    AuxSalidaMOV2:
        JMP AuxSalidaMOV1

    VerificarCasillaTorreAtras:
        MOV AL, DL ; Restaurar el valor original de AL
        ADD AL, 8; Sumar 8 a AL
        MOV CL, 8
        MOV SI, AX
        CMP tablero[SI], 32 ; Verifica si la casilla está vacía
        JE MoverTorreBlancaAtras
        JMP VerificarCasillaTorreDerecha
        
        MoverTorreBlancaAtras:
            MOV AL, DL ; Restaurar el valor original de AL
            ADD AL, CL; Sumar CL a AL
            ADD CL, 8; CL = CL + 8	
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XTorreBlancaAtras
            JMP VerificarCasillaTorreAtras

        XTorreBlancaAtras:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP MoverTorreBlancaAtras

    AuxSalidaMOV1:
        JMP AuxSalidaMOV    
    
    VerificarCasillaTorreDerecha:
        MOV AL, DL ; Restaurar el valor original de AL
        MOV BL, DH ; Restaurar el valor original de BL

        ;VERIFICAR si la columna no se ha pasado de la columna H
        CMP BL, 7
        JB MoverTorreBlancaDerecha
        JMP VerificarCasillaTorreIzquierda

        movimientoColumnaDerecha:
            CMP BL, 7
            JB MoverTorreBlancaDerecha ; VERIFICAR QUE EL VALOR DE BL SEA MENOR A 104 (por que hasta 104 es h en ASCII)
            JMP VerificarCasillaTorreIzquierda

        MoverTorreBlancaDerecha:
            ADD BL, 1; Sumar 1 a BL
            ADD AL, 1           
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XTorreBlancaDerecha
            JMP VerificarCasillaTorreIzquierda
            
        XTorreBlancaDerecha:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP movimientoColumnaDerecha
    
    AuxSalidaMOV:
        JMP SalidaMOV

    VerificarCasillaTorreIzquierda:
        MOV AL, DL ; Restaurar el valor original de AL
        MOV BL, DH ; Restaurar el valor original de BL

        ;VERIFICAR si la columna no se ha pasado de la columna A
        CMP BL, 0
        JA MoverTorreBlancaIzquierda
        JMP AuxSalidaMOV

        movimientoColumnaIzquierda:
            CMP BL, 0
            JA MoverTorreBlancaIzquierda ; VERIFICAR QUE EL VALOR DE BL SEA MAYOR A 0 (por que 0 es a en el tablero de ajedrez)
            JMP SalidaMOV

        MoverTorreBlancaIzquierda:
            SUB BL, 1; Restar 1 a BL
            SUB AL, 1           
            MOV SI, AX
            CMP tablero[SI], 32 ; Verifica si la casilla está vacía
            JE XTorreBlancaIzquierda
            JMP SalidaMOV
            
        XTorreBlancaIzquierda:
            MOV tablero[SI], 120 ; Coloca una "x" en la casilla, para informar que se puede mover
            JMP movimientoColumnaIzquierda

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
    JE moverPeon1
    CMP CH, 84 ; Si es un torre (T en ASCII)
    JE moverTorre1
    CMP CH, 67 ; Si es un caballo (C en ASCII)
    JE moverCaballo1
    CMP CH, 65 ; Si es un alfil (A en ASCII)
    JE moverAlfil
    CMP CH, 82 ; Si es un rey  (R en ASCII)
    JE moverRey
    CMP CH, 42 ; Si es una reina (* en ASCII)
    JE moverReina

    JMP AuxSalida3

    moverTorre1:
        JMP moverTorre

    moverPeon1:
        JMP moverPeon2
    
    moverCaballo1:
        JMP moverCaballo2

    moverReina:
        MOV tablero[SI], 42
        MOV AL, filaPosible
        MOV BL, columnaPosible
        SUB AL, 49
        SUB BL, 97
        MOV BH, 8
        MUL BH
        ADD AL, BL
        MOV SI, AX
        MOV tablero[SI], 32
        JMP AuxSalida3
    
    AuxSalida3:
        JMP AuxSalida2

    moverRey:
        MOV tablero[SI], 82
        MOV AL, filaPosible
        MOV BL, columnaPosible
        SUB AL, 49
        SUB BL, 97
        MOV BH, 8
        MUL BH
        ADD AL, BL
        MOV SI, AX
        MOV tablero[SI], 32
        JMP AuxSalida2

    moverTorre2:
        JMP moverTorre
    
    moverPeon2:
        JMP moverPeon3
    
    moverCaballo2:
        JMP moverCaballo

    moverAlfil:
        MOV tablero[SI], 65
        MOV AL, filaPosible
        MOV BL, columnaPosible
        SUB AL, 49
        SUB BL, 97
        MOV BH, 8
        MUL BH
        ADD AL, BL
        MOV SI, AX
        MOV tablero[SI], 32
        JMP AuxSalida2

    AuxSalida2:
        JMP AuxSalida

    moverCaballo:
        MOV tablero[SI], 67
        MOV AL, filaPosible
        MOV BL, columnaPosible
        SUB AL, 49
        SUB BL, 97
        MOV BH, 8
        MUL BH
        ADD AL, BL
        MOV SI, AX
        MOV tablero[SI], 32
        JMP AuxSalida

    AuxSalida:
        JMP SalidaMoverPieza

    moverPeon3:
        JMP moverPeon

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
    textoInicioJuego db "   vs  IA      Turno: ", "$"
    handleArchivo DW ? ; Define handleArchivo como una variable de palabra (word) manejador del archivo de 16 bits
    nombreArchivo db "puntajes.txt", 00h ; nombre del archivo, terminar con 00h
    ArchivoReporte db "reportes.htm", 00h ; nombre del archivo, terminar con 00h
    textoReporte db "<!DOCTYPE html>", 10, 13, "<html>", 10, 13, "<head>", 10, 13, "<title>REPORTE</title>", 10, 13, "</head>", 10, 13, "<body>", 10, 13, "<h1>REPORTE</h1>", 10, 13,"<p><b>Nombre del curso:</b>", "$"
    textoReporte1 db "Arquitectura de computadores y ensambladores 1</p>", 10, 13,"<p><b>Sección: </b>A</p>",10, 13,"<p><b>Nombre del estudiante:</b>Mario Ernesto Marroquin Perez</p>", 10, 13, "$"
    textoReporte2 db "<p><b>Carnet:</b>202110509</p>", 10, 13,"<h2>Puntaje de Jugadores</h2>", 10,13,"<table border='1'>", 10, 13, "<tr>", 10, 13, "<th>Nombre</th>", "$"
    textoReporte3 db  10, 13,"<th>Tiempo</th>", 10, 13, "</tr>", 10, 13,"</table>", 10, 13,"</body>", 10, 13, "</html>", "$"
    textoErrorArchivo db "Error con el archivo", '$'
    textoCreacion db 10, 13, "El Archivo Se Creo Correctamente", "$"
    buffer db 150 dup("$") ; Buffer para almacenar el contenido leido de un archivo
    textoIngreseFila db "Ingrese la fila: ", "$"
    textoIngreseColumna db "Ingrese la columna (letra minuscula): ", "$"
    textoMovimientos db "Seleccione una pieza para visualizar los posibles movimientos", "$"
    textoMovimiento db "Elija el movimiento a realizar", "$"
    textoRegresarMenu db "Ingrese m si desea regresar al menu", "$"
    textoErrorFila db 10,13,"ERROR, fila ingresada no valida (presione enter)", "$"
    textoErrorColumna db 10,13, "ERROR, columna ingresada no valida (presione enter)", "$"
    tituloNombre db "Nombre del jugador - Tiempo ", "$"

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
            
            CMP seleccion, 50 ; 50 es el valor ASCII de 2, estamos estimulando el registro de banderas
            JE MostrarPuntajes

            CMP seleccion, 51 ; 51 es el valor ASCII de 3, estamos estimulando el registro de banderas
            JE MostrarReportes1

            CMP seleccion, 52 ; 52 es el valor ASCII de 4, estamos estimulando el registro de banderas
            JE SalidaRapida2
                        
            JMP Menu

        SaltoPrincipal:
            JMP Principal

        SalidaRapida2:
            JMP Salida
        
        MostrarReportes1:
            JMP MostrarReportes

        MostrarPuntajes:
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto tituloNombre
            MostrarTexto saltoLinea
            MostrarTexto nombreJugador
            MostrarTexto saltoLinea
            CapturarOpcion seleccion
            JMP Principal

        MostrarTablero:
            BorrarPantalla
            MostrarTexto textoNombreJugador
            CapturarNombre nombreJugador ; captura el nombre con un máximo de 5 caracteres
            BorrarPantalla
            MostrarTexto nombreJugador
            MostrarTexto textoInicioJuego
            MostrarTexto nombreJugador
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            TableroOriginal
            RellenarTablero
            DibujarTablero
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            JMP PedirOpcionFila

        SaltoPrincipal1:
            JMP SaltoPrincipal

        PedirOpcionFila:
            MostrarTexto textoMovimientos
            MostrarTexto saltoLinea
            MostrarTexto textoRegresarMenu
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto textoIngreseFila
            CapturarOpcion filaPosible

            ;Verificar que la fila ingresada sea valida
            CMP filaPosible, 49
            JB ErrorFila

            CMP filaPosible, 109
            JE SaltoPrincipal1

            CMP filaPosible, 56
            JA ErrorFila
            JMP PedirOpcionColumna

            ErrorFila:
                MostrarTexto textoErrorFila
                CapturarOpcion seleccion
                JMP PedirOpcionFila
            
        SaltoPrincipal2:
            JMP SaltoPrincipal1
        
        PedirOpcionColumna:
            MostrarTexto saltoLinea
            MostrarTexto textoIngreseColumna
            CapturarOpcion columnaPosible

            CMP columnaPosible, 97
            JB ErrorColumna

            CMP columnaPosible, 109
            JE SaltoPrincipal2

            CMP columnaPosible, 104
            JA ErrorColumna
            JMP MostrarMovimientosPosibles

            ErrorColumna:
                MostrarTexto textoErrorColumna
                CapturarOpcion seleccion
                JMP PedirOpcionColumna


        MostrarMovimientosPosibles:
            BorrarPantalla
            MostrarTexto nombreJugador
            MostrarTexto textoInicioJuego
            MostrarTexto nombreJugador
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            ; aqui poner de nuevo el tablero con los movimientos posibles de dicha pieza
            MovimientoPiezas
            DibujarTablero
            JMP MostrarMoviemientos

        MostrarMoviemientos:
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            MostrarTexto textoMovimiento
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea
            JMP PedirOpcionFilaMOV
        
        SaltoPrincipal3:
            JMP SaltoPrincipal2

        PedirOpcionFilaMOV:
            MostrarTexto textoIngreseFila
            CapturarOpcion filaMov ; elegir uno de los movimientos posibles
            MostrarTexto saltoLinea

            ;Verificar que la fila ingresada sea valida
            CMP filaMov, 49
            JB ErrorFilaMOV

            CMP filaMov, 109
            JE SaltoPrincipal3

            CMP filaMov, 56
            JA ErrorFilaMOV
            JMP PedirOpcionColumnaMOV

            ErrorFilaMOV:
                MostrarTexto textoErrorFila
                CapturarOpcion seleccion
                JMP PedirOpcionFilaMOV

        SaltoPrincipal4:
            JMP SaltoPrincipal3

        PedirOpcionColumnaMOV:
            MostrarTexto textoIngreseColumna
            CapturarOpcion columnaMov
            MostrarTexto saltoLinea
            MostrarTexto saltoLinea

            CMP columnaMov, 97
            JB ErrorColumnaMOV

            CMP columnaMov, 109
            JE SaltoPrincipal4

            CMP columnaMov, 104
            JA ErrorColumnaMOV
            JMP MoverPiezaTablero

            ErrorColumnaMOV:
                MostrarTexto textoErrorColumna
                CapturarOpcion seleccion
                JMP PedirOpcionColumnaMOV
        
        MoverPiezaTablero:
            BorrarPantalla
            MostrarTexto nombreJugador
            MostrarTexto textoInicioJuego
            MostrarTexto nombreJugador
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
            JMP PedirOpcionFila

        SalidaRapida: ; Salida rápida (salto corto)
            JMP Salida

        MostrarReportes:
            NuevoArchivo ArchivoReporte, handleArchivo
            CMP seleccion, 13 ;verificamos que no exista error
            JE SalidaRapida
            ;PosicionFinalApuntador handleArchivo
            EscribirArchi textoReporte, handleArchivo
            EscribirArchi textoReporte1, handleArchivo
            EscribirArchi textoReporte2, handleArchivo
            EscribirArchi textoReporte3, handleArchivo
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
            JMP SaltoPrincipal4


        Salida: 
            MostrarTexto buffer
            MOV AX, 4C00h ;terminar el programa(interrupción)
            INT 21h

    Principal ENDP
END