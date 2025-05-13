-- Procedimiento para agregar un usuario nuevo con lo básico
CREATE OR REPLACE PROCEDURE registrar_usuario_simple(
    IN p_nombre VARCHAR,
    IN p_apellido VARCHAR,
    IN p_email VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO usuarios(nombre, apellido, email, tipo_usuario_id)
    VALUES (p_nombre, p_apellido, p_email, 1);
END;
$$;

-- Procedimiento para crear un incidente
CREATE OR REPLACE PROCEDURE registrar_incidente_basico(
    IN p_patineta_id INT,
    IN p_tipo_incidente VARCHAR,
    IN p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO incidentes(patineta_id, tipo_incidente, descripcion)
    VALUES (p_patineta_id, p_tipo_incidente, p_descripcion);
END;
$$;

-- Procedimiento para iniciar un nuevo alquiler
CREATE OR REPLACE PROCEDURE iniciar_alquiler(
    IN p_usuario_id INT,
    IN p_patineta_id INT,
    IN p_tarifa_id INT,
    IN p_metodo_pago_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO alquileres(usuario_id, patineta_id, tarifa_id, metodo_pago_id, estado_alquiler_id)
    VALUES (p_usuario_id, p_patineta_id, p_tarifa_id, p_metodo_pago_id, 1);
    
    UPDATE patinetas
    SET estado_id = (SELECT estado_id FROM estados_patineta WHERE nombre = 'En uso')
    WHERE patineta_id = p_patineta_id;
END;
$$;

-- Procedimiento para finalizar un alquiler
CREATE OR REPLACE PROCEDURE finalizar_alquiler(
    IN p_alquiler_id INT,
    IN p_lat_fin DECIMAL,
    IN p_lon_fin DECIMAL,
    IN p_duracion INT,
    IN p_km DECIMAL,
    IN p_calificacion TINYINT,
    IN p_comentario TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    p_patineta_id INT;
BEGIN
    UPDATE alquileres
    SET 
        fecha_hora_fin = CURRENT_TIMESTAMP,
        ubicacion_fin_lat = p_lat_fin,
        ubicacion_fin_lon = p_lon_fin,
        duracion_minutos = p_duracion,
        distancia_recorrida_km = p_km,
        calificacion_usuario = p_calificacion,
        comentarios_usuario = p_comentario,
        costo_total = calcular_costo_alquiler(p_duracion, tarifa_id),
        estado_alquiler_id = (SELECT estado_alquiler_id FROM estados_alquiler WHERE nombre = 'Completado')
    WHERE alquiler_id = p_alquiler_id;

    SELECT patineta_id INTO p_patineta_id FROM alquileres WHERE alquiler_id = p_alquiler_id;

    UPDATE patinetas
    SET estado_id = (SELECT estado_id FROM estados_patineta WHERE nombre = 'Disponible')
    WHERE patineta_id = p_patineta_id;
END;
$$;

-- Procedimiento para registrar mantenimiento preventivo
CREATE OR REPLACE PROCEDURE registrar_mantenimiento_preventivo(
    IN p_patineta_id INT,
    IN p_usuario_tecnico_id INT,
    IN p_descripcion TEXT,
    IN p_costo DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO mantenimientos(
        patineta_id,
        usuario_tecnico_id,
        tipo_mantenimiento,
        fecha_hora_inicio,
        descripcion,
        costo
    ) VALUES (
        p_patineta_id,
        p_usuario_tecnico_id,
        'Preventivo',
        CURRENT_TIMESTAMP,
        p_descripcion,
        p_costo
    );

    UPDATE patinetas
    SET estado_id = (SELECT estado_id FROM estados_patineta WHERE nombre = 'Mantenimiento')
    WHERE patineta_id = p_patineta_id;
END;
$$;

