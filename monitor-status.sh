#!/bin/bash
# Real-time Monitor Display for Pi_Server
# Shows live statistics from Suricata and system

echo "========================================="
echo "Pi_Server Real-Time Monitor"
echo "========================================="
echo ""

# Function to count events
count_events() {
    local log_file="/home/rakeshry/Pi_Server/suricata/logs/eve.json"
    local event_type=$1
    grep -c "\"event_type\":\"$event_type\"" "$log_file" 2>/dev/null || echo "0"
}

# Show Suricata statistics
echo "📊 SURICATA EVENT COUNTS:"
echo "  Flow Events:    $(count_events 'flow')"
echo "  Netflow:        $(count_events 'netflow')"
echo "  HTTP:           $(count_events 'http')"
echo "  DNS:            $(count_events 'dns')"
echo "  TLS:            $(count_events 'tls')"
echo "  Alerts:         $(count_events 'alert')"
echo ""

# Show recent events (last 10)
echo "🔍 RECENT EVENTS (Last 10 non-stats):"
tail -100 /home/rakeshry/Pi_Server/suricata/logs/eve.json | \
  grep -v '"event_type":"stats"' | \
  tail -10 | \
  while read line; do
    timestamp=$(echo "$line" | grep -o '"timestamp":"[^"]*"' | cut -d'"' -f4 | cut -d'T' -f2 | cut -d'+' -f1)
    event_type=$(echo "$line" | grep -o '"event_type":"[^"]*"' | cut -d'"' -f4)
    src_ip=$(echo "$line" | grep -o '"src_ip":"[^"]*"' | head -1 | cut -d'"' -f4)
    dest_ip=$(echo "$line" | grep -o '"dest_ip":"[^"]*"' | head -1 | cut -d'"' -f4)
    proto=$(echo "$line" | grep -o '"proto":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$src_ip" ] && [ -n "$dest_ip" ]; then
      echo "  $timestamp | $event_type | $proto | $src_ip → $dest_ip"
    fi
  done

echo ""
echo "📁 ZEEK LOGS:"
echo "  Log files: $(ls /home/rakeshry/Pi_Server/zeek/logs/current/*.log 2>/dev/null | wc -l)"
echo "  Recent connections: $(tail -10 /home/rakeshry/Pi_Server/zeek/logs/current/conn.log 2>/dev/null | wc -l)"
echo ""

echo "💾 PCAP CAPTURES:"
pcap_count=$(ls /home/rakeshry/Pi_Server/pcap/*.pcap* 2>/dev/null | wc -l)
pcap_size=$(du -sh /home/rakeshry/Pi_Server/pcap 2>/dev/null | cut -f1)
echo "  Files: $pcap_count"
echo "  Total Size: $pcap_size"
echo ""

echo "🌐 DOCKER SERVICES:"
docker compose ps --format "table {{.Service}}\t{{.Status}}" 2>/dev/null | grep -E "suricata|zeek|promtail|loki|grafana|traffic-monitor" || echo "  (Run from Pi_Server directory)"
echo ""

echo "========================================="
echo "Dashboards:"
echo "  Grafana:        http://128.39.201.47:3000"
echo "  Traffic Monitor: http://128.39.201.47:8080"
echo "========================================="
echo ""
echo "Commands:"
echo "  Generate traffic: bash generate-test-traffic.sh"
echo "  Watch logs:       tail -f suricata/logs/eve.json | grep -v stats"
echo "  This script:      bash monitor-status.sh"
echo "========================================="
