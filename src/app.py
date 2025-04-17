#!/usr/bin/env python3
import json
import requests

try:
    geo_data = requests.get("http://ip-api.com/json/").json()
    city = geo_data.get("city", "Lisbon")
    country = geo_data.get("country", "Portugal")

    response = requests.get(f"https://wttr.in/{city}?format=j1")
    weather = response.json()

    current = weather["current_condition"][0]
    area = weather["nearest_area"][0]["areaName"][0]["value"]

    data = {
        "location": f"{area}, {country}",
        "temperature": f"{current['temp_C']}°C",
        "feels_like": f"{current['FeelsLikeC']}°C",
        "humidity": f"{current['humidity']}%",
        "wind_speed": f"{current['windspeedKmph']} km/h",
        "condition": current["weatherDesc"][0]["value"],
        "sunrise": weather["weather"][0]["astronomy"][0]["sunrise"],
        "sunset": weather["weather"][0]["astronomy"][0]["sunset"]
    }

    print(json.dumps(data))  # Output JSON directly

except Exception as e:
    print(json.dumps({ "error": f"Failed to get weather info: {str(e)}" }))
