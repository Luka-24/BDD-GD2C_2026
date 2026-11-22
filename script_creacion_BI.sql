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


------ DIMENSIONES --------


-- Dimension Tiempo: una fila por anio-mes
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Tiempo' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Tiempo (
    id_tiempo INT IDENTITY(1,1),
    anio INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL,

    CONSTRAINT PK_BI_Tiempo PRIMARY KEY (id_tiempo),
    CONSTRAINT UQ_BI_Tiempo UNIQUE (anio, mes)
);

-- Agrupo por local
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Local' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Local (
    id_local INT,
    nombre_local VARCHAR(255) NULL,

    CONSTRAINT PK_BI_Local PRIMARY KEY (id_local)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Tipo_Producto' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Tipo_Producto (
    nro_tipo_producto INT,
    tipo_producto VARCHAR(255) NULL,
 
    CONSTRAINT PK_BI_TipoProducto PRIMARY KEY (nro_tipo_producto)
);
 
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Rango_Etario' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Rango_Etario (
    id_rango_etario INT,
    descripcion VARCHAR(255) NOT NULL,
 
    CONSTRAINT PK_BI_RangoEtario PRIMARY KEY (id_rango_etario)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Categoria_Bicicleta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Categoria_Bicicleta (
    id_categoria_bicicleta INT,
    categoria_bicicleta VARCHAR(255) NOT NULL,
 
    CONSTRAINT PK_BI_CategoriaBicicleta PRIMARY KEY (id_categoria_bicicleta)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Categoria_Repuesto' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Categoria_Repuesto (
    id_categoria_repuesto INT,
    categoria_repuesto VARCHAR(255) NOT NULL,

    CONSTRAINT PK_BI_CategoriaRepuesto PRIMARY KEY (id_categoria_repuesto)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Tipo_Ingreso_Reparacion' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Tipo_Ingreso_Reparacion (
    id_tipo_ingreso INT,
    descripcion VARCHAR(255) NOT NULL,

    CONSTRAINT PK_BI_TipoIngresoReparacion PRIMARY KEY (id_tipo_ingreso)
);



------ HECHOS ------
-- Hechos Ventas: una fila por tiempo + local + tipo de producto + rango etario
-- Para los otros puntos seguro tenemos que ampliarlo
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Hechos_Ventas' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas (
    id_tiempo INT,
    id_local INT,
    nro_tipo_producto INT,
    id_rango_etario INT,
    cantidad_ventas INT,
    monto_total NUMERIC(38, 2),
 
    CONSTRAINT PK_BI_HechosVentas PRIMARY KEY (id_tiempo, id_local, nro_tipo_producto, id_rango_etario),
    CONSTRAINT FK_BI_HechosVentas_Tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tiempo (id_tiempo),
    CONSTRAINT FK_BI_HechosVentas_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.BI_Local (id_local),
    CONSTRAINT FK_BI_HechosVentas_TipoProducto FOREIGN KEY (nro_tipo_producto) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tipo_Producto (nro_tipo_producto),
    CONSTRAINT FK_BI_HechosVentas_RangoEtario FOREIGN KEY (id_rango_etario) REFERENCES SOMOS_QUATRO_LOCOS.BI_Rango_Etario (id_rango_etario)
);


---- ALQUILERES ----
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Hechos_Alquileres' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Hechos_Alquileres (
    id_tiempo INT,
    id_local INT,
    id_categoria_bicicleta INT,
    cantidad_alquileres INT,
    cantidad_alquileres_devueltos INT,
    cantidad_horas NUMERIC(18, 2),
    monto_total NUMERIC(38, 2),

    CONSTRAINT PK_BI_HechosAlquileres PRIMARY KEY (id_tiempo, id_local, id_categoria_bicicleta),
    CONSTRAINT FK_BI_HechosAlquileres_Tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tiempo (id_tiempo),
    CONSTRAINT FK_BI_HechosAlquileres_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.BI_Local (id_local),
    CONSTRAINT FK_BI_HechosAlquileres_CategoriaBicicleta FOREIGN KEY (id_categoria_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.BI_Categoria_Bicicleta (id_categoria_bicicleta)
);

