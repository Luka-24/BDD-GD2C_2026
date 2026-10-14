USE [GD2C_2026]
GO

CREATE SCHEMA SOMOS_QUATRO_LOCOS
GO

--CREACION DE TABLAS:

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Provincia' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Provincia (
    id_provincia INT IDENTITY(1,1),
    provincia VARCHAR(255),

    CONSTRAINT PK_Provincia PRIMARY KEY (id_provincia)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Localidad' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Localidad (
    id_localidad INT IDENTITY(1,1),
    id_provincia INT NULL,
    localidad VARCHAR(255) NULL,

    CONSTRAINT PK_Localidad PRIMARY KEY (id_localidad), 
    CONSTRAINT FK_Localidad_Provincia FOREIGN KEY (id_provincia) REFERENCES SOMOS_QUATRO_LOCOS.Provincia (id_provincia)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Marca' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Marca (
    id_marca INT IDENTITY(1,1),
    marca VARCHAR(255),

    CONSTRAINT PK_Marca PRIMARY KEY (id_marca)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Estado_Reparacion' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Estado_Reparacion (
    id_estado_reparacion INT IDENTITY(1,1),
    estado_reparacion VARCHAR(255),

    CONSTRAINT PK_EstadoReparacion PRIMARY KEY (id_estado_reparacion)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Estado_Alquiler' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Estado_Alquiler (
    id_estado_alquiler INT IDENTITY(1,1),
    estado_alquiler VARCHAR(255) NULL,

    CONSTRAINT PK_EstadoAlquiler PRIMARY KEY (id_estado_alquiler)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Categoria_Accesorio' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Categoria_Accesorio (
    nro_categoria_accesorio INT IDENTITY(1,1),
    categoria_accesorio VARCHAR(255),

    CONSTRAINT PK_CategoriaAccesorio PRIMARY KEY (nro_categoria_accesorio)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Categoria_Bicicleta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Categoria_Bicicleta (
    id_categoria_bicicleta INT IDENTITY(1,1),
    categoria_bicicleta VARCHAR(255),

    CONSTRAINT PK_CategoriaBicicleta PRIMARY KEY (id_categoria_bicicleta)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Tipo_Producto' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Tipo_Producto (
    nro_tipo_producto INT IDENTITY(1,1),
    tipo_producto VARCHAR(255),

    CONSTRAINT PK_TipoProducto PRIMARY KEY (nro_tipo_producto)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Modelo_Bicicleta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (
    modelo_bicicleta VARCHAR(255),
    id_marca INT,
    rodado_modelo_bicicleta VARCHAR(255),
    cuadro_modelo_bicicleta VARCHAR(255),
    color_modelo_bicicleta VARCHAR(255),
    id_categoria_bicicleta INT,

    CONSTRAINT PK_ModeloBicicleta PRIMARY KEY (modelo_bicicleta),
    CONSTRAINT FK_ModeloBicicleta_Marca FOREIGN KEY (id_marca) REFERENCES SOMOS_QUATRO_LOCOS.Marca (id_marca),
    CONSTRAINT FK_ModeloBicicleta_CategoriaBicicleta FOREIGN KEY (id_categoria_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Categoria_Bicicleta (id_categoria_bicicleta)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Bicicleta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Bicicleta (
    nro_serie_bicicleta VARCHAR(255),
    modelo_bicicleta VARCHAR(255),

    CONSTRAINT PK_Bicicleta PRIMARY KEY (nro_serie_bicicleta),
    CONSTRAINT FK_Bicicleta_ModeloBicicleta FOREIGN KEY (modelo_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (modelo_bicicleta)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Producto' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Producto (
    cod_producto VARCHAR(255),
    nombre_producto VARCHAR(255),
    descripcion_producto VARCHAR(255),
    precio_venta_producto NUMERIC(38, 2),
    nro_tipo_producto INT,

    CONSTRAINT PK_Producto PRIMARY KEY (cod_producto),
    CONSTRAINT FK_Producto_TipoProducto FOREIGN KEY (nro_tipo_producto) REFERENCES SOMOS_QUATRO_LOCOS.Tipo_Producto (nro_tipo_producto)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Accesorio' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Accesorio (
    cod_producto VARCHAR(255),
    talle_accesorio VARCHAR(255),
    color_accesorio VARCHAR(255),
    nro_categoria_accesorio INT,
    id_marca INT,

    CONSTRAINT PK_Accesorio PRIMARY KEY (cod_producto),
    CONSTRAINT FK_Accesorio_Producto FOREIGN KEY (cod_producto) REFERENCES SOMOS_QUATRO_LOCOS.Producto (cod_producto),
    CONSTRAINT FK_Accesorio_CategoriaAccesorio FOREIGN KEY (nro_categoria_accesorio) REFERENCES SOMOS_QUATRO_LOCOS.Categoria_Accesorio (nro_categoria_accesorio),
    CONSTRAINT FK_Accesorio_Marca FOREIGN KEY (id_marca) REFERENCES SOMOS_QUATRO_LOCOS.Marca (id_marca)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Bicicleta_Venta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Bicicleta_Venta (
    nro_serie_bicicleta VARCHAR(255),
    meses_garantia_bici_venta INT,
    cod_producto VARCHAR(255),

    CONSTRAINT PK_BicicletaVenta PRIMARY KEY (nro_serie_bicicleta),
    CONSTRAINT FK_BicicletaVenta_Bicicleta FOREIGN KEY (nro_serie_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Bicicleta (nro_serie_bicicleta),
    CONSTRAINT FK_BicicletaVenta_Producto FOREIGN KEY (cod_producto) REFERENCES SOMOS_QUATRO_LOCOS.Producto (cod_producto)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Cliente' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Cliente (
    nro_cliente INT IDENTITY(1,1),
    nombre_cliente VARCHAR(255) NULL,
    apellido_cliente VARCHAR(255) NULL,
    dni_cliente VARCHAR(255) NULL,
    telefono_cliente VARCHAR(255) NULL,
    email_cliente VARCHAR(255) NULL,
    direccion_cliente VARCHAR(255) NULL,
    fecha_nacimiento_cliente DATETIME2(6) NULL,
    id_localidad INT NULL,
    
    CONSTRAINT PK_Cliente PRIMARY KEY (nro_cliente),
    CONSTRAINT FK_Cliente_Localidad FOREIGN KEY (id_localidad) REFERENCES SOMOS_QUATRO_LOCOS.Localidad (id_localidad)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Forma_Pago' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Forma_Pago (
    id_forma_pago INT IDENTITY(1,1),
    forma_pago VARCHAR(255) NULL,

    CONSTRAINT PK_FormaPago PRIMARY KEY (id_forma_pago)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Local' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Local (
    id_local INT IDENTITY(1,1), 
    nombre_local VARCHAR(255) NULL,
    telefono_local VARCHAR(255) NULL,
    email_local VARCHAR(255) NULL,
    direccion_local VARCHAR(255) NULL,
    id_localidad INT NULL,
    

    CONSTRAINT PK_Local PRIMARY KEY (id_local), 
    CONSTRAINT FK_Local_Localidad FOREIGN KEY (id_localidad) REFERENCES SOMOS_QUATRO_LOCOS.Localidad (id_localidad)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Estado_Bicicleta_Alquiler' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Estado_Bicicleta_Alquiler (
    id_estado_bicicleta_alquiler INT IDENTITY(1,1), 
    estado_bicicleta_alquiler VARCHAR(255) NULL,
    

    CONSTRAINT PK_EstadoBicicletaAlquiler PRIMARY KEY (id_estado_bicicleta_alquiler)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Bicicleta_Alquiler' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler (
    nro_serie_bicicleta VARCHAR(255),
    id_estado INT NULL, 
    precio_bici_alquiler_hora DECIMAL(38, 2) NULL,
    precio_bici_alquiler_dia DECIMAL(38, 2) NULL,
    id_local INT NULL,
    

    CONSTRAINT PK_BicicletaAlquiler PRIMARY KEY (nro_serie_bicicleta), 
    CONSTRAINT FK_BicicletaAlquiler_Bicicleta FOREIGN KEY (nro_serie_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Bicicleta (nro_serie_bicicleta),
    CONSTRAINT FK_BicicletaAlquiler_EstadoBicicletaAlquiler FOREIGN KEY (id_estado) REFERENCES SOMOS_QUATRO_LOCOS.Estado_Bicicleta_Alquiler (id_estado_bicicleta_alquiler),
    CONSTRAINT FK_BicicletaAlquiler_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.Local (id_local)
);


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Empleado' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Empleado (
    nro_empleado INT IDENTITY(1,1),
    nombre_empleado VARCHAR(255),
    apellido_empleado VARCHAR(255),
    dni_empleado VARCHAR(255),
    puesto_empleado VARCHAR(255),
    fecha_ingreso_empleado DATETIME2(6) NULL,
    telefono_empleado VARCHAR(255) NULL,
    email_empleado VARCHAR(255) NULL,
    domicilio_empleado VARCHAR(255) NULL,
    fecha_nac_empleado DATETIME2(6) NULL,
    id_local INT,
    id_localidad INT,

    CONSTRAINT PK_Empleado PRIMARY KEY (nro_empleado),
    CONSTRAINT FK_Empleado_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.Local (id_local),
    CONSTRAINT FK_Empleado_Localidad FOREIGN KEY (id_localidad) REFERENCES SOMOS_QUATRO_LOCOS.Localidad (id_localidad)
);


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Venta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Venta (
    nro_venta INT IDENTITY(1,1),
    nro_empleado INT, 
    nro_cliente INT,
    id_forma_pago INT,
    fecha_hora_venta DATETIME2(6) NULL,
    total_venta NUMERIC(38, 2),
    id_local INT,

    CONSTRAINT PK_Venta PRIMARY KEY (nro_venta),
    CONSTRAINT FK_Venta_Empleado FOREIGN KEY (nro_empleado) REFERENCES SOMOS_QUATRO_LOCOS.Empleado (nro_empleado),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (nro_cliente) REFERENCES SOMOS_QUATRO_LOCOS.Cliente (nro_cliente),
    CONSTRAINT FK_Venta_FormaPago FOREIGN KEY (id_forma_pago) REFERENCES SOMOS_QUATRO_LOCOS.Forma_Pago (id_forma_pago),
    constraint FK_Venta_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.Local (id_local)
);


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Detalle_Venta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Detalle_Venta (
    nro_venta INT,
    cod_producto VARCHAR(255),
    cantidad_prod_venta INT,
    precio_unitario_prod_venta NUMERIC(38, 2),
    subtotal_prod_venta NUMERIC(38, 2),

    CONSTRAINT PK_DetalleVenta_Producto PRIMARY KEY (cod_producto, nro_venta),
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (nro_venta) REFERENCES SOMOS_QUATRO_LOCOS.Venta (nro_venta),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (cod_producto) REFERENCES SOMOS_QUATRO_LOCOS.Producto (cod_producto)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Alquiler' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Alquiler (
    nro_alquiler INT IDENTITY(1,1),
    nro_empleado INT NULL, 
    nro_cliente INT NULL,
    id_forma_pago INT NULL,
    id_estado INT NULL,
    nro_serie_bicicleta VARCHAR(255) NULL,
    fecha_fin_pactada_alquiler DATETIME2(6) NULL,
    fecha_devolucion_real_alquiler DATETIME2(6) NULL,
    fecha_inicio_alquiler DATETIME2(6) NULL,
    importe_total_alquiler NUMERIC(38, 2) NULL,
    id_local INT,

    CONSTRAINT PK_Alquiler PRIMARY KEY (nro_alquiler),
    CONSTRAINT FK_Alquiler_Empleado FOREIGN KEY (nro_empleado) REFERENCES SOMOS_QUATRO_LOCOS.Empleado (nro_empleado),
    CONSTRAINT FK_Alquiler_Cliente FOREIGN KEY (nro_cliente) REFERENCES SOMOS_QUATRO_LOCOS.Cliente (nro_cliente),
    CONSTRAINT FK_Alquiler_FormaPago FOREIGN KEY (id_forma_pago) REFERENCES SOMOS_QUATRO_LOCOS.Forma_Pago (id_forma_pago),
    CONSTRAINT FK_Alquiler_EstadoAlquiler FOREIGN KEY (id_estado) REFERENCES SOMOS_QUATRO_LOCOS.Estado_Alquiler (id_estado_alquiler),
    CONSTRAINT FK_Alquiler_SerieBicicleta FOREIGN KEY (nro_serie_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Bicicleta (nro_serie_bicicleta),
    CONSTRAINT FK_Alquiler_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.Local (id_local)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Reparacion' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Reparacion (
    nro_reparacion INT IDENTITY(1,1),
    nro_empleado INT NULL,
    nro_cliente INT NULL,
    nro_serie_bicicleta VARCHAR(255) NULL,
    fecha_ingreso_reparacion DATETIME2(6) NULL,
    fecha_entrega_estimada_reparacion DATETIME2(6) NULL,
    fecha_entrega_real_reparacion DATETIME2(6) NULL,
    id_local INT NULL,
    precio_mano_obra_reparacion NUMERIC(38, 2) NULL,
    precio_repuestos_reparacion NUMERIC(38, 2) NULL,
    precio_total_reparacion NUMERIC(38, 2) NULL,
    id_estado INT NULL,
    diagnostico_reparacion VARCHAR(255) NULL,

    CONSTRAINT PK_Reparacion PRIMARY KEY (nro_reparacion),
    CONSTRAINT FK_Reparacion_Empleado FOREIGN KEY (nro_empleado) REFERENCES SOMOS_QUATRO_LOCOS.Empleado (nro_empleado),
    CONSTRAINT FK_Reparacion_Cliente FOREIGN KEY (nro_cliente) REFERENCES SOMOS_QUATRO_LOCOS.Cliente (nro_cliente),
    CONSTRAINT FK_Reparacion_Bicicleta FOREIGN KEY (nro_serie_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Bicicleta (nro_serie_bicicleta),
    CONSTRAINT FK_Reparacion_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.Local (id_local),
    CONSTRAINT FK_Reparacion_Estado FOREIGN KEY (id_estado) REFERENCES SOMOS_QUATRO_LOCOS.Estado_Reparacion (id_estado_reparacion)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Categoria_Repuesto' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Categoria_Repuesto (
    id_categoria_repuesto INT IDENTITY(1,1), 
    categoria_repuesto VARCHAR(255) NULL,

    CONSTRAINT PK_CategoriaRepuesto PRIMARY KEY (id_categoria_repuesto)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Repuesto' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Repuesto (
    cod_repuesto VARCHAR(255),
    desc_repuesto VARCHAR(255) NULL,
    precio_repuesto NUMERIC(38, 2) NULL,
    id_categoria INT NULL, 
    compatibilidad_repuesto VARCHAR(255) NULL,

    CONSTRAINT PK_Repuesto PRIMARY KEY (cod_repuesto),
    CONSTRAINT FK_Repuesto_CategoriaRepuesto FOREIGN KEY (id_categoria) REFERENCES SOMOS_QUATRO_LOCOS.Categoria_Repuesto (id_categoria_repuesto)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Detalle_Reparacion' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Detalle_Reparacion (
    cod_repuesto VARCHAR(255),
    nro_reparacion INT,
    cantidad_repuesto INT NULL,
    precio_unitario_repuesto NUMERIC(38,2), 
    subtotal_repuesto NUMERIC(38,2),

    CONSTRAINT PK_DetalleReparacion PRIMARY KEY (cod_repuesto, nro_reparacion),
    CONSTRAINT FK_DetalleReparacion_Repuesto FOREIGN KEY (cod_repuesto) REFERENCES SOMOS_QUATRO_LOCOS.Repuesto (cod_repuesto),
    CONSTRAINT FK_DetalleReparacion_Reparacion FOREIGN KEY (nro_reparacion) REFERENCES SOMOS_QUATRO_LOCOS.Reparacion (nro_reparacion)
);



IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Proveedor' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Proveedor (
    id_proveedor INT IDENTITY(1,1),
    razon_social_proveedor VARCHAR(255),
    cuit_proveedor VARCHAR(255),
    telefono_proveedor VARCHAR(255),
    email_proveedor VARCHAR(255),
    direccion_proveedor VARCHAR(255),
    id_localidad INT,

    CONSTRAINT PK_Proveedor PRIMARY KEY (id_proveedor),
    CONSTRAINT FK_Proveedor_Localidad FOREIGN KEY (id_localidad) REFERENCES SOMOS_QUATRO_LOCOS.Localidad (id_localidad)
);


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Compra' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Compra (
    nro_compra INT IDENTITY(1,1),
    id_proveedor INT,
    nro_empleado INT,
    fecha_compra DATETIME2(6),
    total_compra NUMERIC(38, 2),
    id_local INT,

    CONSTRAINT PK_Compra PRIMARY KEY (nro_compra),
    CONSTRAINT FK_Compra_Empleado FOREIGN KEY (nro_empleado) REFERENCES SOMOS_QUATRO_LOCOS.Empleado (nro_empleado),
    CONSTRAINT FK_Compra_FormaPago FOREIGN KEY (id_proveedor) REFERENCES SOMOS_QUATRO_LOCOS.Proveedor (id_proveedor),
    constraint FK_Compra_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.Local (id_local)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Detalle_Compra' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Detalle_Compra (
    nro_compra INT,
    cod_producto VARCHAR(255),
    cantidad_prod_compra INT,
    precio_unitario_prod_compra NUMERIC(38, 2),
    subtotal NUMERIC(38, 2),
    
    CONSTRAINT PK_DetalleCompra PRIMARY KEY (nro_compra, cod_producto),
    CONSTRAINT FK_DetalleCompra_Compra FOREIGN KEY (nro_compra) REFERENCES SOMOS_QUATRO_LOCOS.Compra (nro_compra),
    CONSTRAINT FK_DetalleCompra_Producto FOREIGN KEY (cod_producto) REFERENCES SOMOS_QUATRO_LOCOS.Producto (cod_producto)
);


