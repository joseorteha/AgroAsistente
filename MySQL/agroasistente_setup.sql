USE railway;

CREATE TABLE productores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    municipio VARCHAR(100),
    departamento VARCHAR(100),
    altitud_msnm INT,
    tipo_cultivo VARCHAR(50) DEFAULT 'cafe',
    email VARCHAR(150),
    fecha_registro DATE NOT NULL
);

CREATE TABLE lotes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productor_id INT NOT NULL,
    nombre_lote VARCHAR(80) NOT NULL,
    area_hectareas DECIMAL(5,2),
    altitud_msnm INT,
    variedad VARCHAR(80),
    anio_siembra INT,
    tipo_sombrío VARCHAR(80),
    sistema_certificacion VARCHAR(100),
    FOREIGN KEY (productor_id) REFERENCES productores(id)
);

CREATE TABLE registro_fenologico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lote_id INT NOT NULL,
    fecha DATE NOT NULL,
    etapa VARCHAR(50) NOT NULL,
    observacion TEXT,
    registrado_por VARCHAR(100),
    FOREIGN KEY (lote_id) REFERENCES lotes(id)
);

CREATE TABLE inventario_insumos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productor_id INT NOT NULL,
    insumo VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    cantidad DECIMAL(8,2) NOT NULL,
    unidad VARCHAR(20) NOT NULL,
    fecha_ultima_aplicacion DATE,
    lote_aplicado VARCHAR(80),
    FOREIGN KEY (productor_id) REFERENCES productores(id)
);

CREATE TABLE precios_mercado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    producto VARCHAR(80) NOT NULL,
    precio_kg DECIMAL(8,2) NOT NULL,
    precio_arroba DECIMAL(8,2),
    moneda VARCHAR(10) DEFAULT 'COP',
    fuente VARCHAR(100),
    tipo_mercado VARCHAR(50)
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productor_id INT NOT NULL,
    fecha DATE NOT NULL,
    lote_id INT,
    cantidad_kg DECIMAL(8,2) NOT NULL,
    precio_unitario_kg DECIMAL(8,2) NOT NULL,
    total_venta DECIMAL(10,2),
    comprador VARCHAR(100),
    tipo_venta VARCHAR(50),
    FOREIGN KEY (productor_id) REFERENCES productores(id),
    FOREIGN KEY (lote_id) REFERENCES lotes(id)
);

CREATE TABLE alertas_sanitarias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lote_id INT NOT NULL,
    fecha DATE NOT NULL,
    tipo_alerta VARCHAR(100) NOT NULL,
    descripcion TEXT,
    nivel_severidad VARCHAR(20),
    accion_tomada TEXT,
    resuelta BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (lote_id) REFERENCES lotes(id)
);

-- ============================================================
-- DATOS DE EJEMPLO — PRODUCTORES
-- ============================================================

INSERT INTO productores (nombre, telefono, municipio, departamento, altitud_msnm, tipo_cultivo, email, fecha_registro) VALUES
('Martín Ospina Ríos',      '3124567890', 'Pitalito',      'Huila',      1750, 'cafe', 'martin.ospina@gmail.com',  '2024-01-15'),
('Carmen Lozano Bernal',    '3209876543', 'Salento',       'Quindío',    1890, 'cafe', NULL,                        '2024-02-03'),
('José Rentería Mena',      '3145551234', 'Riosucio',      'Caldas',     1620, 'cafe', NULL,                        '2024-03-10'),
('Esperanza Cifuentes',     '3001234567', 'El Tambo',      'Cauca',      1480, 'cafe', 'espe.cifuentes@gmail.com', '2024-04-20'),
('Rodrigo Aya Vargas',      '3187654321', 'Jardín',        'Antioquia',  1950, 'cafe', NULL,                        '2024-05-05'),
('Lucía Mendoza Pardo',     '3112345678', 'Argelia',       'Cauca',      1300, 'cafe', NULL,                        '2024-06-18'),
('Héctor Bautista Torres',  '3223456789', 'Circasia',      'Quindío',    1550, 'cafe', NULL,                        '2024-07-22'),
('Ana María Cuellar',       '3134567890', 'Gaitania',      'Tolima',     1400, 'cafe', 'ana.cuellar@yahoo.com',    '2024-08-11');

