-- =====================================================
-- PROJETO DE BANCO DE DADOS E-COMMERCE
-- Arquivo: queries.sql
-- Descrição: Consultas complexas demonstrando funcionalidades
-- =====================================================

USE ecommerce_db;

-- =====================================================
-- 1. RECUPERAÇÕES SIMPLES COM SELECT
-- =====================================================

-- 1.1 Listar todos os clientes
SELECT * FROM Cliente;

-- 1.2 Listar todos os produtos com informações básicas
SELECT produto_id, nome, preco, estoque FROM Produto;

-- 1.3 Listar todas as categorias ativas
SELECT categoria_id, nome, descricao FROM Categoria WHERE ativo = TRUE;

-- 1.4 Listar fornecedores com contato
SELECT nome, contato, email, telefone FROM Fornecedor WHERE ativo = TRUE;

-- =====================================================
-- 2. FILTROS COM WHERE
-- =====================================================

-- 2.1 Clientes pessoa física
SELECT nome, email, telefone 
FROM Cliente 
WHERE tipo = 'PF';

-- 2.2 Clientes pessoa jurídica
SELECT nome, email, telefone 
FROM Cliente 
WHERE tipo = 'PJ';

-- 2.3 Produtos com estoque baixo (menor que estoque mínimo)
SELECT nome, estoque, estoque_minimo, preco
FROM Produto 
WHERE estoque <= estoque_minimo AND ativo = TRUE;

-- 2.4 Produtos em faixa de preço específica
SELECT nome, preco, categoria_id
FROM Produto 
WHERE preco BETWEEN 100.00 AND 500.00;

-- 2.5 Pedidos em processamento ou enviados
SELECT pedido_id, cliente_id, data_pedido, status, valor_total
FROM Pedido 
WHERE status IN ('PROCESSANDO', 'ENVIADO');

-- 2.6 Pagamentos aprovados por PIX
SELECT pagamento_id, pedido_id, valor, data_pagamento
FROM Pagamento 
WHERE tipo_pagamento = 'PIX' AND status_pagamento = 'APROVADO';

-- =====================================================
-- 3. ATRIBUTOS DERIVADOS (CÁLCULOS)
-- =====================================================

-- 3.1 Total de cada pedido (soma dos subtotais dos itens)
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    p.data_pedido,
    SUM(ip.subtotal) AS total_calculado,
    p.valor_total AS total_armazenado
FROM Pedido p
JOIN Cliente c ON p.cliente_id = c.cliente_id
JOIN ItemPedido ip ON p.pedido_id = ip.pedido_id
GROUP BY p.pedido_id, c.nome, p.data_pedido, p.valor_total;

-- 3.2 Valor médio dos pedidos por cliente
SELECT 
    c.cliente_id,
    c.nome,
    COUNT(p.pedido_id) AS total_pedidos,
    AVG(p.valor_total) AS valor_medio_pedido,
    SUM(p.valor_total) AS valor_total_cliente
FROM Cliente c
JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome;

-- 3.3 Margem de lucro simulada (assumindo custo de 60% do preço)
SELECT 
    produto_id,
    nome,
    preco,
    ROUND(preco * 0.60, 2) AS custo_estimado,
    ROUND(preco * 0.40, 2) AS margem_estimada,
    ROUND((preco * 0.40 / preco) * 100, 2) AS percentual_margem
FROM Produto
WHERE ativo = TRUE;

-- 3.4 Idade dos pedidos em dias
SELECT 
    pedido_id,
    data_pedido,
    status,
    DATEDIFF(CURDATE(), DATE(data_pedido)) AS dias_desde_pedido,
    CASE 
        WHEN DATEDIFF(CURDATE(), DATE(data_pedido)) <= 7 THEN 'Recente'
        WHEN DATEDIFF(CURDATE(), DATE(data_pedido)) <= 30 THEN 'Médio'
        ELSE 'Antigo'
    END AS classificacao_idade
FROM Pedido;

