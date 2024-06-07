-- Crear la base de datos
CREATE DATABASE LabLicoreria;
GO

-- Usar la base de datos
USE LabLicoreria;
GO

-- Crear el login y usuario para la base de datos
USE master;
GO
CREATE LOGIN usrlicoreria WITH PASSWORD=N'12345678',
    DEFAULT_DATABASE=LabLicoreria,
    CHECK_EXPIRATION=OFF,
    CHECK_POLICY=ON;
GO
USE LabLicoreria;
GO
CREATE USER usrlicoreria FOR LOGIN usrlicoreria;
GO
ALTER ROLE db_owner ADD MEMBER usrlicoreria;
GO

-- Eliminar tablas si existen

DROP TABLE IF EXISTS Empleado;
GO
DROP TABLE IF EXISTS Usuario;
GO
DROP TABLE IF EXISTS Categoria;
GO
DROP TABLE IF EXISTS Producto;
GO
DROP TABLE IF EXISTS Cliente;
GO
DROP TABLE IF EXISTS Venta;
GO
DROP TABLE IF EXISTS Detalle_Venta;
GO
DROP TABLE IF EXISTS Proveedor;
GO
DROP TABLE IF EXISTS compra;
GO
DROP TABLE IF EXISTS Detalle_Compra;
GO


-- Crear tablas
CREATE TABLE Empleado(
    idEmpleado INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(20) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    cargo VARCHAR(20) NOT NULL,
    salario FLOAT NOT NULL
);
GO

CREATE TABLE Usuario(
    idUsuario INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idEmpleado INT NOT NULL,
    usuario VARCHAR(30) NOT NULL,
    clave VARCHAR(30) NOT NULL,
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);
GO

