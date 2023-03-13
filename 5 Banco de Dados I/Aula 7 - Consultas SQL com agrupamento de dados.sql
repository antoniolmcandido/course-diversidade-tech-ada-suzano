/*
Aula 7 - Consultas SQL com agrupamento de dados
Prof. Tiago Dias
*/

-- criando uma nova base de dados e fazendo uma nova conexão

create database emp99

-- carregando as base de dados

-- vendas.csv
-- clientes.csv
-- produtos.csv

-- verificando as cargas

select * from vendas v 

select * from clientes c 

select * from produtos p 

-- ##### FUNÇÕES DE AGREGAÇÃO ##### --

-- somando os valores de todos os produtos

select 
	sum(valor) as total_produtos
from produtos p 

-- somando os valores de todas vendas

select *
from vendas v 
left join produtos p using (id_produto)

select 
	sum(valor) as total_vendas
from vendas v 
left join produtos p using (id_produto)

-- somando os valores total das vendas

select 
	quantidade,
	valor,
	quantidade * valor as total
from vendas v 
left join produtos p using (id_produto)

select 
	sum(quantidade * valor) as total_vendas
from vendas v 
left join produtos p using (id_produto)


-- contando os registros de cada tabela da base

select
	'produtos' as tabela,
	count(*) as qtd
from produtos p 
union
select 
	'clientes' as tabela,
	count(*) as qtd
from clientes c 
union
select
	'vendas' as tabela,
	count(*) as qtd
from vendas v 

-- Qual a quantidade máxima?

select
	max(quantidade) as qtd_max
from vendas v 


-- Qual a maior venda?

select
	max(quantidade*valor) as max_venda
from vendas v 
left join produtos p using (id_produto)

-- Qual o valor do produto mais barato?

select 
	min(valor) as min_produto
from produtos p 

-- Quais os produtos mais baratos?

select
	*
from produtos p 
where valor = 1

select
	*
from produtos p 
where valor = (
	select 
	min(valor) as min_produto
	from produtos p 
)


-- Qual o valor médio dos produtos?

select
	avg(valor) as media_produtos
from produtos p 


-- Qual o valor médio das vendas?

select
	avg(quantidade*valor) as media_vendas
from vendas v 
left join produtos p on v.id_produto = p.id_produto 


-- ##### GROUP BY ##### --

-- Qual o valor total das vendas por clientes?

select 
	nome,
	sum(quantidade*valor) as total_vendas
from vendas v 
left join produtos p using (id_produto)
left join clientes c using (id_cliente)
group by nome
order by sum(quantidade*valor) desc

select 
	nome,
	sum(quantidade*valor) as total_vendas
from vendas v 
left join produtos p using (id_produto)
left join clientes c using (id_cliente)
group by 1
order by 2 desc

-- Valor médio de vendas por produtos? 

select 
	produto,
	avg(quantidade*valor) as media_vendas
from vendas v 
left join produtos p using (id_produto)
group by produto

-- agupando mais de um atributo

select 
	nome,
	produto,
	min(quantidade*valor) as min_vendas,
	max(quantidade*valor) as max_vendas,
	avg(quantidade*valor) as media_vendas,
	sum(quantidade*valor) as total_vendas
from vendas v 
left join produtos p using (id_produto)
left join clientes c using (id_cliente)
group by 1, 2
order by 6 desc

-- ##### HAVING ##### --

-- Encontrando vendas por cliente com valor total da venda maior que 3000

select 
	nome,
	sum(quantidade*valor) as total_vendas
from vendas v 
left join produtos p using (id_produto)
left join clientes c using (id_cliente)
group by nome
having sum(quantidade*valor) > 3000
order by 2

-- Encontrando clientes com mais de uma venda

select 
	nome,
	count(*) as qtd_vendas
from vendas v 
left join clientes c using (id_cliente)
group by nome
having count(*) > 1
order by 2

-- Encontrando clientes com três vendas

select 
	nome,
	count(*) as qtd_vendas
from vendas v 
left join clientes c using (id_cliente)
group by nome
having count(*) = 3
order by 2


-- ##### CAST ##### --

-- convertendo dados de inteiro para string

select
	id_produto,
	cast(id_produto as varchar) as id_produto_text 
from vendas v 


-- convertendo dados de string para inteiro