--- REPARACIONES ---
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Hechos_Reparaciones' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones (
    id_tiempo INT,
    id_local INT,
    promedio_dias_diferencia_fecha_entega INT,

    CONSTRAINT PK_BI_HechosReparaciones PRIMARY KEY (id_tiempo, id_local),
    CONSTRAINT FK_BI_HechosReparaciones_Tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tiempo,
    CONSTRAINT FK_BI_HechosReparaciones_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.BI_Local (id_local)
)
-- lo separe en reparaciones_ingresos porque estaria conceptualmente mal hacer una unica tabla para todos los datos, dado que son de distinta granularidad
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Hechos_Reparaciones_Ingresos' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones_Ingresos (
    id_tiempo INT,
    id_local INT,
    id_tipo_ingreso INT,
    monto_total NUMERIC(38, 2),

    CONSTRAINT PK_BI_HechosReparacionesIngresos PRIMARY KEY (id_tiempo, id_local, id_tipo_ingreso),
    CONSTRAINT FK_BI_HechosReparacionesIngresos_Tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tiempo (id_tiempo),
    CONSTRAINT FK_BI_HechosReparacionesIngresos_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.BI_Local (id_local),
    CONSTRAINT FK_BI_HechosReparacionesIngresos_TipoIngreso FOREIGN KEY (id_tipo_ingreso) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tipo_Ingreso_Reparacion (id_tipo_ingreso)
);

----- REPUESTOS -----
-- Una fila por tiempo + local + categoría de repuesto
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Hechos_Repuestos' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Hechos_Repuestos (
    id_tiempo INT,
    id_local INT,
    id_categoria_repuesto INT,
    cantidad_repuestos INT,
    monto_total NUMERIC(38, 2),

    CONSTRAINT PK_BI_HechosRepuestos PRIMARY KEY (id_tiempo, id_local, id_categoria_repuesto),
    CONSTRAINT FK_BI_HechosRepuestos_Tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tiempo (id_tiempo),
    CONSTRAINT FK_BI_HechosRepuestos_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.BI_Local (id_local),
    CONSTRAINT FK_BI_HechosRepuestos_Categoria FOREIGN KEY (id_categoria_repuesto) REFERENCES SOMOS_QUATRO_LOCOS.BI_Categoria_Repuesto (id_categoria_repuesto)
);

----- COMPRAS -----
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BI_Hechos_Compras' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.BI_Hechos_Compras (
    id_tiempo INT,
    id_local INT,
    nro_tipo_producto INT,
    cantidad_items INT,        -- cantidad de renglones de detalle de compra
    cantidad_unidades INT,     -- unidades compradas
    monto_total NUMERIC(38, 2),

    CONSTRAINT PK_BI_HechosCompras PRIMARY KEY (id_tiempo, id_local, nro_tipo_producto),
    CONSTRAINT FK_BI_HechosCompras_Tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tiempo (id_tiempo),
    CONSTRAINT FK_BI_HechosCompras_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.BI_Local (id_local),
    CONSTRAINT FK_BI_HechosCompras_TipoProducto FOREIGN KEY (nro_tipo_producto) REFERENCES SOMOS_QUATRO_LOCOS.BI_Tipo_Producto (nro_tipo_producto)
);


------ INDICES --------- de tiempo no?
CREATE NONCLUSTERED INDEX INX_BI_HechosVentas_Local ON SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas (id_local);
CREATE NONCLUSTERED INDEX INX_BI_HechosVentas_TipoProducto ON SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas (nro_tipo_producto);
CREATE NONCLUSTERED INDEX INX_BI_HechosVentas_RangoEtario ON SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas (id_rango_etario);
CREATE NONCLUSTERED INDEX INX_BI_HechosAlquileres_Local ON SOMOS_QUATRO_LOCOS.BI_Hechos_Alquileres (id_local);
CREATE NONCLUSTERED INDEX INX_BI_HechosAlquileres_CategoriaBicicleta ON SOMOS_QUATRO_LOCOS.BI_Hechos_Alquileres (id_categoria_bicicleta);
CREATE NONCLUSTERED INDEX INX_BI_HechosReparaciones_Local ON SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones (id_local);
CREATE NONCLUSTERED INDEX INX_BI_HechosRepuestos_Local ON SOMOS_QUATRO_LOCOS.BI_Hechos_Repuestos (id_local);
CREATE NONCLUSTERED INDEX INX_BI_HechosRepuestos_Categoria ON SOMOS_QUATRO_LOCOS.BI_Hechos_Repuestos (id_categoria_repuesto);
CREATE NONCLUSTERED INDEX INX_BI_HechosReparacionesIngresos_Local ON SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones_Ingresos (id_local);
CREATE NONCLUSTERED INDEX INX_BI_HechosReparacionesIngresos_TipoIngreso ON SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones_Ingresos (id_tipo_ingreso);
CREATE NONCLUSTERED INDEX INX_BI_HechosCompras_Local ON SOMOS_QUATRO_LOCOS.BI_Hechos_Compras (id_local);
CREATE NONCLUSTERED INDEX INX_BI_HechosCompras_TipoProducto ON SOMOS_QUATRO_LOCOS.BI_Hechos_Compras (nro_tipo_producto);


