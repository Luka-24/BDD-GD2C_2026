USE [GD2C_2026]
GO

CREATE SCHEMA SOMOS_QUATRO_LOCOS
GO

--TABLAS Y CLAVES:

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
    id_marca INT NULL,
    rodado_modelo_bicicleta VARCHAR(255) NULL,
    cuadro_modelo_bicicleta VARCHAR(255) NULL,
    color_modelo_bicicleta VARCHAR(255) NULL,
    id_categoria_bicicleta INT NULL,

    CONSTRAINT PK_ModeloBicicleta PRIMARY KEY (modelo_bicicleta),
    CONSTRAINT FK_ModeloBicicleta_Marca FOREIGN KEY (id_marca) REFERENCES SOMOS_QUATRO_LOCOS.Marca (id_marca),
    CONSTRAINT FK_ModeloBicicleta_CategoriaBicicleta FOREIGN KEY (id_categoria_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Categoria_Bicicleta (id_categoria_bicicleta)
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
    cod_producto VARCHAR(255),
    modelo_bicicleta VARCHAR(255),
    meses_garantia_bici_venta INT,

    CONSTRAINT PK_BicicletaVenta PRIMARY KEY (cod_producto),
    CONSTRAINT FK_BicicletaVenta_Producto FOREIGN KEY (cod_producto) REFERENCES SOMOS_QUATRO_LOCOS.Producto (cod_producto),
    CONSTRAINT FK_BicicletaVenta_Modelo FOREIGN KEY (modelo_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (modelo_bicicleta)
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
    modelo_bicicleta VARCHAR(255),
    id_estado INT NULL,
    precio_bici_alquiler_hora DECIMAL(38, 2) NULL,
    precio_bici_alquiler_dia DECIMAL(38, 2) NULL,
    id_local INT NULL,

    CONSTRAINT PK_BicicletaAlquiler PRIMARY KEY (nro_serie_bicicleta),
    CONSTRAINT FK_BicicletaAlquiler_ModeloBicicleta FOREIGN KEY (modelo_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (modelo_bicicleta),
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
    id_localidad INT,

    CONSTRAINT PK_Empleado PRIMARY KEY (nro_empleado),
    CONSTRAINT FK_Empleado_Localidad FOREIGN KEY (id_localidad) REFERENCES SOMOS_QUATRO_LOCOS.Localidad (id_localidad)
);


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Venta' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Venta (
    nro_venta INT,
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
    id_detalle_venta INT IDENTITY(1,1),
    nro_venta INT,
    cod_producto VARCHAR(255),
    cantidad_prod_venta INT,
    precio_unitario_prod_venta NUMERIC(38, 2),
    subtotal_prod_venta NUMERIC(38, 2),

    CONSTRAINT PK_DetalleVenta PRIMARY KEY (id_detalle_venta),
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (nro_venta) REFERENCES SOMOS_QUATRO_LOCOS.Venta (nro_venta),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (cod_producto) REFERENCES SOMOS_QUATRO_LOCOS.Producto (cod_producto)
);
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Alquiler' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Alquiler (
    nro_alquiler INT,
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
    CONSTRAINT FK_Alquiler_BicicletaAlquiler FOREIGN KEY (nro_serie_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler (nro_serie_bicicleta),    CONSTRAINT FK_Alquiler_Local FOREIGN KEY (id_local) REFERENCES SOMOS_QUATRO_LOCOS.Local (id_local)
);

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Reparacion' AND schema_id = SCHEMA_ID('SOMOS_QUATRO_LOCOS'))
CREATE TABLE SOMOS_QUATRO_LOCOS.Reparacion (
    nro_reparacion INT,
    nro_empleado INT NULL,
    nro_cliente INT NULL,
    nro_serie_bici_reparacion VARCHAR(255) NULL,
    modelo_bicicleta VARCHAR(255) NULL,
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
    CONSTRAINT FK_Reparacion_ModeloBicicleta FOREIGN KEY (modelo_bicicleta) REFERENCES SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (modelo_bicicleta),
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
    id_detalle_reparacion INT IDENTITY(1,1),
    cod_repuesto VARCHAR(255),
    nro_reparacion INT,
    cantidad_repuesto INT NULL,
    precio_unitario_repuesto NUMERIC(38,2),
    subtotal_repuesto NUMERIC(38,2),

    CONSTRAINT PK_DetalleReparacion PRIMARY KEY (id_detalle_reparacion),
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
    nro_compra INT,
    id_proveedor INT,
    nro_empleado INT,
    fecha_compra DATETIME2(6),
    total_compra NUMERIC(38, 2),
    id_local INT,

    CONSTRAINT PK_Compra PRIMARY KEY (nro_compra),
    CONSTRAINT FK_Compra_Empleado FOREIGN KEY (nro_empleado) REFERENCES SOMOS_QUATRO_LOCOS.Empleado (nro_empleado),
    CONSTRAINT FK_Compra_Proveedor FOREIGN KEY (id_proveedor) REFERENCES SOMOS_QUATRO_LOCOS.Proveedor (id_proveedor),
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

---INDICES:

CREATE NONCLUSTERED INDEX INX_Venta_Cliente ON SOMOS_QUATRO_LOCOS.Venta (nro_cliente);
CREATE NONCLUSTERED INDEX INX_Venta_Empleado ON SOMOS_QUATRO_LOCOS.Venta (nro_empleado); 
CREATE NONCLUSTERED INDEX INX_Venta_Local ON SOMOS_QUATRO_LOCOS.Venta (id_local); 
CREATE NONCLUSTERED INDEX INX_Empleado_Localidad ON SOMOS_QUATRO_LOCOS.Empleado (id_localidad);
CREATE NONCLUSTERED INDEX INX_Reparacion_Empleado ON SOMOS_QUATRO_LOCOS.Reparacion (nro_empleado);
CREATE NONCLUSTERED INDEX INX_Reparacion_Cliente ON SOMOS_QUATRO_LOCOS.Reparacion (nro_cliente);
CREATE NONCLUSTERED INDEX INX_Reparacion_Modelo ON SOMOS_QUATRO_LOCOS.Reparacion (modelo_bicicleta);
CREATE NONCLUSTERED INDEX INX_Reparacion_Local ON SOMOS_QUATRO_LOCOS.Reparacion (id_local);
CREATE NONCLUSTERED INDEX INX_Reparacion_Estado  ON SOMOS_QUATRO_LOCOS.Reparacion (id_estado);
CREATE NONCLUSTERED INDEX INX_Repuesto_CategoriaRepuesto ON SOMOS_QUATRO_LOCOS.Repuesto (id_categoria)
CREATE NONCLUSTERED INDEX INX_Proveedor_Localidad ON SOMOS_QUATRO_LOCOS.Proveedor (id_localidad);
CREATE NONCLUSTERED INDEX INX_Compra_Empleado ON SOMOS_QUATRO_LOCOS.Compra (nro_empleado);
CREATE NONCLUSTERED INDEX INX_Compra_Proveedor ON SOMOS_QUATRO_LOCOS.Compra (id_proveedor);
CREATE NONCLUSTERED INDEX INX_Compra_Local ON SOMOS_QUATRO_LOCOS.Compra (id_local);
CREATE NONCLUSTERED INDEX INX_ModeloBicileta_Marca ON SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (id_marca);
CREATE NONCLUSTERED INDEX INX_ModeloBicileta_Categoria ON SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (id_categoria_bicicleta);
CREATE NONCLUSTERED INDEX INX_Producto_TipoProducto ON SOMOS_QUATRO_LOCOS.Producto (nro_tipo_producto);
CREATE NONCLUSTERED INDEX INX_Accesorio_CategoriaAccesorio ON SOMOS_QUATRO_LOCOS.Accesorio (nro_categoria_accesorio);
CREATE NONCLUSTERED INDEX INX_Accesorio_Marca ON SOMOS_QUATRO_LOCOS.Accesorio (id_marca);
CREATE NONCLUSTERED INDEX INX_Cliente_Localidad ON SOMOS_QUATRO_LOCOS.Cliente (id_localidad);
CREATE NONCLUSTERED INDEX INX_Localidad_Provincia ON SOMOS_QUATRO_LOCOS.Localidad (id_provincia);
CREATE NONCLUSTERED INDEX INX_Local_Localidad ON SOMOS_QUATRO_LOCOS.Local (id_localidad);
CREATE NONCLUSTERED INDEX INX_BicicletaAlquiler_Estado ON SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler (id_estado);
CREATE NONCLUSTERED INDEX INX_BicicletaAlquiler_local ON SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler (id_local);
CREATE NONCLUSTERED INDEX INX_BicicletaAlquiler_Modelo ON SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler (modelo_bicicleta);
CREATE NONCLUSTERED INDEX INX_DetalleVenta_Venta ON SOMOS_QUATRO_LOCOS.Detalle_Venta (nro_venta, cod_producto);
CREATE NONCLUSTERED INDEX INX_DetalleVenta_Producto ON SOMOS_QUATRO_LOCOS.Detalle_Venta (cod_producto);
CREATE NONCLUSTERED INDEX INX_DetalleReparacion_Reparacion ON SOMOS_QUATRO_LOCOS.Detalle_Reparacion (nro_reparacion, cod_repuesto);
CREATE NONCLUSTERED INDEX INX_DetalleReparacion_Repuesto ON SOMOS_QUATRO_LOCOS.Detalle_Reparacion (cod_repuesto);
CREATE NONCLUSTERED INDEX INX_DetalleCompra_Producto ON SOMOS_QUATRO_LOCOS.Detalle_Compra (cod_producto);
CREATE NONCLUSTERED INDEX INX_Venta_FormaPago ON SOMOS_QUATRO_LOCOS.Venta (id_forma_pago);
CREATE NONCLUSTERED INDEX INX_Alquiler_Empleado ON SOMOS_QUATRO_LOCOS.Alquiler (nro_empleado);
CREATE NONCLUSTERED INDEX INX_Alquiler_Cliente ON SOMOS_QUATRO_LOCOS.Alquiler (nro_cliente);
CREATE NONCLUSTERED INDEX INX_Alquiler_FormaPago ON SOMOS_QUATRO_LOCOS.Alquiler (id_forma_pago);
CREATE NONCLUSTERED INDEX INX_Alquiler_Estado ON SOMOS_QUATRO_LOCOS.Alquiler (id_estado);
CREATE NONCLUSTERED INDEX INX_Alquiler_Bicicleta ON SOMOS_QUATRO_LOCOS.Alquiler (nro_serie_bicicleta);
CREATE NONCLUSTERED INDEX INX_Alquiler_Local ON SOMOS_QUATRO_LOCOS.Alquiler (id_local);
CREATE NONCLUSTERED INDEX INX_Cliente_Dni ON SOMOS_QUATRO_LOCOS.Cliente (dni_cliente);
CREATE NONCLUSTERED INDEX INX_Empleado_Dni ON SOMOS_QUATRO_LOCOS.Empleado (dni_empleado);
CREATE NONCLUSTERED INDEX INX_Proveedor_Cuit ON SOMOS_QUATRO_LOCOS.Proveedor (cuit_proveedor);
CREATE NONCLUSTERED INDEX INX_Local_Nombre ON SOMOS_QUATRO_LOCOS.Local (nombre_local);
CREATE NONCLUSTERED INDEX INX_BicicletaVenta_Modelo ON SOMOS_QUATRO_LOCOS.Bicicleta_Venta (modelo_bicicleta);

GO
CREATE TRIGGER TR_Insert_Reparacion_ModeloBicicleta
ON SOMOS_QUATRO_LOCOS.Reparacion INSTEAD OF INSERT
AS BEGIN
    IF NOT EXISTS(SELECT 1 FROM SOMOS_QUATRO_LOCOS.Modelo_Bicicleta WHERE modelo_bicicleta IN (SELECT modelo_bicicleta FROM inserted))
        INSERT INTO SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (modelo_bicicleta)
        SELECT modelo_bicicleta FROM inserted
    INSERT INTO SOMOS_QUATRO_LOCOS.Reparacion
    SELECT * FROM inserted
END;

--MIGRACION

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Provincia
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Provincia (provincia)
        SELECT DISTINCT Cliente_Provincia AS provincia FROM gd_esquema.Maestra WHERE Cliente_Provincia IS NOT NULL
        UNION
        SELECT DISTINCT Proveedor_Provincia AS provincia FROM gd_esquema.Maestra WHERE Proveedor_Provincia IS NOT NULL
        UNION
        SELECT DISTINCT Empleado_Provincia AS provincia FROM gd_esquema.Maestra WHERE Empleado_Provincia IS NOT NULL
        UNION
        SELECT DISTINCT Local_Provincia AS provincia FROM gd_esquema.Maestra WHERE Local_Provincia IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Localidad
AS BEGIN 
    INSERT INTO SOMOS_QUATRO_LOCOS.Localidad (id_provincia, localidad)
    SELECT DISTINCT P.id_provincia, Loc.localidad
    FROM (
        SELECT DISTINCT Cliente_Localidad AS localidad, Cliente_Provincia AS provincia
        FROM gd_esquema.Maestra
        WHERE Cliente_Localidad IS NOT NULL AND Cliente_Provincia IS NOT NULL 
    
        UNION

        SELECT DISTINCT Empleado_Localidad AS localidad, Empleado_Provincia AS provincia
        FROM gd_esquema.Maestra
        WHERE Empleado_Localidad IS NOT NULL AND Empleado_Provincia IS NOT NULL
    
        UNION 

        SELECT DISTINCT Local_Localidad AS localidad, Local_Provincia AS provincia
        FROM gd_esquema.Maestra
        WHERE Local_Localidad IS NOT NULL AND Local_Provincia IS NOT NULL

        UNION

        SELECT DISTINCT Proveedor_Localidad AS localidad, Proveedor_Provincia AS provincia
        FROM gd_esquema.Maestra 
        WHERE Proveedor_Localidad IS NOT NULL AND Proveedor_Provincia IS NOT NULL
    ) AS Loc
    JOIN SOMOS_QUATRO_LOCOS.Provincia P ON Loc.provincia = P.provincia
    WHERE NOT EXISTS (
        SELECT 1
        FROM SOMOS_QUATRO_LOCOS.Localidad L
        WHERE L.localidad = Loc.localidad AND L.id_provincia = P.id_provincia
    )
END

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Marca
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Marca (marca)
        SELECT DISTINCT Marca_Marca AS marca
        FROM gd_esquema.Maestra
        WHERE Marca_Marca IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_EstadoReparacion
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Estado_Reparacion (estado_reparacion)
        SELECT DISTINCT Estado_Reparacion_Estado_Reparacion AS estado_reparacion 
        FROM gd_esquema.Maestra 
        WHERE Estado_Reparacion_Estado_Reparacion IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_EstadoAlquiler
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Estado_Alquiler (estado_alquiler)
        SELECT DISTINCT Estado_Alquiler_Estado_Alquiler AS estado_alquiler 
        FROM gd_esquema.Maestra 
        WHERE Estado_Alquiler_Estado_Alquiler IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_CategoriaAccesorio
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Categoria_Accesorio (categoria_accesorio)
        SELECT DISTINCT Categoria_Accesorios_Categoria_Accesorio AS categoria_accesorio
        FROM gd_esquema.Maestra
        WHERE Categoria_Accesorios_Categoria_Accesorio IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_CategoriaBicicleta
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Categoria_Bicicleta (categoria_bicicleta)
        SELECT DISTINCT Categoria_Bicicleta_Categoria_Bicicleta AS categoria_bicicleta
        FROM gd_esquema.Maestra
        WHERE Categoria_Bicicleta_Categoria_Bicicleta IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_TipoProducto
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Tipo_Producto (tipo_producto)
        SELECT DISTINCT Tipo_Producto_Tipo_Producto AS tipo_producto
        FROM gd_esquema.Maestra 
        WHERE Tipo_Producto_Tipo_Producto IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_ModeloBicicleta
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Modelo_Bicicleta (modelo_bicicleta, id_marca, rodado_modelo_bicicleta, cuadro_modelo_bicicleta, color_modelo_bicicleta, id_categoria_bicicleta)
        SELECT DISTINCT Modelo_Bicicleta_Modelo_Bicicleta AS modelo_bicicleta,
            M.id_marca,
            T.Modelo_Bicicleta_Rodado_Modelo_Bicicleta AS rodado_modelo_bicicleta,
            T.Modelo_Bicicleta_Cuadro_Modelo_Bicicleta AS cuadro_modelo_bicicleta,
            T.Modelo_Bicicleta_Color_Modelo_Bicicleta AS color_modelo_bicicleta,
            CB.id_categoria_bicicleta
        FROM gd_esquema.Maestra T
            LEFT JOIN SOMOS_QUATRO_LOCOS.Marca M ON M.marca = T.Marca_Marca
            LEFT JOIN SOMOS_QUATRO_LOCOS.Categoria_Bicicleta CB ON CB.categoria_bicicleta = T.Categoria_Bicicleta_Categoria_Bicicleta
        WHERE T.Modelo_Bicicleta_Modelo_Bicicleta IS NOT NULL 
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Producto
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Producto (cod_producto, nombre_producto, descripcion_producto, precio_venta_producto, nro_tipo_producto)
        SELECT DISTINCT M.Producto_Cod_Producto AS cod_producto,
            M.Producto_Nombre_Producto AS nombre_producto,
            M.Producto_Descripcion_Producto AS descripcion_producto,
            M.Producto_Precio_Venta_Producto AS precio_venta_producto,
            TP.nro_tipo_producto
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Tipo_Producto TP ON TP.tipo_producto = M.Tipo_Producto_Tipo_Producto
        WHERE Tipo_Producto_Tipo_Producto IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Accesorio
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Accesorio (cod_producto, talle_accesorio, color_accesorio, nro_categoria_accesorio, id_marca)
        SELECT DISTINCT M.Producto_Cod_Producto AS cod_producto,
            M.Accesorio_Talle_Accesorio AS talle_accesorio,
            M.Accesorio_Color_Accesorio AS color_accesorio,
            C.nro_categoria_accesorio,
            R.id_marca
        FROM gd_esquema.Maestra M
            LEFT JOIN SOMOS_QUATRO_LOCOS.Categoria_Accesorio C ON C.categoria_accesorio = M.Categoria_Accesorios_Categoria_Accesorio
            LEFT JOIN SOMOS_QUATRO_LOCOS.Marca R ON R.marca = M.Marca_Marca
        WHERE Producto_Cod_Producto IS NOT NULL AND M.Categoria_Accesorios_Categoria_Accesorio IS NOT NULL AND M.Marca_Marca IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Cliente
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Cliente (nombre_cliente, apellido_cliente, dni_cliente, telefono_cliente, email_cliente, direccion_cliente, fecha_nacimiento_cliente, id_localidad)
        SELECT DISTINCT Cliente_Nombre_Cliente AS nombre_cliente,
            Cliente_Apellido_Cliente AS apellido_cliente,
            Cliente_DNI_Cliente AS dni_cliente,
            Cliente_Telefono_Cliente AS telefono_cliente,
            Cliente_Email_Cliente AS email_cliente,
            Cliente_Direccion_Cliente AS direccion_cliente,
            Cliente_Fecha_Nacimiento_Cliente AS fecha_nacimiento_cliente,
            L.id_localidad
        FROM gd_esquema.Maestra
            LEFT JOIN SOMOS_QUATRO_LOCOS.Localidad L ON L.localidad = Cliente_Localidad 
        AND L.id_provincia = (
                SELECT id_provincia 
                FROM SOMOS_QUATRO_LOCOS.Provincia 
                WHERE provincia = Cliente_Provincia
        )
        WHERE Cliente_Dni_Cliente IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_BicicletaVenta
AS BEGIN
    -- Bicis que se vendieron: tienen garantia informada
    INSERT INTO SOMOS_QUATRO_LOCOS.Bicicleta_Venta (cod_producto, modelo_bicicleta, meses_garantia_bici_venta)
        SELECT DISTINCT M.Producto_Cod_Producto,
               M.Modelo_Bicicleta_Modelo_Bicicleta,
               M.Bicicleta_Venta_Meses_Garantia_Bici_Venta
        FROM gd_esquema.Maestra M
        WHERE M.Producto_Cod_Producto IS NOT NULL
          AND M.Modelo_Bicicleta_Modelo_Bicicleta IS NOT NULL
          AND M.Bicicleta_Venta_Meses_Garantia_Bici_Venta IS NOT NULL

    -- Bicis que solo aparecen en compras (nunca se vendieron): sin garantia
    INSERT INTO SOMOS_QUATRO_LOCOS.Bicicleta_Venta (cod_producto, modelo_bicicleta, meses_garantia_bici_venta)
        SELECT DISTINCT M.Producto_Cod_Producto,
               M.Modelo_Bicicleta_Modelo_Bicicleta,
               NULL
        FROM gd_esquema.Maestra M
        WHERE M.Producto_Cod_Producto IS NOT NULL
          AND M.Modelo_Bicicleta_Modelo_Bicicleta IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM SOMOS_QUATRO_LOCOS.Bicicleta_Venta BV
                          WHERE BV.cod_producto = M.Producto_Cod_Producto)
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_FormaPago
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Forma_Pago (forma_pago)
        SELECT DISTINCT Forma_Pago_Forma_Pago AS forma_pago
        FROM gd_esquema.Maestra
        WHERE Forma_Pago_Forma_Pago IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Local
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Local (nombre_local, telefono_local, email_local, direccion_local, id_localidad)
        SELECT DISTINCT Local_Nombre_Local AS nombre_local,
            Local_Telefono_Local AS telefono_local,
            Local_Email_Local AS email_local,
            Local_Direccion_Local AS direccion_local,
            L.id_localidad
        FROM gd_esquema.Maestra
        LEFT JOIN SOMOS_QUATRO_LOCOS.Localidad L ON L.localidad = Local_Localidad 
        AND L.id_provincia = (
                SELECT id_provincia 
                FROM SOMOS_QUATRO_LOCOS.Provincia 
                WHERE provincia = Local_Provincia
        )
        WHERE Local_Nombre_Local IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_EstadoBicicletaAlquiler
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Estado_Bicicleta_Alquiler (estado_bicicleta_alquiler)
        SELECT DISTINCT Estado_Bici_Alquiler_Estado_Bici_Alquiler AS estado_bicicleta_alquiler
        FROM gd_esquema.Maestra
        WHERE Estado_Bici_Alquiler_Estado_Bici_Alquiler IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_BicicletaAlquiler
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler
        (nro_serie_bicicleta, modelo_bicicleta, id_estado, precio_bici_alquiler_hora, precio_bici_alquiler_dia, id_local)
        SELECT DISTINCT
            M.Bicicleta_Alquiler_Nro_Serie_Bici_Alquiler,
            M.Modelo_Bicicleta_Modelo_Bicicleta,
            E.id_estado_bicicleta_alquiler,
            M.Bicicleta_Alquiler_Precio_Bici_Alquiler_Hora,
            M.Bicicleta_Alquiler_Precio_Bici_Alquiler_Dia,
            L.id_local
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Estado_Bicicleta_Alquiler E
               ON E.estado_bicicleta_alquiler = M.Estado_Bici_Alquiler_Estado_Bici_Alquiler
        LEFT JOIN SOMOS_QUATRO_LOCOS.Local L
               ON L.nombre_local = M.Local_Nombre_Local
        WHERE M.Bicicleta_Alquiler_Nro_Serie_Bici_Alquiler IS NOT NULL
END;   

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Empleado
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Empleado (nombre_empleado, apellido_empleado, dni_empleado, puesto_empleado, fecha_ingreso_empleado, telefono_empleado, email_empleado, domicilio_empleado, fecha_nac_empleado, id_localidad)
        SELECT DISTINCT
            M.Empleado_Nombre_Empleado,
            M.Empleado_Apellido_Empleado,
            M.Empleado_Dni_Empleado,
            M.Empleado_Puesto_Empleado,
            M.Empleado_Fecha_Ingreso_Empleado,
            M.Empleado_Telefono_Empleado,
            M.Empleado_Email_Empleado,
            M.Empleado_Domicilio_Empleado,
            M.Empleado_Fecha_Nac_Empleado,
            D.id_localidad
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Provincia P ON P.provincia = M.Empleado_Provincia
        LEFT JOIN SOMOS_QUATRO_LOCOS.Localidad D ON D.localidad = M.Empleado_Localidad AND D.id_provincia = P.id_provincia
        WHERE M.Empleado_Dni_Empleado IS NOT NULL
END;

GO 
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Venta
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Venta (nro_venta, nro_empleado, nro_cliente, id_forma_pago, fecha_hora_venta, total_venta, id_local)
        SELECT DISTINCT 
        Venta_Nro_Venta AS nro_venta_origen,
        E.nro_empleado,
        C.nro_cliente,
        FP.id_forma_pago,
        Venta_Fecha_Hora_Venta AS fecha_hora_venta,
        Venta_Total_Venta AS total_venta,
        L.id_local
    FROM gd_esquema.Maestra M 
    LEFT JOIN SOMOS_QUATRO_LOCOS.Empleado E ON E.dni_empleado = M.Empleado_Dni_Empleado
    LEFT JOIN SOMOS_QUATRO_LOCOS.Cliente C
           ON C.dni_cliente = M.Cliente_Dni_Cliente
          AND EXISTS (SELECT C.nombre_cliente, C.apellido_cliente, C.telefono_cliente,
                             C.email_cliente, C.direccion_cliente, C.fecha_nacimiento_cliente
                      INTERSECT
                      SELECT M.Cliente_Nombre_Cliente, M.Cliente_Apellido_Cliente, M.Cliente_Telefono_Cliente,
                             M.Cliente_Email_Cliente, M.Cliente_Direccion_Cliente, M.Cliente_Fecha_Nacimiento_Cliente)    LEFT JOIN SOMOS_QUATRO_LOCOS.Forma_Pago FP ON FP.forma_pago = M.Forma_Pago_Forma_Pago
    LEFT JOIN SOMOS_QUATRO_LOCOS.LOCAL L ON L.nombre_local = M.Local_Nombre_Local
    WHERE Venta_Nro_Venta IS NOT NULL AND Venta_Fecha_Hora_Venta IS NOT NULL AND Venta_Total_Venta IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_DetalleVenta
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Detalle_Venta (nro_venta, cod_producto, cantidad_prod_venta, precio_unitario_prod_venta, subtotal_prod_venta)
        SELECT
            Venta_Nro_Venta AS nro_venta,
            Producto_Cod_Producto AS cod_producto,
            SUM(Detalle_Venta_Cantidad_Prod_Venta) AS cantidad_prod_venta,
            Detalle_Venta_Precio_Unitario_Prod_Venta AS precio_unitario_prod_venta,
            SUM(Detalle_Venta_Subtotal_Prod_Venta) AS subtotal_prod_venta
        FROM gd_esquema.Maestra
        WHERE Venta_Nro_Venta IS NOT NULL AND Producto_Cod_Producto IS NOT NULL
        GROUP BY Venta_Nro_Venta, Producto_Cod_Producto, Detalle_Venta_Precio_Unitario_Prod_Venta
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Alquiler
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Alquiler (nro_alquiler, nro_empleado, nro_cliente, id_forma_pago, id_estado, nro_serie_bicicleta, fecha_fin_pactada_alquiler, fecha_devolucion_real_alquiler, fecha_inicio_alquiler, importe_total_alquiler, id_local)
        SELECT DISTINCT
            M.Alquiler_Nro_Alquiler,
            E.nro_empleado,
            C.nro_cliente,
            FP.id_forma_pago,
            EA.id_estado_alquiler,
            B.nro_serie_bicicleta,
            M.Alquiler_Fecha_Fin_Pactada_Alquiler,
            M.Alquiler_Fecha_Devolucion_Real_Alquiler,
            M.Alquiler_Fecha_Inicio_Alquiler,
            M.Alquiler_Importe_Total_Alquiler,
            L.id_local
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Empleado E ON E.dni_empleado = M.Empleado_Dni_Empleado
        LEFT JOIN SOMOS_QUATRO_LOCOS.Cliente C
               ON C.dni_cliente = M.Cliente_Dni_Cliente
              AND EXISTS (SELECT C.nombre_cliente, C.apellido_cliente, C.telefono_cliente,
                                 C.email_cliente, C.direccion_cliente, C.fecha_nacimiento_cliente
                          INTERSECT
                          SELECT M.Cliente_Nombre_Cliente, M.Cliente_Apellido_Cliente, M.Cliente_Telefono_Cliente,
                                 M.Cliente_Email_Cliente, M.Cliente_Direccion_Cliente, M.Cliente_Fecha_Nacimiento_Cliente)
        LEFT JOIN SOMOS_QUATRO_LOCOS.Forma_Pago FP ON FP.forma_pago = M.Forma_Pago_Forma_Pago
        LEFT JOIN SOMOS_QUATRO_LOCOS.Estado_Alquiler EA ON EA.estado_alquiler = M.Estado_Alquiler_Estado_Alquiler
        LEFT JOIN SOMOS_QUATRO_LOCOS.Bicicleta_Alquiler B ON B.nro_serie_bicicleta = M.Bicicleta_Alquiler_Nro_Serie_Bici_Alquiler
        LEFT JOIN SOMOS_QUATRO_LOCOS.Local L ON L.nombre_local = M.Local_Nombre_Local
        WHERE M.Alquiler_Nro_Alquiler IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Reparacion
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Reparacion (nro_reparacion, nro_empleado, nro_cliente, nro_serie_bici_reparacion, modelo_bicicleta, fecha_ingreso_reparacion, fecha_entrega_estimada_reparacion, fecha_entrega_real_reparacion, id_local, precio_mano_obra_reparacion, precio_repuestos_reparacion, precio_total_reparacion, id_estado, diagnostico_reparacion)
        SELECT DISTINCT
            M.Reparacion_Nro_Reparacion,
            E.nro_empleado,
            C.nro_cliente,
            M.Reparacion_Numero_Serie_Bici_Reparacion,
            M.Modelo_Bicicleta_Modelo_Bicicleta,
            M.Reparacion_Fecha_Ingreso_Reparacion,
            M.Reparacion_Fecha_Entrega_Estimada_Reparacion,
            M.Reparacion_Fecha_Entrega_Real_Reparacion,
            L.id_local,
            M.Reparacion_Precio_Mano_Obra_Reparacion,
            M.Reparacion_Precio_Repuestos_Reparacion,
            M.Reparacion_Precio_Total_Reparacion,
            ER.id_estado_reparacion,
            M.Reparacion_Diagnostico_Reparacion
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Empleado E ON E.dni_empleado = M.Empleado_Dni_Empleado
        LEFT JOIN SOMOS_QUATRO_LOCOS.Cliente C
               ON C.dni_cliente = M.Cliente_Dni_Cliente
              AND EXISTS (SELECT C.nombre_cliente, C.apellido_cliente, C.telefono_cliente,
                                 C.email_cliente, C.direccion_cliente, C.fecha_nacimiento_cliente
                          INTERSECT
                          SELECT M.Cliente_Nombre_Cliente, M.Cliente_Apellido_Cliente, M.Cliente_Telefono_Cliente,
                                 M.Cliente_Email_Cliente, M.Cliente_Direccion_Cliente, M.Cliente_Fecha_Nacimiento_Cliente)    LEFT JOIN SOMOS_QUATRO_LOCOS.Forma_Pago FP ON FP.forma_pago = M.Forma_Pago_Forma_Pago
        LEFT JOIN SOMOS_QUATRO_LOCOS.Local L ON L.nombre_local = M.Local_Nombre_Local
        LEFT JOIN SOMOS_QUATRO_LOCOS.Estado_Reparacion ER ON ER.estado_reparacion = M.Estado_Reparacion_Estado_Reparacion
        WHERE M.Reparacion_Nro_Reparacion IS NOT NULL
END;
GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_CategoriaRepuesto
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Categoria_Repuesto (categoria_repuesto)
        SELECT DISTINCT Categoria_Repuestos_Categoria_Respuesto AS categoria_repuesto
        FROM gd_esquema.Maestra
        WHERE Categoria_Repuestos_Categoria_Respuesto IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Repuesto
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Repuesto (cod_repuesto, desc_repuesto, precio_repuesto, id_categoria, compatibilidad_repuesto)
        SELECT DISTINCT 
            Repuesto_Cod_Repuesto AS cod_repuesto,
            Repuesto_Desc_Repuesto AS desc_repuesto,
            Repuesto_Precio_Repuesto AS precio_repuesto,
            CR.id_categoria_repuesto,
            Repuesto_Compatibilidad_Repuesto AS compatibilidad_repuesto
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Categoria_Repuesto CR ON CR.categoria_repuesto = M.Categoria_Repuestos_Categoria_Respuesto
        WHERE Repuesto_Cod_Repuesto IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_DetalleReparacion
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Detalle_Reparacion (cod_repuesto, nro_reparacion, cantidad_repuesto, precio_unitario_repuesto, subtotal_repuesto)
        SELECT
            Repuesto_Cod_Repuesto AS cod_repuesto,
            Reparacion_Nro_Reparacion AS nro_reparacion,
            SUM(Detalle_Reparacion_Cantidad_Repuesto) AS cantidad_repuesto,
            Detalle_Reparacion_Precio_Unitario_Repuesto AS precio_unitario_repuesto,
            SUM(Detalle_Reparacion_Subtotal_Repuesto) AS subtotal_repuesto
        FROM gd_esquema.Maestra
        WHERE Repuesto_Cod_Repuesto IS NOT NULL AND Reparacion_Nro_Reparacion IS NOT NULL
        GROUP BY Repuesto_Cod_Repuesto, Reparacion_Nro_Reparacion, Detalle_Reparacion_Precio_Unitario_Repuesto
END;

GO 
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Proveedor
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Proveedor (razon_social_proveedor, cuit_proveedor, telefono_proveedor, email_proveedor, direccion_proveedor, id_localidad)
        SELECT DISTINCT 
            Proveedor_Razon_Social_Proveedor AS razon_social_proveedor,
            Proveedor_Cuit_Proveedor AS cuit_proveedor,
            Proveedor_Telefono_Proveedor AS telefono_proveedor,
            Proveedor_Email_Proveedor AS email_proveedor,
            Proveedor_Direccion_Proveedor AS direccion_proveedor,
            L.id_localidad
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Localidad L ON L.localidad = M.Proveedor_Localidad 
        AND L.id_provincia = (
                SELECT id_provincia 
                FROM SOMOS_QUATRO_LOCOS.Provincia 
                WHERE provincia = M.Proveedor_Provincia
   )    WHERE Proveedor_Cuit_Proveedor IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_Compra
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Compra (nro_compra,id_proveedor, nro_empleado, fecha_compra, total_compra, id_local)
        SELECT DISTINCT 
            M.Compra_Nro_Compra AS nro_compra_origen,
            P.id_proveedor,
            E.nro_empleado,
            Compra_Fecha_Compra AS fecha_compra,
            Compra_Total_Compra AS total_compra,
            L.id_local
        FROM gd_esquema.Maestra M
        LEFT JOIN SOMOS_QUATRO_LOCOS.Proveedor P ON P.cuit_proveedor = M.Proveedor_Cuit_Proveedor
        LEFT JOIN SOMOS_QUATRO_LOCOS.Empleado E ON E.dni_empleado = M.Empleado_Dni_Empleado
        LEFT JOIN SOMOS_QUATRO_LOCOS.Local L ON L.nombre_local = M.Local_Nombre_Local
        WHERE Compra_Fecha_Compra IS NOT NULL AND Compra_Total_Compra IS NOT NULL
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Migrar_DetalleCompra
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Detalle_Compra (nro_compra, cod_producto, cantidad_prod_compra, precio_unitario_prod_compra, subtotal)
        SELECT DISTINCT 
            Compra_Nro_Compra AS nro_compra,
            Producto_Cod_Producto,
            Detalle_Compra_Cantidad_Prod_Compra AS cantidad_prod_compra,
            Detalle_Compra_Precio_Unitario_Prod_Compra AS precio_unitario_prod_compra,
            Detalle_Compra_Precio_Unitario_Prod_Compra * Detalle_Compra_Cantidad_Prod_Compra AS subtotal
        FROM gd_esquema.Maestra
        WHERE Compra_Nro_Compra IS NOT NULL AND Producto_Cod_Producto IS NOT NULL
END; 

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Popular_EstadoAlquiler
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Estado_Alquiler (estado_alquiler)
    VALUES ('Reservado'), ('En Curso'), ('Vencido')
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Popular_EstadoBicicletaAlquiler
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Estado_Bicicleta_Alquiler (estado_bicicleta_alquiler)
    VALUES ('Alquilada'), ('De Baja')
END;

GO
CREATE PROCEDURE SOMOS_QUATRO_LOCOS.Popular_EstadoReparacion
AS BEGIN
    INSERT INTO SOMOS_QUATRO_LOCOS.Estado_Reparacion (estado_reparacion)
    VALUES ('Presupuestada'), ('En Proceso'), ('Lista')
END;

GO
EXEC SOMOS_QUATRO_LOCOS.Migrar_Provincia;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Localidad;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Marca;
EXEC SOMOS_QUATRO_LOCOS.Migrar_EstadoReparacion;
EXEC SOMOS_QUATRO_LOCOS.Migrar_EstadoAlquiler;
EXEC SOMOS_QUATRO_LOCOS.Migrar_CategoriaAccesorio;
EXEC SOMOS_QUATRO_LOCOS.Migrar_CategoriaBicicleta;
EXEC SOMOS_QUATRO_LOCOS.Migrar_TipoProducto;
EXEC SOMOS_QUATRO_LOCOS.Migrar_ModeloBicicleta;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Producto;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Accesorio;
EXEC SOMOS_QUATRO_LOCOS.Migrar_BicicletaVenta;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Cliente;
EXEC SOMOS_QUATRO_LOCOS.Migrar_FormaPago;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Local;
EXEC SOMOS_QUATRO_LOCOS.Migrar_EstadoBicicletaAlquiler;
EXEC SOMOS_QUATRO_LOCOS.Migrar_BicicletaAlquiler;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Empleado;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Venta;
EXEC SOMOS_QUATRO_LOCOS.Migrar_DetalleVenta;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Alquiler;
EXEC SOMOS_QUATRO_LOCOS.Migrar_CategoriaRepuesto;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Repuesto;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Reparacion;
EXEC SOMOS_QUATRO_LOCOS.Migrar_DetalleReparacion;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Proveedor;
EXEC SOMOS_QUATRO_LOCOS.Migrar_Compra;
EXEC SOMOS_QUATRO_LOCOS.Migrar_DetalleCompra;
EXEC SOMOS_QUATRO_LOCOS.Popular_EstadoAlquiler;
EXEC SOMOS_QUATRO_LOCOS.Popular_EstadoBicicletaAlquiler;
EXEC SOMOS_QUATRO_LOCOS.Popular_EstadoReparacion;
