{
 Una empresa posee un archivo con información de los ingresos percibidos por diferentes
 empleados en concepto de comisión, de cada uno de ellos se conoce:
  * código de empleado,
  * nombre y
  * monto de la comisión.
 La información del archivo se encuentra ordenada por código de empleado y cada empleado
 puede aparecer más de una vez en el archivo de comisiones.

 Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte.
 En consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
 única vez con el valor total de sus comisiones.

 NOTA: No se conoce a priori la cantidad de empleados.
       Además, el archivo debe ser recorrido una única vez.
}
program TP02_Ej01;

uses crt,sysutils;

type
  rEmp = record      //Registro empleado
    cod : integer;       // codigo empleado
    nom : string[19];    // nombre del empleado
    com : real;          // comision que corresponde
    end;
  fEmp = file of rEmp; // Archivo con registros empleados
{$i ext.prc} // lib secundaria estilos y func extendidas

//////////////////////////// Compactar Datos \\\\\\\\\\\\\\\\\\\\\\\\\\\\\
procedure compactar(var emp,res:fEmp);
var
  aux,e:rEmp;
begin
  rewrite(res);
  reset(emp);
  read(emp,e);
  while (NOT EOF(emp))do begin
    aux.cod:= e.cod;
    aux.nom:= e.nom;
    aux.com:= e.com;
    while (NOT EOF(emp))and(aux.cod = e.cod) do begin
      read(emp,e);
      aux.com:= aux.com + e.com;
      end;
    write(res,aux);
    end;
  close(emp);
  close(res);
end;
////////////////////////////// VER  DATOS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
procedure verDatos (var a:fEmp);
var
  e:rEmp;
begin
  reset(a);
  while (NOT EOF (a))do begin
    read(a,e);
    writeln('Codigo: ',e.cod,' | Empleado: ',e.nom,' | Comision: $',e.com:4:2);
    end;
  writeln('------------------------------------------------------------------');
end;
////////////////////////////// MENU INTERACTIVO \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
procedure menu (var emp,res:fEmp);
var opcion:char;
begin
  repeat
    clrscr;
    writeln(' ############# MENU OPCIONES ##############');
    writeln(' #                                        #');
    writeln(' # a.- Ver archivo empleados original.    #');
    writeln(' #                                        #');
    writeln(' # b.- Ver archivo empleados compactado.  #');
    writeln(' #                                        #');
    writeln(' # f o F.- PARA FINALIZAR...              #');
    writeln(' #                                        #');
    writeln(' ##########################################');
    write(' Ingrese opcion: '); readln(opcion);
    case opcion of
      'a': begin
             writeln();
             writeln('---------------------- DATOS ORIGINALES -----------------------');
             writeln();
             verDatos(emp);
             write('Presione una tecla para continuar...'); readkey();
           end;
      'b': begin
             writeln();
             writeln('--------------------- DATOS COMPACTADOS -----------------------');
             writeln();
             verDatos(res);
             write('Presione una tecla para continuar...'); readkey();
           end;
      else begin
             if ((opcion <> 'f')and(opcion <> 'F'))then begin
               writeln('ERROR!!! - OPCION NO VALIDA...');
               delay(500);
               end;
           end;
      end;
  until ((opcion = 'f')or(opcion='F'));
end;

////////////////////////// PROGRAMA PRINCIPAL \\\\\\\\\\\\\\\\\\\\\\\\\\\\\
VAR
  empleados,compactado:fEmp;
BEGIN
  Assign(empleados,'Empleados.bin');
  Assign(compactado,'Compactado.bin');
  obtenerDatos(empleados);
  compactar(empleados,compactado);
  menu(empleados,compactado);
END.
