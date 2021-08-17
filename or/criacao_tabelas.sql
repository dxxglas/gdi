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