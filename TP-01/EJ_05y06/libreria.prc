// ######################## REGISTROS EN FORMATO TXT (STRINGS) ################################# \\
  rTxt = record        //Reg temp para el parseo de valores de los datos del txt
    cod: string[4];    //código de celular 4 digitos del 0000 al 9999
    pre: string[8];    //precio, 6 digitos 3 enteros 2 decimales y el punto 000.00 al 999.99
    stkM:string[2];    //stock mínimo 2 digitos del 00 al 99
    stkD:string[2];    //el stock disponible. 3 digitos del 00 al 99
    bco:char;          //descartar espacios
    end;
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
function validaEnlace(var archivo:fCelulares):boolean;
  //retorna boolean F-> hubo fallo,V->si abrio sin error, existe y debe cerrarlo
  var ok:boolean;
  begin
    {$I-} reset(archivo); {$I+}//Bloqueo errores,-intento apertura,-desb errores
    ok:=(ioResult = 0); // mantener res apertura - si existio error, no debe cerrar nada
    if ok then close(archivo);//~V->(valido,existio arch y debe cerrarse)
    validaEnlace:= ok ; //retornar ~error (F->si los hay, V-> si esta ok)
  end;

function consultaAbrirArchivo(var archivo:fCelulares):boolean;
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

// conversion numero entero a string 2 espacios
function entero_str(x:integer):string;
begin
 if(x<10)then entero_str:=' '+intTostr(x) else entero_str:=intTostr(x);
end;

// conversion numero real a string 8 espacios (5 enteros + . + 2 fraccion)
function real_str(x:real):string;
var y:string; z:integer;
begin
  str(x:5:2,y); z:=length(y);
  case z of
    4: begin y:='    '+y;  end;
    5: begin y:='   '+y;   end;
    6: begin y:='  '+y;    end;
    7: begin y:=' '+y;     end;
    end;
  real_str:=y;
end;

procedure verificaCelular(var r:rCel);
var ok:boolean;
begin
  ok:=false;
  while not ok do begin
    with r do begin
     // validar rango del codigo
     ok:=(cod < 9999) and (cod > 1000);
     while not ok do begin
       write('Error en el codigo "4 dig", ingrese nuevamente(debe ser mayor a 1000): ');
       readln(cod);
       ok:=(cod < 9999) and (cod > 1000);
       end;
     //validar rengo del precio
     ok:=(pre < 99999.99) and (pre > 10000.00);
     while not ok do begin
       write('Error en el precio, ingrese nuevamente(rango [10000.00 a 99999.99]: ');
       readln(pre);
       ok:=(pre < 99999.99) and (pre > 10000.00);
       end;

     //validar rango del stock disponible
     ok:=(stkD >= 0)and(stkD <= 99);
     while not ok do begin
       write('Error en stock disponible, ingrese nuevamente(rango [0 a 99]: ');
       readln(stkD);
       ok:=(stkD >= 0)and(stkD <= 99);
       end;

     //validar rango del stock minimo
     ok:=(stkM >= 0)and(stkM <= 99);
     while not ok do begin
       write('Error en stock minimo, ingrese nuevamente(rango [0 a 99]: ');
       readln(stkM);
       ok:=(stkM >= 0)and(stkM <= 99);
       end;
     end; //with
    end; // while
end;

