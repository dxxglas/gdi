--moderador
CREATE TABLE tb_moderador OF tp_moderador NESTED TABLE contatos STORE AS nt_contatos;
/

--membro
CREATE TABLE tb_membro OF tp_membro(
    nome_de_usuario PRIMARY KEY
);
/

--categoria
CREATE TABLE tb_categoria OF tp_categoria(
    id PRIMARY KEY
);
/

--postagem
CREATE TABLE tb_postagem OF tp_postagem(
    id PRIMARY KEY
);
/

--denuncia
CREATE TABLE tb_denuncia OF tp_denuncia(
    membro SCOPE IS tb_membro,
	postagem WITH ROWID REFERENCES tb_postagem,
	moderador SCOPE IS tb_moderador
);
/

--comentario
CREATE TABLE tb_comentario OF tp_comentario(
	id_postagem SCOPE IS tb_postagem
);
/

--acompanhar
CREATE TABLE tb_acompanhar OF tp_acompanhar(
	moderador SCOPE IS tb_moderador,
	categoria SCOPE IS tb_categoria
);
/

--inscrever
CREATE TABLE tb_inscrever OF tp_inscrever(
	membro SCOPE IS tb_membro,
	categoria SCOPE IS tb_categoria
);
/

--denunciar
CREATE TABLE tb_denunciar OF tp_denunciar(
	membro SCOPE IS tb_membro,
	postagem SCOPE IS tb_postagem
);
/

--publicar
CREATE TABLE tb_publicar OF tp_publicar(
	membro SCOPE IS tb_membro,
	postagem SCOPE IS tb_postagem,
	categoria SCOPE IS tb_categoria
);
/

--comentar
CREATE TABLE tb_comentar OF tp_comentar(
	postagem SCOPE IS tb_postagem,
    membro SCOPE IS tb_membro,
	comentario SCOPE IS tb_comentario
);
/