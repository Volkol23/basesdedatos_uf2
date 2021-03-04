CREATE DATABASE pokenti;

DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS players_pokentis;

DROP TABLE IF EXISTS pokentis_evolutions;
DROP TABLE IF EXISTS evolutions;

DROP TABLE IF EXISTS pokentis_types;
DROP TABLE IF EXISTS types;

DROP TABLE IF EXISTS stats;

DROP TABLE IF EXISTS pokentis;

DROP PROCEDURE IF EXISTS add_to_team;
DROP PROCEDURE IF EXISTS add_to_computer;
DROP PROCEDURE IF EXISTS heal_pokenti;

/* Creación de los procedimientos o funciones de Pokénti */

/*Procedimiento que actualiza la variable booleana de false a true si podemos añadirlo al equipo maximo numero de 6*/
DELIMITER $$

CREATE PROCEDURE add_to_team(IN in_id_player_pokenti INT UNSIGNED)
BEGIN
	SET @team := 0;
	SELECT SUM(in_use = 1) INTO @team FROM players_pokentis;

	IF @team < 6 THEN
		UPDATE players_pokentis SET in_use = true WHERE id_player_pokenti=in_id_player_pokenti;
	END IF;
END$$

DELIMITER ;

/*Procedimiento que actualiza la variable booleana de true a false si tenemos más de un pokenti en el equipo*/

DELIMITER $$

CREATE PROCEDURE add_to_computer(IN in_id_player_pokenti INT UNSIGNED)
BEGIN
	SET @team := 0;
	SELECT SUM(in_use = 1) INTO @team FROM players_pokentis;

	IF @team > 1 THEN
		UPDATE players_pokentis SET in_use = false WHERE id_player_pokenti=in_id_player_pokenti;
	END IF;
END$$

DELIMITER ;

/* Prodecimiento que nos permite curar a un pokenti que llevamos, los del pc no se curan (Poner stat de vida a 100)*/
DELIMITER $$

CREATE PROCEDURE heal_pokenti(IN in_id_player_pokenti INT UNSIGNED)
BEGIN
	SET @use := false;
    SELECT in_use INTO @use FROM players_pokentis WHERE id_plid_player_pokenti=in_id_player_pokenti;
    
    IF @use = true THEN
		SET @stat_id := 0;
		SELECT id_stat INTO @stat_id FROM players_pokentis WHERE id_player_pokenti=in_id_player_pokenti;
		UPDATE stats SET health=100 WHERE id_stat=@stat_id;
    END IF;
END$$

DELIMITER ;


/* Estructura y creación de la tablas */
CREATE TABLE pokentis (
    id_pokenti INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    number INT NOT NULL,
    name VARCHAR(16) NOT NULL,
    description TEXT NOT NULL
);
CREATE TABLE stats (
    id_stat INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `level` INT NOT NULL,
    health INT NOT NULL,
    attack INT NOT NULL, 
    defense INT NOT NULL,
    special_attack INT NOT NULL,
    special_defense INT NOT NULL,
    speed INT NOT NULL
);
CREATE TABLE types (
    id_type INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(16)
);
CREATE TABLE evolutions(
    id_evolution INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `level` INT NOT NULL,
    evolve_to INT NOT NULL
);
CREATE TABLE pokentis_types(
    id_pokenti_type INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pokenti INT UNSIGNED NOT NULL,
    id_type INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pokenti) REFERENCES pokentis(id_pokenti)
    ON DELETE CASCADE,
    FOREIGN KEY (id_type) REFERENCES types(id_type)
    ON DELETE RESTRICT
);
CREATE TABLE pokentis_evolutions(
    id_pokenti_evolution INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pokenti INT UNSIGNED NOT NULL,
    id_evolution INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pokenti) REFERENCES pokentis(id_pokenti)
    ON DELETE CASCADE,
    FOREIGN KEY (id_evolution) REFERENCES evolutions(id_evolution)
    ON DELETE RESTRICT
);
CREATE TABLE players_pokentis (
    id_player_pokenti INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nickname VARCHAR(16),
    in_use BOOLEAN NOT NULL,
    id_stat INT UNSIGNED NOT NULL,
    id_pokenti INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_stat) REFERENCES stats(id_stat)
    ON DELETE CASCADE,
    FOREIGN KEY (id_pokenti) REFERENCES pokentis(id_pokenti)
    ON DELETE CASCADE
);
/*
CREATE TABLE teams (
    id_team INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_player_pokenti_1 INT UNSIGNED NOT NULL DEFAULT 0,
    id_player_pokenti_2 INT UNSIGNED NOT NULL DEFAULT 0,
    id_player_pokenti_3 INT UNSIGNED NOT NULL DEFAULT 0,
    id_player_pokenti_4 INT UNSIGNED NOT NULL DEFAULT 0, 
    id_player_pokenti_5 INT UNSIGNED NOT NULL DEFAULT 0,
    id_player_pokenti_6 INT UNSIGNED NOT NULL DEFAULT 0,
    FOREIGN KEY (id_player_pokenti_1) REFERENCES players_pokentis(id_player_pokenti)
    ON DELETE RESTRICT,
    FOREIGN KEY (id_player_pokenti_2) REFERENCES players_pokentis(id_player_pokenti)
    ON DELETE RESTRICT,
    FOREIGN KEY (id_player_pokenti_3) REFERENCES players_pokentis(id_player_pokenti)
    ON DELETE RESTRICT,
    FOREIGN KEY (id_player_pokenti_4) REFERENCES players_pokentis(id_player_pokenti)
    ON DELETE RESTRICT,
    FOREIGN KEY (id_player_pokenti_5) REFERENCES players_pokentis(id_player_pokenti)
    ON DELETE RESTRICT,
    FOREIGN KEY (id_player_pokenti_6) REFERENCES players_pokentis(id_player_pokenti)
    ON DELETE RESTRICT
);
*/

