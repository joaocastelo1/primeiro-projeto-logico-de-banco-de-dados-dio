/**
 * Sistema E-commerce - Frontend JavaScript
 * Autor: João Castelo de Sousa Ferreira
 * Descrição: Funcionalidades dinâmicas do dashboard
 */

// Variáveis globais
let currentTab = 'overview';
let charts = {};

// Inicialização quando a página carrega
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 Dashboard E-commerce iniciado!');
    hideLoading();
    loadStats();
    setupTabListeners();
    loadProducts();
    loadClients();
    loadOrders();
});

// Função para esconder o loading
function hideLoading() {
    const loading = document.getElementById('loading');
    if (loading) {
        loading.style.display = 'none';
    }
}

// Configurar listeners das abas
function setupTabListeners() {
    const tabButtons = document.querySelectorAll('.nav-link');
    tabButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const tabId = this.getAttribute('href').substring(1);
            switchTab(tabId);
        });
    });
}

// Trocar aba ativa
function switchTab(tabId) {
    // Remover classe ativa de todas as abas
    document.querySelectorAll('.nav-link').forEach(tab => {
        tab.classList.remove('active');
    });
    document.querySelectorAll('.tab-pane').forEach(pane => {
        pane.classList.remove('show', 'active');
    });

    // Ativar aba selecionada
    document.querySelector(`[href="#${tabId}"]`).classList.add('active');
    document.getElementById(tabId).classList.add('show', 'active');
    
    currentTab = tabId;
    
    // Carregar dados específicos da aba
    if (tabId === 'overview') {
        loadStats();
    }
}

// Carregar estatísticas gerais
async function loadStats() {
    try {
        const response = await fetch('/api/stats');
        const stats = await response.json();
        
        // Atualizar cards de estatísticas
        updateStatsCards(stats);
        
        // Carregar gráficos
        loadCharts();
        
    } catch (error) {
        console.error('Erro ao carregar estatísticas:', error);
        showError('Erro ao carregar estatísticas');
    }
}

// Atualizar cards de estatísticas
function updateStatsCards(stats) {
    const elements = {
        'total-clientes': stats.total_clientes || 0,
        'total-produtos': stats.total_produtos || 0,
        'total-pedidos': stats.total_pedidos || 0,
        'receita-total': formatCurrency(stats.receita_total || 0)
    };
    
    Object.entries(elements).forEach(([id, value]) => {
        const element = document.getElementById(id);
        if (element) {
            element.textContent = value;
        }
    });
}

// Carregar gráficos
async function loadCharts() {
    try {
        // Gráfico de vendas por categoria
        const salesResponse = await fetch('/api/sales-by-category');
        const salesData = await salesResponse.json();
        createCategoryChart(salesData);
        
        // Gráfico de vendas mensais
        const monthlyResponse = await fetch('/api/monthly-sales');
        const monthlyData = await monthlyResponse.json();
        createMonthlyChart(monthlyData);
        
    } catch (error) {
        console.error('Erro ao carregar gráficos:', error);
    }
}

// Criar gráfico de vendas por categoria
function createCategoryChart(data) {
    const ctx = document.getElementById('categoryChart');
    if (!ctx) return;
    
    if (charts.category) {
        charts.category.destroy();
    }
    
    charts.category = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: data.map(item => item.categoria),
            datasets: [{
                data: data.map(item => item.total_vendas),
                backgroundColor: [
                    '#FF6384',
                    '#36A2EB',
                    '#FFCE56',
                    '#4BC0C0',
                    '#9966FF'
                ]
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
}

// Criar gráfico de vendas mensais
function createMonthlyChart(data) {
    const ctx = document.getElementById('monthlyChart');
    if (!ctx) return;
    
    if (charts.monthly) {
        charts.monthly.destroy();
    }
    
    charts.monthly = new Chart(ctx, {
        type: 'line',
        data: {
            labels: data.map(item => item.mes),
            datasets: [{
                label: 'Vendas (R$)',
                data: data.map(item => item.total_vendas),
                borderColor: '#36A2EB',
                backgroundColor: 'rgba(54, 162, 235, 0.1)',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return formatCurrency(value);
                        }
                    }
                }
            }
        }
    });
}

// Carregar produtos
async function loadProducts() {
    try {
        const response = await fetch('/api/products');
        const products = await response.json();
        
        const tbody = document.querySelector('#products tbody');
        if (!tbody) return;
        
        tbody.innerHTML = products.map(product => `
            <tr>
                <td>${product.nome}</td>
                <td>${product.categoria}</td>
                <td>${formatCurrency(product.preco)}</td>
                <td>
                    <span class="badge ${product.estoque < 10 ? 'bg-danger' : 'bg-success'}">
                        ${product.estoque}
                    </span>
                </td>
                <td>${product.fornecedor}</td>
            </tr>
        `).join('');
        
    } catch (error) {
        console.error('Erro ao carregar produtos:', error);
    }
}

