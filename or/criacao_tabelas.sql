--moderador
CREATE TABLE tb_moderador OF tp_moderador(
    nome_de_usuario PRIMARY KEY
);
/

--membro
CREATE TABLE tb_membro OF tp_membro(
    nome_de_usuario PRIMARY KEY
);
/

CREATE tb_membro OF tp_membro NESTED TABLE emails STORE AS nt_emails;

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
    membro SCOPE IS tp_membro,
	postagem WITH ROWID REFERENCES tp_postagem,
	moderador SCOPE IS tp_moderador
);
/