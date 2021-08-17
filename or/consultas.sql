-- SELECT DREF
SELECT DISTINCT DEREF (p.membro).nome_de_usuario AS membro FROM tb_postagem p;

-- VARRAY
SELECT N.conta FROM tb_membro M, TABLE (M.emails) N
WHERE M.nome_de_usuario = 'grogu';

-- NESTED TABLE
SELECT C.conta FROM tb_moderador M, TABLE (M.contatos) C; 