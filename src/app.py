import requests

try:
    # Use ip-api for more accurate location
    geo_data = requests.get("http://ip-api.com/json/").json()
    city = geo_data.get("city", "Lisbon")
    country = geo_data.get("country", "Portugal")

    # Get weather data
    response = requests.get(f"https://wttr.in/{city}?format=j1")
    weather = response.json()

    current = weather["current_condition"][0]
    area = weather["nearest_area"][0]["areaName"][0]["value"]

    temp_c = current["temp_C"]
    feels_like = current["FeelsLikeC"]
    humidity = current["humidity"]
    wind_speed = current["windspeedKmph"]
    desc = current["weatherDesc"][0]["value"]

    sunrise = weather["weather"][0]["astronomy"][0]["sunrise"]
    sunset = weather["weather"][0]["astronomy"][0]["sunset"]

    weather_text = (
        f"🌍 Weather in {area}, {country}\n"
        f"🌡️ Temp: {temp_c}°C (Feels like {feels_like}°C)\n"
        f"💧 Humidity: {humidity}%\n"
        f"💨 Wind Speed: {wind_speed} km/h\n"
        f"☀️ Sunrise: {sunrise}\n"
        f"🌇 Sunset: {sunset}\n"
        f"☁️ Condition: {desc}"
    )

    print(weather_text)

except Exception as e:
    print("❌ Failed to get weather info:", e)
