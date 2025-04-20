import json
import requests
import sys

def get_location_by_ip():
    try:
        geo = requests.get("http://ip-api.com/json/").json()
        return geo.get("city", "Lisbon"), geo.get("country", "Portugal")
    except Exception:
        return "Lisbon", "Portugal"

def get_weather(city):
    url = f"https://wttr.in/{city}?format=j1"
    response = requests.get(url)

    if response.status_code != 200:
        raise Exception(f"Failed to get weather data: status {response.status_code}")
    
    try:
        return response.json()
    except ValueError:
        raise Exception("Invalid JSON response.")

def parse_weather(data, city, country):
    current = data["current_condition"][0]
    area = data["nearest_area"][0]["areaName"][0]["value"]

    return {
        "location": f"{area}, {country}",
        "temperature": f"{current['temp_C']}°C",
        "feels_like": f"{current['FeelsLikeC']}°C",
        "humidity": f"{current['humidity']}%",
        "wind_speed": f"{current['windspeedKmph']} km/h",
        "condition": current["weatherDesc"][0]["value"],
        "sunrise": data["weather"][0]["astronomy"][0]["sunrise"],
        "sunset": data["weather"][0]["astronomy"][0]["sunset"]
    }

def main():
    try:
        # If a city is passed via CLI, use it. Otherwise, use IP-based location.
        if len(sys.argv) > 1:
            city = " ".join(sys.argv[1:])
            country = ""
        else:
            city, country = get_location_by_ip()

        weather_data = get_weather(city)
        result = parse_weather(weather_data, city, country)
        print(json.dumps(result, indent=2, ensure_ascii=False))

    except Exception as e:
        print(json.dumps({ "error": f"Failed to get weather info: {str(e)}" }))

if __name__ == "__main__":
    main()
