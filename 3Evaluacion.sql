--3 EVALUACION
SET SERVEROUTPUT ON;
--1
DECLARE 
  cursor_out SYS_REFCURSOR;
  v_cod partidos.cod%TYPE;
  v_fecha partidos.fecha%TYPE;
  v_equipo_local partidos.codequipo_local%TYPE;
  v_equipo_visitante partidos.codequipo_visitante%TYPE;
BEGIN
  ResulPartidosPorJornada(1, cursor_out);
  LOOP
    EXIT WHEN cursor_out%NOTFOUND;
    FETCH cursor_out
    INTO v_cod, v_fecha, v_equipo_local, v_equipo_visitante;
      DBMS_OUTPUT.PUT_LINE('COD: ' || v_cod || ' Fecha: ' || v_fecha || 'Cod local: ' ||
      v_equipo_local || 'Cod visitante: ' || v_equipo_visitante);
  END LOOP;
END;    

--2
CREATE OR REPLACE PROCEDURE ResulPartidosPorJornada_02 (p_cod_jor INTEGER, c_partidos OUT SYS_REFCURSOR) AS
BEGIN
 --ABRIR CURSOR Y LLENARLO CON DATOS
 OPEN c_partidos FOR
   SELECT p.cod, p.fecha, p.codEquipo_local, p.codEquipo_visitante, 
   p.resultadoel, p.resultadoev, l.nombre
   FROM jornadas j, partidos p, equipos l, equipo v
   WHERE p.jornada_cod=j.cod
   AND j.cod=p_cod_jor
   AND p.jugado='S'
   AND l.cod = p.codequipo_local OR v.cod=p.codequipo_visitante;
END;

--3
CREATE OR REPLACE PACKAGE trigg_pack IS
temp_jugador jugadores%ROWTYPE;
END;
/
CREATE OR REPLACE TRIGGER maximo_num_jugador_02_t
  AFTER INSERT OR UPDATE ON jugadores
DECLARE
  --DECLARAMOS LA VARIABLE EN LA QUE GUARDAREMOS EL NUMERO DE JUGADORES DEL EQUIPO Y LA EXCEPCION PERSONALIZADA
  v_jug_count VARCHAR2(2);
  max_jug_err EXCEPTION;
BEGIN
  --Seleccionamos el número de jugadores que está en el equipo
  SELECT COUNT(*) INTO v_jug_count
  FROM jugadores
  WHERE equipo_cod = trigg_pack.temp_juagdor.equipo_cod;
  --Miramos si es mayor que 5
  IF(v_jug_count>=5) THEN
    RAISE max_jug_err;
  END IF;
  EXCEPTION WHEN max_jug_err THEN
    RAISE_APPLICATION_ERROR(-20001, 'No se puede realizar porque el numero de jugadores es mayor que 5');
END maximo_num_jugador_02_t;    
/
CREATE OR REPLACE TRIGGER maximo_num_jugador_02 
  AFTER INSERT OR UPDATE ON jugadores
  FOR EACH ROW
DECLARE
  --Declaramos la variable para guardar el numero de jugadores y la excepcion
BEGIN
  IF UPDATING THEN
    --Si está actualizando le asiganmos el valor equipo_cod al jugador temporal
    trigg_pack.temp_jugador.equipo_cod:= :new.equipo_cod;
  ELSE
    --Si no, esta insertando asi que le asigamos todas la variables posibles
    trigg_pack.temp_jugador.cod := :new.cod;
    trigg_pack.temp_jugador.nombre := :new.nombre;
    trigg_pack.temp_jugador.apellido := :new.apellido;
    trigg_pack.temp_jugador.nickname := :new.nickname;
    trigg_pack.temp_jugador.sueldo := :new.sueldo;
    trigg_pack.temp_jugador.equipo_cod:= :new.equipo_cod;
  END IF;
END maximo_num_jugador_02;    
  
   
   