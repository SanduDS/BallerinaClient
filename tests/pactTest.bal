import ballerina/test;
import dhanushkasd/pact;

pact:Client pactMockServerClient = check new ("localhost:1234");

@test:BeforeSuite
function beforeSuite() returns error? {
    string mockServiceStatus = check pactMockServerClient->getMockServiceStatus();
    test:assertEquals(mockServiceStatus.toString().trim(), "Mock service running", "Mock server is not running");
}

@test:AfterEach
@test:Config {groups:["pact"]}
function AfterEach() returns error? {
    string deletionResponse = check pactMockServerClient->deleteInteraction();
    test:assertEquals(deletionResponse.toString().trim(), "Cleared interactions", "Interaction deletion fails");
}

@test:Config {enable: true, groups: ["pact"]}
function getGreetingPactTest() returns error? {
    pact:Interaction interaction = {
        description: "Get hello world greeting from ballerina service",
        request: {
            path: "/hello",
            method: "GET"
        },
        response: {
            status: 200,
            headers: {
                "Content-Type": "application/json"
            },
            body: {
                message: "Hello world"
            }
        }
    };

    string registrationStatus = check pactMockServerClient->registerInteraction(interaction);
    test:assertEquals(registrationStatus.toString().trim(), "Registered interactions", "Registration fails");
    GreetingResponse actualResponse = check getGreeting();
    GreetingResponse expectedResponse = {
        message: "Hello world"
    };

    test:assertEquals(actualResponse, expectedResponse);
}


@test:Config {enable: true, groups: ["pact"]}
function getGreetingHiPactTest() returns error? {
    pact:Interaction interaction = {
        description: "Get hi greeting from ballerina service",
        request: {
            path: "/hi/Ballerina",
            method: "GET"
        },
        response: {
            status: 200,
            headers: {
                "Content-Type": "application/json"
            },
            body: {
                message: "Hi Ballerina"
            }
        }
    };

    string registrationStatus = check pactMockServerClient->registerInteraction(interaction);
    test:assertEquals(registrationStatus.toString().trim(), "Registered interactions", "Registration fails");
    GreetingResponse actualResponse = check getGreetingHi("Ballerina");
    GreetingResponse expectedResponse = {
        message: "Hi Ballerina"
    };

    test:assertEquals(actualResponse, expectedResponse);

}

@test:AfterSuite {}
function afterSuite() returns error? {
    _ = check pactMockServerClient->writePact();
}
