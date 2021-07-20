-- #1 - Mapeamento e moderação de denuncias

-- ALTER TABLE
-- Adiciona checagem na tabela denunciar
ALTER TABLE denunciar
    ADD checagem CHAR(1);

-- CREATE INDEX
-- Criacao de indice para checar denuncia
DROP INDEX m_denuncia;

CREATE INDEX m_denuncia
    ON moderar_denuncia (membro, postagem);

-- SUBCONSULTA IN
-- Atualiza a checagem para 1 se a postagem estiver excluída
-- e houver correspondência entre denuncia e moderar_denuncia
UPDATE denunciar
    SET checagem = 1
    WHERE postagem IN (
        SELECT p.id FROM postagem p
        WHERE p.exclusao = 1
    )
    AND postagem IN (
        SELECT m.postagem FROM moderar_denuncia m
        WHERE m.membro = membro
    );

-- UPDATE
UPDATE denunciar
    SET checagem = 0
    WHERE checagem IS NULL;

-- DELETE
-- Deleta registros de denuncia
DELETE FROM denunciar
    WHERE checagem = 1;

-- INSERT INTO
-- Adicionar na tabela de moderar
INSERT INTO moderar(postagem, categoria, moderador) 
SELECT d.postagem, p.categoria, a.moderador FROM 
    (
        SELECT postagem FROM denunciar
        INTERSECT
        SELECT id FROM postagem
        WHERE exclusao <> 1
    ) d

    INNER JOIN publicar p
    ON d.postagem = p.postagem

    INNER JOIN acompanhar a
    ON p.categoria = a.categoria;
    
-- #2 - Estatística das categorias

-- FULL OUTER JOIN
-- Quantidade de comentarios por categoria
DROP VIEW qtd_comentario_postagem;

CREATE VIEW qtd_comentario_postagem AS
SELECT COUNT(c.id) as COMENTARIOS, pc.categoria FROM comentario c
    FULL OUTER JOIN postagem p
    ON c.id_postagem = p.id

    INNER JOIN publicar pc
    ON p.id = pc.postagem

    WHERE p.exclusao = 0

    GROUP BY pc.categoria
    ORDER BY pc.categoria;

-- COUNT
-- Quantidade de curtidas em postagem por categoria
DROP VIEW qtd_curtida_postagem;

CREATE VIEW qtd_curtida_postagem AS
SELECT COUNT(c.postagem) AS CURTIDAS, p.categoria FROM curtir_postagem c

    FULL OUTER JOIN publicar p
    ON p.postagem = c.postagem

    GROUP BY p.categoria
    ORDER BY p.categoria;

-- AVG
-- Media de usuarios por categoria
SELECT ROUND(AVG(membro)) AS MEDIA_MEMBRO FROM 
    (
        SELECT COUNT(*) AS membro, categoria FROM inscrever
        GROUP BY categoria
    ) membro_por_categoria;

-- GROUP BY
-- Categoria com menos interações
DROP VIEW interacoes_categoria;
CREATE VIEW interacoes_categoria AS
SELECT c.categoria, SUM(a.comentarios + c.curtidas) AS interacoes FROM qtd_curtida_postagem c
    INNER JOIN qtd_comentario_postagem a
    ON c.categoria = a.categoria
    GROUP BY c.categoria;

-- MIN    
SELECT c.id, c.titulo, c.descricao, interacoes FROM interacoes_categoria
    INNER JOIN categoria c
    ON categoria = c.id
    WHERE interacoes = (SELECT MIN(interacoes) FROM interacoes_categoria);

-- INNER JOIN
-- Feed da categoria com menos interacoes    
SELECT o.titulo, o.conteudo, o.membro FROM interacoes_categoria i
    INNER JOIN publicar p
    ON i.categoria = p.categoria
    
    INNER JOIN postagem o
    ON p.postagem = o.id
    
    WHERE i.interacoes = (SELECT MIN(interacoes) FROM interacoes_categoria);

-- UNION
-- Interações por dia da semana
SELECT COUNT(*) AS interacoes, to_char(data, 'DAY') AS dia_semana 
    FROM (SELECT * FROM data_comentario
    UNION
    SELECT * FROM data_publicacao) total_interacoes

    GROUP BY to_char(data, 'DAY')
    ORDER BY interacoes DESC;


-- #3 - Filtro de publicações