// Carregar clientes
async function loadClients() {
    try {
        const response = await fetch('/api/clients');
        const clients = await response.json();
        
        const tbody = document.querySelector('#clients tbody');
        if (!tbody) return;
        
        tbody.innerHTML = clients.map(client => `
            <tr>
                <td>${client.nome}</td>
                <td>${client.email}</td>
                <td>${client.telefone || 'N/A'}</td>
                <td>
                    <span class="badge ${client.tipo === 'PF' ? 'bg-primary' : 'bg-info'}">
                        ${client.tipo}
                    </span>
                </td>
                <td>${client.cidade || 'N/A'}</td>
            </tr>
        `).join('');
        
    } catch (error) {
        console.error('Erro ao carregar clientes:', error);
    }
}

// Carregar pedidos
async function loadOrders() {
    try {
        const response = await fetch('/api/orders');
        const orders = await response.json();
        
        const tbody = document.querySelector('#orders tbody');
        if (!tbody) return;
        
        tbody.innerHTML = orders.map(order => `
            <tr>
                <td>#${order.id}</td>
                <td>${order.cliente}</td>
                <td>${formatDate(order.data_pedido)}</td>
                <td>${formatCurrency(order.total)}</td>
                <td>
                    <span class="badge ${getStatusBadge(order.status)}">
                        ${order.status}
                    </span>
                </td>
                <td>
                    <button class="btn btn-sm btn-outline-primary" onclick="showOrderDetails(${order.id})">
                        <i class="fas fa-eye"></i> Ver
                    </button>
                </td>
            </tr>
        `).join('');
        
    } catch (error) {
        console.error('Erro ao carregar pedidos:', error);
    }
}

// Mostrar detalhes do pedido
async function showOrderDetails(orderId) {
    try {
        const response = await fetch(`/api/orders/${orderId}`);
        const order = await response.json();
        
        // Preencher modal com detalhes
        document.getElementById('orderModalLabel').textContent = `Pedido #${order.id}`;
        document.getElementById('orderDetails').innerHTML = `
            <div class="row">
                <div class="col-md-6">
                    <h6>Informações do Cliente</h6>
                    <p><strong>Nome:</strong> ${order.cliente}</p>
                    <p><strong>Email:</strong> ${order.email}</p>
                    <p><strong>Telefone:</strong> ${order.telefone || 'N/A'}</p>
                </div>
                <div class="col-md-6">
                    <h6>Informações do Pedido</h6>
                    <p><strong>Data:</strong> ${formatDate(order.data_pedido)}</p>
                    <p><strong>Status:</strong> <span class="badge ${getStatusBadge(order.status)}">${order.status}</span></p>
                    <p><strong>Total:</strong> ${formatCurrency(order.total)}</p>
                </div>
            </div>
            <hr>
            <h6>Itens do Pedido</h6>
            <div class="table-responsive">
                <table class="table table-sm">
                    <thead>
                        <tr>
                            <th>Produto</th>
                            <th>Quantidade</th>
                            <th>Preço Unit.</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${order.itens.map(item => `
                            <tr>
                                <td>${item.produto}</td>
                                <td>${item.quantidade}</td>
                                <td>${formatCurrency(item.preco_unitario)}</td>
                                <td>${formatCurrency(item.subtotal)}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        `;
        
        // Mostrar modal
        const modal = new bootstrap.Modal(document.getElementById('orderModal'));
        modal.show();
        
    } catch (error) {
        console.error('Erro ao carregar detalhes do pedido:', error);
        showError('Erro ao carregar detalhes do pedido');
    }
}

// Funções utilitárias
function formatCurrency(value) {
    return new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL'
    }).format(value);
}

function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('pt-BR');
}

function getStatusBadge(status) {
    const badges = {
        'Pendente': 'bg-warning',
        'Processando': 'bg-info',
        'Enviado': 'bg-primary',
        'Entregue': 'bg-success',
        'Cancelado': 'bg-danger'
    };
    return badges[status] || 'bg-secondary';
}

function showError(message) {
    console.error(message);
    // Aqui você pode implementar um sistema de notificações
    alert(message);
}

// Função para atualizar dados (pode ser chamada periodicamente)
function refreshData() {
    if (currentTab === 'overview') {
        loadStats();
    } else if (currentTab === 'products') {
        loadProducts();
    } else if (currentTab === 'clients') {
        loadClients();
    } else if (currentTab === 'orders') {
        loadOrders();
    }
}

// Atualizar dados a cada 30 segundos
setInterval(refreshData, 30000);

console.log('✅ Script do dashboard carregado com sucesso!');