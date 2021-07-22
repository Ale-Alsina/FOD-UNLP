{ TP01_EJ05_y_EJ06
5. Realizar un prog para una tienda de celulares, que presente un menú con opciones para:
 a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
    ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
    correspondientes a los celulares, deben contener:
    * código de celular,
    * el nombre,
    * descripcion,
    * marca,
    * precio,
    * stock mínimo
    * y el stock disponible.
 b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
 c. Listar en pantalla los celulares del archivo cuya descripción contenga una
    cadena de caracteres proporcionada por el usuario.
 d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
    “celulares.txt” con todos los celulares del mismo.
 NOTA 1: El nom del archivo binario de celulares debe ser proporcionado x el usuario una única vez.
 NOTA 2: El arch de carga debe editarse de manera q c/celular se especifique en 3 líneas consec:
        *  en la primera se especifica: código de celular, el precio y marca,
        *  en la segunda el stock disponible, stock mínimo y la descripción
        *  y en la 3ra nombre, en ese orden.
 Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.

6. Agregar al menú del programa del ejercicio 5, opciones para:
 a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
 b. Modificar el stock de un celular dado.
 c. Exportar el contenido del archivo binario a un archivo de texto denominado:
       ”SinStock.txt”, con aquellos celulares que tengan stock 0.
 NOTA: Las búsquedas deben realizarse por nombre de celular

}
program TP01_EJ05_y_EJ06;
uses crt, sysutils;
CONST
   TXT='celulares.txt';
TYPE
   rCel = record
      cod: integer; //código de celular,
      nom: string;  //el nombre(modelo)
      des: string;  //descripcion,
      mar: string;  //marca,
      pre: real;    //precio,
      stkM:integer; //stock mínimo
      stkD:integer; //el stock disponible.
      end;
  fCelulares= file of rCel;

{$i ./libreria.prc} // lib secundaria cosas  =>(codigo soporte a la resolucion -NO EVALUA-)

{****************************************  PRACTICA 5  **********************************************}
//########################################## PUNTO A ###############################################\\
procedure cargarInfo(var archivo:fCelulares);
var
  d:rTxt; i:rCel;  data:text; nomArch:string;
begin
  assign(data,TXT);          reset(data);
  write('Ingrese nombre del archivo binario a crear: '); readln(nomArch);
  assign(archivo,nomArch);   rewrite(archivo);
  while NOT EOF(data) do begin
    with d do begin
      //Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
      readln(data,cod,bco,pre,bco,i.mar);   // 1er linea codigo, precio, marca (ingresa al reg)
      readln(data,stkD,stkM,bco,i.des);     // 2da linea stock disp, stock min, desc(ingresa al reg)
      readln(data,i.nom);                   // 3er linea nombre o modelo (ingresa al reg)
      //Parceo datos del txt a valores para el reg bin
      i.cod := strToInt(cod);               // convetir a entero valor del codigo leido del txt
      i.stkD:= strToInt(stkD);              // convetir a entero valor del stock disp leido del txt
      i.stkM:= strToInt(stkM);              // convetir a entero valor del stock min leido del txt
      val(pre,i.pre);                       // convetir a real valor del precio leido del txt
    end;
    write(archivo,i); // Escribir el registro dentro del binario
  end;
  close(archivo); // cerrar binario
  close(data);    // cerrar txt con datos
  writeln('Archivo binario "',nomArch,'" creado CORRECTAMENTE....');
end;

//########################################## PUNTO B ###############################################\\
//5b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
procedure listarMinimosStock(var archivo:fCelulares);
var r:rCel;
begin
  clrscr;
  reset(archivo);
  writeln();
  writeln('################### LISTA DE CELULARES CON STOCK POR DEBAJO DEL MINIMO ###################');
  writeln();
  while (NOT EOF(archivo))do begin
    read(archivo,r);
    if (r.stkD < r.stkM)then
      writeln('Cod:"',r.cod,'"| ',r.mar:8,' | ',r.nom:25,' | -> stock por debajo del minimo');
    end;
  writeln();
  writeln('##########################################################################################');
  close(archivo);
