#!/bin/bash

# Test MQTT subscription for LSM9DS1 sensor data
echo "🔌 Testing MQTT Subscription for LSM9DS1 Sensor Data"
echo "=============================================="
echo ""
echo "Subscribing to topic: sensors/esp32/lsm9ds1"
echo "Press Ctrl+C to stop..."
echo ""

# Subscribe to the LSM9DS1 topic and display incoming messages
docker exec mqtt-broker mosquitto_sub -h localhost -t "sensors/esp32/lsm9ds1" -v