/* insert de datos */
INSERT INTO pokentis (number, name, description) VALUES 
(1, "Bulbasaur", "Bicho que le sale un bulbo en la espalda"),
(2, "Ivysaur", "El bulbo de su espalda parece que florecera"),
(3, "Venusaur", "Le ha aparecido un a flor"),
(4, "Charmander", "Dragón de fuego que no es dragón"),
(5, "Charmeleon", "Tiene uns garras to flamas"),
(6, "Charizard", "Dragón de fuego que no puede utilizar placaje"),
(7, "Squirtle", "Tortuga que tranquiliza a los demás"),
(8, "Wartotle", "Tortuga más grande que ejerce presión"),
(9, "Blastoise", "Tortuga gigante que le han puesto unos cañones"),
(147, "Dratini", "Anguila de mar que SÍ es un dragón"),
(148, "Dragonair", "Anguila más grande"),
(149, "Dragonite", "Canta el himno de espanita muy bien"),
(116, "Horsea", "Caballito de mar mono"),
(117, "Seadra", "Caballito de mar venenoso"),
(77, "Ponyta", "Caballo, de fuego que quema las hierbas que come"),
(78, "Rapidash", "Caballo de fuego más guapo");

INSERT INTO stats (level, health, attack, defense, special_attack, special_defense, speed) VALUES
(50, 152, 111, 111, 128, 128, 106),
(50, 167, 125, 126, 145, 145, 123),
(50, 187, 167, 192, 191, 189, 145),
(50, 146, 114, 104, 123, 112, 128),
(50, 165, 127, 121, 145, 128, 145),
(50, 185, 149, 143, 177, 150, 167),
(50, 151, 110, 128, 112, 127, 104),
(50, 166, 126, 145, 128, 145, 121),
(50, 186, 148, 167, 150, 172, 143),
(50, 148, 127, 106, 112, 112, 112),
(50, 168, 149, 128, 134, 134, 134),
(50, 198, 204, 161, 167, 167, 145),
(50, 137, 101, 124, 124, 84, 123),
(50, 162, 128, 161, 161, 106, 150),
(50, 157, 150, 117, 128, 128, 156),
(50, 172, 167, 134, 145, 145, 172);

INSERT INTO types (type) VALUES
("Planta"), ("Fuego"), ("Agua"), ("Veneno"), ("Dragón"), ("Volador");

INSERT INTO pokentis_types (id_pokenti, id_type) VALUES
(1,1), (1,4), (2,1), (2,4), (3,1), (3,4), (4,2), (5,2), (6,2), 
(6,6), (7,3), (8,3), (9,3),(10,3), (11,3), (12,3), (12,6),(13,3),
(14,3),(15,2),(16,2); 

INSERT INTO evolutions (`level`, evolve_to) VALUES
(16,2),(32,3),(16,5),(36,6),(16,8),(36,9),(30,148),(55,149),(32,117),(40,78);

INSERT INTO pokentis_evolutions (id_pokenti, id_evolution) VALUES
(1,1), (2,2), (3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10); 

INSERT INTO players_pokentis (nickname, in_use, id_stat, id_pokenti) VALUES
("Dino",true,3,3),("Dragoon",false,6,6),("Canon",false,9,9), 
("Patria",true,12,12), ("Rapidin",true,16, 16), ("Caballin",false,13, 13);

INSERT INTO players_pokentis (in_use, id_stat,id_pokenti) VALUES 
(false,2,2), (false,15,15), (true, 10,10), (false,1,1), (false,7,7); 