-- ============================================================
-- LOTES POR PRODUCTOR
-- ============================================================

-- Martín Ospina Ríos (id=1) — 3 lotes en Pitalito, Huila
INSERT INTO lotes (productor_id, nombre_lote, area_hectareas, altitud_msnm, variedad, anio_siembra, tipo_sombrío, sistema_certificacion) VALUES
(1, 'El Nogal',      2.50, 1750, 'Bourbon Rosa',   2019, 'Guamo + Nogal cafetero', 'Fair Trade + Organico'),
(1, 'La Primavera',  1.80, 1720, 'Pink Bourbon',    2021, 'Plátano + Guamo',       'Organico en transicion'),
(1, 'Potrero Alto',  3.00, 1780, 'Castillo',        2017, 'Guamo',                 'Convencional');

-- Carmen Lozano Bernal (id=2) — 2 lotes en Salento, Quindío
INSERT INTO lotes (productor_id, nombre_lote, area_hectareas, altitud_msnm, variedad, anio_siembra, tipo_sombrío, sistema_certificacion) VALUES
(2, 'La Esperanza',  1.20, 1890, 'Geisha',          2020, 'Guamo + Roble',         'Fair Trade + Organico'),
(2, 'El Mirador',    2.00, 1870, 'Bourbon Rosado',  2018, 'Guamo + Plátano',       'Rainforest Alliance');

-- José Rentería Mena (id=3) — 2 lotes en Riosucio, Caldas
INSERT INTO lotes (productor_id, nombre_lote, area_hectareas, altitud_msnm, variedad, anio_siembra, tipo_sombrío, sistema_certificacion) VALUES
(3, 'San Isidro',    3.50, 1620, 'Castillo',        2016, 'Guamo',                 'Convencional'),
(3, 'Los Pinos',     1.50, 1650, 'Caturra',         2020, 'Plátano + Guamo',       'Organico en transicion');

-- Esperanza Cifuentes (id=4) — 2 lotes en El Tambo, Cauca
INSERT INTO lotes (productor_id, nombre_lote, area_hectareas, altitud_msnm, variedad, anio_siembra, tipo_sombrío, sistema_certificacion) VALUES
(4, 'El Paraíso',    2.20, 1480, 'Colombia',        2018, 'Plátano',               'Convencional'),
(4, 'La Montaña',   1.80, 1510, 'Castillo',        2020, 'Plátano + Guamo',       'Convencional');

-- Rodrigo Aya Vargas (id=5) — 1 lote en Jardín, Antioquia
INSERT INTO lotes (productor_id, nombre_lote, area_hectareas, altitud_msnm, variedad, anio_siembra, tipo_sombrío, sistema_certificacion) VALUES
(5, 'Alto Bonito',   4.00, 1950, 'Typica + Bourbon', 2015, 'Guamo + Cedro + Nogal', 'Fair Trade + Organico');

-- ============================================================
-- REGISTROS FENOLÓGICOS
-- ============================================================

INSERT INTO registro_fenologico (lote_id, fecha, etapa, observacion, registrado_por) VALUES
-- Lote "El Nogal" de Martín (id_lote=1)
(1, '2025-04-15', 'floracion',   'Floración abundante, aproximadamente 85% de las plantas florecidas. Condiciones climáticas favorables.', 'Martín Ospina'),
(1, '2025-05-10', 'cuaje',       'Buen cuaje de frutos. Se estima 70% de conversión flor-fruto. Sin eventos de granizo.', 'Martín Ospina'),
(1, '2025-07-20', 'llenado',     'Frutos en llenado activo. Color verde brillante. Sin síntomas visibles de broca o roya.', 'Martín Ospina'),
(1, '2025-10-05', 'maduracion',  'Inicio de cambio de color. 15% de frutos pintones. Cosecha estimada para noviembre.', 'Martín Ospina'),
(1, '2025-11-20', 'cosecha',     'Primer pase de cosecha: 12 arrobas de cereza. Selectividad alta, solo frutos rojos.', 'Martín Ospina'),
(1, '2025-12-18', 'cosecha',     'Segundo pase: 18 arrobas. Total parcial: 30 arrobas de cereza seleccionada.', 'Martín Ospina'),

