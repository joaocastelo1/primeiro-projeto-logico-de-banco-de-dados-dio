-- =====================================================
-- PROJETO DE BANCO DE DADOS E-COMMERCE - SQLite Version
-- Arquivo: seed_sqlite.sql
-- Descrição: Dados de teste para popular o banco SQLite
-- =====================================================

-- Desabilitar verificações de chave estrangeira temporariamente
PRAGMA foreign_keys = OFF;

-- =====================================================
-- DADOS: Categorias
-- =====================================================
INSERT INTO Categoria (nome, descricao, ativo) VALUES
('Eletrônicos', 'Produtos eletrônicos e tecnologia', 1),
('Roupas', 'Vestuário e acessórios', 1),
('Casa e Jardim', 'Produtos para casa e decoração', 1),
('Livros', 'Livros e material educativo', 1),
('Esportes', 'Artigos esportivos e fitness', 1),
('Beleza', 'Produtos de beleza e cuidados pessoais', 1);

-- =====================================================
-- DADOS: Fornecedores
-- =====================================================
INSERT INTO Fornecedor (nome, cnpj, contato, email, telefone, endereco, ativo) VALUES
('TechSupply Ltda', '12.345.678/0001-90', 'João Silva', 'contato@techsupply.com', '11987654321', 'Rua da Tecnologia, 123 - São Paulo/SP', 1),
('Fashion World', '23.456.789/0001-01', 'Maria Santos', 'vendas@fashionworld.com', '11876543210', 'Av. da Moda, 456 - Rio de Janeiro/RJ', 1),
('Casa & Cia', '34.567.890/0001-12', 'Pedro Oliveira', 'comercial@casacia.com', '11765432109', 'Rua do Lar, 789 - Belo Horizonte/MG', 1),
('Livraria Central', '45.678.901/0001-23', 'Ana Costa', 'pedidos@livrariacentral.com', '11654321098', 'Praça dos Livros, 321 - Porto Alegre/RS', 1),
('SportMax', '56.789.012/0001-34', 'Carlos Lima', 'esportes@sportmax.com', '11543210987', 'Rua do Esporte, 654 - Brasília/DF', 1);

-- =====================================================
-- DADOS: Produtos
-- =====================================================
INSERT INTO Produto (nome, descricao, preco, estoque, estoque_minimo, categoria_id, fornecedor_id, sku, peso, dimensoes, ativo) VALUES
-- Eletrônicos
('Smartphone Galaxy X1', 'Smartphone com 128GB, câmera 48MP', 1299.99, 50, 10, 1, 1, 'TECH001', 0.180, '15x7x0.8cm', 1),
('Notebook UltraBook Pro', 'Notebook i7, 16GB RAM, SSD 512GB', 3499.99, 25, 5, 1, 1, 'TECH002', 1.500, '35x25x2cm', 1),
('Fone Bluetooth Premium', 'Fone sem fio com cancelamento de ruído', 299.99, 100, 20, 1, 1, 'TECH003', 0.250, '20x18x8cm', 1),
('Smart TV 55 polegadas', 'TV 4K com sistema Android', 2199.99, 15, 3, 1, 1, 'TECH004', 18.500, '123x71x8cm', 1),

-- Roupas
('Camiseta Básica Algodão', 'Camiseta 100% algodão, várias cores', 39.99, 200, 50, 2, 2, 'FASH001', 0.200, 'P/M/G/GG', 1),
('Calça Jeans Slim', 'Calça jeans masculina corte slim', 89.99, 80, 15, 2, 2, 'FASH002', 0.600, '36-44', 1),
('Vestido Floral Verão', 'Vestido feminino estampado', 129.99, 60, 10, 2, 2, 'FASH003', 0.300, 'P/M/G', 1),
('Tênis Casual Couro', 'Tênis masculino em couro legítimo', 199.99, 45, 8, 2, 2, 'FASH004', 0.800, '38-44', 1),

-- Casa e Jardim
('Sofá 3 Lugares Cinza', 'Sofá confortável para sala', 899.99, 12, 2, 3, 3, 'CASA001', 45.000, '200x90x85cm', 1),
('Mesa de Jantar 6 Lugares', 'Mesa em madeira maciça', 1299.99, 8, 1, 3, 3, 'CASA002', 35.000, '160x90x75cm', 1),
('Conjunto Panelas Inox', 'Kit com 5 panelas em aço inox', 249.99, 30, 5, 3, 3, 'CASA003', 3.500, '40x30x25cm', 1),
('Aspirador de Pó Robot', 'Aspirador automático inteligente', 799.99, 20, 3, 3, 3, 'CASA004', 3.200, '35x35x10cm', 1),

-- Livros
('Livro: Algoritmos e Programação', 'Livro técnico sobre programação', 89.99, 75, 15, 4, 4, 'LIVR001', 0.500, '23x16x3cm', 1),
('Romance: O Grande Gatsby', 'Clássico da literatura mundial', 34.99, 120, 25, 4, 4, 'LIVR002', 0.300, '21x14x2cm', 1),
('Manual de Culinária Brasileira', 'Receitas tradicionais do Brasil', 59.99, 40, 8, 4, 4, 'LIVR003', 0.800, '25x20x4cm', 1),

