from statistics import mean
import streamlit as st
import datetime
import re
import pickle
from functools import reduce



#FUNÇÃO PARA CONSOLIDAR OS VALORES POR DIA 

def group_values_by_dates(list_data,type_transaction = 'Débito',date_column = "data"): 

    is_type_transaction = lambda x: x['tipo_de_transacao'] == type_transaction

    data_chart_list = list(filter(is_type_transaction, list_data))

    distinct_dates = sorted(list(set([i[date_column] for i in data_chart_list])))

    data_chart_list_grouped = []

    for i in distinct_dates:

        is_date_filter = lambda x: x[date_column]==i

        data_chart_list_date_filtered = list(filter(is_date_filter, data_chart_list))

        data_chart_list_grouped.append({date_column:i,
                                        "valor":reduce(lambda x, y: x + y["valor"], data_chart_list_date_filtered, 0)})

    return data_chart_list_grouped


#FUNÇÃO PARA ESTRUTURAR OS DADOS DE CRÉDITO E DÉBITO 

def join_credit_debit(data_credit,data_debit,date_column = 'data'):
   

   all_dates = sorted(list(set([i[date_column] for i in data_debit]+[i[date_column] for i in data_credit])))

   data_chart = {date_column:[],"debito":[], "credito":[],"net":[]}

   for i in all_dates:

      is_date_filter = lambda x: x[date_column]==i

      data_credit_date_filtered = list(filter(is_date_filter, data_credit))

      data_debit_date_filtered = list(filter(is_date_filter, data_debit))


      if len(data_debit_date_filtered)>0:

            debit = data_debit_date_filtered[0]["valor"]

      if len(data_debit_date_filtered) == 0:

            debit = 0

      if len(data_credit_date_filtered)>0:

            credit = data_credit_date_filtered[0]["valor"]

      else:

            credit = 0


      data_chart[date_column].append(i)
      data_chart["debito"].append(debit*-1)
      data_chart["credito"].append(credit)
      data_chart["net"].append(credit-debit)


   return data_chart


#FUNÇÃO PARA CARREGAR OS DADOS 

def load_data(file_name):

   try:

      file = open(file_name, 'rb')
      data = pickle.load(file)
      file.close()

      return data
   
   except:

      return []

#FUNÇÃO PARA SALVAR OS DADOS 

def save_data(file_name,data):

   file = open(file_name,"wb")
   pickle.dump(data,file)
   file.close()

#CARREGAMENTO DOS DADOS NECESSARIOS PARA O SISTEMA 

dataset = load_data(file_name = 'data.pkl')
tags = load_data(file_name = 'tags.pkl')
register_filtered_by_tags = load_data(file_name = 'filter.pkl')


# INPUT PARA O SAVE DAS TAGS

tags_input_text = st.text_input('DIGITE AS TAGS QUE É DESEJADO SALVAR SEPARADO POR VÍRGULAS',key=1)

#BOTÃO PARA CONFIRMAR O SAVE DAS TAGS

if st.button("Save Tags",key=2):

   tags_treatment = re.sub(r'\s+','',tags_input_text)

   tags_treatment = tags_treatment.split(",")

   save_data(file_name="tags.pkl",data=tags_treatment)

   save_data(file_name="filter.pkl",data=[])



#SELECT DOS MOTIVOS

options_reasons = st.selectbox(
    'MOTIVOS DAS TRANSAÇÕES',
     tags)

#TIPOS DE TRANSAÇÕES (DÉBITO OU CRÉDITO)

type_transactions = st.radio(
    "TIPO DE TRANSAÇÕES",
    ('Crédito', 'Débito'))


#DATA DO BALANCETE

date_execution = st.date_input(
    "DATA DO BALANCETE",
    datetime.date.today())


#DESCRIÇÃO DO DÉBITO OU CRÉDITO 

txt_description = st.text_area('DESCRIÇÃO')


col_value_of_transaction, col_id_selected = st.columns([1.5,1])

#INPUT DO VALOR EM R$

value_of_transaction = col_value_of_transaction.number_input('VALOR EM R$',step=1.0)

#ID SELECIONADO PARA SER DELETADO

id_selected = col_id_selected.number_input('ÍNDICE QUE É DESEJADO SER REMOVIDO',step=1,min_value=1)


col_save_btn, col_delete_btn = st.columns([1.5,1])

# BOTÃO PARA CONFIRMAR O SAVE DO NOVO REGISTRO  

if col_save_btn.button("Save",key=3):


   if len(dataset)>0:

      new_id = max([i["indice"] for i in dataset]) + 1

   else:

      new_id = 0 

   dataset.append({  "indice": new_id,
                     "motivo": options_reasons,
                     "tipo_de_transacao": type_transactions,
                     "data": date_execution,
                     "ano_mes":datetime.date(date_execution.year,date_execution.month,1),
                     "descricao": txt_description,
                     "valor": value_of_transaction})



   save_data(file_name="data.pkl",data=dataset)

   save_data(file_name="filter.pkl",data=[])

# BOTÃO PARA CONFIRMAR O DELETE BASEADO NO ID  