-- Lote "La Primavera" de Martín (id_lote=2)
(2, '2025-05-02', 'floracion',   'Floración tardía respecto al año anterior. Plantas jóvenes (4 años). Floración uniforme 90%.', 'Martín Ospina'),
(2, '2025-06-01', 'cuaje',       'Cuaje del 65%. Algunas flores caídas por viento fuerte el 20 de mayo.', 'Martín Ospina'),
(2, '2025-10-15', 'maduracion',  'Inicio lento de maduración por la variedad Pink Bourbon. Frutos cambiando a color amarillo.', 'Martín Ospina'),
(2, '2026-01-10', 'cosecha',     'Primer pase de cosecha: 8 arrobas. Frutos amarillo-rosados en punto óptimo.', 'Martín Ospina'),

-- Lote "La Esperanza" de Carmen (id_lote=4)
(4, '2025-03-20', 'floracion',   'Floración intensa después de la época seca. Geisha en plena flor, aroma intenso.', 'Carmen Lozano'),
(4, '2025-04-25', 'cuaje',       'Excelente cuaje. Estimado 80% de conversión.', 'Carmen Lozano'),
(4, '2025-08-10', 'llenado',     'Frutos en llenado. Aplicó abono foliar de algas la semana pasada.', 'Carmen Lozano'),
(4, '2025-12-05', 'maduracion',  'Inicio de cosecha. Geisha tomando color amarillo-anaranjado característico.', 'Carmen Lozano'),
(4, '2026-01-15', 'cosecha',     'Primer pase: 6 arrobas de Geisha. Calidad visual excelente, sin defectos aparentes.', 'Carmen Lozano'),

-- Lote "San Isidro" de José (id_lote=6)
(6, '2025-04-10', 'floracion',   'Floración normal. Castillo con floración uniforme. Sin problemas de estrés hídrico.', 'José Rentería'),
(6, '2025-09-15', 'maduracion',  'Inicio de maduración. Frutos cambiando de verde a rojo intenso.', 'José Rentería'),
(6, '2025-10-20', 'cosecha',     'Cosecha en curso. Primer pase: 25 arrobas.', 'José Rentería'),
(6, '2025-11-25', 'cosecha',     'Segundo pase: 30 arrobas. Total: 55 arrobas. Año de buena producción.', 'José Rentería');

-- ============================================================
-- INVENTARIO DE INSUMOS
-- ============================================================

INSERT INTO inventario_insumos (productor_id, insumo, tipo, cantidad, unidad, fecha_ultima_aplicacion, lote_aplicado) VALUES
-- Martín Ospina (id=1)
(1, 'Caldo bordelés (sulfato de cobre + cal)',  'fungicida organico', 15.00, 'kg',   '2025-12-01', 'El Nogal'),
(1, 'Lombriabono',                              'fertilizante organico', 200.00, 'kg', '2025-11-15', 'El Nogal, La Primavera'),
(1, 'Beauveria bassiana',                        'control biologico', 2.00, 'kg',     '2025-10-20', 'El Nogal'),
(1, 'Caldo sulfocálcico',                       'fungicida organico', 10.00, 'litros','2025-09-10', 'La Primavera'),
(1, 'Bocashi (abono fermentado)',               'fertilizante organico', 300.00, 'kg', '2025-08-05', 'Potrero Alto'),

