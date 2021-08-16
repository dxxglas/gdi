--membro

INSERT INTO tb_membro VALUES (
    tp_membro(
        tp_usuario(
            'ruyzinho', 
            'Ruy Barbosa', 
            to_date('31/08/1995', 'dd/mm/yyyy'), 
            varray_email(tp_email('ruy_b@gmail.com')) 
            ), 
        27
    )
); 
/

INSERT INTO tb_membro VALUES ( tp_usuario( 'bruno25', 'Bruno Gomes', to_date('09/03/1999', 'dd/mm/yyyy'), varray_email(tp_email('brunogomes@gmail.com')) ), 16 ); /

INSERT INTO tb_membro VALUES ( tp_usuario( 'leticiaV', 'Letícia Vieira', to_date('21/12/2002', 'dd/mm/yyyy'), varray_email(tp_email('leticiav@gmail.com')) ), 52 ); /

INSERT INTO tb_membro VALUES ( tp_usuario( 'grogu', 'Hugo Brandão', to_date('16/05/2001', 'dd/mm/yyyy'), varray_email(tp_email('hugob10@gmail.com')) ), 78 ); /
--moderador

INSERT INTO tb_moderador VALUES ( tp_usuario( 'lukass', 'Lukas Cardoso', to_date('05/12/1998', 'dd/mm/yyyy'), varray_email(tp_email('luke98@gmail.com')) ), 1500 ); /

INSERT INTO tb_moderador VALUES ( tp_usuario( 'gator7', 'Maria Luiza', to_date('15/07/2000', 'dd/mm/yyyy'), varray_email(tp_email('malu7@hotmail.com')) ), 1800 ); /

INSERT INTO tb_moderador VALUES ( tp_usuario( 'cacto', 'Juliette Freire', to_date('03/12/1989', 'dd/mm/yyyy'), varray_email(tp_email('jujuf@gmail.com')) ), 2100 ); /
--categoria

INSERT INTO tb_categoria VALUES ( 1, 'Cactos', 'Dúvidas sobre o cultivo de espécies de cactos' ); /

INSERT INTO tb_categoria VALUES ( 2, 'Sonhos', 'Histórias sobre todos os tipos de sonhos' ); /

INSERT INTO tb_categoria VALUES ( 3, 'Gatos', 'Gatinhos fofinhos para alegrar seu dia' ); /
--postagem

INSERT INTO tb_postagem VALUES ( '00001', (
SELECT  REF(Me)
FROM tb_membro Me
WHERE Me.nome_de_usuario = 'bruno25' ), 'Mulher se transforma em salsicha', 'Uma vez sonhei que estava brigando com uma mulher, na beira da pista, e do nada ela se transformava numa salsicha. Bizarro e engraçado.', (
SELECT  REF(Me)
FROM tb_moderador Me
WHERE Me.nome_de_usuario = '' ), '0' ); /

INSERT INTO tb_postagem VALUES ( '00012', (
SELECT  REF(Me)
FROM tb_membro Me
WHERE Me.nome_de_usuario = 'leticiaV' ), 'Dicas para cultivar cactos', 'Gosto muito de ter plantas em casa, mas nunca tive nenhum cacto, então gostaria de dicas para me ajudar a cultivá-los.', (
SELECT  REF(Me)
FROM tb_moderador Me
WHERE Me.nome_de_usuario = '' ), '0' ); /

INSERT INTO tb_postagem VALUES ( '00013', (
SELECT  REF(Me)
FROM tb_membro Me
WHERE Me.nome_de_usuario = 'grogu' ), 'Parabéns, Cookie', 'Meu gato está completando 5 aninhos hoje, então aqui está uma foto do Cookie comendo seu bolo de aniversário :)', (
SELECT  REF(Me)
FROM tb_moderador Me
WHERE Me.nome_de_usuario = '' ), '0' ); /

INSERT INTO tb_postagem VALUES ( '00014', (
SELECT  REF(Me)
FROM tb_membro Me
WHERE Me.nome_de_usuario = 'grogu' ), 'Vídeo engraçado', 'Olhem esse vídeo de gatinho!!! youtube.com/video-gatinho', (
SELECT  REF(Me)
FROM tb_moderador Me
WHERE Me.nome_de_usuario = 'gator7' ), '1' ); /

INSERT INTO tb_postagem VALUES ( '00015', (
SELECT  REF(Me)
FROM tb_membro Me
WHERE Me.nome_de_usuario = 'ruyzinho' ), 'Problema com pelos', 'Meu gato tem soltado vários pelos ultimamente, vocês tem ideia o que pode estar acontecendo?', (
SELECT  REF(Me)
FROM tb_moderador Me
WHERE Me.nome_de_usuario = '' ), '0' ); /
--denuncia

INSERT INTO tb_denuncia VALUES ( tp_denuncia ( (
SELECT  REF(Me)
FROM tb_membro Me
WHERE Me.nome_de_usuario = 'ruyzinho' ), (
SELECT  REF(P)
FROM tb_postagem P
WHERE P.id = '00014' ), (
SELECT  REF(Mo)
FROM tb_moderador Mo
WHERE Mo.nome_de_usuario = 'gator7' ) ) ); / 