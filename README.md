Resumen de TODOS los cambios del original:
https://claude.ai/share/57601bbd-eade-4e87-917a-c94c24948968 

Importante: 
El TP avisaba que seguro habia inconsistencias en la tabla madre, y que estas no se tienen que corregir, solo avisar de su existencia y como las rodeamos.
Esto es lo que encontre

                     Hallazgo	                                       Tratamiento
25 empleados (mismo DNI) figuran en operaciones de 5     Empleado no tiene id_local. El local de 
locales distintos, contra la regla de                    cada operación se conserva en Venta, Alquiler
“un empleado pertenece a un solo local”                  , Reparacion y Compra



126 DNI de clientes con datos distintos	                Se conserva cada versión como un cliente distinto. 
                                                        Cada operación se asocia a la versión que figura en su fila (G6)

                                                        
Diferencias de centavos entre el total de la            Se migran los importes sin recalcular ni redondear
cabecera y la suma de las líneas (16.522 ventas
y 7.875 reparaciones, con relación 
entre 0,999999 y 1,000000)	
