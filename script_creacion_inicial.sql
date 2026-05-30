USE GD1C2026;
GO

PRINT 'MIGRACION EN PROCESO.. '
GO
PRINT 'SE CREA ESQUEMA DEL GRUPO...'
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'LOS_JOINEROS')
BEGIN
    EXEC('CREATE SCHEMA LOS_JOINEROS');
END
GO

PRINT 'SE COMIENZAN A GENERAR LAS TABLAS...'
GO

CREATE TABLE LOS_JOINEROS.Pais (
 pai_id int IDENTITY(1,1) NOT NULL,
 pai_nombre nvarchar(255) NOT NULL,
 CONSTRAINT PK_Pais PRIMARY KEY (pai_id)
);
GO

CREATE TABLE LOS_JOINEROS.Alianza (
 ali_id int IDENTITY(1,1) NOT NULL,
 ali_descripcion nvarchar(255) NOT NULL,
 CONSTRAINT PK_Alianza PRIMARY KEY (ali_id)
);
GO

CREATE TABLE LOS_JOINEROS.CanalVenta (
 cdv_id int IDENTITY(1,1) NOT NULL,
 cdv_descripcion nvarchar(255) NOT NULL,
 CONSTRAINT PK_CanalVenta PRIMARY KEY (cdv_id)
);
GO

CREATE TABLE LOS_JOINEROS.MedioPago (
 mdp_id int IDENTITY(1,1) NOT NULL,
 mdp_descripcion nvarchar(255) NOT NULL,
 CONSTRAINT PK_MedioPago PRIMARY KEY (mdp_id)
);
GO

CREATE TABLE LOS_JOINEROS.Estado_Propuesta (
 esp_id int IDENTITY(1,1) NOT NULL,
 esp_descripcion nvarchar(255) NOT NULL,
 CONSTRAINT PK_Estado_Propuesta PRIMARY KEY (esp_id)
);
GO

CREATE TABLE LOS_JOINEROS.Aspecto_Encuesta (
 asp_id int IDENTITY(1,1) NOT NULL,
 asp_descripcion nvarchar(255) NOT NULL,
 CONSTRAINT PK_Aspecto_Encuesta PRIMARY KEY (asp_id)
);
GO

CREATE TABLE LOS_JOINEROS.Provincia (
 pro_id int IDENTITY(1,1) NOT NULL,
 pro_pais int NOT NULL,
 pro_nombre nvarchar(255) NOT NULL,
 CONSTRAINT PK_Provincia PRIMARY KEY (pro_id),
 CONSTRAINT FK_Provincia_Pais FOREIGN KEY (pro_pais) REFERENCES LOS_JOINEROS.Pais (pai_id)
);
GO

CREATE TABLE LOS_JOINEROS.Localidad (
 loc_id int IDENTITY(1,1) NOT NULL,
 loc_provincia int NOT NULL,
 loc_nombre nvarchar(255) NOT NULL,
 CONSTRAINT PK_Localidad PRIMARY KEY (loc_id),
 CONSTRAINT FK_Localidad_Provincia FOREIGN KEY (loc_provincia) REFERENCES LOS_JOINEROS.Provincia (pro_id)
);
GO

CREATE TABLE LOS_JOINEROS.Ciudad (
 ciu_id int IDENTITY(1,1) NOT NULL,
 ciu_pais int NOT NULL,
 ciu_nombre nvarchar(255) NOT NULL,
 CONSTRAINT PK_Ciudad PRIMARY KEY (ciu_id),
 CONSTRAINT FK_Ciudad_Pais FOREIGN KEY (ciu_pais) REFERENCES LOS_JOINEROS.Pais (pai_id)
);
GO

CREATE TABLE LOS_JOINEROS.Agencia (
 age_nro_agencia bigint NOT NULL,
 age_localidad int NOT NULL,
 age_direccion nvarchar(255) NULL,
 age_telefono nvarchar(255) NULL,
 age_mail nvarchar(255) NULL,
 CONSTRAINT PK_Agencia PRIMARY KEY (age_nro_agencia),
 CONSTRAINT FK_Agencia_Localidad FOREIGN KEY (age_localidad) REFERENCES LOS_JOINEROS.Localidad (loc_id)
);
GO

CREATE TABLE LOS_JOINEROS.Agente (
 agt_legajo bigint NOT NULL,
 agt_agencia bigint NOT NULL,
 agt_localidad int NOT NULL,
 agt_dni nvarchar(255) NOT NULL,
 agt_nombre nvarchar(255) NOT NULL,
 agt_apellido nvarchar(255) NOT NULL,
 agt_fecha_nacimiento date NULL,
 agt_mail nvarchar(255) NULL,
 agt_telefono nvarchar(255) NULL,
 agt_direccion nvarchar(255) NULL,
 CONSTRAINT PK_Agente PRIMARY KEY (agt_legajo),
 CONSTRAINT FK_Agente_Agencia FOREIGN KEY (agt_agencia) REFERENCES LOS_JOINEROS.Agencia (age_nro_agencia),
 CONSTRAINT FK_Agente_Localidad FOREIGN KEY (agt_localidad) REFERENCES LOS_JOINEROS.Localidad (loc_id)
);
GO

CREATE TABLE LOS_JOINEROS.Cliente (
 cli_id int IDENTITY(1,1) NOT NULL,
 cli_localidad int NOT NULL,
 cli_dni nvarchar(255) NOT NULL,
 cli_nombre nvarchar(255) NOT NULL,
 cli_apellido nvarchar(255) NOT NULL,
 cli_fecha_nacimiento date NULL,
 cli_mail nvarchar(255) NULL,
 cli_telefono nvarchar(255) NULL,
 cli_direccion nvarchar(255) NULL,
 CONSTRAINT PK_Cliente PRIMARY KEY (cli_id),
 CONSTRAINT FK_Cliente_Localidad FOREIGN KEY (cli_localidad) REFERENCES LOS_JOINEROS.Localidad (loc_id)
);
GO

CREATE TABLE LOS_JOINEROS.Aerolinea (
 aero_codigo nvarchar(255) NOT NULL,
 aero_pais int NOT NULL,
 aero_alianza int NULL,
 aero_nombre nvarchar(255) NOT NULL,
 CONSTRAINT PK_Aerolinea PRIMARY KEY (aero_codigo),
 CONSTRAINT FK_Aerolinea_Pais FOREIGN KEY (aero_pais) REFERENCES LOS_JOINEROS.Pais (pai_id),
 CONSTRAINT FK_Aerolinea_Alianza FOREIGN KEY (aero_alianza) REFERENCES LOS_JOINEROS.Alianza (ali_id)
);
GO