-- =====================================================
-- 4. ORDENAÇÕES COM ORDER BY
-- =====================================================

-- 4.1 Produtos ordenados por preço (maior para menor)
SELECT nome, preco, estoque 
FROM Produto 
WHERE ativo = TRUE
ORDER BY preco DESC;

-- 4.2 Clientes ordenados alfabeticamente
SELECT nome, tipo, email 
FROM Cliente 
WHERE ativo = TRUE
ORDER BY nome ASC;

-- 4.3 Pedidos ordenados por data (mais recentes primeiro)
SELECT pedido_id, cliente_id, data_pedido, valor_total, status
FROM Pedido 
ORDER BY data_pedido DESC;

-- 4.4 Produtos ordenados por estoque (menor primeiro) e depois por preço
SELECT nome, estoque, preco, categoria_id
FROM Produto 
WHERE ativo = TRUE
ORDER BY estoque ASC, preco DESC;

-- 4.5 Top 5 produtos mais caros
SELECT nome, preco, categoria_id
FROM Produto 
WHERE ativo = TRUE
ORDER BY preco DESC
LIMIT 5;

-- =====================================================
-- 5. CONDIÇÕES DE GRUPO COM HAVING
-- =====================================================

-- 5.1 Clientes com mais de 1 pedido
SELECT 
    c.cliente_id,
    c.nome,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS valor_total_gasto
FROM Cliente c
JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome
HAVING COUNT(p.pedido_id) > 1;

-- 5.2 Produtos vendidos mais de 5 vezes
SELECT 
    pr.produto_id,
    pr.nome,
    SUM(ip.quantidade) AS total_vendido,
    COUNT(DISTINCT ip.pedido_id) AS pedidos_diferentes
FROM Produto pr
JOIN ItemPedido ip ON pr.produto_id = ip.produto_id
GROUP BY pr.produto_id, pr.nome
HAVING SUM(ip.quantidade) > 5;

-- 5.3 Categorias com valor total de vendas acima de R$ 1000
SELECT 
    c.categoria_id,
    c.nome AS categoria,
    COUNT(DISTINCT pr.produto_id) AS produtos_na_categoria,
    SUM(ip.subtotal) AS valor_total_vendas
FROM Categoria c
JOIN Produto pr ON c.categoria_id = pr.categoria_id
JOIN ItemPedido ip ON pr.produto_id = ip.produto_id
GROUP BY c.categoria_id, c.nome
HAVING SUM(ip.subtotal) > 1000.00;

-- 5.4 Fornecedores com mais de 3 produtos cadastrados
SELECT 
    f.fornecedor_id,
    f.nome AS fornecedor,
    COUNT(p.produto_id) AS total_produtos,
    AVG(p.preco) AS preco_medio_produtos
FROM Fornecedor f
JOIN Produto p ON f.fornecedor_id = p.fornecedor_id
WHERE p.ativo = TRUE
GROUP BY f.fornecedor_id, f.nome
HAVING COUNT(p.produto_id) > 3;

-- 5.5 Meses com vendas acima da média
SELECT 
    YEAR(p.data_pedido) AS ano,
    MONTH(p.data_pedido) AS mes,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS valor_total_mes
FROM Pedido p
WHERE p.status != 'CANCELADO'
GROUP BY YEAR(p.data_pedido), MONTH(p.data_pedido)
HAVING SUM(p.valor_total) > (
    SELECT AVG(valor_mensal) 
    FROM (
        SELECT SUM(valor_total) AS valor_mensal
        FROM Pedido 
        WHERE status != 'CANCELADO'
        GROUP BY YEAR(data_pedido), MONTH(data_pedido)
    ) AS medias_mensais
);

-- =====================================================
-- 6. JUNÇÕES COMPLEXAS (JOINS)
-- =====================================================

-- 6.1 Produtos com fornecedores e categorias
SELECT 
    pr.nome AS produto,
    pr.preco,
    pr.estoque,
    c.nome AS categoria,
    f.nome AS fornecedor,
    f.contato AS contato_fornecedor
