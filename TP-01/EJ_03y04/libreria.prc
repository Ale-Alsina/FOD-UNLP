// ########################################## MENU ############################################## \\
  rMenu = record
    a,b,c,d,e,f,g,h:string;  //8 cadenas descriptivas en opciones (max cant de opciones)
    ini,fin: string;         // titulo ventana y texto de finalizacion
    end;

procedure menuOpciones(var op:char; m:rMenu; tot:integer);
  procedure imprimeOpcion (str:string; n,max:integer);
  var aux,x:integer;
  begin
    aux:=length(str);
    write('# ',n,'- ',str,'.');
    for x:= aux to max do write(' ');
    writeln('#');
  end;
  function selOption(m:rMenu; sel:integer):string;
  var str:string;
  begin
    case sel of
      1:begin str:=m.a; end;      2:begin str:=m.b; end;      3:begin str:=m.c; end;
      4:begin str:=m.d; end;      5:begin str:=m.e; end;      6:begin str:=m.f; end;
      7:begin str:=m.g; end;      8:begin str:=m.h; end;
    end;
    selOption:=str;
  end;
var max,aux,opcion,x:integer;
begin
  clrscr;  writeln(''); max:=0;
  // busqueda de cadena mas larga para crear ventana -> max sera el string mas grande
  x:=length(m.ini);
  if (x > max)then max:=x;
  for opcion:= 1 to 8 do begin
    x:=length(selOption(m,opcion));
    if (x > max) then max:=x;
    end;

  // titulo de la ventana
  aux:=((max-length(m.ini)) div 2)+3; write(' ');
  for x:=1 to aux do write('#');      write(' ',m.ini,' ');
  for x:=1 to aux do write('#');      writeln();
  write(' ');  write('#');   for x:=1 to max+6 do write(' ');   writeln('#');

  //opciones dentro de la ventana
  for opcion:= 1 to tot do begin
    write(' ');
    imprimeOpcion(selOption(m,opcion),opcion,max);
    write(' #');   for x:=1 to max+6 do write(' ');   writeln('#');
    end;

  // opcion fin,cierre y continua
  aux:=((max-length(m.fin)) div 2)+3;
  write(' # =>',m.fin);
  for x:= 1 to aux-1 do write(' ');  writeln('#');
  write(' #');   for x:=1 to max+6 do write(' ');   writeln('#');

  // cierre ventana
  write(' ');   for x:=1 to max+8 do write('#');

  writeln();  writeln();
  write  ('Ingrese opcion: ');      readln(op);
end;
// ######################################## FIN MENU ############################################ \\

// validar que este abierto el archivo binario con datos sino opcion a abrirlo-> devuelve booleano
function validaEnlace(var archivo:aEmp):boolean;
  //retorna boolean F-> hubo fallo,V->si abrio sin error, existe y debe cerrarlo
  var ok:boolean;
  begin
    {$I-} reset(archivo); {$I+}//Bloqueo errores,-intento apertura,-desb errores
    ok:=(ioResult = 0); // mantener res apertura - si existio error, no debe cerrar nada
    if ok then close(archivo);//~V->(valido,existio arch y debe cerrarse)
    validaEnlace:= ok ; //retornar ~error (F->si los hay, V-> si esta ok)
  end;

function consultaAbrirArchivo(var archivo:aEmp):boolean;
var nomArchivo: string; ok:boolean; op:char;
begin
  ok:=false;
  writeln('ERROR! - No existe archivo binario con datos asignados');
  repeat
    write('Desea cargar archivo binario con datos para trabajar?. Si(s)/No(n): '); readln(op);
    if(op='s')or(op='S')then begin
      write('Ingrese nombre de archivo para abrir: '); readln(nomArchivo);
      assign(archivo,nomArchivo);
      ok:=validaEnlace(archivo);// verificar si existe archivo
      if NOT(ok)then begin
        writeln('???????????????????????????????????????????????????????????????????????????');
        writeln('Error en apertura del archivo. NO EXISTE! Bin "',nomArchivo,'" en el dir...');
        writeln('???????????????????????????????????????????????????????????????????????????');
        writeln();
        end;
      end;
  until (op = 'n')or(op = 'N')or(ok);
  consultaAbrirArchivo:=ok;
end;

// < procedimiento string del campo - compos de tamaño fijo sin espacios >
function eliminaBlancos (str:string; long:integer):string;
var lng,res:integer;
begin
  lng:=1; res:=1;
  while (lng < long)do begin
    if (str[lng] = ' ') and (str[lng+1]=' ')then
      str[lng]:=str[lng+1]  // ponge en actual el siguiente sin sumar res(long resultante cadena final)
      else res:=res+1;
    lng:=lng+1;
    end;
  if (str[lng] = ' ')then res:=res-1;//ult car del str si es bco debo eliminarlo(puede q este completo)
  str[0]:= chr(res);                 //le pasa al string la longitud real
  eliminaBlancos:=str                //devolver nuevo string sin espacios blancos demas
end;

// carga c/datos de un txt
procedure crearArchivo_cDatos(var archivo:aEmp);
type
   rTxt = record    //Obtendra un registro en el txt respetando tamaños de campos
    nom:string[25]; //Sera un campo con 25 car MAX para Nombre
    ape:string[25]; //Sera un campo con 25 car MAX para Apellido
    doc:string[8];  //contendra 8 digitos para el DNI
    edad:string[2]; //contendra 2 digitos para la edad
    bco:char        //Descartar espacios entre campos
    end;
var data:text; e:rEmp; x:rTxt;  n:integer;
begin
  assign(data,'Datos.txt');  reset(data);// Asignar y abrir el txt c/datos
  n:=0;
  while NOT EOF(data)do begin
    with e do begin
      n:=n+1; nro:=n;                             //Asignacion auto del cod empleado
      readln(data,x.ape,x.nom,x.doc,x.bco,x.edad);//Del txt toma 1linea=1reg:Ape,Nom,DNI,espacio,edad
      dni:=strToInt(x.doc);                       //Parseo Cpo DNI ->  string[8] a longword 8 dig
      eda:=strToInt(x.edad);                      //Parseo Cpo edad -> string[2] a entero  2 dig
      nom:=eliminaBlancos(x.nom,25);              //Parseo Cpo nom ->Quitar espacios demas al final
      ape:=eliminaBlancos(x.ape,25);              //Parseo Cpo ape ->Quitar espacios demas al final
      write(archivo,e);                           //Escribir en el binario emp el registro c/datos
    end;
  end;
  close(data);// Cerrar el txt c/datos
end;

