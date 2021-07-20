-- DROP TABLES
DROP TABLE comentar;
DROP TABLE data_comentario;
DROP TABLE publicar;
DROP TABLE data_publicacao;
DROP TABLE moderar_denuncia;
DROP TABLE moderar;
DROP TABLE curtir_postagem;
DROP TABLE curtir_comentario;
DROP TABLE reportar;
DROP TABLE denunciar;
DROP TABLE inscrever;
DROP TABLE acompanhar;
DROP TABLE comentario;
DROP TABLE postagem;
DROP TABLE categoria;
DROP SEQUENCE c_id;
DROP TABLE membro;
DROP TABLE moderador;
DROP TABLE email;
DROP TABLE usuario;

-- CREATE TABLES
CREATE TABLE usuario(
	nome_de_usuario VARCHAR2(8) NOT NULL,
	nome VARCHAR2(30) NOT NULL,
   	data_nascimento DATE NOT NULL,
	CONSTRAINT usuario_pk PRIMARY KEY (nome_de_usuario)
);

CREATE TABLE email(
	nome_de_usuario_m VARCHAR2(8),
	conta VARCHAR2(20),
    CONSTRAINT email_pk PRIMARY KEY (conta),
    CONSTRAINT email_fk FOREIGN KEY (nome_de_usuario_m) REFERENCES usuario (nome_de_usuario) 	
);

CREATE TABLE moderador(
	nome_de_usuario_m VARCHAR2(8),
	salario NUMBER,
	CONSTRAINT moderador_pk PRIMARY KEY (nome_de_usuario_m),
    CONSTRAINT moderador_fk FOREIGN KEY (nome_de_usuario_m) REFERENCES usuario (nome_de_usuario),
    CONSTRAINT moderador_ck CHECK (salario > 1100)
);

CREATE TABLE membro(
	nome_de_usuario_m VARCHAR2(8),
	nivel NUMBER,
	CONSTRAINT membro_pk PRIMARY KEY (nome_de_usuario_m),
    CONSTRAINT membro_fk FOREIGN KEY (nome_de_usuario_m) REFERENCES usuario (nome_de_usuario)
);

CREATE SEQUENCE c_id START WITH 1 INCREMENT BY 1;

CREATE TABLE categoria(
	id NUMBER DEFAULT c_id.NEXTVAL,
	titulo VARCHAR2(20),
	descricao VARCHAR2(240),
	CONSTRAINT categoria_pk PRIMARY KEY (id)
);

CREATE TABLE postagem(
	id VARCHAR2(5),
	membro VARCHAR2(8),
	titulo VARCHAR2(50),
	conteudo VARCHAR2(350),
	exclusao CHAR(1) NOT NULL,
	CONSTRAINT postagem_pk PRIMARY KEY (id),
    CONSTRAINT postagem_fk FOREIGN KEY (membro) REFERENCES membro(nome_de_usuario_m)
);

CREATE TABLE comentario(
	id VARCHAR2(5),
	id_postagem VARCHAR2(8),
	descricao VARCHAR2(240),
	CONSTRAINT comentario_pk PRIMARY KEY (id),
    CONSTRAINT comentario_fk FOREIGN KEY (id_postagem) REFERENCES postagem(id)
);

CREATE TABLE acompanhar(
	moderador VARCHAR2(8),
	categoria NUMBER,
	CONSTRAINT acompanhar_pk PRIMARY KEY (moderador, categoria),
    CONSTRAINT acompanhar_moderador_fk FOREIGN KEY (moderador) REFERENCES moderador(nome_de_usuario_m),
    CONSTRAINT acompanhar_categoria_fk FOREIGN KEY (categoria) REFERENCES categoria(id)
);

CREATE TABLE inscrever(
	membro VARCHAR2(8),
	categoria NUMBER,
	CONSTRAINT inscrever_pk PRIMARY KEY (membro, categoria),
    CONSTRAINT inscrever_membro_fk FOREIGN KEY (membro) REFERENCES membro (nome_de_usuario_m),
    CONSTRAINT inscrever_categoria_fk FOREIGN KEY (categoria) REFERENCES categoria(id)
);

CREATE TABLE denunciar(
	membro VARCHAR2(8),
	postagem VARCHAR2(5),
	data DATE NOT NULL,
	CONSTRAINT denunciar_pk PRIMARY KEY (membro, postagem),
    CONSTRAINT denunciar_membro_fk FOREIGN KEY (membro) REFERENCES membro (nome_de_usuario_m),
    CONSTRAINT denunciar_postagem_fk FOREIGN KEY (postagem) REFERENCES postagem(id)
);

