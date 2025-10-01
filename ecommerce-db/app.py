#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Sistema E-commerce - Backend API
Autor: João Castelo de Sousa Ferreira
Descrição: API Flask para conectar frontend com banco SQLite
"""

from flask import Flask, jsonify, render_template, request
from flask_cors import CORS
import sqlite3
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Configuração do banco de dados
DATABASE = 'ecommerce.db'

def get_db_connection():
    """Conecta ao banco de dados SQLite"""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

def dict_factory(cursor, row):
    """Converte linhas do SQLite em dicionários"""
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d

@app.route('/')
def index():
    """Página principal"""
    return render_template('index.html')

@app.route('/api/stats')
def get_stats():
    """Retorna estatísticas gerais do e-commerce"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    stats = {}
    
    # Contadores básicos
    stats['total_clientes'] = conn.execute('SELECT COUNT(*) as count FROM Cliente').fetchone()['count']
    stats['total_produtos'] = conn.execute('SELECT COUNT(*) as count FROM Produto').fetchone()['count']
    stats['total_pedidos'] = conn.execute('SELECT COUNT(*) as count FROM Pedido').fetchone()['count']
    stats['total_fornecedores'] = conn.execute('SELECT COUNT(*) as count FROM Fornecedor').fetchone()['count']
    
    # Receita total
    receita = conn.execute('SELECT SUM(total) as receita FROM Pedido WHERE status = "Entregue"').fetchone()
    stats['receita_total'] = receita['receita'] if receita['receita'] else 0
    
    # Pedidos por status
    pedidos_status = conn.execute('''
        SELECT status, COUNT(*) as count 
        FROM Pedido 
        GROUP BY status
    ''').fetchall()
    stats['pedidos_por_status'] = pedidos_status
    
    conn.close()
    return jsonify(stats)

@app.route('/api/produtos')
def get_produtos():
    """Retorna lista de produtos com categoria"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    produtos = conn.execute('''
        SELECT p.id, p.nome, p.descricao, p.preco, p.estoque,
               c.nome as categoria, f.nome as fornecedor
        FROM Produto p
        JOIN Categoria c ON p.categoria_id = c.id
        JOIN Fornecedor f ON p.fornecedor_id = f.id
        ORDER BY p.nome
    ''').fetchall()
    
    conn.close()
    return jsonify(produtos)

@app.route('/api/clientes')
def get_clientes():
    """Retorna lista de clientes com endereços"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    clientes = conn.execute('''
        SELECT c.id, c.nome, c.email, c.telefone, c.data_cadastro,
               e.rua, e.cidade, e.estado, e.cep
        FROM Cliente c
        LEFT JOIN Endereco e ON c.id = e.cliente_id
        ORDER BY c.nome
    ''').fetchall()
    
    conn.close()
    return jsonify(clientes)

@app.route('/api/pedidos')
def get_pedidos():
    """Retorna lista de pedidos com detalhes"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    pedidos = conn.execute('''
        SELECT p.id, p.data_pedido, p.total, p.status,
               c.nome as cliente_nome, c.email as cliente_email
        FROM Pedido p
        JOIN Cliente c ON p.cliente_id = c.id
        ORDER BY p.data_pedido DESC
    ''').fetchall()
    
    conn.close()
    return jsonify(pedidos)

@app.route('/api/pedido/<int:pedido_id>')
def get_pedido_detalhes(pedido_id):
    """Retorna detalhes de um pedido específico"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    # Dados do pedido
    pedido = conn.execute('''
        SELECT p.id, p.data_pedido, p.total, p.status,
               c.nome as cliente_nome, c.email as cliente_email
        FROM Pedido p
        JOIN Cliente c ON p.cliente_id = c.id
        WHERE p.id = ?
    ''', (pedido_id,)).fetchone()
    
    if not pedido:
        return jsonify({'error': 'Pedido não encontrado'}), 404
    
    # Itens do pedido
    itens = conn.execute('''
        SELECT ip.quantidade, ip.preco_unitario, ip.subtotal,
               pr.nome as produto_nome, pr.descricao as produto_descricao
        FROM ItemPedido ip
        JOIN Produto pr ON ip.produto_id = pr.id
        WHERE ip.pedido_id = ?
    ''', (pedido_id,)).fetchall()
    
    pedido['itens'] = itens
    
    conn.close()
    return jsonify(pedido)

@app.route('/api/vendas-categoria')
def get_vendas_categoria():
    """Retorna vendas por categoria"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    vendas = conn.execute('''
        SELECT c.nome as categoria,
               COUNT(ip.id) as total_itens,
               SUM(ip.quantidade) as quantidade_vendida,
               ROUND(SUM(ip.subtotal), 2) as receita
        FROM Categoria c
        JOIN Produto p ON c.id = p.categoria_id
        JOIN ItemPedido ip ON p.id = ip.produto_id
        JOIN Pedido ped ON ip.pedido_id = ped.id
        WHERE ped.status = 'Entregue'
        GROUP BY c.id, c.nome
        ORDER BY receita DESC
    ''').fetchall()
    
    conn.close()
    return jsonify(vendas)

@app.route('/api/produtos-mais-vendidos')
def get_produtos_mais_vendidos():
    """Retorna produtos mais vendidos"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    produtos = conn.execute('''
        SELECT p.nome, p.preco,
               SUM(ip.quantidade) as total_vendido,
               ROUND(SUM(ip.subtotal), 2) as receita_total
        FROM Produto p
        JOIN ItemPedido ip ON p.id = ip.produto_id
        JOIN Pedido ped ON ip.pedido_id = ped.id
        WHERE ped.status = 'Entregue'
        GROUP BY p.id, p.nome, p.preco
        ORDER BY total_vendido DESC
        LIMIT 10
    ''').fetchall()
    
    conn.close()
    return jsonify(produtos)

@app.route('/api/vendas-mensais')
def get_vendas_mensais():
    """Retorna vendas por mês"""
    conn = get_db_connection()
    conn.row_factory = dict_factory
    
    vendas = conn.execute('''
        SELECT strftime('%Y-%m', data_pedido) as mes,
               COUNT(*) as total_pedidos,
               ROUND(SUM(total), 2) as receita_total
        FROM Pedido
        WHERE status = 'Entregue'
        GROUP BY strftime('%Y-%m', data_pedido)
        ORDER BY mes
    ''').fetchall()
    
    conn.close()
    return jsonify(vendas)

if __name__ == '__main__':
    # Verifica se o banco de dados existe
    if not os.path.exists(DATABASE):
        print(f"Erro: Banco de dados '{DATABASE}' não encontrado!")
        print("Execute primeiro os scripts schema_sqlite.sql e seed_sqlite.sql")
        exit(1)
    
    print("🚀 Servidor E-commerce iniciado!")
    print("📊 Dashboard disponível em: http://localhost:5000")
    print("🔗 API endpoints disponíveis em: http://localhost:5000/api/")
    print("👤 Desenvolvido por: João Castelo de Sousa Ferreira")
    print("🔄 Iniciando servidor Flask...")
    
    try:
        app.run(debug=False, host='127.0.0.1', port=5000, threaded=True)
    except Exception as e:
        print(f"❌ Erro ao iniciar servidor: {e}")
        import traceback
        traceback.print_exc()