FROM Produto pr
LEFT JOIN Categoria c ON pr.categoria_id = c.categoria_id
LEFT JOIN Fornecedor f ON pr.fornecedor_id = f.fornecedor_id
WHERE pr.ativo = TRUE;

-- 6.2 Pedidos completos com cliente, itens e produtos
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    c.tipo AS tipo_cliente,
    p.data_pedido,
    p.status,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.desconto,
    ip.subtotal
FROM Pedido p
JOIN Cliente c ON p.cliente_id = c.cliente_id
JOIN ItemPedido ip ON p.pedido_id = ip.pedido_id
JOIN Produto pr ON ip.produto_id = pr.produto_id
ORDER BY p.pedido_id, pr.nome;

-- 6.3 Clientes com seus endereços e pedidos
SELECT 
    c.nome AS cliente,
    e.logradouro,
    e.cidade,
    e.estado,
    e.tipo_endereco,
    COUNT(p.pedido_id) AS total_pedidos
FROM Cliente c
LEFT JOIN Endereco e ON c.cliente_id = e.cliente_id
LEFT JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome, e.endereco_id, e.logradouro, e.cidade, e.estado, e.tipo_endereco;

-- 6.4 Relatório de vendas por fornecedor
SELECT 
    f.nome AS fornecedor,
    COUNT(DISTINCT pr.produto_id) AS produtos_cadastrados,
    COUNT(DISTINCT ip.pedido_id) AS pedidos_com_produtos,
    SUM(ip.quantidade) AS total_unidades_vendidas,
    SUM(ip.subtotal) AS valor_total_vendas
FROM Fornecedor f
JOIN Produto pr ON f.fornecedor_id = pr.fornecedor_id
LEFT JOIN ItemPedido ip ON pr.produto_id = ip.produto_id
GROUP BY f.fornecedor_id, f.nome
ORDER BY valor_total_vendas DESC;

-- 6.5 Verificar se algum cliente é também fornecedor (por nome)
SELECT 
    c.nome AS cliente,
    c.tipo AS tipo_cliente,
    f.nome AS fornecedor,
    'Possível duplicação' AS observacao
FROM Cliente c
JOIN Fornecedor f ON UPPER(c.nome) = UPPER(f.nome);

-- =====================================================
-- 7. CONSULTAS AVANÇADAS E ANALÍTICAS
-- =====================================================

-- 7.1 Ranking de produtos mais vendidos
SELECT 
    pr.produto_id,
    pr.nome,
    SUM(ip.quantidade) AS total_vendido,
    SUM(ip.subtotal) AS receita_total,
    RANK() OVER (ORDER BY SUM(ip.quantidade) DESC) AS ranking_quantidade,
    RANK() OVER (ORDER BY SUM(ip.subtotal) DESC) AS ranking_receita
FROM Produto pr
JOIN ItemPedido ip ON pr.produto_id = ip.produto_id
GROUP BY pr.produto_id, pr.nome
ORDER BY total_vendido DESC;

-- 7.2 Análise de sazonalidade de vendas
SELECT 
    MONTH(p.data_pedido) AS mes,
    MONTHNAME(p.data_pedido) AS nome_mes,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS valor_total,
    AVG(p.valor_total) AS ticket_medio
FROM Pedido p
WHERE p.status != 'CANCELADO'
GROUP BY MONTH(p.data_pedido), MONTHNAME(p.data_pedido)
ORDER BY mes;

-- 7.3 Clientes mais valiosos (RFM simplificado)
SELECT 
    c.cliente_id,
    c.nome,
    COUNT(p.pedido_id) AS frequencia,
    SUM(p.valor_total) AS valor_monetario,
    MAX(p.data_pedido) AS ultima_compra,
    DATEDIFF(CURDATE(), MAX(p.data_pedido)) AS dias_desde_ultima_compra,
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(p.data_pedido)) <= 30 THEN 'Ativo'
        WHEN DATEDIFF(CURDATE(), MAX(p.data_pedido)) <= 90 THEN 'Em Risco'
        ELSE 'Inativo'
    END AS status_cliente
