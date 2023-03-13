import streamlit as st
import pandas as pd
import numpy as np
from PIL import Image 

st.title("Este aqui é um título")

st.write("$$ f(x) = y $$")

st.header("Este é um header")

st.caption("este é um caption")

st.code(
    
    """
a = 20
b = 30
print(a + b)
"""
)

st.latex('\sum_{i=0}^j x_i')

df = pd.DataFrame({"A":[1,2,3],"B":[1,2,3]})

dict_data = {"A":[1,2,3],"B":[1,2,3]}

st.write(df)

st.table(df)

st.table(dict_data)

baseline = np.random.randint(0,10,10)

new_model = np.random.randint(10,20,10)

st.metric('Model Performance',new_model.mean(),
            new_model.mean() - baseline.mean() )

dict_chart_line = {"baseline":baseline,"new_model":new_model} 

st.line_chart(dict_chart_line)

st.area_chart(dict_chart_line)

st.bar_chart(dict_chart_line)

click = st.button("click me")

if click:
    st.write("deu certo")

select = st.checkbox("concorda?")

st.write(select)

radio = st.radio("escolha uma fruta",["banana","maça","morango"])

st.write(radio)

drop = st.selectbox("selecione as frutas",["banana","maça","morango"])

text = st.text_input("qual é o seu nome??")

st.write(text)

date = st.date_input("escolha uma data")

st.write(type(date))
st.write(date)

uploaded_file = st.file_uploader("carregue o arquivo aqui")

st.write(uploaded_file)

st.write(type(uploaded_file))

if uploaded_file is not None:

    img = Image.open(uploaded_file)

    st.image(img)

