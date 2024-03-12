import pandas as pd
from textblob import TextBlob

data = pd.read_csv(r'C:\Users\omila\Downloads\chem.csv')

def get_sentiment(text):
    analysis = TextBlob(text)
    if analysis.sentiment.polarity < 0:
        return 'Negative'
    elif analysis.sentiment.polarity == 0:
        return 'Neutral'
    else:
        return 'Positive'

def analyze_sentiment_for_chemical(chemical_name):
    chemical_data = data[data['Chemical'] == chemical_name].copy()  # Create a copy explicitly
    if len(chemical_data) == 0:
        print(f"No data found for chemical: {chemical_name}")
        return
    chemical_data.loc[:, 'sentiment'] = chemical_data['Health Hazards'].apply(get_sentiment)
    sentiment_counts = chemical_data['sentiment'].value_counts()
    print("Sentiment analysis for chemical", chemical_name + ":")
    print(sentiment_counts.to_string(index=False))

    # Calculate the risk level based on the count of sentiment analysis
    risk_level = ''
    if 'Negative' in sentiment_counts and 'Positive' in sentiment_counts:
        if sentiment_counts['Negative'] > sentiment_counts['Positive']:
            risk_level = 'Higher'
        elif sentiment_counts['Negative'] < sentiment_counts['Positive']:
            risk_level = 'Lower'
        else:
            risk_level = 'Equal'
    else:
        risk_level = 'N/A'

    print(f"higher the number, greater the risk")

chemical_name = input("Enter the name of the chemical: ")
analyze_sentiment_for_chemical(chemical_name)
