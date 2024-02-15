-- Criar o banco de dados Contabilidade
CREATE DATABASE db_contabilidade_Financas_3tecnos;
GO

-- Usar o banco de dados Contabilidade
USE db_contabilidade_Financas_3tecnos;
GO

-- Tabela para Entes (representando os �rg�os governamentais)
CREATE TABLE Entes (
    ente_id INT IDENTITY(1,1),
    nome_orgao VARCHAR(255) UNIQUE NOT NULL,
    tipo_entidade VARCHAR(100) NOT NULL,
	CONSTRAINT entes_id_ente_pk PRIMARY KEY(ente_id)
);

-- Tabela para Centraliza��o de Cr�ditos Adicionais
CREATE TABLE CreditosAdicionais (
    id_creditos_adicionais INT IDENTITY(1,1),
    ente_id INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    data_adicao DATE NOT NULL,
	tipo_credito VARCHAR(100) NOT NULL,
	CONSTRAINT creditos_id_creditos_adicionais_pk PRIMARY KEY(id_creditos_adicionais),
	CONSTRAINT creditos_tipo_credito_ck CHECK(tipo_credito IN ('Cr�dito Suplementar', 'Cr�dito Especial', 'Cr�dito Extraordin�rio')),
	CONSTRAINT fk_creditos_adicionais FOREIGN KEY(ente_id) REFERENCES Entes(ente_id),
);

-- Tabela para Centraliza��o de Repasses Financeiros
CREATE TABLE RepassesFinanceiros (
    id_repasses INT NOT NULL,
	ente_id INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    data_repasso DATE NOT NULL,
	id_origem INT NOT NULL,
	id_destino INT NOT NULL,
	CONSTRAINT pk_repasses_id_repasse PRIMARY KEY(id_repasses),
	CONSTRAINT fk_repasses_financeiros FOREIGN KEY(ente_id) REFERENCES Entes(ente_id),
);


-- Cria��o da tabela OrigemRepasse
CREATE TABLE OrigemRepasse (
	id_origem INT NOT NULL,
	id_repasse_origem INT NOT NULL,
    nome_origem_repasse VARCHAR(100) UNIQUE NOT NULL,
	id_repasses INT NOT NULL,
	CONSTRAINT origem_repasse_id_origem_pk PRIMARY KEY(id_origem),
	CONSTRAINT financeiro_origem_repasse_fk FOREIGN KEY(id_repasses) REFERENCES RepassesFinanceiros(id_repasses),
);

-- Cria��o da tabela DestinoRepasse
CREATE TABLE DestinoRepasse (
	id_destino INT NOT NULL,
	id_repasse_destino INT NOT NULL,
    nome_destino_repasse VARCHAR(100) UNIQUE NOT NULL,
	id_repasses INT NOT NULL,
	CONSTRAINT destino_id_destino_repasse_pk PRIMARY KEY(id_destino),
	CONSTRAINT financeiro_destino_repasse_fk FOREIGN KEY(id_repasses) REFERENCES RepassesFinanceiros(id_repasses),
);


-- Tabela para Cronograma Or�ament�rio
CREATE TABLE CronogramaOrcamentario (
    id_cronograma_orcamentario INT IDENTITY(1,1),
    ente_id INT NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fim DATE NOT NULL,
    limite_orcamento DECIMAL(10, 2) NOT NULL,
	CONSTRAINT pk_cronograma_orcamentario PRIMARY KEY(id_cronograma_orcamentario),
	CONSTRAINT fk_cronograma_orcamentario_entes FOREIGN KEY(ente_id) REFERENCES Entes(ente_id),
);

-- Tabela para Cronograma Financeiro
CREATE TABLE CronogramaFinanceiro (
    id_cronograma_financeiro INT IDENTITY(1,1),
    ente_id INT NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fim DATE NOT NULL,
    limite_liquidacoes DECIMAL(10, 2) NOT NULL,
	CONSTRAINT pk_cronograma_financeiro PRIMARY KEY(id_cronograma_financeiro),
	CONSTRAINT fk_cronograma_financeiro FOREIGN KEY(ente_id) REFERENCES Entes(ente_id)
);

-- Tabela para Despesas
CREATE TABLE Despesas (
    id_despesas INT IDENTITY(1,1),
    ente_id INT NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_despesa DATE NOT NULL,
	CONSTRAINT pk_despesas PRIMARY KEY(id_despesas),
	CONSTRAINT fk_despesas FOREIGN KEY(ente_id) REFERENCES Entes(ente_id),
);

