----EJERCICIO 1 
SELECT d.nombre AS "UNIDAD",
       m.pnombre || ' ' || m.apterno || ' ' || m.amaterno AS "MEDICO",
       SUBSTR(d.nombre,1,2) || '' || SUBSTR(apaterno,-3,2) || '' || SUBSTR(m.telefono,1,3) || '' || TO_CHAR(fecha_contrato,'YYYY') || '' || '@medicocktk.cl' AS "CORREO MEDICO",
       COUNT(ate_id) AS "ATENCIONES MEDICAS"
FROM medico m
INNER JOIN unidad d
        ON m.uni_id=d.uni_id
LEFT JOIN atencion a
        ON m.med_rut=a.med_rut
GROUP BY d.nombre, m.pnombre, m.apaterno, m.amaterno, m.telefono, fecha_contrato
HAVING COUNT (ate_id)<(SELECT MAX(COUNT(ate_id))
                       FROM medico m 
                       INNER JOIN atencion a
                         ON m.med_rut=a.med_rut
                       WHERE fecha_atencion BETWEEN TO_DATE('010117') AND TO_DATE('311217')
                       GROUP BY dv_rut)
ORDER BY d.nombre ASC, m.aparterno ASC;

------EJERCICIO 2.1
SELECT TO_CHAR(fecha_atencion, 'MM/YYYY') AS "MES Y AÑO",
       COUNT(ate_id) AS "TOTAL DE ATENCIONES",
       costo AS "VALOR TOTAL DE LAS ATENCIONES"
FROM atencion
GROUP BY fecha_atencion, costo
HAVING COUNT (ate_id)>(SELECT ROUND (AVG(COUNT(a.ate_id)))
                       FROM medico m
                       INNER JOIN atencion a
                         ON m.med_rut=a.med_rut
                       WHERE fecha_atencion BETWEEN TO_DATE('010117') AND TO_DATE('311217')
                       GROUP BY m.med_rut)
ORDER BY EXTRACT(MONTH FROM fecha_atencion), EXTRACT(YEAR FROM fecha_atencion);                       
--------EJERCICIO 2.2

-------EJERCICIO 3
SELECT t.descripcion AS "SISTEMA DE SALUD"
       COUNT(ate_id) AS "TOTAL ATENCIONES"
FROM atencion a
INNER JOIN paciente p
    ON a.pac_rut=p.pac_rut
INNER JOIN salud s
    ON p.sal_id=s.sal_id
INNER JOIN tipo_salud t
    ON s.tipo_sal_id=t.tipo_sal_id
WHERE COUNT(ate_id)>(SELECT AVG(COUNT(ate_id))
                     FROM atencion)
HAVING a.fecha_atencion= TO_DATE('010818')
GROUP BY t.descripcion, a.fecha_atencion
ORDER BY "SISTEMA DE SALUD" ASC;