if col_delete_btn.button("Delete",key=4):


   try:

      is_selected_id = lambda x: x["indice"]==id_selected

      removed_register = list(filter(is_selected_id,dataset))

      dataset.remove(removed_register[0])

      save_data(file_name="data.pkl",data=dataset)

      
   except:

      pass


   save_data(file_name="filter.pkl",data=[])


# SELEÇÃO DO MOTIVO PARA SER FILTRADO

filter_reasons = st.selectbox(
    'FILTRO POR MOTIVO',
   list(set([i["motivo"] for i in dataset]))+["todos"],key=11)


# BOTÃO PARA CONFIRMAR O FILTRO 

if st.button("Filter",key=6):


   is_tags_filter = lambda x: x["motivo"]==filter_reasons

   register_filtered_by_tags = list(filter(is_tags_filter, dataset))

   save_data(file_name="filter.pkl",data=register_filtered_by_tags)
  

# CONDIÇÃO PARA VERIFICAR SE FOI FILTRADO 

if len(register_filtered_by_tags)>0:

   st.table({ "indice": [i["indice"] for i in register_filtered_by_tags],
                        "motivo": [i["motivo"] for i in register_filtered_by_tags],
                        "tipo_de_transacao": [i["tipo_de_transacao"] for i in register_filtered_by_tags],
                        "data": [i["data"] for i in register_filtered_by_tags],
                        "ano_mes": [i["ano_mes"] for i in register_filtered_by_tags],
                        "descricao": [i["descricao"] for i in register_filtered_by_tags],
                        "valor": [i["valor"] for i in register_filtered_by_tags]})

else:

   st.table({ "indice": [i["indice"] for i in dataset],
                        "motivo": [i["motivo"] for i in dataset],
                        "tipo_de_transacao": [i["tipo_de_transacao"] for i in dataset],
                        "data": [i["data"] for i in dataset],
                        "ano_mes": [i["ano_mes"] for i in dataset],
                        "descricao": [i["descricao"] for i in dataset],
                        "valor": [i["valor"] for i in dataset]})


# BOTÃO PARA CONFIRMAR O PLOT 

if st.button("Plot",key=7):


   # CONDICIONAL PARA VERIFICAR SE ESTÁ FILTRADO 

   register_filtered_by_tags = load_data(file_name = 'filter.pkl')


   if len(register_filtered_by_tags) > 0:

      data_plot = register_filtered_by_tags

   else:

      data_plot = dataset
   
   # ESTRUTURAÇÃO DA TABELA PARA O PLOT 

   data_chart_debit = group_values_by_dates(data_plot,type_transaction = 'Débito',date_column = "data")
   data_chart_credit = group_values_by_dates(data_plot,type_transaction = 'Crédito',date_column = "data")
   data_chart_structered = join_credit_debit(data_credit = data_chart_credit,data_debit = data_chart_debit,date_column = 'data')
   
   
   # PLOT DAS MÉTRICAS POR DIA

   col1, col2, col3  = st.columns(3)

   col1.metric("Valor líquido médio por dia",f'R$ {round(mean(data_chart_structered["net"]),2)}' )
   col2.metric("Crédito médio por dia", f'R$ {round(mean(data_chart_structered["credito"]),2)}')
   col3.metric("Débito médio por dia", f'R$ {round(mean(data_chart_structered["debito"]),2)}')

   # PLOT DOS TOTAIS 

   col4, col5, col6  = st.columns(3)

   col4.metric("Valor líquido total",f'R$ {sum(data_chart_structered["net"])}')
   col5.metric("Crédito total", f'R$ {sum(data_chart_structered["credito"])}')
   col6.metric("Débito total", f'R$ {sum(data_chart_structered["debito"])}')

   # PLOT DA TABELA E DO GRÁFICO DE LINHA POR DIA 

   st.subheader("Dataset")   
   st.table(data_chart_structered)
   st.subheader("Gráfico de Linha")
   st.line_chart(data=data_chart_structered,x="data")
   st.header("Balanço por mês")

   # ESTRUTURAÇÃO DA TABELA PARA O PLOT POR MÊS 

   data_chart_debit_ano_mes = group_values_by_dates(data_plot,type_transaction = 'Débito',date_column = "ano_mes")
   data_chart_credit_ano_mes = group_values_by_dates(data_plot,type_transaction = 'Crédito',date_column = "ano_mes")
   data_chart_structered_ano_mes = join_credit_debit(data_credit = data_chart_credit_ano_mes,data_debit = data_chart_debit_ano_mes,date_column = 'ano_mes')
   
   # PLOT DA TABELA E DO GRÁFICO DE LINHA POR MÊS 

   col7, col8, col9  = st.columns(3)
   
   col7.metric("Valor líquido médio por mês",f'R$ {round(mean(data_chart_structered_ano_mes["net"]),2)}' )
   col8.metric("Crédito médio por mês", f'R$ {round(mean(data_chart_structered_ano_mes["credito"]),2)}')
   col9.metric("Débito médio por mês", f'R$ {round(mean(data_chart_structered_ano_mes["debito"]),2)}')

   # PLOT DA TABELA E DO GRÁFICO DE LINHA POR MÊS 

   st.subheader("Dataset")
   st.table(data_chart_structered_ano_mes)
   st.subheader("Gráfico de Linha")
   st.line_chart(data=data_chart_structered_ano_mes,x="ano_mes")

   save_data(file_name="filter.pkl",data=[])



