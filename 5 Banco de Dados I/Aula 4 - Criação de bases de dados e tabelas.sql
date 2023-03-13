/*
Aula 4 - Criação de bases de dados e tabelas
Prof Tiago Dias
*/

/****************** MANIPULANDO BASE DE DADOS ******************/

-- Criar de uma nova base de dados, e criar uma nova conexão com essa base.

CREATE DATABASE TURMA889

-- Realizar uma alteração no nome da base de dados criada anteriormente.

ALTER DATABASE TURMA889 RENAME TO CLIENTES

-- Deletar uma base de dados.

DROP DATABASE CLIENTES

-- Deletar uma base de dados com o comando if exists.

DROP DATABASE IF EXISTS CLIENTES

/****************** MANIPULANDO TABELAS ******************/

CREATE DATABASE CLIENTES

-- Criar uma tabela.

CREATE TABLE CLIENTES (
	ID_CLIENTE		INTEGER,
	NM_CLIENTE		VARCHAR,
	EMAIL			VARCHAR,
	ID_UF			VARCHAR
)


-- Criar uma tabela e definir chave primária e extrangeira.

CREATE TABLE UFS (
	ID_UF	VARCHAR,
	ESTADO	VARCHAR
)


ALTER TABLE CLIENTES 
	ADD CONSTRAINT PK_CLIENTES
	PRIMARY KEY (ID_CLIENTE)
	
ALTER TABLE UFS 
	ADD CONSTRAINT PK_UFS
	PRIMARY KEY (ID_UF)
	
ALTER TABLE CLIENTES 
	ADD CONSTRAINT FK_CLIENTES
	FOREIGN KEY (ID_UF)
	REFERENCES UFS (ID_UF)


-- Alterar o nome da tabela criada anteriormente.

ALTER TABLE UFS RENAME TO ESTADOS

-- Alterar o nome de uma coluna da tabela.

ALTER TABLE CLIENTES RENAME COLUMN EMAIL TO EMAIL_CLIENTE

-- Alterar o tipo de dados de uma coluna da tabela.

ALTER TABLE CLIENTES ALTER COLUMN NM_CLIENTE TYPE VARCHAR(200)

-- Adicionar uma coluna na tabela.

ALTER TABLE CLIENTES ADD COLUMN TELEFONE VARCHAR(20)

-- Deletar uma coluna na tabela.

ALTER TABLE CLIENTES DROP COLUMN TELEFONE

-- Deletar a tabela.

DROP TABLE CLIENTES

--DROP TABLE ESTADOS
--DROP TABLE UFS

-- Deletar a tabela if exists.

DROP TABLE IF EXISTS CLIENTES
