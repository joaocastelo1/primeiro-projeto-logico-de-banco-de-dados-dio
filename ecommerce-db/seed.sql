-- =====================================================
-- PROJETO DE BANCO DE DADOS E-COMMERCE
-- Arquivo: seed.sql
-- Descrição: Dados de teste para popular o banco
-- =====================================================

USE ecommerce_db;

-- Desabilitar verificações de chave estrangeira temporariamente
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- DADOS: Categorias
-- =====================================================
INSERT INTO Categoria (nome, descricao, ativo) VALUES
('Eletrônicos', 'Produtos eletrônicos e tecnologia', TRUE),
('Roupas', 'Vestuário e acessórios', TRUE),
('Casa e Jardim', 'Produtos para casa e decoração', TRUE),
('Livros', 'Livros e material educativo', TRUE),
('Esportes', 'Artigos esportivos e fitness', TRUE),
('Beleza', 'Produtos de beleza e cuidados pessoais', TRUE);

-- =====================================================
-- DADOS: Fornecedores
-- =====================================================
INSERT INTO Fornecedor (nome, cnpj, contato, email, telefone, endereco, ativo) VALUES
('TechSupply Ltda', '12.345.678/0001-90', 'João Silva', 'contato@techsupply.com', '11987654321', 'Rua da Tecnologia, 123 - São Paulo/SP', TRUE),
('Fashion World', '23.456.789/0001-01', 'Maria Santos', 'vendas@fashionworld.com', '11876543210', 'Av. da Moda, 456 - Rio de Janeiro/RJ', TRUE),
('Casa & Cia', '34.567.890/0001-12', 'Pedro Oliveira', 'comercial@casacia.com', '11765432109', 'Rua do Lar, 789 - Belo Horizonte/MG', TRUE),
('Livraria Central', '45.678.901/0001-23', 'Ana Costa', 'pedidos@livrariacentral.com', '11654321098', 'Praça dos Livros, 321 - Porto Alegre/RS', TRUE),
('SportMax', '56.789.012/0001-34', 'Carlos Lima', 'esportes@sportmax.com', '11543210987', 'Rua do Esporte, 654 - Brasília/DF', TRUE);

-- =====================================================
-- DADOS: Produtos
-- =====================================================
INSERT INTO Produto (nome, descricao, preco, estoque, estoque_minimo, categoria_id, fornecedor_id, sku, peso, dimensoes, ativo) VALUES
-- Eletrônicos
('Smartphone Galaxy X1', 'Smartphone com 128GB, câmera 48MP', 1299.99, 50, 10, 1, 1, 'TECH001', 0.180, '15x7x0.8cm', TRUE),
('Notebook UltraBook Pro', 'Notebook i7, 16GB RAM, SSD 512GB', 3499.99, 25, 5, 1, 1, 'TECH002', 1.500, '35x25x2cm', TRUE),
('Fone Bluetooth Premium', 'Fone sem fio com cancelamento de ruído', 299.99, 100, 20, 1, 1, 'TECH003', 0.250, '20x18x8cm', TRUE),
('Smart TV 55 polegadas', 'TV 4K com sistema Android', 2199.99, 15, 3, 1, 1, 'TECH004', 18.500, '123x71x8cm', TRUE),

-- Roupas
('Camiseta Básica Algodão', 'Camiseta 100% algodão, várias cores', 39.99, 200, 50, 2, 2, 'FASH001', 0.200, 'P/M/G/GG', TRUE),
('Calça Jeans Slim', 'Calça jeans masculina corte slim', 89.99, 80, 15, 2, 2, 'FASH002', 0.600, '36-44', TRUE),
('Vestido Floral Verão', 'Vestido feminino estampado', 129.99, 60, 10, 2, 2, 'FASH003', 0.300, 'P/M/G', TRUE),
('Tênis Casual Couro', 'Tênis masculino em couro legítimo', 199.99, 45, 8, 2, 2, 'FASH004', 0.800, '38-44', TRUE),

-- Casa e Jardim
('Sofá 3 Lugares Cinza', 'Sofá confortável para sala', 899.99, 12, 2, 3, 3, 'CASA001', 45.000, '200x90x85cm', TRUE),
('Mesa de Jantar 6 Lugares', 'Mesa em madeira maciça', 1299.99, 8, 1, 3, 3, 'CASA002', 35.000, '160x90x75cm', TRUE),
('Conjunto Panelas Inox', 'Kit com 5 panelas em aço inox', 249.99, 30, 5, 3, 3, 'CASA003', 3.500, '40x30x25cm', TRUE),
('Aspirador de Pó Robot', 'Aspirador automático inteligente', 799.99, 20, 3, 3, 3, 'CASA004', 3.200, '35x35x10cm', TRUE),

