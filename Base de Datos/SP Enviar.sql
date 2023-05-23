use master
go

if exists(Select * FROM SysDataBases WHERE name='ProyectoFinal2')
BEGIN
	DROP DATABASE ProyectoFinal2
END
go

create login [IIS APPPOOL\DefaultAppPool] from windows
go

create database ProyectoFinal2
go

use ProyectoFinal2
go

create user [IIS APPPOOL\DefaultAppPool] for login [IIS APPPOOL\DefaultAppPool]
go

-- TABLAS --

create table UsuarioAdmin
(
	UsuarioLogueo varchar(20) primary key,
	Contrasena varchar(15) not null,
	Nombre varchar(50) not null,
	Apellido varchar(50) not null,
	Activo bit not null default 1
)
go

create table CategoriaPregunta
(
	Codigo char(4) primary key check(Codigo like '[A-Z][A-Z][A-Z][A-Z]'),
	Nombre varchar(30) not null,
	Activa bit not null default 1
)
go

create table Juego
(
	Codigo int identity (1,1) primary key,
	Dificultad varchar(10) not null check (Dificultad = 'Facil' or 
										   Dificultad = 'Medio' or 
										   Dificultad = 'Dificil'),
	FechaHora datetime not null default getdate(),
	UsuarioLogueo varchar(20) not null foreign key references UsuarioAdmin(UsuarioLogueo)
)
go

create table Pregunta
(
	Codigo char(5) primary key check(Codigo like '[0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]'),
	PuntajePregunta int not null check(PuntajePregunta > 0 and PuntajePregunta <= 10),
	Texto varchar(100) not null,
	CategPregunta char(4) not null foreign key references CategoriaPregunta(Codigo)
)
go

create table Respuesta
(
	CodRespuesta int,
	CodigoPregunta char(5) not null foreign key references Pregunta(Codigo),
	Texto varchar(100) not null,
	Correccion bit not null,
		Primary Key(CodRespuesta, CodigoPregunta)
)
go

create table Asigna
(
	CodJuego int not null foreign key references Juego(Codigo),
	CodPregunta char(5) not null foreign key references Pregunta(Codigo),
		Primary key (CodJuego, CodPregunta)
)
go

create table Jugada
(
	FechaHora datetime default getdate() primary key,
	Jugador varchar(50) not null,
	Juego int not null foreign key references Juego(Codigo),
	Puntaje int not null check(Puntaje > 0)
)
go

------------------ SP ------------------

-- LISTADO DE JUGADAS REALIZADAS --
create proc ListadoJugadas AS
Begin 
	select * from Jugada
End
go

-- GENERAR JUGADA --
create proc GenerarJugada @jugador varchar(50), @juego int, @puntaje int
AS
Begin
	if not exists (select * from Juego where Codigo = @juego)
		return -1
	
			INSERT INTO Jugada (Jugador, Juego, Puntaje)
			VALUES (@jugador, @juego, @puntaje)			
	
		if (@@ERROR <> 0)				
			return -2		
		else
			return 1
End
go

-- LOGUEO DE USUARIOADMIN --
create proc LogueodeUsuario @logueo varchar(20), @contrasena varchar(15) AS
Begin
	select * from UsuarioAdmin where UsuarioLogueo = @logueo and Activo = 1 and Contrasena = @contrasena
End
go

-- ASIGNAR PREGUNTA PARA JUEGO --
create proc AsignarPreguntapJuego @codJuego int, @codPregunta char(5) AS
Begin
	if not exists (select * from Juego where Codigo = @codJuego)
		return -1

	if not exists (select * from Pregunta where Codigo = @codPregunta)
		return -2

	if exists (select * from Asigna where CodJuego = @codJuego and CodPregunta = @codPregunta)
		return -3

	insert into Asigna (CodJuego, CodPregunta)
				values (@codJuego, @codPregunta)

	if @@ERROR = 0
		return 1
	else
		return 0
End
go

-- QUITAR PREGUNTA DE JUEGO --
create proc EliminarPreguntadeJuego @codJuego int, @codPregunta char(5) AS
Begin
	if not exists(select * from Asigna where CodJuego = @codJuego and CodPregunta = @codPregunta)
		return -1	
	
	delete from Asigna where CodJuego = @codJuego and CodPregunta = @codPregunta

	if @@ERROR <> 0
	  return -2
	else
	  return 1   
End
go

-- ALTA PREGUNTA --
create proc AltaPregunta @codigo char(5), @texto varchar(100), @puntaje int, @categoria char(4)
AS
Begin
	if exists (select * from Pregunta where Codigo = @codigo)
		return -1		     

		 insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
						VALUES (@codigo, @puntaje, @texto, @categoria)		 

    if (@@ERROR <> 0)		
		return -2
	else
		return 1
End
go

-- LISTADO DE PREGUNTAS DE UN JUEGO -- 
create proc ListadodePreguntasdeJuego @codJuego int AS
Begin
	select * from Pregunta where Codigo in (select CodPregunta from Asigna where CodJuego = @codJuego)	
End
go

-- BUSCAR PREGUNTA -- 
create proc BuscarPregunta @codigo char(5) AS
Begin 
	select * from Pregunta where Codigo = @codigo
End
go

-- PREGUNTAS NO ASOCIADAS A UN JUEGO -- 
create proc PreguntasinJuego AS
Begin
	select * from Pregunta where Codigo not in (select CodPregunta from Asigna)	
End
go