end;

//########################################## PUNTO C ###############################################\\
//5c. Listar cel del archivo cuya descripción contenga una cad de car proporcionada por el usuario.
procedure buscar_y_listar(var archivo:fCelulares);
  function buscar(x,y:string):boolean;
  begin buscar:=((pos(x,y)>0)); end;

var r:rCel;   des:string;
begin
  reset(archivo);
  clrscr;
  write('Ingrese texto que incluya en la descripcion de los celulares: '); readln(des);
  writeln();
  writeln('################### LISTA DE CELULARES CON ',des,' INCLUIDO EN SU DESCRIPCION ###################');
  writeln();
  while (NOT EOF(archivo))do begin
    read(archivo,r);
    if (buscar(des,r.des))then begin
      writeln('Cod:"',r.cod,'" | marca:"',r.mar:10,' " | Modelo:"',r.nom,'"');
      writeln('Descripcion:',r.des);
      writeln('-------------------------------------------------------------------------------------------');
      end;
    end;
  writeln();
  writeln('##########################################################################################');
  close(archivo);
end;

//########################################## PUNTO D ###############################################\\
//5d. Exportar archivo bin a un arch txt denominado “celulares.txt” c/todos los celulares del mismo.
procedure exportarBinario(var archivo:fCelulares);
var r:rCel; d:rTxt; data:text;
begin
  reset(archivo);
  clrscr;
  assign(data,'celulares.txt');
  rewrite(data);
  while (NOT EOF(archivo))do begin
    read(archivo,r);
    d.cod:=entero_str(r.cod);     d.pre:=real_str(r.pre);     //{./libreria.prc}
    d.stkD:=entero_str(r.stkD);   d.stkM:=entero_str(r.stkM); //{./libreria.prc}
    writeln(data,d.cod,' ',d.pre,' ',r.mar); // 1er linea codigo, precio, marca (ingresa al reg)
    writeln(data,d.stkD,d.stkM,' ',r.des);   // 2da linea stock disp, stock min, desc(ingresa al reg)
    writeln(data,r.nom);                     // 3er linea nombre o modelo (ingresa al reg)
    end;
  close(archivo);
  close(data);
  writeln('Archivo binario exportado CORRECTAMENTE a "celulares.txt"....');
end;

{****************************************  PRACTICA 6  **********************************************}
//########################################## PUNTO A ###############################################\\
//6a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
procedure agregarCelular(var archivo:fCelulares);
  procedure leerCelular(var r:rCel);
  begin
    with r do begin
     writeln('Ingrese datos del celular a agregar...');
     write('Su codigo: ');            readln(cod);
     write('Su nombre o modelo: ');   readln(nom);
     write('Su descripcion: ');       readln(des);
     write('Su marca: ');             readln(mar);
     write('Su precio: $');           readln(pre);
     write('Su stock disponible: ');    readln(stkD);
     write('Su stock minimo: ');      readln(stkM);
     verificaCelular(r);
     end;
  end;
var r:rCel; x:integer;
begin
  reset(archivo);
  seek(archivo,filesize(archivo));
  x:=0;
  repeat
    writeln('----------------------------');
    leerCelular(r);
    write(archivo,r);
    x:=x+1;
    writeln('Desea cargar otro Celular?: Si(s)/No(n)'); readln(r.nom);
  until (r.nom='n');
  if x=1 then writeln('Se agrego un celular al final del archivo... CORRECTAMENTE')
  else writeln('Se agregaron "',x,'" celulares al final del archivo... CORRECTAMENTE');
end;

