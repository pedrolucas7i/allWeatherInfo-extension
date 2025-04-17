import os
import requests
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("API_WEATHER_KEY")

# Get location based on IP
geo_req = requests.get("https://ipinfo.io/json")
geo_data = geo_req.json()
city = geo_data.get("city", "Lisbon")

# Fetch weather data
url = f"https://api.openweathermap.org/data/2.5/weather?q={city},PT&appid={API_KEY}&units=metric&lang=en"
res = requests.get(url)

if res.status_code != 200:
    print(f"❌ Error fetching weather: {res.status_code}")
else:
    data = res.json()
    city_name = data['name']
    description = data['weather'][0]['description'].capitalize()
    temp = data['main']['temp']
    feels_like = data['main']['feels_like']
    humidity = data['main']['humidity']
    wind_speed = data['wind']['speed']
    sunrise = datetime.utcfromtimestamp(data['sys']['sunrise']).strftime('%H:%M')
    sunset = datetime.utcfromtimestamp(data['sys']['sunset']).strftime('%H:%M')

    weather_text = (
        f"🌍 Weather in {city_name}, Portugal 🇵🇹\\n"
        f"🌡️ Temp: {temp:.0f}°C (Feels like {feels_like:.0f}°C)\\n"
        f"💧 Humidity: {humidity}%\\n"
        f"💨 Wind Speed: {wind_speed} m/s\\n"
        f"☀️ Sunrise: {sunrise} UTC\\n"
        f"🌇 Sunset: {sunset} UTC\\n"
        f"☁️ Condition: {description}"
    )

    print(weather_text)
