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
    textoIngresarOpcion db ">>Ingrese una opcion:","$"
    opcionTotito1 db "|1.| 1 vs CPU", "$"
    opcionTotito2 db "|2.| 1 vs 1", "$"
    opcionTotito3 db "|3.| Reportes", "$"
    opcionTotito4 db "|4.| Regresar", "$"


.CODE

    MOV AX, @data
    MOV DS, AX


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
                MostrarTextoColor textoOpcion, 0Bh, 28
                MostrarTexto ln
                MostrarTexto ln
                MostrarTextoColor opcionTotito1, 0Ch, 13
                MostrarTexto ln
                MostrarTexto ln
                MostrarTextoColor opcionTotito2, 0Ah, 11
                MostrarTexto ln
                MostrarTexto ln
                MostrarTextoColor opcionTotito3, 0Dh, 13
                MostrarTexto ln
                MostrarTexto ln
                MostrarTextoColor opcionTotito4, 0Eh, 13
                MostrarTexto ln
                MostrarTexto ln
                MostrarTexto textoIngresarOpcion
                CapturarOpcion opcion
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