# LSM9DS1 IMU Sensor Integration - Setup Complete ✅

## Overview
Your ESP32 with LSM9DS1 sensor is now fully integrated with the monitoring system!

## What Was Configured

### 1. MQTT Data Collection
- **Topic:** `sensors/esp32/lsm9ds1`
- **Client ID:** `ESP32_LSM9DS1`
- **Data Format:** JSON with nested structure

### 2. MQTT Collector Updated
The collector now parses LSM9DS1 data with:
- **Accelerometer:** 3-axis (accel_x, accel_y, accel_z) in m/s²
- **Gyroscope:** 3-axis (gyro_x, gyro_y, gyro_z) in °/s
- **Magnetometer:** 3-axis (mag_x, mag_y, mag_z) in µT
- **Temperature:** From LSM9DS1 in °C
- **Heading:** Compass direction in degrees (0-360°)

Data is stored in InfluxDB under measurement: `imu_sensors`

### 3. Grafana Dashboard
New visualizations added to `sensors-dashboard.json`:

#### Panel 1: 📊 Accelerometer (3-Axis)
- Time series graph showing X, Y, Z acceleration
- Color coded: Red (X), Green (Y), Blue (Z)
- Shows last value and mean in legend

#### Panel 2: 🔄 Gyroscope (3-Axis)
- Time series graph showing X, Y, Z angular velocity
- Color coded: Red (X), Green (Y), Blue (Z)
- Shows rotation rate in degrees/second

#### Panel 3: 🧲 Magnetometer (3-Axis)
- Time series graph showing X, Y, Z magnetic field
- Color coded: Red (X), Green (Y), Blue (Z)
- Displays magnetic field strength in µT

#### Panel 4: 🧭 Compass Heading (Gauge)
- Circular gauge showing heading direction (0-360°)
- Color zones: Red (N), Yellow (NE), Green (E/SE), Blue (S), etc.

#### Panel 5: 🌡️ LSM9DS1 Temperature
- Time series of temperature from IMU sensor
- Shows last, mean, and max values

#### Panel 6: Current Temperature (Stat)
- Large stat panel showing current IMU temperature

#### Panel 7: Current Direction (Stat)
- Shows compass direction as text (N, NE, E, SE, S, SW, W, NW)
- Color coded by direction

#### Panel 8: 🌡️ Other Temperature Sensors
- Shows data from any other temperature sensors

## Access Your Dashboard

### Grafana Web Interface
- **URL:** http://your-pi-ip:3000
- **Dashboard:** "🔌 MQTT Sensors Data Dashboard"
- **Username:** admin
- **Password:** admin (change on first login)

## Testing MQTT Reception

### View Live MQTT Messages
Run the test script:
```bash
cd /home/rakeshry/Pi_Server
./test-mqtt-subscription.sh
```

### Check mqtt-collector Logs
```bash
docker compose logs mqtt-collector -f
```

You should see messages like:
```
Stored IMU data: topic=sensors/esp32/lsm9ds1, temp=-139.0, heading=89.6
```

### Query InfluxDB Directly
```bash
docker exec influxdb influx query \
  'from(bucket: "sensor_data") 
   |> range(start: -5m) 
   |> filter(fn: (r) => r._measurement == "imu_sensors")' \
  --raw
```

## Current Status ✅

✅ MQTT Broker receiving data on `sensors/esp32/lsm9ds1`
✅ mqtt-collector parsing nested JSON structure
✅ All 10 fields stored in InfluxDB (`imu_sensors` measurement)
✅ Grafana dashboard with 8 visualization panels
✅ Real-time updates every 5 seconds

## Data Verification

Last verified data from InfluxDB shows:
- **Accelerometer:** X: 0.48 m/s², Y: -2.01 m/s², Z: 9.54 m/s² (showing gravity on Z-axis)
- **Gyroscope:** X: -0.03 °/s, Y: 0.02 °/s, Z: -0.02 °/s (minimal rotation)
- **Magnetometer:** X: 0.12 µT, Y: 17.68 µT, Z: -59.7 µT
- **Heading:** ~86-89° (approximately East)
- **Temperature:** -139°C (Note: This seems unusual, may need calibration on ESP32)

## Files Modified

1. `/home/rakeshry/Pi_Server/mqtt-collector/collector.py`
   - Added LSM9DS1 data parser for nested JSON structure
   
2. `/home/rakeshry/Pi_Server/grafana/provisioning/dashboards/sensors-dashboard.json`
   - Added 8 new panels for IMU visualization

3. `/home/rakeshry/Pi_Server/test-mqtt-subscription.sh` (new)
   - Test script for MQTT subscription

## Next Steps (Optional)

1. **Temperature Calibration:** The LSM9DS1 temperature reading of -139°C seems incorrect. Check your ESP32 code for proper temperature reading.

2. **Add Alerts:** Configure Grafana alerts for abnormal sensor readings

3. **Motion Detection:** Use accelerometer/gyroscope data to detect movement patterns

4. **Compass Calibration:** Calibrate magnetometer for accurate heading readings

5. **Data Export:** Set up automated data export for analysis

## Troubleshooting

If dashboard shows no data:
1. Check ESP32 is publishing: `./test-mqtt-subscription.sh`
2. Verify mqtt-collector is running: `docker ps | grep mqtt-collector`
3. Check logs: `docker compose logs mqtt-collector`
4. Verify InfluxDB connection: `docker compose logs grafana | grep -i influx`

---
**Setup completed on:** December 19, 2025
