from flask import Flask, request, jsonify
from urllib.parse import unquote
from fuzzywuzzy import fuzz, process
import pandas as pd
import re
import warnings
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.multioutput import MultiOutputClassifier
from sklearn.svm import SVC
import string

app = Flask(__name__)

# Suppress DtypeWarning
warnings.filterwarnings("ignore", category=pd.errors.DtypeWarning)

# Read data from CSV file with explicit data type specification
chemical_data = pd.read_csv("chemicals_in_cosmetics.csv", dtype={'ChemicalName': str})

# Load the dataset for predictions
cos_data = pd.read_csv('chem.csv')

# Separate features (X) and target variables (Y)
X = cos_data['Chemical']
Y = cos_data[['Health Hazards', 'Additional Information', 'Compounds']]

# Vectorize the chemical names using bag-of-words representation
vectorizer = CountVectorizer()
X_vectorized = vectorizer.fit_transform(X)

# Train multi-output classifier with SVM classifiers
classifier = MultiOutputClassifier(SVC())
classifier.fit(X_vectorized, Y)

# Cache to store results of previous queries
query_cache = {}

# Function to tokenize chemical names
def tokenize_chemical_name(chemical_name):
    # Remove punctuation and special characters
    chemical_name = chemical_name.translate(str.maketrans('', '', string.punctuation))
    # Tokenize based on space and common chemical delimiters
    tokens = re.split(r'[\s\-/]', chemical_name)
    # Remove empty tokens
    tokens = [token.strip() for token in tokens if token.strip()]
    return tokens

# Function to match input chemical name with database
def match_chemical_name(input_chemical_name):
    # Check if the result is cached
    if input_chemical_name in query_cache:
        return query_cache[input_chemical_name]

    # Normalize and tokenize input
    input_tokens = tokenize_chemical_name(input_chemical_name.lower())

    matched_chemical_names = set()
    # Exact string matching
    exact_matches = chemical_data[chemical_data['ChemicalName'].str.lower() == input_chemical_name]
    matched_chemical_names.update(exact_matches['ChemicalName'].tolist())

    # Fuzzy string matching with tokenized names
    for name in chemical_data['ChemicalName']:
        if pd.notna(name):  # Skip NaN values
            name_tokens = tokenize_chemical_name(name.lower())
            if all(token in name_tokens for token in input_tokens):
                matched_chemical_names.add(name)

    # If no exact matches found, use fuzzy matching
    if not matched_chemical_names:
        fuzzy_matches = process.extract(input_chemical_name, chemical_data['ChemicalName'], limit=5)
        matched_chemical_names.update([match[0] for match in fuzzy_matches if match[1] >=95])

    # Cache the result
    query_cache[input_chemical_name] = (list(matched_chemical_names), input_chemical_name)
    return list(matched_chemical_names), input_chemical_name

# Method to predict health hazards, additional information, and compounds
def predict(input_chemical_name):
    # Vectorize the input chemical name
    chemical_vectorized = vectorizer.transform([input_chemical_name])

    # Predictions for the input chemical name
    predictions = classifier.predict(chemical_vectorized)[0]
    
    return {
        'Health Hazards': predictions[0],
        'Additional Information': predictions[1],
        'Compounds': predictions[2]
    }

@app.route('/api', methods=['POST'])  
def receive_data():
    if request.method == 'POST':
        data = request.json  
        if data and 'Query' in data:
            query = data['Query']
            decoded_query = unquote(query)
            
            print('Received query:', decoded_query)
            matched_results_info = {}  # Dictionary to store matched chemicals and their predictions
            matched_chemicals_list = []  # List to store matched chemical names
            for input_chemical_name in re.split(r'[\n,]', decoded_query):
                input_chemical_name = input_chemical_name.strip()
                if input_chemical_name:
                    # Check if the result is cached
                    if input_chemical_name in query_cache:
                        matched_chemicals, returned_input_chemical_name = query_cache[input_chemical_name]
                    else:
                        matched_chemicals, returned_input_chemical_name = match_chemical_name(input_chemical_name)
                    if matched_chemicals:
                        matched_chemicals_list.extend(matched_chemicals)
                        print("Matches found for chemical name:", input_chemical_name)
                        for matched_chemical in matched_chemicals:
                            print("Matched chemical name:", matched_chemical)
            
            # Sending matched chemicals to Flutter
            if matched_chemicals_list:
                matched_results_info['MatchedChemicalNames'] = matched_chemicals_list
                print("Matched chemical names:", matched_chemicals_list)
                return jsonify(matched_results_info), 200
            
            # No matches found for the provided chemical names
            else:
                return jsonify({"message": "No matches found for the provided chemical names."}), 404
        else:
            return jsonify({"message": "Invalid data format."}), 400
    else:
        return jsonify({"message": "Only POST requests are allowed."}), 405

@app.route('/predict', methods=['POST'])  
def predict_additional_information():
    data = request.json  
    if data and 'MatchedChemicalNames' in data and data['MatchedChemicalNames']:
        matched_chemicals = data['MatchedChemicalNames']
        print("Predicting additional information for matched chemicals:", matched_chemicals)
        additional_info = {}
        for chemical_name in matched_chemicals:
            predictions = predict(chemical_name)
            # Update the dictionary with formatted data for each chemical
            additional_info[chemical_name] = {
                'Health Hazards': predictions['Health Hazards'],
                'Additional Information': predictions['Additional Information'],
                'Compounds': predictions['Compounds']
            }
        print("Additional information predictions:", additional_info)
        return jsonify(additional_info), 200
    else:
        return jsonify({"message": "Invalid data format or no matched chemicals provided."}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=9000)