-- RESPUESTA PARA PREGUNTA --
create proc RespuestaparaPregunta @codigoPregunta char(5), @texto varchar(100), @correccion bit AS
Begin	
	if not exists (select * from Pregunta where Codigo = @codigoPregunta)
		return -1

	declare @variable int
	declare @codRespuesta int

	set @variable = (select max(CodRespuesta) from Respuesta where CodigoPregunta = @codigoPregunta)
		
	if (@variable is null)
		set @codRespuesta = 1
	else
		set @codRespuesta = @variable + 1

	insert into Respuesta(CodRespuesta, CodigoPregunta, Texto, Correccion)
					values(@codRespuesta, @codigoPregunta, @texto, @correccion)

	if @@ERROR <> 0
	   return -2
	else
	   return 1
End
go

-- RESPUESTAS DE PREGUNTA --
create proc RespuestasdePregunta @codigo char(5) AS
Begin
	select * from Respuesta where CodigoPregunta = @codigo
End
go

-- ALTA CATEGORIA --
create proc AltaCategoria @codigo char(4), @nombre varchar(30) AS
Begin		
		if exists (select * from CategoriaPregunta where Codigo = @codigo and Activa = 0)
			begin 				
				update CategoriaPregunta
				set Nombre = @nombre, Activa = 1
				where Codigo = @codigo
				return 1
			end		
		
		if exists (select * from CategoriaPregunta where Codigo = @codigo and Activa = 1)
			return -1

		insert CategoriaPregunta (Codigo, Nombre) 
						  values (@codigo, @nombre)
			return 1
End
go

-- MODIFICAR CATEGORIA --
create proc ModificarCategoria @codigo char(4), @nombre varchar(30) AS
Begin
	if not exists(Select * From CategoriaPregunta Where Codigo = @codigo and Activa = 1)			
		return -1
			
	else
		Begin
			Update CategoriaPregunta set Nombre = @nombre where Codigo = @codigo
				if (@@ERROR = 0)
					return 1
				else
					return -2
		End
End
go

-- BAJA CATEGORIA --
create procedure BajaCategoria @codigo char(4) AS
Begin		
		if not exists(select * from CategoriaPregunta where Codigo = @codigo)			
			return -1					
		
		if exists (select * from Pregunta where Pregunta.CategPregunta = @codigo)
			begin				
				update CategoriaPregunta set Activa = 0 where Codigo = @codigo
				return 1 
			End
		else
			begin
			delete from CategoriaPregunta where Codigo = @codigo
				if (@@ERROR = 0)
					return 1
				else
					return -2	
			end
end
go

-- BUSCAR CATEGORIA ACTIVA --
create proc BuscarCategoriaActiva @codigo char(4) AS
Begin
	select * from CategoriaPregunta where Codigo = @codigo and Activa = 1
End
go

-- BUSCAR CATEGORIA --
create proc BuscarCategoria @codigo char(4) AS
Begin
	select * from CategoriaPregunta where Codigo = @codigo
End
go

-- LISTADO DE CATEGORIAS --
create proc ListadoCategorias AS
Begin
	select * from CategoriaPregunta where Activa = 1
End
go

-- ALTA JUEGO --
create proc AltaJuego @dificultad varchar(10), @usuario varchar(20) AS
Begin
	if not exists (select * from UsuarioAdmin where UsuarioLogueo = @usuario and Activo = 1)
		return -1		
   
	     declare @idJuego int

		 insert into Juego (Dificultad, UsuarioLogueo)
		 VALUES (@dificultad, @usuario)

		 set @idJuego = @@IDENTITY
		 
    if (@@ERROR <> 0)		
		return -2
	else
		return @idJuego
End
go

-- MODIFICACIÓN DE JUEGO --
create proc ModificarJuego @codigo int, @dificultad varchar(10), @usuario varchar(20) AS
Begin
	if not exists (select * from Juego where Codigo = @codigo)
		return -1

	if not exists (select * from UsuarioAdmin where UsuarioLogueo = @usuario and Activo = 1)
		return -2	
   	     
		 update Juego set Dificultad = @dificultad, UsuarioLogueo = @usuario where Codigo = @codigo
		 		 
    if (@@ERROR <> 0)		
		return -3
	else
		return 1
End
go

-- BAJA JUEGO -- 
create proc BajaJuego @codigo int AS	
Begin	
	if not exists (select * from Juego where Codigo = @codigo)
		return -1

	if exists (select * from Jugada where Juego = @codigo)
	   return -2

	Begin tran		
	
		delete Asigna where CodJuego = @codigo

		if (@@error <> 0)
			begin
				rollback
				return -3
			end

		delete Juego where Codigo = @codigo	

		if (@@error <> 0)
			begin
				rollback
				return -4
			end
			
	Commit tran
		return 1	
End
go

-- BUSCAR JUEGO --
create proc BuscarJuego @codigo int AS
Begin
	select * from Juego where Codigo = @codigo
End
go

-- LISTADO DE JUEGOS QUE NO TENGAN JUGADAS PERO QUE SI TENGAN PREGUNTAS ASOCIADAS --
create proc JuegosinJugadaperoconPregunta AS
Begin
	select * from Juego where Codigo not in (select Juego from Jugada) and Codigo in (select CodJuego from Asigna)
End
go

-- LISTADOS DE JUEGOS CON PREGUNTAS ASIGNADAS --
create proc ListadoJuegosconPreguntas AS
Begin
	select * from Juego where Codigo in (select CodJuego from Asigna)	
End
go

-- JUEGOS QUE NO TIENEN PREGUNTAS ASIGNADAS -- 
create proc JuegosinPregunta AS
Begin
	select * from Juego where not Codigo in (select CodJuego from Asigna)
End
go

-- PREGUNTAS NUNCA USADAS -- 
create proc PreguntasNuncaUsadas AS
Begin
	select * from Pregunta where Codigo not in (select CodPregunta from Asigna)
