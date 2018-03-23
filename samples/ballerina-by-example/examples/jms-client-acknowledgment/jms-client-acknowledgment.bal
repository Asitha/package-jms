import ballerina/net.jms;
import ballerina/io;

endpoint jms:ConsumerEndpoint ep1 {
    initialContextFactory: "wso2mbInitialContextFactory",
    providerUrl: "amqp://admin:admin@carbon/carbon?brokerlist='tcp://localhost:5672'"
};

@jms:ServiceConfig {
    destination: "testQueue",
    acknowledgementMode: "CLIENT_ACKNOWLEDGE"
}
service<jms> jmsService bind ep1 {

    onMessage (jms:JMSMessage m) {
        string messageText = message.getTextMessageContent();
        io:println("Message: " + messageText);
        // Message is acknowledged when the message successfully go out of scope of this resource. This done by the
        // connector.
    }
}
