/*
Aula 5 - Consulta simples e manipulação de dados nas tabelas (CRUD)
Prof. Tiago Dias
*/

-- criando uma base de dados e conectar

create database escola

-- criando uma sequencia para codigo do aluno

create sequence seq_cod_aluno start 10001

/* 
criando uma tabela de alunos

cod_aluno|nm_aluno_pri|nm_aluno_ult|id_aluno|dt_aluno  |
---------+------------+------------+--------+----------+
     1001|Tiago       |Dias        |      33|2022-06-01|
     1002|Patricia    |Dias        |        |          |
     1003|José        |Costa       |      23|2022-05-01|
     1004|Maria       |Silva       |      26|2022-05-01|
     1005|Paula       |Santos      |      55|2022-04-01|
     1006|Joana       |Santana     |      38|2022-03-01|
*/


-- verificando a tabela de alunos

create table alunos (
	cod_aluno		integer default nextval('seq_cod_aluno'),
	nm_aluno_pri	varchar,
	nm_aluno_ult	varchar,
	id_aluno		integer,
	dt_aluno		date
)

select * from alunos

-- ##### Comando de inclusão de dados em tabelas (INSERT) ##### --

-- Inserindo um único registro

insert into alunos values (1001, 'Tiago', 'Dias', 33, '2022-01-01')

-- Inserindo um registro especificando as colunas

insert into alunos (cod_aluno, nm_aluno_pri, nm_aluno_ult)
	values (1002, 'Joãozinho', 'da Silva')

-- Inserindo vários registros
	
insert into alunos values
	(1003, 'Maria', 'da Paz', 25, '2022-02-06'),
	(1004, 'Joana', 'Santos', 34, '2022-05-06'),
	(1005, 'Paulo', 'silva', 18, '2022-07-07'),
	(1006, 'Mariana', 'Oliveira', 25, '2022-02-16')

-- Inserindo registro com valores default
	
insert into alunos (nm_aluno_pri, nm_aluno_ult, id_aluno)
	values ('José', 'Costa', 55)

insert into alunos (nm_aluno_pri, nm_aluno_ult, id_aluno)
	values ('Laura', 'Costa', 55)
	
-- Inserindo registros a partir de uma outra consulta
   
create table alunos_temp (
	cod_aluno		integer default nextval('seq_cod_aluno'),
	nm_aluno_pri	varchar,
	nm_aluno_ult	varchar,
	id_aluno		integer,
	dt_aluno		date
)

select * from alunos

select * from alunos_temp

insert into alunos_temp select * from alunos  

-- Inserindo com create table

create table alunos_new as select * from alunos

select * from alunos_new

-- ##### Comando de atualização de dados em tabelas (UPDATE) ##### --

-- Atualizando dados sem where

update alunos_temp set id_aluno = 25

select * from alunos_temp

-- Atualizando dados com where

update alunos_new set id_aluno = 25 where id_aluno is null

select * from alunos_new

-- Atualizando várias colunas

update alunos_new set id_aluno = 35, dt_aluno = '2022-09-01' 
	where cod_aluno = 1006


-- Atualizando várias colunas com outra sintaxe e exibindo a atualização

 update alunos_new set (id_aluno, dt_aluno) = (28, '2022-08-01')
 	where cod_aluno = 1005
 	returning *

-- ##### Comando de atualização de dados em tabelas (DELETE) ##### --
 
-- Exclusão sem where
	
delete from alunos_temp 

select * from alunos_temp

-- Exclusão com where

delete from alunos_new where dt_aluno is null

select * from alunos_new

-- Exibindo registros excluídos

delete from alunos_new where id_aluno > 30 returning *

-- ##### Comandos de consulta simples como SELECT ##### --

-- Todas as colunas 

select * from alunos

-- Todas as colunas com limitador de registros (limit)

select * from alunos limit 2

-- Colunas específicas

select 
	cod_aluno,
	nm_aluno_pri,
	id_aluno
from alunos

-- Apelidos em colunas

select 
	cod_aluno 		as matricula,
	nm_aluno_pri	as primeiro_nome,
	id_aluno		as idade
from alunos

-- Cláusula WHERE com IN

select *
from alunos
where id_aluno in (33, 55, 24)

-- Cláusula WHERE com várias condições

select *
from alunos
where id_aluno = 55 and nm_aluno_pri = 'Laura'

-- Cláusula WHERE com várias condições com texto todo minusculo

select *
from alunos
where id_aluno = 55 and lower(nm_aluno_pri) = 'laura'

-- minusculo lower()
-- maiusculo upper() 

-- Cláusula WHERE com LIKE
	
select *
from alunos
where lower(nm_aluno_ult) like 'silva' -- igual

select *
from alunos
where lower(nm_aluno_ult) like 'silva%' -- começando com

select *
from alunos
where lower(nm_aluno_ult) like '%silva' -- terminando com

select *
from alunos
where lower(nm_aluno_ult) like '%silva%' -- em qualquer parte

-- Cláusula WHERE com iLIKE
	
select *
from alunos
where nm_aluno_ult ilike '%silva%' -- em qualquer parte


-- Cláusula WHERE com <=, >=, =.

select *
from alunos
where dt_aluno > '2022-05-01'


-- Cláusula WHERE com <=, >=, = incluindo nulos.


select *
from alunos
where dt_aluno > '2022-05-01' or dt_aluno is null


-- Cláusula WHERE com BETWEEN

select *
from alunos
where dt_aluno > '2022-05-06' and dt_aluno < '2022-06-01' -- excluindo a data diferente ao between

select *
from alunos
where dt_aluno >= '2022-05-06' and dt_aluno <= '2022-06-01' -- inclusive a data igual ao between

select *
from alunos
where dt_aluno between '2022-05-06' and '2022-06-01'


-- ##### Comando para apagar todos os registros da tabela (TRUNCATE) ##### --

select * from alunos_new

truncate table alunos_new 