End
go

-- ALTA USUARIOADMIN -- 
create proc AltaUsuAdmin @logueo varchar(20), @pass varchar(15),  @nombre varchar(50), @apellido varchar(50) AS
Begin
	Declare @VarSentencia varchar(200)
			
	if exists (select * from UsuarioAdmin where UsuarioLogueo = @logueo and Activo = 1)
		return -1
	
	Begin TRAN			
		Set @VarSentencia = 'Create Login [' +  @logueo + '] With Password = ' + QUOTENAME(@pass, '''')
		Exec (@VarSentencia)
		
		if (@@ERROR <> 0)
		Begin
			Rollback TRAN
			return -2
		end		
		
		Set @VarSentencia = 'Create User [' +  @logueo + '] From Login [' + @logueo + ']'
		Exec (@VarSentencia)
		
		if (@@ERROR <> 0)
		Begin
			Rollback TRAN
			return -3
		end		

		If exists (select * from UsuarioAdmin where UsuarioLogueo = @logueo and Activo = 0)
		begin 				
				update UsuarioAdmin
				set Contrasena = @pass, Nombre = @nombre, Apellido = @apellido, Activo = 1
				where UsuarioLogueo = @logueo

			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -4
			end
		end			
		
		Else
		Begin
		Insert UsuarioAdmin (UsuarioLogueo, Contrasena, Nombre, Apellido) 
				values (@logueo, @pass, @nombre, @apellido)

			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -5
			end
		End
	Commit TRAN	
		
		Exec sp_addsrvrolemember @loginame=@logueo, @rolename='securityAdmin'		
	
		Exec sp_addrolemember @rolename='RolUsuAdmin', @membername=@logueo
End
go

create proc ModificarUsuario @logueo varchar(20), @contrasena varchar(15), @nombre varchar(50), @apellido varchar(50) AS 
Begin
	if not exists(Select * From UsuarioAdmin Where UsuarioLogueo = @logueo and Activo = 1)		
		return -1

	Declare @VarSentencia varchar(200)

	if (Current_User = @logueo) 
	Begin
		Begin Tran						
		Update UsuarioAdmin set Contrasena = @contrasena, Nombre = @nombre, Apellido = @apellido where UsuarioLogueo = @logueo
		
		if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -2
			end

		Set @VarSentencia = 'Alter Login [' +  @logueo + '] With Password = ' + QUOTENAME(@contrasena, '''')
		Exec (@VarSentencia)
		
		if (@@ERROR <> 0)
		Begin
			Rollback TRAN
			return -3
		end	

		Commit TRAN
		return 1
	end

	Else
	Begin				
			Update UsuarioAdmin set Nombre = @nombre, Apellido = @apellido where UsuarioLogueo = @logueo
				if (@@ERROR = 0)
					return 1
				else
					return -2	
	End
	
End
go
------------------------------------------------------------------------------------------------------------------

create proc EliminarUsuario @logueo varchar(20) AS
Begin		
		if not exists(select * from UsuarioAdmin where UsuarioLogueo = @logueo)			
			return -1					
		
		declare @VarSentencia varchar(200)

		if exists (select * from Juego where UsuarioLogueo = @logueo)	
		Begin

		Begin Tran							
			update UsuarioAdmin set Activo = 0 where UsuarioLogueo = @logueo				
			
			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -2
			end	

			set @VarSentencia = 'DROP LOGIN [' + @logueo + ']'
				exec (@VarSentencia)

			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -3
			end				

			set @VarSentencia = 'DROP USER [' + @logueo + ']'
			exec (@VarSentencia)

			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -4
			end			
			
		Commit Tran
			return 1

		End

		Else
		Begin

		Begin Tran
				delete from UsuarioAdmin where UsuarioLogueo = @logueo

			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -2
			end	

				set @VarSentencia = 'DROP LOGIN [' + @logueo + ']'
				exec (@VarSentencia)
					
			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -5
			end	

				set @VarSentencia = 'DROP USER [' + @logueo + ']'
				exec (@VarSentencia)

			if (@@ERROR <> 0)
			Begin
				Rollback TRAN
				return -6
			end	
		Commit Tran
			return 1
		End
end
go

-- BUSCAR USUARIO ACTIVO --
create proc BuscarUsuarioActivo @logueo varchar(20) AS
Begin
	select * from UsuarioAdmin where UsuarioLogueo = @logueo and Activo = 1
End
go

-- BUSCAR USUARIO --
create proc BuscarUsuario @logueo varchar(20) AS
Begin
	select * from UsuarioAdmin where UsuarioLogueo = @logueo
End
go

------------------------------------------------------------------------------------------------------------------

-- ROL PUBLICO --
Grant execute on GenerarJugada to [IIS APPPOOL\DefaultAppPool]
Grant execute on ListadoJugadas to [IIS APPPOOL\DefaultAppPool] 
Grant execute on ListadoJuegosconPreguntas to [IIS APPPOOL\DefaultAppPool] 
Grant execute on ListadodePreguntasdeJuego to [IIS APPPOOL\DefaultAppPool] 
Grant execute on LogueodeUsuario to [IIS APPPOOL\DefaultAppPool] 
Grant execute on BuscarJuego to [IIS APPPOOL\DefaultAppPool]
Grant execute on BuscarUsuario to [IIS APPPOOL\DefaultAppPool]
Grant execute on BuscarCategoria to [IIS APPPOOL\DefaultAppPool] 
Grant execute on RespuestasdePregunta to [IIS APPPOOL\DefaultAppPool]  
go

------------------------------------------------------------------------------------------------------------------

-- ROLES Y PERMISOS --
create Role RolUsuAdmin
go

Grant execute on AsignarPreguntapJuego to RolUsuAdmin 
Grant execute on EliminarPreguntadeJuego to RolUsuAdmin 
Grant execute on AltaPregunta to RolUsuAdmin 
Grant execute on PreguntasinJuego to RolUsuAdmin 
Grant execute on RespuestaparaPregunta to RolUsuAdmin 
Grant execute on RespuestasdePregunta to RolUsuAdmin 
Grant execute on AltaCategoria to RolUsuAdmin 
Grant execute on ModificarCategoria to RolUsuAdmin 
Grant execute on BajaCategoria to RolUsuAdmin 
Grant execute on BuscarCategoriaActiva to RolUsuAdmin 
Grant execute on ListadoCategorias to RolUsuAdmin 
Grant execute on AltaJuego to RolUsuAdmin 
Grant execute on ModificarJuego to RolUsuAdmin 
Grant execute on BajaJuego to RolUsuAdmin 
Grant execute on BuscarJuego to RolUsuAdmin 
Grant execute on JuegosinJugadaperoconPregunta to RolUsuAdmin 
Grant execute on ListadoJuegosconPreguntas to RolUsuAdmin 
Grant execute on JuegosinPregunta to RolUsuAdmin 
Grant execute on PreguntasNuncaUsadas to RolUsuAdmin 
Grant execute on AltaUsuAdmin to RolUsuAdmin 
Grant execute on ModificarUsuario to RolUsuAdmin 
Grant execute on EliminarUsuario to RolUsuAdmin
Grant execute on BuscarUsuarioActivo to RolUsuAdmin
Grant execute on BuscarUsuario to RolUsuAdmin
Grant execute on BuscarPregunta to RolUsuAdmin

GRANT CREATE SCHEMA TO RolUsuAdmin
GRANT ALTER ANY USER TO RolUsuAdmin
GRANT ALTER ANY ROLE TO RolUsuAdmin
go

-----------------------------------------------------------------------------------------------------------

-- DATOS DE PRUEBA --

-- Usuarios --
AltaUsuAdmin 'UsuarioA', '1234', 'Pepito', 'Perez'
go
AltaUsuAdmin 'UsuarioB', '1234', 'Maria', 'Benitez'
go
AltaUsuAdmin 'UsuarioC', '1234', 'Martin', 'Pintos'
go

-- Categoria de Pregunta --
insert into CategoriaPregunta (Codigo, Nombre)
values ('CAPI', 'Capitales')

insert into CategoriaPregunta (Codigo, Nombre)
values ('HIST', 'Historia')

insert into CategoriaPregunta (Codigo, Nombre)
values ('MATM', 'Matematica')

insert into CategoriaPregunta (Codigo, Nombre)
values ('CULT', 'Cultura')

insert into CategoriaPregunta (Codigo, Nombre)
values ('URUG', 'Uruguay')

insert into CategoriaPregunta (Codigo, Nombre)
values ('ROCK', 'Rock N Roll')

insert into CategoriaPregunta (Codigo, Nombre)
values ('FUTB', 'Futbol')

insert into CategoriaPregunta (Codigo, Nombre)
values ('BRAS', 'Brasil')
go

-- Juegos --
insert into Juego (Dificultad, UsuarioLogueo)
values ('Medio', 'UsuarioC')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Dificil', 'UsuarioC')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioC')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioC')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Medio', 'UsuarioA')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Dificil', 'UsuarioB')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioA')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioB')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Medio', 'UsuarioA')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Dificil', 'UsuarioB')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioA')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioC')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Medio', 'UsuarioC')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Dificil', 'UsuarioC')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioA')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioA')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Medio', 'UsuarioA')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Dificil', 'UsuarioB')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioB')
go

