{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}


program playbingo;


uses crt, sysutils;


const
    MaxCartones = 10;

type
    { Tipo de dato que representa un jugador necesito 3 jugadores array de 3, pero eso va a ser tipo de dato juego
    a su vez, cada jugador tiene un array de cartones, y cada carton tiene un array de filas, y cada fila tiene un array de numeros
    }
    tipo_color = (rojo, verde, azul, amarillo, ninguno);

    fila_carton = record
        color: tipo_color;
        numeros: array[1..5] of integer;
    end;

    carton = record
        filas: array[1..3] of fila_carton;
    end;

    jugador = record
        nombre: string;
        cartones: array[1..MaxCartones] of carton;
        numCartones: integer;
    end;
    tipoJuego = record
        jugadores: array[1..3] of jugador;
    end;

    { Jugadas de bingo }
    tipoJugada = record
        numero: integer;
        color: tipo_color;
    end;

    tipoJugadas = record
        jugadas: array[1..100] of tipoJugada;
        elementos: integer; {Numero de elementos que tiene el array}
    end;

    { Variables globales }


    { Struct que sea que los numeros son STRING para que así puedan ponerse una x en os tachados}
    fila_carton_string = record
        color: tipo_color;
        numeros: array[1..5] of string;
    end;
    carton_string = record
        filas: array[1..3] of fila_carton_string;
    end;


procedure faseExtraccionJugadasBingo(var jugadas: tipoJugadas; entrada: string);
var
    i, valor: integer;
    colorString: string;
    color: tipo_color;
    temp: string;
    colorFilaCompleto: boolean;

begin
    temp := '';
    { De Cada linea se extraen los valores de cada linea y a partir de ahí se introduciran valores}
    i := 1;
    {Se extrae color si existe}
    colorString := '';
    colorFilaCompleto := false;


    while (i <= length(entrada)) do
    begin
        
        if entrada[i] in ['A'..'Z'] then
            exit; {Si hay mayúsculas, se sale de la función}
        
        
        if entrada[i] = '' then
        begin
            {Se comprueba se hay elementos a añadir a las variables, o colorString o temp}
            if (colorString <> '') and (colorFilaCompleto = false) then
            begin
                if colorString = 'rojo' then
                begin
                    color := rojo;
                end
                else if colorString = 'verde' then
                begin
                    color := verde;
                end
                else if colorString = 'azul' then
                begin
                    color := azul;
                end
                else if colorString = 'amarillo' then
                begin
                    color := amarillo;
                end
                else
                begin
                    exit; {Si no es ninguno de los colores, se sale de la función}  
                end;
                
                {Se asigna el color al jugador}
                jugadas.jugadas[jugadas.elementos].color := color;
                colorString := '';
                colorFilaCompleto := true;
            end
            else if temp <> '' then
            begin
                val(temp, valor);
                jugadas.jugadas[jugadas.elementos].numero := valor;
                jugadas.elementos := jugadas.elementos + 1; 
                temp := '';
            end;

            
        end;
    end;

    if entrada[i] in ['0'..'9'] then
    begin
        temp := temp + entrada[i];
        i := i + 1;
    end
    else if entrada[i] in ['a'..'z'] then
    begin
        colorString := colorString + entrada[i];
        i := i + 1;
    end
end;



{Se le va a dar cada linea del archivo de texto, y se va a extraer los valores de cada linea}
procedure faseExtraccionJugadores(var juego: tipoJuego; jugadorIndex: integer; cartonIndex: integer;  filaIndex: integer;  numeroIndex: integer; entrada: string);
var
    i, valor: integer;
    colorString: string;
    color: tipo_color;
    temp: string;

    colorFilaCompleto: boolean;
