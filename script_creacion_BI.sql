USE GD1C2026;
GO

PRINT '=== INICIO CREACION MODELO BI ==='
GO

-- TABLAS DE DIMENSIONES

PRINT 'Creando tablas de dimensiones...'
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Tiempo (
    bit_id          int IDENTITY(1,1) NOT NULL,
    bit_fecha       date              NOT NULL,
    bit_anio        int               NOT NULL,
    bit_cuatrimestre int              NOT NULL,
    bit_mes         int               NOT NULL,
    bit_temporada   nvarchar(50)      NOT NULL,
    CONSTRAINT PK_BI_Dim_Tiempo PRIMARY KEY (bit_id),
    CONSTRAINT UQ_BI_Dim_Tiempo_Fecha UNIQUE (bit_fecha)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Rango_Etario (
    bire_id          int IDENTITY(1,1) NOT NULL,
    bire_descripcion nvarchar(100)     NOT NULL,
    bire_edad_desde  int               NOT NULL,
    bire_edad_hasta  int               NOT NULL,
    CONSTRAINT PK_BI_Dim_Rango_Etario PRIMARY KEY (bire_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Tipo_Servicio (
    bits_id          int IDENTITY(1,1) NOT NULL,
    bits_descripcion nvarchar(100)     NOT NULL,
    CONSTRAINT PK_BI_Dim_Tipo_Servicio PRIMARY KEY (bits_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Canal_Venta (
    bicv_id          int IDENTITY(1,1) NOT NULL,
    bicv_descripcion nvarchar(255)     NOT NULL,
    CONSTRAINT PK_BI_Dim_Canal_Venta PRIMARY KEY (bicv_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Estado_Propuesta (
    biep_id          int IDENTITY(1,1) NOT NULL,
    biep_descripcion nvarchar(255)     NOT NULL,
    CONSTRAINT PK_BI_Dim_Estado_Propuesta PRIMARY KEY (biep_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Agente (
    bia_id           int IDENTITY(1,1) NOT NULL,
    bia_legajo       bigint            NOT NULL,
    bia_nombre       nvarchar(255)     NOT NULL,
    bia_apellido     nvarchar(255)     NOT NULL,
    bia_rango_etario int               NOT NULL,
    CONSTRAINT PK_BI_Dim_Agente PRIMARY KEY (bia_id),
    CONSTRAINT FK_BI_DimAgente_RangoEtario FOREIGN KEY (bia_rango_etario)
        REFERENCES LOS_JOINEROS.BI_Dim_Rango_Etario (bire_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Cliente (
    bic_id           int IDENTITY(1,1) NOT NULL,
    bic_cliente_id   int               NOT NULL,
    bic_nombre       nvarchar(255)     NOT NULL,
    bic_apellido     nvarchar(255)     NOT NULL,
    bic_rango_etario int               NOT NULL,
    CONSTRAINT PK_BI_Dim_Cliente PRIMARY KEY (bic_id),
    CONSTRAINT FK_BI_DimCliente_RangoEtario FOREIGN KEY (bic_rango_etario)
        REFERENCES LOS_JOINEROS.BI_Dim_Rango_Etario (bire_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Dim_Aspecto_Encuesta (
    biae_id          int IDENTITY(1,1) NOT NULL,
    biae_descripcion nvarchar(255)     NOT NULL,
    CONSTRAINT PK_BI_Dim_Aspecto_Encuesta PRIMARY KEY (biae_id)
);
GO

-- TABLAS DE HECHOS

PRINT 'Creando tablas de hechos...'
GO

CREATE TABLE LOS_JOINEROS.BI_Fact_Venta (
    bfv_id           int IDENTITY(1,1) NOT NULL,
    bfv_tiempo       int               NOT NULL,
    bfv_cliente      int               NOT NULL,
    bfv_agente       int               NOT NULL,
    bfv_canal_venta  int               NOT NULL,
    bfv_tipo_servicio int              NOT NULL,
    bfv_total        decimal(18,2)     NOT NULL,
    bfv_subtotal     decimal(18,2)     NOT NULL,
    bfv_descuento    decimal(18,2)     NOT NULL,
    CONSTRAINT PK_BI_Fact_Venta PRIMARY KEY (bfv_id),
    CONSTRAINT FK_BI_FVenta_Tiempo      FOREIGN KEY (bfv_tiempo)        REFERENCES LOS_JOINEROS.BI_Dim_Tiempo (bit_id),
    CONSTRAINT FK_BI_FVenta_Cliente     FOREIGN KEY (bfv_cliente)       REFERENCES LOS_JOINEROS.BI_Dim_Cliente (bic_id),
    CONSTRAINT FK_BI_FVenta_Agente      FOREIGN KEY (bfv_agente)        REFERENCES LOS_JOINEROS.BI_Dim_Agente (bia_id),
    CONSTRAINT FK_BI_FVenta_Canal       FOREIGN KEY (bfv_canal_venta)   REFERENCES LOS_JOINEROS.BI_Dim_Canal_Venta (bicv_id),
    CONSTRAINT FK_BI_FVenta_TipoServ    FOREIGN KEY (bfv_tipo_servicio) REFERENCES LOS_JOINEROS.BI_Dim_Tipo_Servicio (bits_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Fact_Solicitud (
    bfs_id                    int IDENTITY(1,1) NOT NULL,
    bfs_tiempo_solicitud      int               NOT NULL,
    bfs_cliente               int               NOT NULL,
    bfs_agente                int               NOT NULL,
    bfs_dias_anticipacion     int               NULL,
    bfs_presupuesto_estimado  decimal(18,2)     NULL,
    bfs_cant_pasajeros        int               NULL,
    CONSTRAINT PK_BI_Fact_Solicitud PRIMARY KEY (bfs_id),
    CONSTRAINT FK_BI_FSol_Tiempo   FOREIGN KEY (bfs_tiempo_solicitud) REFERENCES LOS_JOINEROS.BI_Dim_Tiempo (bit_id),
    CONSTRAINT FK_BI_FSol_Cliente  FOREIGN KEY (bfs_cliente)          REFERENCES LOS_JOINEROS.BI_Dim_Cliente (bic_id),
    CONSTRAINT FK_BI_FSol_Agente   FOREIGN KEY (bfs_agente)           REFERENCES LOS_JOINEROS.BI_Dim_Agente (bia_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Fact_Propuesta (
    bfp_id                   int IDENTITY(1,1) NOT NULL,
    bfp_tiempo_emision       int               NOT NULL,
    bfp_tiempo_viaje         int               NULL,
    bfp_tiempo_solicitud     int               NOT NULL,
    bfp_agente               int               NOT NULL,
    bfp_estado_propuesta     int               NOT NULL,
    bfp_dias_respuesta       int               NULL,
    bfp_importe_total        decimal(18,2)     NULL,
    bfp_descuento            decimal(18,2)     NULL,
    bfp_presupuesto_estimado decimal(18,2)     NULL,
    bfp_desvio_presupuesto   decimal(18,2)     NULL,
    CONSTRAINT PK_BI_Fact_Propuesta PRIMARY KEY (bfp_id),
    CONSTRAINT FK_BI_FProp_TiempoEmision  FOREIGN KEY (bfp_tiempo_emision)   REFERENCES LOS_JOINEROS.BI_Dim_Tiempo (bit_id),
    CONSTRAINT FK_BI_FProp_TiempoViaje    FOREIGN KEY (bfp_tiempo_viaje)     REFERENCES LOS_JOINEROS.BI_Dim_Tiempo (bit_id),
    CONSTRAINT FK_BI_FProp_TiempoSol      FOREIGN KEY (bfp_tiempo_solicitud) REFERENCES LOS_JOINEROS.BI_Dim_Tiempo (bit_id),
    CONSTRAINT FK_BI_FProp_Agente         FOREIGN KEY (bfp_agente)           REFERENCES LOS_JOINEROS.BI_Dim_Agente (bia_id),
    CONSTRAINT FK_BI_FProp_Estado         FOREIGN KEY (bfp_estado_propuesta) REFERENCES LOS_JOINEROS.BI_Dim_Estado_Propuesta (biep_id)
);
GO

CREATE TABLE LOS_JOINEROS.BI_Fact_Encuesta (
    bfe_id      int IDENTITY(1,1) NOT NULL,
    bfe_tiempo  int               NOT NULL,
    bfe_agente  int               NOT NULL,
    bfe_aspecto int               NOT NULL,
    bfe_puntaje int               NOT NULL,
    CONSTRAINT PK_BI_Fact_Encuesta PRIMARY KEY (bfe_id),
    CONSTRAINT FK_BI_FEnc_Tiempo  FOREIGN KEY (bfe_tiempo)  REFERENCES LOS_JOINEROS.BI_Dim_Tiempo (bit_id),
    CONSTRAINT FK_BI_FEnc_Agente  FOREIGN KEY (bfe_agente)  REFERENCES LOS_JOINEROS.BI_Dim_Agente (bia_id),
    CONSTRAINT FK_BI_FEnc_Aspecto FOREIGN KEY (bfe_aspecto) REFERENCES LOS_JOINEROS.BI_Dim_Aspecto_Encuesta (biae_id)
);
GO

-- CARGAMOS LAS DIMENSIONES Y HECHOS

PRINT 'Creando stored procedures de carga...'
GO

-- BI_Dim_Tiempo
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_TIEMPO
AS
BEGIN
    SET NOCOUNT ON; --para no llenar de mensajes de rows affected
    -- Genera un registro por cada fecha distinta que aparece en los datos transaccionales
    INSERT INTO LOS_JOINEROS.BI_Dim_Tiempo (bit_fecha, bit_anio, bit_cuatrimestre, bit_mes, bit_temporada)
    SELECT DISTINCT
        f.fecha,
        YEAR(f.fecha),
        CASE
            WHEN MONTH(f.fecha) BETWEEN 1 AND 4 THEN 1
            WHEN MONTH(f.fecha) BETWEEN 5 AND 8 THEN 2
            ELSE 3
        END,
        MONTH(f.fecha),
        CASE
            WHEN MONTH(f.fecha) BETWEEN 1  AND 3 THEN 'Verano'
            WHEN MONTH(f.fecha) BETWEEN 4  AND 6 THEN 'Otono'
            WHEN MONTH(f.fecha) BETWEEN 7  AND 9 THEN 'Invierno'
            ELSE 'Primavera'
        END
    FROM (
        SELECT ven_fecha            AS fecha FROM LOS_JOINEROS.Venta             WHERE ven_fecha IS NOT NULL
        UNION
        SELECT sol_fecha_solicitud  AS fecha FROM LOS_JOINEROS.Solicitud_Cotizacion WHERE sol_fecha_solicitud IS NOT NULL
        UNION
        SELECT prop_fecha           AS fecha FROM LOS_JOINEROS.Propuesta         WHERE prop_fecha IS NOT NULL
        UNION
        SELECT prop_fecha_desde     AS fecha FROM LOS_JOINEROS.Propuesta         WHERE prop_fecha_desde IS NOT NULL
        UNION
        SELECT enc_fecha            AS fecha FROM LOS_JOINEROS.Encuesta          WHERE enc_fecha IS NOT NULL
    ) f
    WHERE NOT EXISTS (
        SELECT 1 FROM LOS_JOINEROS.BI_Dim_Tiempo t WHERE t.bit_fecha = f.fecha
    );
END;
GO

-- BI_Dim_Rango_Etario
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_RANGO_ETARIO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Dim_Rango_Etario (bire_descripcion, bire_edad_desde, bire_edad_hasta)
    VALUES
        ('Menores de 25 anios',    0,  24),
        ('Entre 25 y 35 anios',   25,  35),
        ('Entre 35 y 50 anios',   36,  50),
        ('Mayores de 50 anios',   51, 999);
END;
GO

-- BI_Dim_Tipo_Servicio
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_TIPO_SERVICIO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Dim_Tipo_Servicio (bits_descripcion)
    VALUES ('Venta Directa'), ('Propuesta a Medida');
END;
GO

-- BI_Dim_Canal_Venta
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_CANAL_VENTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Dim_Canal_Venta (bicv_descripcion)
    SELECT cdv_descripcion FROM LOS_JOINEROS.CanalVenta;
END;
GO

-- BI_Dim_Estado_Propuesta
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_ESTADO_PROPUESTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Dim_Estado_Propuesta (biep_descripcion)
    SELECT esp_descripcion FROM LOS_JOINEROS.Estado_Propuesta;
END;
GO

-- BI_Dim_Agente
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_AGENTE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Dim_Agente (bia_legajo, bia_nombre, bia_apellido, bia_rango_etario)
    SELECT
        a.agt_legajo,
        a.agt_nombre,
        a.agt_apellido,
        r.bire_id
    FROM LOS_JOINEROS.Agente a
    INNER JOIN LOS_JOINEROS.BI_Dim_Rango_Etario r
        ON DATEDIFF(YEAR, a.agt_fecha_nacimiento, GETDATE()) BETWEEN r.bire_edad_desde AND r.bire_edad_hasta
    WHERE a.agt_fecha_nacimiento IS NOT NULL;
END;
GO

-- BI_Dim_Cliente
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_CLIENTE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Dim_Cliente (bic_cliente_id, bic_nombre, bic_apellido, bic_rango_etario)
    SELECT
        c.cli_id,
        c.cli_nombre,
        c.cli_apellido,
        r.bire_id
    FROM LOS_JOINEROS.Cliente c
    INNER JOIN LOS_JOINEROS.BI_Dim_Rango_Etario r
        ON DATEDIFF(YEAR, c.cli_fecha_nacimiento, GETDATE()) BETWEEN r.bire_edad_desde AND r.bire_edad_hasta
    WHERE c.cli_fecha_nacimiento IS NOT NULL;
END;
GO

-- BI_Dim_Aspecto_Encuesta
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_DIM_ASPECTO_ENCUESTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Dim_Aspecto_Encuesta (biae_descripcion)
    SELECT asp_descripcion FROM LOS_JOINEROS.Aspecto_Encuesta;
END;
GO

-- BI_Fact_Venta
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_FACT_VENTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Fact_Venta
        (bfv_tiempo, bfv_cliente, bfv_agente, bfv_canal_venta, bfv_tipo_servicio,
         bfv_total, bfv_subtotal, bfv_descuento)
    SELECT
        t.bit_id,
        c.bic_id,
        a.bia_id,
        cv.bicv_id,
        ts.bits_id,
        ISNULL(v.ven_total,    0),
        ISNULL(v.ven_subtotal, 0),
        ISNULL(v.ven_descuento,0)
    FROM LOS_JOINEROS.Venta v
    INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo        t   ON t.bit_fecha         = v.ven_fecha
    INNER JOIN LOS_JOINEROS.BI_Dim_Cliente        c   ON c.bic_cliente_id   = v.ven_cliente
    INNER JOIN LOS_JOINEROS.BI_Dim_Agente         a   ON a.bia_legajo       = v.ven_agente
    INNER JOIN LOS_JOINEROS.CanalVenta            cvt ON cvt.cdv_id         = v.ven_canal_venta
    INNER JOIN LOS_JOINEROS.BI_Dim_Canal_Venta    cv  ON cv.bicv_descripcion = cvt.cdv_descripcion
    -- Clasificacion por tipo de servicio segun si la venta proviene de una propuesta o no
    INNER JOIN LOS_JOINEROS.BI_Dim_Tipo_Servicio  ts  ON ts.bits_descripcion =
        CASE WHEN v.ven_propuesta IS NULL THEN 'Venta Directa' ELSE 'Propuesta a Medida' END;
END;
GO

-- BI_Fact_Solicitud
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_FACT_SOLICITUD
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Fact_Solicitud
        (bfs_tiempo_solicitud, bfs_cliente, bfs_agente,
         bfs_dias_anticipacion, bfs_presupuesto_estimado, bfs_cant_pasajeros)
    SELECT
        t.bit_id,
        c.bic_id,
        a.bia_id,
        CASE
            WHEN s.sol_fecha_inicio_tentativa IS NOT NULL
            THEN DATEDIFF(DAY, s.sol_fecha_solicitud, s.sol_fecha_inicio_tentativa)
            ELSE NULL
        END,
        s.sol_presupuesto,
        s.sol_cant_pasajeros
    FROM LOS_JOINEROS.Solicitud_Cotizacion s
    INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo   t ON t.bit_fecha      = s.sol_fecha_solicitud
    INNER JOIN LOS_JOINEROS.BI_Dim_Cliente  c ON c.bic_cliente_id = s.sol_cliente
    INNER JOIN LOS_JOINEROS.BI_Dim_Agente   a ON a.bia_legajo     = s.sol_agente;
END;
GO

--  BI_Fact_Propuesta
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_FACT_PROPUESTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Fact_Propuesta
        (bfp_tiempo_emision, bfp_tiempo_viaje, bfp_tiempo_solicitud,
         bfp_agente, bfp_estado_propuesta,
         bfp_dias_respuesta, bfp_importe_total, bfp_descuento,
         bfp_presupuesto_estimado, bfp_desvio_presupuesto)
    SELECT
        te.bit_id,
        tv.bit_id,
        ts.bit_id,
        a.bia_id,
        ep.biep_id,
        DATEDIFF(DAY, sol.sol_fecha_solicitud, p.prop_fecha),
        p.prop_total,
        p.prop_descuento,
        sol.sol_presupuesto,
        ISNULL(p.prop_total, 0) - ISNULL(sol.sol_presupuesto, 0)
    FROM LOS_JOINEROS.Propuesta p
    INNER JOIN LOS_JOINEROS.Solicitud_Cotizacion     sol ON sol.sol_nro          = p.prop_solicitud
    INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo            te  ON te.bit_fecha         = p.prop_fecha
    INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo            ts  ON ts.bit_fecha         = sol.sol_fecha_solicitud
    INNER JOIN LOS_JOINEROS.BI_Dim_Agente            a   ON a.bia_legajo         = p.prop_agente
    INNER JOIN LOS_JOINEROS.Estado_Propuesta         est ON est.esp_id           = p.prop_estado
    INNER JOIN LOS_JOINEROS.BI_Dim_Estado_Propuesta  ep  ON ep.biep_descripcion  = est.esp_descripcion
    LEFT  JOIN LOS_JOINEROS.BI_Dim_Tiempo            tv  ON tv.bit_fecha         = p.prop_fecha_desde;
END;
GO

-- BI_Fact_Encuesta
CREATE OR ALTER PROCEDURE LOS_JOINEROS.P_BI_CARGA_FACT_ENCUESTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_JOINEROS.BI_Fact_Encuesta
        (bfe_tiempo, bfe_agente, bfe_aspecto, bfe_puntaje)
    SELECT
        t.bit_id,
        a.bia_id,
        asp.biae_id,
        v.val_puntaje
    FROM LOS_JOINEROS.Valoracion_Encuesta v
    INNER JOIN LOS_JOINEROS.Encuesta               e   ON e.enc_id          = v.val_encuesta
    INNER JOIN LOS_JOINEROS.Aspecto_Encuesta        ae  ON ae.asp_id         = v.val_aspecto
    INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo           t   ON t.bit_fecha       = e.enc_fecha
    INNER JOIN LOS_JOINEROS.BI_Dim_Agente           a   ON a.bia_legajo      = e.enc_agente
    INNER JOIN LOS_JOINEROS.BI_Dim_Aspecto_Encuesta asp ON asp.biae_descripcion = ae.asp_descripcion;
END;
GO

-- EJECUCION DE CARGA EN ORDEN

PRINT 'Cargando dimensiones...'
GO

EXEC LOS_JOINEROS.P_BI_CARGA_DIM_TIEMPO;
EXEC LOS_JOINEROS.P_BI_CARGA_DIM_RANGO_ETARIO;
EXEC LOS_JOINEROS.P_BI_CARGA_DIM_TIPO_SERVICIO;
EXEC LOS_JOINEROS.P_BI_CARGA_DIM_CANAL_VENTA;
EXEC LOS_JOINEROS.P_BI_CARGA_DIM_ESTADO_PROPUESTA;
EXEC LOS_JOINEROS.P_BI_CARGA_DIM_AGENTE;
EXEC LOS_JOINEROS.P_BI_CARGA_DIM_CLIENTE;
EXEC LOS_JOINEROS.P_BI_CARGA_DIM_ASPECTO_ENCUESTA;
GO

PRINT 'Cargando hechos...'
GO

EXEC LOS_JOINEROS.P_BI_CARGA_FACT_VENTA;
EXEC LOS_JOINEROS.P_BI_CARGA_FACT_SOLICITUD;
EXEC LOS_JOINEROS.P_BI_CARGA_FACT_PROPUESTA;
EXEC LOS_JOINEROS.P_BI_CARGA_FACT_ENCUESTA;
GO

-- VISTAS PARA LOS 10 INDICADORES DE NEGOCIO

PRINT 'Creando vistas de indicadores...'
GO

-- Indicador 1: Ticket promedio mensual por rango etario cliente y canal de venta
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Ticket_Promedio_Mensual AS
SELECT
    t.bit_anio                  AS anio,
    t.bit_mes                   AS mes,
    r.bire_descripcion          AS rango_etario_cliente,
    cv.bicv_descripcion         AS canal_venta,
    AVG(v.bfv_total)            AS ticket_promedio,
    COUNT(*)                    AS cantidad_ventas,
    SUM(v.bfv_total)            AS total_facturado
FROM LOS_JOINEROS.BI_Fact_Venta          v
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo        t  ON t.bit_id  = v.bfv_tiempo
INNER JOIN LOS_JOINEROS.BI_Dim_Cliente       c  ON c.bic_id  = v.bfv_cliente
INNER JOIN LOS_JOINEROS.BI_Dim_Rango_Etario  r  ON r.bire_id = c.bic_rango_etario
INNER JOIN LOS_JOINEROS.BI_Dim_Canal_Venta   cv ON cv.bicv_id = v.bfv_canal_venta
GROUP BY t.bit_anio, t.bit_mes, r.bire_descripcion, cv.bicv_descripcion;
GO

-- Indicador 2: Distribución de facturación por tipo de servicio y cuatrimestre
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Distribucion_Facturacion AS
SELECT
    t.bit_anio                                                          AS anio,
    t.bit_cuatrimestre                                                  AS cuatrimestre,
    ts.bits_descripcion                                                 AS tipo_servicio,
    SUM(v.bfv_total)                                                    AS total_facturado,
    SUM(v.bfv_total) * 100.0
        / SUM(SUM(v.bfv_total)) OVER (PARTITION BY t.bit_anio, t.bit_cuatrimestre) AS porcentaje
FROM LOS_JOINEROS.BI_Fact_Venta           v
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo         t  ON t.bit_id   = v.bfv_tiempo
INNER JOIN LOS_JOINEROS.BI_Dim_Tipo_Servicio  ts ON ts.bits_id = v.bfv_tipo_servicio
GROUP BY t.bit_anio, t.bit_cuatrimestre, ts.bits_descripcion;
GO

-- Indicador 3: Ranking de solicitudes por temporada y rango etario cliente
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Ranking_Solicitudes_Temporada AS
SELECT
    t.bit_anio                  AS anio,
    t.bit_temporada             AS temporada,
    r.bire_descripcion          AS rango_etario_cliente,
    COUNT(*)                    AS cantidad_solicitudes,
    RANK() OVER (
        PARTITION BY t.bit_anio, t.bit_temporada
        ORDER BY COUNT(*) DESC
    )                           AS ranking
FROM LOS_JOINEROS.BI_Fact_Solicitud      s
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo        t ON t.bit_id  = s.bfs_tiempo_solicitud
INNER JOIN LOS_JOINEROS.BI_Dim_Cliente       c ON c.bic_id  = s.bfs_cliente
INNER JOIN LOS_JOINEROS.BI_Dim_Rango_Etario  r ON r.bire_id = c.bic_rango_etario
GROUP BY t.bit_anio, t.bit_temporada, r.bire_descripcion;
GO

-- Indicador 4: Anticipación promedio de solicitudes por rango etario cliente y cuatrimestre
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Anticipacion_Solicitudes AS
SELECT
    t.bit_anio                          AS anio,
    t.bit_cuatrimestre                  AS cuatrimestre,
    r.bire_descripcion                  AS rango_etario_cliente,
    AVG(CAST(s.bfs_dias_anticipacion AS FLOAT)) AS anticipacion_promedio_dias,
    COUNT(*)                            AS cantidad_solicitudes
FROM LOS_JOINEROS.BI_Fact_Solicitud      s
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo        t ON t.bit_id  = s.bfs_tiempo_solicitud
INNER JOIN LOS_JOINEROS.BI_Dim_Cliente       c ON c.bic_id  = s.bfs_cliente
INNER JOIN LOS_JOINEROS.BI_Dim_Rango_Etario  r ON r.bire_id = c.bic_rango_etario
WHERE s.bfs_dias_anticipacion IS NOT NULL
GROUP BY t.bit_anio, t.bit_cuatrimestre, r.bire_descripcion;
GO

-- Indicador 5: Tasa de aceptación de propuestas por cuatrimestre
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Tasa_Aceptacion_Propuestas AS
SELECT
    t.bit_anio                                              AS anio,
    t.bit_cuatrimestre                                      AS cuatrimestre,
    COUNT(*)                                                AS total_propuestas,
    SUM(CASE WHEN ep.biep_descripcion = 'Aceptada' THEN 1 ELSE 0 END) AS propuestas_aceptadas,
    SUM(CASE WHEN ep.biep_descripcion = 'Aceptada' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)                                          AS tasa_aceptacion_pct
FROM LOS_JOINEROS.BI_Fact_Propuesta          p
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo            t  ON t.bit_id   = p.bfp_tiempo_emision
INNER JOIN LOS_JOINEROS.BI_Dim_Estado_Propuesta  ep ON ep.biep_id = p.bfp_estado_propuesta
GROUP BY t.bit_anio, t.bit_cuatrimestre;
GO

-- Indicador 6: Cotización promedio por temporada y año (fecha inicio viaje)
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Cotizacion_Promedio_Temporada AS
SELECT
    tv.bit_anio                         AS anio,
    tv.bit_temporada                    AS temporada,
    AVG(p.bfp_importe_total)            AS cotizacion_promedio,
    COUNT(*)                            AS cantidad_propuestas,
    SUM(p.bfp_importe_total)            AS total_cotizado
FROM LOS_JOINEROS.BI_Fact_Propuesta  p
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo tv ON tv.bit_id = p.bfp_tiempo_viaje
WHERE p.bfp_tiempo_viaje IS NOT NULL
  AND p.bfp_importe_total IS NOT NULL
GROUP BY tv.bit_anio, tv.bit_temporada;
GO

-- Indicador 7: Tiempo promedio de respuesta por rango etario agente y mes
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Tiempo_Respuesta_Agente AS
SELECT
    ts.bit_anio                                     AS anio,
    ts.bit_mes                                      AS mes,
    r.bire_descripcion                              AS rango_etario_agente,
    AVG(CAST(p.bfp_dias_respuesta AS FLOAT))        AS tiempo_respuesta_promedio_dias,
    COUNT(*)                                        AS cantidad_propuestas
FROM LOS_JOINEROS.BI_Fact_Propuesta      p
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo        ts ON ts.bit_id  = p.bfp_tiempo_solicitud
INNER JOIN LOS_JOINEROS.BI_Dim_Agente        a  ON a.bia_id   = p.bfp_agente
INNER JOIN LOS_JOINEROS.BI_Dim_Rango_Etario  r  ON r.bire_id  = a.bia_rango_etario
WHERE p.bfp_dias_respuesta IS NOT NULL
GROUP BY ts.bit_anio, ts.bit_mes, r.bire_descripcion;
GO

-- Indicador 8: Desvío de presupuesto promedio
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Desvio_Presupuesto AS
SELECT
    t.bit_anio                                          AS anio,
    t.bit_cuatrimestre                                  AS cuatrimestre,
    AVG(p.bfp_presupuesto_estimado)                     AS presupuesto_estimado_promedio,
    AVG(p.bfp_importe_total)                            AS importe_propuesta_promedio,
    AVG(p.bfp_desvio_presupuesto)                       AS desvio_promedio,
    AVG(p.bfp_desvio_presupuesto) * 100.0
        / NULLIF(AVG(p.bfp_presupuesto_estimado), 0)    AS desvio_porcentual_promedio,
    COUNT(*)                                            AS cantidad_propuestas
FROM LOS_JOINEROS.BI_Fact_Propuesta  p
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo t ON t.bit_id = p.bfp_tiempo_emision
WHERE p.bfp_presupuesto_estimado IS NOT NULL
  AND p.bfp_importe_total IS NOT NULL
GROUP BY t.bit_anio, t.bit_cuatrimestre;
GO

-- Indicador 9: Ranking de aspectos mejor y peor valorados por cuatrimestre
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Ranking_Aspectos_Encuesta AS
SELECT
    t.bit_anio                              AS anio,
    t.bit_cuatrimestre                      AS cuatrimestre,
    asp.biae_descripcion                    AS aspecto,
    AVG(CAST(e.bfe_puntaje AS FLOAT))       AS puntaje_promedio,
    COUNT(*)                                AS cantidad_valoraciones,
    RANK() OVER (
        PARTITION BY t.bit_anio, t.bit_cuatrimestre
        ORDER BY AVG(CAST(e.bfe_puntaje AS FLOAT)) DESC
    )                                       AS ranking_mejor,
    RANK() OVER (
        PARTITION BY t.bit_anio, t.bit_cuatrimestre
        ORDER BY AVG(CAST(e.bfe_puntaje AS FLOAT)) ASC
    )                                       AS ranking_peor
FROM LOS_JOINEROS.BI_Fact_Encuesta           e
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo            t   ON t.bit_id    = e.bfe_tiempo
INNER JOIN LOS_JOINEROS.BI_Dim_Aspecto_Encuesta  asp ON asp.biae_id = e.bfe_aspecto
GROUP BY t.bit_anio, t.bit_cuatrimestre, asp.biae_descripcion;
GO

-- Indicador 10: Satisfacción promedio por agente, rango etario agente y mes
CREATE OR ALTER VIEW LOS_JOINEROS.BI_V_Satisfaccion_Por_Agente AS
SELECT
    t.bit_anio                              AS anio,
    t.bit_mes                               AS mes,
    a.bia_legajo                            AS legajo_agente,
    a.bia_nombre + ' ' + a.bia_apellido     AS nombre_agente,
    r.bire_descripcion                      AS rango_etario_agente,
    AVG(CAST(e.bfe_puntaje AS FLOAT))       AS satisfaccion_promedio,
    COUNT(*)                                AS cantidad_valoraciones
FROM LOS_JOINEROS.BI_Fact_Encuesta           e
INNER JOIN LOS_JOINEROS.BI_Dim_Tiempo        t ON t.bit_id   = e.bfe_tiempo
INNER JOIN LOS_JOINEROS.BI_Dim_Agente        a ON a.bia_id   = e.bfe_agente
INNER JOIN LOS_JOINEROS.BI_Dim_Rango_Etario  r ON r.bire_id  = a.bia_rango_etario
GROUP BY t.bit_anio, t.bit_mes, a.bia_legajo, a.bia_nombre, a.bia_apellido, r.bire_descripcion;
GO

PRINT '=== MODELO BI CREADO Y CARGADO CORRECTAMENTE ==='
GO
