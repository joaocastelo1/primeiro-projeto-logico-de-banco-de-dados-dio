#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Servidor simples para o projeto E-commerce
"""

import http.server
import socketserver
import os
import sys

PORT = 8080

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.path = '/templates/index.html'
        return super().do_GET()

def main():
    # Muda para o diretório do script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    
    print("=" * 60)
    print("🚀 SERVIDOR E-COMMERCE DASHBOARD")
    print("=" * 60)
    print(f"📂 Diretório: {script_dir}")
    print(f"🌐 Porta: {PORT}")
    print(f"🔗 URL: http://localhost:{PORT}")
    print(f"📊 Dashboard: http://localhost:{PORT}/templates/index.html")
    print("=" * 60)
    print("👤 Desenvolvido por: João Castelo de Sousa Ferreira")
    print("🔄 Pressione Ctrl+C para parar o servidor")
    print("=" * 60)
    
    try:
        with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
            print(f"✅ Servidor iniciado com sucesso!")
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Servidor parado pelo usuário")
    except Exception as e:
        print(f"❌ Erro: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()