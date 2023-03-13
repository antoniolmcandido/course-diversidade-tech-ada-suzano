/*
Aula 6 - Consultas SQL com tabelas relacionadas
Prof. Tiago Dias
*/

-- ##### JOINS ##### --

-- criando tabela_a e tabela_b

create table  public.tabela_a (
                id_aluno INTEGER,
                nm_aluno VARCHAR,
                id_uf INTEGER
);

create table  public.tabela_b (
                id_uf INTEGER,
                nm_uf VARCHAR
);
-- inserindo dados nas tabela_a e tabela_b

insert into tabela_a values
	(1,'Joana',1),
	(2,'Priscila',9),
	(3,'José',3),
	(4,'Maria',4),
	(5,'Paula',8),
	(6,'Paulo',8);

insert into tabela_b values
	(1,'BA'),
	(2,'CE'),
	(3,'SP'),
	(4,'PE'),
	(5,'RJ'),
	(6,'SC');


select * from tabela_a ta 

select * from tabela_b tb 

-- left join tabela_a com tabela_b

select *
from 		tabela_a ta
left join 	tabela_b tb on ta.id_uf = tb.id_uf 
order by id_aluno 


-- right join tabela_a com tabela_b

select *
from 		tabela_a ta
right join 	tabela_b tb on ta.id_uf = tb.id_uf 
order by tb.id_uf  

-- inner join tabela_a com tabela_b

select *
from 		tabela_a ta
inner join 	tabela_b tb on ta.id_uf = tb.id_uf 
order by id_aluno 

select *
from 	tabela_a ta
join 	tabela_b tb on ta.id_uf = tb.id_uf 
order by id_aluno 

-- full join tabela_a com tabela_b

select *
from 		tabela_a ta
full join 	tabela_b tb on ta.id_uf = tb.id_uf 
order by ta.id_aluno, tb.id_uf

-- full join 1=1, relaciona todas os registros das 2 duas tabelas

select *
from 		tabela_a ta
full join 	tabela_b tb on 1=1 
order by ta.id_aluno, tb.id_uf

-- transformando a coluna do join em apenas uma com USING

select *
from 		tabela_a ta
inner join 	tabela_b tb using (id_uf) 
order by id_aluno 

-- filtrando o join

select *
from 		tabela_a ta
inner join 	tabela_b tb on ta.id_uf = tb.id_uf and id_aluno in (1,4)
order by id_aluno 

-- ##### UNIONS ##### --

-- criando tabela_c  

create table  public.tabela_c (
                id_aluno INTEGER,
                nm_aluno VARCHAR,
                id_uf INTEGER
);

-- inserindo dados nas tabela_a e tabela_b

insert into tabela_c values
	(1,'Joana',1),
	(7,'Gustavo',1),
	(8,'Giovana',3);

select * from tabela_c

-- Union tabela_a com tabela_c

select * from tabela_a ta -- 6 registros
union -- distinct
select * from tabela_c tc -- 3 registros
order by id_aluno 

-- Union all tabela_a com tabela_c

select * from tabela_a ta -- 6 registros
union all -- não usa distinct
select * from tabela_c tc -- 3 registros
order by id_aluno 

-- intersect tabela_a com tabela_c

select * from tabela_a ta 
intersect
select * from tabela_c tc
order by id_aluno 

-- except tabela_a com tabela_c e tabela_c com tabela_a (Atenção!!! A ordem das tabelas altera a exibição)

select * from tabela_a ta 
except
select * from tabela_c tc
order by id_aluno 

select * from tabela_c tc 
except
select * from tabela_a ta
order by id_aluno 


-- ##### VIEWS ##### --

-- criando uma view

create view vw_tabela_ab as (
	select *
	from 		tabela_a ta
	inner join 	tabela_b tb using (id_uf) 
	order by id_aluno 
)

-- consultando view

select * from vw_tabela_ab vta 

-- criando uma view materializada

create materialized view vwm_tabela_ab as (
	select *
	from 		tabela_a ta
	inner join 	tabela_b tb using (id_uf) 
	order by id_aluno 
)

-- consultando view materializada

select * from vwm_tabela_ab vta 

-- atualizando dados 

select * from tabela_b tb

insert into tabela_b values
	(7, 'SP'),
	(8, 'ES')

-- consultando view atualizada

select * from vw_tabela_ab vta 

-- consultando view materializada desatualizada

select * from vwm_tabela_ab vta 

-- atualizando view materializada

refresh materialized view vwm_tabela_ab 

-- consultando view materializada atualizada

select * from vwm_tabela_ab vta 

-- with para sub consultas

with tabela_ac as (
	select * from tabela_a ta 
	union 
	select * from tabela_c tc 
	order by id_aluno 
)
select * 
from tabela_ac
left join tabela_b using (id_uf)

-- criando uma view com with

create view vw_tabela_abc as (
	with tabela_ac as (
		select * from tabela_a ta 
		union 
		select * from tabela_c tc 
		order by id_aluno 
	)
	select * 
	from tabela_ac
	left join tabela_b using (id_uf)
)

select * from vw_tabela_abc vta 


-- fazendo o join com union

select * from tabela_a ta 
left join tabela_b using (id_uf)
union 
select * from tabela_c tc 
left join tabela_b using (id_uf)
order by id_aluno

-- fazendo o join com union, com sub select

select *
from (
	select * from tabela_a ta 
	union 
	select * from tabela_c tc 
) ac
left join tabela_b using (id_uf)
order by id_aluno