-- Tabela para Receitas
CREATE TABLE Receitas (
    id_receitas INT IDENTITY(1,1),
    ente_id INT NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_receita DATE NOT NULL,
	CONSTRAINT pk_id_receitas PRIMARY KEY(id_receitas),
	CONSTRAINT fk_receitas FOREIGN KEY(ente_id) REFERENCES Entes(ente_id),
);

-- Tabela DotacaoOrcamentaria
CREATE TABLE DotacaoOrcamentaria (
    id_dotacao_orcamentaria INT PRIMARY KEY IDENTITY(1,1),
	id_repasses INT FOREIGN KEY REFERENCES RepassesFinanceiros(id_repasses),
    descricao VARCHAR(255) NOT NULL,
    valor DECIMAL(18, 2) NOT NULL,
    data_distribuicao DATE NOT NULL,
    id_despesas INT FOREIGN KEY REFERENCES Despesas(id_despesas),
    data_empenho DATE NOT NULL,
    data_liquidacao DATE NOT NULL,
    data_pagamento DATE NOT NULL
);
GO

-- Dados de Amostra
INSERT INTO Entes (nome_orgao, tipo_entidade) VALUES
('Prefeitura Municipal de S�o Paulo', 'Munic�pio'),
('Governo do Estado de Minas Gerais', 'Estado'),
('Governo do Distrito Federal', 'Uni�o'),
('Prefeitura Municipal de Rio de Janeiro', 'Munic�pio'),
('Governo do Estado da Bahia', 'Estado'),
('Prefeitura Municipal de Fortaleza', 'Munic�pio'),
('Governo do Estado de S�o Paulo', 'Estado'),
('Prefeitura Municipal de Belo Horizonte', 'Munic�pio'),
('Governo do Estado do Rio Grande do Sul', 'Estado'),
('Prefeitura Municipal de Recife', 'Munic�pio'),
('Governo do Estado do Paran�', 'Estado'),
('Prefeitura Municipal de Salvador', 'Munic�pio'),
('Governo do Estado do Cear�', 'Estado'),
('Prefeitura Municipal de Curitiba', 'Munic�pio'),
('Governo do Estado de Pernambuco', 'Estado'),
('Prefeitura Municipal de Manaus', 'Munic�pio'),
('Governo do Estado do Rio de Janeiro', 'Estado'),
('Prefeitura Municipal de Porto Alegre', 'Munic�pio'),
('Governo do Estado do Amazonas', 'Estado'),
('Prefeitura Municipal de Goi�nia', 'Munic�pio');

INSERT INTO CreditosAdicionais (ente_id, valor, descricao, data_adicao, tipo_credito) VALUES
(1, 50000.00, 'Cr�dito adicional para educa��o', '2024-01-15', 'Cr�dito Suplementar'),
(2, 75000.00, 'Cr�dito adicional para sa�de', '2024-02-05', 'Cr�dito Suplementar'),
(1, 30000.00, 'Cr�dito adicional para infraestrutura', '2024-01-30', 'Cr�dito Especial'),
(3, 40000.00, 'Cr�dito adicional para transporte p�blico', '2024-02-12', 'Cr�dito Suplementar'),
(2, 60000.00, 'Cr�dito adicional para seguran�a p�blica', '2024-01-20', 'Cr�dito Especial'),
(3, 35000.00, 'Cr�dito adicional para programas sociais', '2024-02-28', 'Cr�dito Extraordin�rio');

INSERT INTO RepassesFinanceiros (id_repasses, ente_id, valor, descricao, data_repasso, id_origem, id_destino) VALUES
    (1, 1, 50000.00, 'Repasse para educa��o', '2024-02-05', 101, 201),
    (2, 2, 75000.00, 'Repasse para sa�de', '2024-02-10', 102, 202),
    (3, 3, 60000.00, 'Repasse para infraestrutura', '2024-02-15', 103, 203),
    (4, 1, 45000.00, 'Repasse para assist�ncia social', '2024-02-20', 104, 204),
    (5, 2, 55000.00, 'Repasse para seguran�a p�blica', '2024-02-25', 105, 205),
	(6, 3, 70000.00, 'Repasse para cultura', '2024-03-05', 106, 206),
    (7, 1, 48000.00, 'Repasse para desenvolvimento social', '2024-03-10', 107, 207),
    (8, 2, 62000.00, 'Repasse para agricultura', '2024-03-15', 108, 208),
    (9, 3, 58000.00, 'Repasse para meio ambiente', '2024-03-20', 109, 209),
    (10, 1, 53000.00, 'Repasse para turismo', '2024-03-25', 110, 210);

