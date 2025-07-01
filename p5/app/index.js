const fs = require('fs');
const path = require('path');

const logLevels = ['INFO', 'WARN', 'ERROR', 'DEBUG'];
const logFile = path.join(__dirname, 'logs', 'application.log');

// Ensure logs directory exists
fs.mkdirSync(path.dirname(logFile), { recursive: true });

function generateLog() {
    const level = logLevels[Math.floor(Math.random() * logLevels.length)];
    const message = `Sample log message ${Math.random().toString(36)}`;
    const timestamp = new Date().toISOString();

    const logEntry = JSON.stringify({
        timestamp,
        level,
        message,
        service: 'log-generator',
        requestId: Math.random().toString(36).substr(2, 9)
    }) + '\n';

    fs.appendFileSync(logFile, logEntry);
    console.log(`Generated log: ${level} - ${message}`);
}

// Generate a log every 2 seconds
setInterval(generateLog, 2000);

console.log('Log generator started...');
