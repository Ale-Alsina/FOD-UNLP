rMenu = record
   a,b,c,d,e,f,g,h,i:string; //9 cadenas descriptivas en opciones (max cant de opciones)
   ini,fin: string;          // titulo ventana y texto de finalizacion
   end;

// ################################ MENU #################################### \\
procedure menuOpciones(var op:char;m:rMenu; tot:integer);
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
      7:begin str:=m.g; end;      8:begin str:=m.h; end;      9:begin str:=m.i; end;
    end;
    selOption:=str;
  end;

var max,aux,opcion,x:integer;
begin
  clrscr;  writeln(' ');
  max:=0;

  // busqueda de cadena mas larga para crear ventana -> max sera el string mas grande
  x:=length(m.ini);
  if (x > max)then max:=x;
  for opcion:= 1 to 9 do begin
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

//############################# Validacion y asigancion de Archivos ###############################\\
  {Agregado de funcionalidades a los codigos que aportan a la solucion s/relevancia}
  function validaEnlace(var archivo:fAcceso):boolean;
  //retorna boolean F-> hubo fallo,V->si abrio sin error, existe y debe cerrarlo
  var ok:boolean;
  begin
    {$I-} reset(archivo); {$I+}//Bloqueo errores,-intento apertura,-desb errores
    ok:=(ioResult = 0); // mantener res apertura - si existio error, no debe cerrar nada
    if ok then close(archivo);//~V->(valido,existio arch y debe cerrarse)
    validaEnlace:= ok ; //retornar ~error (F->si los hay, V-> si esta ok)
  end;
//# - proceso para asignar logicamente un arch o lo cree y el programa lo trate sobre el enlace
function enlaceLogicoArchivo(var archivo:fAcceso; str:string):boolean;
var nomArchivo: string; ok:boolean;
begin
  if (str='abre')then begin //-> si hay q abrirlo verificar q realmente exista el archivo c/nombre esp
    write('Ingrese nombre de archivo para abrir: '); readln(nomArchivo);
    assign(archivo,nomArchivo);
    // verificar si existe archivo
    if NOT(validaEnlace(archivo))then begin
      writeln('Error en la apertura del archivo NO EXISTE "',nomArchivo,'"');
      ok:=false;
      end else ok:=true;
    end else begin //-> sino crear el archivo para cargar datos, enlace(es nuevo archivo)
      write('Ingrese nombre de archivo a crear: '); readln(nomArchivo);
      assign(archivo,nomArchivo);
      ok:=true;
      end;
    enlaceLogicoArchivo:=ok;
end;

//<--------------------- Proceso para la creacion del archivo binario de conexiones --------------------->\\
//# Crear un arch de reg ordenados x =>año =>mes =>dia =>idUsuario c/datos de un arch “Data.txt”​.
procedure cargaBin (var archivo:fAcceso);
type
  dig_1=char; dig_2= string[2];  dig_4= string[4];
  rData = record
    d: dig_2;     m: dig_2;    a: dig_4;    u: dig_4;    t: dig_1;
    end;
  function validaEnlaceTxt(var archivo:text):boolean;
  var ok:boolean;
  begin
    {$I-} reset(archivo); {$I+}//Bloqueo errores,-intento apertura,-desb errores
    ok:=(ioResult = 0); // mantener res apertura - si existio error, no debe cerrar nada
    if ok then close(archivo);//~V->(valido,existio arch y debe cerrarse)
    validaEnlaceTxt:=ok ; //retornar ~error (F->si los hay, V-> si esta ok)
  end;
  function enlaceLogicoArchivoTxt(var archivo:text):boolean;
  var nomArchivo: string; ok:boolean;
  begin
    write('Ingrese nombre del archivo TXT c/datos para abrir: '); readln(nomArchivo);
    assign(archivo,nomArchivo);
    // verificar si existe archivo
    if NOT(validaEnlaceTxt(archivo))then begin
      writeln('Error en la apertura del archivo NO EXISTE "',nomArchivo,'"');
      ok:=false;
      end else ok:=true;
    enlaceLogicoArchivoTxt:=ok;
  end;
var a     : rAcceso;   // reg accesos
    carga : text;      // archivo txt con info de accesos
    d: rData;          // reg con info de accesos
    bco:dig_1;
begin
  // solicitar al usuario un nom para abrir arch txt c/datos y un nom de arch bin y crear el enlace
  if(enlaceLogicoArchivoTxt(carga))and(enlaceLogicoArchivo(archivo,'nuevo'))then begin
    reset (carga);                       // programa -> abrir el archivo txt con la info de Accesos
    rewrite(archivo);                    // crea y abre el archivo enlazado para cargar la info
    while (not eof(carga))do begin      //#--> mientras no llegue al fin d/arch carga(tiene datos)...leer
      // 1 lineas -> un registro coexion
      readln(carga,d.a,bco,d.m,bco,d.d,bco,d.u,bco,d.t );//Año,mes,dia,id usuario,tiempo de acceso
      //#-> tratar los datos segun corresponda antes de cargarlo al binario
      a.a  := strToInt(d.a);               // conversion a integer del cpo, tomado en string
      a.m  := strToInt(d.m);               // conversion a integer del cpo, tomado en string
      a.d  := strToInt(d.d);               // conversion a integer del cpo, tomado en string
      a.i  := strToInt(d.u);               // conversion a integer del cpo, tomado en string
      a.t  := strToInt(d.t);               // conversion a integer del cpo, tomado en string
      // <----
      write(archivo,a);                    // guardar registo formateado acceso al archivo binario
      end;                                 //#<-- fin del archivo info, ya no contiene mas datos...
    // Finalizo la carga: crerrar abos archivos e informar
    close(carga);                          // cerrar el archivo txt con la info a cargar de accesos
    close(archivo);                        // cerrar el archivo binario con la info ya guardada.
    write('Finalizo carga exitosamente. Pulse una tecla para continuar...');  readkey();
  end else begin
    write('ERROR -No se pudo crear archivo binario. Pulse una tecla para continuar...');  readkey();
    end;
end;


