create database Muebleria
use Muebleria

/*******************************************************
           Base de Datos Sistema Muebleria
*******************************************************/

create table Inventario(
ID_Articulo integer IDENTITY(1,1),
Nombre varchar(30) not null,
Descripcion varchar(500) not null,
Existencias integer not null,
Precio numeric (5,2) not null 
)

create table Clientes(
ID_Cliente integer Identity(1,1),
Nombre varchar(30) not null,
Fecha_Nacimiento date not null,
Numero_Telefono char(10) not null,
Correo varchar (30) not null,
Direccion varchar(40) not null,
Actividad varchar(8) not null
)

create table Usuarios(
ID_Usuario integer Identity(1,1),
Nombre varchar(30) not null,
Contrase�a varchar(10) not null,
Numero_Telefono varchar(10) not null,
Correo varchar (30) not null,
Direccion varchar(40) not null
)
------------------------------------------------------
--  Procedimiento Almacenado para Agregar Clientes  --
------------------------------------------------------
alter procedure SP_InsertarCliente 
@Nombre varchar(12), @Fecha_Nacimiento date, @Numero_Telefono char(10), @Correo varchar (30), @Direccion varchar(40)
AS
         declare @Actividad varchar(8)
		 declare @Actualizar as integer 
set @Actualizar=0
--mandar llamar al SP_BuscarArticulo
exec @Actualizar = SP_BuscarCliente @ID_Cliente
BEGIN
    if @Actualizar = 1
	BEGIN
	   Set @Actividad = 'Activo' 
       insert into Clientes(Nombre, Fecha_Nacimiento, Numero_Telefono, Correo, Direccion, Actividad)
       values(@Nombre, @Fecha_Nacimiento, @Numero_Telefono, @Correo, @Direccion, @Actividad)
       Print 'Se registr� con Exito...'
	   return @Actividad
	END
	else
	BEGIN
	   print 'El Cliente ya Existe'
    END
END
GO

Select * from Clientes

EXEC SP_InsertarCliente 'Bryan Gutierrez Alvarez', '02/12/1999', '6674589568', 'donbryan@gmail.com', 'Zona Dorada 2560', 'Activo'  
----------------------------------------------------
--  Procedimiento Almacenado para Agrgar Usuarios --
----------------------------------------------------
alter procedure SP_InsertarUsuario
@Nombre varchar(30), @Contrase�a varchar(10), @Numero_Telefono varchar(10), @Correo varchar (30), @Direccion varchar(40)
AS
BEGIN
    if not exists (Select * from Usuarios where Nombre=@Nombre or Correo=@Correo or Numero_Telefono=@Numero_Telefono)
	BEGIN
       insert into Usuarios(Nombre, Contrase�a, Numero_Telefono, Correo, Direccion)
       values(@Nombre,  @Contrase�a, @Numero_Telefono, @Correo , @Direccion )
       Print 'Se registr� con Exito...'
	END
	else
	BEGIN
	   print 'El Usuario ya Existe'
    END
END
GO
Exec SP_InsertarUsuario 'Bryan','123','6675894563','ejemplo@ejem.Com','Solidaridad'
-------------------------------------------------------
--  Procedimiento Almacenado para Agregar Articulos  --
-------------------------------------------------------
alter procedure SP_InsertarArticulo
@Nombre varchar(30), @Descripcion varchar(500), @Existencias integer, @Precio numeric (5,2)
AS
BEGIN
    if not exists (Select * from Inventario where Nombre=@Nombre)
	BEGIN
       insert into Inventario(Nombre, Descripcion, Existencias, Precio)
       values(@Nombre, @Descripcion, @Existencias, @Precio)
       Print 'Se registr� con Exito...'
	END
	else
	BEGIN
	   print 'El Articulo ya Existe'
    END
END
GO

Exec SP_InsertarArticulo 'Mesa de Roble', 'Es una mesa', 15, 750.25
select * from Inventario
------------------------------------------------------
--  Procedimiento Almacenado para Buscar Articulos  --
------------------------------------------------------
alter Procedure SP_BuscarArticulo @ID_Articulo integer
AS
Begin
     Declare @Encontro integer
     Set @Encontro = 0
     IF EXISTS (Select * From Inventario Where ID_Articulo = @ID_Articulo)
     Begin
          Set @Encontro = 1
          Print 'Articulo: ' + cast (@ID_Articulo as varchar(3)) + ' Encontrado'
          Return 1
     END

     Else 
     Begin
          Set @Encontro = 0
          Print 'El Articulo no Existe...'
          Return 0
     END
END 
GO

Exec SP_BuscarArticulo 2
-------------------------------------------------------
--  Procedimiento Almacenado para Eliminar Artculos  --
-------------------------------------------------------
ALTER procedure SP_EliminarArticulo
@ID_Articulo integer
AS
BEGIN
declare @Actualizar as integer 
set @Actualizar=0
--mandar llamar al SP_BuscarArticulo
exec @Actualizar = SP_BuscarArticulo @ID_Articulo
if @Actualizar=1
begin
    BEGIN TRANSACTION --Iniciar la transaccion
    BEGIN TRY
        DELETE FROM Inventario WHERE ID_Articulo = @ID_Articulo--borrar articulo
        COMMIT
        PRINT 'Articulo con ID ' + cast(@ID_Articulo as varchar(3)) + ' Eliminado  Correctamente'
    END TRY

    BEGIN CATCH
    ROLLBACK
        PRINT ERROR_MESSAGE()
        Print ERROR_LINE()
      END CATCH
      End
      Else 
      begin
        print 'Error el Articulo con ID '+ cast (@ID_Articulo as varchar(3)) + ' no pudo ser Borrado' 
      end