-- Esportes
('Bicicleta Mountain Bike', 'Bike 21 marchas, aro 26', 899.99, 15, 3, 5, 5, 'SPOR001', 15.000, '180x65x110cm', 1),
('Kit Halteres 20kg', 'Conjunto de halteres ajustáveis', 299.99, 25, 5, 5, 5, 'SPOR002', 20.000, '50x30x20cm', 1),
('Tênis Running Pro', 'Tênis para corrida profissional', 349.99, 35, 7, 5, 5, 'SPOR003', 0.400, '30x20x12cm', 1),

-- Beleza
('Kit Skincare Completo', 'Kit com limpador, tônico e hidratante', 159.99, 50, 10, 6, 2, 'BEAU001', 0.600, '25x15x10cm', 1),
('Perfume Floral Feminino', 'Fragrância suave e duradoura', 189.99, 40, 8, 6, 2, 'BEAU002', 0.200, '12x8x15cm', 1),
('Shampoo Hidratante 500ml', 'Shampoo para cabelos secos', 29.99, 100, 20, 6, 2, 'BEAU003', 0.500, '20x8x8cm', 1);

-- =====================================================
-- DADOS: Clientes
-- =====================================================
INSERT INTO Cliente (nome, tipo, cpf_cnpj, email, telefone, ativo) VALUES
-- Pessoas Físicas
('Maria Silva Santos', 'PF', '123.456.789-00', 'maria.silva@email.com', '11999888777', 1),
('João Pedro Oliveira', 'PF', '234.567.890-11', 'joao.pedro@email.com', '11888777666', 1),
('Ana Carolina Costa', 'PF', '345.678.901-22', 'ana.carolina@email.com', '11777666555', 1),
('Carlos Eduardo Lima', 'PF', '456.789.012-33', 'carlos.eduardo@email.com', '11666555444', 1),
('Fernanda Rodrigues', 'PF', '567.890.123-44', 'fernanda.rodrigues@email.com', '11555444333', 1),
('Roberto Almeida', 'PF', '678.901.234-55', 'roberto.almeida@email.com', '11444333222', 1),

-- Pessoas Jurídicas
('Empresa Tech Solutions Ltda', 'PJ', '12.345.678/0001-99', 'contato@techsolutions.com', '1133334444', 1),
('Comércio Varejo ABC S.A.', 'PJ', '23.456.789/0001-88', 'vendas@varejoabc.com', '1144445555', 1),
('Restaurante Sabor & Arte', 'PJ', '34.567.890/0001-77', 'pedidos@saborarte.com', '1155556666', 1),
('Clínica Médica Vida Saudável', 'PJ', '45.678.901/0001-66', 'atendimento@vidasaudavel.com', '1166667777', 1);

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
(5, 6, '2024-01-19 11:30:00', '2024-01-24', 'ENVIADO', 'BR456789123', 'Entrega expressa');

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
(4, 16, 1, 899.99, 0.00),  -- Bicicleta
(4, 17, 1, 349.99, 0.00),  -- Tênis Running

-- Pedido 5 (Fernanda)
(5, 9, 1, 899.99, 20.00),  -- Sofá com 20% desconto
(5, 11, 1, 249.99, 0.00);  -- Conjunto Panelas

-- =====================================================
-- DADOS: Pagamentos
-- =====================================================
INSERT INTO Pagamento (pedido_id, tipo_pagamento, valor, data_pagamento, status_pagamento, numero_transacao, observacoes) VALUES
(1, 'PIX', 1834.97, '2024-01-15 10:35:00', 'APROVADO', 'PIX20240115103500001', 'Pagamento instantâneo'),
(2, 'CARTAO_CREDITO', 5349.98, '2024-01-16 14:25:00', 'APROVADO', 'CC20240116142500001', 'Parcelado em 12x'),
(3, 'CARTAO_DEBITO', 290.48, '2024-01-17 09:20:00', 'APROVADO', 'CD20240117092000001', 'Débito à vista'),
(4, 'PIX', 1249.98, '2024-01-18 16:50:00', 'PENDENTE', NULL, 'Aguardando confirmação'),
(5, 'TRANSFERENCIA', 969.99, '2024-01-19 11:35:00', 'APROVADO', 'TF20240119113500001', 'Transferência bancária');

-- Reabilitar verificações de chave estrangeira
PRAGMA foreign_keys = ON;

-- =====================================================
-- VERIFICAÇÃO DOS DADOS INSERIDOS
-- =====================================================
SELECT 'Dados inseridos com sucesso!' AS status,
       (SELECT COUNT(*) FROM Cliente) AS total_clientes,
       (SELECT COUNT(*) FROM Produto) AS total_produtos,
       (SELECT COUNT(*) FROM Pedido) AS total_pedidos,
       (SELECT COUNT(*) FROM ItemPedido) AS total_itens,
       (SELECT COUNT(*) FROM Pagamento) AS total_pagamentos;