select 
	num,
	cast( num as int),
	cast( num as float),
	cast( num as numeric)
from (
	select '1' as num
	union
	select '4' as num
	union
	select '10' as num
) x

-- erro conversão
select 
	num,
	cast( num as int),
	cast( num as float),
	cast( num as numeric)
from (
	select '1' as num
	union
	select '4' as num
	union
	select '10' as num
	union
	select 'a' as num
) x

-- convertendo coluna de valor para moeda (https://www.postgresql.org/docs/current/functions-formatting.html)

select *, to_char(valor, 'L9G999G999D99') as valor_moeda
from produtos p 

-- L – Símbolo da moeda (utiliza o idioma)
-- 9 – Valor com o número especificado de dígitos
-- G – Separador de grupo (utiliza o idioma)
-- D – Ponto decimal (utiliza o idioma)
 
-- ##### WITH ##### --

-- criando tabelas temporárias para realizar o join

with tab_temp as (
	select
		id_venda,
		data_venda,
		'test' as var
	from vendas v 
)
select *
from tab_temp temp1
--inner join vendas using (id_venda)
inner join tab_temp temp2 on temp1.id_venda = temp2.id_venda


-- refazendo a consulta a -- Quais os produtos mais baratos?
-- 1
select
	*
from produtos p 
where valor = (
	select 
	min(valor) as min_produto
	from produtos p 
)
-- 2
with min_vlr as (
	select 
		min(valor) as min_produto
	from produtos p 
)
select
	*
from produtos p 
where valor = (select * from min_vlr)
-- 3
with min_vlr as (
	select 
		min(valor) as min_produto
	from produtos p 
)
select
	p.*
from produtos p 
inner join min_vlr m on m.min_produto = p.valor

-- ##### FUNÇÕES COM DATA ##### --

select 
	current_date as data_atual,
	date_part('year', current_date) as ano_atual,
	date_part('quarter', current_date) as quarter_atual,
	date_part('month', current_date) as mes_atual,
	date_part('week', current_date) as semana_atual,
	date_part('day', current_date) as dia_atual,
	date_trunc('year', current_date) as data_ano_atual,
	date_trunc('quarter', current_date) as data_quarter_atual,
	date_trunc('month', current_date) as data_mes_atual,
	date_trunc('week', current_date) as data_semana_atual,
	date_trunc('day', current_date) as data_dia_atual

-- total por ano das vendas
	
select
	date_part('year', data_venda) as ano,
	sum(quantidade*valor) as total
from vendas v 
left join produtos p using (id_produto)
group by 1
order by 1 desc 


-- total de clientes por mês


select
	nome,
	date_part('month', data_venda) as mes,
	sum(quantidade*valor) as total
from vendas v 
left join produtos p using (id_produto)
left join clientes c using (id_cliente)
group by 1, 2
order by 1 desc 


-- comparando anos com filtro do mês atual

select
	date_part('year', data_venda) as ano,
	sum(quantidade*valor) as total
from vendas v 
left join produtos p using (id_produto)
where date_part('month', data_venda) <= date_part('month', current_date)
group by 1
order by 1 desc 


-- ##### WINDOWS FUNCTIONS ##### --

--Qual é a média de venda por produto?

select 
	avg(quantidade) as media_qtd
from vendas v 

select 
	produto,
	avg(quantidade) as media_qtd
from vendas v 
left join produtos p using (id_produto)
group by produto

select 
	id_venda,
	produto,
	quantidade,
	avg (quantidade) over (partition by produto) as media_qtd
from vendas v 
left join produtos p using (id_produto)

-- Qual o rank de cliente?

select
	nome,
	sum(quantidade*valor) as total_venda
from vendas v 
left join produtos p using (id_produto)
left join clientes c using (id_cliente)
group by nome

select
	nome,
	sum(quantidade*valor) as total_venda,
	rank() over (order by sum(quantidade*valor) desc)
from vendas v 
left join produtos p using (id_produto)
left join clientes c using (id_cliente)
group by nome

-- top 10
select * 
from (
	select
		nome,
		sum(quantidade*valor) as total_venda,
		rank() over (order by sum(quantidade*valor) desc)
	from vendas v 
	left join produtos p using (id_produto)
	left join clientes c using (id_cliente)
	group by nome
) tab
where rank <=10
