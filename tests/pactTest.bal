import ballerina/test;
import ballerina/http;
import dhanushkasd/pact;

pact:Client pactMockServerClient = check new ("localhost:1234");
http:Client userServiceClient =  check new("localhost:1234");

@test:BeforeGroups { value:["pact"]}
function beforeGroupsFunc() returns error? {
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
function getUserHandlerByIdPactTest() returns error? {
    pact:Interaction interaction = {
        description: "Get user Org handler by user Id",
        request: {
            path: "/user/001",
            method: "GET"
        },
        response: {
            status: 200,
            headers: {
                "Content-Type": "application/json"
            },
            body: {
                "name":"Dhanushka", "id":"001", "orgId":"choreoogid001", "orgHandle":"mytestorg"
            }
        }
    };

    string registrationStatus = check pactMockServerClient->registerInteraction(interaction);
    test:assertEquals(registrationStatus.toString().trim(), "Registered interactions", "Registration fails");
    string userHandleByID = check getUserHandleByID(userServiceClient, "001");
    test:assertEquals(userHandleByID, "mytestorg");    

}

@test:AfterGroups {value: ["pact"]}
function afterGroupsFunc() returns error? {
    _ = check pactMockServerClient->writePact();
}
