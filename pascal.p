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
        jugadores: array[1..3] of string;






procedure faseExtraccionValores(nombreArchivo : string);
var
    entrada: text;
    s: string;
begin
    assign(entrada, nombreArchivo);
    reset(entrada);
    while not EOF(entrada) do         { read it until it's done }
    begin
        readln(entrada,s);
        writeln(s);
    end;
    close(entrada);                   { close it }
end;

{
  Comienzo de programa en pascal, como principio de programa se lee el fichero
}
var
    nombreArchivo: string = 'datos.txt';
    personajes: integer = 3;
begin
    writeln('Comienzo de programa en pascal');
    faseExtraccionValores(nombreArchivo);
end.



