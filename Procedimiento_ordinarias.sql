/*ESCRIBE UN PROCEDIMIENTO, LLAMADO GASTO_HOSPI_PLANTILLA, QUE LISTE EL GASTO DE PERSONAL PARA UN 
HOSPITAL CONCRETO.

AL HOSPITAL SE LE PASARA COMO PARAMETRO EL CODIGO DEL HOSPITAL

EL PROCEDIMIENTO POR CADA EMPLEADO QUE FORME PARTE DE LA PLANTILLA DE ESE HOSPITAL, SACARA: EL NUMERO 
DE EMPLEADO, EL NOMBRE DEL EMPLEADO, LA FUNCION QUE REALIZA EN EL HOSPITAL Y EL PORCENTAJEM CON DOS
DECIMALES, QUE SUPONE SU SUELDO AL HOSPITAL(SU SUELDO/TOTAL HOSPITAL).

    CONTROLAR LOS SIGUIENTE POSIBLES ERRORES
    
        EN EL CASO DE QUE EL HOSPITAL QUE PASEN COMO PARAMETRO NO EXISTA, SE ENVIARA EL CODIGO 20100, CON EL 
        MENSAJE 'NO EXISTE X HOSPITAL' DONDE X ES EL VALOR QUE NOS HA INTRODUCIDO COMO PARAMETRO
        
        CONTROLARA SI HAY PLANTILLA EN ESE HOSPITAL. SI TODAVIA NO TIENEN PLANTILLA NOS INFORMARA
        
        EN EL CASO DE QUE EL SUELDO DE UN EMPLEADO SUPERE EL 2% EL DEL HOSPILAT SE INSERTARA EN UNA TABLA
        SUELDOS_A_REVISAR, EL CODIGO DEL HOSPITAL, EL NUMERO DEL EMPLEADO Y LA FECHA EN LA QUE SE HA REALIZADO
        LA INSERCION. LA TABLA SE CREARA PREVIAMENTE. 
        
        PARA CUALQUIER ERROR SE ENVIARA EL CODIGO DE ERROR Y EL MENSAJE GENERADO POR ORACLE


MUESTRA LA EJECUCION Y EL RESULTADO PARA CADA UNO DE LOS SIGUIENTES CODIGOS DE HOSPITAL
1
3
22
45

*/
/
set serveroutput on
create or replace procedure gasto_hospi_plantilla (codigo number) as
  cod number(5);   
  contadorPlantilla number(4);
  sueldoEmple number(10);
  sueldoHospi number(10);
  CURSOR datos IS
  SELECT emp_no, apellido, oficio, salario
  FROM emple where dept_no=codigo; 
    begin    
    select dept_no into cod from depart where dept_no = codigo;
    select count(emp_no) into contadorPlantilla from emple where dept_no = codigo;
    select sum (salario) into sueldoHospi from emple where dept_no=codigo; 
    if contadorPlantilla = 0
        then raise_application_error (-20200,'EL HOSPITAL NO TIENE PLANTILLA');
    else
        for v in datos loop
        dbms_output.put_line('Codigo del empleado: '||v.emp_no||', '||'Apellido: '||v.apellido||', '||'Oficio: '||v.oficio||', '||'Salario: '||v.salario);
          if v.salario > (2*sueldoHospi)/100 
            then insert into sueldos_a_revisar values (codigo,v.emp_no,sysdate);          
          end if;
        end loop;
    end if;
      exception
        when no_data_found 
          then raise_application_error (-20100,'NO EXISTE EL HOSPITAL CON CODIGO: '||TO_CHAR(CODIGO));
        when others 
          then DBMS_OUTPUT.PUT_LINE('Error code ' || sqlcode || ': ' || SUBSTR(SQLERRM, 1 , 64));
end;
/
create table sueldos_a_revisar(
codHospi number(5),
codEmple number (5),
fecha date
);
/
execute gasto_hospi_plantilla(40);