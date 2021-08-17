--membro

INSERT INTO tb_membro VALUES (
    tp_membro(
        'ruyzinho', 
        'Ruy Barbosa', 
        to_date('31/08/1995', 'dd/mm/yyyy'), 
        varray_email(tp_email('ruy_b@gmail.com')),
        'ruyzinho@forum.com',
        27
    )
); 
/

INSERT INTO tb_membro VALUES ( 
    tp_membro(
        'bruno25', 
        'Bruno Gomes', 
        to_date('09/03/1999', 'dd/mm/yyyy'), 
        varray_email(tp_email('brunogomes@gmail.com')),
        'bruno25@forum.com',
        16 
    )
); 
/

INSERT INTO tb_membro VALUES (
    tp_membro(
        'leticiaV', 
        'Letícia Vieira', 
        to_date('21/12/2002', 'dd/mm/yyyy'), 
        varray_email(tp_email('leticiav@gmail.com')), 
        'leticiaV@forum.com',
        52 
    )
); 
/

INSERT INTO tb_membro VALUES (
    tp_membro(
        'grogu', 
        'Hugo Brandão',
        to_date('16/05/2001', 'dd/mm/yyyy'),
        varray_email(tp_email('hugob10@gmail.com')),
        'grogu@forum.com',
        78 
    )
); 
/
--moderador

INSERT INTO tb_moderador VALUES (
    tp_moderador(
        'lukass',
        'Lukas Cardoso',
        to_date('05/12/1998', 'dd/mm/yyyy'),
        varray_email(tp_email('luke98@gmail.com')),
        'lukass@forum.com',
        1500,
        tp_contatos(tp_email('c_um@forum.com'))
    )
); 
/

INSERT INTO tb_moderador VALUES (
    tp_moderador( 
        'gator7',
        'Maria Luiza',
        to_date('15/07/2000', 'dd/mm/yyyy'),
        varray_email(tp_email('malu7@hotmail.com')),
        'gator7@forum.com',
        1800,
        tp_contatos(tp_email('c_dois@forum.com'))
    )
); 
/

INSERT INTO tb_moderador VALUES (
    tp_moderador(
        'cacto',
        'Juliette Freire',
        to_date('03/12/1989', 'dd/mm/yyyy'),
        varray_email(tp_email('jujuf@gmail.com')),
        'cacto@forum.com',
        2100,
        tp_contatos(tp_email('c_tres@forum.com'))
    )
);
/

--categoria

INSERT INTO tb_categoria VALUES (
    1, 'Cactos', 'Dúvidas sobre o cultivo de espécies de cactos' 
); 
/

INSERT INTO tb_categoria VALUES ( 
    2, 'Sonhos', 'Histórias sobre todos os tipos de sonhos' 
); 
/

INSERT INTO tb_categoria VALUES ( 
    3, 'Gatos', 'Gatinhos fofinhos para alegrar seu dia'
);
/

--postagem

INSERT INTO tb_postagem VALUES ( 
    '00001', 
    (
        SELECT  REF(Me)
        FROM tb_membro Me
        WHERE Me.nome_de_usuario = 'bruno25' 
    ), 
    'Mulher se transforma em salsicha', 
    'Uma vez sonhei que estava brigando com uma mulher, na beira da pista, e do nada ela se transformava numa salsicha. Bizarro e engraçado.', 
    (
        SELECT  REF(Me)
        FROM tb_moderador Me
        WHERE Me.nome_de_usuario = '' 
    ), 
    '0' 
); 
/

INSERT INTO tb_postagem VALUES (
    '00012', 
    (
        SELECT  REF(Me)
        FROM tb_membro Me
        WHERE Me.nome_de_usuario = 'leticiaV' 
    ), 
    'Dicas para cultivar cactos', 
    'Gosto muito de ter plantas em casa, mas nunca tive nenhum cacto, então gostaria de dicas para me ajudar a cultivá-los.', 
    (
        SELECT  REF(Me)
        FROM tb_moderador Me
        WHERE Me.nome_de_usuario = '' 
    ), 
    '0' 
); 
/

INSERT INTO tb_postagem VALUES ( 
    '00013',
    (
        SELECT  REF(Me)
        FROM tb_membro Me
        WHERE Me.nome_de_usuario = 'grogu' 
    ), 
    'Parabéns, Cookie',
    'Meu gato está completando 5 aninhos hoje, então aqui está uma foto do Cookie comendo seu bolo de aniversário :)',
    (
        SELECT  REF(Me)
        FROM tb_moderador Me
        WHERE Me.nome_de_usuario = '' 
    ),
    '0'
); 
/

INSERT INTO tb_postagem VALUES (
    '00014',
    (
        SELECT  REF(Me)
        FROM tb_membro Me
        WHERE Me.nome_de_usuario = 'grogu' 
    ), 
    'Vídeo engraçado',
    'Olhem esse vídeo de gatinho!!! youtube.com/video-gatinho', 
    (
        SELECT  REF(Me)
        FROM tb_moderador Me
        WHERE Me.nome_de_usuario = 'gator7' 
    ), 
    '1' 
);
/

