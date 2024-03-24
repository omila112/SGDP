import unittest
import json
from matchall import app

class TestMatchAllAPI(unittest.TestCase):
    
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True
        
    def test_receive_data(self):
        query = {'Query': 'Chemical1, Chemical2, Chemical3'}
        response = self.app.post('/api', json=query)
        data = json.loads(response.data)
        self.assertEqual(response.status_code, 200)
        self.assertIn('MatchedChemicalNames', data)
        self.assertIsInstance(data['MatchedChemicalNames'], list)
        
    def test_predict_additional_information(self):
        data = {'MatchedChemicalNames': ['Chemical1', 'Chemical2']}
        response = self.app.post('/predict', json=data)
        self.assertEqual(response.status_code, 200)
        predictions = json.loads(response.data)
        self.assertIsInstance(predictions, dict)
        self.assertEqual(len(predictions), 2)
        self.assertIn('Chemical1', predictions)
        self.assertIn('Chemical2', predictions)
        chemical1_predictions = predictions['Chemical1']
        self.assertIn('Health Hazards', chemical1_predictions)
        self.assertIn('Additional Information', chemical1_predictions)
        self.assertIn('Compounds', chemical1_predictions)
        
if __name__ == '__main__':
    unittest.main()
