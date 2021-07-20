program TP01_EJ03_y_EJ04;
uses crt,sysutils;
const
  FIN= 'fin';  // Condicion de corte, lectura de teclado
type
  rEmp=  record
    nro : integer;
    nom:  string;
    ape:  string;
    eda:  integer;
    dni:  longword;
    end;

  aEmp = file of rEmp;

  {$i ./libreria.prc} // lib secundaria cosas  =>(codigo soporte a la resolucion -NO EVALUA-) // debe descargarse mismo directorio


//================================= PUNTO A carga en el archivo ==================================\\
procedure leerEmp (var e:rEmp);
begin
  writeln('____________________________________________');
  with e do begin
    write('Ingrese Apellido del empleado: ');  readln(ape);
    if ( ape <> FIN )then begin
      write('ingrese su "Nombre": ');          readln(nom);
      write('Ingrese "Num Empleado": ');       readln(nro);
      write('ingrese su "Edad":');             readln(eda);
      write('ingrese su "DNI": ');             readln(dni);
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

procedure crearArchivo(var archivo:aEmp);
var nomArchivo:string; m:rMenu; op:char;
begin
  write('Ingrese nombre de archivo binario de Empleados a crear: ');  readln(nomArchivo);
  assign(archivo,nomArchivo);
  rewrite(archivo);
  {*                       MENU                         *}
  {*}m.a:='Crear archivo Binario c/datos desde teclado';
  {*}m.b:='Crear archivo Binario auto desde un archivo';
  {*}m.ini:=' OPCIONES DE CARGA ';
  {*}m.fin:=' Pulse "C" o "c" para Continuar...           ';
  {*}m.c:=' '; m.d:=' '; m.e:=' '; m.f:=' ';m.g:=' ';m.h:=' '; //opciones rest s/validez
  repeat
  {*}menuOpciones(op,m,2);     // op=opcion elegida, m=todos los param, 2=cant total de param.
     case op of
       '1': begin
             crearArchivo_teclado(archivo);
             writeln('Carga del archivo bin c/reg empleados leidos de teclado EXITOSA !!!...');
             op:='c'
            end;
       '2': begin
             crearArchivo_cDatos(archivo) ;
             writeln('Carga del archivo binario "',nomArchivo,'" c/reg empleados EXITOSA !!!...');
             op:='c';
            end;
       else begin if ((op <> 'c')and(op <> 'c'))then write('??? - Opcion no valida...'); delay(800); end;
     end;
  until(op = 'c')or(op = 'C');
  close(archivo);
end;

//================================= PUNTO B  BUSCAR,LISTAR =======================================\\
//i-)Listar en pantalla los datos de emp q tengan un nom o ape determinado
procedure buscar_y_listar_NomApe (var archivo:aEmp);
  function encontro(aBucar:string; reg:rEmp):boolean;
  begin encontro:=((pos(aBucar, reg.nom)>0) or (pos(aBucar, reg.ape)>0)); end;
  
var x:string; e:rEmp;
begin
  reset(archivo);
  writeln(); write('Ingrese nombre o apellido a buscar: '); readln(x);
  writeln('--------------------------------------------------');
  writeln('Cod |    DNI   | Edad |     APELLIDO y NOMBRE/s');
  writeln('----|----------|------|---------------------------');
  while NOT EOF(archivo)do begin
    read(archivo,e);
    if(encontro(x,e))then
      writeln(e.nro:3,' | ',e.dni:8,' | ',e.eda:4,' | ',e.nom,' ',e.ape);
    end;
  close(archivo);
end;

//ii-) Listar en pantalla los empleados de a uno por línea.
procedure Listar(var archivo: aEmp);
var e:rEmp;
begin
  reset(archivo);
  writeln('--------------------------------------------------');
  writeln('Cod |    DNI   | Edad |     APELLIDO y NOMBRE/s');
  writeln('----|----------|------|---------------------------');
  while (not eof(archivo)) do begin
    read(archivo,e);
    writeln(e.nro:3,' | ',e.dni:8,' | ',e.eda:4,' | ',e.nom,' ',e.ape);
    end;
  close(archivo);
