{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}


program playbingo;


uses crt, sysutils;


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