insert into Juego (Dificultad, UsuarioLogueo)
values ('Facil', 'UsuarioB')
go

-- Preguntas --
-- 1 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('A1234', 10, 'Cuál es la capital de Uruguay?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'A1234', 'Montevideo', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'A1234', 'Buenos Aires', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'A1234', 'Brasilia', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('B1234', 5, 'Cuál es la capital de Argentina?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'B1234', 'Montevideo', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'B1234', 'Buenos Aires', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'B1234', 'Brasilia', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('C1234', 6, 'Cuál es la capital de Bolivia?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'C1234', 'Quito', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'C1234', 'Caracas', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'C1234', 'La Paz', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('D1234', 7, 'Cuál es la capital de Brasil?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'D1234', 'Rio de Janeiro', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'D1234', 'Salvador', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'D1234', 'Brasilia', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('E1234', 8, 'Cuál es la capital de Corea del Sur?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'E1234', 'Seúl', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'E1234', 'Pionyang', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'E1234', 'Inchon', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('F1234', 9, 'Cuál es la capital de Corea del Norte?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'F1234', 'Seúl', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'F1234', 'Pionyang', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'F1234', 'Inchon', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('G1234', 7, 'Cuál es la capital de Chile?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'G1234', 'Santiago', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'G1234', 'Arica', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'G1234', 'Antofagasta', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('H1234', 5, 'Cuál es la capital de la India?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'H1234', 'Bombay', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'H1234', 'Nueva Delhi', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'H1234', 'Calcuta', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('I1234', 5, 'Cuál es la capital de Pakistán?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'I1234', 'Faisalabad', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'I1234', 'Karachi', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'I1234', 'Islamabad', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('J1234', 4, 'Cuál es la capital de Afganistán?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'J1234', 'Kabul', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'J1234', 'Kandahar', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'J1234', 'Mazar-e-Sharif', 0)
go

-- 11 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('K1234', 10, 'Cuál es la capital de Turquia?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'K1234', 'Istambul', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'K1234', 'Ankara', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'K1234', 'Esmirna', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('L1234', 5, 'Cuál es la capital de Irán?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'L1234', 'Karaj', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'L1234', 'Mashhad', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'L1234', 'Teherán', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('M1234', 6, 'Cuál es la capital de Suiza?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'M1234', 'Berna', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'M1234', 'Zúrich', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'M1234', 'Ginebra', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('N1234', 8, 'Cuál es la capital de Noruega?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'N1234', 'Copenhague', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'N1234', 'Estocolmo', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'N1234', 'Oslo', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('O1234', 10, 'Cuál es la capital de Lituania?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'O1234', 'Vilna', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'O1234', 'Kaunas', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'O1234', 'Trakai', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('P1234', 5, 'Cuál es la capital de Ucrania?', 'CAPI')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'P1234', 'Moscú', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'P1234', 'Kiev', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'P1234', 'Lviv', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('Q1234', 5, 'Cuál es la capital de Belarus?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'Q1234', 'Minsk', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'Q1234', 'Brest', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'Q1234', 'Moguilov', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('R1234', 8, 'Cuál es la capital de Vietnam?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'R1234', 'Saigon', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'R1234', 'Ho Chi Minh', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'R1234', 'Hanoi', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('S1234', 9, 'En que año fue la declaración de independencia de Estados Unidos?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'S1234', '1783', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'S1234', '1776', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'S1234', '1803', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('T1234', 9, 'En que año fue proclamada la independencia de de Brasil?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'T1234', '1822', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'T1234', '1820', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'T1234', '1828', 0)
go

-- 21 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('TTTTT', 10, 'En que año fue la declaratoria de independencia de Uruguay?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'TTTTT', '1822', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'TTTTT', '1820', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'TTTTT', '1825', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('U1234', 6, 'En que año finalizó la primera guerra mundial?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'U1234', '1945', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'U1234', '1918', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'U1234', '1919', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('V1234', 5, 'En que año finalizó la segunda guerra mundial?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'V1234', '1949', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'V1234', '1947', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'V1234', '1945', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('X1234', 5, 'En que año fue la guerra de Malvinas?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'X1234', '1980', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'X1234', '1981', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'X1234', '1982', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('Z1234', 10, 'En que día del año 2022 se inició la guerra de Ucrania?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'Z1234', '1 de marzo', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'Z1234', '19 de febrero', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'Z1234', '24 de febrero', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('W1234', 5, 'En que año murió Napoleon Bonaparte?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'W1234', '1821', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'W1234', '1832', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'W1234', '1810', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('Y1234', 5, 'En que año se fundó Montevideo?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'Y1234', '1730', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'Y1234', '1723', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'Y1234', '1690', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('AA234', 7, 'Cuál fue la primer capital de Brasil?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'AA234', 'Brasilia', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'AA234', 'Salvador', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'AA234', 'Rio de Janeiro', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('BB234', 7, 'En que día fue el ataque japonés a la base de Pearl Harbour?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'BB234', '07/12/1940', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'BB234', '07/12/1941', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'BB234', '07/12/1942', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('CC234', 6, 'En que año fue la independencia de India?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'CC234', '1947', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'CC234', '1945', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'CC234', '1950', 0)
go

-- 31 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('DD234', 10, 'En que año se fundó el estado actual de Israel?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'DD234', '1946', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'DD234', '1947', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'DD234', '1948', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('EE234', 6, 'En que año los países balticos entraron en la Otan?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'EE234', '2000', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'EE234', '2004', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'EE234', '2009', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('FF234', 7, 'En que año el acorazado alemán Graff Spee estuvo en Montevideo?', 'HIST')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'FF234', '1939', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'FF234', '1940', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'FF234', '1941', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('GG234', 8, 'Cuántos departamentos tiene Uruguay?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'GG234', '18', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'GG234', '19', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'GG234', '20', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('II234', 10, 'Cuál es el deporte favorito de los uruguayos?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'II234', 'Tenis', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'II234', 'Fútbol', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'II234', 'Remo', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('JJ234', 9, 'Cuál es el partido de fútbol que va más gente al estadio en Uruguay?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'JJ234', 'Defensor vs Peñarol', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'JJ234', 'Nacional vs Cerro', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'JJ234', 'Peñarol vs Nacional', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('KK234', 6, 'En que año fue la declaratoria de independencia de Uruguay?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'KK234', '1825', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'KK234', '1826', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'KK234', '1827', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('LL234', 8, 'Cuántas veces la selección uruguaya de fútbol ganó el mundial?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'LL234', '4', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'LL234', '3', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'LL234', '2', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('MM234', 5, 'Cuántas veces la selección uruguaya de fútbol ganó la medalla de oro en juegos olímpicos?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'MM234', '1', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'MM234', '2', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'MM234', '3', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('NN234', 5, 'Es una ciudad famosa donde va mucha gente adinerada en uruguay...', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'NN234', 'Rivera', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'NN234', 'Artigas', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'NN234', 'Punta del Este', 1)
go

-- 41 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('OO234', 10, 'Cuál de estos departamentos NO está en el norte del Uruguay?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'OO234', 'Rivera', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'OO234', 'Artigas', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'OO234', 'Canelones', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('PP234', 6, 'Cuál de estos departamentos está en el norte del Uruguay?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'PP234', 'Maldonado', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'PP234', 'Montevideo', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'PP234', 'Artigas', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('QQ234', 7, 'Cuál de estos departamentos NO está pegado a Montevideo?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'QQ234', 'Canelones', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'QQ234', 'San José', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'QQ234', 'Rocha', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('RR234', 8, 'Cuál de estos departamentos está pegado a Montevideo?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'RR234', 'Rocha', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'RR234', 'San José', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'RR234', 'Maldonado', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('SS234', 10, 'Cuál es nombre del actual presidente del Uruguay?', 'URUG')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'SS234', 'Lacalle Pou', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'SS234', 'Pepe Mujica', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'SS234', 'Manini Rios', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('TT234', 9, 'Cuántos títulos mundiales tiene la selección de fútbol de Argentina?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'TT234', '2', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'TT234', '3', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'TT234', '4', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('UU234', 8, 'Cuantos títulos mundiales tiene la selección de fútbol de Brasil?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'UU234', '4', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'UU234', '5', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'UU234', '6', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('VV234', 5, 'Cuántos títulos mundiales tiene la selección de Inglaterra?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'VV234', '1', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'VV234', '2', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'VV234', '3', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('XX234', 5, 'Cuántos títulos mundiales tiene la selección de fútbol de Colombia?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'XX234', '0', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'XX234', '1', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'XX234', '2', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('ZZ234', 7, 'Cuántos títulos mundiales tiene la selección de fútbol de Alemania?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'ZZ234', '2', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'ZZ234', '3', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'ZZ234', '4', 1)
go

-- 51 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('WW234', 10, 'Cuántos títulos mundiales tiene la selección de fútbol de Italia?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'WW234', '2', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'WW234', '3', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'WW234', '4', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('YY234', 5, 'Cuántos títulos mundiales tiene la selección de fútbol de Francia?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'YY234', '2', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'YY234', '3', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'YY234', '4', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('AAA34', 5, 'Cuántos títulos mundiales tiene la selección de fútbol de Japón?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'AAA34', '0', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'AAA34', '1', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'AAA34', '2', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('BBB34', 4, 'Cuántos títulos mundiales tiene la selección de fútbol de Uruguay?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'BBB34', '1', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'BBB34', '2', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'BBB34', '3', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('CCC34', 10, 'Cuántos títulos mundiales tiene la selección de fútbol de Argentina?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'CCC34', '2', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'CCC34', '3', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'CCC34', '4', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('DDD34', 9, 'Cuántos títulos mundiales tiene la selección de fútbol de Chile?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'DDD34', '0', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'DDD34', '1', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'DDD34', '3', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('EEE34', 6, 'Cuántos títulos mundiales tiene la selección de fútbol de Estados Unidos?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'EEE34', '0', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'EEE34', '1', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'EEE34', '2', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('FFF34', 7, 'Cuántos títulos mundiales tiene la selección de fútbol de China?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'FFF34', '0', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'FFF34', '1', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'FFF34', '3', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('GGG34', 8, 'Cuántos títulos mundiales tiene la selección de fútbol de España?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'GGG34', '0', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'GGG34', '1', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'GGG34', '2', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('HHH34', 9, 'Cuántos títulos mundiales tiene la selección de fútbol de Brasil?', 'FUTB')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'HHH34', '4', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'HHH34', '5', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'HHH34', '6', 0)
go

-- 61 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('III34', 10, 'Cuál es la capital del estado de Rio Grande do Sul?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'III34', 'Santa maria', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'III34', 'Coritiba', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'III34', 'Porto Alegre', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('JJJ34', 7, 'Cuál es la capital del estado de Mato Grosso?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'JJJ34', 'Cuiabá', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'JJJ34', 'San Luis', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'JJJ34', 'Macapá', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('KKK34', 5, 'Cuál es la capital del estado de Paraná?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'KKK34', 'Belém', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'KKK34', 'Aracaju', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'KKK34', 'Coritiba', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('LLL34', 5, 'Cuál es la capital del estado de Amazonas?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'LLL34', 'Manaus', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'LLL34', 'Campinas', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'LLL34', 'Rio Branco', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('MMM34', 10, 'Cuál es la capital del estado de Roraima?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'MMM34', 'Manaus', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'MMM34', 'Porto Velho', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'MMM34', 'Boa Vista', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('NNN34', 10, 'Cuál es la capital del estado de Acre?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'NNN34', 'Porto Velho', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'NNN34', 'Boa Vista', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'NNN34', 'Rio Branco', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('OOO34', 9, 'Cuál es la capital del estado de Espíritu Santo?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'OOO34', 'San Luis', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'OOO34', 'Vitória', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'OOO34', 'Porto Alegre', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('PPP34', 8, 'Cuál es la capital del estado de Pará?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'PPP34', 'Belém', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'PPP34', 'Rio Branco', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'PPP34', 'Manaus', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('QQQ34', 7, 'Cuál es la capital del estado de Amapá?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'QQQ34', 'Manaus', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'QQQ34', 'Macapá', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'QQQ34', 'Belém', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('RRR34', 6, 'Cuál es la capital del estado de Tocantins?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'RRR34', 'Belém', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'RRR34', 'Palmas', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'RRR34', 'Macapá', 0)
go

-- 71 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('SSS34', 10, 'Cuál es la capital del estado de Rondonia?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'SSS34', 'Vitória', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'SSS34', 'Rio Branco', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'SSS34', 'Porto Velho', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('TTT34', 4, 'Cuál es la capital del estado de Mato Grosso do Sul?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'TTT34', 'Campo Grande', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'TTT34', 'Porto Velho', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'TTT34', 'Palmas', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('UUU34', 6, 'Cuál es la capital del estado de Bahía?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'UUU34', 'Vitória', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'UUU34', 'Salvador', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'UUU34', 'Recife', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('VVV34', 7, 'Cuál es la capital del estado de Paraíba?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'VVV34', 'João Pessoa', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'VVV34', 'Palmas', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'VVV34', 'Fortaleza', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('XXX34', 10, 'Cuál es la capital del estado de Pernambuco?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'XXX34', 'João Pessoa', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'XXX34', 'Recife', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'XXX34', 'Fortaleza', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('ZZZ34', 8, 'Cuál es la capital del estado de Sergipe?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'ZZZ34', 'Porto Velho', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'ZZZ34', 'Aracaju', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'ZZZ34', 'Fortaleza', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('WWW34', 9, 'Cuál es la capital del estado de Rio Grande do Norte?', 'BRAS')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'WWW34', 'Recife', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'WWW34', 'Aracaju', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'WWW34', 'Natal', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('YYY34', 6, 'Cuánto es 7 al cuadrado ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'YYY34', '47', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'YYY34', '48', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'YYY34', '49', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('AAAA4', 5, 'Cuánto es 8 al cuadrado ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'AAAA4', '64', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'AAAA4', '65', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'AAAA4', '66', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('BBBB4', 7, 'Cuánto es 9x9 ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'BBBB4', '83', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'BBBB4', '82', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'BBBB4', '81', 1)
go

-- 81 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('CCCC4', 10, 'Cuántos segundos son dos minutos y medio ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'CCCC4', '150', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'CCCC4', '170', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'CCCC4', '190', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('DDDD4', 5, 'Cuánto segundos son tres minutos ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'DDDD4', '160', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'DDDD4', '180', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'DDDD4', '200', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('EEEE4', 5, 'Cuánto es 300x300 ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'EEEE4', '150.000', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'EEEE4', '120.000', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'EEEE4', '90.000', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('FFFF4', 5, 'Cuál es un número primo ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'FFFF4', '15', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'FFFF4', '14', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'FFFF4', '13', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('GGGG4', 10, 'Cuál NO es un número primo ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'GGGG4', '15', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'GGGG4', '13', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'GGGG4', '11', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('HHHH4', 7, 'Cuánto es 6x7 ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'HHHH4', '49', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'HHHH4', '43', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'HHHH4', '42', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('IIII4', 8, 'Cuánto minutos son 180 segundos ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'IIII4', '6', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'IIII4', '4', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'IIII4', '3', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('JJJJ4', 9, 'Cuántos minutos son 300 segundos ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'JJJJ4', '5', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'JJJJ4', '6', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'JJJJ4', '7', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('KKKK4', 7, 'Cuánto es 9x7 ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'KKKK4', '73', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'KKKK4', '63', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'KKKK4', '62', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('LLLL4', 6, 'Cuántos minutos son 360 segundos ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'LLLL4', '5', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'LLLL4', '6', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'LLLL4', '7', 0)
go

-- 91 > --
insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('MMMM4', 10, 'Cuánto es 1000 dividido por 5 ?', 'MATM')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'MMMM4', '250', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'MMMM4', '225', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'MMMM4', '200', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('NNNN4', 5, 'Es una banda de Argentina...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'NNNN4', 'Chopper', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'NNNN4', 'Sepultura', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'NNNN4', 'Mastifal', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('OOOO4', 6, 'Es una banda Británica...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'OOOO4', 'Exodus', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'OOOO4', 'Metallica', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'OOOO4', 'Judas Priest', 1)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('PPPP4', 7, 'Es una banda de Estados Unidos...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'PPPP4', 'Metallica', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'PPPP4', 'Judas Priest', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'PPPP4', 'Iron Maiden', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('QQQQ4', 8, 'Es una banda Alemania...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'QQQQ4', 'Kreator', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'QQQQ4', 'Vader', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'QQQQ4', 'Nightwish', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('RRRR4', 9, 'Es una banda de Brasil...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'RRRR4', 'Megadeth', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'RRRR4', 'Sepultura', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'RRRR4', 'Brujeria', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('SSSS4', 6, 'Es una banda de Noruega...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'SSSS4', 'Dimmu Borgir', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'SSSS4', 'Dark Funeral', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'SSSS4', 'Carcass', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('TTTT4', 5, 'Es una banda de Finlandia...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'TTTT4', 'Stratovarius', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'TTTT4', 'Angra', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'TTTT4', 'Sodom', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('UUUU4', 4, 'Es una banda de Ucrania...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'UUUU4', 'Sonata Artica', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'UUUU4', 'Jinjer', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'UUUU4', 'Vader', 0)
go

insert into Pregunta (Codigo, PuntajePregunta, Texto, CategPregunta)
values ('VVVV4', 8, 'Es una banda de Polonia...', 'ROCK')

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (1, 'VVVV4', 'Exodus', 0)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (2, 'VVVV4', 'Vader', 1)

insert into Respuesta (CodRespuesta, CodigoPregunta, Texto, Correccion)
values (3, 'VVVV4', 'Nightwish', 0)
go

-- Asigna -- 
-- Juego 1 -- Capitales
insert into Asigna (CodJuego, CodPregunta)
values (1, 'A1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'B1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'C1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'D1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'E1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'F1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'G1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'H1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'I1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'J1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'K1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'L1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'M1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'N1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'O1234')

insert into Asigna (CodJuego, CodPregunta)
values (1, 'P1234')
go

-- Juego 2 -- HISTORIA
insert into Asigna (CodJuego, CodPregunta)
values (2, 'Q1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'R1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'S1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'T1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'U1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'V1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'X1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'Z1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'Y1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'W1234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'AA234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'BB234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'CC234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'DD234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'EE234')

insert into Asigna (CodJuego, CodPregunta)
values (2, 'FF234')
go

-- Juego 3 -- URUGUAY
insert into Asigna (CodJuego, CodPregunta)
values (3, 'GG234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'II234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'JJ234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'KK234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'LL234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'MM234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'NN234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'OO234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'PP234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'QQ234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'RR234')

insert into Asigna (CodJuego, CodPregunta)
values (3, 'SS234')
go

-- Juego 4 -- FUTBOL
insert into Asigna (CodJuego, CodPregunta)
values (4, 'TT234')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'UU234')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'VV234')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'XX234')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'ZZ234')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'YY234')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'WW234')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'AAA34')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'BBB34')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'CCC34')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'DDD34')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'EEE34')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'FFF34')

insert into Asigna (CodJuego, CodPregunta)
values (4, 'GGG34')
go

-- Juego 5 -- BRASIL
insert into Asigna (CodJuego, CodPregunta)
values (5, 'III34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'JJJ34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'KKK34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'LLL34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'MMM34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'NNN34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'OOO34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'PPP34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'QQQ34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'RRR34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'SSS34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'TTT34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'UUU34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'VVV34')

insert into Asigna (CodJuego, CodPregunta)
values (5, 'XXX34')
go

-- Juego 6 -- MATEMATICA
insert into Asigna (CodJuego, CodPregunta)
values (6, 'YYY34')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'AAAA4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'BBBB4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'CCCC4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'DDDD4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'EEEE4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'FFFF4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'GGGG4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'HHHH4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'IIII4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'JJJJ4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'KKKK4')

insert into Asigna (CodJuego, CodPregunta)
values (6, 'LLLL4')
go

-- Juego 7 -- ROCK/METAL
insert into Asigna (CodJuego, CodPregunta)
values (7, 'NNNN4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'OOOO4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'PPPP4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'QQQQ4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'RRRR4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'SSSS4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'TTTT4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'UUUU4')

insert into Asigna (CodJuego, CodPregunta)
values (7, 'VVVV4')
go

-- Juego 8 -- CAPITALES 2
insert into Asigna (CodJuego, CodPregunta)
values (8, 'F1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'G1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'H1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'I1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'J1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'K1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'L1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'M1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'N1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'O1234')

insert into Asigna (CodJuego, CodPregunta)
values (8, 'P1234')
go

-- Juego 9 -- HISTORIA 2
insert into Asigna (CodJuego, CodPregunta)
values (9, 'T1234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'U1234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'V1234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'X1234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'Z1234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'Y1234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'W1234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'AA234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'BB234')

insert into Asigna (CodJuego, CodPregunta)
values (9, 'CC234')
go

-- Juego 10 -- BRASIL 2
insert into Asigna (CodJuego, CodPregunta)
values (10, 'KKK34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'LLL34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'MMM34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'NNN34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'OOO34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'PPP34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'QQQ34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'RRR34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'SSS34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'TTT34')

insert into Asigna (CodJuego, CodPregunta)
values (10, 'UUU34')
go

-- Juego 11 -- Sin Jugada
insert into Asigna (CodJuego, CodPregunta)
values (11, 'GG234')

insert into Asigna (CodJuego, CodPregunta)
values (11, 'PP234')
go

-- Juego 12 -- 
insert into Asigna (CodJuego, CodPregunta)
values (12, 'S1234')

insert into Asigna (CodJuego, CodPregunta)
values (12, 'Y1234')

insert into Asigna (CodJuego, CodPregunta)
values (12, 'W1234')
go

-- Juego 13 -- 
insert into Asigna (CodJuego, CodPregunta)
values (13, 'MMM34')

insert into Asigna (CodJuego, CodPregunta)
values (13, 'NNN34')

insert into Asigna (CodJuego, CodPregunta)
values (13, 'OOO34')
go

-- Juego 14 -- Sin Jugada
insert into Asigna (CodJuego, CodPregunta)
values (14, 'H1234')

insert into Asigna (CodJuego, CodPregunta)
values (14, 'I1234')

insert into Asigna (CodJuego, CodPregunta)
values (14, 'J1234')
go

-- Juego 15 -- Sin Jugada
insert into Asigna (CodJuego, CodPregunta)
values (15, 'BBBB4')

insert into Asigna (CodJuego, CodPregunta)
values (15, 'CCCC4')

insert into Asigna (CodJuego, CodPregunta)
values (15, 'DDDD4')

insert into Asigna (CodJuego, CodPregunta)
values (15, 'EEEE4')
go

-- Juego 16 -- Sin Jugada
insert into Asigna (CodJuego, CodPregunta)
values (16, 'AA234')

insert into Asigna (CodJuego, CodPregunta)
values (16, 'NNN34')
go

-- Jugadas --
insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 20:00', 'Martin', 1, 50)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 19:00', 'Otro', 2, 40)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 18:00', 'Martin', 3, 55)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 17:00', 'Otro', 4, 40)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 16:00', 'Martin', 5, 48)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 15:00', 'Otro', 6, 50)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 14:00', 'Martin', 7, 47)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 13:00', 'Otro', 8, 38)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 12:00', 'Martin', 9, 35)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 11:00', 'Otro', 10, 40)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 12:30', 'Martin', 12, 25)

insert into Jugada (FechaHora, Jugador, Juego, Puntaje)
values ('2023/02/28 11:30', 'Otro', 13, 20)
go


--PUBLICAR SERVICIO
--http://localhost/ServicioJuego

--PARA HACER REFERENCIA DE SERVICIO
--http://localhost/ServicioJuego/servicio.svc (ip en lugar de "localhost")

--SI NO ABRE LA PAGINA, PONER ESTE CODIGO EN WEB.CONFIG DE UI
--<binding name="BasicHttpBinding_IServicio" maxBufferSize="2147483647" maxReceivedMessageSize="2147483647"/>