//########################################## PUNTO B ###############################################\\
//6b. Modificar el stock de un celular dado.
procedure modificaStock(var archivo:fCelulares);
var r:rCel;   cod:integer;
begin
  reset(archivo);
  write('Ingrese del celular a modificar su stock: '); readln(cod);
  read(archivo,r);
  while (NOT EOF(archivo)and(r.cod<>cod)) do read(archivo,r);
  if(r.cod=cod)then begin
    write('Ingrese stock a modif del celular. ',r.nom,' ',r.mar,' con stock actual de ',r.stkD,': ');
    readln(r.stkD);
    seek(archivo,filepos(archivo)-1);
    write(archivo,r);
    end else
      writeln('El celular solicitado no se encuentra registrado');
  close(archivo);
end;

//########################################## PUNTO C ###############################################\\
//6c. Exportar archivo bin a un archivo de texto ”SinStock.txt”, c/aquellos cel q tengan stock 0.
procedure sinStock(var archivo:fCelulares);
var r:rCel;  sinStk:text;
begin
  assign(sinStk,'SinStock.txt');
  rewrite(sinStk);
  reset(archivo);
  writeln(sinStk,' ');
  writeln(sinStk,'######################### LISTA DE CELULARES CON STOCK CERO #############################');
  writeln(sinStk,' ');
  while (NOT EOF(archivo))do begin
    read(archivo,r);
    if(r.stkD=0)then begin
      writeln(sinStk,'--------------------------------------------------------------------------------------');
      writeln(sinStk,'Cod:"',r.cod,'" -> ',r.mar,' ',r.nom,' | Precio: $',r.pre:5:2);
      writeln(sinStk,'Descripcion: ',r.des);
      writeln(sinStk,'Stock Disponible: ',r.stkD,' | Stock Min: ',r.stkM);
      end;
    end;
  writeln(sinStk,'--------------------------------------------------------------------------------------');
  writeln(sinStk,' ');
  writeln(sinStk,'#########################################################################################');
  close(archivo);
  close(sinStk);

end;

//###################################### MENU PRINCIPAL ############################################\\
procedure menuPrincipal(var archivo:fCelulares);
var op:char; m:rMenu;
begin
  {*                        *** MENU PRINCIPAL ***                        *}
  {1*} m.a:='Crear archivo binario con datos proporcionados de "celulares.txt")';
  {2*} m.b:='Listar aquellos celulares que tengan un stock menor al stock minimo';
  {3*} m.c:='Listar cel del archivo c/descripcion proporcionada por el usuario';
  {4*} m.d:='Exportar archivo bin a un arch txt denominado "celulares.txt"';
  {5*} m.e:='Agregar 1 o mas celuares al final de arch c/datos ing x teclado';
  {6*} m.f:='Modificar stock a un determinado celular';
  {7*} m.g:='Exp el archivo bin a un arch txt llamado "SinStock.txt"';
  {8*} m.h:='';//sin item como parametro son solo 7
  {**} m.ini:='MENU PRINCIPAL  ';
  {**} m.fin:=' Pulse "f" o "F" para Finalizar...                                ';
  repeat
    menuOpciones(op,m,7);     // op=opcion elegida, m=todos los param, 2=cant total de param.
    writeln('');
    case op of
      '1': begin
            cargarInfo(archivo);
           end;
      '2': begin
             if(validaEnlace(archivo))then listarMinimosStock(archivo)
               else
                 if(consultaAbrirArchivo(archivo))then listarMinimosStock(archivo);
           end;
      '3': begin
            if(validaEnlace(archivo))then buscar_y_listar(archivo)
               else
                 if(consultaAbrirArchivo(archivo))then buscar_y_listar(archivo);
           end;
      '4': begin
            if(validaEnlace(archivo))then exportarBinario(archivo)
              else
                 if(consultaAbrirArchivo(archivo))then exportarBinario(archivo);
           end;
      '5': begin
             if(validaEnlace(archivo))then agregarCelular(archivo)
               else
                if(consultaAbrirArchivo(archivo))then agregarCelular(archivo);
           end;
      '6': begin
             if(validaEnlace(archivo))then modificaStock(archivo)
               else
                if(consultaAbrirArchivo(archivo))then modificaStock(archivo);
           end;
      '7': begin
            if(validaEnlace(archivo))then sinStock(archivo)
              else
                if(consultaAbrirArchivo(archivo))then sinStock(archivo);
           end;
      else begin
             if(op<>'f')or(op<>'f')then begin
               writeln('????????????????????????????????????????????');
               writeln('?  Error! ... --> OPCION NO VALIDA ...     ?');
               writeln('????????????????????????????????????????????');
               end;
           end;
    end;
    writeln();writeln('--------------------------------------------------');
    write('Presione una tecla para continuar...'); readkey();
  until (op='f') or (op='F');