begin
    temp := '';
    { De Cada linea se extraen los valores de cada linea y a partir de ahí se introduciran valores}
    i := 1;
    {Se extrae color si existe}
    colorString := '';
    colorFilaCompleto := false;

    while (i <= length(entrada)) do
    begin

        if entrada[i] in ['A'..'Z'] then
            exit; {Si hay mayúsculas, se sale de la función}
        
        if entrada[i] = '' then
        begin
            {Se comprueba se hay elementos a añadir a las variables, o colorString o temp}
            if (colorString <> '') and (colorFilaCompleto = false) then
            begin
                if colorString = 'rojo' then
                    color := rojo
                else if colorString = 'verde' then
                    color := verde
                else if colorString = 'azul' then
                    color := azul
                else if colorString = 'amarillo' then
                    color := amarillo
                else
                    exit; {Si no es ninguno de los colores, se sale de la función}  

                {Se asigna el color al jugador}
                juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].color := color;
                colorString := '';
                colorFilaCompleto := true;
            end
            else if temp <> '' then
            begin
                val(temp, valor);
                juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].numeros[numeroIndex] := valor;
                numeroIndex := numeroIndex + 1;
                
                if numeroIndex > 6 then
                begin
                    numeroIndex := 1;
                    filaIndex := filaIndex + 1;
                    colorFilaCompleto := false;
                end;

                temp := '';
            end;
        end;
    end;

        {Puede existir un valor numerico o uno alfabetico en las posiciones, esto quiere decir que hay que comprobar las dos cosas
            Si existe un valor numérico se avanza en el indice de la cadena añadiendolo a temp
            Si existe un valor alfabetico se avanza en el indice de la cadena añadiendo el valor a colorString
            
            cuando llegue el final va a haber un " " que va a ser el final de ese número o color entonces se va a añadir a la variable}

        if entrada[i] in ['0'..'9'] then
        begin
            temp := temp + entrada[i];
            i := i + 1;
       
        end
        else if entrada[i] in ['a'..'z'] then
        begin
            colorString := colorString + entrada[i];
            i := i + 1;
 
        end
end;



procedure faseExtraccionValores(nombreArchivo : string; var juego: tipoJuego; var jugadas: tipoJugadas);
var
    entrada: text;    
    s: string;

    jugadorIndex: integer; { counter jugador --> de 1 a 3}
    cartonIndex: integer; { counter carton --> de 1 a 100}
    filaIndex : integer; { counter fila  --> tienen que ser 3}
    numeroIndex : integer; { counter numero  --> tienen que ser 5}
    {todos estos valores se le iran pasando a faseExtraccionJugadores para saber donde introducirlos}

    finLecturaJugadores: boolean;
    tempLecturaJugadores: integer;

begin
    assign(entrada, nombreArchivo);
    reset(entrada);
    tempLecturaJugadores := 0;
    finLecturaJugadores := false;
    jugadorIndex := 1;
    cartonIndex := 1;
    filaIndex := 1;
    numeroIndex := 1;
    jugadas.elementos := 1;

    while not EOF(entrada) do         
    begin
        readln(entrada,s);

        if finLecturaJugadores = false then
        begin
            if s = 'FIN' then
            begin
                tempLecturaJugadores := tempLecturaJugadores + 1;
                jugadorIndex := jugadorIndex + 1;
                
                {Se reinician los valores si los valores estan en maximo de fila y numero}
                if (filaIndex >= 3) and (numeroIndex > 5) then
                begin
                    cartonIndex := 1;
                    filaIndex := 1;
                    numeroIndex := 0;
                end;

                if tempLecturaJugadores = 3 then
                    finLecturaJugadores := true;
            end
            else    
                faseExtraccionJugadores(juego, jugadorIndex, cartonIndex, filaIndex, numeroIndex, s)
        end
        else
            faseExtraccionJugadasBingo(jugadas, s);   
    end;
    close(entrada);             
end;


procedure imprimirCarton(carton: carton; var carton_string: carton_string);
var
    i, j: integer;
begin
    for i := 1 to 3 do
    begin 
        for j := 1 to 5 do
        begin
            if carton.filas[i].numeros[j] = -1 then
            begin
                carton_string.filas[i].numeros[j] := 'XX';
            end
            else
            begin
                carton_string.filas[i].numeros[j] := '';
                Str(carton.filas[i].numeros[j], carton_string.filas[i].numeros[j]);
            end;
        end;
    end;
end;


procedure imprimirBingo(carton_string: carton_string);
var 
    i, j: integer;
