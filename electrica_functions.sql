-- Función que devuelve el nombre de la marca a partir de su ID:
CREATE OR REPLACE FUNCTION obtener_nombre_marca(mid INT)
RETURNS VARCHAR AS $$
DECLARE
    resultado VARCHAR;
BEGIN
    SELECT nombre INTO resultado FROM marcas WHERE marca_id = mid;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

-- Función que devuelve el número total de alquileres de un usuario:
CREATE OR REPLACE FUNCTION total_alquileres_usuario(uid INT)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total FROM alquileres WHERE usuario_id = uid;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Función para calcular el costo de un alquiler en tiempo real:
CREATE OR REPLACE FUNCTION calcular_costo_alquiler(
    minutos INT,
    tarifa_id INT
)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    costo DECIMAL(10,2);
    desbloqueo DECIMAL(10,2);
    por_minuto DECIMAL(6,2);
BEGIN
    SELECT costo_desbloqueo, costo_por_minuto
    INTO desbloqueo, por_minuto
    FROM tarifas
    WHERE tarifa_id = calcular_costo_alquiler.tarifa_id;

    costo := desbloqueo + (por_minuto * minutos);
    RETURN costo;
END;
$$ LANGUAGE plpgsql;

-- Función para verificar disponibilidad de una patineta
CREATE OR REPLACE FUNCTION esta_disponible(patineta INT)
RETURNS BOOLEAN AS $$
DECLARE
    estado_actual VARCHAR(20);
BEGIN
    SELECT ep.nombre
    INTO estado_actual
    FROM patinetas p
    JOIN estados_patineta ep ON p.estado_id = ep.estado_id
    WHERE p.patineta_id = patineta;

    RETURN (estado_actual = 'Disponible');
END;
$$ LANGUAGE plpgsql;

