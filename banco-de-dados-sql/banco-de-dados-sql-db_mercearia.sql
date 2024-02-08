create database db_mercearia
go

use db_mercearia
go


--Criando as tabelas

--tabela fornecedores

create table fornecedores(
id_fornecedor int primary key identity(1,1),
nome varchar(255),
endereco varchar(255),
);

--Tabela categoria

create table categorias(
id_categoria int primary key identity(1,1),
nome varchar(255)
);

--Tabela Produtos

create table produtos(
id_produto int primary key identity(1,1),
nome varchar(255),
preco decimal(10,2),
id_categoria int, 
id_fornecedor int, 
foreign key(id_categoria) references categorias(id_categoria),
foreign key (id_fornecedor) references fornecedores(id_fornecedor)
);

--Tabela estoque
create table estoques(
id_estoque int primary key identity(1,1),
quantidade int,
id_produto int,
foreign key(id_produto) references produtos(id_produto)
);

--Populando nosso banco

INSERT INTO categorias (nome) VALUES 
('Alimentos'),
('Higiene Pessoal'),
('Limpeza'),
('Açougue');

-- Populando a tabela Fornecedores
INSERT INTO fornecedores (nome, endereco) VALUES 
('P&G Distribuidora', 'Rua A, 123'),
('Val Alimentos', 'Avenida B, 456'),
('Ypê Distribuidora', 'Rua C, 789'),
('Sadia BRF', 'Avenida D, 101');

-- Populando a tabela Produtos
INSERT INTO produtos (nome, preco, id_categoria, id_fornecedor) VALUES 
('Refrigerante', 4.50, 1, 2),
('Paleta', 15.99, 4, 4),
('Maçã', 2.50, 1, 2),
('Leite', 3.75, 1, 2),
('Detergente', 1.99, 3, 3),
('Desinfetante', 4.99, 3, 3),
('Água Sanitária', 1.99, 3, 3),
('Amaciante', 7.50, 3, 3),
('Arroz', 6.25, 1, 2),
('Sabonete', 2.20, 2, 1),
('Costela', 17.90, 4, 4),
('Frango', 17.60, 4, 4),
('Papel Higiênico', 8.99, 2, 1),
('Shampoo', 1.75, 2, 1),
('Alface', 1.50, 1, 2);

-- Populando a tabela Estoque
INSERT INTO estoques (quantidade, id_produto) VALUES 
(100, 1),
(50, 2),
(200, 3),
(80, 4),
(150, 5),
(120, 6),
(90, 7),
(200, 8),
(30, 9),
(100, 10),
(30, 11),
(50, 12),
(120, 13),
(40, 14),
(20, 15);


--Consultas

--1Listar todos os produtos

Select *from produtos

--Apresente todos os produtos e preços em ordem alfabética

select nome, preco from produtos order by nome asc

--Atualização do preço do produto arroz

update produtos
set preco = 5.50
where id_produto = 9

--Quantidade de produtos
select
p.nome as nome_produto,
e.quantidade * p.preco as Estoque_Atual
from produtos p
Join
estoques e on p.id_produto = e.id_produto

--Aqui é outra maneira mais completa de dar a quantidade de produtos

select
    p.nome as NomeProduto,
    p.preco as PrecoUnitario,
    e.quantidade as QuantidadeEmEstoque,
    (p.preco * e.quantidade) as ValorTotalEmEstoque
from
    produtos p
JOIN
    estoques e on p.id_produto = e.id_produto;

-- Selecionar nome dos produtos com valor abaixo de 5

select 
	nome
from 
	produtos
where 
	preco < 5


-- Selecionar nome dos produtos com valor acima de 5

select 
	nome
from 
	produtos
where 
	preco > 5


-- Apresentar nome do produto e seu fornecedor (Join)

select
    p.nome as NomeProduto,
    e.nome as NomeFornecedores
from
    produtos p
JOIN
    fornecedores e on p.id_fornecedor = e.id_fornecedor;

-- Contar quantos produtos eu tenho cadastrados na mercearia

select
	p.nome as nome_produto,
	e.quantidade as Estoque_Total
from 
	produtos p
Join
	estoques e on p.id_produto = e.id_produto


-- Apresente os preços em ordem decrescente com os nomes dos produtos

select nome, preco from produtos order by nome desc


-- selecionar nome e fornecedor dos produtos com valor acima de 6
select
    p.nome as NomeProduto,
    f.nome as NomeFornecedores
from
    produtos p
JOIN
    fornecedores f on p.id_fornecedor = f.id_fornecedor
where 
	p.preco > 6
	

-- Selecionar nome dos produtos da P&G

select
    p.nome as NomeProduto,
    f.nome as NomeFornecedora
from
    produtos p
JOIN
    fornecedores f on p.id_fornecedor = f.id_fornecedor
where
	f.nome = 'P&G Distribuidora'

-- Selecionar nome e preço dos produtos da categoria Açougue.

select
    p.nome as NomeProduto,
	p.preco as PrecoProduto,
    c.nome as NomeFornecedora
from
    produtos p
JOIN
    categorias c on p.id_categoria = c.id_categoria
where
	c.nome = 'Açougue';

--Atualizar o valor do preço do Leite para R$ 3,99

update produtos
set preco = 3.99
where id_produto = 4

-- Atualizar a quantidade do valor do produto detergente, uma vez que foram vendidas 20 unidades.

UPDATE estoques
SET quantidade = quantidade - 20
WHERE id_produto = 5

-- Apresentar Quantidade da categoria Açougue

SELECT c.nome AS Categoria, SUM(e.quantidade) AS Quantidade
FROM categorias c
JOIN produtos p ON c.id_categoria = p.id_categoria
JOIN estoques e ON p.id_produto = e.id_produto
WHERE c.nome = 'Açougue'
GROUP BY c.nome


-- Apresentar o Total dos produtos de cada categoria

SELECT c.nome AS Categoria, SUM(e.quantidade) AS Quantidade
FROM categorias c
JOIN produtos p ON c.id_categoria = p.id_categoria
JOIN estoques e ON p.id_produto = e.id_produto
GROUP BY c.nome
