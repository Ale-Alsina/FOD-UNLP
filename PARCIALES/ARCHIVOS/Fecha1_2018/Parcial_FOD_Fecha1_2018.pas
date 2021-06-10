program Parcial_FOD_Fecha1_2018;
uses crt,sysutils;
const VALOR_ALTO=9999;
type
  rAcceso = record
   d : integer;       // dia        | flag dia
   m : integer;       // mes        | flag mes
   a : integer;       // anio       | contador tiempo acceso anio
   i : integer;       // id         | contador tiempo acceso mes
   t : integer;       // tiempo     | contador tiempo acceso dia
   end;

  fAcceso = File of rAcceso;

  {$i ./libreria.prc} // lib secundaria cosas  =>(codigo soporte a la resolucion)

procedure informe (var archivo:fAcceso);
  //-> leer un reg c/cte ctrl a fin de archivo
  procedure leer(var arch:fAcceso; var a:rAcceso);
  begin
    if not eof(arch)then read(arch,a) else a.a:=VALOR_ALTO;
  end;
var
  a,act:rAcceso;
  anio:integer;
begin
 if (enlaceLogicoArchivo(archivo,'abre'))then begin
  reset(archivo);
  act.a:=0;                                                 // año actual inicia en 0
  write('Ingrese anio para buscar informe: ');readln(anio); // año buscado x
  while(act.a<>VALOR_ALTO)and(act.a <> anio)do leer(archivo,act); //Buscar en arch año(orden hasta/fin)
  if (anio = act.a)then begin                 // si contiene datos del año buscado. entonces...
    writeln('ANIO:',anio);                    // ## Mostar AÑO en pantalla
    a.a:=0;                                   // a.i -> como contador de accesos año actual
    while (act.a <> VALOR_ALTO)do begin       // mientras año actual sea dif a VALOR_ALTO, hacer...
      a.i:=0;                                  // a.i -> como contador de accesos mes actual
      a.m:=act.m;                              // a.m -> act.m (mantener mes actual)
      writeln('  MES:',a.m);                   // ## Mostar MES ACTUAL en pantalla
      while (act.a<>VALOR_ALTO)and(a.m = act.m)do begin //mientras no termine archivo y mismo mes...
        a.t:=0;                                // a.t -> como contador del dia actual
        a.d:=act.d;                            // a.d -> act.d (mantener dia actual)
        while(act.a<>VALOR_ALTO)and(a.m=act.m)and(a.d=act.d)do begin//mient. n/fin arch, =mes y =dia
          writeln('     IdUsuario:',act.i,', tiempo total de acceso en mes:',a.m,' dia:',a.d,' fue: ',act.t);
          a.t:=a.t + act.t;                    // contabilizar el tiempo de ese usuario en ese DIA.
          leer(archivo,act);                   // leer otro usuario hasta q cambie dia o fin de arch.
          end;
        writeln ('   TIEMPO TOTAL DE ACCESOS DIA ',a.d:2,', MES ',a.m,': ',a.t);//## Mostar totales DIA.
        a.i:=a.i + a.t;                        // contabilizar el tiempo de los usuarios en el MES.
        end;
      writeln('  TOTAL TIEMPO DE ACCESO MES ',a.m,':',a.i);//## Mostar accesos totales d/MES en pantalla
      a.a:=a.a + a.i;                          // contabilizar el tiempo de los meses en ese AÑO.
      end;
    writeln('TIEMPO DE ACCESO ANIO ',anio,':',a.a);//## Mostar accesos totales d/AÑO en pantalla
    write('Pulse una tecla para continuar...'); readkey();
  end else
    writeln('"Anio No Encontrado"');
  close(archivo);
 end else begin
   write('Pulse una tecla para continuar...'); readkey();
   end;
end;
//#################### AGREGADO S/RELEVANCIA (NO SE PIDE-PRUEBAS)#################################\\
{*}procedure menu(var a:fAcceso);
{*}var op:char;  m:rMenu;
{*}begin
{*} m.a:='Crear archivo Binario c/datos Accesos al servidor';
{*} m.b:='Abrir archivo Binario y realizar Informe anual';
{*} m.ini:='MENU OPCIONES';
{*} m.fin:='   Pulse "F" o "f" para Finalizar...              ';
{*} m.c:=' '; m.d:=' '; m.e:=' '; m.f:=' '; m.g:=' '; m.h:=' '; m.i:=' ';//opciones rest s/validez
{*} repeat
{*}   menuOpciones(op,m,2);         // op=opcion elegida, m=todos los param, 2=cant total de param.
{*}   case op of
{*}     '1': begin  cargaBin(a); end;
{*}     '2': begin  informe(a); end;
{*}     else begin
{*}      if ((op <> 'f')and(op <> 'F'))then write('??? - Opcion no valida...'); delay(800);
{*}          end;
{*}    end;
{*}  until(op = 'f')or(op = 'F');
{*}end;
//################################################################################################\\

//----------------------------------   programa principal  ------------------------------------
VAR
  datos:fAcceso;
BEGIN
  menu(datos);
END.