CREATE TABLE reportar(
	membro_denunciado VARCHAR2(8),
	membro_denunciante VARCHAR2(8),
    CONSTRAINT reportar_pk PRIMARY KEY (membro_denunciado, membro_denunciante),
    CONSTRAINT reportar_denunciado_fk FOREIGN KEY (membro_denunciado) REFERENCES membro(nome_de_usuario_m),
    CONSTRAINT reportar_denunciante_fk FOREIGN KEY (membro_denunciante) REFERENCES membro(nome_de_usuario_m)
);

CREATE TABLE curtir_comentario(
	membro VARCHAR2(8),
	comentario VARCHAR2(5),
	CONSTRAINT curtir_comentario_pk PRIMARY KEY (membro, comentario),
    CONSTRAINT curtir_comentario_membro_fk FOREIGN KEY (membro) REFERENCES membro (nome_de_usuario_m),
    CONSTRAINT curtir_comentario_comentario_fk FOREIGN KEY (comentario) REFERENCES comentario(id)
);

CREATE TABLE curtir_postagem(
	membro VARCHAR2(8),
	postagem VARCHAR2(5),
	CONSTRAINT curtir_postagem_pk PRIMARY KEY (membro, postagem),
    CONSTRAINT curtir_postagem_membro_fk FOREIGN KEY (membro) REFERENCES membro (nome_de_usuario_m),
    CONSTRAINT curtir_postagem_postagem_fk FOREIGN KEY (postagem) REFERENCES postagem(id)
);

CREATE TABLE moderar(
	postagem VARCHAR2(5),
	categoria NUMBER,
	moderador VARCHAR2(8),
    CONSTRAINT moderar_pk PRIMARY KEY (postagem, categoria, moderador),
    CONSTRAINT moderar_postagem_fk FOREIGN KEY (postagem) REFERENCES postagem(id),
    CONSTRAINT moderar_categoria_fk FOREIGN KEY (categoria) REFERENCES categoria(id),
    CONSTRAINT moderar_moderador_fk FOREIGN KEY (moderador) REFERENCES moderador(nome_de_usuario_m)
);

CREATE TABLE moderar_denuncia(
    membro VARCHAR2(8),
	postagem VARCHAR2(5),
	categoria NUMBER,
	moderador VARCHAR2(8),
    CONSTRAINT moderar_denuncia_pk PRIMARY KEY (membro, postagem, categoria, moderador),
    CONSTRAINT moderar_denuncia_membro_fk FOREIGN KEY (membro) REFERENCES membro(nome_de_usuario_m),
    CONSTRAINT moderar_denuncia_postagem_fk FOREIGN KEY (postagem) REFERENCES postagem(id),
    CONSTRAINT moderar_denuncia_categoria_fk FOREIGN KEY (categoria) REFERENCES categoria(id),
    CONSTRAINT moderar_denuncia_moderador_fk FOREIGN KEY (moderador) REFERENCES moderador(nome_de_usuario_m)
);

CREATE TABLE data_publicacao(
	postagem VARCHAR2(5),
    data DATE NOT NULL,
	CONSTRAINT data_publicacao_pk PRIMARY KEY (postagem),
    CONSTRAINT data_publicacao_fk FOREIGN KEY (postagem) REFERENCES postagem(id)
);

CREATE TABLE publicar(
	membro VARCHAR2(8),
	postagem VARCHAR2(5),
	categoria NUMBER,
    CONSTRAINT publicar_membro_pk PRIMARY KEY (membro, postagem, categoria),
    CONSTRAINT publicar_membro_fk FOREIGN KEY (membro) REFERENCES membro (nome_de_usuario_m),
    CONSTRAINT publicar_postagem_fk FOREIGN KEY (postagem) REFERENCES postagem(id),
    CONSTRAINT publicar_categoria_fk FOREIGN KEY (categoria) REFERENCES categoria(id)
);

CREATE TABLE data_comentario(
	comentario VARCHAR2(5),
    data DATE NOT NULL,
	CONSTRAINT data_comentario_pk PRIMARY KEY (comentario),
    CONSTRAINT data_comentario_fk FOREIGN KEY (comentario) REFERENCES comentario(id)
);

CREATE TABLE comentar(
	postagem VARCHAR2(5),
	membro VARCHAR2(8),
	comentario VARCHAR2(5),
	CONSTRAINT comentar_pk PRIMARY KEY (postagem,membro, comentario),
    CONSTRAINT comentar_postagem_fk FOREIGN KEY (postagem) REFERENCES postagem(id),
    CONSTRAINT comentar_membro_fk FOREIGN KEY (membro) REFERENCES membro (nome_de_usuario_m),
    CONSTRAINT comentar_comentario_fk FOREIGN KEY (comentario) REFERENCES comentario(id)
);