INSERT INTO tb_postagem VALUES (
    '00015', 
    (
        SELECT  REF(Me)
        FROM tb_membro Me
        WHERE Me.nome_de_usuario = 'ruyzinho' 
    ), 
    'Problema com pelos',
    'Meu gato tem soltado vários pelos ultimamente, vocês tem ideia o que pode estar acontecendo?',
    (
        SELECT  REF(Me)
        FROM tb_moderador Me
        WHERE Me.nome_de_usuario = '' 
    ), 
    '0' 
); 
/

--denuncia

INSERT INTO tb_denuncia VALUES (
    tp_denuncia ( 
        (
            SELECT  REF(Me)
            FROM tb_membro Me
            WHERE Me.nome_de_usuario = 'ruyzinho' 
        ), 
        (
            SELECT  REF(P)
            FROM tb_postagem P
            WHERE P.id = '00014' 
        ), 
        (
            SELECT  REF(Mo)
            FROM tb_moderador Mo
            WHERE Mo.nome_de_usuario = 'gator7' 
        ) 
    ) 
); 
/ 

--comentario
INSERT INTO tb_comentario VALUES (
	'Estranho',
    (	
        SELECT REF(P) FROM tb_postagem P
        WHERE P.id = '00001'
    ), 
    'Que sonho estranho!',
    2
);
/

INSERT INTO tb_comentario VALUES (
	'Significado',
(	SELECT REF(P) FROM tb_postagem P
WHERE P.id = '00001'
), 
'Será que tem algum significado?',
1
);
/

INSERT INTO tb_comentario VALUES (
	'Parabéns',
(	SELECT REF(P) FROM tb_postagem P
WHERE P.id = '00013'
), 
'Parabéns para ele!!',
3
);
/

INSERT INTO tb_comentario VALUES (
	'Legal',
(	SELECT REF(P) FROM tb_postagem P
WHERE P.id = '00013'
), 
'Que legal!!!',
1
);
/

--acompanhar
INSERT INTO tb_acompanhar VALUES (
	(	SELECT REF(M) FROM tb_moderador M 
WHERE M.nome_de_usuario = 'cacto'
), 
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 1
)
);
/

INSERT INTO tb_acompanhar VALUES (
	(	SELECT REF(M) FROM tb_moderador M 
WHERE M.nome_de_usuario = 'lukass'
), 
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 2
)
);
/

INSERT INTO tb_acompanhar VALUES (
	(	SELECT REF(M) FROM tb_moderador M 
WHERE M.nome_de_usuario = 'gator7'
), 
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 3
)
);
/

--inscrever
INSERT INTO tb_inscrever VALUES (	
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'leticiaV'
), 
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 1
)
);
/

INSERT INTO tb_inscrever VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'bruno25'
), 
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 2
)
);
/

INSERT INTO tb_inscrever VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'grogu'
), 
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 3
)
);
/

INSERT INTO tb_inscrever VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'ruyzinho'
), 
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 3
)
);
/

--denunciar
INSERT INTO tb_denunciar VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'ruyzinho'
), 
(	SELECT REF(P) FROM tb_postagem P 
WHERE P.id = '00014'
),
to_date('15/07/2021', 'dd/mm/yyyy')
);
/

--publicar
INSERT INTO tb_publicar VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'bruno25'
), 
(	SELECT REF(P) FROM tb_postagem P 
WHERE P.id = '00001'
),
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 2
),
to_date('11/02/2021', 'dd/mm/yyyy')
);
/

INSERT INTO tb_publicar VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'leticiaV'
), 
(	SELECT REF(P) FROM tb_postagem P 
WHERE P.id = '00012'
),
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 1
),
to_date('15/06/2021', 'dd/mm/yyyy')
);
/

INSERT INTO tb_publicar VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'grogu'
), 
(	SELECT REF(P) FROM tb_postagem P 
WHERE P.id = '00013'
),
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 3
), 
to_date('08/07/2021', 'dd/mm/yyyy')
);
/

INSERT INTO tb_publicar VALUES (
	(	SELECT REF(M) FROM tb_membro M 
WHERE M.nome_de_usuario = 'grogu'
), 
(	SELECT REF(P) FROM tb_postagem P 
WHERE P.id = '00014'
),
(	SELECT REF(C) FROM tb_categoria C 
WHERE C.id = 3
),
	to_date('12/07/2021', 'dd/mm/yyyy')
);
/

INSERT INTO tb_publicar VALUES (
	(	
        SELECT REF(M) FROM tb_membro M 
        WHERE M.nome_de_usuario = 'ruyzinho'
    ), 
    (	
        SELECT REF(P) FROM tb_postagem P 
        WHERE P.id = '00015'
    ),
    (	
        SELECT REF(C) FROM tb_categoria C 
        WHERE C.id = 3
    ),
	to_date('01/01/2021', 'dd/mm/yyyy')
);
/

--comentar
INSERT INTO tb_comentar VALUES (
	(
	    SELECT REF(P) FROM tb_postagem P WHERE P.id = '00013'
    ),
    (	
        SELECT REF(M) FROM tb_membro M WHERE M.nome_de_usuario = 'ruyzinho'
    ),
    (	
        SELECT REF(C) FROM tb_comentario C WHERE (C.id_postagem).id = '00013' AND C.titulo = 'Legal'
    ),
	to_date('09/07/2021', 'dd/mm/yyyy')
);
/