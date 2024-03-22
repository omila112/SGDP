from flask import Flask, request, jsonify
from urllib.parse import unquote
from fuzzywuzzy import fuzz
import pandas as pd
import re
import warnings
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.multioutput import MultiOutputClassifier
from sklearn.svm import SVC

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

# Set to store processed queries
processed_queries = set()

# Set to store processed chemical names
processed_chemical_names = set()

# Function to match input chemical name with database
def match_chemical_name(input_chemical_name):
    # Check if the chemical name has already been processed
    if input_chemical_name in processed_chemical_names:
        return None, None
    else:
        processed_chemical_names.add(input_chemical_name)

    # Exact string matching
    exact_matches = chemical_data[chemical_data['ChemicalName'].fillna('').str.lower() == input_chemical_name.lower()]
    
    if not exact_matches.empty:
        matched_chemical_names = exact_matches['ChemicalName'].tolist()
        return matched_chemical_names, input_chemical_name
    else:
        # Fuzzy string matching
        fuzzy_matches = [(cn, fuzz.partial_ratio(input_chemical_name.lower(), str(cn).lower())) for cn in chemical_data['ChemicalName']]
        fuzzy_matches = [(cn, score) for cn, score in fuzzy_matches if score > 80]  # Filter based on score threshold
        
        if fuzzy_matches:
            matched_chemical_names = [cn for cn, _ in fuzzy_matches]
            return matched_chemical_names, input_chemical_name
        else:
            return None, None  # No match found

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
            
            # Check if query has already been processed
            if decoded_query in processed_queries:
                return jsonify({"message": "Query already processed."}), 200
            
            processed_queries.add(decoded_query)
            
            print('Received query:', decoded_query)
            matched_results_info = {}  # Dictionary to store matched chemicals and their predictions
            matched_chemicals_list = []  # List to store matched chemical names
            for input_chemical_name in re.split(r'[\n,]', decoded_query):
                input_chemical_name = input_chemical_name.strip()
                if input_chemical_name:
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
