-- Consulta de Patinetas Disponibles con su Ubicación Actual
SELECT p.patineta_id, p.codigo_serie, u.latitud, u.longitud, u.fecha_hora_registro
FROM patinetas p
JOIN estados_patineta ep ON p.estado_id = ep.estado_id
JOIN (
    SELECT DISTINCT ON (patineta_id) *
    FROM ubicaciones
    ORDER BY patineta_id, fecha_hora_registro DESC
) u ON p.patineta_id = u.patineta_id
WHERE ep.nombre = 'Disponible';

-- Consulta de Alquileres Activos con Detalles de Usuario y Patineta
SELECT a.alquiler_id, u.nombre, u.apellido, p.codigo_serie, a.fecha_hora_inicio
FROM alquileres a
JOIN usuarios u ON a.usuario_id = u.usuario_id
JOIN patinetas p ON a.patineta_id = p.patineta_id
JOIN estados_alquiler ea ON a.estado_alquiler_id = ea.estado_alquiler_id
WHERE ea.nombre = 'Activo';

-- Consulta de Ingresos por Período (Agrupado por Mes)
SELECT 
    DATE_TRUNC('month', fecha_hora_pago) AS mes,
    SUM(monto) AS total_ingresos
FROM pagos
GROUP BY mes
ORDER BY mes;

-- Consulta de Mantenimientos Pendientes y Patinetas que los Necesitan
SELECT p.patineta_id, p.codigo_serie, m.fecha_hora_inicio, m.descripcion
FROM mantenimientos m
JOIN patinetas p ON m.patineta_id = p.patineta_id
WHERE m.fecha_hora_fin IS NULL;

-- Consulta de Uso por Patineta (Top 10 más utilizadas)
SELECT 
    p.patineta_id,
    p.codigo_serie,
    COUNT(a.alquiler_id) AS total_alquileres
FROM patinetas p
JOIN alquileres a ON p.patineta_id = a.patineta_id
GROUP BY p.patineta_id, p.codigo_serie
ORDER BY total_alquileres DESC
LIMIT 10;

