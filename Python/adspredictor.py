import streamlit as st
import pickle
import pandas as pd
import numpy as np

# Load the trained model
with open('decision_tree.pkl', 'rb') as file:
    model = pickle.load(file)

# Define the categories and the features they include
categories = {
    'Country': ['Country_Canada', 'Country_United States'],
    'Terminal': ['terminal_App', 'terminal_App&iPad', 'terminal_Web', 'terminal_iPad'],
    'Position': ['position_App&iPad_Image_Live_Top', 'position_App&iPad_Image_Pause',
                 'position_App_Image_Detail', 'position_App_Image_Detail&Original&Intro',
                 'position_App_Image_Home', 'position_App_Image_Home_Banner',
                 'position_App_Image_Intro', 'position_Web_Image_Banner_Left',
                 'position_Web_Image_Banner_Right', 'position_Web_Image_Detail&Original',
                 'position_Web_Image_Detail&Points', 'position_Web_Image_Home_Center',
                 'position_Web_Image_Home_Left', 'position_Web_Image_Home_Right',
                 'position_Web_Image_Live_Center', 'position_Web_Image_Live_Left',
                 'position_Web_Image_Live_Right', 'position_Web_Image_Pause',
                 'position_Web_Image_VOD_Center', 'position_iPad_Image_Detail',
                 'position_iPad_Image_Detail&Original', 'position_iPad_Image_Home',
                 'position_iPad_Image_Home_Banner', 'position_iPad_Image_Original',
                 'position_iPad_Image_Points&Detail'],
    'Size': ['size_1024x363', 'size_160x600',
             'size_300x250', 'size_320x50', 'size_335x190', 'size_728x90']
}

# Create a mapping from the modified feature names to the original names
modified_to_original = {feature.split('_', 1)[1]: feature for category in categories.values() for feature in category}

# Initialize a dictionary to store the user's input
user_input = {key: 0 for key in modified_to_original.values()}

# Display a title
st.title("Predict CTR")
st.header("Please make sure selecting the correct position and size.") 

# For each category, display a dropdown for the user to select a feature
for category, features in categories.items():
    modified_features = [feature.split('_', 1)[1] for feature in features]
    selected_feature = st.selectbox(f"Select a {category}", modified_features)
    user_input[modified_to_original[selected_feature]] = 1

# Create a dataframe from the user's input
user_input_df = pd.DataFrame([user_input])

# When the 'Predict' button is clicked, use the model to make a prediction
if st.button('Predict'):
    prediction = model.predict(user_input_df)
    st.write(f"Predicted CTR: {prediction[0]}")