-- BETWEEN
-- Publicações em um período específico
SELECT d.data, a.titulo, a.conteudo, a.membro FROM publicar p
    FULL OUTER JOIN data_publicacao d
    ON p.postagem = d.postagem

    INNER JOIN postagem a
    ON p.postagem = a.id

    WHERE d.data BETWEEN '01/06/2021' AND '01/08/2021'
    AND a.exclusao <> 1;

-- LIKE
-- Busca em publicações
SELECT d.data, a.titulo, a.conteudo, a.membro FROM publicar p
    FULL OUTER JOIN data_publicacao d
    ON p.postagem = d.postagem

    INNER JOIN postagem a
    ON p.postagem = a.id

    WHERE (
    a.titulo LIKE '%gato%'
    OR a.conteudo LIKE '%gato%')
    AND a.exclusao <> 1;

-- IN
-- Publicações de um usuário
SELECT d.data, a.titulo, a.conteudo, a.membro FROM publicar p
    FULL OUTER JOIN data_publicacao d
    ON p.postagem = d.postagem

    INNER JOIN postagem a
    ON p.postagem = a.id

    WHERE a.exclusao <> 1
    AND a.membro IN ('grogu');

-- ANY
-- Feed de um membro
SELECT * FROM publicar p
    INNER JOIN postagem
    ON p.postagem = id

    WHERE exclusao <> 1
    AND p.categoria = ANY (
        SELECT categoria FROM inscrever
        WHERE membro = 'comments'
        );

-- #4 - Informações dos membros

-- CREATE VIEW
-- Usuario em mais categorias
DROP VIEW categoria_por_membro;

CREATE VIEW categoria_por_membro AS
    SELECT membro, COUNT(categoria) AS categorias from inscrever
    GROUP BY membro;

-- SUBCONSULTA COM OPERADOR
SELECT * FROM categoria_por_membro
    WHERE categorias = (SELECT MAX(categorias) from categoria_por_membro);

-- SELECT-FROM-WHERE
-- Contas de email dos aniversariantes do mes
SELECT e.conta FROM usuario u
    FULL OUTER JOIN email e
    ON u.nome_de_usuario = e.nome_de_usuario_m

    WHERE extract(month from data_nascimento) = extract(month from sysdate);

-- IS NULL
-- Usuarios que não em conta GMAIL associada
SELECT * FROM usuario u
    FULL OUTER JOIN (SELECT * FROM email WHERE conta LIKE '%gmail%') e
    ON u.nome_de_usuario = e.nome_de_usuario_m
    
    WHERE e.conta IS NULL;

-- MAX
-- Comentarios do usuário com maior nível
SELECT descricao FROM comentar
    INNER JOIN comentario
    ON comentario = id

    WHERE membro = (
        SELECT nome_de_usuario FROM usuario
        INNER JOIN membro
        ON nome_de_usuario = nome_de_usuario_m

        WHERE nivel = (SELECT MAX(nivel) FROM membro)
);

-- #5 - Mapeamento de Postagens

-- ORDER BY
-- Tabela de Postagens + Comentários
SELECT p.id, p.membro, p.titulo, p.conteudo, pbd.data, cd.id, cd.descricao, cd.data FROM postagem p
    INNER JOIN (
        SELECT pb.postagem, data, membro FROM publicar pb
        INNER JOIN data_publicacao d
        ON pb.postagem = d.postagem
    ) pbd
    ON p.id = pbd.postagem

    LEFT JOIN (
        SELECT * FROM comentario c
        INNER JOIN data_comentario d
        ON c.id = d.comentario
    ) cd
    ON p.id = cd.id_postagem

    WHERE p.exclusao <> 1

    ORDER BY pbd.data, cd.data;

-- ALL
-- Categoria com mais pessoas inscritas que a média
SELECT categoria, titulo FROM inscrever

INNER JOIN categoria
ON categoria = id

GROUP BY categoria, titulo
HAVING COUNT(membro) > ALL (
    SELECT ROUND(AVG(COUNT(membro))) FROM inscrever
    GROUP BY categoria
);

-- HAVING
-- Comentarios com pelo menos uma curtida
SELECT c.descricao, COUNT(membro) FROM comentario c
    FULL OUTER JOIN curtir_comentario
    ON c.id = comentario

    GROUP BY c.id, c.descricao
    HAVING COUNT(membro) > 0;

-- GRANT
GRANT SELECT ON usuario TO ANONYMOUS;

REVOKE SELECT ON usuario FROM ANONYMOUS;