------ MIGRAR DIMECIONES
-- Carga BI_Tiempo con los anio-mes de las fechas de venta
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Tiempo
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Tiempo (anio, trimestre, mes)
        SELECT DISTINCT YEAR(F.fecha), DATEPART(QUARTER, F.fecha), MONTH(F.fecha)
        FROM (
            SELECT fecha_hora_venta AS fecha FROM SOMOS_QUATRO_LOCOS.Venta
            UNION
            SELECT fecha_inicio_alquiler FROM SOMOS_QUATRO_LOCOS.Alquiler
            UNION
            SELECT fecha_ingreso_reparacion FROM SOMOS_QUATRO_LOCOS.Reparacion
            UNION
            SELECT fecha_compra FROM SOMOS_QUATRO_LOCOS.Compra
        ) AS F
        WHERE F.fecha IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Local
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Local (id_local, nombre_local)
        SELECT id_local, nombre_local
        FROM SOMOS_QUATRO_LOCOS.Local
END;


GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_TipoProducto
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Tipo_Producto (nro_tipo_producto, tipo_producto)
        SELECT nro_tipo_producto, tipo_producto FROM SOMOS_QUATRO_LOCOS.Tipo_Producto
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_RangoEtario
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Rango_Etario (id_rango_etario, descripcion)
    VALUES (1, 'Menores de 25 o igual'), (2, 'Entre 26 y 35'), (3, 'Entre 36 y 50'), (4, 'Mayores de 50'), (5, 'Sin dato')
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_CategoriaBicicleta
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Categoria_Bicicleta (id_categoria_bicicleta, categoria_bicicleta)
    SELECT id_categoria_bicicleta, categoria_bicicleta FROM SOMOS_QUATRO_LOCOS.categoria_bicicleta
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_CategoriaRepuesto
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Categoria_Repuesto (id_categoria_repuesto, categoria_repuesto)
        SELECT id_categoria_repuesto, categoria_repuesto
        FROM SOMOS_QUATRO_LOCOS.Categoria_Repuesto
        WHERE categoria_repuesto IS NOT NULL
END;

GO

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_TipoIngresoReparacion
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Tipo_Ingreso_Reparacion (id_tipo_ingreso, descripcion)
    VALUES (1, 'Mano de obra'), (2, 'Repuestos')
END;

-------- MIGRAR HECHOS --------

