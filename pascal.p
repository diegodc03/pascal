{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}


program playbingo;


uses crt, sysutils;


const
    MAX_CARTONES = 10;
    MAX_FILAS_CARTON = 3;
    MAX_NUMEROS_FILA = 5;
    MAX_JUGADORES = 3;

    MIN_VALOR_BINGO = 0;
    MAX_VALOR_BINGO = 100;

    MAX_NUM_BINGO = 401;

type
    {estructura jugador}
    tipo_color = (rojo, verde, azul, amarillo);

    fila_carton = record
        color: tipo_color;
        numeros: array[1..MAX_NUMEROS_FILA] of string;
    end;

    carton = record
        filas: array[1..MAX_FILAS_CARTON] of fila_carton;
    end;

    jugador = record
        cartones: array[1..MAX_CARTONES] of carton;
        numCartones: integer;
    end;
    tipoJuego = record
        jugadores: array[1..MAX_JUGADORES] of jugador;
    end;

    {Jugadas}
    lista_jugadas = record
        jugada: string;
        color: tipo_color;
    end;

    jugadas_bingo = record
        lista_jugadas_impl: array[1..MAX_NUM_BINGO] of lista_jugadas;
        numJugadas: integer;
    end;

    {Ganador}
    jugador_ganador = record
        jugador: integer;
        carton: integer;
    end;


procedure imprimirCarton(carton: carton);
var
    i, j: integer;
begin
    for i := 1 to MAX_FILAS_CARTON do
    begin 
        write(carton.filas[i].color, ' -->  ');
        for j := 1 to MAX_NUMEROS_FILA do
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
    for i := 1 to MAX_FILAS_CARTON do
    begin
        for j := 1 to MAX_NUMEROS_FILA do
        begin
            if carton.filas[i].numeros[j] = 'XX' then
                contador := contador + 1;
        end;
    end;

    if contador = 15 then
    begin
        comprobarBingo := true;
    end
    else
    begin
        comprobarBingo := false;
    end;
end;

procedure imprimirJugadores(juego: tipoJuego);
var
    i, j, k, m: integer;
begin
    writeln('');
    writeln('Imprimiendo los jugadores con sus cartones');

    for i := 1 to MAX_JUGADORES do
    begin
        writeln('Jugador ', i);
        for j := 1 to juego.jugadores[i].numCartones do
        begin
            for k := 1 to MAX_FILAS_CARTON do
            begin
                write(juego.jugadores[i].cartones[j].filas[k].color, ' -->  ');
                
                for m := 1 to MAX_NUMEROS_FILA do
                begin
                    write(juego.jugadores[i].cartones[j].filas[k].numeros[m], ' ');
                end;
                writeln();
            end;
            writeln();
        end;
    end;
end;

procedure mostrar_Jugadas_bingo_ganadoras(jugadas: jugadas_bingo; carton_ganador: carton);
var
    i, j, k: integer;
begin
    writeln('Jugadas ganadoras:');
    writeln('Numero de jugadas que han sido necesarias para encontrar un ganador: ', jugadas.numJugadas); 
    carton_ganador_dev := carton_ganador;
    for i := 1 to jugadas.numJugadas do
    begin
        carton_ganador_dev.
        for j := 1 to MAX_FILAS_CARTON do
        begin
            for k := 1 to MAX_NUMEROS_FILA do
            begin
                if (jugadas.lista_jugadas_impl[i].jugada = carton_ganador.filas[j].numeros[k]) and
                   (jugadas.lista_jugadas_impl[i].color = carton_ganador.filas[j].color) then
                begin
                    writeln('Jugada: ', jugadas.lista_jugadas_impl[i].jugada, ' ', jugadas.lista_jugadas_impl[i].color);
                    carton_ganador.filas[j].numeros[k] := 'XX';
                    imprimirCarton(carton_ganador);
                    writeln('');
                end;
            end;
        end;
        
    end;
end;

function comprobarNumeros(var juego: tipoJuego; jugadorIndex: integer; cartonIndex: integer; numero: string): boolean;
var 
    filaIndex, numeroIndex, num: integer;
    comprobacionNumero: boolean;
