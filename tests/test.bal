import ballerina/test;                                                                                      


@test:Config{enable: true, groups: ["unit"]}
function testGetGreetingPactTest() returns error? {
    GreetingResponse actualResponse = check getGreeting();
        GreetingResponse expectedResponse = {
        message: "Hello world"
    };

    test:assertEquals(actualResponse, expectedResponse);
}

@test:Config{enable: true, groups: ["unit"]}
function testGetHiGreetingPactTest() returns error? {
    GreetingResponse actualResponse = check getGreetingHi("Choreo");
    GreetingResponse expectedResponse = {
        message: "Hi Choreo"
    };

    test:assertEquals(actualResponse, expectedResponse);
}