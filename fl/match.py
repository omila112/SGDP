from flask import Flask, request, jsonify
from urllib.parse import unquote
from fuzzywuzzy import fuzz
import pandas as pd
import re
import warnings

app = Flask(__name__)

# Suppress DtypeWarning
warnings.filterwarnings("ignore", category=pd.errors.DtypeWarning)

# Read data from CSV file with explicit data type specification
chemical_data = pd.read_csv("chemicals_in_cosmetics.csv", dtype={'ChemicalName': str})

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
    # Your prediction code here
    return {
        'Health Hazards': 'Placeholder prediction for ' + input_chemical_name,
        'Additional Information': 'Placeholder prediction for ' + input_chemical_name,
        'Compounds': 'Placeholder prediction for ' + input_chemical_name
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
                            # Get predictions for the matched chemical
                            predictions = predict(matched_chemical)
                            matched_results_info[matched_chemical] = predictions
            
            # Sending matched chemicals and predictions to Flutter
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

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=9000)
