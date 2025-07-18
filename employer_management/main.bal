import ballerina/http;
import ballerina/log;
import employer_management.bigquery_client;
import employer_management.models;

// Provide default values that will be overridden by Config.toml
configurable string keyFilePath = "./resources/service-account-key.json";
configurable string projectId = "your-google-cloud-project-id";
configurable string datasetId = "employer_data";
configurable string tableId = "employers";

# Employer Management Service
service / on new http:Listener(9090) {
    private bigquery_client:BigQueryClient? bqClient = ();

    function init() {
        // Initialize BigQuery client
        do {
            self.bqClient = check new bigquery_client:BigQueryClient(keyFilePath, projectId, datasetId, tableId);
            log:printInfo("Employer Management Service initialized successfully with BigQuery");
        } on fail var e {
            log:printError("Error initializing BigQuery client", e);
            log:printInfo("Service will continue with mock data");
            // Don't panic - service should still start with limited functionality
            self.bqClient = ();
        }
    }

    # Get all employers
    # + return - Array of employers or error response
    resource function get employers() returns models:Employer[]|http:InternalServerError {
        log:printInfo("GET /employers endpoint called");
        if self.bqClient is () {
            return <http:InternalServerError>{
                body: {
                    message: "Service not properly initialized",
                    details: "BigQuery client is not available"
                }
            };
        }
        
        do {
            bigquery_client:BigQueryClient bqClientRef = <bigquery_client:BigQueryClient>self.bqClient;
            return check bqClientRef.getAllEmployers();
        } on fail var e {
            log:printError("Error retrieving employers", e);
            return <http:InternalServerError>{
                body: {
                    message: "Failed to retrieve employers",
                    details: e.toString()
                }
            };
        }
    }

    # Get employer by ID
    # + id - Employer ID
    # + return - Employer record or error response
    resource function get employers/[string id]() returns models:Employer|http:NotFound|http:InternalServerError {
        if self.bqClient is () {
            return <http:InternalServerError>{
                body: {
                    message: "Service not properly initialized",
                    details: "BigQuery client is not available"
                }
            };
        }
        
        do {
            bigquery_client:BigQueryClient bqClientRef = <bigquery_client:BigQueryClient>self.bqClient;
            return check bqClientRef.getEmployerById(id);
        } on fail var e {
            if e.message() == "Employer not found" {
                return <http:NotFound>{
                    body: {
                        message: "Employer not found",
                        details: id
                    }
                };
            }
            
            log:printError("Error retrieving employer", e);
            return <http:InternalServerError>{
                body: {
                    message: "Failed to retrieve employer",
                    details: e.toString()
                }
            };
        }
    }

    # Create a new employer
    # + request - Employer create request
    # + return - Created employer or error response
    resource function post employers(@http:Payload models:EmployerCreate request) returns models:Employer|http:BadRequest|http:InternalServerError {
        if self.bqClient is () {
            return <http:InternalServerError>{
                body: {
                    message: "Service not properly initialized",
                    details: "BigQuery client is not available"
                }
            };
        }
        
        do {
            bigquery_client:BigQueryClient bqClientRef = <bigquery_client:BigQueryClient>self.bqClient;
            return check bqClientRef.createEmployer(request);
        } on fail var e {
            log:printError("Error creating employer", e);
            return <http:InternalServerError>{
                body: {
                    message: "Failed to create employer",
                    details: e.toString()
                }
            };
        }
    }

    # Update an employer
    # + id - Employer ID
    # + request - Employer update request
    # + return - Updated employer or error response
    resource function put employers/[string id](@http:Payload models:EmployerUpdate request) returns models:Employer|http:NotFound|http:InternalServerError {
        if self.bqClient is () {
            return <http:InternalServerError>{
                body: {
                    message: "Service not properly initialized",
                    details: "BigQuery client is not available"
                }
            };
        }
        
        do {
            bigquery_client:BigQueryClient bqClientRef = <bigquery_client:BigQueryClient>self.bqClient;
            return check bqClientRef.updateEmployer(id, request);
        } on fail var e {
            if e.message() == "Employer not found" {
                return <http:NotFound>{
                    body: {
                        message: "Employer not found",
                        details: id
                    }
                };
            }
            
            log:printError("Error updating employer", e);
            return <http:InternalServerError>{
                body: {
                    message: "Failed to update employer",
                    details: e.toString()
                }
            };
        }
    }

    # Delete an employer
    # + id - Employer ID
    # + return - Success response or error
    resource function delete employers/[string id]() returns http:NoContent|http:NotFound|http:InternalServerError {
        if self.bqClient is () {
            return <http:InternalServerError>{
                body: {
                    message: "Service not properly initialized",
                    details: "BigQuery client is not available"
                }
            };
        }
        
        do {
            bigquery_client:BigQueryClient bqClientRef = <bigquery_client:BigQueryClient>self.bqClient;
            boolean deleted = check bqClientRef.deleteEmployer(id);
            if deleted {
                return http:NO_CONTENT;
            }
            return <http:NotFound>{
                body: {
                    message: "Employer not found",
                    details: id
                }
            };
        } on fail var e {
            log:printError("Error deleting employer", e);
            return <http:InternalServerError>{
                body: {
                    message: "Failed to delete employer",
                    details: e.toString()
                }
            };
        }
    }
}

