#!/usr/bin/env node
const WebSocket = require('ws');

if (!process.argv[2]) {
  console.error('Usage: cdp-console.js <page-id> [url]');
  process.exit(1);
}

const ws = new WebSocket('ws://localhost:9222/devtools/page/' + process.argv[2]);
let id = 1;

ws.on('open', () => {
  console.error('Connected to CDP');
  ws.send(JSON.stringify({ id: id++, method: 'Runtime.enable' }));
  ws.send(JSON.stringify({ id: id++, method: 'Log.enable' }));
  ws.send(JSON.stringify({ id: id++, method: 'Console.enable' }));
  
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
  
  // Output console messages
  if (msg.method === 'Runtime.consoleAPICalled') {
    const args = msg.params.args.map(arg => {
      if (arg.type === 'string') return arg.value;
      if (arg.value !== undefined) return arg.value;
      return arg.description || JSON.stringify(arg);
    });
    
    console.log(JSON.stringify({
      type: msg.params.type,
      timestamp: msg.params.timestamp,
      message: args.join(' '),
      stackTrace: msg.params.stackTrace
    }));
  } 
  // Output log entries
  else if (msg.method === 'Log.entryAdded') {
    console.log(JSON.stringify({
      type: msg.params.entry.level,
      timestamp: msg.params.entry.timestamp,
      message: msg.params.entry.text,
      source: msg.params.entry.source,
      url: msg.params.entry.url,
      lineNumber: msg.params.entry.lineNumber
    }));
  }
  // Output exceptions
  else if (msg.method === 'Runtime.exceptionThrown') {
    console.log(JSON.stringify({
      type: 'exception',
      timestamp: msg.params.timestamp,
      message: msg.params.exceptionDetails.text,
      exception: msg.params.exceptionDetails.exception,
      stackTrace: msg.params.exceptionDetails.stackTrace
    }));
  }
});