begin    
    comprobacionNumero := false;
    comprobarNumeros := false;

    Val(numero, num);
    if (num >= MAX_VALOR_BINGO) or (num < MIN_VALOR_BINGO) then
    begin
        comprobacionNumero := true;
        writeln('Numero fuera de rango, tienen que estar todos entre 0 y 99 inclusive');
    end
    else
    begin
        for filaIndex := 1 to MAX_FILAS_CARTON do
        begin
            for numeroIndex := 1 to MAX_NUMEROS_FILA do
            begin
                if juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].numeros[numeroIndex] = numero then
                begin
                    comprobacionNumero := true;
                    writeln('Numero repetido en el carton');
                    break;
                end;
            end;
        end;
    end;
    if comprobacionNumero = true then
    begin
        comprobarNumeros := true;
    end;
end;

procedure imprimir_carton_txt(var fichero: text; carton: carton);
var
    i, j: integer;
begin
    for i := 1 to MAX_FILAS_CARTON do
    begin 
        write(fichero, carton.filas[i].color, ' -->  ');
        for j := 1 to MAX_NUMEROS_FILA do
        begin
            write(fichero, carton.filas[i].numeros[j], ' ');
        end;
        writeln(fichero);
    end;
end;

function faseExtraccionJugadores(var juego: tipoJuego; var jugadorIndex: integer; var cartonIndex: integer; var filaIndex: integer; var numeroIndex: integer; entrada: string):boolean;
var
    i: integer;
    colorString: string;
    color: tipo_color;
    temp: string;
    colorFilaCompleto: boolean;
    error_jugador: boolean;
begin
    error_jugador := false;
    temp := '';
    colorString := '';
    colorFilaCompleto := false;
    faseExtraccionJugadores := true;

    for i := 1 to length(entrada) do
    begin
        if entrada[i] in ['A'..'Z'] then
        begin
            error_jugador := true;
            break;
        end;
        
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
                begin
                    writeln('Color no valido');
                    error_jugador := true;
                    break;
                end;
                
                juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].color := color;
                colorString := '';
                colorFilaCompleto := true;
            end
            else if temp <> '' then
            begin
                
                if comprobarNumeros(juego, jugadorIndex, cartonIndex, temp) then
                begin
                    error_jugador := true;
                    break;
                end;
         
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

                if comprobarNumeros(juego, jugadorIndex, cartonIndex, temp) then
                begin
                    error_jugador := true;
                    break;
                end;

                juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].numeros[numeroIndex] := temp;
                numeroIndex := numeroIndex + 1;
            
                if numeroIndex > MAX_NUMEROS_FILA then
                begin
                    numeroIndex := 1;
                    colorFilaCompleto := false;

                    if filaIndex = MAX_FILAS_CARTON then
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

    if error_jugador = true then
    begin
        faseExtraccionJugadores := false;
    end;
end;

function faseExtraccionValores(nombreArchivo : string; var juego: tipoJuego): boolean;
var
    entrada: text;    
    s: string;

    jugadorIndex: integer; 
    cartonIndex: integer; 
    filaIndex : integer; 
    numeroIndex : integer; 

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
    faseExtraccionValores := true;
    while not EOF(entrada) do         
    begin
        readln(entrada,s);
        if finLecturaJugadores = false then
        begin
            if s = 'FIN' then
            begin
                if tempLecturaJugadores < MAX_JUGADORES then
                begin
                    tempLecturaJugadores := tempLecturaJugadores + 1;
                end;
                
                jugadorIndex := jugadorIndex + 1;
                cartonIndex := 1;
                filaIndex := 1;
                numeroIndex := 1;

                if tempLecturaJugadores = MAX_JUGADORES then
                    finLecturaJugadores := true;
            end
            else    
            begin
                if not faseExtraccionJugadores(juego, jugadorIndex, cartonIndex, filaIndex, numeroIndex, s) then
                begin
                    faseExtraccionValores := false;
                    exit;
                end;
            end;
        end;
    end;
    close(entrada);             
end;

function esJugadaUnica(jugadas: jugadas_bingo; numero: string; color: tipo_color): boolean;
var
    y: integer;
begin
    for y := 1 to jugadas.numJugadas do
    begin
        if (jugadas.lista_jugadas_impl[y].jugada = numero) and 
           (jugadas.lista_jugadas_impl[y].color = color) then
        begin
            esJugadaUnica := false;
            exit;
        end;
    end;
    esJugadaUnica := true; 
