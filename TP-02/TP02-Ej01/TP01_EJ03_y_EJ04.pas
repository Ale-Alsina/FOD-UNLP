program TP01_EJ03_y_EJ04;
uses crt,sysutils;
const
  FIN= 'fin';
//#tipo de datos a usar
type
  rEmp=  record
    nro : integer;
    nom:  string[25];
    ape:  string[25];
    eda:  integer;
    dni:  longword;
    end;

  aEmp = file of rEmp;

procedure completar (var x:string);
var i,pos:integer;
begin
  pos:=length(x);
  for i:= pos+1 to 25 do
    x[i]:=' ';
  x[0]:=chr(25);
end;

//==================== PUNTO A carga en el archivo ===========================
procedure leerEmp (var e:rEmp);
begin
  with e do begin
    write('Ingrese Apellido del empleado: ');  readln(ape);
    if ( ape <> FIN )then begin
        write('ingrese su "Nombre": '); readln(nom);
        write('ingrese su "Edad":');    readln(eda);
        write('ingrese su "DNI": ');    readln(dni);
      end;
  end;
end;
procedure crearArchivo_teclado (var archivo: aEmp);
var emp:rEmp;
begin
  rewrite(archivo);
  leerEmp(emp);
  while ( emp.ape <> FIN )do begin
    write(archivo,emp);
    leerEmp(emp);
    end;
end;
// carga c/datos de un txt
procedure crearArchivo_cDatos(var archivo:aEmp);
var data:text; x:char;  e:rEmp; doc:string[8]; edad:string[2]; n:integer;
begin
  assign(data,'Datos.txt'); reset(data);// Asignar y abrir el txt c/datos
  n:=0;
  while NOT EOF(data)do begin
    with e do begin
      readln(data,nom,ape,doc,x,edad);
      dni:=strToInt(doc);  eda:=strToInt(edad);
      n:=n+1; nro:=n;
      write(archivo,e);
    end;
  end;
  close(data);// Cerrar el txt c/datos
end;
procedure crearArchivo(var archivo:aEmp);
var nomArchivo:string;
begin
  write('Ingrese nombre de archivo binario de Empleados a crear: ');  readln(nomArchivo);
  assign(archivo,nomArchivo);
  rewrite(archivo);

  close(archivo);
end;
//==================== PUNTO B carga en el archivo ===========================
//i-)Listar en pantalla los datos de emp q tengan un nom o ape determinado
procedure buscar_y_listar_NomApe (var archivo:aEmp);
var x:string; e:rEmp;
begin
  reset(archivo);
  writeln('Ingrese nombre o apellido a buscar: '); readln(x);
  while NOT EOF(archivo)do begin
    read(archivo,e);
    if (pos(x,e.nom)>0) or (pos(x,e.ape)>0)then
      writeln('Cod: ',e.nro,' | Nom y Ap:',e.nom,' ',e.ape,' | Edad: ',e.eda,' a',Utf8ToAnsi('ñ'),'os | DNI: ',e.dni);
    end;
  close(archivo);
end;

//ii-) Listar en pantalla los empleados de a uno por línea.
procedure Listar(var arc: aEmp);
var e:rEmp;
begin
   reset(arc);
   while (not eof(arc)) do begin
     read(arc,e);
     writeln('Cod: ',e.nro,' | Nom y Ap:',e.nom,' ',e.ape,' | Edad: ',e.eda,' a',Utf8ToAnsi('ñ'),'os | DNI: ',e.dni);
     end;
   close(arc);
end;

//iii-.) Listar en pantalla empleados mayores de 70 años, próximos a jubilarse
procedure listar_meyor70(var archivo:aEmp);
var e:rEmp;
begin
  reset(archivo);
  writeln('<--------------------Proximos a junilarse---------------------------->');
  while NOT EOF(archivo)do begin
    read(archivo,e);
    if (e.eda >70)then
      writeln('Cod: ',e.nro,' | Nom y Ap:',e.nom,' ',e.ape,' | Edad: ',e.eda,' a',Utf8ToAnsi('ñ'),'os | DNI: ',e.dni);
    end;
  close(archivo);
end;

//################################### TP 04 ###################################
procedure Opciones(var x:char);
begin
  repeat
   clrscr;
   writeln(' ####################### MENU OPCIONES ############################');
   writeln(' #                                                                #');
   writeln(' # 0 Crear archivo binario Empleados (manual - c/datos de txt.)   #');
   writeln(' #                                                                #');
   writeln(' # 1 Listar en pant datos d/emp q tengan un nom o ape determinado #');
   writeln(' #                                                                #');
   writeln(' # 2 Listar en pantalla los empleados de a uno por linea.         #');
   writeln(' #                                                                #');
   writeln(' # 3 Listar en pant emp mayores de 70 a',Utf8ToAnsi('ñ'),'os, proximos a jubilarse. #');
   writeln(' #                                                                #');
   writeln(' # a. A',Utf8ToAnsi('ñ'),'adir 1 o mas emp al final de arch c/datos ing x teclado.  #');
   writeln(' #                                                                #');
   writeln(' # b. Modificar edad a una o mas empleados.                       #');
   writeln(' #                                                                #');
   writeln(' # c Exp el archivo a un arch txt llamado "todos_empleados.txt".  #');
   writeln(' #                                                                #');
   writeln(' # d Exp a txt llamado: "faltaDNIEmpleado.txt", emp s/DNI.        #');
   writeln(' #                                                                #');
   writeln(' # f. Finalizar ->...                                             #');
   writeln(' #                                                                #');
   writeln(' ##################################################################');
   writeln('');
   write(' Ingrese una opcion: '); readln(x);
   if((x<>'1')and(x<>'2')and(x<>'3')and(x<>'a')and(x<>'b')
              and(x<>'c')and(x<>'d')and(x<>'f')and(x<>'0')) then  begin
     writeln('-------------------------------');
     writeln('- ERROR! - Opcion invalida... -');
     writeln('-------------------------------');
     delay(1000);
     end;
   until (x='0')or(x='1')or(x='2')or(x='3')or(x='a')or(x='b')or(x='c')or(x='d')or(x='f');
   writeln('-------------------------------');
end;
procedure menu (var archivo:aEmp);
var x:char;
begin
  repeat
    Opciones(x);
    case x of
      '0': begin
            crearArchivo_cDatos(archivo);
           end;
      '1': begin
            buscar_y_listar_NomApe(archivo);
           end;
      '2': begin
            listar(archivo);
           end;
      '3': begin
            listar_meyor70(archivo);
           end;
      'a': begin

           end;
      'b': begin

           end;
      'c': begin

           end;

    end;
  until (x='f');
end;

VAR
  archivo : aEmp; x:char;
BEGIN

  writeln(x);
END.
