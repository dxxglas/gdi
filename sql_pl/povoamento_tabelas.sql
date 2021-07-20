-- POPULATE TABLES

--usuario
INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('ruyzinho', 'Ruy Barbosa', to_date('31/08/1995', 'dd/mm/yyyy'));

INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('bruno25', 'Bruno Gomes', to_date('09/03/1999', 'dd/mm/yyyy'));

INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('gator7', 'Maria Luiza', to_date('15/07/2000', 'dd/mm/yyyy'));

INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('leticiaV', 'Letícia Vieira', to_date('21/12/2002', 'dd/mm/yyyy'));

INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('lukass', 'Lukas Cardoso', to_date('05/12/1998', 'dd/mm/yyyy'));

INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('cacto', 'Juliette Freire', to_date('03/12/1989', 'dd/mm/yyyy'));

INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('grogu', 'Hugo Brandão', to_date('16/05/2001', 'dd/mm/yyyy'));

INSERT INTO usuario (nome_de_usuario, nome, data_nascimento) 
VALUES ('comments', 'Joana Gomes', to_date('10/02/2000', 'dd/mm/yyyy'));


--email
INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('ruyzinho', 'ruy_b@gmail.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('bruno25', 'brunogomes@gmail.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('gator7', 'malu7@hotmail.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('leticiaV', 'leticiav@gmail.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('lukass', 'luke98@gmail.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('cacto', 'jujuf@gmail.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('cacto', 'juliette@globo.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('grogu', 'hugob10@gmail.com');

INSERT INTO email (nome_de_usuario_m , conta) 
            VALUES ('comments', 'joana_g@hotmail.com');

--moderador
INSERT INTO moderador (nome_de_usuario_m , salario) 
            VALUES ('lukass', 1500);

INSERT INTO moderador (nome_de_usuario_m , salario) 
            VALUES ('gator7', 1800);

INSERT INTO moderador (nome_de_usuario_m , salario) 
            VALUES ('cacto', 2100);

--membro
INSERT INTO membro (nome_de_usuario_m , nivel) 
            VALUES ('ruyzinho', 27);

INSERT INTO membro (nome_de_usuario_m , nivel) 
            VALUES ('bruno25', 16);

INSERT INTO membro (nome_de_usuario_m , nivel) 
            VALUES ('leticiaV', 52);

INSERT INTO membro (nome_de_usuario_m , nivel) 
            VALUES ('grogu', 78);

INSERT INTO membro (nome_de_usuario_m , nivel) 
            VALUES ('comments', 99);

--categoria
INSERT INTO categoria (id, titulo, descricao) 
VALUES (c_id.NEXTVAL, 'Cactos', 'Dúvidas sobre o cultivo de espécies de cactos');

INSERT INTO categoria (id, titulo, descricao) 
VALUES (c_id.NEXTVAL, 'Sonhos', 'Histórias sobre todos os tipos de sonhos');

INSERT INTO categoria (id, titulo, descricao) 
VALUES (c_id.NEXTVAL, 'Gatos', 'Gatinhos fofinhos para alegrar seu dia');

--postagem
INSERT INTO postagem (id, membro, titulo, conteudo, exclusao) 
VALUES ('00001', 'bruno25', 'Mulher se transforma em salsicha', 'Uma vez sonhei que estava brigando com uma mulher, na beira da pista, e do nada ela se transformava numa salsicha. Bizarro e engraçado.', 0);

INSERT INTO postagem (id, membro, titulo, conteudo, exclusao) 
VALUES ('00012', 'leticiaV', 'Dicas para cultivar cactos', 'Gosto muito de ter plantas em casa, mas nunca tive nenhum cacto, então gostaria de dicas para me ajudar a cultivá-los.', 0);

INSERT INTO postagem (id, membro, titulo, conteudo, exclusao) 
VALUES ('00013', 'grogu', 'Parabéns, Cookie', 'Meu gato está completando 5 anihnos hoje, então aqui está uma foto do Cookie comendo seu bolo de aniversário :)', 0);

INSERT INTO postagem (id, membro, titulo, conteudo, exclusao) 
VALUES ('00014', 'grogu', 'Vídeo engraçado', 'Olhem esse vídeo de gatinho!!! youtube.com/video-gatinho', 1);

INSERT INTO postagem (id, membro, titulo, conteudo, exclusao) 
VALUES ('00015', 'ruyzinho', 'Problema com pelos', 'Meu gato tem soltado vários pelos ultimamente, vocês tem ideia o que pode estar acontecendo?', 0);

--comentario
INSERT INTO comentario (id, id_postagem, descricao)
VALUES ('20015', '00001', 'Que sonho estranho!');

INSERT INTO comentario (id, id_postagem, descricao)
VALUES ('20016', '00001', 'Será que tem algum significado?');

INSERT INTO comentario (id, id_postagem, descricao)
VALUES ('20020', '00013', 'Parabéns para ele!!');

INSERT INTO comentario (id, id_postagem, descricao)
VALUES ('20021', '00013', 'Que legal!!!');

--acompanhar
INSERT INTO acompanhar (moderador, categoria)
            VALUES ('cacto', 1);

INSERT INTO acompanhar (moderador, categoria)
            VALUES ('lukass', 2);

INSERT INTO acompanhar (moderador, categoria)
            VALUES ('gator7', 3);

--inscrever
INSERT INTO inscrever (membro, categoria)
            VALUES ('leticiaV', 1);

INSERT INTO inscrever (membro, categoria)
            VALUES ('bruno25', 2);

INSERT INTO inscrever (membro, categoria)
            VALUES ('grogu', 3);

INSERT INTO inscrever (membro, categoria)
            VALUES ('ruyzinho', 3);

INSERT INTO inscrever (membro, categoria)
            VALUES ('comments', 1);

INSERT INTO inscrever (membro, categoria)
            VALUES ('comments', 2);

INSERT INTO inscrever (membro, categoria)
            VALUES ('comments', 3);

--denunciar
INSERT INTO denunciar(membro, postagem, data) 
VALUES ('ruyzinho', '00014', to_date('15/07/2021', 'dd/mm/yyyy'));

--reportar
INSERT INTO reportar (membro_denunciado, membro_denunciante)
            VALUES ('grogu', 'ruyzinho');

--curtir_comentario
INSERT INTO curtir_comentario (membro, comentario)
            VALUES ('bruno25', '20015');

INSERT INTO curtir_comentario (membro, comentario)
            VALUES ('grogu', '20020');

INSERT INTO curtir_comentario (membro, comentario)
            VALUES ('grogu', '20021');

--curtir_postagem
INSERT INTO curtir_postagem (membro, postagem)
            VALUES ('ruyzinho','00013');

INSERT INTO curtir_postagem (membro, postagem)
            VALUES ('comments','00013');

INSERT INTO curtir_postagem (membro, postagem)
            VALUES ('comments','00001');


-- moderar
INSERT INTO moderar(postagem, categoria, moderador) VALUES ('00014', 3, 'gator7');

-- moderar_denuncia
INSERT INTO moderar_denuncia(membro, postagem, categoria, moderador) VALUES ('ruyzinho', '00014', 3, 'gator7');

-- data_publicacao
INSERT INTO data_publicacao(postagem, data) 
VALUES ('00001', to_date('11/02/2021', 'dd/mm/yyyy'));

INSERT INTO data_publicacao(postagem, data) 
VALUES ('00012', to_date('15/06/2021', 'dd/mm/yyyy'));

INSERT INTO data_publicacao(postagem, data) 
VALUES ('00013', to_date('08/07/2021', 'dd/mm/yyyy'));

INSERT INTO data_publicacao(postagem, data) 
VALUES ('00014', to_date('12/07/2021', 'dd/mm/yyyy'));

INSERT INTO data_publicacao(postagem, data) 
VALUES ('00015', to_date('01/01/2021', 'dd/mm/yyyy'));


--pulbicar
INSERT INTO publicar (membro, postagem, categoria) 
VALUES ('bruno25', '00001', 2);

INSERT INTO publicar (membro, postagem, categoria) 
VALUES ('leticiaV', '00012', 1);

INSERT INTO publicar (membro, postagem, categoria) 
VALUES ('grogu', '00013', 3);

INSERT INTO publicar (membro, postagem, categoria) 
VALUES ('grogu', '00014', 3);

INSERT INTO publicar (membro, postagem, categoria) 
VALUES ('ruyzinho', '00015', 3);


-- data_comentario
INSERT INTO data_comentario(comentario, data) 
    VALUES ('20015', to_date('11/02/2021', 'dd/mm/yyyy'));

INSERT INTO data_comentario(comentario, data) 
    VALUES ('20016', to_date('11/02/2021', 'dd/mm/yyyy'));

INSERT INTO data_comentario(comentario, data) 
    VALUES ('20020', to_date('08/07/2021', 'dd/mm/yyyy'));

INSERT INTO data_comentario(comentario, data) 
    VALUES ('20021', to_date('09/07/2021', 'dd/mm/yyyy'));


-- comentar
INSERT INTO comentar(postagem, membro, comentario)
VALUES ('00001', 'comments', '20015');

INSERT INTO comentar(postagem, membro, comentario)
VALUES ('00001', 'comments', '20016');

INSERT INTO comentar(postagem, membro, comentario)
VALUES ('00013', 'comments', '20020');

INSERT INTO comentar(postagem, membro, comentario)
VALUES ('00013', 'ruyzinho', '20021');