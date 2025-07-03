import requests

url = "https://test.api.amadeus.com/v1/security/oauth2/token"

headers = {
    "Content-Type": "application/x-www-form-urlencoded"
}

data = {
    "grant_type": "client_credentials",
    "client_id": "Azf3sM3HBbCPxaq3f3rPu8T1EBSRq3Ru",         # remplace par ton vrai client_id
    "client_secret": "xRDMPXEfniiKNhnm"       # remplace par ton vrai client_secret
}

response = requests.post(url, headers=headers, data=data)

# Affiche la réponse JSON (token, etc.)
print(response.status_code)
print(response.json())