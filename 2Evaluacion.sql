--2 EVALUACION

--1


--2
SELECT nombre
FROM conductores
WHERE codC IN (SELECT codC 
               FROM trabajos
               WHERE codM IN (SELECT codM 
                              FROM maquinas 
                              WHERE nombre = 'Hormigonera'))
ORDER BY nombre DESC;

--3
SELECT DISTINCT c.*
FROM conductores c, trabajos t
WHERE t.codC = c.codC 
AND tiempo IS NULL;

--4
SELECT DISTINCT c.nombre, p.cliente, ps.localidad
FROM conductores c, trabajos t, proyectos p
WHERE t.codM IN (SELECT codM 
                 FROM maquinas 
                 WHERE preciohora IN (SELECT MAX(preciohora) 
                                       FROM maquinas)) 
AND proyectos.codP = trabajos.codP 
AND trabajos.codC = conductores.codC;

--5
SELECT p.CodP, descrip, cliente, COUNT(*) AS "Número de Trabajos"
FROM proyectos p, trabajos t
WHERE p.codP = t.codP
GROUP BY p.CodP, descrip, cliente¡
HAVING COUNT(*) >=ALL (SELECT COUNT(*) 
                       FROM trabajos 
                       GROUP BY CodP);
                       
--6


--7
UPDATE maquinas
SET preciohora = preciohora + (SELECT MIN(preciohora)*0.1 
                               FROM maquinas)
WHERE preciohora NOT IN (SELECT MAX(preciohora) 
                         FROM maquinas);

--8
DELETE FROM Proyectos
WHERE descrip = 'Solado' 
AND cliente = 'José Pérez';

DELETE FROM trabajos
WHERE CodP NOT IN (SELECT CodP 
                   FROM proyectos);

--9
ALTER TABLE conductores
ADD (formacion VARCHAR(1), 
CONSTRAINT f_ch CHECK(formacion IN ('s' , 'n')));

--10
ALTER TABLE conductores
DROP COLUMN formacion;

--11 VISTAS
CREATE VIEW ap34a (conductor, maquina, proyecto, fecha, tiempo) AS 
SELECT codc, codm, codp, fecha, tiempo 
FROM trabajos 
WHERE fecha > '15/sep/02';

INSERT INTO ap34 VALUES ('C01','M01','P01','03/sep/02',10);

--12
CREATE SYNONYM trab_sep
FOR ap34a;
































