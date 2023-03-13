/*
Aula 8 - Revisão
Prof. Tiago Dias
*/


-- ### RELEMBRANDO CONCEITOS ### --

/* 
 
Dado, Informação e Conhecimento
18 ---> 18 Anos ---> Maioridade no Brasil

O que são banco de dados?
Conjunto de informações organizada, armazenadas em um sistema de computador.

O que são banco de dados relacionais?
Os bancos relacionais, são dados estruturados em linhas e colunas.

O que é SQL?
É a linguagem de consulta padrão em banco de dados relacionais.

Modelo entidade relacionamento (MER)
- É um modelo conceitual.
- Identifica as entidades, atributos e relacionamentos.
- Modelo abstrato que representa a estrutura do banco de dados.

Diagrama entidade relacionamento (DER):
- É a representação gráfica. 
- Facilitar o desenvolvimento do banco de dados. 
- A proposta original é uma modelagem utilizando retângulos, elipse, losangos e linhas.

*/

-- ### CARGA DE DADOS ### --

-- Criar uma nova base de dados

create database revisao

-- importar as bases de dados

-- funcionarios.csv
-- telefones.csv
-- email.csv

-- ### PROBLEMAS DE NEGÓCIO ### --

select * from funcionarios f 

select * from telefones t 

select * from emails e 

-- Qual a quantidade de funcionários na base?

select 
	count(*) as qtd_registos,
	count(distinct cd_funcionario) as qtd_funcionarios	
from funcionarios f 

-- Exiba os primeiros 10 registros da tabela de funcionários.

select * 
from funcionarios f 
limit 10

SELECT * FROM funcionarios LIMIT 20 OFFSET 10;

-- Quais os cargos existentes na base?

select distinct 
	cargo
from funcionarios f 

-- Qual a estrutura hierárquica atual dos funcionários?

select
	ven.cd_funcionario,
	ven.nm_funcionario,
	ven.cargo,
	sup.cd_funcionario,
	sup.nm_funcionario,
	sup.cargo,
	ger.cd_funcionario,
	ger.nm_funcionario,
	ger.cargo
from 		funcionarios ven 
left join 	funcionarios sup on ven.cd_superior = sup.cd_funcionario and sup.cargo = 'supervisor' 
left join 	funcionarios ger on sup.cd_superior = ger.cd_funcionario and ger.cargo = 'gerente' 
where ven.cargo = 'vendedor'


-- Check de validação da hierarquia

select *
from funcionarios f 
where cd_funcionario in (1001,1002,1003)

-- Selecionar somente o time do gerente 1003

select *
from funcionarios
where cd_superior = 1003

select *
from funcionarios
where cd_superior is null

select
	ven.cd_funcionario,
	ven.nm_funcionario,
	ven.cargo,
	sup.cd_funcionario,
	sup.nm_funcionario,
	sup.cargo,
	ger.cd_funcionario,
	ger.nm_funcionario,
	ger.cargo
from 		funcionarios ven 
left join 	funcionarios sup on ven.cd_superior = sup.cd_funcionario and sup.cargo = 'supervisor' 
left join 	funcionarios ger on sup.cd_superior = ger.cd_funcionario and ger.cargo = 'gerente' 
where ven.cargo = 'vendedor' and ger.cd_funcionario = 1003


-- Check de validação da hierarquia pelo superior

select *
from funcionarios
where cd_superior in (1003, 1002);


-- Qual a quantidade de cada cargo com detalhe do sexo?

select 
	cargo ,
	sexo ,
	count(*) as qtd
from funcionarios f 
group by cargo , sexo 
order by cargo 

-- Acrescentando o percentual de representatividade.

select 
	cargo ,
	sexo ,
	count(*) as qtd,
	sum(count(*)) over (partition by cargo) as qtd_total_cargo,
	count(*) / sum(count(*)) over (partition by cargo) as perc
from funcionarios f 
group by cargo , sexo 
order by cargo 
	
-- Qual a idade e o tempo de serviço dos funcionários?

select 
	nm_funcionario ,
	--(current_date - dt_nascimento)/365 as idade,
	age(current_date, dt_nascimento) as idade,
	age(current_date, dt_admissao) as tempo
from funcionarios f 

-- Qual o funcionário mais velho? e com mais tempo de casa?

select 
	max(age(current_date, dt_nascimento)) as idade
from funcionarios f 

select *
from funcionarios f 
where age(current_date, dt_nascimento) = (
	select 
		max(age(current_date, dt_nascimento))
	from funcionarios f 
)

select 
	*, age(current_date, dt_admissao) as tempo
from funcionarios f 
where age(current_date, dt_admissao) = (
	select 
		max(age(current_date, dt_admissao))
	from funcionarios f 
)

-- Listar os funcionários com o telefone comercial, quando não houver, listar o telefone pessoal.

select 
	f.cd_funcionario,
	nm_funcionario,
	coalesce (t.tp_telefone, t2.tp_telefone ) as tp_telefone,
	coalesce (t.nr_telefone, t2.nr_telefone ) as nr_telefone
from funcionarios f 
left join telefones t on f.cd_funcionario = t.cd_funcionario and t.tp_telefone = 'comercial'
left join telefones t2 on f.cd_funcionario = t2.cd_funcionario and t2.tp_telefone = 'pessoal'
--where f.cd_funcionario in (1001, 1002)
order by f.cd_funcionario 

-- Listar os funcionários com o último e-mail cadastrado.

with ult_email as (
	select 
		*,
		--rank() over(partition by cd_funcionario order by dt_cadastro desc),
		row_number () over(partition by cd_funcionario order by dt_cadastro desc) as ordem
	from emails
)
select 
	f.cd_funcionario,
	nm_funcionario,
	email 
from funcionarios f
inner join ult_email u on f.cd_funcionario = u.cd_funcionario and ordem = 1
