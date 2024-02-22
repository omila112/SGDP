import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel

# Read data from CSV file
chemical_data = pd.read_csv("chemicals_in_cosmetics.csv")

# Combine relevant text features into one string for vectorization
chemical_data['combined_features'] = chemical_data['ProductName'].fillna('') + ' ' + chemical_data['ChemicalName'].fillna('')

# Vectorize the text features using TF-IDF
tfidf_vectorizer = TfidfVectorizer(stop_words='english')
tfidf_matrix = tfidf_vectorizer.fit_transform(chemical_data['combined_features'])

# Function to get alternative products based on subcategory similarity
def get_alternative_products(matched_chemical_index, df):
    # Get subcategory of the matched chemical
    matched_subcategory = df.iloc[matched_chemical_index]['SubCategory']

    # Find chemicals with similar subcategories
    alternative_chemicals = [
        dict(df.iloc[idx]) for idx in range(len(df)) if
        idx != matched_chemical_index and df.iloc[idx]['SubCategory'] == matched_subcategory
    ]

    return alternative_chemicals

# Function to match input product name with database and get alternative products
def match_product_name_with_alternatives(input_product_name):
    # Exact string matching
    exact_matches = chemical_data[chemical_data['ProductName'].fillna('').str.lower() == input_product_name.lower()]

    if not exact_matches.empty:
        matched_chemical_index = exact_matches.index[0]
    else:
        return None  # No match found
    

    # Get alternative products based on subcategory similarity
    alternative_chemicals = get_alternative_products(matched_chemical_index, chemical_data)

    return alternative_chemicals

# Example usage
input_product_names = input("Enter the product names separated by commas: ").split(',')


for input_product_name in input_product_names:
    alternative_chemicals = match_product_name_with_alternatives(input_product_name.strip())

    if alternative_chemicals:
        print("\nAlternative Products for product name", input_product_name.strip() + ":")
        
        # Ensure at least 5 distinct alternative products
        distinct_alternatives = set()
        for alternative_chemical in alternative_chemicals:
            if len(distinct_alternatives) >= 5:
                break
            distinct_alternatives.add(alternative_chemical["ProductName"])
            print("ProductName:", alternative_chemical["ProductName"])
            print("CompanyId:", alternative_chemical["CompanyId"])
            print("CompanyName:", alternative_chemical["CompanyName"])
            print("BrandName:", alternative_chemical["BrandName"])
            print("PrimaryCategoryId:", alternative_chemical["PrimaryCategoryId"])
            print()  # Add a newline between alternative products
    else:
        print("\nNo alternative products found for product name", input_product_name.strip() + ". This product may not be in our database.")