-- Carmen Lozano (id=2)
(2, 'Compost de pulpa de café',                 'fertilizante organico', 500.00, 'kg', '2025-11-20', 'La Esperanza, El Mirador'),
(2, 'Extracto de algas foliares',              'bioestimulante', 5.00, 'litros',       '2025-08-10', 'La Esperanza'),
(2, 'Trichoderma sp.',                          'control biologico', 1.50, 'kg',       '2025-10-01', 'El Mirador'),
(2, 'Caldo bordelés',                          'fungicida organico', 8.00, 'kg',       '2025-09-15', 'La Esperanza'),

-- José Rentería (id=3)
(3, 'Urea',                                    'fertilizante quimico', 50.00, 'kg',   '2025-08-01', 'San Isidro'),
(3, 'Cloruro de potasio (KCl)',               'fertilizante quimico', 30.00, 'kg',    '2025-09-01', 'San Isidro'),
(3, 'Mancozeb',                               'fungicida quimico', 2.00, 'kg',        '2025-07-15', 'San Isidro'),
(3, 'Lombriabono',                            'fertilizante organico', 100.00, 'kg',  '2025-10-01', 'Los Pinos'),

-- Esperanza Cifuentes (id=4)
(4, 'Fertilizante 15-15-15',                  'fertilizante quimico', 40.00, 'kg',   '2025-09-20', 'El Paraíso'),
(4, 'Fungicida cobre (Kocide)',               'fungicida quimico', 3.00, 'kg',        '2025-10-05', 'La Montaña'),

-- Rodrigo Aya (id=5)
(5, 'Lombriabono',                            'fertilizante organico', 800.00, 'kg', '2025-11-01', 'Alto Bonito'),
(5, 'Caldo bordelés',                         'fungicida organico', 20.00, 'kg',     '2025-11-15', 'Alto Bonito'),
(5, 'Beauveria bassiana',                      'control biologico', 3.00, 'kg',      '2025-10-10', 'Alto Bonito'),
(5, 'Gallinaza compostada',                   'fertilizante organico', 1500.00, 'kg','2025-08-20', 'Alto Bonito');

-- ============================================================
-- PRECIOS DEL MERCADO (actualizables diariamente)
-- ============================================================

INSERT INTO precios_mercado (fecha, producto, precio_kg, precio_arroba, moneda, fuente, tipo_mercado) VALUES
('2026-05-20', 'Café pergamino seco (convencional)',  14500.00, 181250.00, 'COP', 'Federación Nacional de Cafeteros', 'interno'),
('2026-05-20', 'Café pergamino seco (organico)',       18200.00, 227500.00, 'COP', 'Cooperativa Organicos del Sur',  'especialidad'),
('2026-05-20', 'Café pergamino seco (Fair Trade)',     17800.00, 222500.00, 'COP', 'FLOCERT precio referencia',       'fair trade'),
('2026-05-20', 'Café especialidad >85 puntos',         28000.00, 350000.00, 'COP', 'Tostador directo - exportacion', 'especialidad'),
('2026-05-20', 'Café cereza (precio local)',            3200.00,  40000.00, 'COP', 'Cooperativa regional',           'local'),
('2026-05-21', 'Café pergamino seco (convencional)',  14650.00, 183125.00, 'COP', 'Federación Nacional de Cafeteros', 'interno'),
('2026-05-21', 'Café pergamino seco (organico)',       18350.00, 229375.00, 'COP', 'Cooperativa Organicos del Sur',  'especialidad'),
('2026-05-21', 'Café especialidad >85 puntos',         28500.00, 356250.00, 'COP', 'Tostador directo - exportacion', 'especialidad'),
('2026-05-22', 'Café pergamino seco (convencional)',  14800.00, 185000.00, 'COP', 'Federación Nacional de Cafeteros', 'interno'),
('2026-05-22', 'Café pergamino seco (organico)',       18500.00, 231250.00, 'COP', 'Cooperativa Organicos del Sur',  'especialidad'),
('2026-05-22', 'Café pergamino seco (Fair Trade)',     18000.00, 225000.00, 'COP', 'FLOCERT precio referencia',       'fair trade'),
('2026-05-22', 'Café especialidad >85 puntos',         29000.00, 362500.00, 'COP', 'Tostador directo - exportacion', 'especialidad'),
('2026-05-22', 'Café cereza (precio local)',            3300.00,  41250.00, 'COP', 'Cooperativa regional',           'local');

