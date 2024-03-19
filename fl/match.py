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
            matched_results = set()  # Use a set to store unique chemical names
            for input_chemical_name in re.split(r'[\n,]', decoded_query):
                input_chemical_name = input_chemical_name.strip()
                if input_chemical_name:
                    matched_chemicals, returned_input_chemical_name = match_chemical_name(input_chemical_name)
                    if matched_chemicals:
                        # Check if the chemical name matches the returned input chemical name
                        if input_chemical_name.lower() == returned_input_chemical_name.lower():
                            matched_results.update(matched_chemicals)  # Add matched chemical names to the set
                            print("Matches found for chemical name", input_chemical_name + ":", len(matched_chemicals))
                            for matched_chemical in matched_chemicals:
                                print("Chemical name:", matched_chemical)
                        else:
                            print("Skipping duplicate chemical name:", input_chemical_name)
            matched_results_list = list(matched_results)
            if matched_results_list:
                print("Matched chemical names:", matched_results_list)
                return jsonify({"MatchedChemicalNames": matched_results_list}), 200
            else:
                return jsonify({"message": "No matches found for the provided chemical names."}), 404
        else:
            return jsonify({"message": "Invalid data format."}), 400
    else:
        return jsonify({"message": "Only POST requests are allowed."}), 405

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=9000)
