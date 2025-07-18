import ballerina/http;
import ballerina/log;

service / on new http:Listener(9091) {
    resource function get test() returns string {
        log:printInfo("Test endpoint called");
        return "Hello from minimal service!";
    }
}