-- ============================================================
-- VENTAS REGISTRADAS
-- ============================================================

INSERT INTO ventas (productor_id, fecha, lote_id, cantidad_kg, precio_unitario_kg, total_venta, comprador, tipo_venta) VALUES
-- Martín Ospina
(1, '2025-12-20', 1, 250.00, 18200.00, 4550000.00, 'Cooperativa Huila Organicos', 'organico'),
(1, '2026-01-15', 2, 100.00, 28000.00, 2800000.00, 'Pergamino Café - Exportador', 'especialidad'),
(1, '2026-02-10', 3, 375.00, 14500.00, 5437500.00, 'Federación de Cafeteros',     'convencional'),

-- Carmen Lozano
(2, '2026-01-20', 4,  75.00, 29000.00, 2175000.00, 'Amor Perfecto Tostadores',    'especialidad'),
(2, '2025-12-10', 5, 200.00, 17800.00, 3560000.00, 'Cooperativa Salento Fair Trade', 'fair trade'),

-- José Rentería
(3, '2025-11-15', 6, 550.00, 14500.00, 7975000.00, 'Federación de Cafeteros',     'convencional'),
(3, '2025-12-01', 7, 100.00, 16500.00, 1650000.00, 'Cooperativa Riosucio',        'convencional'),

-- Rodrigo Aya
(5, '2026-02-05', 9, 300.00, 27000.00, 8100000.00, 'Pergamino Café - Exportador', 'especialidad');

-- ============================================================
-- ALERTAS SANITARIAS (historial de problemas)
-- ============================================================

INSERT INTO alertas_sanitarias (lote_id, fecha, tipo_alerta, descripcion, nivel_severidad, accion_tomada, resuelta) VALUES
(1, '2025-08-15', 'Roya (Hemileia vastatrix)',
   'Aparición de manchas amarillas en envés de hojas. Aproximadamente 12% de plantas afectadas. Zona baja del lote con mayor incidencia.',
   'moderado',
   'Aplicación de caldo bordelés 3 veces cada 15 días. Eliminación de hojas más afectadas.',
   TRUE),

(3, '2025-09-01', 'Broca del café (Hypothenemus hampei)',
   'Se detectó 4.5% de frutos brocados en monitoreo rutinario. Concentración en el sector central del lote donde hay más sombra.',
   'moderado',
   'Aplicación de Beauveria bassiana. Instalación de 20 trampas con alcohol. Re-re intensivo.',
   TRUE),

(6, '2025-07-20', 'Deficiencia de potasio',
   'Bordes de hojas amarillas-cafés en plantas adultas de todo el lote. Necrosis marginal evidente en más del 30% de plantas.',
   'moderado',
   'Aplicación de KCl 50 g por planta. Seguimiento quincenal.',
   TRUE),

(2, '2025-11-10', 'Mancha de hierro (Cercospora coffeicola)',
   'Manchas circulares con centro blanco en hojas. Afecta principalmente plantas jóvenes del sector norte. Plantas con posible deficiencia nutricional.',
   'leve',
   'Aplicación de caldo bordelés. Fertilización con lombriabono.',
   FALSE),

(9, '2025-10-05', 'Antracnosis (Colletotrichum)',
   'Frutos con manchas hundidas café oscuras. Concentrado en la parte baja del lote. Condiciones muy húmedas las semanas anteriores.',
   'moderado',
   'Poda de ramas afectadas. Caldo bordelés. Recolección urgente de frutos afectados.',
   TRUE);
