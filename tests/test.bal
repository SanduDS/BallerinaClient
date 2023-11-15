import ballerina/test;
import ballerina/http;

@test:Config {enable: true, groups: ["unit"]}
public function testGetUserOrgHandleByID() returns error? {
    http:Client clientEndpoint = test:mock(http:Client);
    test:prepare(clientEndpoint).when("get").thenReturn(getMockResponse());
    string userHandleByID = check getUserHandleByID(clientEndpoint, "001");
    test:assertEquals(userHandleByID, "testOrg");
}

function getMockResponse() returns http:Response {
    http:Response mockResponse = new;
    mockResponse.setPayload({
        name: "Test User name",
        id: "001",
        orgHandle: "testOrg",
        orgId: "test0rgID100"
    });
    return mockResponse;
}
