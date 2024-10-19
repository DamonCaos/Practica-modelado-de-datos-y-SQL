create schema if not exists jrodriguezvideoclub;

set schema 'jrodriguezvideoclub';

create table direccion (
	id_direccion SERIAL primary key,
	calle VARCHAR(20) not null,
	piso VARCHAR(10) not null,
	codigo_postal numeric not null
	);
create table socios (
	id_socio SERIAL primary key,
	nombre VARCHAR(20) not null, 
	apellidos Varchar(30) not null,
	fecha_nacimiento date not null,
	telefono_contacto numeric not null,
	dni_socio varchar(9) not null,
	id_direccion int
	);
create table pelicula (
	id_pelicula SERIAL primary key,
	titulo varchar(30) not null,
	genero varchar(30) not null,
	director varchar(20) not null,
	sinopsis varchar(250),
	num_copias numeric not null
	);
create table copia_pelicula (
	id_copia SERIAL primary key,
	id_pelicula int not null,
	num_copia numeric not null,
	prestada boolean not null
	);
create table prestamo (
	id_prestamo SERIAL primary key,
	id_socio int not null,
	id_pelicula int not null,
	id_copia int not null,
	fecha_prestamo date not null,
	fecha_devolucion date
	);

ALTER TABLE socios 
ADD CONSTRAINT fk_direccion FOREIGN KEY (id_direccion) 
REFERENCES direccion(id_direccion);

ALTER TABLE copia_pelicula 
ADD CONSTRAINT fk_pelicula FOREIGN KEY (id_pelicula) 
REFERENCES pelicula(id_pelicula);

ALTER TABLE prestamo 
ADD CONSTRAINT fk_socio FOREIGN KEY (id_socio) 
REFERENCES socios(id_socio),
ADD CONSTRAINT fk_pelicula FOREIGN KEY (id_pelicula) 
REFERENCES pelicula(id_pelicula),
ADD CONSTRAINT fk_copia FOREIGN KEY (id_copia) 
REFERENCES copia_pelicula(id_copia);

-- Inserta datos en la tabla direccion
INSERT INTO direccion (calle, piso, codigo_postal) VALUES
('Calle Falsa', '1', 28001),
('Avenida Siempre', '2', 28002),
('Calle del Cielo', '3', 28003);

-- Inserta datos en la tabla socios
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, telefono_contacto, dni_socio, id_direccion) VALUES
('Juan', 'Pérez', '1990-05-15', 600123456, '12345678A', 1),
('Ana', 'Gómez', '1985-03-22', 600654321, '87654321B', 2),
('Luis', 'Fernández', '1992-07-30', 600987654, '12345679C', 3);

-- Inserta datos en la tabla pelicula
INSERT INTO pelicula (titulo, genero, director, sinopsis, num_copias) VALUES
('El Resplandor', 'Terror', 'Stanley Kubrick', 'Un escritor se convierte en el cuidador de un hotel embrujado.', 3),
('La Cosa', 'Ciencia Ficción', 'John Carpenter', 'Un grupo en la Antártida se enfrenta a una criatura alienígena.', 2),
('Alien', 'Ciencia Ficción', 'Ridley Scott', 'La tripulación de una nave espacial se enfrenta a un alienígena mortal.', 4);

-- Inserta datos en la tabla copia_pelicula
INSERT INTO copia_pelicula (id_pelicula, num_copia, prestada) VALUES
(1, 1, FALSE),
(1, 2, TRUE),
(1, 3, FALSE),
(2, 1, FALSE),
(2, 2, FALSE),
(3, 1, FALSE),
(3, 2, TRUE),
(3, 3, FALSE),
(3, 4, FALSE);

-- Inserta datos en la tabla prestamo
INSERT INTO prestamo (id_socio, id_pelicula, id_copia, fecha_prestamo, fecha_devolucion) VALUES
(1, 1, 2, '2024-10-10', NULL),
(2, 3, 2, '2024-10-11', NULL);

SELECT 
    p.titulo,
    COUNT(c.id_copia) AS copias_disponibles
FROM 
    pelicula p
JOIN 
    copia_pelicula c ON p.id_pelicula = c.id_pelicula
LEFT JOIN 
    prestamo pr ON c.id_copia = pr.id_copia AND pr.fecha_devolucion IS NULL
GROUP BY 
    p.id_pelicula
HAVING 
    COUNT(pr.id_prestamo) = 0;
   
SELECT 
    s.nombre,
    s.apellidos,
    p.titulo,
    pr.fecha_prestamo
FROM 
    prestamo pr
JOIN 
    socios s ON pr.id_socio = s.id_socio
JOIN 
    copia_pelicula c ON pr.id_copia = c.id_copia
JOIN 
    pelicula p ON c.id_pelicula = p.id_pelicula
WHERE 
    pr.fecha_devolucion IS NULL;
  
   



