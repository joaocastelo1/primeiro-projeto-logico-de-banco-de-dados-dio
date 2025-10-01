-- Script de Demonstração do Banco E-commerce
-- Execute com: sqlite3 ecommerce.db < demo.sql

.headers on
.mode column

-- Verificação das tabelas criadas
.print "=== TABELAS CRIADAS ==="
.tables

-- Contagem de registros por tabela
.print ""
.print "=== CONTAGEM DE REGISTROS ==="
SELECT 'Clientes' as Tabela, COUNT(*) as Total FROM Cliente
UNION ALL
SELECT 'Produtos', COUNT(*) FROM Produto
UNION ALL
SELECT 'Pedidos', COUNT(*) FROM Pedido
UNION ALL
SELECT 'Fornecedores', COUNT(*) FROM Fornecedor
UNION ALL
SELECT 'Categorias', COUNT(*) FROM Categoria;

-- Produtos por categoria
.print ""
.print "=== PRODUTOS POR CATEGORIA ==="
SELECT 
    c.nome as Categoria,
    COUNT(p.id) as Total_Produtos,
    ROUND(AVG(p.preco), 2) as Preco_Medio
FROM Categoria c
LEFT JOIN Produto p ON c.id = p.categoria_id
GROUP BY c.id, c.nome
ORDER BY Total_Produtos DESC;

-- Pedidos com detalhes
.print ""
.print "=== ÚLTIMOS 5 PEDIDOS ==="
SELECT 
    ped.id as Pedido_ID,
    cli.nome as Cliente,
    ped.data_pedido as Data,
    ped.total as Total,
    ped.status as Status
FROM Pedido ped
JOIN Cliente cli ON ped.cliente_id = cli.id
ORDER BY ped.data_pedido DESC
LIMIT 5;

-- Produtos mais vendidos
.print ""
.print "=== PRODUTOS MAIS VENDIDOS ==="
SELECT 
    p.nome as Produto,
    SUM(ip.quantidade) as Total_Vendido,
    ROUND(SUM(ip.subtotal), 2) as Receita_Total
FROM ItemPedido ip
JOIN Produto p ON ip.produto_id = p.id
GROUP BY p.id, p.nome
ORDER BY Total_Vendido DESC
LIMIT 5;

-- Relatório de vendas por mês
.print ""
.print "=== VENDAS POR MÊS ==="
SELECT 
    strftime('%Y-%m', data_pedido) as Mes,
    COUNT(*) as Total_Pedidos,
    ROUND(SUM(total), 2) as Receita_Total
FROM Pedido
WHERE status = 'Entregue'
GROUP BY strftime('%Y-%m', data_pedido)
ORDER BY Mes;

.print ""
.print "=== DEMONSTRAÇÃO CONCLUÍDA ==="