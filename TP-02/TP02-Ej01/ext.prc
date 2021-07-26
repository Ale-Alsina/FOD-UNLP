procedure obtenerDatos (var emp:fEmp);
var
  data : text;
  e: rEmp;
  bco:char;    cod:string[3];  com:string[5];
begin
  Assign(data,'Empleados.txt');
  reset(data);
  rewrite(emp);
  while (NOT EOF(data))do begin
    readln(data,cod,e.nom,com);
    e.cod:= strToInt(cod);
    e.com:= strToFloat(com);
    write(emp,e);
    readln(data,cod,bco,e.nom,com);
    end;
  close(data);
  close(emp);
end;
