-- schema.sql
-- Criação da estrutura do banco de dados BitVerso_BD

CREATE DATABASE BitVerso_BD;
USE BitVerso_BD;

CREATE TABLE Endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(150) NOT NULL,
    bairro VARCHAR(120) NOT NULL,
    numero VARCHAR(10), 
    cidade VARCHAR(150) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    pais VARCHAR(50) NOT NULL
);   

CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL, 
    email VARCHAR(50) UNIQUE NOT NULL,
    codigo_acesso VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(20) UNIQUE NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_endereco INT,
    FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco)
);

CREATE TABLE Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(80) NOT NULL
);  

CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    valor_produto DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);  

CREATE TABLE Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    status_pedido VARCHAR(100),
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE ItensPedidos (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    data_pagamento DATE NOT NULL,
    valor_pagamento DECIMAL(10,2) NOT NULL,
    tipo_pagamento VARCHAR(50) NOT NULL,
    status_pagamento VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);  

CREATE TABLE Entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_endereco INT NOT NULL,
    status_entrega VARCHAR(30) NOT NULL,
    data_envio DATE NOT NULL,
    data_entrega DATE,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco)
);
