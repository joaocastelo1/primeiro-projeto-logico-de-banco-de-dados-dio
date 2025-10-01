-- =====================================================
-- PROJETO DE BANCO DE DADOS E-COMMERCE - SQLite Version
-- Arquivo: schema_sqlite.sql
-- Descrição: Estrutura completa do banco de dados para SQLite
-- =====================================================

-- =====================================================
-- TABELA: Cliente
-- Descrição: Armazena informações dos clientes (PF e PJ)
-- =====================================================
CREATE TABLE Cliente (
    cliente_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo TEXT CHECK(tipo IN ('PF', 'PJ')) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT 1
);

-- =====================================================
-- TABELA: Endereco
-- Descrição: Endereços dos clientes (relacionamento 1:N)
-- =====================================================
CREATE TABLE Endereco (
    endereco_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    tipo_endereco TEXT CHECK(tipo_endereco IN ('RESIDENCIAL', 'COMERCIAL', 'ENTREGA')) DEFAULT 'RESIDENCIAL',
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id) ON DELETE CASCADE
);

-- =====================================================
-- TABELA: Fornecedor
-- Descrição: Informações dos fornecedores
-- =====================================================
CREATE TABLE Fornecedor (
    fornecedor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) UNIQUE,
    contato VARCHAR(50),
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT 1
);

-- =====================================================
-- TABELA: Categoria
-- Descrição: Categorias dos produtos
-- =====================================================
CREATE TABLE Categoria (
    categoria_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT,
    ativo BOOLEAN DEFAULT 1
);

-- =====================================================
-- TABELA: Produto
-- Descrição: Catálogo de produtos
-- =====================================================
CREATE TABLE Produto (
    produto_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    estoque INTEGER NOT NULL DEFAULT 0 CHECK (estoque >= 0),
    estoque_minimo INTEGER DEFAULT 5,
    categoria_id INTEGER,
    fornecedor_id INTEGER,
    sku VARCHAR(50) UNIQUE,
    peso DECIMAL(8,3),
    dimensoes VARCHAR(50),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT 1,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id),
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(fornecedor_id)
);

-- =====================================================
-- TABELA: Pedido
-- Descrição: Pedidos realizados pelos clientes
-- =====================================================
CREATE TABLE Pedido (
    pedido_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    endereco_entrega_id INTEGER,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_entrega_prevista DATE,
    data_entrega_real DATE,
    status TEXT CHECK(status IN ('AGUARDANDO_PAGAMENTO', 'PROCESSANDO', 'ENVIADO', 'ENTREGUE', 'CANCELADO')) 
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
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
    desconto DECIMAL(5,2) DEFAULT 0 CHECK (desconto >= 0 AND desconto <= 100),
    subtotal DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id),
    UNIQUE (pedido_id, produto_id)
);

-- =====================================================
-- TABELA: Pagamento
-- Descrição: Pagamentos realizados para os pedidos
-- =====================================================
CREATE TABLE Pagamento (
    pagamento_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    tipo_pagamento TEXT CHECK(tipo_pagamento IN ('CARTAO_CREDITO', 'CARTAO_DEBITO', 'PIX', 'BOLETO', 'TRANSFERENCIA')) NOT NULL,
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pagamento TEXT CHECK(status_pagamento IN ('PENDENTE', 'APROVADO', 'REJEITADO', 'CANCELADO')) DEFAULT 'PENDENTE',
    numero_transacao VARCHAR(100),
    observacoes TEXT,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id)
);

-- =====================================================
-- TABELA: Estoque_Historico
-- Descrição: Histórico de movimentações de estoque
-- =====================================================
CREATE TABLE Estoque_Historico (
    historico_id INTEGER PRIMARY KEY AUTOINCREMENT,
    produto_id INTEGER NOT NULL,
    tipo_movimentacao TEXT CHECK(tipo_movimentacao IN ('ENTRADA', 'SAIDA', 'AJUSTE')) NOT NULL,
    quantidade INTEGER NOT NULL,
    estoque_anterior INTEGER NOT NULL,
    estoque_atual INTEGER NOT NULL,
    motivo VARCHAR(100),
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_responsavel VARCHAR(50),
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id)
);

-- =====================================================
-- ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS
-- =====================================================
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
-- TRIGGERS PARA AUTOMAÇÃO (SQLite)
-- =====================================================

-- Trigger para calcular subtotal automaticamente
CREATE TRIGGER tr_calcula_subtotal 
AFTER INSERT ON ItemPedido
BEGIN
    UPDATE ItemPedido 
    SET subtotal = NEW.quantidade * NEW.preco_unitario * (1 - NEW.desconto/100)
    WHERE item_id = NEW.item_id;
END;

-- Trigger para atualizar valor total do pedido
CREATE TRIGGER tr_atualiza_valor_pedido 
AFTER INSERT ON ItemPedido
BEGIN
    UPDATE Pedido 
    SET valor_total = (
        SELECT SUM(subtotal) 
        FROM ItemPedido 
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE pedido_id = NEW.pedido_id;
END;

-- Trigger para controle de estoque
CREATE TRIGGER tr_controla_estoque 
AFTER INSERT ON ItemPedido
BEGIN
    UPDATE Produto 
    SET estoque = estoque - NEW.quantidade
    WHERE produto_id = NEW.produto_id;
    
    INSERT INTO Estoque_Historico (produto_id, tipo_movimentacao, quantidade, estoque_anterior, estoque_atual, motivo)
    VALUES (NEW.produto_id, 'SAIDA', NEW.quantidade, 
            (SELECT estoque + NEW.quantidade FROM Produto WHERE produto_id = NEW.produto_id),
            (SELECT estoque FROM Produto WHERE produto_id = NEW.produto_id),
            'Venda - Pedido #' || NEW.pedido_id);
END;

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
WHERE pr.estoque <= pr.estoque_minimo AND pr.ativo = 1;