-- Ventas --
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Ventas
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas (id_tiempo, id_local, nro_tipo_producto, id_rango_etario, cantidad_ventas, monto_total)
        SELECT
            T.id_tiempo, X.id_local, X.nro_tipo_producto, X.id_rango_etario,
            COUNT(DISTINCT X.nro_venta), SUM(X.subtotal_prod_venta)
        FROM (
            SELECT
                Y.nro_venta, Y.id_local, Y.nro_tipo_producto, Y.anio, Y.mes, Y.subtotal_prod_venta,
                CASE
                    WHEN Y.edad IS NULL THEN 5
                    WHEN Y.edad <= 25 THEN 1
                    WHEN Y.edad <= 35 THEN 2
                    WHEN Y.edad <= 50 THEN 3
                    ELSE 4
                END AS id_rango_etario
            FROM (
                -- (diferencia de años, menos 1 si todavia no cumplio años ese año)
                SELECT
                    V.nro_venta, V.id_local, P.nro_tipo_producto,
                    YEAR(V.fecha_hora_venta) AS anio,
                    MONTH(V.fecha_hora_venta) AS mes,
                    DV.subtotal_prod_venta,
                    DATEDIFF(YEAR, C.fecha_nacimiento_cliente, V.fecha_hora_venta)
                            - 
                            CASE WHEN MONTH(C.fecha_nacimiento_cliente) * 100 + DAY(C.fecha_nacimiento_cliente)
                                  > MONTH(V.fecha_hora_venta) * 100 + DAY(V.fecha_hora_venta)
                               THEN 1 ELSE 0 END AS edad
                FROM SOMOS_QUATRO_LOCOS.Venta V
                JOIN SOMOS_QUATRO_LOCOS.Detalle_Venta DV ON DV.nro_venta = V.nro_venta
                JOIN SOMOS_QUATRO_LOCOS.Producto P ON P.cod_producto = DV.cod_producto
                LEFT JOIN SOMOS_QUATRO_LOCOS.Cliente C ON C.nro_cliente = V.nro_cliente
                WHERE V.id_local IS NOT NULL
                  AND V.fecha_hora_venta IS NOT NULL
                  AND P.nro_tipo_producto IS NOT NULL
            ) AS Y
        ) AS X
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.anio = X.anio AND T.mes = X.mes
        GROUP BY T.id_tiempo, X.id_local, X.nro_tipo_producto, X.id_rango_etario
END;

-- Alquileres --
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Alquileres
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Hechos_Alquileres (id_tiempo, id_local, id_categoria_bicicleta, cantidad_alquileres, cantidad_horas, monto_total)
        SELECT T.id_tiempo, A.id_local, MB.id_categoria_bicicleta, COUNT(DISTINCT A.nro_alquiler) AS cantidad_alquileres, CAST(SUM(DATEDIFF(HOUR, A.fecha_inicio_alquiler, A.fecha_devolucion_real_alquiler)) AS NUMERIC(10,1)) AS cantidad_horas, SUM(A.importe_total_alquiler)
        FROM SOMOS_QUATRO_LOCOS.Alquiler A
            LEFT JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.anio = YEAR(A.fecha_inicio_alquiler) AND T.mes = MONTH(A.fecha_inicio_alquiler)
            LEFT JOIN SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler BA ON BA.nro_serie_bicicleta = A.nro_serie_bicicleta
            JOIN SOMOS_QUATRO_LOCOS.Modelo_Bicicleta MB ON MB.modelo_bicicleta = BA.modelo_bicicleta
        GROUP BY T.id_tiempo, A.id_local, MB.id_categoria_bicicleta
        ORDER BY 1, 2, 3
END;
GO
-- Repuestos --
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Repuestos
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Hechos_Repuestos (id_tiempo, id_local, id_categoria_repuesto, cantidad_repuestos, monto_total)
        SELECT T.id_tiempo, R.id_local, REP.id_categoria,
               SUM(DR.cantidad_repuesto), SUM(DR.subtotal_repuesto)
        FROM SOMOS_QUATRO_LOCOS.Detalle_Reparacion DR
            JOIN SOMOS_QUATRO_LOCOS.Reparacion R ON R.nro_reparacion = DR.nro_reparacion
            JOIN SOMOS_QUATRO_LOCOS.Repuesto REP ON REP.cod_repuesto = DR.cod_repuesto
            JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.anio = YEAR(R.fecha_ingreso_reparacion)
                                               AND T.mes = MONTH(R.fecha_ingreso_reparacion)
        WHERE R.id_local IS NOT NULL
          AND REP.id_categoria IS NOT NULL
        GROUP BY T.id_tiempo, R.id_local, REP.id_categoria
END;