CREATE TABLE LOS_JOINEROS.Aeropuerto (
 aer_codigo nvarchar(10) NOT NULL,
 aer_ciudad int NOT NULL,
 aer_descripcion nvarchar(200) NOT NULL,
 CONSTRAINT PK_Aeropuerto PRIMARY KEY (aer_codigo),
 CONSTRAINT FK_Aeropuerto_Ciudad FOREIGN KEY (aer_ciudad) REFERENCES LOS_JOINEROS.Ciudad (ciu_id)
);
GO

CREATE TABLE LOS_JOINEROS.Vuelo (
 vue_id int IDENTITY(1,1) NOT NULL,
 vue_aerolinea nvarchar(255) NOT NULL,
 vue_aeropuerto_salida nvarchar(10) NOT NULL,
 vue_aeropuerto_llegada nvarchar(10) NOT NULL,
 vue_fecha_salida date NOT NULL,
 vue_hora_salida nvarchar(50) NULL,
 vue_fecha_llegada date NOT NULL,
 vue_hora_llegada nvarchar(50) NULL,
 vue_duracion int NULL,
 vue_precio decimal(18,2) NULL,
 vue_incluye_carry bit NOT NULL DEFAULT 0,
 vue_incluye_valija bit NOT NULL DEFAULT 0,
 CONSTRAINT PK_Vuelo PRIMARY KEY (vue_id),
 CONSTRAINT FK_Vuelo_Aerolinea FOREIGN KEY (vue_aerolinea) REFERENCES LOS_JOINEROS.Aerolinea (aero_codigo),
 CONSTRAINT FK_Vuelo_AeropuertoSalida FOREIGN KEY (vue_aeropuerto_salida) REFERENCES LOS_JOINEROS.Aeropuerto (aer_codigo),
 CONSTRAINT FK_Vuelo_AeropuertoLlegada FOREIGN KEY (vue_aeropuerto_llegada) REFERENCES LOS_JOINEROS.Aeropuerto (aer_codigo)
);
GO

CREATE TABLE LOS_JOINEROS.Hospedaje (
 hos_id int IDENTITY(1,1) NOT NULL,
 hos_ciudad int NOT NULL,
 hos_nombre nvarchar(255) NOT NULL,
 hos_direccion nvarchar(255) NULL,
 hos_horario_checkin nvarchar(50) NULL,
 hos_horario_checkout nvarchar(50) NULL,
 hos_incluye_desayuno bit NOT NULL DEFAULT 0,
 CONSTRAINT PK_Hospedaje PRIMARY KEY (hos_id),
 CONSTRAINT FK_Hospedaje_Ciudad FOREIGN KEY (hos_ciudad) REFERENCES LOS_JOINEROS.Ciudad (ciu_id)
);
GO

CREATE TABLE LOS_JOINEROS.Tipo_Habitacion (
 tdh_id int IDENTITY(1,1) NOT NULL,
 tdh_hospedaje int NOT NULL,
 tdh_nombre nvarchar(255) NOT NULL,
 tdh_descripcion nvarchar(max) NOT NULL,
 tdh_cant_camas int NULL,
 tdh_precio_base decimal(18,2) NOT NULL,
 CONSTRAINT PK_Tipo_Habitacion PRIMARY KEY (tdh_id),
 CONSTRAINT FK_TipoHabitacion_Hospedaje FOREIGN KEY (tdh_hospedaje) REFERENCES LOS_JOINEROS.Hospedaje (hos_id)
);
GO

CREATE TABLE LOS_JOINEROS.Proveedor_Excursion (
 pre_id int IDENTITY(1,1) NOT NULL,
 pre_nombre nvarchar(255) NOT NULL,
 pre_mail nvarchar(255) NULL,
 pre_telefono nvarchar(255) NULL,
 CONSTRAINT PK_Proveedor_Excursion PRIMARY KEY (pre_id)
);
GO

CREATE TABLE LOS_JOINEROS.Excursion (
 exc_id int IDENTITY(1,1) NOT NULL,
 exc_proveedor int NOT NULL,
 exc_ciudad int NOT NULL,
 exc_nombre nvarchar(255) NOT NULL,
 exc_descripcion nvarchar(max) NULL,
 exc_duracion int NULL,
 exc_horario nvarchar(50) NULL,
 exc_precio decimal(18,2) NOT NULL,
 CONSTRAINT PK_Excursion PRIMARY KEY (exc_id),
 CONSTRAINT FK_Excursion_Proveedor FOREIGN KEY (exc_proveedor) REFERENCES LOS_JOINEROS.Proveedor_Excursion (pre_id),
 CONSTRAINT FK_Excursion_Ciudad FOREIGN KEY (exc_ciudad) REFERENCES LOS_JOINEROS.Ciudad (ciu_id)
);
GO

CREATE TABLE LOS_JOINEROS.Solicitud_Cotizacion (
 sol_nro bigint NOT NULL,
 sol_cliente int NOT NULL,
 sol_agente bigint NOT NULL,
 sol_fecha_solicitud date NOT NULL,
 sol_fecha_inicio_tentativa date NULL,
 sol_fecha_fin_tentativa date NULL,
 sol_cant_pasajeros int NULL,
 sol_presupuesto decimal(18,2) NULL,
 sol_observaciones nvarchar(max) NULL,
 CONSTRAINT PK_Solicitud_Cotizacion PRIMARY KEY (sol_nro),
 CONSTRAINT FK_Solicitud_Cliente FOREIGN KEY (sol_cliente) REFERENCES LOS_JOINEROS.Cliente (cli_id),
 CONSTRAINT FK_Solicitud_Agente FOREIGN KEY (sol_agente) REFERENCES LOS_JOINEROS.Agente (agt_legajo)
);
GO

CREATE TABLE LOS_JOINEROS.Detalle_Solicitud (
 ds_id int IDENTITY(1,1) NOT NULL,
 ds_solicitud bigint NOT NULL,
 ds_ciudad int NOT NULL,
 ds_cant_dias int NULL,
 ds_observaciones nvarchar(max) NULL,
 CONSTRAINT PK_Detalle_Solicitud PRIMARY KEY (ds_id),
 CONSTRAINT FK_DetalleSolicitud_Solicitud FOREIGN KEY (ds_solicitud) REFERENCES LOS_JOINEROS.Solicitud_Cotizacion (sol_nro),
 CONSTRAINT FK_DetalleSolicitud_Ciudad FOREIGN KEY (ds_ciudad) REFERENCES LOS_JOINEROS.Ciudad (ciu_id)
);
GO