begin
    for i := 1 to 3 do
    begin
        for j := 1 to 5 do
        begin
            write(carton_string.filas[i].numeros[j], 'XX');
        end;
        writeln();
    end;
end;


function comprobarBingo(carton: carton): boolean;
var
    i, j, contador: integer;
    carton_string_def: carton_string;
begin
    contador := 0;
    for i := 1 to 3 do
    begin
        for j := 1 to 5 do
        begin
            if carton.filas[i].numeros[j] = -1 then
                contador := contador + 1;
        end;
    end;

    if contador = 15 then
    begin
        comprobarBingo := true;
        imprimirCarton(carton, carton_string_def);
        imprimirBingo(carton_string_def);
    end
    else
    begin
        comprobarBingo := false;
    end;
end;


procedure tomaJugada(var jugadas: tipoJugadas; var juego: tipoJuego);
var
    i, j, k, m, n: integer;
    color_jugada: tipo_color;
    numero_jugada: integer;

    { variable de los jugadores que han tachado}
    numero_tachado: integer;
    color_jugador: tipo_color;

    carton_string_def: carton_string;

begin
    { Se hace un while recorriendo el array de jugadas, y se va mostrando cada jugada}
    for i := 1 to jugadas.elementos do
    begin
        { Tengo en cada jugada el numero y el color, tengo que ir comprobando si hay valores en los cartones}
        writeln('Jugada: ', jugadas.jugadas[i].numero, ' ', jugadas.jugadas[i].color);
        
        { Se hace un while de las los jugadores , luego de los cartones y dentro de los cartones hacer un bucle de las filas y de los numeros}
        { Se va comprobando si hay valores en los cartones, si hay valores se va tachando y se va comprobando si hay bingo}
        { Si hay bingo se muestra el carton y se muestra como ha ido desde el primer valor tachado hasta el ultimo}
        { Si no hay bingo se muestra los jugadores que han tachado}

        color_jugada := jugadas.jugadas[i].color;
        numero_jugada := jugadas.jugadas[i].numero;

        for j := 1 to 3 do
        begin
            for k := 1 to juego.jugadores[j].numCartones do
            begin
                for m := 1 to 3 do
                begin
                    color_jugador := juego.jugadores[j].cartones[k].filas[m].color;
                    for n := 1 to 5 do
                    begin
                        numero_tachado := juego.jugadores[j].cartones[k].filas[m].numeros[n];
                        if (numero_tachado = numero_jugada) and (color_jugador = color_jugada) then
                        begin 
                            writeln('Jugador ', j, ' ha tachado');
                            if comprobarBingo(juego.jugadores[j].cartones[k]) then
                            begin
                                writeln('Jugador ', j, ' ha hecho bingo');
                                juego.jugadores[j].cartones[k].filas[m].numeros[n] := -1;
                            end;
                        end;
                    end;
                end;
                imprimirCarton(juego.jugadores[j].cartones[k], carton_string_def);
            end;
        end;
    end;
end;



{
  Comienzo de programa en pascal, como principio de programa se lee el fichero
}
var
    nombreArchivo: string = 'datos.txt';
    juego: tipoJuego;
    jugadas: tipoJugadas;
begin
    writeln('Comienzo de programa en pascal');
    faseExtraccionValores(nombreArchivo, juego, jugadas);
    tomaJugada(jugadas, juego);
end.




{
    Despues de haber introducido los valores en el array de jugadores y jugadas, se procede a realizar el juego
}

{
    se tiene que hacer un bucle con todas las jugadas, y con cada jugada se tiene que ir comprobando si hay valores en los cartones
    si hay valores en los cartones se tiene que ir comprobando si hay bingo y escribiendo cada carton de como va quedando
    tiene que ir mostrando en cada jugada los jugadores que han tachado
        Jugador 1: Nada.
        Jugador 2: Nada.
        Jugador 3: Tachado.

    Si hay bingo se tiene que mostrar el carton y como ha ido desde el primer valor tachado hasta el ultimo
        Jugador 1: Bingo.
        Jugador 2: Nada.
        Jugador 3: Nada.    
}
