-- 1.
DELIMITER //
CREATE FUNCTION total_livros_por_genero(nome_genero VARCHAR(255)) RETURNS INT DETERMINISTIC
    BEGIN
        DECLARE total INT;
        DECLARE genero_id INT;
        
        SELECT id INTO genero_id FROM Genero WHERE nome_genero = nome_genero;
        SELECT COUNT(*) INTO total FROM Livro WHERE id_genero = genero_id;
        
        RETURN total;
    END //
DELIMITER ;

-- 2.
DELIMITER //
CREATE FUNCTION listar_livros_por_autor(primeiro_nome VARCHAR(255), ultimo_nome VARCHAR(255)) RETURNS TEXT
    BEGIN
        DECLARE lista_livros TEXT;
        DECLARE autor_id INT;
        
        SELECT id INTO autor_id FROM Autor WHERE primeiro_nome = primeiro_nome AND ultimo_nome = ultimo_nome;
        
        SELECT GROUP_CONCAT(titulo) INTO lista_livros 
        FROM Livro 
        WHERE id IN (SELECT id_livro FROM Livro_Autor WHERE id_autor = autor_id);
        
        RETURN lista_livros;
    END //
DELIMITER ;

-- 3.
DELIMITER //
CREATE FUNCTION atualizar_resumos() RETURNS TEXT
    BEGIN
        DECLARE done INT DEFAULT 0;
        DECLARE livro_id INT;
        DECLARE novo_resumo TEXT;
        DECLARE curs CURSOR FOR SELECT id FROM Livro;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        OPEN curs;
        repeticao: LOOP
            FETCH curs INTO livro_id;
            IF done THEN
                LEAVE repeticao;
            END IF;
            SET novo_resumo = CONCAT(resumo, ' Este é um excelente livro!');
            UPDATE Livro SET resumo = novo_resumo WHERE id = livro_id;
        END LOOP;

        CLOSE curs;
    END //
DELIMITER ;

-- 4.
DELIMITER //
CREATE FUNCTION media_livros_por_editora() RETURNS FLOAT
    BEGIN
        DECLARE total_editoras INT;
        DECLARE total_livros INT;
        DECLARE media FLOAT;
        
        SELECT COUNT(*) INTO total_editoras FROM Editora;
        SELECT COUNT(*) INTO total_livros FROM Livro;
        
        SET media = total_livros / total_editoras;
        
        RETURN media;
    END //
DELIMITER ;

-- 5.
DELIMITER //
CREATE FUNCTION autores_sem_livros() RETURNS TEXT
    BEGIN
        DECLARE lista_autores TEXT;
        
        SELECT GROUP_CONCAT(CONCAT(primeiro_nome, ' ', ultimo_nome)) 
        INTO lista_autores
        FROM Autor 
        WHERE id NOT IN (SELECT id_autor FROM Livro_Autor);
        
        RETURN lista_autores;
    END //
DELIMITER ;