end;

procedure tomaJugada(var juego: tipoJuego; var jugador_ganador_bingo: jugador_ganador; var jugadas_bingo_impl: jugadas_bingo);
var
    j, k, m, n: integer;

    {Variables random}
    numero_jugada: string;
    numero_jugada_num: integer;
    color_jugada: tipo_color;

    {Variables de los jugadores}
    color_jugador: tipo_color;
    numero_jugador: string;

    bingo_jugador: boolean;
begin
    Randomize;

    jugadas_bingo_impl.numJugadas := 0;
    bingo_jugador := false;

    while bingo_jugador = false do
    begin
        repeat
            numero_jugada_num := Random(MAX_VALOR_BINGO);
            Str(numero_jugada_num, numero_jugada);
            color_jugada := tipo_color(Random(Ord(High(tipo_color)) + 1));
        until esJugadaUnica(jugadas_bingo_impl, numero_jugada, color_jugada);

        jugadas_bingo_impl.numJugadas := jugadas_bingo_impl.numJugadas + 1;
        jugadas_bingo_impl.lista_jugadas_impl[jugadas_bingo_impl.numJugadas].jugada := numero_jugada;
        jugadas_bingo_impl.lista_jugadas_impl[jugadas_bingo_impl.numJugadas].color := color_jugada;

        writeln('');
        writeln('');
        writeln('');
        writeln('Jugada: ', numero_jugada, ' ', color_jugada);
        writeln('');
        for j := 1 to MAX_JUGADORES do
        begin
            writeln('');
            writeln('Jugador ', j);
            for k := 1 to juego.jugadores[j].numCartones do
            begin

                for m := 1 to MAX_FILAS_CARTON do
                begin
                    color_jugador := juego.jugadores[j].cartones[k].filas[m].color;
                    for n := 1 to MAX_NUMEROS_FILA do
                    begin
                        numero_jugador := juego.jugadores[j].cartones[k].filas[m].numeros[n];
                        
                        if (numero_jugador = numero_jugada) and (color_jugador = color_jugada) then
                        begin 
                            writeln('Jugador ', j, ' ha tachado');
                            juego.jugadores[j].cartones[k].filas[m].numeros[n] := 'XX';
                            if comprobarBingo(juego.jugadores[j].cartones[k]) then
                            begin
                                writeln('Jugador ', j, ' ha hecho bingo con carton ', k);
                                jugador_ganador_bingo.jugador := j;
                                jugador_ganador_bingo.carton := k;
                                bingo_jugador := true;
                            end;
                        end;
                    end;
                end;
                imprimirCarton(juego.jugadores[j].cartones[k]);
            end;
        end;
    end;
end;

{
  Comienzo de programa en pascal, como principio de programa se lee el fichero
}
var
    nombreArchivo: string = 'datos.txt';
    juego_inicio: tipoJuego;
    juego: tipoJuego;
    jugador_ganador_bingo: jugador_ganador;
    jugadas_bingo_impl: jugadas_bingo;

    carton_ganador: carton;
begin
    writeln('Comienzo de programa en pascal');

    if faseExtraccionValores(nombreArchivo, juego) = false then
    begin
        exit;
    end;    
    juego_inicio := juego;

    writeln('Juego duplicado');
    imprimirJugadores(juego_inicio);

    writeln('Juego original');
    imprimirJugadores(juego);

    tomaJugada(juego, jugador_ganador_bingo, jugadas_bingo_impl);

    writeln('');
    writeln('');
    writeln('');
    writeln('');
    writeln('');
    writeln('');

    writeln('Jugador ganador: ', jugador_ganador_bingo.jugador, ' con carton ', jugador_ganador_bingo.carton);
    writeln('Se va a mostrar el carton ganador y todas las jugadas que le han hecho ser ganador');
    mostrar_Jugadas_bingo_ganadoras(jugadas_bingo_impl, juego_inicio.jugadores[jugador_ganador_bingo.jugador].cartones[jugador_ganador_bingo.carton], carton_ganador);

{    introducir_jugada_ganadora_txt(jugadas_bingo_impl, juego_inicio.jugadores[jugador_ganador_bingo.jugador].cartones[jugador_ganador_bingo.carton]);}
end.

