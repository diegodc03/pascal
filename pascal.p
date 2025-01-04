{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}


program playbingo;


uses crt, sysutils;


const
    MaxCartones = 10;

type
    { Tipo de dato que representa un jugador necesito 3 jugadores array de 3, pero eso va a ser tipo de dato juego
    a su vez, cada jugador tiene un array de cartones, y cada carton tiene un array de filas, y cada fila tiene un array de numeros
    }
    tipo_color = (rojo, verde, azul, amarillo);

    fila_carton = record
        color: tipo_color;
        numeros: array[1..5] of string;
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


procedure imprimirCarton(carton: carton);
var
    i, j: integer;
begin
    for i := 1 to 3 do
    begin 
        for j := 1 to 5 do
        begin
            write(carton.filas[i].numeros[j], ' ');
        end;
        writeln();
    end;
end;





function comprobarBingo(carton: carton): boolean;
var
    i, j, contador: integer;
begin
    contador := 0;
    for i := 1 to 3 do
    begin
        for j := 1 to 5 do
        begin
            if carton.filas[i].numeros[j] = 'XX' then
                contador := contador + 1;
        end;
    end;

    if contador = 15 then
    begin
        comprobarBingo := true;
        imprimirCarton(carton);
    end
    else
    begin
        comprobarBingo := false;
    end;
end;






{Se le va a dar cada linea del archivo de texto, y se va a extraer los valores de cada linea}
procedure faseExtraccionJugadores(var juego: tipoJuego; var jugadorIndex: integer; var cartonIndex: integer; var filaIndex: integer; var numeroIndex: integer; entrada: string);
var
    i: integer;
    colorString: string;
    color: tipo_color;
    temp: string;
    colorFilaCompleto: boolean;

begin

    temp := '';
    colorString := '';
    colorFilaCompleto := false;

    for i := 1 to length(entrada) do
    begin
        if entrada[i] in ['A'..'Z'] then
            exit;
        
        if (entrada[i] = ' ') then
        begin
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
                    exit; 

                juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].color := color;
                colorString := '';
                colorFilaCompleto := true;
            end
            else if temp <> '' then
            begin
         
                juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].numeros[numeroIndex] := temp;
                numeroIndex := numeroIndex + 1;
                temp := '';
            end;
        end
        else if entrada[i] in ['0'..'9'] then
        begin
            temp := temp + entrada[i];

            if i = length(entrada) then
            begin
                juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].numeros[numeroIndex] := temp;
                numeroIndex := numeroIndex + 1;
            
                if numeroIndex > 5 then
                begin
                    numeroIndex := 1;
                    colorFilaCompleto := false;

                    if filaIndex = 3 then
                    begin
                        cartonIndex := cartonIndex + 1;
                        juego.jugadores[jugadorIndex].numCartones := juego.jugadores[jugadorIndex].numCartones + 1;
                        filaIndex := 1;
                        colorFilaCompleto := false;
                    end
                    else
                    begin
                        filaIndex := filaIndex + 1;
                    end;

                end;
            end;

        end
        else if entrada[i] in ['a'..'z'] then
        begin
            colorString := colorString + entrada[i];
        end
    end;
end;



procedure faseExtraccionValores(nombreArchivo : string; var juego: tipoJuego; var jugadas: tipoJugadas);
var
    entrada: text;    
    s: string;

    jugadorIndex: integer; { counter jugador --> de 1 a 3}
    cartonIndex: integer; { counter carton --> de 1 a 100}
    filaIndex : integer; { counter fila  --> tienen que ser 3}
    numeroIndex : integer; { counter numero  --> tienen que ser 5}

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
                if tempLecturaJugadores < 3 then
                begin
                    tempLecturaJugadores := tempLecturaJugadores + 1;
                end;
                

                jugadorIndex := jugadorIndex + 1;
                cartonIndex := 1;
                filaIndex := 1;
                numeroIndex := 1;

                if tempLecturaJugadores = 3 then
                    finLecturaJugadores := true;
             
            end
            else    
                faseExtraccionJugadores(juego, jugadorIndex, cartonIndex, filaIndex, numeroIndex, s);
        end
        else
            {faseExtraccionJugadasBingo(jugadas, s);   }
    end;
    close(entrada);             
end;


procedure tomaJugada(var jugadas: tipoJugadas; var juego: tipoJuego);
var
    i, j, k, m, n: integer;

    {Variables random}
    numero_jugada: string;
    numero_jugada_num: integer;
    color_jugada: tipo_color;

    { variable de los jugadores que han tachado}
    color_jugador: tipo_color;
    numero_jugador: string;

begin
    Randomize;
    
    for i := 1 to 10 do
    begin
        
        numero_jugada_num := Random(100);
        Str(numero_jugada_num, numero_jugada);

        color_jugada := tipo_color(Random(Ord(High(tipo_color)) + 1));
        writeln('');
        writeln('');
        writeln('');
        writeln('Jugada: ', numero_jugada, ' ', color_jugada);
        writeln('');
        for j := 1 to 3 do
        begin
            writeln('');
            writeln('Jugador ', j);
            for k := 1 to juego.jugadores[j].numCartones do
            begin
                writeln('');

                for m := 1 to 3 do
                begin
                    color_jugador := juego.jugadores[j].cartones[k].filas[m].color;
                    for n := 1 to 5 do
                    begin
                        numero_jugador := juego.jugadores[j].cartones[k].filas[m].numeros[n];
                        
                        if (numero_jugador = numero_jugada) and (color_jugador = color_jugada) then
                        begin 
                            writeln('Jugador ', j, ' ha tachado');
                            if comprobarBingo(juego.jugadores[j].cartones[k]) then
                            begin
                                writeln('Jugador ', j, ' ha hecho bingo');
                                juego.jugadores[j].cartones[k].filas[m].numeros[n] := 'XX';
                            end;
                        end;
                    end;
                end;
                imprimirCarton(juego.jugadores[j].cartones[k]);
            end;
        end;
    end;
end;



procedure imprimirJugadores(juego: tipoJuego);
var
    i, j, k, m: integer;
begin
    writeln('');
    writeln('Imprimiendo los jugadores con sus cartones');

    for i := 1 to 3 do
    begin
        writeln('Jugador ', i);
        for j := 1 to juego.jugadores[i].numCartones do
        begin
            for k := 1 to 3 do
            begin
                write(juego.jugadores[i].cartones[j].filas[k].color, ' -->  ');
                
                for m := 1 to 5 do
                begin
                    write(juego.jugadores[i].cartones[j].filas[k].numeros[m], ' ');
                end;
                writeln();
            end;
            writeln();
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
    imprimirJugadores(juego);
    tomaJugada(jugadas, juego);
end.

