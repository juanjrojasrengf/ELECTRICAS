-- Tabla de Marcas de patinetas
CREATE TABLE marcas (
    marca_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    pais_origen VARCHAR(50),
    fecha_fundacion DATE,
    descripcion TEXT
);

-- Tabla de Modelos de patinetas
CREATE TABLE modelos (
    modelo_id INT PRIMARY KEY AUTO_INCREMENT,
    marca_id INT,
    nombre VARCHAR(50) NOT NULL,
    año_lanzamiento INT,
    peso_kg DECIMAL(5,2),
    velocidad_max_kmh DECIMAL(5,2),
    autonomia_km DECIMAL(6,2),
    potencia_w INT,
    FOREIGN KEY (marca_id) REFERENCES marcas(marca_id)
);

-- Tabla de Estados de patineta
CREATE TABLE estados_patineta (
    estado_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    descripcion TEXT
);

-- Tabla principal de Patinetas
CREATE TABLE patinetas (
    patineta_id INT PRIMARY KEY AUTO_INCREMENT,
    modelo_id INT,
    estado_id INT,
    codigo_serie VARCHAR(50) UNIQUE NOT NULL,
    fecha_compra DATE,
    precio_compra DECIMAL(10,2),
    bateria_actual DECIMAL(5,2) COMMENT 'Porcentaje de batería',
    fecha_ultimo_mantenimiento DATE,
    notas TEXT,
    FOREIGN KEY (modelo_id) REFERENCES modelos(modelo_id),
    FOREIGN KEY (estado_id) REFERENCES estados_patineta(estado_id)
);

-- Tabla de Ubicaciones (se actualiza constantemente)
CREATE TABLE ubicaciones (
    ubicacion_id INT PRIMARY KEY AUTO_INCREMENT,
    patineta_id INT,
    latitud DECIMAL(10,8) NOT NULL,
    longitud DECIMAL(11,8) NOT NULL,
    fecha_hora_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    velocidad_actual DECIMAL(5,2) COMMENT 'En km/h',
    bateria_en_ubicacion DECIMAL(5,2),
    FOREIGN KEY (patineta_id) REFERENCES patinetas(patineta_id)
);

-- Tabla de Tipos de Usuario
CREATE TABLE tipos_usuario (
    tipo_usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla de Usuarios
CREATE TABLE usuarios (
    usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_usuario_id INT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    direccion TEXT,
    documento_identidad VARCHAR(50) UNIQUE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    saldo DECIMAL(10,2) DEFAULT 0.00,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (tipo_usuario_id) REFERENCES tipos_usuario(tipo_usuario_id)
);

-- Tabla de Métodos de Pago
CREATE TABLE metodos_pago (
    metodo_pago_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla de Tarifas
CREATE TABLE tarifas (
    tarifa_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    costo_por_minuto DECIMAL(6,2) NOT NULL,
    costo_desbloqueo DECIMAL(6,2) DEFAULT 0.00,
    descripcion TEXT,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE
);

-- Tabla de Estados de Alquiler
CREATE TABLE estados_alquiler (
    estado_alquiler_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    descripcion TEXT
);

-- Tabla principal de Alquileres
CREATE TABLE alquileres (
    alquiler_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    patineta_id INT,
    tarifa_id INT,
    metodo_pago_id INT,
    estado_alquiler_id INT,
    fecha_hora_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_fin DATETIME,
    ubicacion_inicio_lat DECIMAL(10,8),
    ubicacion_inicio_lon DECIMAL(11,8),
    ubicacion_fin_lat DECIMAL(10,8),
    ubicacion_fin_lon DECIMAL(11,8),
    costo_total DECIMAL(10,2),
    distancia_recorrida_km DECIMAL(8,2),
    duracion_minutos INT,
    calificacion_usuario TINYINT COMMENT 'De 1 a 5 estrellas',
    comentarios_usuario TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (patineta_id) REFERENCES patinetas(patineta_id),
    FOREIGN KEY (tarifa_id) REFERENCES tarifas(tarifa_id),
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(metodo_pago_id),
    FOREIGN KEY (estado_alquiler_id) REFERENCES estados_alquiler(estado_alquiler_id)
);

-- Tabla de Pagos
CREATE TABLE pagos (
    pago_id INT PRIMARY KEY AUTO_INCREMENT,
    alquiler_id INT,
    metodo_pago_id INT,
    monto DECIMAL(10,2) NOT NULL,
    fecha_hora_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado_pago VARCHAR(20) NOT NULL,
    transaccion_id VARCHAR(100),
    FOREIGN KEY (alquiler_id) REFERENCES alquileres(alquiler_id),
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(metodo_pago_id)
);

-- Tabla de Mantenimientos
CREATE TABLE mantenimientos (
    mantenimiento_id INT PRIMARY KEY AUTO_INCREMENT,
    patineta_id INT,
    usuario_tecnico_id INT,
    tipo_mantenimiento VARCHAR(50) NOT NULL,
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME,
    descripcion TEXT,
    costo DECIMAL(10,2),
    repuestos_cambiados TEXT,
    FOREIGN KEY (patineta_id) REFERENCES patinetas(patineta_id),
    FOREIGN KEY (usuario_tecnico_id) REFERENCES usuarios(usuario_id)
);

-- Tabla de Incidentes
CREATE TABLE incidentes (
    incidente_id INT PRIMARY KEY AUTO_INCREMENT,
    patineta_id INT,
    usuario_id INT,
    alquiler_id INT,
    tipo_incidente VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_hora_incidente DATETIME DEFAULT CURRENT_TIMESTAMP,
    ubicacion_lat DECIMAL(10,8),
    ubicacion_lon DECIMAL(11,8),
    gravedad VARCHAR(20),
    estado VARCHAR(20) DEFAULT 'Reportado',
    acciones_tomadas TEXT,
    FOREIGN KEY (patineta_id) REFERENCES patinetas(patineta_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (alquiler_id) REFERENCES alquileres(alquiler_id)
);

