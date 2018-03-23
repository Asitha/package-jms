import ballerina/net.jms;
import ballerina/net.http;

endpoint jms:ConsumerEndpoint jmsEP {
    initialContextFactory:"wso2mbInitialContextFactory",
    providerUrl: "amqp://admin:admin@carbon/carbon?brokerlist='tcp://localhost:5672'",
    destinationType: "topic"
};

@jms:SourceConfig {
    acknowledgmentMode: "CLIENT_ACKNOWLEDGEMENT"
}
service<jms:Service> jmsService bind jmsEP {
    onMessage (endpoint client, jms:JMSMessage m) {
        endpoint<http:HttpClient> httpConnector {
             create http:HttpClient ("http://localhost:8080",{});
        }

        http:Request req = {};

        // Retrieve the string payload using native function and set as a json payload.
        req.setStringPayload(m.getTextMessageContent());
        var resp,err = httpConnector.get("/my-webapp/echo", req);
        println("POST response: ");
        println(resp.getJsonPayload());
    }
}
