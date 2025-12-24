#!/bin/bash

# Test MQTT subscription for health sensor data
echo "🫀 Testing MQTT Subscription for Health Sensor Data"
echo "===================================================="
echo ""
echo "Subscribing to topic: sensors/esp32/health"
echo "Press Ctrl+C to stop..."
echo ""

# Subscribe to the health sensor topic and display incoming messages
docker exec mqtt-broker mosquitto_sub -h localhost -t "sensors/esp32/health" -v