CREATE TABLE Categoria(
    idCategoria INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Producto(
    idProducto INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idCategoria INT NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
	Stock INT NOT NULL DEFAULT 0,
    descripcion VARCHAR(500) NOT NULL,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);
GO

CREATE TABLE Cliente(
    idCliente INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    cedulaIdentidad VARCHAR(15) NOT NULL,
    razonSocial VARCHAR(50) NOT NULL,
    celular VARCHAR(8) NOT NULL DEFAULT '0'
);
GO

CREATE TABLE Venta(
    idVenta INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idUsuario INT NOT NULL,
    idCliente INT NOT NULL,
    cantidadProducto INT NOT NULL,
    cantidadTotal INT NOT NULL,
    totalCosto FLOAT NOT NULL,
    ImporteRecibido FLOAT NOT NULL,
    ImporteCambio FLOAT NOT NULL,
    tipoDocumento VARCHAR(50) DEFAULT 'Boleta',
    CONSTRAINT fk_Venta_Usuario FOREIGN KEY(idUsuario) REFERENCES Usuario(idUsuario),
    CONSTRAINT fk_Venta_Cliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
);
GO

CREATE TABLE Detalle_Venta(
    idDetalleVenta INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idVenta INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL CHECK(cantidad > 0),
    precioUnitario DECIMAL(10,2) NOT NULL,
    importeTotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_VentaDetalle_Venta FOREIGN KEY(idVenta) REFERENCES Venta(idVenta),
    CONSTRAINT fk_VentaDetalle_Producto FOREIGN KEY(idProducto) REFERENCES Producto(idProducto)
);
GO

CREATE TABLE Proveedor(
    idProveedor INT PRIMARY KEY IDENTITY(1,1),
    razonSocial VARCHAR(100),
    cedulaIdentidad VARCHAR(50),
    celular VARCHAR(8) NOT NULL DEFAULT '0'
);
GO

CREATE TABLE Compra(
    idCompra INT PRIMARY KEY IDENTITY(1,1),
    idUsuario INT REFERENCES Usuario(idUsuario),
    idProveedor INT REFERENCES Proveedor(idProveedor),
    totalCosto FLOAT DEFAULT 0,
    tipoComprobante VARCHAR(50) DEFAULT 'Boleta'
);
GO

CREATE TABLE Detalle_Compra(
    idDetalleCompra INT PRIMARY KEY IDENTITY(1,1),
    idCompra INT REFERENCES Compra(idCompra),
    idProducto INT REFERENCES Producto(idProducto),
    cantidad FLOAT,
    PrecioUnitarioCompra FLOAT,
    PrecioUnitarioVenta FLOAT,
    TotalCosto FLOAT
);
GO

-- Alter tables 
ALTER TABLE Empleado ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Empleado ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Empleado ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Usuario ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Usuario ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Usuario ADD Estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Categoria ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Categoria ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Categoria ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Producto ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Producto ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Producto ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Cliente ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Cliente ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Cliente ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Venta ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Venta ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Venta ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Detalle_Venta ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Detalle_Venta ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Detalle_Venta ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Proveedor ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Proveedor ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Proveedor ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Compra ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Compra ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Compra ADD estado SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE Detalle_Compra ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Detalle_Compra ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Detalle_Compra ADD estado SMALLINT NOT NULL DEFAULT 1;
GO

-- PROCEDIMIENTO PARA LISTAR EMPLEADOS
CREATE PROCEDURE paEmpleadoListar 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT idEmpleado, nombre, apellidos, telefono, cargo, salario, usuarioRegistro, fechaRegistro, estado
    FROM Empleado
    WHERE estado <> -1 AND nombre LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO

-- PROCEDIMIENTO PARA LISTAR PRODUCTOS
CREATE PROCEDURE paProductosListar 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT p.idProducto, p.idCategoria, p.codigo, p.nombre, p.Stock, p.descripcion, c.nombre AS categoria, p.usuarioRegistro, p.fechaRegistro, p.estado
    FROM Producto AS p
    INNER JOIN Categoria AS c ON p.idCategoria = c.idCategoria
    WHERE p.estado <> -1 AND p.nombre LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO

-- PROCEDIMIENTO PARA LISTAR CLIENTES
CREATE PROCEDURE paClienteListar 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT idCliente, cedulaIdentidad, razonSocial, celular, usuarioRegistro, fechaRegistro, estado
    FROM Cliente
    WHERE Estado <> -1 AND razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO

-- PROCEDIMIENTO PARA LISTAR VENTAS
CREATE PROCEDURE paVentaListar 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT v.idVenta, v.idUsuario, v.idCliente, v.cantidadProducto, v.cantidadTotal, v.totalCosto, v.ImporteRecibido, v.ImporteCambio, v.tipoDocumento, u.usuario, c.razonSocial, v.usuarioRegistro, v.fechaRegistro, v.estado
    FROM Venta v
    JOIN Usuario u ON v.idUsuario = u.idUsuario
    JOIN Cliente c ON v.idCliente = c.idCliente
    WHERE v.estado <> -1
    AND (c.razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%'
         OR u.usuario LIKE '%' + REPLACE(@parametro, ' ', '%') + '%');
END;
GO

-- PROCEDIMIENTO PARA LISTAR DETALLES DE VENTA
CREATE PROCEDURE paVentaDetalleListar 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT vd.idDetalleVenta, vd.idVenta, vd.idProducto, vd.cantidad, vd.precioUnitario, vd.importeTotal, p.nombre AS nombreProducto, c.razonSocial AS nombreCliente, vd.usuarioRegistro, vd.fechaRegistro, vd.estado
    FROM Detalle_Venta vd
    INNER JOIN Producto p ON p.idProducto = vd.idProducto
    INNER JOIN Venta v ON v.idVenta = vd.idVenta
    INNER JOIN Cliente c ON c.idCliente = v.idCliente
    WHERE vd.estado <> -1 AND c.razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO
-- PROCEDIMIENTO PARA LISTAR COMPRAS
CREATE PROCEDURE paListarCompras 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT c.idCompra, c.idUsuario, c.idProveedor, c.totalCosto, c.tipoComprobante, u.usuario, p.razonSocial AS nombreProveedor, c.usuarioRegistro, c.fechaRegistro, c.estado
    FROM Compra c
    JOIN Usuario u ON c.idUsuario = u.idUsuario
    JOIN Proveedor p ON c.idProveedor = p.idProveedor
    WHERE c.estado <> -1 AND p.razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO

-- PROCEDIMIENTO PARA LISTAR DETALLES DE COMPRAS
CREATE PROCEDURE paListarDetalleCompras 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT dc.idDetalleCompra, dc.idCompra, dc.idProducto, dc.cantidad, dc.PrecioUnitarioCompra, dc.PrecioUnitarioVenta, dc.TotalCosto, p.nombre AS nombreProducto, p.descripcion AS descripcionProducto, pr.razonSocial AS nombreProveedor, dc.usuarioRegistro, dc.fechaRegistro, dc.estado
    FROM Detalle_Compra dc
    INNER JOIN Producto p ON p.idProducto = dc.idProducto
    INNER JOIN Compra c ON c.idCompra = dc.idCompra
    INNER JOIN Proveedor pr ON pr.idProveedor = c.idProveedor
    WHERE dc.estado <> -1 AND pr.razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO


-- PROCEDIMIENTO PARA REGISTRAR UNA COMPRA
CREATE PROCEDURE paRegistrarCompra (
    @IdUsuario INT,
    @IdProveedor INT,
    @Detalle XML,
    @Resultado INT OUTPUT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @compraId INT;

        -- Insertar la compra
        INSERT INTO Compra (idUsuario, idProveedor, totalCosto)
        VALUES (@IdUsuario, @IdProveedor, 0);

        -- Obtener el ID de la compra recién insertada
        SET @compraId = SCOPE_IDENTITY();

        -- Insertar detalles de compra
        INSERT INTO Detalle_Compra (idCompra, idProducto, cantidad, PrecioUnitarioCompra, PrecioUnitarioVenta, TotalCosto)
        SELECT 
            @compraId,
            Node.Data.value('(IdProducto)[1]', 'INT'),
            Node.Data.value('(Cantidad)[1]', 'FLOAT'),
            Node.Data.value('(PrecioUnidadCompra)[1]', 'FLOAT'),
            Node.Data.value('(PrecioUnidadVenta)[1]', 'FLOAT'),
            Node.Data.value('(TotalCosto)[1]', 'FLOAT')
        FROM @Detalle.nodes('/DETALLE/DETALLE_COMPRA/DETALLE') Node(Data);

        -- Actualizar el costo total de la compra
        UPDATE Compra
        SET totalCosto = (
            SELECT SUM(TotalCosto)
            FROM Detalle_Compra
            WHERE idCompra = @compraId
        )
        WHERE idCompra = @compraId;

        COMMIT TRANSACTION;
        SET @Resultado = 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Resultado = 0;
    END CATCH;
END;
GO


-- PROCEDIMIENTO PARA LISTAR VENTAS
CREATE PROCEDURE paListarVentas 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT v.idVenta, v.idUsuario, v.idCliente, v.cantidadProducto, v.cantidadTotal, v.totalCosto, v.ImporteRecibido, v.ImporteCambio, v.tipoDocumento, u.usuario, c.razonSocial AS nombreCliente, v.usuarioRegistro, v.fechaRegistro, v.estado
    FROM Venta v
    JOIN Usuario u ON v.idUsuario = u.idUsuario
    JOIN Cliente c ON v.idCliente = c.idCliente
    WHERE v.estado <> -1 AND c.razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO

-- PROCEDIMIENTO PARA LISTAR DETALLES DE VENTAS
CREATE PROCEDURE paListarDetalleVentas 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT dv.idDetalleVenta, dv.idVenta, dv.idProducto, dv.cantidad, dv.precioUnitario, dv.importeTotal, p.nombre AS nombreProducto, c.razonSocial AS nombreCliente, dv.usuarioRegistro, dv.fechaRegistro, dv.estado
    FROM Detalle_Venta dv
    INNER JOIN Producto p ON p.idProducto = dv.idProducto
    INNER JOIN Venta v ON v.idVenta = dv.idVenta
    INNER JOIN Cliente c ON c.idCliente = v.idCliente
    WHERE dv.estado <> -1 AND c.razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO

-- PROCEDIMIENTO PARA REGISTRAR UNA VENTA
CREATE PROCEDURE paRegistrarVenta (
    @IdUsuario INT,
    @Detalle XML,
    @Resultado INT OUTPUT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ventaId INT;

		INSERT INTO Venta (idUsuario, idCliente, cantidadProducto, cantidadTotal, totalCosto, ImporteRecibido, ImporteCambio, tipoDocumento)
		SELECT 
			@IdUsuario,
			Nodo.Data.value('(IdCliente)[1]', 'INT'),
			Nodo.Data.value('(CantidadProducto)[1]', 'INT'),
			Nodo.Data.value('(CantidadTotal)[1]', 'INT'),
			Nodo.Data.value('(TotalCosto)[1]', 'FLOAT'),
			Nodo.Data.value('(ImporteRecibido)[1]', 'FLOAT'),
			Nodo.Data.value('(ImporteCambio)[1]', 'FLOAT'),
			Nodo.Data.value('(TipoDocumento)[1]', 'VARCHAR(50)')
		FROM @Detalle.nodes('/DETALLE/VENTA') AS Nodo(Data);
        -- Obtener el ID de la venta recién insertada
        SET @ventaId = SCOPE_IDENTITY();

        -- Insertar detalles de venta
        INSERT INTO Detalle_Venta (idVenta, idProducto, cantidad, precioUnitario, importeTotal)
        SELECT 
            @ventaId,
            Node.Data.value('(IdProducto)[1]', 'INT'),
            Node.Data.value('(Cantidad)[1]', 'INT'),
            Node.Data.value('(PrecioUnidad)[1]', 'DECIMAL(10,2)'),
            Node.Data.value('(ImporteTotal)[1]', 'DECIMAL(10,2)')
        FROM @Detalle.nodes('/DETALLE/DETALLE_VENTA/DATOS') Node(Data);

        COMMIT TRANSACTION;
        SET @Resultado = 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Resultado = 0;
    END CATCH;
END;
GO

-- PROCEDIMIENTO PARA LISTAR PROVEEDORES
CREATE PROCEDURE paListarProveedores 
    @parametro VARCHAR(50)
AS
BEGIN
    SELECT idProveedor, razonSocial, cedulaIdentidad, celular, usuarioRegistro, fechaRegistro, estado
    FROM Proveedor
    WHERE estado <> -1 AND razonSocial LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO


-- Insertar datos en la tabla Empleado
INSERT INTO Empleado (nombre, apellidos, telefono, cargo, salario, usuarioRegistro, fechaRegistro, estado)
VALUES ('Juan', 'Pérez', '123456789', 'Vendedor', 1500.00, 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Usuario
INSERT INTO Usuario (idEmpleado, usuario, clave, usuarioRegistro, fechaRegistro, estado)
VALUES (1, 'ruth', 'i0hcoO/nssY6WOs9pOp5Xw==', 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Categoria
INSERT INTO Categoria (nombre, usuarioRegistro, fechaRegistro, estado)
VALUES ('Bebidas', 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Producto
INSERT INTO Producto (idCategoria, codigo, nombre, Stock, descripcion, usuarioRegistro, fechaRegistro, estado)
VALUES (1, '001', 'Cerveza', 100, 'Cerveza tipo Lager', 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Cliente
INSERT INTO Cliente (cedulaIdentidad, razonSocial, celular, usuarioRegistro, fechaRegistro, estado)
VALUES ('1234567', 'Cliente A', '98765432', 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Venta
INSERT INTO Venta (idUsuario, idCliente, cantidadProducto, cantidadTotal, totalCosto, ImporteRecibido, ImporteCambio, tipoDocumento, usuarioRegistro, fechaRegistro, estado)
VALUES (1, 1, 5, 1, 10.00, 20.00, 10.00, 'Boleta', 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Detalle_Venta
INSERT INTO Detalle_Venta (idVenta, idProducto, cantidad, precioUnitario, importeTotal, usuarioRegistro, fechaRegistro, estado)
VALUES (1, 1, 5, 2.00, 10.00, 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Proveedor
INSERT INTO Proveedor (razonSocial, cedulaIdentidad, celular, usuarioRegistro, fechaRegistro, estado)
VALUES ('Proveedor X', '8765432', '1234567', 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Compra
INSERT INTO Compra (idUsuario, idProveedor, totalCosto, tipoComprobante, usuarioRegistro, fechaRegistro, estado)
VALUES (1, 1, 50.00, 'Factura', 'ruth', '2024-06-08', 1);

-- Insertar datos en la tabla Detalle_Compra
INSERT INTO Detalle_Compra (idCompra, idProducto, cantidad, PrecioUnitarioCompra, PrecioUnitarioVenta, TotalCosto, usuarioRegistro, fechaRegistro, estado)
VALUES (1, 1, 20, 2.00, 3.00, 40.00, 'ruth', '2024-06-08', 1);