end;

//##########################################   MAIN  ###############################################\\
VAR
  celulares:fCelulares;
BEGIN
  writeln();
  writeln(' #####################################################################');
  writeln(' #                ________   ______   _______                        #');
  writeln(' #               /        | /      \ /       \                       #');
  writeln(' #               $$$$$$$$/ /$$$$$$  |$$$$$$$  |                      #');
  writeln(' #               $$ |__    $$ |  $$ |$$ |  $$ |                      #');
  writeln(' #               $$    |   $$ |  $$ |$$ |  $$ |                      #');
  writeln(' #               $$$$$/    $$ |  $$ |$$ |  $$ |                      #');
  writeln(' #               $$ |      $$ \__$$ |$$ |__$$ |                      #');
  writeln(' #               $$ |      $$    $$/ $$    $$/                       #');
  writeln(' #               $$/        $$$$$$/  $$$$$$$/                        #');
  writeln(' #          ________  _______            ______     __               #');
  writeln(' #         /        |/       \          /      \  _/  |              #');
  writeln(' #         $$$$$$$$/ $$$$$$$  |        /$$$$$$  |/ $$ |              #');
  writeln(' #            $$ |   $$ |__$$ | ______ $$$  \$$ |$$$$ |              #');
  writeln(' #            $$ |   $$    $$/ /      |$$$$  $$ |  $$ |              #');
  writeln(' #            $$ |   $$$$$$$/  $$$$$$/ $$ $$ $$ |  $$ |              #');
  writeln(' #            $$ |   $$ |              $$ \$$$$ | _$$ |_             #');
  writeln(' #            $$ |   $$ |              $$   $$$/ / $$   |            #');
  writeln(' #            $$/    $$/                $$$$$$/  $$$$$$/             #');
  writeln(' #    ________     _____            _______              ______      #');
  writeln(' #   /        |   /     |          /       |            /      \     #');
  writeln(' #   $$$$$$$$/    $$$$$ |          $$$$$$$/   __    __ /$$$$$$  |    #');
  writeln(' #   $$ |__          $$ |          $$ |____  /  |  /  |$$ \__$$/     #');
  writeln(' #   $$    |    __   $$ |          $$      \ $$ |  $$ |$$      \     #');
  writeln(' #   $$$$$/    /  |  $$ |          $$$$$$$  |$$ |  $$ |$$$$$$$  |    #');
  writeln(' #   $$ |_____ $$ \__$$ | __       /  \__$$ |$$ \__$$ |$$ \__$$ |    #');
  writeln(' #   $$       |$$    $$/ /  |      $$    $$/ $$    $$ |$$    $$/     #');
  writeln(' #   $$$$$$$$/  $$$$$$/  $$/        $$$$$$/   $$$$$$$ | $$$$$$/      #');
  writeln(' #                                           /  \__$$ |              #');
  writeln(' #                                           $$    $$/               #');
  writeln(' #                                            $$$$$$/                #');
  writeln(' #                                                                   #');
  writeln(' #####################################################################');
  delay(900);
  menuPrincipal(celulares);
END.
