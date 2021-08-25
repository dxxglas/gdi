-- SELECT DREF
SELECT DISTINCT DEREF (p.membro).nome_de_usuario AS membro FROM tb_postagem p;

-- SELECT REF
SELECT DEREF(A.postagem).titulo AS Titulo, 
    (A.categoria).descricao AS Categoria, 
    (A.membro).nome_de_usuario AS Membro 
FROM tb_publicar A
WHERE A.postagem = 
    (
        SELECT REF(p) FROM tb_postagem p
        WHERE p.id = '00012'
    );

-- VARRAY
SELECT N.conta FROM tb_membro M, TABLE (M.emails) N
WHERE M.nome_de_usuario = 'grogu';

-- NESTED TABLE
SELECT M.nome_de_usuario, C.conta FROM tb_moderador M, TABLE (M.contatos) C
WHERE M.nome_de_usuario = 
    (
        SELECT DEREF(A.moderador).nome_de_usuario FROM tb_acompanhar A
        WHERE (A.categoria).id = 3
    );

-- MAP FUNCTION
SELECT c.id, c.titulo, c.descricao, i.membro.nome_de_usuario, i.membro.nivel FROM tb_categoria c

INNER JOIN tb_inscrever i
ON c.id = DEREF(i.categoria).id

ORDER BY c.categoria_n();