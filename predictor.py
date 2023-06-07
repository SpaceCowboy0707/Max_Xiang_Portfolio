import streamlit as st
import pickle
import numpy as np
from sklearn.feature_selection import SelectKBest, f_classif

with open('log_reg_model.pkl', 'rb') as file:
    log_reg = pickle.load(file)

st.title("Credit Risk Prediction System")
st.write("Disclaimer: The predictive system prototype provided is based on a combination of historical data and statistical modeling techniques, and is intended for informational purposes only. It is not intended to provide any guarantees or predictions with absolute accuracy. The prototype is subject to change. ")
st.subheader("Please put all applicant's information below")


input_features = np.zeros((1, 32))
feature_names = ['External risk estimate index',
                 'Months since oldest trade open',
                 'Months since most recent trade open', 
                 'Average months in file', 
                 'Number of satisfactory trades',
                 'Numbers of trades 60+ Ever', 
                 'Numbers of trades 90+ Ever',
                 'Percent trades never delinquent', 
                 'Months since most recent delinquency',
                 'Max delinquency/public records last 12 months (1 for no such value, 2 for derogatory comment, 3 for 120+ days delinquent, 4 for 90 days delinquent, 5 for 60 days delinquent, 6 for 30 days delinquent, 7 for unknown delinquency, 8 for current and never delinquent, 9 for all other) ', 
                 'Max delinquency ever (1 for no such value, 2 for derogatory comment, 3 for 120+ days delinquent, 4 for 90 days delinquent, 5 for 60 days delinquent, 6 for 30 days delinquent, 7 for unknown delinquency, 8 for current and never delinquent, 9 for all other)', 
                 'Number of total trades (total number of credit accounts)',
                 'Number of trades open in last 12 months', 
                 'Percent installment trades',
                 'Months since most recent inquiries excluding last 7 days', 
                 'Number of inquiries last 6 months', 
                 'Number of inquiries last 6 months excluding last 7 days. (excluding the last 7 days removes inquiries that are likely due to price comparision shopping)',
                 'Net fraction revolving burden. (this is revolving balance divided by credit limit)',
                 'Net fraction installment burden. (this is installment balance divided by original loan amount)',
                 'Number revolving trades with balance',
                 'Number installment trades with balance',
                 'Number bank/national trades with high utilization ratio',
                 'Percent trades with balance',
                 'Does months since most recent delinquency applied? (e.g. no inquiries, no delinquencies, please select no)', 
                 'Does months since most recent inquiries excluding last 7 days applied? (e.g. no inquiries, no delinquencies, please select no)',
                 'Does months since most recent delinquency information usable? (if there is no usable/valid trades or inquiries, please select no)', 
                 'Does months since most recent inquiries excluding last 7 days information usable? (if there is no usable/valid trades or inquiries, please select no)',
                 'Net fraction revolving burden information usable? (if there is no usable/valid trades or inquiries, please select no)',
                 'Does net fraction installment burden information usable?  (if there is no usable/valid trades or inquiries, please select no)',
                 'Does number revolving trades with balance usable? (if there is no usable/valid trades or inquiries, please select no)' , 
                 'Does number installment trades with balance information usable? (if there is no usable/valid trades or inquiries, please select no)',
                 'Does number bank/national trades with high utilization ratio information usable? (if there is no usable/valid trades or inquiries, please select no)']

for i in range(32):
    if i == 9 or i == 10:
        input_features[0, i] = int(st.selectbox(feature_names[i], list(range(1,10))))
    elif i >= 23: 
        input_features[0, i] = 1 if st.selectbox(feature_names[i], ['No', 'Yes']) == 'No' else 0 
    else:
        input_features[0, i] = st.number_input(feature_names[i], value=0.0)


# Make prediction using the loaded model
prediction = log_reg.predict(input_features)
prediction_proba = log_reg.predict_proba(input_features)


st.subheader("Prediction Result")
if prediction == 1:
    st.write("The application is predicted as HIGH credit risk. Additional information may needed from applicant. ")
else:
    st.write("The application is predicted as LOW credit risk.")
    
st.subheader("Prediction Probabilities")
st.write("Probability of applicant having high credit risk:", prediction_proba[0][1])
st.write("Probability of applicant having low credit risk:", prediction_proba[0][0])
    
st.subheader("Thank you for using our system, hope you have a nice day!")