-- Reparaciones --

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Reparaciones
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones (id_tiempo, id_local, promedio_dias_diferencia_fecha_entega)
    SELECT 
        T.id_tiempo, R.id_local, 
        AVG(1.0 * DATEDIFF(DAY, R.fecha_entrega_estimada_reparacion, R.fecha_entrega_real_reparacion)) AS promedio_dias_diferencia_fecha_entega
    FROM SOMOS_QUATRO_LOCOS.Reparacion R 
        LEFT JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.anio = YEAR(R.fecha_ingreso_reparacion) AND T.mes = MONTH(R.fecha_ingreso_reparacion)
    GROUP BY T.id_tiempo, R.id_local
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Reparaciones_Ingresos
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones_Ingresos (id_tiempo, id_local, id_tipo_ingreso, monto_total)
        SELECT T.id_tiempo, R.id_local, X.id_tipo_ingreso, SUM(X.monto)
        FROM SOMOS_QUATRO_LOCOS.Reparacion R
            JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.anio = YEAR(R.fecha_ingreso_reparacion)
                                               AND T.mes = MONTH(R.fecha_ingreso_reparacion)
            -- una fila de Reparacion pasa a dos filas: una por tipo de ingreso
            CROSS APPLY (VALUES (1, R.precio_mano_obra_reparacion),
                                (2, R.precio_repuestos_reparacion)) AS X(id_tipo_ingreso, monto)
        WHERE R.id_local IS NOT NULL
          AND R.fecha_ingreso_reparacion IS NOT NULL
          AND X.monto IS NOT NULL
        GROUP BY T.id_tiempo, R.id_local, X.id_tipo_ingreso
END;

-- Compras --
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Compras
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.BI_Hechos_Compras (id_tiempo, id_local, nro_tipo_producto, cantidad_items, cantidad_unidades, monto_total)
        SELECT T.id_tiempo, C.id_local, P.nro_tipo_producto,
               COUNT(*), SUM(DC.cantidad_prod_compra), SUM(DC.subtotal)
        FROM SOMOS_QUATRO_LOCOS.Compra C
            JOIN SOMOS_QUATRO_LOCOS.Detalle_Compra DC ON DC.nro_compra = C.nro_compra
            JOIN SOMOS_QUATRO_LOCOS.Producto P ON P.cod_producto = DC.cod_producto
            JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.anio = YEAR(C.fecha_compra)
                                               AND T.mes = MONTH(C.fecha_compra)
        WHERE C.id_local IS NOT NULL
          AND C.fecha_compra IS NOT NULL
          AND P.nro_tipo_producto IS NOT NULL
        GROUP BY T.id_tiempo, C.id_local, P.nro_tipo_producto
END;

-------- VISTAS ----------

GO
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Facturacion_Ventas_Mensual
AS
    SELECT
        T.anio, T.mes, L.id_local, L.nombre_local,
        SUM(H.monto_total) AS facturacion_total
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas H
    JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = H.id_tiempo
    JOIN SOMOS_QUATRO_LOCOS.BI_Local L ON L.id_local = H.id_local
    GROUP BY T.anio, T.mes, L.id_local, L.nombre_local;
GO
 
-- Indicador 2: ticket promedio ($) de venta mensual por tipo de producto y rango etario del cliente
-- Ticket promedio = monto total / cantidad de ventas (se suman ambos y recien ahi se divide)
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Ticket_Promedio_Mensual
AS
    SELECT
        T.anio, T.mes, TP.tipo_producto, RE.descripcion AS rango_etario,
        CAST(SUM(H.monto_total) / NULLIF(SUM(H.cantidad_ventas), 0) AS NUMERIC(38, 2)) AS ticket_promedio
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas H
    JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = H.id_tiempo
    JOIN SOMOS_QUATRO_LOCOS.BI_Tipo_Producto TP ON TP.nro_tipo_producto = H.nro_tipo_producto
    JOIN SOMOS_QUATRO_LOCOS.BI_Rango_Etario RE ON RE.id_rango_etario = H.id_rango_etario
    GROUP BY T.anio, T.mes, TP.nro_tipo_producto, TP.tipo_producto, RE.id_rango_etario, RE.descripcion;
GO

