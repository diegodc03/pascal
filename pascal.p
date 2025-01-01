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
    end;
    tipoJuego = record
        jugadores: array[1..3] of jugador;
    end;

{Se le va a dar cada linea del archivo de texto, y se va a extraer los valores de cada linea}
procedure faseExtraccionJugadores(var juego: tipoJuego; jugadorIndex: integer; cartonIndex: integer;  filaIndex: integer;  numeroIndex: integer; entrada: string);
var
    i, valor: integer;
    colorString: string;
    color: tipo_color;
    temp: string;
begin
    { De Cada linea se extraen los valores de cada linea y a partir de ahí se introduciran valores}
    i := 1;
    {Se extrae color si existe}
    colorString := '';

    if (juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].color = ninguno) and (numeroIndex = 1) then
    begin 

        while (i <= length(entrada)) and (entrada[i] in ['a'..'z', 'A'..'Z']) do
        begin
            if(entrada[i] in ['A'..'Z']) then
                exit; {Si hay mayúsculas, se sale de la función}
            
            colorString := colorString + entrada[i];
            i := i + 1;
        end;

        {Si ha ido todo correcto y no ha habiado mayúsculas, se convierte a tipo_color}
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
    end;

    {Se extraen los números que haya en esa linea}
    temp := ''; 
    while (i <= length(entrada)) do
    begin
        if entrada[i] in ['0'..'9'] then
        begin
            temp := temp + entrada[i];
            i := i + 1;
        end
        else
        begin
            val(temp, valor);
            juego.jugadores[jugadorIndex].cartones[cartonIndex].filas[filaIndex].numeros[numeroIndex] := valor;
            numeroIndex := numeroIndex + 1;
            if numeroIndex > 5 then
                exit;
            temp := '';
        end;
    end;

    {Se comprueba los valores de los indices para ver si se han pasado,
    si se han pasado se devuelve error por que se han pasado mal datos.txt}
    if (filaIndex > 3) or (cartonIndex > 100) or (jugadorIndex > 3) then
        exit;
     
end;


procedure faseExtraccionValores(nombreArchivo : string; var juego: tipoJuego);
var
    entrada: text;    
    s: string;

    jugadorIndex: integer; { counter jugador --> de 1 a 3}
    cartonIndex: integer; { counter carton --> de 1 a 100}
    filaIndex : integer; { counter fila  --> tienen que ser 3}
    numeroIndex : integer; { counter numero  --> tienen que ser 5}
    {todos estos valores se le iran pasando a faseExtraccionJugadores para saber donde introducirlos}

begin
    assign(entrada, nombreArchivo);
    reset(entrada);

    jugadorIndex := 1;
    cartonIndex := 1;
    filaIndex := 1;
    numeroIndex := 0;

    while not EOF(entrada) do         
    begin
        readln(entrada,s);

        if s = 'FIN' then
        begin
            jugadorIndex := jugadorIndex + 1;
            if (jugadorIndex > 3) or (cartonIndex > 100) or (filaIndex > 3) or (numeroIndex > 5) then
                exit;
            
            {Se reinician los valores si los valores estan en maximo de fila y numero}
            if (filaIndex = 3) and (numeroIndex = 5) then
            begin
                cartonIndex := 1;
                filaIndex := 1;
                numeroIndex := 0;
            end;
            
        end
        else    
            faseExtraccionJugadores(juego, jugadorIndex, cartonIndex, filaIndex, numeroIndex, s)
    end;
    close(entrada);             
end;

{
  Comienzo de programa en pascal, como principio de programa se lee el fichero
}
var
    nombreArchivo: string = 'datos.txt';
    juego: tipoJuego;
begin
    writeln('Comienzo de programa en pascal');
    faseExtraccionValores(nombreArchivo, juego);
end.