CREATE TABLE LOS_JOINEROS.Propuesta (
 prop_nro_propuesta bigint NOT NULL,
 prop_solicitud bigint NOT NULL,
 prop_agente bigint NOT NULL,
 prop_estado int NOT NULL,
 prop_fecha date NOT NULL,
 prop_vigencia date NULL,
 prop_fecha_desde date NULL,
 prop_fecha_hasta date NULL,
 prop_subtotal decimal(18,2) NULL,
 prop_descuento decimal(18,2) NULL DEFAULT 0,
 prop_total decimal(18,2) NULL,
 CONSTRAINT PK_Propuesta PRIMARY KEY (prop_nro_propuesta),
 CONSTRAINT FK_Propuesta_Solicitud FOREIGN KEY (prop_solicitud) REFERENCES LOS_JOINEROS.Solicitud_Cotizacion (sol_nro),
 CONSTRAINT FK_Propuesta_Agente FOREIGN KEY (prop_agente) REFERENCES LOS_JOINEROS.Agente (agt_legajo),
 CONSTRAINT FK_Propuesta_Estado FOREIGN KEY (prop_estado) REFERENCES LOS_JOINEROS.Estado_Propuesta (esp_id)
);
GO

CREATE TABLE LOS_JOINEROS.Propuesta_Vuelo (
 pv_id int IDENTITY(1,1) NOT NULL,
 pv_propuesta bigint NOT NULL,
 pv_vuelo int NOT NULL,
 pv_cantidad int NOT NULL,
 pv_precio decimal(18,2) NOT NULL,
 pv_subtotal decimal(18,2) NOT NULL,
 CONSTRAINT PK_Propuesta_Vuelo PRIMARY KEY (pv_id),
 CONSTRAINT FK_PropuestaVuelo_Propuesta FOREIGN KEY (pv_propuesta) REFERENCES LOS_JOINEROS.Propuesta (prop_nro_propuesta),
 CONSTRAINT FK_PropuestaVuelo_Vuelo FOREIGN KEY (pv_vuelo) REFERENCES LOS_JOINEROS.Vuelo (vue_id)
);
GO

CREATE TABLE LOS_JOINEROS.Propuesta_Hospedaje (
 ph_id int IDENTITY(1,1) NOT NULL,
 ph_propuesta bigint NOT NULL,
 ph_tipo_habitacion int NOT NULL,
 ph_fecha_desde date NULL,
 ph_fecha_hasta date NULL,
 ph_cant_habitaciones int NOT NULL,
 ph_precio decimal(18,2) NOT NULL,
 ph_subtotal decimal(18,2) NOT NULL,
 CONSTRAINT PK_Propuesta_Hospedaje PRIMARY KEY (ph_id),
 CONSTRAINT FK_PropuestaHospedaje_Propuesta FOREIGN KEY (ph_propuesta) REFERENCES LOS_JOINEROS.Propuesta (prop_nro_propuesta),
 CONSTRAINT FK_PropuestaHospedaje_TipoHab FOREIGN KEY (ph_tipo_habitacion) REFERENCES LOS_JOINEROS.Tipo_Habitacion (tdh_id)
);
GO

CREATE TABLE LOS_JOINEROS.Venta (
 ven_nro_venta bigint NOT NULL,
 ven_cliente int NOT NULL,
 ven_agente bigint NOT NULL,
 ven_canal_venta int NOT NULL,
 ven_medio_pago int NOT NULL,
 ven_propuesta bigint NULL,
 ven_fecha date NOT NULL,
 ven_subtotal decimal(18,2) NULL,
 ven_descuento decimal(18,2) NULL DEFAULT 0,
 ven_total decimal(18,2) NULL,
 CONSTRAINT PK_Venta PRIMARY KEY (ven_nro_venta),
 CONSTRAINT FK_Venta_Cliente FOREIGN KEY (ven_cliente) REFERENCES LOS_JOINEROS.Cliente (cli_id),
 CONSTRAINT FK_Venta_Agente FOREIGN KEY (ven_agente) REFERENCES LOS_JOINEROS.Agente (agt_legajo),
 CONSTRAINT FK_Venta_CanalVenta FOREIGN KEY (ven_canal_venta) REFERENCES LOS_JOINEROS.CanalVenta (cdv_id),
 CONSTRAINT FK_Venta_MedioPago FOREIGN KEY (ven_medio_pago) REFERENCES LOS_JOINEROS.MedioPago (mdp_id),
 CONSTRAINT FK_Venta_Propuesta FOREIGN KEY (ven_propuesta) REFERENCES LOS_JOINEROS.Propuesta (prop_nro_propuesta)
);
GO

CREATE TABLE LOS_JOINEROS.Venta_Vuelo (
 vv_id int IDENTITY(1,1) NOT NULL,
 vv_venta bigint NOT NULL,
 vv_vuelo int NOT NULL,
 vv_cant_pasajes int NOT NULL,
 vv_precio decimal(18,2) NOT NULL,
 vv_subtotal decimal(18,2) NOT NULL,
 vv_codigo_reserva nvarchar(255) NULL,
 CONSTRAINT PK_Venta_Vuelo PRIMARY KEY (vv_id),
 CONSTRAINT FK_VentaVuelo_Venta FOREIGN KEY (vv_venta) REFERENCES LOS_JOINEROS.Venta (ven_nro_venta),
 CONSTRAINT FK_VentaVuelo_Vuelo FOREIGN KEY (vv_vuelo) REFERENCES LOS_JOINEROS.Vuelo (vue_id)
);
GO

CREATE TABLE LOS_JOINEROS.Venta_Hospedaje (
 vh_id int IDENTITY(1,1) NOT NULL,
 vh_venta bigint NOT NULL,
 vh_tipo_habitacion int NOT NULL,
 vh_fecha_desde date NULL,
 vh_fecha_hasta date NULL,
 vh_cantidad int NOT NULL,
 vh_precio decimal(18,2) NOT NULL,
 vh_subtotal decimal(18,2) NOT NULL,
 vh_codigo_reserva nvarchar(255) NULL,
 CONSTRAINT PK_Venta_Hospedaje PRIMARY KEY (vh_id),
 CONSTRAINT FK_VentaHospedaje_Venta FOREIGN KEY (vh_venta) REFERENCES LOS_JOINEROS.Venta (ven_nro_venta),
 CONSTRAINT FK_VentaHospedaje_TipoHab FOREIGN KEY (vh_tipo_habitacion) REFERENCES LOS_JOINEROS.Tipo_Habitacion (tdh_id)
);
GO

