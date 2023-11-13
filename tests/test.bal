import ballerina/test;                                                                                      
import ballerina/http;


@test:Config{enable: true, groups: ["integration"]}
function testGetGreeting() returns error? {
    GreetingResponse actualResponse = check getGreeting();
        GreetingResponse expectedResponse = {
        message: "Hello world"
    };

    test:assertEquals(actualResponse, expectedResponse);
}

@test:Config{enable: true, groups: ["integration"]}
function testGetHiGreeting() returns error? {
    GreetingResponse actualResponse = check getGreetingHi("Choreo");
    GreetingResponse expectedResponse = {
        message: "Hi Choreo"
    };

    test:assertEquals(actualResponse, expectedResponse);
}

@test:Config {enable: true, groups: ["unit"]}
public function testGetWelcomeGreeting() returns error? {
    http:Client clientEndpoint = test:mock(http:Client);

    test:prepare(clientEndpoint).when("get").thenReturn(getMockResponse());

    http:Response result = check clientEndpoint->get("/welcome/Ballerina");
    json payload = check result.getJsonPayload();

    test:assertEquals(payload, {"message": "welcome Ballerina"});    
}

function getMockResponse() returns http:Response {
    http:Response mockResponse = new;
    mockResponse.setPayload({"message": "welcome Ballerina"});
    return mockResponse;
}