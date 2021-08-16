DROP TYPE tp_comentar;
DROP TYPE tp_publicar;
DROP TYPE tp_curtir_postagem;
DROP TYPE tp_curtir_comentario;
DROP TYPE tp_reportar;
DROP TYPE tp_denunciar;
DROP TYPE tp_inscrever;
DROP TYPE tp_acompanhar;
DROP TYPE tp_comentario;
DROP TYPE tp_denuncia;
DROP TYPE tp_postagem;
DROP TYPE tp_categoria;
DROP TYPE tp_moderador;
DROP TYPE tp_contatos;
DROP TYPE tp_membro;
DROP TYPE tp_usuario;
DROP TYPE varray_email;
DROP TYPE tp_email;


-- email
CREATE OR REPLACE TYPE tp_email AS OBJECT (
	conta VARCHAR2(20)
);
/

CREATE TYPE varray_email AS VARRAY (2) OF tp_email;
/

-- usuario
CREATE OR REPLACE TYPE tp_usuario AS OBJECT (
	nome_de_usuario VARCHAR2(8),
	nome VARCHAR2(30),
   	data_nascimento DATE,
	emails varray_email,
	MEMBER FUNCTION idade_minima RETURN VARCHAR2
) NOT FINAL NOT INSTANTIABLE;
/

ALTER TYPE tp_usuario ADD ATTRIBUTE (conta VARCHAR2(18)) CASCADE;
/

ALTER TYPE tp_usuario ADD CONSTRUCTOR FUNCTION 
	tp_usuario (
		nome_de_usuario VARCHAR2,
		nome VARCHAR2,
   		data_nascimento DATE,
		emails varray_email,
		conta VARCHAR2
	) RETURN SELF AS RESULT CASCADE;
/

CREATE OR REPLACE TYPE BODY tp_usuario AS
	CONSTRUCTOR FUNCTION tp_usuario (
		nome_de_usuario VARCHAR2,
		nome VARCHAR2,
   		data_nascimento DATE,
		emails varray_email,
		conta VARCHAR2
	) RETURN SELF AS RESULT
		IS 
		BEGIN
			SELF.nome_de_usuario := nome_de_usuario;
			SELF.nome := nome;
			SELF.data_nascimento := data_nascimento;
			SELF.emails := emails;
			SELF.conta := CONCAT(nome_de_usuario, '@forum.com');
			RETURN;
		END;

		MEMBER FUNCTION idade_minima RETURN VARCHAR2 IS
			BEGIN
			IF ((EXTRACT(YEAR from CURRENT_DATE) - EXTRACT(YEAR from data_nascimento)) > 18) THEN
				RETURN 'SIM';
			END IF;
			
			RETURN 'NAO';
		END; 
	
END;
/

