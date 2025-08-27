DROP DATABASE IF EXISTS db_revenda_luis;
CREATE DATABASE db_revenda_luis;
\c db_revenda_luis;

drop table pedido

CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(15),
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE fornecedor (
    fornecedor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(15),
    cidade VARCHAR(50)
);

CREATE TABLE produto (
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria_produto VARCHAR(50) NOT NULL,
    preco NUMERIC(10,2) CHECK (preco > 0),
    estoque INT DEFAULT 0 CHECK (estoque >= 0),
    fornecedor_id INT REFERENCES fornecedor(fornecedor_id)
);

CREATE TABLE funcionario (
    funcionario_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario NUMERIC(10,2) CHECK (salario >= 1320),
    email VARCHAR(100) UNIQUE,
    data_contratacao DATE DEFAULT CURRENT_DATE
);

CREATE TABLE pedido (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES cliente(cliente_id),
    funcionario_id INT NOT NULL REFERENCES funcionario(funcionario_id),
    data_pedido DATE DEFAULT CURRENT_DATE,
    valor_total NUMERIC(10,2) CHECK (valor_total >= 0),
    status VARCHAR(20) DEFAULT 'Em aberto'
);

CREATE TABLE pedido_produto (
    pedido_id INT NOT NULL REFERENCES pedido(pedido_id),
    produto_id INT NOT NULL REFERENCES produto(produto_id),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (pedido_id, produto_id)
);

CREATE VIEW vw_pedidos_clientes AS
SELECT p.pedido_id, c.nome AS cliente, p.data_pedido, p.valor_total, p.status
FROM pedido p
JOIN cliente c ON p.cliente_id = c.cliente_id;

CREATE VIEW vw_produtos_fornecedores AS
SELECT pr.nome AS produto, pr.categoria_produto AS categoria, pr.preco, pr.estoque, f.nome AS fornecedor
FROM produto pr
JOIN fornecedor f ON pr.fornecedor_id = f.fornecedor_id;

INSERT INTO cliente (nome, cpf, email, telefone) VALUES
('João Silva', '12345678901', 'joao@email.com', '11999990001'),
('Maria Souza', '23456789012', 'maria@email.com', '11999990002'),
('Carlos Lima', '34567890123', 'carlos@email.com', '11999990003'),
('Fernanda Alves', '45678901234', 'fernanda@email.com', '11999990004'),
('Rafael Costa', '56789012345', 'rafael@email.com', '11999990005'),
('Juliana Pereira', '67890123456', 'juliana@email.com', '11999990006'),
('Pedro Gomes', '78901234567', 'pedro@email.com', '11999990007'),
('Ana Oliveira', '89012345678', 'ana@email.com', '11999990008'),
('Lucas Fernandes', '90123456789', 'lucas@email.com', '11999990009'),
('Beatriz Santos', '01234567890', 'bia@email.com', '11999990010');

INSERT INTO fornecedor (nome, cnpj, email, telefone, cidade) VALUES
('Yamaha Brasil', '11111111000199', 'contato@yamaha.com', '1133334444', 'São Paulo'),
('Fender Music', '22222222000188', 'contato@fender.com', '1144445555', 'Curitiba'),
('Tagima Guitars', '33333333000177', 'vendas@tagima.com', '1155556666', 'Sorocaba'),
('Pearl Drums', '44444444000166', 'drums@pearl.com', '1166667777', 'Rio de Janeiro'),
('Casio Music', '55555555000155', 'info@casio.com', '1177778888', 'São Paulo'),
('Roland Brasil', '66666666000144', 'roland@roland.com', '1188889999', 'Campinas'),
('Ibanez Music', '77777777000133', 'ibanez@ibanez.com', '1199990000', 'Belo Horizonte'),
('Hering Harmonicas', '88888888000122', 'hering@hering.com', '1171717171', 'Blumenau'),
('Korg Brasil', '99999999000111', 'korg@korg.com', '1145454545', 'São Paulo'),
('Gibson Music', '10101010000100', 'gibson@gibson.com', '1198989898', 'Porto Alegre');

INSERT INTO produto (nome, categoria_produto, preco, estoque, fornecedor_id) VALUES
('Violão Tagima', 'Corda', 800.00, 15, 3),
('Guitarra Fender Stratocaster', 'Corda', 6500.00, 5, 2),
('Bateria Pearl Export', 'Percussão', 7000.00, 3, 4),
('Teclado Casio CTK', 'Teclado', 1800.00, 8, 5),
('Amplificador Roland', 'Eletrônico', 2500.00, 6, 6),
('Baixo Ibanez GSR200', 'Corda', 2200.00, 4, 7),
('Gaita Hering', 'Sopro', 200.00, 20, 8),
('Piano Yamaha P125', 'Teclado', 4800.00, 2, 1),
('Sintetizador Korg', 'Teclado', 5200.00, 3, 9),
('Guitarra Gibson Les Paul', 'Corda', 12000.00, 2, 10);

