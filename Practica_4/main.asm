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

.MODEL small
.STACK 64h

.DATA
    ln db 10, 13, "$"
    textoInicio db "|M|E|N|U| |P|R|I|N|C|I|P|A|L|", "$"
    textoAdorno db "+-+-+-+-+ +-+-+-+-+-+-+-+-+-+", "$"
    textoOpciones db "|1.| NUEVO JUEGO", 10,13,10,13, "|2.| ANIMACION", 10,13,10,13, "|3.| INFORMACION", 10,13,10,13, "|4.| SALIR", 10,13,10,13, ">>Ingrese una opcion: ", "$"
    textoInfo db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10,13, "FACULTAD DE INGENIERIA", 10, 13, "ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", "$"
    textoInfo1 db 10, 13,"SECCION A", 10, 13, "Primer Semestre 2024", 10, 13, "Mario Ernesto Marroquin Perez", 10, 13, "202110509", 10,13,"$"
    textoPractica db "*******************************", 10,13, "****  P R A C T I C A   4  ****", 10,13, "*******************************","$"
    opcion db 1 dup(32);
    textoRegresar db "Presione una tecla para regresar al menu: ", "$"
    textoOpcionesTotito db "|1.| 1 vs CPU", 10,13, "|2.| 1 vs 1", 10,13, "|3.| Reportes", 10,13, "|4.| Regresar", 10,13,10,13, ">>Ingrese una opcion:","$"

.CODE

    MOV AX, @data
    MOV DS, AX


    Principal PROC
        BorrarPantalla

        Menu:
            BorrarPantalla
            MostrarTexto textoAdorno
            MostrarTexto ln
            MostrarTexto textoInicio
            MostrarTexto ln
            MostrarTexto textoAdorno
            MostrarTexto ln
            MostrarTexto ln

            MostrarTexto textoOpciones
            CapturarOpcion opcion

            CMP opcion, 49
            JE NuevoJuego

            CMP opcion, 50
            JE Animacion

            CMP opcion, 51
            JE Informacion

            CMP opcion, 52
            JE Salir

            JMP Menu

            NuevoJuego:
                BorrarPantalla
                MostrarTexto textoOpcionesTotito
                CapturarOpcion opcion
                JMP Menu

            Animacion: 
                BorrarPantalla
                JMP Menu

            Informacion:
                BorrarPantalla
                MostrarTexto textoPractica
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