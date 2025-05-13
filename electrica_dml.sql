-- Insertar estados básicos de patinetas
INSERT INTO estados_patineta (nombre, descripcion) VALUES 
('Disponible', 'Patineta en buen estado y disponible para alquiler'),
('En uso', 'Patineta actualmente alquilada'),
('Mantenimiento', 'Patineta en reparación o mantenimiento'),
('Inactiva', 'Patineta no disponible por algún motivo');

-- Insertar tipos de usuario básicos
INSERT INTO tipos_usuario (nombre, descripcion) VALUES 
('Cliente', 'Usuario regular que alquila patinetas'),
('Técnico', 'Personal encargado de mantenimiento'),
('Administrador', 'Personal con acceso completo al sistema');

-- Insertar métodos de pago comunes
INSERT INTO metodos_pago (nombre, descripcion) VALUES 
('Tarjeta Crédito', 'Pago con tarjeta de crédito'),
('Tarjeta Débito', 'Pago con tarjeta de débito'),
('PayPal', 'Pago a través de PayPal'),
('Transferencia', 'Transferencia bancaria');

-- Insertar estados de alquiler
INSERT INTO estados_alquiler (nombre, descripcion) VALUES 
('Activo', 'Alquiler en curso'),
('Completado', 'Alquiler finalizado correctamente'),
('Cancelado', 'Alquiler cancelado por el usuario'),
('Problema', 'Alquiler con algún problema reportado');