FROM Cliente c
JOIN Pedido p ON c.cliente_id = p.cliente_id
WHERE p.status != 'CANCELADO'
GROUP BY c.cliente_id, c.nome
ORDER BY valor_monetario DESC, frequencia DESC;

-- 7.4 Análise de conversão de pagamentos
SELECT 
    pg.tipo_pagamento,
    COUNT(*) AS total_tentativas,
    SUM(CASE WHEN pg.status_pagamento = 'APROVADO' THEN 1 ELSE 0 END) AS aprovados,
    SUM(CASE WHEN pg.status_pagamento = 'REJEITADO' THEN 1 ELSE 0 END) AS rejeitados,
    ROUND(
        (SUM(CASE WHEN pg.status_pagamento = 'APROVADO' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 
        2
    ) AS taxa_aprovacao
FROM Pagamento pg
GROUP BY pg.tipo_pagamento
ORDER BY taxa_aprovacao DESC;

-- 7.5 Produtos que nunca foram vendidos
SELECT 
    pr.produto_id,
    pr.nome,
    pr.preco,
    pr.estoque,
    c.nome AS categoria
FROM Produto pr
LEFT JOIN ItemPedido ip ON pr.produto_id = ip.produto_id
LEFT JOIN Categoria c ON pr.categoria_id = c.categoria_id
WHERE ip.produto_id IS NULL AND pr.ativo = TRUE;

-- =====================================================
-- 8. CONSULTAS USANDO AS VIEWS CRIADAS
-- =====================================================

-- 8.1 Usando a view de relatório de vendas
SELECT * FROM vw_relatorio_vendas 
WHERE status_pagamento = 'APROVADO'
ORDER BY data_pedido DESC;

-- 8.2 Usando a view de estoque baixo
SELECT * FROM vw_estoque_baixo
ORDER BY estoque ASC;

-- =====================================================
-- 9. CONSULTAS DE CONTROLE E AUDITORIA
-- =====================================================

-- 9.1 Histórico de movimentações de estoque
SELECT 
    eh.historico_id,
    pr.nome AS produto,
    eh.tipo_movimentacao,
    eh.quantidade,
    eh.estoque_anterior,
    eh.estoque_atual,
    eh.motivo,
    eh.data_movimentacao,
    eh.usuario_responsavel
FROM Estoque_Historico eh
JOIN Produto pr ON eh.produto_id = pr.produto_id
ORDER BY eh.data_movimentacao DESC;

-- 9.2 Auditoria de pedidos cancelados
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    p.data_pedido,
    p.valor_total,
    p.observacoes,
    pg.status_pagamento
FROM Pedido p
JOIN Cliente c ON p.cliente_id = c.cliente_id
LEFT JOIN Pagamento pg ON p.pedido_id = pg.pedido_id
WHERE p.status = 'CANCELADO';

-- =====================================================
-- 10. ESTATÍSTICAS GERAIS DO E-COMMERCE
-- =====================================================

-- 10.1 Dashboard executivo
SELECT 
    'Resumo Geral' AS categoria,
    (SELECT COUNT(*) FROM Cliente WHERE ativo = TRUE) AS total_clientes,
    (SELECT COUNT(*) FROM Produto WHERE ativo = TRUE) AS total_produtos,
    (SELECT COUNT(*) FROM Pedido WHERE status != 'CANCELADO') AS total_pedidos,
    (SELECT ROUND(SUM(valor_total), 2) FROM Pedido WHERE status != 'CANCELADO') AS receita_total,
    (SELECT ROUND(AVG(valor_total), 2) FROM Pedido WHERE status != 'CANCELADO') AS ticket_medio;

-- =====================================================
-- FIM DAS CONSULTAS
-- =====================================================