-- RECORD
-- Declaração de usuario em PL/SQL

DECLARE
TYPE usuario IS RECORD
(
    nome_de_usuario     VARCHAR2(8) NOT NULL := 'ruyzinho',
    nome                VARCHAR2(30) NOT NULL := 'Ruy Barbosa',
    data_nascimento     DATE NOT NULL := to_date('31/08/1995', 'dd/mm/yyyy')
);

usuario_ruy usuario;

BEGIN
    DBMS_OUTPUT.PUT_LINE('usuario_user:             ' || usuario_ruy.nome_de_usuario);
    DBMS_OUTPUT.PUT_LINE('usuario_nome:             ' || usuario_ruy.nome);
    DBMS_OUTPUT.PUT_LINE('usuario_data_nascimento:  ' || usuario_ruy.data_nascimento);
END;
/

-- BLOCO ANONIMO
-- Função de retorno do nome de usuário a partir de postagem

DECLARE
    v_user_postagem     VARCHAR2(8);
    v_post_id           VARCHAR(5) := '00001';

BEGIN
    SELECT P.membro INTO v_user_postagem
    FROM postagem P
    WHERE P.id = v_post_id;

    DBMS_OUTPUT.PUT_LINE('post:     ' || v_post_id);
    DBMS_OUTPUT.PUT_LINE('usuario:  ' || v_user_postagem);
END;
/

-- PROCEDURE
-- Listar comentários de uma postagem

DROP PROCEDURE comentarios_postagem;

CREATE OR REPLACE PROCEDURE comentarios_postagem(post IN VARCHAR2)
IS
    descricao VARCHAR2(240);
    CURSOR postagens
    IS
        SELECT descricao FROM comentario
        WHERE id_postagem = post;
BEGIN
    OPEN postagens;
    FETCH postagens INTO descricao;
    WHILE postagens%FOUND
    LOOP
        DBMS_OUTPUT.PUT_LINE('comentario:' || descricao);
        FETCH postagens INTO descricao;
    END LOOP;
    CLOSE postagens;
END;
/

BEGIN
    comentarios_postagem('00013');
END;
/

-- USO DE ESTRUTURA DE DADOS DO TIPO TABLE
-- Copiar os nomes de usuários moderadores para a moderador_tab criada

DECLARE 
   CURSOR m_moderadores is SELECT nome_de_usuario_m FROM moderador; 

   TYPE moderador_tab IS TABLE of moderador.nome_de_usuario_m%TYPE INDEX BY BINARY_INTEGER; 
   moderadores moderador_tab; 
   j integer := 0; 
BEGIN 
   FOR i IN m_moderadores LOOP 
      j := j + 1; 
      moderadores (j) := i.nome_de_usuario_m; 
      dbms_output.put_line('Nome de Usuário '||j||' : '||moderadores(j)); 
   END LOOP; 
END; 
/ 

-- CREATE FUNCTION & CASE...WHEN
-- Aumentar nivel de um membro

CREATE OR REPLACE FUNCTION aumentar_nivel(usuario IN VARCHAR2)
RETURN NUMBER
IS
    nivel NUMBER;
    
    CURSOR c_usuario
    IS
        SELECT nivel
        FROM membro
        WHERE nome_de_usuario_m = usuario;

BEGIN
    OPEN c_usuario;
    FETCH c_usuario INTO nivel;

    CASE
        WHEN nivel > 50 THEN
            nivel := nivel * 1.2;
        ELSE
            nivel := nivel * 1.1;
    END CASE;
    
    CLOSE c_usuario;

    RETURN nivel;
END;
/

DECLARE
    v_user VARCHAR2(8) := 'grogu';
    v_nivel NUMBER;
BEGIN
    v_nivel := aumentar_nivel(v_user);
    
    UPDATE membro
    SET nivel = v_nivel
    WHERE nome_de_usuario_m = v_user;
END;
/

-- EXCEPTION
-- Consulta de categorias por ID

DECLARE 
v_categoria		categoria%ROWTYPE;
    	v_numero        NUMBER := 4;
BEGIN
	SELECT *
	INTO v_categoria
	FROM categoria
    	WHERE id = v_numero;
	
    	DBMS_OUTPUT.PUT_LINE('Título: ' || v_categoria.titulo);
	    DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_categoria.descricao);
	
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('Essa categoria não existe');
END;
/

--%ROWTYPE
--copia a linha inteira selecionada da tabela membro para m_membro

DECLARE 
  m_membro membro%ROWTYPE; 
  
BEGIN

   SELECT * INTO m_membro FROM membro
    WHERE nome_de_usuario_m = 'grogu';
    
    DBMS_OUTPUT.PUT_LINE(m_membro.nome_de_usuario_m);
    DBMS_OUTPUT.PUT_LINE(m_membro.nivel);
    
END; 
/

-- LOOP EXIT WHEN
-- Lista de postagens por categoria

DROP PROCEDURE postagens_categoria;

CREATE OR REPLACE PROCEDURE postagens_categoria(n_cat IN NUMBER)
IS
    titulo_post VARCHAR2(50);
    CURSOR c_postagens
    IS
        SELECT titulo FROM postagem
        INNER JOIN publicar
        ON id = postagem
        WHERE categoria = n_cat
        AND exclusao <> 1;
BEGIN
    OPEN c_postagens;
    LOOP
    FETCH c_postagens INTO titulo_post;
    EXIT WHEN c_postagens%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('Título: ' || titulo_post);
    
    END LOOP;
    
    CLOSE c_postagens;
END;
/
BEGIN
    postagens_categoria(3);
END;
/

--CREATE OR REPLACE TRIGGER (LINHA)
--cria um trigger para cada vez que um membro aumenta de nivel 
CREATE OR REPLACE TRIGGER display_level_changes 
BEFORE UPDATE ON membro 
FOR EACH ROW 
WHEN (NEW.nivel > 0) 
DECLARE 
   new_level NUMBER; 
BEGIN
    new_level := :NEW.nivel;
    dbms_output.put_line('Novo nível atingido: ' || :NEW.nivel); 
END; 
/ 
