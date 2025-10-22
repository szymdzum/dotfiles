#!/usr/bin/env node
const WebSocket = require('ws');

if (!process.argv[2]) {
  console.error('Usage: cdp-network.js <page-id> [url]');
  process.exit(1);
}

const ws = new WebSocket('ws://localhost:9222/devtools/page/' + process.argv[2]);
let id = 1;

ws.on('open', () => {
  console.error('Connected to CDP');
  ws.send(JSON.stringify({ id: id++, method: 'Network.enable' }));
  if (process.argv[3]) {
    console.error('Navigating to:', process.argv[3]);
    ws.send(JSON.stringify({ id: id++, method: 'Page.navigate', params: { url: process.argv[3] }}));
  }
});

ws.on('error', (err) => {
  console.error('WebSocket error:', err.message);
  process.exit(1);
});

ws.on('close', () => {
  console.error('Connection closed');
});

ws.on('message', (data) => {
  const msg = JSON.parse(data);
  
  // Output key network events
  if (msg.method === 'Network.requestWillBeSent') {
    console.log(JSON.stringify({
      event: 'request',
      url: msg.params.request.url,
      method: msg.params.request.method,
      requestId: msg.params.requestId
    }));
  } else if (msg.method === 'Network.responseReceived') {
    console.log(JSON.stringify({
      event: 'response',
      url: msg.params.response.url,
      status: msg.params.response.status,
      statusText: msg.params.response.statusText,
      mimeType: msg.params.response.mimeType,
      requestId: msg.params.requestId
    }));
  } else if (msg.method === 'Network.loadingFailed') {
    console.log(JSON.stringify({
      event: 'failed',
      errorText: msg.params.errorText,
      requestId: msg.params.requestId
    }));
  }
});
