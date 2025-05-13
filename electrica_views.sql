-- Vista: Resumen legible de los alquileres
CREATE OR REPLACE VIEW vista_alquileres_detallados AS
SELECT 
    a.alquiler_id,
    u.nombre || ' ' || u.apellido AS usuario,
    p.codigo_serie AS patineta,
    t.nombre AS tarifa,
    a.fecha_hora_inicio,
    a.fecha_hora_fin,
    a.costo_total,
    a.distancia_recorrida_km,
    a.duracion_minutos
FROM alquileres a
JOIN usuarios u ON a.usuario_id = u.usuario_id
JOIN patinetas p ON a.patineta_id = p.patineta_id
JOIN tarifas t ON a.tarifa_id = t.tarifa_id;

-- Vista: Última ubicación registrada por patineta
CREATE OR REPLACE VIEW vista_ubicaciones_recientes AS
SELECT DISTINCT ON (u.patineta_id)
    u.patineta_id,
    m.nombre AS modelo,
    u.latitud,
    u.longitud,
    u.fecha_hora_registro,
    u.velocidad_actual,
    u.bateria_en_ubicacion
FROM ubicaciones u
JOIN patinetas p ON u.patineta_id = p.patineta_id
JOIN modelos m ON p.modelo_id = m.modelo_id
ORDER BY u.patineta_id, u.fecha_hora_registro DESC;

