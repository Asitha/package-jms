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
    destination: "MyQueue"
}
service<jms> jmsService bind ep1 {
    onMessage (endpoint client, jms:Message message) {

        // Get and Print message properties values.
        // Ballerina Supports JMS property types of string, boolean, float and int
        io:println("String Property : " + message.getStringProperty("string-prop"));
        io:println("Boolean Property : " + message.getBooleanProperty("boolean-prop"));
        io:println("----------------------------------");

        // Create an empty Ballerina message.
        jms:JMSMessage responseMessage = jms:createTextMessage("Hello from Ballerina!");
        // Set a string payload to the message.
        responseMessage.setIntProperty("int-prop",777);
        responseMessage.setFloatProperty("float-prop",123);

        clientEP->send("MySecondQueue", responseMessage);
    }
}