-- Indicador 3: Porcentaje de ventas trimestrales según tipo de producto (bicicletas o accesorios) por local
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Porcentaje_Ventas_Trimestrales
AS
    SELECT 
        L.nombre_local, T.anio, T.trimestre, TP.tipo_producto,
       CAST(100.0 * SUM(V.cantidad_ventas) / TV.total_ventas AS DECIMAL(5,2)) AS porcentaje
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas V
        JOIN SOMOS_QUATRO_LOCOS.BI_Local L ON L.id_local = V.id_local
        JOIN SOMOS_QUATRO_LOCOS.BI_Tipo_Producto TP ON TP.nro_tipo_producto = V.nro_tipo_producto
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = V.id_tiempo
        JOIN (
        SELECT V.id_local, T.anio, T.trimestre, SUM(V.cantidad_ventas) AS total_ventas
            FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas V
                JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = V.id_tiempo
        GROUP BY V.id_local, T.anio, T.trimestre
        ) TV ON TV.id_local = L.id_local AND TV.anio = T.anio AND TV.trimestre = T.trimestre
    GROUP BY L.id_local, L.nombre_local, T.anio, T.trimestre, TP.tipo_producto, TV.total_ventas
    -- ORDER BY 1, 2, 3, 4 me parece que el orden se pone al consultar
GO

-- Indicador 4: Promedio de cantidad de horas de alquiler de bicicletas, por local y mes
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Cant_Horas_Alquiler_Bicicleta
AS
    SELECT L.nombre_local, T.anio, T.mes, CAST(AVG(HA.cantidad_horas) AS NUMERIC(20,2)) AS promedio_horas
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Alquileres HA
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = HA.id_tiempo
        JOIN SOMOS_QUATRO_LOCOS.BI_Local L ON L.id_local = HA.id_local
    GROUP BY L.id_local, L.nombre_local, T.anio, T.mes
GO


-- Indicador 5: Top 5 categorias de bicicleta mas alquiladas, por año
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Top5_Categorias_Alquiladas
AS
    WITH Totales AS (
        SELECT T.anio, CB.id_categoria_bicicleta, CB.categoria_bicicleta, SUM(HA.cantidad_alquileres) AS cantidad_alquileres
        FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Alquileres HA
            JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = HA.id_tiempo
            JOIN SOMOS_QUATRO_LOCOS.BI_Categoria_Bicicleta CB ON CB.id_categoria_bicicleta = HA.id_categoria_bicicleta
        GROUP BY T.anio, CB.id_categoria_bicicleta, CB.categoria_bicicleta
    )
    SELECT R.anio, R.ranking, R.categoria_bicicleta, R.cantidad_alquileres
    FROM (
        SELECT A.anio, A.categoria_bicicleta, A.cantidad_alquileres,
            (SELECT COUNT(*) FROM Totales B
             WHERE B.anio = A.anio
               AND (B.cantidad_alquileres > A.cantidad_alquileres OR (B.cantidad_alquileres = A.cantidad_alquileres
                                                                        AND B.id_categoria_bicicleta < A.id_categoria_bicicleta))) + 1 AS ranking
        FROM Totales A
    ) R
    WHERE R.ranking <= 5
GO

-- Indicador 6. Desvío promedio de reparaciones (en días), entre fecha de entrega estimada y real, por local y trimestre
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Promedio_Desvio_Reparaciones
AS
    SELECT id_local, T.anio, T.trimestre, AVG(R.promedio_dias_diferencia_fecha_entega) AS promedio_dias_diferencia_fecha_entega
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones R
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = R.id_tiempo
    GROUP BY id_local, T.anio, T.trimestre
GO

-- Indicador 7: Ranking de categoría de repuestos más utilizados por mes.
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Ranking_Categorias_Repuestos_Mensual
AS
    WITH Totales AS (
        SELECT T.anio, T.mes, CR.id_categoria_repuesto, CR.categoria_repuesto,
               SUM(HR.cantidad_repuestos) AS cantidad_repuestos
        FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Repuestos HR
            JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = HR.id_tiempo
            JOIN SOMOS_QUATRO_LOCOS.BI_Categoria_Repuesto CR ON CR.id_categoria_repuesto = HR.id_categoria_repuesto
        GROUP BY T.anio, T.mes, CR.id_categoria_repuesto, CR.categoria_repuesto
    )
    SELECT A.anio, A.mes, A.categoria_repuesto, A.cantidad_repuestos,
        (SELECT COUNT(*) FROM Totales B
         WHERE B.anio = A.anio AND B.mes = A.mes
           AND (B.cantidad_repuestos > A.cantidad_repuestos
                OR (B.cantidad_repuestos = A.cantidad_repuestos
                    AND B.id_categoria_repuesto < A.id_categoria_repuesto))) + 1 AS ranking
    FROM Totales A
