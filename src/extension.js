const { St, GLib } = imports.gi;
const Main = imports.ui.main;
const ByteArray = imports.byteArray;
let weatherIndicator;

function _getWeatherInfo() {
    let scriptPath = GLib.get_home_dir() + '/.local/share/gnome-shell/extensions/zorinOSWeather-extension@zorin-custom/src/app.py';
    try {
        let [ok, stdout, stderr] = GLib.spawn_command_line_sync('python3 ' + scriptPath);
        if (ok) {
            return ByteArray.toString(stdout).trim();
        }
    } catch (e) {
        log('❌ Error running weather script:', e);
    }
    return "☁️ Error fetching weather";
}

function enable() {
    let weatherText = _getWeatherInfo();

    weatherIndicator = new St.Bin({ style_class: 'panel-button' });
    let label = new St.Label({ text: '☁️ Weather' });
    weatherIndicator.set_child(label);

    weatherIndicator.connect('button-press-event', () => {
        label.set_text(_getWeatherInfo());  // Refresh on click
    });

    weatherIndicator.set_tooltip_text(weatherText); // Show full weather on hover

    Main.panel._rightBox.insert_child_at_index(weatherIndicator, 0);
}

function disable() {
    Main.panel._rightBox.remove_child(weatherIndicator);
}