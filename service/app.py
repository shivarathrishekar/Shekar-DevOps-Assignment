from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os
import socket

APP_NAME = os.getenv("APP_NAME", "demo-app")
VERSION = os.getenv("VERSION", "1.0.0")

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/healthz":
            self.send_response(200)
            body = {"status": "ok"}
        elif self.path == "/":
            self.send_response(200)
            body = {
                "app": APP_NAME,
                "version": VERSION,
                "pod": socket.gethostname()
            }
        else:
            self.send_response(404)
            body = {"error": "not found"}

        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(body).encode())

HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