-- Livros
('Livro: Algoritmos e Programação', 'Livro técnico sobre programação', 89.99, 75, 15, 4, 4, 'LIVR001', 0.500, '23x16x3cm', TRUE),
('Romance: O Grande Gatsby', 'Clássico da literatura mundial', 34.99, 120, 25, 4, 4, 'LIVR002', 0.300, '21x14x2cm', TRUE),
('Manual de Culinária Brasileira', 'Receitas tradicionais do Brasil', 59.99, 40, 8, 4, 4, 'LIVR003', 0.800, '25x20x4cm', TRUE),

-- Esportes
('Bicicleta Mountain Bike', 'Bike 21 marchas, aro 26', 899.99, 15, 3, 5, 5, 'SPOR001', 15.000, '180x65x110cm', TRUE),
('Kit Halteres 20kg', 'Conjunto de halteres ajustáveis', 299.99, 25, 5, 5, 5, 'SPOR002', 20.000, '50x30x20cm', TRUE),
('Tênis Running Pro', 'Tênis para corrida profissional', 349.99, 35, 7, 5, 5, 'SPOR003', 0.400, '30x20x12cm', TRUE),

-- Beleza
('Kit Skincare Completo', 'Kit com limpador, tônico e hidratante', 159.99, 50, 10, 6, 2, 'BEAU001', 0.600, '25x15x10cm', TRUE),
('Perfume Floral Feminino', 'Fragrância suave e duradoura', 189.99, 40, 8, 6, 2, 'BEAU002', 0.200, '12x8x15cm', TRUE),
('Shampoo Hidratante 500ml', 'Shampoo para cabelos secos', 29.99, 100, 20, 6, 2, 'BEAU003', 0.500, '20x8x8cm', TRUE);

-- =====================================================
-- DADOS: Clientes
-- =====================================================
INSERT INTO Cliente (nome, tipo, cpf_cnpj, email, telefone, ativo) VALUES
-- Pessoas Físicas
('Maria Silva Santos', 'PF', '123.456.789-00', 'maria.silva@email.com', '11999888777', TRUE),
('João Pedro Oliveira', 'PF', '234.567.890-11', 'joao.pedro@email.com', '11888777666', TRUE),
('Ana Carolina Costa', 'PF', '345.678.901-22', 'ana.carolina@email.com', '11777666555', TRUE),
('Carlos Eduardo Lima', 'PF', '456.789.012-33', 'carlos.eduardo@email.com', '11666555444', TRUE),
('Fernanda Rodrigues', 'PF', '567.890.123-44', 'fernanda.rodrigues@email.com', '11555444333', TRUE),
('Roberto Almeida', 'PF', '678.901.234-55', 'roberto.almeida@email.com', '11444333222', TRUE),

-- Pessoas Jurídicas
('Empresa Tech Solutions Ltda', 'PJ', '12.345.678/0001-99', 'contato@techsolutions.com', '1133334444', TRUE),
('Comércio Varejo ABC S.A.', 'PJ', '23.456.789/0001-88', 'vendas@varejoabc.com', '1144445555', TRUE),
('Restaurante Sabor & Arte', 'PJ', '34.567.890/0001-77', 'pedidos@saborarte.com', '1155556666', TRUE),
('Clínica Médica Vida Saudável', 'PJ', '45.678.901/0001-66', 'atendimento@vidasaudavel.com', '1166667777', TRUE);

-- =====================================================
-- DADOS: Endereços
-- =====================================================
INSERT INTO Endereco (cliente_id, logradouro, numero, complemento, bairro, cidade, estado, cep, tipo_endereco) VALUES
-- Endereços PF
(1, 'Rua das Flores', '123', 'Apto 45', 'Centro', 'São Paulo', 'SP', '01234-567', 'RESIDENCIAL'),
(1, 'Av. Paulista', '1000', 'Sala 201', 'Bela Vista', 'São Paulo', 'SP', '01310-100', 'COMERCIAL'),
(2, 'Rua dos Jardins', '456', '', 'Jardins', 'São Paulo', 'SP', '01234-890', 'RESIDENCIAL'),
(3, 'Av. Copacabana', '789', 'Cobertura', 'Copacabana', 'Rio de Janeiro', 'RJ', '22070-011', 'RESIDENCIAL'),
(4, 'Rua da Praia', '321', '', 'Ipanema', 'Rio de Janeiro', 'RJ', '22411-010', 'ENTREGA'),
(5, 'Av. Afonso Pena', '654', 'Apto 12', 'Centro', 'Belo Horizonte', 'MG', '30112-000', 'RESIDENCIAL'),
(6, 'Rua XV de Novembro', '987', '', 'Centro', 'Curitiba', 'PR', '80020-310', 'RESIDENCIAL'),

