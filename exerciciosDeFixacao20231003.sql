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