CREATE TABLE LOS_JOINEROS.Venta_Excursion (
 ve_id int IDENTITY(1,1) NOT NULL,
 ve_venta bigint NOT NULL,
 ve_excursion int NOT NULL,
 ve_fecha date NULL,
 ve_cantidad int NOT NULL,
 ve_precio decimal(18,2) NOT NULL,
 ve_subtotal decimal(18,2) NOT NULL,
 ve_codigo_reserva nvarchar(255) NULL,
 CONSTRAINT PK_Venta_Excursion PRIMARY KEY (ve_id),
 CONSTRAINT FK_VentaExcursion_Venta FOREIGN KEY (ve_venta) REFERENCES LOS_JOINEROS.Venta (ven_nro_venta),
 CONSTRAINT FK_VentaExcursion_Excursion FOREIGN KEY (ve_excursion) REFERENCES LOS_JOINEROS.Excursion (exc_id)
);
GO

CREATE TABLE LOS_JOINEROS.Encuesta (
 enc_id bigint NOT NULL,
 enc_cliente int NOT NULL,
 enc_agente bigint NOT NULL,
 enc_venta bigint NULL,
 enc_solicitud bigint NULL,
 enc_fecha date NOT NULL,
 enc_comentario nvarchar(max) NULL,
 CONSTRAINT PK_Encuesta PRIMARY KEY (enc_id),
 CONSTRAINT FK_Encuesta_Cliente FOREIGN KEY (enc_cliente) REFERENCES LOS_JOINEROS.Cliente (cli_id),
 CONSTRAINT FK_Encuesta_Agente FOREIGN KEY (enc_agente) REFERENCES LOS_JOINEROS.Agente (agt_legajo),
 CONSTRAINT FK_Encuesta_Venta FOREIGN KEY (enc_venta) REFERENCES LOS_JOINEROS.Venta (ven_nro_venta),
 CONSTRAINT FK_Encuesta_Solicitud FOREIGN KEY (enc_solicitud) REFERENCES LOS_JOINEROS.Solicitud_Cotizacion (sol_nro),
 CONSTRAINT CK_Encuesta_Origen CHECK (
  (enc_venta IS NOT NULL AND enc_solicitud IS NULL) OR
  (enc_venta IS NULL AND enc_solicitud IS NOT NULL)
 )
);
GO

CREATE TABLE LOS_JOINEROS.Valoracion_Encuesta (
 val_id int IDENTITY(1,1) NOT NULL,
 val_encuesta bigint NOT NULL,
 val_aspecto int NOT NULL,
 val_puntaje int NOT NULL,
 CONSTRAINT PK_Valoracion_Encuesta PRIMARY KEY (val_id),
 CONSTRAINT FK_Valoracion_Encuesta FOREIGN KEY (val_encuesta) REFERENCES LOS_JOINEROS.Encuesta (enc_id),
 CONSTRAINT FK_Valoracion_Aspecto FOREIGN KEY (val_aspecto) REFERENCES LOS_JOINEROS.Aspecto_Encuesta (asp_id),
 CONSTRAINT CK_Valoracion_Puntaje CHECK (val_puntaje BETWEEN 1 AND 5)
);
GO

PRINT 'SE COMIENZAN A GENERAR LOS INDICES...'
GO

CREATE INDEX IX_Provincia_Pais ON LOS_JOINEROS.Provincia (pro_pais);
CREATE INDEX IX_Localidad_Provincia ON LOS_JOINEROS.Localidad (loc_provincia);
CREATE INDEX IX_Ciudad_Pais ON LOS_JOINEROS.Ciudad (ciu_pais);
CREATE INDEX IX_Agente_Agencia ON LOS_JOINEROS.Agente (agt_agencia);
CREATE INDEX IX_Agente_DNI ON LOS_JOINEROS.Agente (agt_dni);
CREATE INDEX IX_Cliente_DNI ON LOS_JOINEROS.Cliente (cli_dni);
CREATE INDEX IX_Vuelo_Aerolinea ON LOS_JOINEROS.Vuelo (vue_aerolinea);
CREATE INDEX IX_Vuelo_FechaSalida ON LOS_JOINEROS.Vuelo (vue_fecha_salida);
CREATE INDEX IX_Vuelo_Salida ON LOS_JOINEROS.Vuelo (vue_aeropuerto_salida);
CREATE INDEX IX_Vuelo_Llegada ON LOS_JOINEROS.Vuelo (vue_aeropuerto_llegada);
CREATE INDEX IX_TipoHab_Hospedaje ON LOS_JOINEROS.Tipo_Habitacion (tdh_hospedaje);
CREATE INDEX IX_Hospedaje_Ciudad ON LOS_JOINEROS.Hospedaje (hos_ciudad);
CREATE INDEX IX_Excursion_Ciudad ON LOS_JOINEROS.Excursion (exc_ciudad);
CREATE INDEX IX_Venta_Cliente ON LOS_JOINEROS.Venta (ven_cliente);
CREATE INDEX IX_Venta_Agente ON LOS_JOINEROS.Venta (ven_agente);
CREATE INDEX IX_Venta_Fecha ON LOS_JOINEROS.Venta (ven_fecha);
CREATE INDEX IX_Venta_Propuesta ON LOS_JOINEROS.Venta (ven_propuesta);
CREATE INDEX IX_VentaVuelo_Venta ON LOS_JOINEROS.Venta_Vuelo (vv_venta);
CREATE INDEX IX_VentaHosp_Venta ON LOS_JOINEROS.Venta_Hospedaje (vh_venta);
CREATE INDEX IX_VentaExc_Venta ON LOS_JOINEROS.Venta_Excursion (ve_venta);
CREATE INDEX IX_Solicitud_Cliente ON LOS_JOINEROS.Solicitud_Cotizacion (sol_cliente);
CREATE INDEX IX_Solicitud_Fecha ON LOS_JOINEROS.Solicitud_Cotizacion (sol_fecha_solicitud);
CREATE INDEX IX_Propuesta_Solicitud ON LOS_JOINEROS.Propuesta (prop_solicitud);
CREATE INDEX IX_Propuesta_Agente ON LOS_JOINEROS.Propuesta (prop_agente);
CREATE INDEX IX_Propuesta_Estado ON LOS_JOINEROS.Propuesta (prop_estado);
CREATE INDEX IX_Encuesta_Cliente ON LOS_JOINEROS.Encuesta (enc_cliente);
CREATE INDEX IX_Encuesta_Agente ON LOS_JOINEROS.Encuesta (enc_agente);
CREATE INDEX IX_Encuesta_Fecha ON LOS_JOINEROS.Encuesta (enc_fecha);
CREATE INDEX IX_Valoracion_Encuesta ON LOS_JOINEROS.Valoracion_Encuesta (val_encuesta);
GO

