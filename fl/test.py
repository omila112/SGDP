import unittest
import requests

class TestChemicalPrediction(unittest.TestCase):
    def setUp(self):
        
        self.url = 'http://127.0.0.1:9000/predict'

    def test_predict_additional_information(self):
        
        data = {
            'MatchedChemicalNames': ['Chemical A', 'Chemical B']
        }

        # Send POST request to Flask app
        response = requests.post(self.url, json=data)

        # Check if response status code is 200 (OK)
        self.assertEqual(response.status_code, 200)

      
        predictions = response.json()
        self.assertIn('Chemical A', predictions)
        self.assertIn('Chemical B', predictions)
        self.assertIn('Health Hazards', predictions['Chemical A'])
        self.assertIn('Additional Information', predictions['Chemical A'])
        self.assertIn('Compounds', predictions['Chemical A'])
        self.assertIn('Health Hazards', predictions['Chemical B'])
        self.assertIn('Additional Information', predictions['Chemical B'])
        self.assertIn('Compounds', predictions['Chemical B'])

if __name__ == '__main__':
    unittest.main()
