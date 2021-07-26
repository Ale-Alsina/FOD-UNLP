{ TP01_EJ07
Realizar un programa que permita:
 a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
    El nombre del archivo de texto es: “novelas.txt”
 b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
    una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: La información en el archivo de texto consiste en:
       * código de novela,
       * nombre,género y
       * precio de diferentes novelas argentinas.
      De cada novela se almacena la información en dos líneas en el archivo de texto.
       * La primera línea contendrá la siguiente información: código novela, precio, y género, y
       * la segunda línea almacenará el nombre de la novela.
}
program TP01_EJ07;
uses crt, sysutils;
CONST
   TXT='novelas.txt';
TYPE
   rLib = record
      cod: integer; //código de celular,
      nom: string;  //el nombre(modelo)
      gen: string;  //descripcion,
      pre: real;    //precio,
      end;
  fLibros= file of rLib;

{$i ./libreria.prc} // lib secundaria cosas  =>(codigo soporte a la resolucion -NO EVALUA-)

{****************************************  PRACTICA 7  **********************************************}
//########################################## PUNTO A ###############################################\\
procedure cargarInfo(var archivo:fLibros);
var
  d:rTxt; l:rLib;  data:text;
begin
  assign(data,TXT);          reset(data);
  assign(archivo,'novelas.bin'); rewrite(archivo);
  while NOT EOF(data) do begin
    with d do begin
      //Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
      readln(data,cod,bco,pre,l.gen);   // 1er linea codigo, precio, genero (ingresa al reg)
      readln(data,l.nom);                   // 2da linea nombre o titulo ingresa al reg)
      //Parceo datos del txt a valores para el reg bin
      l.cod := strToInt(cod);               // convetir a entero valor del codigo leido del txt
      val(pre,l.pre);                       // convetir a real valor del precio leido del txt
      writeln(l.cod,' | $ ',l.pre:5:2,' | ',l.gen:25,' | ',l.nom);
    end;
    write(archivo,l); // Escribir el registro dentro del binario
  end;
  close(archivo); // cerrar binario
  close(data);    // cerrar txt con datos
  writeln('Archivo binario "novelas.bin" creado CORRECTAMENTE....');
end;

//########################################## PUNTO B ###############################################\\
//7b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
//    una novela y modificar una existente. Las búsquedas se realizan por código de novela.
procedure actualizar(var archivo:fLibros);
  procedure leer(var r:rLib; op:integer);
  begin
    case op of
        0: begin
                writeln('Ingrese datos de nuevo libro: ');
            {1} write('Su codigo: ');            readln(r.cod);
            {2} write('Su precio: $');           readln(r.pre);
            {3} write('Su genero: ');            readln(r.gen);
            {4} write('Su nombre : ');           readln(r.nom);
           end;
        1: begin
                write('Ingrese codigo a modif (actualmente ',r.cod,'): '); readln(r.cod);
           end;
        2: begin
                write('Ingrese precio a modif (actualmente $',r.pre:5:2,'): '); readln(r.pre);
           end;
        3: begin
                write('Ingrese genero a modif (actualmente ',r.gen,'): '); readln(r.gen);
           end;
        4: begin
                writeln('Ingrese nombre a modif (actualmente ',r.nom,'): '); readln(r.nom);
           end;
    end;
  end;
  procedure modificar(var archivo:fLibros);
    procedure menuModificar(r:rLib; var op:integer);
    begin
         writeln('Elegir campo del registro novela c/cod "',r.cod,'" a modificar...');
         writeln(' 1: Modifica campo "CODIGO". ');
         writeln(' 2: Modifica campo "PRECIO". ');
         writeln(' 3: Modifica campo "GENERO". ');
         writeln(' 4: Modifica campo "NOMBRE". ');
         write('Ingrese opcion: '); readln(op);
         while (op > 4)and(op < 1 )do begin
           write('ERROR seleccione numero dentro del rango [4 opciones]: '); readln(op);
           end;
    end;
  var r:rLib; cod,op:integer;
  begin
    write('Ingrese CODIGO para actualizar algun campo: '); readln(cod);
    seek(archivo,0);
    read(archivo,r);
    while (NOT EOF(archivo)and(r.cod<>cod)) do read(archivo,r);
    if(r.cod=cod)then begin
      menuModificar(r,op);
      leer(r,op);
      seek(archivo,filepos(archivo)-1);
      write(archivo,r);
      end else
        writeln('Error - No se encontro registro con cod "',cod,'" en el binario');
  end;
var r:rLib; op:char; m:rMenu;
begin
  clrscr;
  reset(archivo);
  {*                        *** MENU PRINCIPAL ***                        *}
  {1*} m.a:='Agregar una novela al binario "novelas.bin")';
  {2*} m.b:='Modificar una novela existente de "novelas.bin"';
  m.c:=''; m.d:=''; m.e:=''; m.f:=''; m.g:=''; m.h:='';//sin item como parametro son solo 2
  {**} m.ini:='ACTUALIZACION DEL ARCHIVO BINARIO  ';
  {**} m.fin:=' Pulse "f" o "F" para Finalizar...                          ';
  repeat
    menuOpciones(op,m,2);     // op=opcion elegida, m=todos los param, 2=cant total de param.
    writeln('');
    case op of
      '1': begin
              seek(archivo,filesize(archivo));
              leer(r,0);
              write(archivo,r);
           end;
      '2': begin
             modificar(archivo);
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
  close(archivo);
end;









//###################################### MENU PRINCIPAL ############################################\\
procedure menuPrincipal(var archivo:fLibros);
var op:char; m:rMenu;
begin
  {*                        *** MENU PRINCIPAL ***                        *}
  {1*} m.a:='Crear archivo binario con datos proporcionados de "novelas.txt")';
  {2*} m.b:='Actualizar "novelas.bin"';
  m.c:=''; m.d:=''; m.e:=''; m.f:=''; m.g:=''; m.h:='';//sin item como parametro son solo 7
  {**} m.ini:='MENU PRINCIPAL  ';
  {**} m.fin:=' Pulse "f" o "F" para Finalizar...                                ';
  repeat
    menuOpciones(op,m,2);     // op=opcion elegida, m=todos los param, 2=cant total de param.
    writeln('');
    case op of
      '1': begin
            cargarInfo(archivo);
           end;
      '2': begin
             if(validaEnlace(archivo))then actualizar(archivo)
               else
                 if(consultaAbrirArchivo(archivo))then actualizar(archivo);
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
  novelas:fLibros;
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
  writeln(' #             ________     _____             ________               #');
  writeln(' #            /        |   /     |           /        |              #');
  writeln(' #            $$$$$$$$/    $$$$$ |           $$$$$$$$/               #');
  writeln(' #            $$ |__          $$ |               /$$/                #');
  writeln(' #            $$    |    __   $$ |              /$$/                 #');
  writeln(' #            $$$$$/    /  |  $$ |             /$$/                  #');
  writeln(' #            $$ |_____ $$ \__$$ | __         /$$/                   #');
  writeln(' #            $$       |$$    $$/ /  |       /$$/                    #');
  writeln(' #            $$$$$$$$/  $$$$$$/  $$/        $$/                     #');
  writeln(' #                                                                   #');
  writeln(' #####################################################################');
  delay(900);
  menuPrincipal(novelas);
END.
