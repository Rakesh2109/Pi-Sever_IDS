#!/bin/bash
# Test Traffic Generator for Pi_Server Monitoring
# This script generates various types of network traffic to test IDS/monitoring

echo "========================================="
echo "Generating Test Network Traffic"
echo "========================================="

# 1. DNS Queries
echo "[1/7] Generating DNS traffic..."
nslookup google.com 8.8.8.8 >/dev/null 2>&1
nslookup github.com 8.8.8.8 >/dev/null 2>&1
nslookup cloudflare.com 1.1.1.1 >/dev/null 2>&1
echo "  ✓ DNS queries sent"

# 2. HTTP Traffic
echo "[2/7] Generating HTTP traffic..."
curl -s http://example.com >/dev/null 2>&1
curl -s http://neverssl.com >/dev/null 2>&1
curl -s http://httpbin.org/get >/dev/null 2>&1
echo "  ✓ HTTP requests sent"

# 3. HTTPS/TLS Traffic
echo "[3/7] Generating HTTPS/TLS traffic..."
curl -s https://www.google.com >/dev/null 2>&1
curl -s https://www.github.com >/dev/null 2>&1
curl -s https://www.cloudflare.com >/dev/null 2>&1
curl -s https://api.github.com >/dev/null 2>&1
echo "  ✓ HTTPS requests sent"

# 4. ICMP Ping
echo "[4/7] Generating ICMP ping traffic..."
ping -c 10 8.8.8.8 >/dev/null 2>&1 &
ping -c 10 1.1.1.1 >/dev/null 2>&1 &
wait
echo "  ✓ ICMP pings sent"

# 5. Multiple HTTP requests (simulating browsing)
echo "[5/7] Simulating web browsing..."
for i in {1..5}; do
    curl -s https://www.wikipedia.org >/dev/null 2>&1 &
    curl -s https://www.reddit.com >/dev/null 2>&1 &
    curl -s https://www.stackoverflow.com >/dev/null 2>&1 &
done
wait
echo "  ✓ Multiple web requests sent"

# 6. DNS lookups for various domains
echo "[6/7] Generating additional DNS traffic..."
for domain in amazon.com facebook.com twitter.com youtube.com netflix.com; do
    nslookup $domain 8.8.8.8 >/dev/null 2>&1
done
echo "  ✓ Additional DNS queries sent"

# 7. Mixed traffic
echo "[7/7] Generating mixed traffic..."
curl -s http://httpbin.org/status/200 >/dev/null 2>&1
curl -s https://httpbin.org/json >/dev/null 2>&1
curl -s https://httpbin.org/user-agent >/dev/null 2>&1
echo "  ✓ Mixed traffic sent"

echo ""
echo "========================================="
echo "Test Traffic Generation Complete!"
echo "========================================="
echo ""
echo "Wait 10-30 seconds for data to appear in:"
echo "  • Grafana: http://128.39.201.47:3000"
echo "  • Traffic Monitor: http://128.39.201.47:8080"
echo ""
echo "You should now see:"
echo "  ✓ DNS queries"
echo "  ✓ HTTP requests"
echo "  ✓ HTTPS/TLS connections"
echo "  ✓ TCP/UDP connections"
echo "  ✓ Network flows"
echo "========================================="
