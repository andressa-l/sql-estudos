-- Criando o banco de dados PRODUCAOBD.
create database producaobd 
go

use producaobd 
go

-- Criando a tabela FABRICANTE.
create table fabricante (
cod_fabricante smallint primary key identity(1,1),
nome_fabricante varchar(30)
);

-- Criando a tabela PRODUTO.
create table produto (
cod_produto int primary key identity(1,1),
nome_produto varchar(30),
cod_fabricante smallint,
constraint fk_Produto_Fabricante
foreign key (cod_fabricante) references fabricante (cod_fabricante));

-- Adicionando uma coluna na tabela PRODUTO.
ALTER TABLE produto
ADD descricao_produto varchar(100);

-- Criando a tabela LOTE.
CREATE TABLE lote (
numlote int primary key identity(1,1),
datavalidade date check (datavalidade > getdate()),
precounitario decimal(10,2) check (precounitario > 0),
quantidade smallint default 100 check (quantidade > 0),
valorlote decimal(10,2),
codproduto int NOT NULL,
constraint fk_Lote_Produto
foreign key (cod_produto) references produto (cod_produto),
check (valorlote = precounitario * quantidade)); -- restrição CHECK no nível da tabela


-- Criando um índice na tabela FABRICANTE.
CREATE NONCLUSTERED INDEX idx_nome_fabricante ON fabricante (nome_fabricante);

-- Inserindo registros na tabela FABRICANTE.
SET IDENTITY_INSERT Fabricante ON
INSERT INTO Fabricante (cod_fabricante, nome_fabricante) VALUES (1, 'Clear');
INSERT INTO Fabricante (cod_fabricante, nome_fabricante) VALUES (2, 'Rexona');
INSERT INTO Fabricante (cod_fabricante, nome_fabricante) VALUES (3, 'Jhonson & Jhonson');
INSERT INTO Fabricante (cod_fabricante, nome_fabricante) VALUES (4, 'Coleston');
SET IDENTITY_INSERT Fabricante OFF

-- Inserindo registros na tabela PRODUTO.
SET IDENTITY_INSERT Produto ON
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (10, 'Sabonete em Barra', 2);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (11, 'Shampoo Anticaspa', 1);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (12, 'Desodorante Aerosol Neutro', 2);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (13, 'Sabonete Liquido', 2);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (14, 'Protetor Solar 30', 3);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (15, 'Shampoo 2 em 1', 2);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (16, 'Desodorante Aerosol Morango', 2);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (17, 'Shampoo Anticaspa', 2);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (18, 'Protetor Solar 60', 3);
INSERT INTO Produto (cod_produto, nome_produto, cod_fabricante) VALUES (19, 'Desodorante Rollon', 1);
SET IDENTITY_INSERT Produto OFF



-- Contar o número de fabricantes
SELECT COUNT(*) AS NumeroDeFabricantes FROM fabricante;

-- Listar os produtos com o maior valor de lote
SELECT 
p.nome_produto, 
MAX(l.valorlote) AS ValorMaximo 
FROM produto AS p INNER 
JOIN lote AS l ON p.cod_produto = l.codproduto GROUP BY p.nome_produto ORDER BY ValorMaximo DESC;