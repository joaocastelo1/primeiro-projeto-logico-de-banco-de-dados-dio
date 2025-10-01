#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Servidor HTTP simples para demonstração
"""

import http.server
import socketserver
import os
import webbrowser
from urllib.parse import urlparse, parse_qs
import json
import sqlite3

PORT = 8000

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.path = '/templates/index.html'
        elif self.path.startswith('/api/'):
            self.handle_api_request()
            return
        return http.server.SimpleHTTPRequestHandler.do_GET(self)
    
    def handle_api_request(self):
        try:
            if self.path == '/api/stats':
                data = self.get_stats()
            elif self.path == '/api/products':
                data = self.get_products()
            elif self.path == '/api/clients':
                data = self.get_clients()
            elif self.path == '/api/orders':
                data = self.get_orders()
            else:
                data = {"error": "Endpoint não encontrado"}
            
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(data, ensure_ascii=False).encode('utf-8'))
        except Exception as e:
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"error": str(e)}).encode('utf-8'))
    
    def get_stats(self):
        conn = sqlite3.connect('ecommerce.db')
        conn.row_factory = sqlite3.Row
        
        stats = {}
        stats['total_clientes'] = conn.execute('SELECT COUNT(*) as count FROM Cliente').fetchone()['count']
        stats['total_produtos'] = conn.execute('SELECT COUNT(*) as count FROM Produto').fetchone()['count']
        stats['total_pedidos'] = conn.execute('SELECT COUNT(*) as count FROM Pedido').fetchone()['count']
        stats['receita_total'] = conn.execute('SELECT COALESCE(SUM(total), 0) as total FROM Pedido').fetchone()['total']
        
        conn.close()
        return stats
    
    def get_products(self):
        conn = sqlite3.connect('ecommerce.db')
        conn.row_factory = sqlite3.Row
        
        produtos = conn.execute('''
            SELECT p.nome, c.nome as categoria, p.preco, p.estoque, f.nome as fornecedor
            FROM Produto p
            JOIN Categoria c ON p.categoria_id = c.id
            JOIN Fornecedor f ON p.fornecedor_id = f.id
            ORDER BY p.nome
        ''').fetchall()
        
        conn.close()
        return [dict(row) for row in produtos]
    
    def get_clients(self):
        conn = sqlite3.connect('ecommerce.db')
        conn.row_factory = sqlite3.Row
        
        clientes = conn.execute('''
            SELECT c.nome, c.email, c.telefone, c.tipo,
                   e.cidade
            FROM Cliente c
            LEFT JOIN Endereco e ON c.id = e.cliente_id
            ORDER BY c.nome
        ''').fetchall()
        
        conn.close()
        return [dict(row) for row in clientes]
    
    def get_orders(self):
        conn = sqlite3.connect('ecommerce.db')
        conn.row_factory = sqlite3.Row
        
        pedidos = conn.execute('''
            SELECT p.id, c.nome as cliente, p.data_pedido, p.total, p.status
            FROM Pedido p
            JOIN Cliente c ON p.cliente_id = c.id
            ORDER BY p.data_pedido DESC
        ''').fetchall()
        
        conn.close()
        return [dict(row) for row in pedidos]

if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
        print(f"🚀 Servidor iniciado na porta {PORT}")
        print(f"📊 Dashboard disponível em: http://localhost:{PORT}")
        print(f"👤 Desenvolvido por: João Castelo de Sousa Ferreira")
        print("🔄 Pressione Ctrl+C para parar o servidor")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n🛑 Servidor parado pelo usuário")
            httpd.shutdown()