-- =====================================================
-- PROJETO DE BANCO DE DADOS E-COMMERCE
-- Arquivo: schema.sql
-- Descrição: Estrutura completa do banco de dados
-- =====================================================

-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- =====================================================
-- TABELA: Cliente
-- Descrição: Armazena informações dos clientes (PF e PJ)
-- =====================================================
CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('PF', 'PJ') NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- TABELA: Endereco
-- Descrição: Endereços dos clientes (relacionamento 1:N)
-- =====================================================
CREATE TABLE Endereco (
    endereco_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    tipo_endereco ENUM('RESIDENCIAL', 'COMERCIAL', 'ENTREGA') DEFAULT 'RESIDENCIAL',
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id) ON DELETE CASCADE
);

-- =====================================================
-- TABELA: Fornecedor
-- Descrição: Informações dos fornecedores
-- =====================================================
CREATE TABLE Fornecedor (
    fornecedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) UNIQUE,
    contato VARCHAR(50),
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- TABELA: Categoria
-- Descrição: Categorias dos produtos
-- =====================================================
CREATE TABLE Categoria (
    categoria_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT,
    ativo BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- TABELA: Produto
-- Descrição: Catálogo de produtos
-- =====================================================
CREATE TABLE Produto (
    produto_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    estoque INT NOT NULL DEFAULT 0 CHECK (estoque >= 0),
    estoque_minimo INT DEFAULT 5,
    categoria_id INT,
    fornecedor_id INT,
    sku VARCHAR(50) UNIQUE,
    peso DECIMAL(8,3),
    dimensoes VARCHAR(50),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id),
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(fornecedor_id)
);

-- =====================================================
-- TABELA: Pedido
-- Descrição: Pedidos realizados pelos clientes
-- =====================================================
CREATE TABLE Pedido (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    endereco_entrega_id INT,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_entrega_prevista DATE,
    data_entrega_real DATE,
    status ENUM('AGUARDANDO_PAGAMENTO', 'PROCESSANDO', 'ENVIADO', 'ENTREGUE', 'CANCELADO') 
           NOT NULL DEFAULT 'AGUARDANDO_PAGAMENTO',
    codigo_rastreio VARCHAR(50),
    valor_total DECIMAL(10,2) DEFAULT 0,
    observacoes TEXT,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (endereco_entrega_id) REFERENCES Endereco(endereco_id)
);

-- =====================================================
-- TABELA: ItemPedido
-- Descrição: Itens que compõem cada pedido
-- =====================================================
CREATE TABLE ItemPedido (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
    desconto DECIMAL(5,2) DEFAULT 0 CHECK (desconto >= 0 AND desconto <= 100),
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario * (1 - desconto/100)) STORED,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id),
    UNIQUE KEY unique_item_pedido (pedido_id, produto_id)
);

-- =====================================================
-- TABELA: Pagamento
-- Descrição: Pagamentos realizados para os pedidos
-- =====================================================
CREATE TABLE Pagamento (
    pagamento_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    tipo_pagamento ENUM('CARTAO_CREDITO', 'CARTAO_DEBITO', 'PIX', 'BOLETO', 'TRANSFERENCIA') NOT NULL,
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pagamento ENUM('PENDENTE', 'APROVADO', 'REJEITADO', 'CANCELADO') DEFAULT 'PENDENTE',
    numero_transacao VARCHAR(100),
    observacoes TEXT,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id)
);

-- =====================================================
-- TABELA: Estoque_Historico
-- Descrição: Histórico de movimentações de estoque
-- =====================================================
CREATE TABLE Estoque_Historico (
    historico_id INT PRIMARY KEY AUTO_INCREMENT,
    produto_id INT NOT NULL,
    tipo_movimentacao ENUM('ENTRADA', 'SAIDA', 'AJUSTE') NOT NULL,
    quantidade INT NOT NULL,
    estoque_anterior INT NOT NULL,
    estoque_atual INT NOT NULL,
    motivo VARCHAR(100),
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_responsavel VARCHAR(50),
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id)
);

-- =====================================================
-- ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS
-- =====================================================

-- Índices para melhorar performance das consultas
CREATE INDEX idx_cliente_tipo ON Cliente(tipo);
CREATE INDEX idx_cliente_email ON Cliente(email);
CREATE INDEX idx_produto_categoria ON Produto(categoria_id);
CREATE INDEX idx_produto_fornecedor ON Produto(fornecedor_id);
CREATE INDEX idx_produto_sku ON Produto(sku);
CREATE INDEX idx_pedido_cliente ON Pedido(cliente_id);
CREATE INDEX idx_pedido_status ON Pedido(status);
CREATE INDEX idx_pedido_data ON Pedido(data_pedido);
CREATE INDEX idx_item_pedido ON ItemPedido(pedido_id);
CREATE INDEX idx_item_produto ON ItemPedido(produto_id);
CREATE INDEX idx_pagamento_pedido ON Pagamento(pedido_id);
CREATE INDEX idx_pagamento_status ON Pagamento(status_pagamento);

-- =====================================================
-- TRIGGERS PARA AUTOMAÇÃO
-- =====================================================

-- Trigger para atualizar valor total do pedido
DELIMITER //
CREATE TRIGGER tr_atualiza_valor_pedido 
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN
    UPDATE Pedido 
    SET valor_total = (
        SELECT SUM(subtotal) 
        FROM ItemPedido 
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE pedido_id = NEW.pedido_id;
END//

-- Trigger para controle de estoque
CREATE TRIGGER tr_controla_estoque 
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN
    UPDATE Produto 
    SET estoque = estoque - NEW.quantidade
    WHERE produto_id = NEW.produto_id;
    
    INSERT INTO Estoque_Historico (produto_id, tipo_movimentacao, quantidade, estoque_anterior, estoque_atual, motivo)
    VALUES (NEW.produto_id, 'SAIDA', NEW.quantidade, 
            (SELECT estoque + NEW.quantidade FROM Produto WHERE produto_id = NEW.produto_id),
            (SELECT estoque FROM Produto WHERE produto_id = NEW.produto_id),
            CONCAT('Venda - Pedido #', NEW.pedido_id));
END//

DELIMITER ;

-- =====================================================
-- VIEWS PARA CONSULTAS FREQUENTES
-- =====================================================

-- View para relatório de vendas
CREATE VIEW vw_relatorio_vendas AS
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    p.data_pedido,
    p.status,
    p.valor_total,
    pg.tipo_pagamento,
    pg.status_pagamento
FROM Pedido p
JOIN Cliente c ON p.cliente_id = c.cliente_id
LEFT JOIN Pagamento pg ON p.pedido_id = pg.pedido_id;

-- View para produtos em estoque baixo
CREATE VIEW vw_estoque_baixo AS
SELECT 
    pr.produto_id,
    pr.nome,
    pr.estoque,
    pr.estoque_minimo,
    c.nome AS categoria,
    f.nome AS fornecedor
FROM Produto pr
LEFT JOIN Categoria c ON pr.categoria_id = c.categoria_id
LEFT JOIN Fornecedor f ON pr.fornecedor_id = f.fornecedor_id
WHERE pr.estoque <= pr.estoque_minimo AND pr.ativo = TRUE;