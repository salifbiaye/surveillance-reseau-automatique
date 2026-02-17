#!/usr/bin/env python3
"""
API backend pour récupérer les statuts réels des services
"""
import json
import subprocess
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import datetime

class StatusAPIHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        parsed_path = urlparse(self.path)
        
        # CORS headers
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        
        if parsed_path.path == '/api/docker/status':
            # Get Docker container status
            response = self.get_docker_status()
        elif parsed_path.path == '/api/system/uptime':
            # Get system uptime
            response = self.get_system_uptime()
        else:
            response = {'error': 'Unknown endpoint'}
        
        self.wfile.write(json.dumps(response).encode())
    
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    
    def get_docker_status(self):
        """Get status of Docker containers"""
        containers = [
            'surveillance-suricata',
            'surveillance-tcpdump',
            'surveillance-arpwatch',
            'surveillance-elasticsearch',
            'surveillance-kibana',
            'surveillance-arkime',
            'surveillance-filebeat'
        ]
        
        status = {}
        for container in containers:
            try:
                result = subprocess.run(
                    ['docker', 'inspect', '-f', '{{.State.Running}}', container],
                    capture_output=True,
                    text=True,
                    timeout=5
                )
                status[container] = result.stdout.strip() == 'true'
            except Exception as e:
                status[container] = False
        
        return {'containers': status}
    
    def get_system_uptime(self):
        """Get system uptime"""
        try:
            # Get Elasticsearch container uptime
            result = subprocess.run(
                ['docker', 'inspect', '-f', '{{.State.StartedAt}}', 'surveillance-elasticsearch'],
                capture_output=True,
                text=True,
                timeout=5
            )
            
            if result.returncode == 0:
                started_at = result.stdout.strip()
                # Parse and calculate uptime
                # Format: 2024-01-01T12:00:00.000000000Z
                start_time = datetime.datetime.fromisoformat(started_at.replace('Z', '+00:00'))
                now = datetime.datetime.now(datetime.timezone.utc)
                uptime_seconds = (now - start_time).total_seconds()
                uptime_days = uptime_seconds / 86400
                
                return {
                    'uptime_seconds': int(uptime_seconds),
                    'uptime_days': round(uptime_days, 2),
                    'started_at': started_at
                }
        except Exception as e:
            pass
        
        return {'uptime_seconds': 0, 'uptime_days': 0}
    
    def log_message(self, format, *args):
        # Suppress default logging
        pass

if __name__ == '__main__':
    port = 8888
    server = HTTPServer(('0.0.0.0', port), StatusAPIHandler)
    print(f'[API] Status API running on port {port}')
    server.serve_forever()
