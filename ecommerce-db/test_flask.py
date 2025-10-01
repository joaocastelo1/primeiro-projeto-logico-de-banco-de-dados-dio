#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Teste simples do Flask
"""

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return '<h1>🚀 Flask está funcionando!</h1><p>Servidor de teste ativo.</p>'

if __name__ == '__main__':
    print("🔥 Iniciando servidor de teste Flask...")
    print("📍 Acesse: http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000)