END
GO

exec SP_EliminarArticulo 2
----------------------------------------------------------
--  Procedimiento Almacenado para Actualizar Articulos  --
----------------------------------------------------------
create Procedure SP_ActualizarArticulos @ID_Articulo integer, @Nombre varchar(30), @Descripcion varchar(500), @Existencias integer, @Precio numeric (5,2)
AS
Begin
  Begin Transaction
  Begin Try
            Update Inventario Set Nombre=@Nombre, Descripcion=@Descripcion, Existencias=@Existencias, Precio=@Precio
            From Inventario Where ID_Articulo = @ID_Articulo
       Print 'Se Actualizaron los datos del Articulo '
       Commit 
  END Try

  Begin Catch
        Print 'Ha ocurrido un error .. ' + Error_Message() + ' en la linea ' +
        ERROR_Line()
    Rollback
    END Catch
END
GO

exec SP_ActualizarArticulos 3, 'Silla', 'Es una silla', 14, 760.25 
select * from Inventario
-----------------------------------------------------
--  Procedimiento Almacenado para Buscar Clientes  --
-----------------------------------------------------
create Procedure SP_BuscarCliente @ID_Cliente integer
AS
Begin
     Declare @Encontro integer
     Set @Encontro = 0
     IF EXISTS (Select * From Clientes Where ID_Cliente = @ID_Cliente)
     Begin
          Set @Encontro = 1
          Print 'Cliente con ID ' + CAST(@ID_Cliente AS varchar (3)) + ' Encontrado'
          Return 1
     END

     Else 
     Begin
          Set @Encontro = 0
          Print 'El Cliente no existe...'
          Return 0
     END
END 
GO
exec SP_BuscarCliente 1
select * from Clientes
-------------------------------------------------------
--  Procedimiento Almacenado para Eliminar Clientes  --
-------------------------------------------------------
create PROCEDURE SP_EliminarCliente @ID_Cliente integer
AS
BEGIN
declare @Actualizar as integer 
set @Actualizar=0
-----------------------------------------
--  mandar llamar al SP_buscarcliente  --
-----------------------------------------
exec @Actualizar = SP_BuscarCliente @ID_Cliente
if @Actualizar=1
begin

    BEGIN TRANSACTION --Iniciar la transaccion

    BEGIN TRY
        DELETE FROM Clientes WHERE ID_Cliente = @ID_Cliente--borrar cliente
        COMMIT
        PRINT 'Cliente con ID '+cast(@ID_Cliente as varchar(5)) + ' eliminado correctamente'
    END TRY

    BEGIN CATCH
    ROLLBACK
        PRINT ERROR_MESSAGE()
        Print ERROR_LINE()
      END CATCH
      End
      Else 
      begin
      print 'Error el Cliente '+ cast (@ID_Cliente as varchar(5)) + ' no pudo ser Borrado' 
      end
END
GO

exec SP_EliminarCliente 1
---------------------------------------------------------
--  Procedimiento Almacenado para Actualizar Clientes  --
---------------------------------------------------------
create Procedure SP_ActualizarClientes @ID_Cliente integer, @Numero_Telefono char(10), @Correo varchar (30), @Direccion varchar(40), @Actividad varchar(8)
AS
Begin
  Begin Transaction
  Begin Try
            Update Clientes Set Numero_Telefono=@Numero_Telefono, Correo=@Correo, Direccion=@Direccion, Actividad=@Actividad
            From Clientes Where ID_Cliente=@ID_Cliente
       Print 'Se actualizaron los datos del Cliente '
       Commit 
  END Try

  Begin Catch
        Print 'Ha ocurrido un error .. ' + Error_Message() + 'en la linea ' +
        ERROR_Line()
    Rollback
    END Catch
END
GO

exec SP_ActualizarClientes 1, '6678958848', 'bryan@gmail.com', 'Culiacan', 'Inactivo'
select * from Clientes
----------------------------------------------------
--  Procedimiento Almacenado para Buscar Usuario  --
----------------------------------------------------
alter Procedure SP_BuscarUsuario @Nombre varchar(30), @Contrase�a varchar(10), @Encontro varchar(30) Out
AS
Begin
     --Declare @Encontro integer
     --Set @Encontro = 0
     IF EXISTS (Select * From Usuarios Where Nombre = @Nombre and Contrase�a=@Contrase�a)
     Begin
          Set @Encontro = 'Buenvenido Sr(a): '+ @Nombre
          Print 'Cliente con ID ' + CAST(@Nombre AS varchar (30)) + ' Encontrado'
          --Return @Encontro
     END

     Else 
     Begin
          Set @Encontro = 'Error de Usuario o Contrase�a...'
          Print 'Error de Usuario o Contrase�a...'
          --Return @Encontro
     END
END 
GO
Exec SP_BuscarUsuario 'Bryan', '123',''
Select * From Usuarios