end;

//iii-) Listar en pantalla empleados mayores de 60 años, próximos a jubilarse.
procedure listar_meyor70(var archivo:aEmp);
var e:rEmp;
begin
  reset(archivo);
  writeln('<----------Proximos a junilarse------------------>');
  writeln('--------------------------------------------------');
  writeln('Cod |    DNI   | Edad |     APELLIDO y NOMBRE/s');
  writeln('----|----------|------|---------------------------');
  while NOT EOF(archivo)do begin
    read(archivo,e);
    if (e.eda >70)then writeln(e.nro:3,' | ',e.dni:8,' | ',e.eda:4,' | ',e.nom,' ',e.ape)
    end;
  close(archivo);
end;

//################################### TP 04 ###################################
//vi-)Añadir una o más empleados al final del archivo con sus datos ingresados x teclado.
procedure agregarEmp(var archivo:aEmp);
var e:rEmp;
begin
  reset(archivo);
  seek(archivo,filesize(archivo));
  leerEmp(e);
  while(e.ape <> FIN)do begin
    write(archivo,e);
    leerEmp(e);
  end;
  close(archivo);
end;

//v-)Modificar edad a una o más empleados.
procedure cambiarEdad(var archivo:aEmp);
var
  e:rEmp;   fin:char;   dni:longword;
begin
  reset(archivo);
  repeat
    write('Ingrese el DNI del empleado a cambiar la edad: '); readln(dni);
    read(archivo,e);
    while (NOT EOF(archivo)and(e.dni<>dni))do read(archivo,e);
    if(e.dni=dni)then begin
      write('Ingrese edad a modif del emp. ',e.nom,' ',e.ape,' con dni:',e.dni,' : ');readln(e.eda);
      seek(archivo,filepos(archivo)-1);
      write(archivo,e);
       seek(archivo,0);
    end else
      writeln('El empleado solicitado no se encuentra registrado');
    write('¿Desea modificar la edad de otro empleado?: Si(s)/No(n)'); readln(fin);
    while ((fin<>'s')and(fin<>'S')and(fin<>'n')and(fin<>'N'))do begin
      write('ERROR de opcion: Si(s)/No(n)'); readln(fin);
      end;
  until (fin ='N')or(fin='n');
  close(archivo);
end;

//vi y vii-)Exportar a un txt segun item, (6)todos los empleados o bien (7)aquellos con dni = "00".
procedure generaTxt(var archivo:aEmp; nomArchivo,item:string);
var e:rEmp; data:text;
begin
  reset(archivo);                                // Abrir binario creado
  assign(data,nomArchivo); rewrite(data);// Asignar y crear el txt c/datos del bin empleados
  if (item = 'todos') then begin         // Item 6 -> exporta los emp a “todos_empleados.txt”
    writeln(data,'');
    writeln(data,'################# LISTADO DE TODOS LON EMPLEADOS ###################');
    writeln(data,'');
    writeln(data,'Cod|  DNI   |Edad|  APELLIDO y NOMBRE');
    while NOT EOF(archivo) do begin
    read(archivo,e);
    writeln(data,e.nro:3,'|',e.dni:8,'|',e.eda:4,'|',e.ape,' ',e.nom);
    end;
  end else begin                    //SINO Item 7 ->exporta emp c/DNI="0" a "faltaDNIEmpleado.txt"
    writeln(data,'');
    writeln(data,'##################### EMPLEADOS CON DNI = "00" #####################');
    writeln(data,'');
    writeln(data,'Cod|  DNI   |Edad|  APELLIDO y NOMBRE');
    while NOT EOF(archivo) do begin
      read(archivo,e);
      if (e.dni = 00)then  writeln(data,e.nro:3,'|',e.dni:8,'|',e.eda:4,'|',e.ape,' ',e.nom);
      end;
  end;
  writeln(data,'');
  writeln(data,'####################################################################');
  close(archivo); //cierra binario
  close(data);    //cierra informe creado txt
end;



