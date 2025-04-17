const Gio = imports.gi.Gio;
const St = imports.gi.St;
const Main = imports.ui.main;
const GLib = imports.gi.GLib;

let PADDING = 40;
let weatherContainer;
let pythonScript = `${GLib.get_home_dir()}/.local/share/gnome-shell/extensions/allWeatherInfo-extension@pedrolucas7i/app.py`;

function runPythonAndParse(callback) {
    try {
        let [ok, out, err, status] = GLib.spawn_sync(
            null,
            ["/usr/bin/python3", pythonScript],
            null,
            GLib.SpawnFlags.SEARCH_PATH,
            null
        );

        if (!ok || status !== 0) {
            global.log("❌ Python script failed to execute.");
            callback({ error: "❌ Python execution failed." });
            return;
        }

        let output = imports.byteArray.toString(out);
        let json = JSON.parse(output);
        callback(json);

    } catch (e) {
        global.log("❌ Error running script: " + e.message);
        callback({ error: "❌ Error running script." });
    }
}

function updateWeather() {
    runPythonAndParse((data) => {
        if (!weatherContainer) return;

        weatherContainer.destroy_all_children();

        if (data.error) {
            let errorLabel = new St.Label({ text: data.error, style_class: "zorin-weather-label" });
            weatherContainer.add_child(errorLabel);
            return;
        }

        let mainLabel = new St.Label({
            text: `🌍 ${data.location}`,
            style_class: "zorin-weather-main"
        });

        let tempLabel = new St.Label({
            text: `🌡️ ${data.temperature} (Feels like ${data.feels_like})`,
            style_class: "zorin-weather-temp"
        });

        let conditionLabel = new St.Label({
            text: `☁️ ${data.condition}`,
            style_class: "zorin-weather-condition"
        });

        let extraLabel = new St.Label({
            text: `💧 Humidity: ${data.humidity}    💨 Wind: ${data.wind_speed}`,
            style_class: "zorin-weather-extra"
        });

        let sunLabel = new St.Label({
            text: `☀️ Sunrise: ${data.sunrise}   🌇 Sunset: ${data.sunset}`,
            style_class: "zorin-weather-extra"
        });

        weatherContainer.add_child(mainLabel);
        weatherContainer.add_child(tempLabel);
        weatherContainer.add_child(conditionLabel);
        weatherContainer.add_child(extraLabel);
        weatherContainer.add_child(sunLabel);
    });
}

function scheduleWeatherUpdate() {
    GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 600, () => {
        updateWeather();
        return true;
    });
}

function enable() {

    let monitor = Main.layoutManager.primaryMonitor;

    weatherContainer = new St.BoxLayout({
        vertical: true,
        style_class: "zorin-weather-box"
    });

    Main.layoutManager._backgroundGroup.add_child(weatherContainer);

    let x = monitor.x + (monitor.width - 325 - PADDING);
    let y = monitor.y + PADDING;

    weatherContainer.set_position(
        x, y
    );

    updateWeather();
    scheduleWeatherUpdate();
}

function disable() {
    if (weatherContainer) {
        weatherContainer.destroy();
        weatherContainer = null;
    }
}