-- membro
CREATE OR REPLACE TYPE tp_membro UNDER tp_usuario(
	nivel NUMBER,
	MEMBER FUNCTION nome_nivel RETURN VARCHAR2
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY tp_membro AS
	MEMBER FUNCTION nome_nivel RETURN VARCHAR2 IS
		BEGIN
			IF (nivel > 60) THEN
				RETURN 'ouro';
			ELSIF (nivel > 20) THEN
				RETURN 'prata';
			END IF;

			RETURN 'bronze';
		END;
END;
/

-- moderador
CREATE OR REPLACE TYPE tp_moderador UNDER tp_usuario(
	salario NUMBER,
	MEMBER PROCEDURE mudar_salario(novo_salario NUMBER),
	OVERRIDING MEMBER FUNCTION idade_minima RETURN VARCHAR2
);
/

CREATE TYPE tp_contatos AS TABLE OF tp_email;
/ 

ALTER TYPE tp_moderador ADD ATTRIBUTE (contatos tp_contatos) CASCADE;
/

CREATE OR REPLACE TYPE BODY tp_moderador AS
	MEMBER PROCEDURE mudar_salario (novo_salario NUMBER) IS
		BEGIN
			IF (salario > 1100) THEN
				salario := novo_salario;
			ELSE
				salario := 1100;
			END IF;
		END;

	OVERRIDING MEMBER FUNCTION idade_minima RETURN VARCHAR2 IS
		BEGIN
			IF ((EXTRACT(YEAR from CURRENT_DATE) - EXTRACT(YEAR from data_nascimento)) > 20) THEN
				RETURN 'SIM';
			END IF;
			
			RETURN 'NAO';
		END; 
END;
/

--categoria
CREATE OR REPLACE TYPE tp_categoria AS OBJECT(
	id NUMBER,
	titulo VARCHAR2(20),
	descricao VARCHAR2(240),
	MAP MEMBER FUNCTION categoria_n RETURN VARCHAR
);
/

CREATE OR REPLACE TYPE BODY tp_categoria AS
MAP MEMBER FUNCTION categoria_n RETURN VARCHAR IS
	BEGIN
		RETURN id || titulo;
	END;
END;
/		

--postagem
CREATE OR REPLACE TYPE tp_postagem AS OBJECT(
	id VARCHAR2(5),
	membro REF tp_membro,
	titulo VARCHAR2(50),
	conteudo VARCHAR2(350),
	moderador REF tp_moderador, 
	exclusao CHAR(1)
);
/

--denuncia
CREATE OR REPLACE TYPE tp_denuncia AS OBJECT(
	membro REF tp_membro,
	postagem REF tp_postagem,
	moderador REF tp_moderador
);			
/

--comentario
CREATE OR REPLACE TYPE tp_comentario AS OBJECT(
	titulo VARCHAR2(50),
	id_postagem tp_postagem,
	descricao VARCHAR2(240),
	curtidas NUMBER,
	ORDER MEMBER FUNCTION relevancia(c tp_comentario) RETURN INTEGER
);
/

CREATE OR REPLACE TYPE BODY tp_comentario AS
	ORDER MEMBER FUNCTION relevancia(c tp_comentario) RETURN INTEGER IS
		BEGIN
			IF c.curtidas > SELF.curtidas  THEN
				RETURN 1;
			ELSIF c.curtidas = SELF.curtidas THEN
				RETURN 0;
			ELSE
				RETURN -1;
			END IF;
		END;
END;
/

--acompanhar
CREATE OR REPLACE TYPE tp_acompanhar AS OBJECT(
	moderador REF tp_moderador,
	categoria REF tp_categoria
);
/

--inscrever
CREATE OR REPLACE TYPE tp_inscrever AS OBJECT(
	membro REF tp_membro,
	categoria REF tp_categoria
);
/

--denunciar
CREATE OR REPLACE TYPE tp_denunciar AS OBJECT(
	membro REF tp_membro,
	postagem REF tp_postagem,
	data DATE
) FINAL;
/

--reportar
CREATE OR REPLACE TYPE tp_reportar AS OBJECT(
	membro_denunciado REF tp_membro,
	membro_denunciante REF tp_membro
);
/
ALTER TYPE tp_reportar ADD ATTRIBUTE (data DATE) CASCADE;
/

--curtir comentario
CREATE OR REPLACE TYPE tp_curtir_comentario AS OBJECT(
	membro REF tp_membro,
	comentario REF tp_comentario
);
/

--curtir postagem
CREATE OR REPLACE TYPE tp_curtir_postagem AS OBJECT(
	membro REF tp_membro,
	postagem REF tp_postagem
);
/

--publicar
CREATE OR REPLACE TYPE tp_publicar AS OBJECT(
	membro REF tp_membro,
	postagem REF tp_postagem,
	categoria REF tp_categoria,
	data DATE
);
/

--comentar
CREATE OR REPLACE TYPE tp_comentar AS OBJECT(
	postagem REF tp_postagem,
	membro REF tp_membro,
	comentario REF tp_comentario,
	data DATE
);
/