procedure menuPrincipal(var archivo:aEmp);
var m:rMenu; op:char;
begin
  {*                        *** MENU PRINCIPAL ***                        *}
  {1*} m.a:='Crear archivo binario Empleados (Manual-Auto c/datos de txt)';
  {2*} m.b:='Listar en pant datos d/emp q tengan un nom o ape determinado';
  {3*} m.c:='Listar en pantalla los empleados de a uno por linea';
  {4*} m.d:='Listar en pant emp mayores de 70 anios, proximos a jubilarse';
  {5*} m.e:='Agregar 1 o mas emp al final de arch c/datos ing x teclado';
  {6*} m.f:='Modificar edad a una o mas empleados';
  {7*} m.g:='Exp el archivo a un arch txt llamado "todos_empleados.txt"';
  {8*} m.h:='Exp a txt llamado: "faltaDNIEmpleado.txt", emp s/DNI';
  {**} m.ini:='MENU PRINCIPAL  ';
  {**} m.fin:=' Pulse "f" o "F" para Finalizar...                           ';
  repeat
   menuOpciones(op,m,8);     // op=opcion elegida, m=todos los param, 8=cant total de param.
   writeln('');
    case op of
      '1': begin
            crearArchivo(archivo);
           end;
      '2': begin
             if(validaEnlace(archivo))then buscar_y_listar_NomApe(archivo)
               else
                 if(consultaAbrirArchivo(archivo))then buscar_y_listar_NomApe(archivo);
           end;
      '3': begin
            if(validaEnlace(archivo))then listar(archivo)
               else
                 if(consultaAbrirArchivo(archivo))then listar(archivo);
           end;
      '4': begin
            if(validaEnlace(archivo))then listar_meyor70(archivo)
              else
                 if(consultaAbrirArchivo(archivo))then listar_meyor70(archivo);
           end;
      '5': begin
             if(validaEnlace(archivo))then agregarEmp(archivo)
               else
                if(consultaAbrirArchivo(archivo))then agregarEmp(archivo);
           end;
      '6': begin
             if(validaEnlace(archivo))then cambiarEdad(archivo)
               else
                if(consultaAbrirArchivo(archivo))then cambiarEdad(archivo);
           end;
      '7': begin
            if(validaEnlace(archivo))then generaTxt(archivo,'todos_empleados.txt','todos')
              else
                if(consultaAbrirArchivo(archivo))then generaTxt(archivo,'todos_empleados.txt','todos');
           end;
      '8': begin
            if(validaEnlace(archivo))then generaTxt(archivo,'faltaDNIEmpleado.txt','faltaDNI')
              else
                if(consultaAbrirArchivo(archivo))then generaTxt(archivo,'faltaDNIEmpleado.txt','faltaDNI');
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


//############################################ MAIN ################################################
VAR
  archivo:aEmp;
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
  writeln(' #    ________     _____             ______             __    __     #');
  writeln(' #   /        |   /     |           /      \           /  |  /  |    #');
  writeln(' #   $$$$$$$$/    $$$$$ |          /$$$$$$  | __    __ $$ |  $$ |    #');
  writeln(' #   $$ |__          $$ |          $$ ___$$ |/  |  /  |$$ |__$$ |    #');
  writeln(' #   $$    |    __   $$ |            /   $$< $$ |  $$ |$$    $$ |    #');
  writeln(' #   $$$$$/    /  |  $$ |           _$$$$$  |$$ |  $$ |$$$$$$$$ |    #');
  writeln(' #   $$ |_____ $$ \__$$ | __       /  \__$$ |$$ \__$$ |      $$ |    #');
  writeln(' #   $$       |$$    $$/ /  |      $$    $$/ $$    $$ |      $$ |    #');
  writeln(' #   $$$$$$$$/  $$$$$$/  $$/        $$$$$$/   $$$$$$$ |      $$/     #');
  writeln(' #                                           /  \__$$ |              #');
  writeln(' #                                           $$    $$/               #');
  writeln(' #                                            $$$$$$/                #');
  writeln(' #                                                                   #');
  writeln(' #####################################################################');
  delay(900);
  menuPrincipal(archivo);
END.
