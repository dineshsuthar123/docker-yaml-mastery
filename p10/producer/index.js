const { Kafka } = require('kafkajs');

const kafka = Kafka({
    clientId: 'user-event-producer',
    brokers: [process.env.KAFKA_BROKER]
});

const producer = kafka.producer();

const events = [
    'user_login',
    'user_logout',
    'page_view',
    'button_click',
    'purchase',
    'cart_add',
    'cart_remove'
];

async function produceEvents() {
    await producer.connect();
    console.log('Producer connected');

    setInterval(async () => {
        const event = events[Math.floor(Math.random() * events.length)];
        const message = {
            eventType: event,
            userId: Math.floor(Math.random() * 1000),
            timestamp: new Date().toISOString(),
            data: {
                sessionId: Math.random().toString(36),
                userAgent: 'Mozilla/5.0 (compatible)',
                ip: `192.168.1.${Math.floor(Math.random() * 255)}`
            }
        };

        await producer.send({
            topic: process.env.TOPIC_NAME,
            messages: [{
                key: message.userId.toString(),
                value: JSON.stringify(message)
            }]
        });

        console.log(`Sent event: ${event} for user ${message.userId}`);
    }, 2000);
}

produceEvents().catch(console.error);
