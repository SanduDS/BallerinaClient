import ballerina/http;

type User readonly & record {|
    string name;
    string id;
    string orgId;
    string orgHandle;
|};


public isolated function getUserByID(http:Client userServiceClient, string id) returns User|error {
    User response = check userServiceClient->/user/[id];
    return response;
}

public isolated function getUserHandleByID(http:Client userServiceClient, string id) returns string|error {
    json response = check userServiceClient->/user/orghandle/[id];
    return (check response.orghandle).toString();
}