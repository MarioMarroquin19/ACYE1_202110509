#  <p align="center">**ACYE1_202110509**</p>
## <p align="center">**PROYECTO 2**</p>

## 📌 **Manual de Usuario**

- **Consola**

    Al iniciar el ejecutable el usuario podrá visualizar el menú principal de la aplicación así como el texto que indica que ingrese un comando a la consola. 

    <p align = "center">
        <img src = "imgs/consola.png" width="500px">
    </p>

- **Comandos**

    Los comandos disponibles dentro de la aplicación son los siguientes:

        1. prom:  Mostrará en consola el resultado del promedio de los datos ingresados.
        2. mediana: Mostrará en consola el resultado de la mediana de los datos ingresados.
        3. moda: Mostrará en consola el resultado de la moda de los datos ingresados.
        4. max: Mostrará en consola el máximo número del conjunto de datosingresados.
        5. min: Mostrará en consola el mínimo número del conjunto de datosingresados.
        6. contador: Mostrar en consola el número de datos que se cargaron en el archivo de entrada.
        7. abrir: Entra al apartado para cargar el archivo csv y leer los datos.
        8. limpiar: Al ingresar este comando se limpia la consola y queda a la espera de otro comando.
        9. reporte: Al ingresar este comando se genera un reporte para visualizar los cálculos de mejor manera.
        9. info: Se muestra la información del desarrollador de la aplicación.
        10. salir: Termina el flujo del programa.

    <p align = "center">
            <img src = "imgs/mediana.png" width="500px">
    </p>

    Al presionar enter, se puede visualizar el valor de dicho comando.

    <p align = "center">
            <img src = "imgs/mediana2.png" width="500px">
    </p>
    
- **Reportes**

    La aplicacion generará un reporte en formato TXT, en donde se detallan de mejor manera los datos matemáticos previamente realizados y la información del desarrollador de la aplicación.

    <p align = "center">
        <img src = "imgs/reporte.png" width="500px">
    </p>

- **Salir**

    Con este comando, se termina el flujo de la aplicación.
    <p align = "center">
        <img src = "imgs/salir.png" width="500px">
    </p>


## 📌 **Manual Técnico**

- **Herramientas y Entorno de Desarrollo**

    La práctica fue realizada en Windows 11, utilizando software libre como el editor de código Visual Studio Code, DOSbox 0.74-3 y emu8086.

    Trabajando con MASM y distintas extensiones para VSCode.

    Las extensiones utilizadas fueron:

        1. MASM/TASM 
        2. MASM
        3. VSCode DOSBox

    Así mismo, se hizo utilización de tres archivos ejecutables para la compilación del main.asm en DOSBox, estos archivos se encuentran dentro de la carpeta ".exe necesitados". 

- **Macros**

    Las macros fueron de bastante utilidad en esta práctica, permitiendo realizar de cierta forma el papel de funciones de un lenguaje de alto nivel. Las macros fueron establecidas y declaradas al principio. Cada macro con un propósito específico, rellenar el tablero, limpiar consola, obtener entrada, etc etc.

    <p align = "center">
        <img src = "imgs/macros.png" width="500px">
    </p>

- **DATA**

    Dentro del apartado ".DATA" se definieron todas las variables y se inicializaron, ya sean los mensajes para mostrar en pantalla, así como las variables donde se almacena una entrada del teclado. El símbolo "$" es para indicar el final de una cadena.

    <p align = "center">
        <img src = "imgs/data.png">
    </p>

- **CODE**

    Dentro del apartado ".CODE" se realiza al ejecucion del programa, aquí es donde se define el flujo de la aplicacion.

    <p align = "center">
        <img src = "imgs/code.png" width = "700px">
    </p>

    Dentro de este apartado se obtiene la entrada del teclado, y se compara para conocer hacía que etiqueta se debe realizar el salto correspondiente.

    <p align = "center">
        <img src = "imgs/salto.png" width = "700px">
    </p>

    Dentro de este apartado se utilizan distintas etiquetas, a las cuales se acceden a través de saltos, estas etiquetas cumplen con un rol específico, ya sea mostrar el tablero en pantalla, obtener la fila y columna, mostrar errores al ingreso de datos, generar el reporte HTML, etc etc.

    <p align = "center">
        <img src = "imgs/MostrarT.png" width = "700px">
    </p>

- **Salida**

    Esta es la etiqueta responsable de finalizar con el flujo del programa, lo hace por medio de una interrupción (las cuales también son parte fundamental para mostrar o ingresar información al sistema).

    <p align = "center">
        <img src = "imgs/salida.png" width = "700px">
    </p>

- **Bibliografías Utilizadas Durante el Desarrollo de la Práctica**

<a href="https://moisesrbb.tripod.com/unidad6.htm#u641" target="_blank">Interrupciones y manejo de archivos DOS</a>
