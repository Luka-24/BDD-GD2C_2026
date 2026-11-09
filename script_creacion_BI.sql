USE [GD2C_2026]
GO
/*
 ------1. Facturación total mensual en ventas de cada local

2. Ticket promedio ($) de venta mensual por tipo de producto (bicicletas o
accesorios) y rango etario del cliente.

3. Porcentaje de ventas trimestrales según tipo de producto (bicicletas o accesorios)
por local.

4. Promedio de cantidad de horas de alquiler de bicicletas, por local y mes

5. Top 5 categorías de bicicleta más alquilados, por año

6. Desvío promedio de reparaciones (en días), entre fecha de entrega estimada y
real, por local y trimestre.

7. Ranking de categoría de repuestos más utilizados por mes.

8. Porcentaje de facturación de reparaciones según el tipo de ingreso de reparación
(mano de obra o repuestos) por trimestre

9. Promedio de unidades (cantidad) compradas según el tipo de producto
(bicicletas o accesorios) por trimestre.

10. Importe total de compras mensuales por local.

11. Facturación mensual del negocio (ventas + alquileres + reparaciones) por local.*/

-- PUNTO 1: Facturación total mensual en ventas de cada local

-- Dimension Tiempo: una fila por anio-mes
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Tiempo (
    id_tiempo INT IDENTITY(1,1),
    anio INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL,

    CONSTRAINT PK_BI_Tiempo PRIMARY KEY (id_tiempo),
    CONSTRAINT UQ_BI_Tiempo UNIQUE (anio, mes)
);

-- Agrupo por local
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Local (
    id_local INT,
    nombre_local VARCHAR(255) NULL,

    CONSTRAINT PK_BI_Local PRIMARY KEY (id_local)
);

-- Hechos Ventas: una fila por tiempo + local
-- Para los otros puntos seguro tenemos que ampliarlo
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas (
    id_tiempo INT,
    id_local INT,
    monto_total NUMERIC(38, 2),

    CONSTRAINT PK_BI_HechosVentas PRIMARY KEY (id_tiempo, id_local),
    CONSTRAINT FK_BI_HechosVentas_Tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tiempo (id_tiempo),
    CONSTRAINT FK_BI_HechosVentas_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.BI_Local (id_local)
);

-- Carga BI_Tiempo con los anio-mes de las fechas de venta
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Tiempo
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Tiempo (anio, trimestre, mes)
        SELECT DISTINCT YEAR(fecha_hora_venta), DATEPART(QUARTER, fecha_hora_venta), MONTH(fecha_hora_venta)
        FROM SOMOS_QUATRO_LOCOS.Venta
        WHERE fecha_hora_venta IS NOT NULL
END;

-- copio los locales 
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Local
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Local (id_local, nombre_local)
        SELECT id_local, nombre_local
        FROM SOMOS_QUATRO_LOCOS.Local
END;

--sumo el total de cada venta por mes y local
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Ventas
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas (id_tiempo, id_local, monto_total)
        SELECT T.id_tiempo, V.id_local, SUM(V.total_venta)
        FROM SOMOS_QUATRO_LOCOS.Venta V
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T
            ON T.anio = YEAR(V.fecha_hora_venta) AND T.mes = MONTH(V.fecha_hora_venta)
        WHERE V.id_local IS NOT NULL
        GROUP BY T.id_tiempo, V.id_local
END;

GO
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Tiempo;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Local;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Ventas;


-- Indicador 1: facturacion total mensual en ventas de cada local
GO
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Facturacion_Ventas_Mensual
AS
    SELECT
        T.anio,
        T.mes,
        L.id_local,
        L.nombre_local,
        SUM(H.monto_total) AS facturacion_total
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas H
    JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = H.id_tiempo
    JOIN SOMOS_QUATRO_LOCOS.BI_Local L ON L.id_local = H.id_local
    GROUP BY T.anio, T.mes, L.id_local, L.nombre_local;