-- Endereços PJ
(7, 'Av. Faria Lima', '2000', 'Andar 15', 'Itaim Bibi', 'São Paulo', 'SP', '01452-000', 'COMERCIAL'),
(8, 'Rua do Comércio', '500', '', 'Centro', 'São Paulo', 'SP', '01013-001', 'COMERCIAL'),
(9, 'Av. Atlântica', '1500', 'Loja 3', 'Copacabana', 'Rio de Janeiro', 'RJ', '22021-001', 'COMERCIAL'),
(10, 'Rua da Saúde', '250', 'Térreo', 'Saúde', 'São Paulo', 'SP', '04038-001', 'COMERCIAL');

-- =====================================================
-- DADOS: Pedidos
-- =====================================================
INSERT INTO Pedido (cliente_id, endereco_entrega_id, data_pedido, data_entrega_prevista, status, codigo_rastreio, observacoes) VALUES
(1, 1, '2024-01-15 10:30:00', '2024-01-20', 'ENTREGUE', 'BR123456789', 'Entrega no período da manhã'),
(2, 3, '2024-01-16 14:20:00', '2024-01-21', 'ENVIADO', 'BR987654321', 'Cuidado com produto frágil'),
(3, 4, '2024-01-17 09:15:00', '2024-01-22', 'PROCESSANDO', NULL, 'Primeira compra do cliente'),
(4, 5, '2024-01-18 16:45:00', '2024-01-23', 'AGUARDANDO_PAGAMENTO', NULL, 'Aguardando confirmação do PIX'),
(5, 6, '2024-01-19 11:30:00', '2024-01-24', 'ENVIADO', 'BR456789123', 'Entrega expressa'),
(7, 8, '2024-01-20 08:00:00', '2024-01-25', 'PROCESSANDO', NULL, 'Pedido corporativo'),
(8, 9, '2024-01-21 13:20:00', '2024-01-26', 'ENTREGUE', 'BR789123456', 'Entrega realizada com sucesso'),
(1, 2, '2024-01-22 15:10:00', '2024-01-27', 'CANCELADO', NULL, 'Cancelado a pedido do cliente'),
(6, 7, '2024-01-23 10:45:00', '2024-01-28', 'ENVIADO', 'BR321654987', 'Produto em promoção'),
(9, 10, '2024-01-24 12:30:00', '2024-01-29', 'PROCESSANDO', NULL, 'Pedido para evento especial');

-- =====================================================
-- DADOS: Itens dos Pedidos
-- =====================================================
INSERT INTO ItemPedido (pedido_id, produto_id, quantidade, preco_unitario, desconto) VALUES
-- Pedido 1 (Maria Silva)
(1, 1, 1, 1299.99, 5.00),  -- Smartphone com 5% desconto
(1, 3, 2, 299.99, 0.00),   -- 2 Fones Bluetooth

-- Pedido 2 (João Pedro)
(2, 2, 1, 3499.99, 10.00), -- Notebook com 10% desconto
(2, 4, 1, 2199.99, 0.00),  -- Smart TV

-- Pedido 3 (Ana Carolina)
(3, 5, 3, 39.99, 0.00),    -- 3 Camisetas
(3, 7, 1, 129.99, 15.00),  -- Vestido com 15% desconto
(3, 18, 1, 159.99, 0.00),  -- Kit Skincare

-- Pedido 4 (Carlos Eduardo)
(4, 14, 1, 899.99, 0.00),  -- Bicicleta
(4, 16, 1, 349.99, 0.00),  -- Tênis Running

-- Pedido 5 (Fernanda)
(5, 9, 1, 899.99, 20.00),  -- Sofá com 20% desconto
(5, 11, 1, 249.99, 0.00),  -- Conjunto Panelas

-- Pedido 6 (Empresa Tech Solutions)
(6, 2, 5, 3499.99, 15.00), -- 5 Notebooks com desconto corporativo
(6, 1, 10, 1299.99, 10.00), -- 10 Smartphones

-- Pedido 7 (Comércio Varejo ABC)
(7, 5, 50, 39.99, 25.00),  -- 50 Camisetas com desconto por volume
(7, 6, 30, 89.99, 20.00),  -- 30 Calças Jeans

-- Pedido 8 (Cancelado)
(8, 13, 1, 89.99, 0.00),   -- Livro (pedido cancelado)

-- Pedido 9 (Roberto)
(9, 19, 2, 189.99, 0.00),  -- 2 Perfumes
(9, 20, 3, 29.99, 0.00),   -- 3 Shampoos

