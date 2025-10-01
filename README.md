# 🛒 Sistema de E-commerce - Banco de Dados + Frontend

## 👤 Autor
**João Castelo de Sousa Ferreira**
- 📧 Email: [jcrocap2@gmail.com]
- 💼 LinkedIn: [https://www.linkedin.com/in/joao-castelo-ferreira/]
- 🐙 GitHub: [github.com/joaocastelo]

## 📋 Descrição

Este projeto implementa um **sistema completo de e-commerce** com banco de dados SQLite e interface web moderna. Desenvolvido como demonstração de modelagem lógica de banco de dados, o sistema inclui backend em Python Flask e frontend responsivo com dashboard interativo.

## 🎯 Objetivos

- ✅ Demonstrar conceitos de modelagem lógica de banco de dados
- ✅ Implementar relacionamentos entre entidades (1:1, 1:N, N:N)
- ✅ Criar estruturas otimizadas com índices e constraints
- ✅ Desenvolver triggers para automação de processos
- ✅ Implementar views para relatórios e consultas frequentes
- ✅ Fornecer dados de teste realistas para demonstração
- ✅ **NOVO:** Interface web moderna com dashboard interativo
- ✅ **NOVO:** API REST para integração frontend/backend
- ✅ **NOVO:** Gráficos e relatórios visuais em tempo real

## 🏗️ Estrutura do Projeto

```
ecommerce-db/
├── 📊 BANCO DE DADOS
│   ├── schema.sql          # Estrutura do banco (MySQL)
│   ├── schema_sqlite.sql   # Estrutura do banco (SQLite)
│   ├── seed.sql           # Dados de teste (MySQL)
│   ├── seed_sqlite.sql    # Dados de teste (SQLite)
│   ├── queries.sql        # Consultas de exemplo
│   ├── demo.sql           # Script de demonstração
│   └── ecommerce.db       # Banco SQLite (gerado)
├── 🌐 FRONTEND
│   ├── templates/
│   │   └── index.html     # Interface principal
│   └── static/
│       ├── style.css      # Estilos CSS
│       └── script.js      # JavaScript
├── 🔧 BACKEND
│   └── app.py             # Servidor Flask + API
├── 📚 DOCUMENTAÇÃO
│   ├── README.md          # Este arquivo
│   └── EXECUTAR.md        # Instruções de execução
└── 📋 EXTRAS
    └── requirements.txt   # Dependências Python
```

## 📊 Modelo de Dados

### Entidades Principais

#### 👥 Cliente
- Suporte para Pessoa Física (PF) e Pessoa Jurídica (PJ)
- Campos: ID, nome, tipo, CPF/CNPJ, email, telefone
- Relacionamento 1:N com Endereços e Pedidos

#### 📍 Endereco
- Múltiplos endereços por cliente
- Tipos: Residencial, Comercial, Entrega
- Campos completos de localização

#### 🏭 Fornecedor
- Informações completas dos fornecedores
- Relacionamento 1:N com Produtos

#### 📦 Produto
- Catálogo completo com categorias
- Controle de estoque e preços
- SKU único e informações físicas

#### 🛍️ Pedido
- Status completo do pedido
- Rastreamento de entrega
- Relacionamento com Cliente e Endereço

#### 📋 ItemPedido
- Itens que compõem cada pedido
- Cálculo automático de subtotais
- Suporte a descontos

#### 💳 Pagamento
- Múltiplas formas de pagamento
- Status de aprovação
- Rastreamento de transações

#### 📈 Estoque_Historico
- Auditoria completa de movimentações
- Controle de entrada, saída e ajustes

### 🔗 Relacionamentos

- **Cliente** 1:N **Endereco**
- **Cliente** 1:N **Pedido**
- **Fornecedor** 1:N **Produto**
- **Categoria** 1:N **Produto**
- **Pedido** 1:N **ItemPedido**
- **Produto** 1:N **ItemPedido**
- **Pedido** 1:N **Pagamento**
- **Produto** 1:N **Estoque_Historico**

## 🚀 Como Executar o Projeto

### 📋 Pré-requisitos
- Python 3.7+ instalado
- SQLite (já incluído no Python)
- Navegador web moderno

### 🔧 Instalação e Execução

#### 1. **Instalar dependências Python:**
```bash
pip install flask flask-cors
```

#### 2. **Criar e popular o banco de dados:**
```bash
# Criar estrutura do banco
sqlite3 ecommerce.db < schema_sqlite.sql

# Popular com dados de teste
sqlite3 ecommerce.db < seed_sqlite.sql
```

#### 3. **Iniciar o servidor:**
```bash
python app.py
```

#### 4. **Acessar o dashboard:**
- Abra seu navegador em: **http://localhost:5000**
- 🎉 **Pronto!** O dashboard estará funcionando

### 💻 Funcionalidades do Dashboard

- 📊 **Visão Geral:** Estatísticas e gráficos interativos
- 📦 **Produtos:** Lista completa com categorias e estoque
- 👥 **Clientes:** Cadastro de clientes com endereços
- 🛒 **Pedidos:** Histórico de pedidos com detalhes
- 📈 **Relatórios:** Vendas por categoria, produtos mais vendidos, etc.

### 🗄️ Execução apenas do Banco (sem interface)

#### Para MySQL:
```sql
-- Criar estrutura
mysql -u usuario -p < schema.sql

-- Popular dados
mysql -u usuario -p ecommerce_db < seed.sql

-- Executar consultas
mysql -u usuario -p ecommerce_db < queries.sql
```

#### Para SQLite:
```bash
# Executar demonstração completa
sqlite3 ecommerce.db < demo.sql
```

## 📊 Funcionalidades Implementadas

### ✅ Consultas Básicas
- Recuperação simples com SELECT
- Filtros com WHERE
- Ordenação com ORDER BY

### ✅ Consultas Avançadas
- Atributos derivados (cálculos)
- Agrupamentos com GROUP BY
- Condições de grupo com HAVING
- Junções complexas (INNER, LEFT, RIGHT JOIN)

### ✅ Recursos Especiais
- **Triggers**: Atualização automática de valores e controle de estoque
- **Views**: Consultas pré-definidas para relatórios
- **Índices**: Otimização de performance
- **Constraints**: Validação de dados

### ✅ Análises Disponíveis
- Ranking de produtos mais vendidos
- Análise de clientes mais valiosos (RFM)
- Relatórios de vendas por período
- Controle de estoque e movimentações
- Análise de conversão de pagamentos

## 📈 Exemplos de Consultas

### Clientes Pessoa Física
```sql
SELECT nome, email, telefone 
FROM Cliente 
WHERE tipo = 'PF';
```

### Produtos com Estoque Baixo
```sql
SELECT nome, estoque, estoque_minimo 
FROM Produto 
WHERE estoque <= estoque_minimo;
```

### Total de Vendas por Cliente
```sql
SELECT 
    c.nome,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS valor_total_gasto
FROM Cliente c
JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome
HAVING COUNT(p.pedido_id) > 1;
```

### Produtos Mais Vendidos
```sql
SELECT 
    pr.nome,
    SUM(ip.quantidade) AS total_vendido,
    SUM(ip.subtotal) AS receita_total
FROM Produto pr
JOIN ItemPedido ip ON pr.produto_id = ip.produto_id
GROUP BY pr.produto_id, pr.nome
ORDER BY total_vendido DESC;
```

## 🔧 Recursos Técnicos

### Triggers Implementados
- **tr_atualiza_valor_pedido**: Atualiza automaticamente o valor total do pedido
- **tr_controla_estoque**: Controla automaticamente o estoque e registra histórico

### Views Criadas
- **vw_relatorio_vendas**: Relatório completo de vendas
- **vw_estoque_baixo**: Produtos com estoque abaixo do mínimo

### Índices para Performance
- Índices em chaves estrangeiras
- Índices em campos de busca frequente
- Índices compostos para consultas complexas

## 📊 Dados de Teste Incluídos

- **10 Clientes** (6 PF + 4 PJ)
- **20 Produtos** distribuídos em 6 categorias
- **5 Fornecedores** ativos
- **10 Pedidos** com diferentes status
- **Múltiplos itens** por pedido
- **Pagamentos** com diferentes métodos
- **Histórico de estoque** com movimentações

## 🎯 Cenários de Teste

### Casos de Uso Cobertos
1. **Cadastro de Clientes PF e PJ**
2. **Gestão de Produtos e Categorias**
3. **Processo Completo de Pedidos**
4. **Múltiplas Formas de Pagamento**
5. **Controle de Estoque Automatizado**
6. **Relatórios Gerenciais**
7. **Análises de Vendas**

### Validações Implementadas
- CPF/CNPJ únicos
- Preços sempre positivos
- Estoque não negativo
- Relacionamentos íntegros
- Status válidos para pedidos e pagamentos

## 📋 Requisitos Atendidos

### ✅ Modelagem Lógica
- [x] Entidades bem definidas
- [x] Relacionamentos corretos
- [x] Chaves primárias e estrangeiras
- [x] Normalização adequada

### ✅ Consultas SQL
- [x] SELECT simples e complexo
- [x] WHERE com múltiplas condições
- [x] ORDER BY em diferentes campos
- [x] GROUP BY e HAVING
- [x] JOINs (INNER, LEFT, RIGHT)
- [x] Atributos derivados
- [x] Subconsultas
- [x] Funções agregadas

### ✅ Funcionalidades Avançadas
- [x] Triggers para automação
- [x] Views para relatórios
- [x] Índices para performance
- [x] Constraints para validação
- [x] Histórico de auditoria

## 🛠️ Tecnologias Utilizadas

### Backend
- **Python 3.7+** - Linguagem principal
- **Flask** - Framework web minimalista
- **SQLite** - Banco de dados leve e eficiente
- **Flask-CORS** - Habilitação de CORS para API

### Frontend
- **HTML5** - Estrutura da página
- **CSS3** - Estilização moderna e responsiva
- **JavaScript ES6+** - Interatividade e requisições AJAX
- **Bootstrap 5** - Framework CSS responsivo
- **Chart.js** - Gráficos interativos
- **Font Awesome** - Ícones vetoriais

### Banco de Dados
- **SQLite** - Versão principal (portável)
- **MySQL** - Versão alternativa (produção)
- **Triggers** - Automação de processos
- **Views** - Consultas otimizadas
- **Indexes** - Performance de consultas

## 📊 Estatísticas do Projeto

- **8 Tabelas** principais
- **15 Produtos** de exemplo
- **10 Clientes** cadastrados
- **8 Pedidos** com itens
- **5 Categorias** de produtos
- **3 Triggers** automáticos
- **2 Views** para relatórios
- **10+ Consultas** complexas

## 🎯 Próximos Passos

- [ ] **Autenticação**: Sistema de login e permissões
- [ ] **Carrinho**: Funcionalidade de carrinho de compras
- [ ] **Checkout**: Processo completo de finalização
- [ ] **Notificações**: Sistema de alertas em tempo real
- [ ] **Mobile App**: Aplicativo móvel React Native
- [ ] **Deploy**: Hospedagem em nuvem (Heroku/AWS)

## 📞 Contato

**João Castelo de Sousa Ferreira**
- 📧 **Email:** [seu-email@exemplo.com]
- 💼 **LinkedIn:** [linkedin.com/in/joao-castelo]
- 🐙 **GitHub:** [github.com/joaocastelo]
- 🌐 **Portfolio:** [seuportfolio.com]

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

*⭐ Se este projeto foi útil para você, considere dar uma estrela no repositório!*

**Desenvolvido com ❤️ por João Castelo de Sousa Ferreira**