INSERT INTO funcionario (nome, cargo, salario, email) VALUES
('Marcos Rocha', 'Vendedor', 2000.00, 'marcos@email.com'),
('Paula Mendes', 'Gerente', 5000.00, 'paula@email.com'),
('Ricardo Silva', 'Caixa', 1800.00, 'ricardo@email.com'),
('Fernanda Costa', 'Estoquista', 1700.00, 'fernanda@email.com');

SELECT produto_id, nome, preco
FROM produto
WHERE nome LIKE 'Guitarra%';

EXPLAIN SELECT produto_id, nome, preco FROM produto WHERE nome LIKE 'Guitarra%';

CREATE INDEX idx_produto_nome_pattern
ON produto (nome text_pattern_ops);

EXPLAIN SELECT produto_id, nome, preco FROM produto WHERE nome LIKE 'Guitarra%';

ALTER TABLE cliente ALTER COLUMN telefone TYPE INT USING telefone::INT;
ALTER TABLE cliente ALTER COLUMN telefone TYPE BIGINT USING telefone::BIGINT;
ALTER TABLE cliente ALTER COLUMN telefone TYPE VARCHAR(15) USING telefone::TEXT;
ALTER TABLE produto ALTER COLUMN estoque TYPE VARCHAR(10) USING estoque::TEXT;

CREATE ROLE luis WITH LOGIN PASSWORD 'senha';
GRANT CONNECT ON DATABASE db_revenda_luis TO luis;
GRANT USAGE, CREATE ON SCHEMA public TO luis;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO luis;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO luis;

CREATE ROLE colega WITH LOGIN PASSWORD 'senha';
GRANT CONNECT ON DATABASE db_revenda_luis TO colega;
GRANT USAGE ON SCHEMA public TO colega;
GRANT SELECT ON TABLE produto TO colega;

SELECT p.pedido_id, c.nome, p.data_pedido, p.status FROM pedido p INNER JOIN cliente c ON p.cliente_id = c.cliente_id;
SELECT p.pedido_id, c.nome, p.data_pedido, p.status FROM pedido p LEFT JOIN cliente c ON p.cliente_id = c.cliente_id;
SELECT p.pedido_id, c.nome, p.data_pedido, p.status FROM pedido p RIGHT JOIN cliente c ON p.cliente_id = c.cliente_id;

SELECT pp.pedido_id, pp.produto_id, pp.quantidade FROM pedido p INNER JOIN pedido_produto pp ON pp.pedido_id = p.pedido_id;
SELECT pp.pedido_id, pp.produto_id, pp.quantidade FROM pedido p LEFT JOIN pedido_produto pp ON pp.pedido_id = p.pedido_id;
SELECT pp.pedido_id, pp.produto_id, pp.quantidade FROM pedido p RIGHT JOIN pedido_produto pp ON pp.pedido_id = p.pedido_id;

SELECT pp.pedido_id, pr.nome, pp.quantidade, pr.preco FROM pedido_produto pp INNER JOIN produto pr ON pr.produto_id = pp.produto_id;
SELECT pp.pedido_id, pr.nome, pp.quantidade, pr.preco FROM pedido_produto pp LEFT JOIN produto pr ON pr.produto_id = pp.produto_id;
SELECT pp.pedido_id, pr.nome, pp.quantidade, pr.preco FROM pedido_produto pp RIGHT JOIN produto pr ON pr.produto_id = pp.produto_id;

SELECT pr.produto_id, pr.nome, f.nome AS fornecedor FROM produto pr INNER JOIN fornecedor f ON f.fornecedor_id = pr.fornecedor_id;
SELECT pr.produto_id, pr.nome, f.nome AS fornecedor FROM produto pr LEFT JOIN fornecedor f ON f.fornecedor_id = pr.fornecedor_id;
SELECT pr.produto_id, pr.nome, f.nome AS fornecedor FROM produto pr RIGHT JOIN fornecedor f ON f.fornecedor_id = pr.fornecedor_id;

UPDATE cliente SET telefone = NULL WHERE cliente_id IN (2, 5, 9);
UPDATE produto SET fornecedor_id = NULL WHERE produto_id IN (3, 7);
UPDATE fornecedor SET email = NULL WHERE fornecedor_id IN (4, 8);