-- Pedido 10 (Restaurante)
(10, 11, 3, 249.99, 10.00), -- 3 Conjuntos de Panelas
(10, 12, 1, 799.99, 5.00);  -- Aspirador Robot

-- =====================================================
-- DADOS: Pagamentos
-- =====================================================
INSERT INTO Pagamento (pedido_id, tipo_pagamento, valor, data_pagamento, status_pagamento, numero_transacao, observacoes) VALUES
(1, 'PIX', 1834.97, '2024-01-15 10:35:00', 'APROVADO', 'PIX20240115103500001', 'Pagamento instantâneo'),
(2, 'CARTAO_CREDITO', 5349.98, '2024-01-16 14:25:00', 'APROVADO', 'CC20240116142500001', 'Parcelado em 12x'),
(3, 'CARTAO_DEBITO', 290.48, '2024-01-17 09:20:00', 'APROVADO', 'CD20240117092000001', 'Débito à vista'),
(4, 'PIX', 1249.98, '2024-01-18 16:50:00', 'PENDENTE', NULL, 'Aguardando confirmação'),
(5, 'TRANSFERENCIA', 969.99, '2024-01-19 11:35:00', 'APROVADO', 'TF20240119113500001', 'Transferência bancária'),
(6, 'CARTAO_CREDITO', 27849.85, '2024-01-20 08:05:00', 'APROVADO', 'CC20240120080500001', 'Pagamento corporativo'),
(7, 'BOLETO', 4169.70, '2024-01-21 13:25:00', 'APROVADO', 'BL20240121132500001', 'Boleto bancário'),
(8, 'PIX', 89.99, '2024-01-22 15:15:00', 'CANCELADO', 'PIX20240122151500001', 'Estornado por cancelamento'),
(9, 'CARTAO_CREDITO', 469.95, '2024-01-23 10:50:00', 'APROVADO', 'CC20240123105000001', 'Cartão de crédito'),
(10, 'CARTAO_DEBITO', 1509.96, '2024-01-24 12:35:00', 'APROVADO', 'CD20240124123500001', 'Débito empresarial');

-- =====================================================
-- DADOS: Histórico de Estoque (Simulando movimentações)
-- =====================================================
INSERT INTO Estoque_Historico (produto_id, tipo_movimentacao, quantidade, estoque_anterior, estoque_atual, motivo, data_movimentacao, usuario_responsavel) VALUES
-- Entradas de estoque
(1, 'ENTRADA', 100, 0, 100, 'Estoque inicial', '2024-01-01 08:00:00', 'admin'),
(2, 'ENTRADA', 50, 0, 50, 'Estoque inicial', '2024-01-01 08:00:00', 'admin'),
(3, 'ENTRADA', 150, 0, 150, 'Estoque inicial', '2024-01-01 08:00:00', 'admin'),

-- Saídas por vendas (algumas já registradas pelos triggers)
(1, 'SAIDA', 50, 100, 50, 'Vendas do mês', '2024-01-31 18:00:00', 'sistema'),
(2, 'SAIDA', 25, 50, 25, 'Vendas do mês', '2024-01-31 18:00:00', 'sistema'),
(3, 'SAIDA', 50, 150, 100, 'Vendas do mês', '2024-01-31 18:00:00', 'sistema'),

-- Ajustes de inventário
(5, 'AJUSTE', -5, 205, 200, 'Ajuste de inventário', '2024-01-15 14:00:00', 'estoquista'),
(10, 'AJUSTE', 2, 10, 12, 'Produto encontrado no estoque', '2024-01-20 16:00:00', 'estoquista');

-- Reabilitar verificações de chave estrangeira
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- ATUALIZAÇÃO DOS VALORES TOTAIS DOS PEDIDOS
-- (Executar após inserir todos os itens)
-- =====================================================
UPDATE Pedido p SET valor_total = (
    SELECT COALESCE(SUM(ip.subtotal), 0)
    FROM ItemPedido ip 
    WHERE ip.pedido_id = p.pedido_id
);

-- =====================================================
-- VERIFICAÇÃO DOS DADOS INSERIDOS
-- =====================================================
SELECT 'Dados inseridos com sucesso!' AS status,
       (SELECT COUNT(*) FROM Cliente) AS total_clientes,
       (SELECT COUNT(*) FROM Produto) AS total_produtos,
       (SELECT COUNT(*) FROM Pedido) AS total_pedidos,
       (SELECT COUNT(*) FROM ItemPedido) AS total_itens,
       (SELECT COUNT(*) FROM Pagamento) AS total_pagamentos;