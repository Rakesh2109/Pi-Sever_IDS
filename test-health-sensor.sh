#!/bin/bash

# Test health sensor data publishing
echo "🫀 Testing Health Sensor Data Publishing"
echo "=========================================="
echo ""
echo "Publishing to topic: sensors/esp32/health"
echo ""

# Simulate health sensor data with varying values
for i in {1..10}; do
    # Generate realistic random values
    HEART_RATE=$((60 + RANDOM % 40))  # 60-100 BPM
    HR_CONFIDENCE=$((85 + RANDOM % 15))  # 85-100%
    OXYGEN=$((95 + RANDOM % 5))  # 95-100%
    SPO2_CONFIDENCE=$((80 + RANDOM % 20))  # 80-100%
    TIMESTAMP=$(($(date +%s) - 1609459200))  # Time since 2021-01-01
    
    # Create JSON payload
    PAYLOAD="{\"heartRate\":$HEART_RATE,\"confidence\":$HR_CONFIDENCE,\"oxygen\":$OXYGEN,\"oxygenConfidence\":$SPO2_CONFIDENCE,\"timestamp\":$TIMESTAMP}"
    
    echo "[$i] Publishing: $PAYLOAD"
    
    # Publish to MQTT
    docker exec mqtt-broker mosquitto_pub -h localhost -t "sensors/esp32/health" -m "$PAYLOAD"
    
    sleep 2
done

echo ""
echo "✅ Test complete! Check Grafana dashboard at http://$(hostname -I | awk '{print $1}'):3000"
