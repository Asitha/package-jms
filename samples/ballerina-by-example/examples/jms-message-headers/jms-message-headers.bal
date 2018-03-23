import ballerina/net.jms;
import ballerina/io;

endpoint jms:ConsumerEndpoint ep1 {
    initialContextFactory: "wso2mbInitialContextFactory",
    providerUrl: "amqp://admin:admin@carbon/carbon?brokerlist='tcp://localhost:5672'"
};

endpoint jms:ClientEndpoint clientEP {
    initialContextFactory:"wso2mbInitialContextFactory",
    providerUrl: "amqp://admin:admin@carbon/carbon?brokerlist='tcp://localhost:5672'"
};

@jms:ServiceConfig {
    destination: "MyQueue" // if this value is not set consumer defaults to destination jmsService.
}
service<jms> jmsService bind ep1 {
    onMessage (endpoint client, jms:Message m) {

        // Read all the supported headers from the message.
        string correlationId = m.getCorrelationID();
        int timestamp = m.getTimestamp();
        string messageType = m.getType();
        string messageId = m.getMessageID();
        boolean redelivered = m.getRedelivered();
        int expirationTime = m.getExpiration();
        int priority = m.getPriority();
        int deliveryMode = m.getDeliveryMode();

        // Print the header values.
        io:println("correlationId : " + correlationId);
        io:println("timestamp : " + timestamp);
        io:println("message type : " + messageType);
        io:println("message id : " + messageId);
        io:println("is redelivered : " + redelivered);
        io:println("expiration time : " + expirationTime);
        io:println("priority : " + priority);
        io:println("delivery mode : " + deliveryMode);
        io:println("----------------------------------");

        jms:Message responseMessage = jms:createTextMessage("{\"name\": \"Ballerina\"}");

        responseMessage.setCorrelationID("response-001");
        responseMessage.setPriority(8);
        responseMessage.setDeliveryMode(1);
        responseMessage.setType("application/json");

        clientEP -> send("MySecondQueue", responseMessage);
    }
}