GO

-- Indicador 8: Porcentaje de facturación de reparaciones según el tipo de ingreso de reparación (mano de obra o repuestos) por trimestre
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Porcentaje_Facturacion_Reparaciones
AS
    SELECT
        T.anio, T.trimestre, TI.descripcion AS tipo_ingreso,
        CAST(100.0 * SUM(H.monto_total) / NULLIF(TT.total_trimestre, 0) AS DECIMAL(5,2)) AS porcentaje
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones_Ingresos H
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = H.id_tiempo
        JOIN SOMOS_QUATRO_LOCOS.BI_Tipo_Ingreso_Reparacion TI ON TI.id_tipo_ingreso = H.id_tipo_ingreso
        JOIN (
            SELECT T2.anio, T2.trimestre, SUM(H2.monto_total) AS total_trimestre
            FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones_Ingresos H2
                JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T2 ON T2.id_tiempo = H2.id_tiempo
            GROUP BY T2.anio, T2.trimestre
        ) TT ON TT.anio = T.anio AND TT.trimestre = T.trimestre
    GROUP BY T.anio, T.trimestre, TI.id_tipo_ingreso, TI.descripcion, TT.total_trimestre
GO
-- Indicador 9: Promedio de unidades (cantidad) compradas según el tipo de producto (bicicletas o accesorios) por trimestre
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Promedio_Unidades_Compradas_Trimestral
AS
    SELECT
        T.anio, T.trimestre, TP.tipo_producto,
        CAST(1.0 * SUM(H.cantidad_unidades) / NULLIF(SUM(H.cantidad_items), 0) AS NUMERIC(10, 2)) AS promedio_unidades
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Compras H
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = H.id_tiempo
        JOIN SOMOS_QUATRO_LOCOS.BI_Tipo_Producto TP ON TP.nro_tipo_producto = H.nro_tipo_producto
    GROUP BY T.anio, T.trimestre, TP.nro_tipo_producto, TP.tipo_producto
GO

-- Indicador 10: Importe total de compras mensuales por local   
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Importe_Compras_Mensual
AS
    SELECT
        T.anio, T.mes, L.id_Local, L.nombre_local,
        SUM(H.monto_total) AS importe_total_compras
    FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Compras H
    JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = H.id_tiempo
    JOIN SOMOS_QUATRO_LOCOS.BI_Local L ON L.id_local = H.id_local
    GROUP BY T.anio, T.mes, L.id_Local, L.nombre_local;
GO

-- Indicador 11: Facturación mensual del negocio (ventas + alquileres + reparaciones)  por local.
CREATE VIEW SOMOS_QUATRO_LOCOS.BI_Vista_Facturacion_Mensual_Total
AS
    SELECT
        T.anio, T.mes, L.id_local, L.nombre_local,
        SUM(F.monto_total) AS facturacion_total
    FROM (
        SELECT id_tiempo, id_local, monto_total
        FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Ventas
        UNION ALL
        SELECT id_tiempo, id_local, monto_total
        FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Alquileres
        UNION ALL
        SELECT id_tiempo, id_local, monto_total
        FROM SOMOS_QUATRO_LOCOS.BI_Hechos_Reparaciones_Ingresos
    ) F
        JOIN SOMOS_QUATRO_LOCOS.BI_Tiempo T ON T.id_tiempo = F.id_tiempo
        JOIN SOMOS_QUATRO_LOCOS.BI_Local L ON L.id_local = F.id_local
    GROUP BY T.anio, T.mes, L.id_local, L.nombre_local
GO
---- EXECUTE -----
GO
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Tiempo;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Local;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_TipoProducto;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_RangoEtario;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_CategoriaBicicleta;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Ventas;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Alquileres;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Reparaciones;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_CategoriaRepuesto;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Repuestos;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_TipoIngresoReparacion;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Reparaciones_Ingresos;
EXEC SOMOS_QUATRO_LOCOS.BI_Migrar_Hechos_Compras;