PRINT 'SE COMIENZAN A GENERAR LOS SP DE LA MIGRA...'
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_PAIS
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Pais (pai_nombre)
 SELECT DISTINCT Aerolinea_Pais FROM gd_esquema.Maestra WHERE Aerolinea_Pais IS NOT NULL
 UNION
 SELECT DISTINCT Aeropuerto_Salida_Pais FROM gd_esquema.Maestra WHERE Aeropuerto_Salida_Pais IS NOT NULL
 UNION
 SELECT DISTINCT Aeropuerto_Llegada_Pais FROM gd_esquema.Maestra WHERE Aeropuerto_Llegada_Pais IS NOT NULL
 UNION
 SELECT DISTINCT Hospedaje_Pais FROM gd_esquema.Maestra WHERE Hospedaje_Pais IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_ALIANZA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Alianza (ali_descripcion)
 SELECT DISTINCT Aerolinea_Alianza
 FROM gd_esquema.Maestra
 WHERE Aerolinea_Alianza IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_CANALVENTA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.CanalVenta (cdv_descripcion)
 SELECT DISTINCT Venta_Canal_Venta
 FROM gd_esquema.Maestra
 WHERE Venta_Canal_Venta IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_MEDIOPAGO
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.MedioPago (mdp_descripcion)
 SELECT DISTINCT Venta_Medio_Pago
 FROM gd_esquema.Maestra
 WHERE Venta_Medio_Pago IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_ESTADO_PROPUESTA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Estado_Propuesta (esp_descripcion)
 SELECT DISTINCT Propuesta_Estado
 FROM gd_esquema.Maestra
 WHERE Propuesta_Estado IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_ASPECTO_ENCUESTA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Aspecto_Encuesta (asp_descripcion)
 SELECT DISTINCT Aspecto_Aspecto
 FROM gd_esquema.Maestra
 WHERE Aspecto_Aspecto IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_PROVINCIA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Provincia (pro_pais, pro_nombre)
 SELECT DISTINCT p.pai_id, src.pro_nombre
 FROM (
  SELECT DISTINCT Agencia_Provincia AS pro_nombre FROM gd_esquema.Maestra WHERE Agencia_Provincia IS NOT NULL
  UNION
  SELECT DISTINCT Agente_Provincia FROM gd_esquema.Maestra WHERE Agente_Provincia IS NOT NULL
  UNION
  SELECT DISTINCT Cliente_Provincia FROM gd_esquema.Maestra WHERE Cliente_Provincia IS NOT NULL
 ) src
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = (SELECT TOP 1 pai_nombre FROM LOS_JOINEROS.Pais ORDER BY pai_id);
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_LOCALIDAD
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Localidad (loc_provincia, loc_nombre)
 SELECT DISTINCT pr.pro_id, m.Agencia_Localidad
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Provincia pr ON pr.pro_nombre = m.Agencia_Provincia
 WHERE m.Agencia_Localidad IS NOT NULL;

 INSERT INTO LOS_JOINEROS.Localidad (loc_provincia, loc_nombre)
 SELECT DISTINCT pr.pro_id, m.Agente_Localidad
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Provincia pr ON pr.pro_nombre = m.Agente_Provincia
 WHERE m.Agente_Localidad IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM LOS_JOINEROS.Localidad l WHERE l.loc_nombre = m.Agente_Localidad AND l.loc_provincia = pr.pro_id);

 INSERT INTO LOS_JOINEROS.Localidad (loc_provincia, loc_nombre)
 SELECT DISTINCT pr.pro_id, m.Cliente_Localidad
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Provincia pr ON pr.pro_nombre = m.Cliente_Provincia
 WHERE m.Cliente_Localidad IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM LOS_JOINEROS.Localidad l WHERE l.loc_nombre = m.Cliente_Localidad AND l.loc_provincia = pr.pro_id);
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_CIUDAD
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Ciudad (ciu_pais, ciu_nombre)
 SELECT DISTINCT p.pai_id, m.Aeropuerto_Salida_Ciudad
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = m.Aeropuerto_Salida_Pais
 WHERE m.Aeropuerto_Salida_Ciudad IS NOT NULL;

 INSERT INTO LOS_JOINEROS.Ciudad (ciu_pais, ciu_nombre)
 SELECT DISTINCT p.pai_id, m.Aeropuerto_Llegada_Ciudad
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = m.Aeropuerto_Llegada_Pais
 WHERE m.Aeropuerto_Llegada_Ciudad IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM LOS_JOINEROS.Ciudad c WHERE c.ciu_nombre = m.Aeropuerto_Llegada_Ciudad AND c.ciu_pais = p.pai_id);

 INSERT INTO LOS_JOINEROS.Ciudad (ciu_pais, ciu_nombre)
 SELECT DISTINCT p.pai_id, m.Hospedaje_Ciudad
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = m.Hospedaje_Pais
 WHERE m.Hospedaje_Ciudad IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM LOS_JOINEROS.Ciudad c WHERE c.ciu_nombre = m.Hospedaje_Ciudad AND c.ciu_pais = p.pai_id);

 INSERT INTO LOS_JOINEROS.Ciudad (ciu_pais, ciu_nombre)
 SELECT DISTINCT p.pai_id, m.Detalle_Solicitud_Ciudad
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_id = (SELECT TOP 1 pai_id FROM LOS_JOINEROS.Pais ORDER BY pai_id)
 WHERE m.Detalle_Solicitud_Ciudad IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM LOS_JOINEROS.Ciudad c WHERE c.ciu_nombre = m.Detalle_Solicitud_Ciudad);
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_AGENCIA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Agencia (age_nro_agencia, age_localidad, age_direccion, age_telefono, age_mail)
 SELECT DISTINCT m.Agencia_Nro_Agencia, l.loc_id, m.Agencia_Direccion, m.Agencia_Telefono, m.Agencia_Mail
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Provincia pr ON pr.pro_nombre = m.Agencia_Provincia
 INNER JOIN LOS_JOINEROS.Localidad l ON l.loc_nombre = m.Agencia_Localidad AND l.loc_provincia = pr.pro_id
 WHERE m.Agencia_Nro_Agencia IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_AGENTE
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Agente (agt_legajo, agt_agencia, agt_localidad, agt_dni, agt_nombre, agt_apellido, agt_fecha_nacimiento, agt_mail, agt_telefono, agt_direccion)
 SELECT DISTINCT m.Agente_Legajo, m.Agencia_Nro_Agencia, l.loc_id, m.Agente_Dni, m.Agente_Nombre, m.Agente_Apellido, m.Agente_Fecha_Nac, m.Agente_Mail, m.Agente_Telefono, m.Agente_Direccion
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Provincia pr ON pr.pro_nombre = m.Agente_Provincia
 INNER JOIN LOS_JOINEROS.Localidad l ON l.loc_nombre = m.Agente_Localidad AND l.loc_provincia = pr.pro_id
 WHERE m.Agente_Legajo IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_CLIENTE
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Cliente (cli_localidad, cli_dni, cli_nombre, cli_apellido, cli_fecha_nacimiento, cli_mail, cli_telefono, cli_direccion)
 SELECT DISTINCT l.loc_id, m.Cliente_Dni, m.Cliente_Nombre, m.Cliente_Apellido, m.Cliente_Fecha_Nac, m.Cliente_Mail, m.Cliente_Tel, m.Cliente_Direccion
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Provincia pr ON pr.pro_nombre = m.Cliente_Provincia
 INNER JOIN LOS_JOINEROS.Localidad l ON l.loc_nombre = m.Cliente_Localidad AND l.loc_provincia = pr.pro_id
 WHERE m.Cliente_Dni IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_AEROLINEA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Aerolinea (aero_codigo, aero_pais, aero_alianza, aero_nombre)
 SELECT DISTINCT m.Aerolinea_Codigo, p.pai_id, a.ali_id, m.Aerolinea_Nombre
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = m.Aerolinea_Pais
 LEFT JOIN LOS_JOINEROS.Alianza a ON a.ali_descripcion = m.Aerolinea_Alianza
 WHERE m.Aerolinea_Codigo IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_AEROPUERTO
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Aeropuerto (aer_codigo, aer_ciudad, aer_descripcion)
 SELECT DISTINCT m.Aeropuerto_Salida_Codigo, c.ciu_id, m.Aeropuerto_Salida_Descripcion
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = m.Aeropuerto_Salida_Pais
 INNER JOIN LOS_JOINEROS.Ciudad c ON c.ciu_nombre = m.Aeropuerto_Salida_Ciudad AND c.ciu_pais = p.pai_id
 WHERE m.Aeropuerto_Salida_Codigo IS NOT NULL;

 INSERT INTO LOS_JOINEROS.Aeropuerto (aer_codigo, aer_ciudad, aer_descripcion)
 SELECT DISTINCT m.Aeropuerto_Llegada_Codigo, c.ciu_id, m.Aeropuerto_Llegada_Descripcion
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = m.Aeropuerto_Llegada_Pais
 INNER JOIN LOS_JOINEROS.Ciudad c ON c.ciu_nombre = m.Aeropuerto_Llegada_Ciudad AND c.ciu_pais = p.pai_id
 WHERE m.Aeropuerto_Llegada_Codigo IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM LOS_JOINEROS.Aeropuerto a WHERE a.aer_codigo = m.Aeropuerto_Llegada_Codigo);
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_VUELO
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Vuelo (vue_aerolinea, vue_aeropuerto_salida, vue_aeropuerto_llegada, vue_fecha_salida, vue_hora_salida, vue_fecha_llegada, vue_hora_llegada, vue_duracion, vue_precio, vue_incluye_carry, vue_incluye_valija)
 SELECT DISTINCT m.Aerolinea_Codigo, m.Aeropuerto_Salida_Codigo, m.Aeropuerto_Llegada_Codigo, m.Vuelo_Fecha_Salida, m.Vuelo_Horario_Salida, m.Vuelo_Fecha_Llegada, m.Vuelo_Horario_Llegada, m.Vuelo_Duracion, m.Vuelo_Precio, ISNULL(m.Vuelo_Incluye_Carry, 0), ISNULL(m.Vuelo_Incluye_Valija, 0)
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Aerolinea ae ON ae.aero_codigo = m.Aerolinea_Codigo
 INNER JOIN LOS_JOINEROS.Aeropuerto aps ON aps.aer_codigo = m.Aeropuerto_Salida_Codigo
 INNER JOIN LOS_JOINEROS.Aeropuerto apl ON apl.aer_codigo = m.Aeropuerto_Llegada_Codigo
 WHERE m.Vuelo_Fecha_Salida IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_PROVEEDOR_EXCURSION
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Proveedor_Excursion (pre_nombre, pre_mail, pre_telefono)
 SELECT DISTINCT m.Proveedor_Nombre, m.Proveedor_Mail, m.Proveedor_Telefono
 FROM gd_esquema.Maestra m
 WHERE m.Proveedor_Nombre IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_HOSPEDAJE
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Hospedaje (hos_ciudad, hos_nombre, hos_direccion, hos_horario_checkin, hos_horario_checkout, hos_incluye_desayuno)
 SELECT DISTINCT c.ciu_id, m.Hospedaje_Nombre, m.Hospedaje_Direccion, m.Hospedaje_Check_In, m.Hospedaje_Check_Out, ISNULL(m.Hospedaje_Incluye_Desayuno, 0)
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Pais p ON p.pai_nombre = m.Hospedaje_Pais
 INNER JOIN LOS_JOINEROS.Ciudad c ON c.ciu_nombre = m.Hospedaje_Ciudad AND c.ciu_pais = p.pai_id
 WHERE m.Hospedaje_Nombre IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_TIPO_HABITACION
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Tipo_Habitacion (tdh_hospedaje, tdh_descripcion, tdh_cant_camas, tdh_precio_base)
 SELECT DISTINCT h.hos_id, m.Habitacion_Nombre,m.Habitacion_Descripcion, NULL, m.Habitacion_Precio_Noche
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Hospedaje h ON h.hos_nombre = m.Hospedaje_Nombre
 WHERE m.Habitacion_Nombre IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_EXCURSION
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Excursion (exc_proveedor, exc_ciudad, exc_nombre, exc_descripcion, exc_duracion, exc_horario, exc_precio)
 SELECT DISTINCT p.pre_id, c.ciu_id, m.Excursion_Nombre, m.Excursion_Descripcion, m.Excursion_Duracion, m.Excursion_Horario, m.Excursion_Precio
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Proveedor_Excursion p ON p.pre_nombre = m.Proveedor_Nombre
 INNER JOIN LOS_JOINEROS.Pais pai ON pai.pai_nombre = m.Hospedaje_Pais
 INNER JOIN LOS_JOINEROS.Ciudad c ON c.ciu_nombre = m.Hospedaje_Ciudad AND c.ciu_pais = pai.pai_id
 WHERE m.Excursion_Nombre IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_SOLICITUD_COTIZACION
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Solicitud_Cotizacion (sol_nro, sol_cliente, sol_agente, sol_fecha_solicitud, sol_fecha_inicio_tentativa, sol_fecha_fin_tentativa, sol_cant_pasajeros, sol_presupuesto, sol_observaciones)
 SELECT m.Solicitud_Nro_Solicitud,
  MIN(c.cli_id),
  MIN(m.Agente_Legajo),
  MIN(m.Solicitud_Fecha_Solicitud),
  MIN(m.Solicitud_Fecha_Inicio_Tentativa),
  MIN(m.Solicitud_Fecha_Fin_Tentativa),
  MIN(m.Solicitud_Cant_Pax),
  MIN(m.Solicitud_Presupuesto_Estimado),
  MIN(m.Solicitud_Observaciones)
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Cliente c ON c.cli_dni = m.Cliente_Dni
 INNER JOIN LOS_JOINEROS.Agente a ON a.agt_legajo = m.Agente_Legajo
 WHERE m.Solicitud_Nro_Solicitud IS NOT NULL
 GROUP BY m.Solicitud_Nro_Solicitud;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_DETALLE_SOLICITUD
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Detalle_Solicitud (ds_solicitud, ds_ciudad, ds_cant_dias, ds_observaciones)
 SELECT DISTINCT m.Solicitud_Nro_Solicitud, c.ciu_id, m.Detalle_Solicitud_Cant_Dias_Aprox, m.Detalle_Solicitud_Observaciones
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Solicitud_Cotizacion s ON s.sol_nro = m.Solicitud_Nro_Solicitud
 INNER JOIN LOS_JOINEROS.Ciudad c ON c.ciu_nombre = m.Detalle_Solicitud_Ciudad
 WHERE m.Detalle_Solicitud_Ciudad IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_PROPUESTA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Propuesta (prop_nro_propuesta, prop_solicitud, prop_agente, prop_estado, prop_fecha, prop_vigencia, prop_fecha_desde, prop_fecha_hasta, prop_subtotal, prop_descuento, prop_total)
 SELECT m.Propuesta_Nro_Propuesta,
  MIN(m.Solicitud_Nro_Solicitud),
  MIN(m.Agente_Legajo),
  MIN(e.esp_id),
  MIN(m.Propuesta_Fecha_Emision),
  MIN(m.Propuesta_Vigencia_Hasta),
  MIN(m.Propuesta_Fecha_Desde),
  MIN(m.Propuesta_Fecha_Hasta),
  MIN(m.Propuesta_Subtotal),
  MIN(m.Propuesta_Descuento),
  MIN(m.Propuesta_Importe_Total)
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Solicitud_Cotizacion s ON s.sol_nro = m.Solicitud_Nro_Solicitud
 INNER JOIN LOS_JOINEROS.Agente a ON a.agt_legajo = m.Agente_Legajo
 INNER JOIN LOS_JOINEROS.Estado_Propuesta e ON e.esp_descripcion = m.Propuesta_Estado
 WHERE m.Propuesta_Nro_Propuesta IS NOT NULL
 GROUP BY m.Propuesta_Nro_Propuesta;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_PROPUESTA_VUELO
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Propuesta_Vuelo (pv_propuesta, pv_vuelo, pv_cantidad, pv_precio, pv_subtotal)
 SELECT DISTINCT m.Propuesta_Nro_Propuesta, v.vue_id, m.Detalle_Propuesta_Vuelo_Cant_Pasajes, m.Detalle_Propuesta_Vuelo_Precio, m.Detalle_Propuesta_Vuelo_Subtotal
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Propuesta p ON p.prop_nro_propuesta = m.Propuesta_Nro_Propuesta
 INNER JOIN LOS_JOINEROS.Vuelo v ON v.vue_aerolinea = m.Aerolinea_Codigo
  AND v.vue_aeropuerto_salida = m.Aeropuerto_Salida_Codigo
  AND v.vue_aeropuerto_llegada = m.Aeropuerto_Llegada_Codigo
  AND v.vue_fecha_salida = m.Vuelo_Fecha_Salida
  AND v.vue_hora_salida = m.Vuelo_Horario_Salida
 WHERE m.Detalle_Propuesta_Vuelo_Cant_Pasajes IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_PROPUESTA_HOSPEDAJE
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Propuesta_Hospedaje (ph_propuesta, ph_tipo_habitacion, ph_fecha_desde, ph_fecha_hasta, ph_cant_habitaciones, ph_precio, ph_subtotal)
 SELECT DISTINCT m.Propuesta_Nro_Propuesta, t.tdh_id, m.Detalle_Propuesta_Hospedaje_Fecha_Desde, m.Detalle_Propuesta_Hospedaje_Fecha_Hasta, m.Detalle_Propuesta_Hospedaje_Cant, m.Detalle_Propuesta_Hospedaje_Precio, m.Detalle_Propuesta_Hospedaje_Subtotal
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Propuesta p ON p.prop_nro_propuesta = m.Propuesta_Nro_Propuesta
 INNER JOIN LOS_JOINEROS.Hospedaje h ON h.hos_nombre = m.Hospedaje_Nombre
 INNER JOIN LOS_JOINEROS.Tipo_Habitacion t ON t.tdh_hospedaje = h.hos_id AND t.tdh_descripcion = m.Habitacion_Nombre
 WHERE m.Detalle_Propuesta_Hospedaje_Cant IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_VENTA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Venta (ven_nro_venta, ven_cliente, ven_agente, ven_canal_venta, ven_medio_pago, ven_propuesta, ven_fecha, ven_subtotal, ven_descuento, ven_total)
 SELECT m.Venta_Nro_Venta,
  MIN(c.cli_id),
  MIN(m.Agente_Legajo),
  MIN(cv.cdv_id),
  MIN(mp.mdp_id),
  MIN(pr.prop_nro_propuesta),
  MIN(m.Venta_Fecha_Venta),
  MIN(m.Venta_Subtotal),
  MIN(m.Venta_Descuento),
  MIN(m.Venta_Importe_Total)
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Cliente c ON c.cli_dni = m.Cliente_Dni
 INNER JOIN LOS_JOINEROS.Agente a ON a.agt_legajo = m.Agente_Legajo
 INNER JOIN LOS_JOINEROS.CanalVenta cv ON cv.cdv_descripcion = m.Venta_Canal_Venta
 INNER JOIN LOS_JOINEROS.MedioPago mp ON mp.mdp_descripcion = m.Venta_Medio_Pago
 LEFT JOIN LOS_JOINEROS.Propuesta pr ON pr.prop_nro_propuesta = m.Propuesta_Nro_Propuesta
 WHERE m.Venta_Nro_Venta IS NOT NULL
 GROUP BY m.Venta_Nro_Venta;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_VENTA_VUELO
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Venta_Vuelo (vv_venta, vv_vuelo, vv_cant_pasajes, vv_precio, vv_subtotal, vv_codigo_reserva)
 SELECT DISTINCT m.Venta_Nro_Venta, v.vue_id, m.Detalle_Venta_Vuelo_Cantidad_Pasajes, m.Detalle_Venta_Vuelo_Precio_Unitario, m.Detalle_Venta_Vuelo_Subtotal, m.Detalle_Venta_Vuelo_Cod_Reserva
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Venta vn ON vn.ven_nro_venta = m.Venta_Nro_Venta
 INNER JOIN LOS_JOINEROS.Vuelo v ON v.vue_aerolinea = m.Aerolinea_Codigo
  AND v.vue_aeropuerto_salida = m.Aeropuerto_Salida_Codigo
  AND v.vue_aeropuerto_llegada = m.Aeropuerto_Llegada_Codigo
  AND v.vue_fecha_salida = m.Vuelo_Fecha_Salida
  AND v.vue_hora_salida = m.Vuelo_Horario_Salida
 WHERE m.Detalle_Venta_Vuelo_Cantidad_Pasajes IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_VENTA_HOSPEDAJE
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Venta_Hospedaje (vh_venta, vh_tipo_habitacion, vh_fecha_desde, vh_fecha_hasta, vh_cantidad, vh_precio, vh_subtotal, vh_codigo_reserva)
 SELECT DISTINCT m.Venta_Nro_Venta, t.tdh_id, m.Detalle_Venta_Hospedaje_Fecha_Desde, m.Detalle_Venta_Hospedaje_Fecha_Hasta, m.Detalle_Venta_Hospedaje_Cantidad, m.Detalle_Venta_Hospedaje_Precio_Unitario, m.Detalle_Venta_Hospedaje_Subtotal, m.Detalle_Venta_Hospedaje_Cod_Reserva
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Venta vn ON vn.ven_nro_venta = m.Venta_Nro_Venta
 INNER JOIN LOS_JOINEROS.Hospedaje h ON h.hos_nombre = m.Hospedaje_Nombre
 INNER JOIN LOS_JOINEROS.Tipo_Habitacion t ON t.tdh_hospedaje = h.hos_id AND t.tdh_descripcion = m.Habitacion_Nombre
 WHERE m.Detalle_Venta_Hospedaje_Cantidad IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_VENTA_EXCURSION
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Venta_Excursion (ve_venta, ve_excursion, ve_fecha, ve_cantidad, ve_precio, ve_subtotal, ve_codigo_reserva)
 SELECT DISTINCT m.Venta_Nro_Venta, e.exc_id, m.Detalle_Venta_Excursion_Fecha_Reserva, m.Detalle_Venta_Excursion_Cant, m.Detalle_Venta_Excursion_Precio_Unitario, m.Detalle_Venta_Excursion_Subtotal, m.Detalle_Venta_Excursion_Cod_Reserva
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Venta vn ON vn.ven_nro_venta = m.Venta_Nro_Venta
 INNER JOIN LOS_JOINEROS.Excursion e ON e.exc_nombre = m.Excursion_Nombre
 WHERE m.Detalle_Venta_Excursion_Cant IS NOT NULL;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_ENCUESTA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Encuesta (enc_id, enc_cliente, enc_agente, enc_venta, enc_solicitud, enc_fecha, enc_comentario)
 SELECT m.Encuesta_Codigo_Encuesta,
  MIN(c.cli_id),
  MIN(m.Agente_Legajo),
  MIN(m.Venta_Nro_Venta),
  NULL,
  MIN(m.Encuesta_Fecha_Encuesta),
  MIN(m.Encuesta_Comentarios)
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Cliente c ON c.cli_dni = m.Cliente_Dni
 INNER JOIN LOS_JOINEROS.Agente a ON a.agt_legajo = m.Agente_Legajo
 INNER JOIN LOS_JOINEROS.Venta v ON v.ven_nro_venta = m.Venta_Nro_Venta
 WHERE m.Encuesta_Codigo_Encuesta IS NOT NULL
 AND m.Venta_Nro_Venta IS NOT NULL
 AND m.Solicitud_Nro_Solicitud IS NULL
 GROUP BY m.Encuesta_Codigo_Encuesta;

 INSERT INTO LOS_JOINEROS.Encuesta (enc_id, enc_cliente, enc_agente, enc_venta, enc_solicitud, enc_fecha, enc_comentario)
 SELECT m.Encuesta_Codigo_Encuesta,
  MIN(c.cli_id),
  MIN(m.Agente_Legajo),
  NULL,
  MIN(m.Solicitud_Nro_Solicitud),
  MIN(m.Encuesta_Fecha_Encuesta),
  MIN(m.Encuesta_Comentarios)
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Cliente c ON c.cli_dni = m.Cliente_Dni
 INNER JOIN LOS_JOINEROS.Agente a ON a.agt_legajo = m.Agente_Legajo
 INNER JOIN LOS_JOINEROS.Solicitud_Cotizacion s ON s.sol_nro = m.Solicitud_Nro_Solicitud
 WHERE m.Encuesta_Codigo_Encuesta IS NOT NULL
 AND m.Solicitud_Nro_Solicitud IS NOT NULL
 AND m.Venta_Nro_Venta IS NULL
 AND NOT EXISTS (SELECT 1 FROM LOS_JOINEROS.Encuesta e WHERE e.enc_id = m.Encuesta_Codigo_Encuesta)
 GROUP BY m.Encuesta_Codigo_Encuesta;
