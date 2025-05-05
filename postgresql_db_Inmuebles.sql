-- CREATE DATABASE db_inmuebles;
-- Creación de la tabla principal de inmuebles
CREATE TABLE inmuebles (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  descripcion TEXT,
  direccion VARCHAR(200) NOT NULL,
  ciudad VARCHAR(50) NOT NULL,
  pais VARCHAR(50) NOT NULL,
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('casa', 'apartamento', 'habitacion', 'oficina', 'local')),
  capacidad INTEGER NOT NULL,
  habitaciones INTEGER NOT NULL,
  banos INTEGER NOT NULL,
  precio_noche DECIMAL(10, 2) NOT NULL,
  internet_type VARCHAR(20) NOT NULL DEFAULT 'No Disponible' CHECK (internet_type IN ('Fibra Óptica', '4G LTE', 'ADSL', 'No Disponible')),
  estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('publicado', 'pendiente', 'rechazado')),
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_publicacion TIMESTAMP,
  usuario_id INTEGER NOT NULL
);

-- Índices para mejorar rendimiento
CREATE INDEX idx_inmuebles_estado ON inmuebles(estado);
CREATE INDEX idx_inmuebles_fecha_publicacion ON inmuebles(fecha_publicacion);
CREATE INDEX idx_inmuebles_usuario ON inmuebles(usuario_id);

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  verificado BOOLEAN NOT NULL DEFAULT FALSE,
  rol VARCHAR(20) NOT NULL DEFAULT 'anfitrion' CHECK (rol IN ('anfitrion', 'huesped', 'admin'))
);


CREATE TABLE reservas (
  id SERIAL PRIMARY KEY,
  inmueble_id INTEGER NOT NULL REFERENCES inmuebles(id),
  usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  precio_total DECIMAL(10, 2) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada', 'completada')),
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reservas_inmueble ON reservas(inmueble_id);
CREATE INDEX idx_reservas_usuario ON reservas(usuario_id);

-- insert

INSERT INTO usuarios (nombre, apellido, email, password_hash, telefono, verificado, rol) VALUES
('María', 'González', 'maria@aloja.com', '$2a$10$xJwL5v5Jz5UZJz5UZJz5Ue', '+5491112345678', TRUE, 'anfitrion'),
('Juan', 'Pérez', 'juan@aloja.com', '$2a$10$xJwL5v5Jz5UZJz5UZJz5Ue', '+5491123456789', TRUE, 'anfitrion'),
('Ana', 'Martínez', 'ana@aloja.com', '$2a$10$xJwL5v5Jz5UZJz5UZJz5Ue', '+5491134567890', FALSE, 'anfitrion'),
('Admin', 'Sistema', 'admin@aloja.com', '$2a$10$xJwL5v5Jz5UZJz5UZJz5Ue', '+5491100000000', TRUE, 'admin');

-- Inmuebles publicados en las últimas 24 horas
INSERT INTO inmuebles (titulo, descripcion, direccion, ciudad, pais, tipo, capacidad, habitaciones, banos, precio_noche, internet_type, estado, fecha_publicacion, usuario_id) VALUES
('Acogedor apartamento en centro', 'Amplio apartamento con vista al mar', 'Av. Rivadavia 1200', 'Buenos Aires', 'Argentina', 'apartamento', 4, 2, 1, 45.00, 'Fibra Óptica', 'publicado', NOW() - INTERVAL '12 hours', 1),
('Casa moderna con piscina', 'Casa de 3 habitaciones en zona residencial', 'Calle Falsa 123', 'Córdoba', 'Argentina', 'casa', 6, 3, 2, 80.00, '4G LTE', 'publicado', NOW() - INTERVAL '6 hours', 2);

-- Inmuebles pendientes de aprobación
INSERT INTO inmuebles (titulo, descripcion, direccion, ciudad, pais, tipo, capacidad, habitaciones, banos, precio_noche, internet_type, estado, usuario_id) VALUES
('Oficina coworking en Palermo', 'Espacio ideal para emprendedores', 'Thames 1500', 'Buenos Aires', 'Argentina', 'oficina', 10, 1, 2, 30.00, 'Fibra Óptica', 'pendiente', 1),
('Habitación en casa compartida', 'Habitación amueblada cerca de universidad', 'Sarmiento 456', 'Mendoza', 'Argentina', 'habitacion', 1, 1, 1, 20.00, 'ADSL', 'pendiente', 3);

-- Inmuebles publicados hace más de 24 horas
INSERT INTO inmuebles (titulo, descripcion, direccion, ciudad, pais, tipo, capacidad, habitaciones, banos, precio_noche, internet_type, estado, fecha_publicacion, usuario_id) VALUES
('Loft en zona turística', 'Pequeño loft cerca de atracciones principales', 'Defensa 789', 'Buenos Aires', 'Argentina', 'apartamento', 2, 1, 1, 55.00, 'No Disponible', 'publicado', NOW() - INTERVAL '36 hours', 2),
('Cabaña en las montañas', 'Cabaña rústica con vista espectacular', 'Ruta 101 km 25', 'Bariloche', 'Argentina', 'casa', 4, 2, 1, 65.00, 'No Disponible', 'publicado', NOW() - INTERVAL '48 hours', 1);

INSERT INTO reservas (inmueble_id, usuario_id, fecha_inicio, fecha_fin, precio_total, estado) VALUES
(1, 3, CURRENT_DATE + INTERVAL '5 days', CURRENT_DATE + INTERVAL '10 days', 225.00, 'confirmada'),
(2, 3, CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '20 days', 400.00, 'pendiente'),
(5, 2, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '3 days', 325.00, 'completada');

-- Ejecutar el query del bonus

SELECT 
  COUNT(CASE WHEN estado = 'publicado' 
        AND fecha_publicacion >= NOW() - INTERVAL '24 hours' 
        THEN 1 ELSE NULL END) AS publicados_ultimas_24h,
  COUNT(CASE WHEN estado = 'pendiente' THEN 1 ELSE NULL END) AS pendientes_aprobacion
FROM inmuebles;


-- Consulta adicional: Inmuebles por tipo de internet

SELECT 
  internet_type AS tipo_internet,
  COUNT(*) AS cantidad_inmuebles,
  ROUND(AVG(precio_noche), 2) AS precio_promedio
FROM inmuebles
WHERE estado = 'publicado'
GROUP BY internet_type
ORDER BY cantidad_inmuebles DESC;