INSERT INTO OrigemRepasse (id_origem, id_repasse_origem, nome_origem_repasse, id_repasses)
VALUES
    (1, 101, 'Minist�rio da Educa��o', 1),
    (2, 102, 'Minist�rio da Sa�de', 2),
    (3, 103, 'Minist�rio do Desenvolvimento Regional', 3),
    (4, 104, 'Minist�rio da Economia', 4),
    (5, 105, 'Minist�rio da Infraestrutura', 5),
	(6, 106, 'Minist�rio da Agricultura, Pecu�ria e Abastecimento', 6),
    (7, 107, 'Minist�rio da Justi�a e Seguran�a P�blica', 7),
    (8, 108, 'Minist�rio do Meio Ambiente', 8),
    (9, 109, 'Minist�rio das Comunica��es', 9),
    (10, 110, 'Minist�rio do Turismo', 10);

INSERT INTO DestinoRepasse (id_destino, id_repasse_destino, nome_destino_repasse, id_repasses)
VALUES
    (1, 201, 'Secretaria Municipal de Educa��o', 1),
    (2, 202, 'Secretaria Municipal de Sa�de', 2),
    (3, 203, 'Secretaria Municipal de Desenvolvimento Social', 3),
    (4, 204, 'Secretaria Municipal de Finan�as', 4),
    (5, 205, 'Secretaria Municipal de Infraestrutura', 5),
    (6, 206, 'Secretaria Municipal de Cultura', 6),
    (7, 207, 'Secretaria Municipal de Agricultura', 7),
    (8, 208, 'Secretaria Municipal de Assist�ncia Social', 8),
    (9, 209, 'Secretaria Municipal de Meio Ambiente', 9),
    (10, 210, 'Secretaria Municipal de Turismo', 10);

INSERT INTO CronogramaOrcamentario (ente_id, periodo_inicio, periodo_fim, limite_orcamento) VALUES
(1, '2024-01-01', '2024-06-30', 100000.00),
(2, '2024-01-01', '2024-12-31', 200000.00),
(3, '2024-01-01', '2024-03-31', 75000.00),
(2, '2024-01-01', '2024-12-31', 300000.00),
(1, '2024-04-01', '2024-06-30', 120000.00),
(3, '2024-04-01', '2024-12-31', 200000.00);

INSERT INTO CronogramaFinanceiro (ente_id, periodo_inicio, periodo_fim, limite_liquidacoes) VALUES
(1, '2024-01-01', '2024-12-31', 80000.00),
(2, '2024-01-01', '2024-12-31', 150000.00),
(3, '2024-01-01', '2024-03-31', 50000.00),
(3, '2024-01-01', '2024-12-31', 100000.00),
(1, '2024-04-01', '2024-06-30', 80000.00),
(2, '2024-04-01', '2024-12-31', 200000.00);

INSERT INTO Despesas (ente_id, categoria, valor, data_despesa) VALUES
(1, 'Educa��o', 25000.00, '2024-01-10'),
(2, 'Sa�de', 35000.00, '2024-02-15'),
(1, 'Infraestrutura', 20000.00, '2024-01-25'),
(2, 'Educa��o', 15000.00, '2024-02-10'),
(1, 'Sa�de', 20000.00, '2024-02-20'),
(3, 'Infraestrutura', 25000.00, '2024-03-05');

INSERT INTO Receitas (ente_id, categoria, valor, data_receita) VALUES
(1, 'Impostos', 50000.00, '2024-01-05'),
(2, 'Transfer�ncias Federais', 75000.00, '2024-02-20'),
(1, 'Taxas', 30000.00, '2024-01-30'),
(1, 'Impostos', 100000.00, '2024-02-05'),
(2, 'Transfer�ncias Federais', 120000.00, '2024-02-15'),
(3, 'Taxas', 50000.00, '2024-03-01');

INSERT INTO DotacaoOrcamentaria (id_repasses, descricao, valor, data_distribuicao, id_despesas, data_empenho, data_liquidacao, data_pagamento)
VALUES 
(1, 'Desenvolvimento de Software', 5000.00, '2023-03-01', 1, '2023-03-15', '2023-03-30', '2023-04-05'),
(2, 'Aquisi��o de Equipamentos', 8000.00, '2023-04-01', 2, '2023-04-10', '2023-04-20', '2023-05-01'),
(3, 'Constru��o de Pr�dio', 10000.00, '2023-05-01', 3, '2023-05-15', '2023-05-30', '2023-06-15'),
(4, 'Pagamento de Sal�rios', 3000.00, '2023-06-01', 4, '2023-06-15', '2023-06-30', '2023-07-05'),
(5, 'Pagamento de Juros', 6000.00, '2023-07-01', 5, '2023-07-15', '2023-07-30', '2023-08-05');