END;
GO

CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_MIGRACION_TABLA_VALORACION_ENCUESTA
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO LOS_JOINEROS.Valoracion_Encuesta (val_encuesta, val_aspecto, val_puntaje)
 SELECT DISTINCT m.Encuesta_Codigo_Encuesta, a.asp_id, m.Detalle_Encuesta_Puntaje
 FROM gd_esquema.Maestra m
 INNER JOIN LOS_JOINEROS.Encuesta e ON e.enc_id = m.Encuesta_Codigo_Encuesta
 INNER JOIN LOS_JOINEROS.Aspecto_Encuesta a ON a.asp_descripcion = m.Aspecto_Aspecto
 WHERE m.Detalle_Encuesta_Puntaje BETWEEN 1 AND 5;
END;
GO

PRINT 'SE COMIENZA A MIGRAR LOS DATOS...'
GO

EXEC LOS_JOINEROS.P_MIGRACION_TABLA_PAIS;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_ALIANZA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_CANALVENTA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_MEDIOPAGO;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_ESTADO_PROPUESTA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_ASPECTO_ENCUESTA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_PROVINCIA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_LOCALIDAD;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_CIUDAD;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_AGENCIA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_AGENTE;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_CLIENTE;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_AEROLINEA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_AEROPUERTO;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_VUELO;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_PROVEEDOR_EXCURSION;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_HOSPEDAJE;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_TIPO_HABITACION;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_EXCURSION;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_SOLICITUD_COTIZACION;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_DETALLE_SOLICITUD;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_PROPUESTA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_PROPUESTA_VUELO;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_PROPUESTA_HOSPEDAJE;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_VENTA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_VENTA_VUELO;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_VENTA_HOSPEDAJE;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_VENTA_EXCURSION;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_ENCUESTA;
EXEC LOS_JOINEROS.P_MIGRACION_TABLA_VALORACION_ENCUESTA;
GO

PRINT 'MIGRACION COMPLETADA'
