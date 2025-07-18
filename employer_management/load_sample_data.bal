import ballerina/http;
import ballerina/io;
import employer_management.models;

public function main() returns error? {
    http:Client apiClient = check new ("http://localhost:8080");
    
    models:EmployerCreate[] sampleEmployers = [
        {
            name: "Acme Corporation",
            industry: "Manufacturing",
            foundedYear: 1985,
            employeeCount: 2500,
            headquarters: "New York, USA",
            annualRevenue: 15000000.00,
            website: "https://www.acmecorp.com",
            contactEmail: "info@acmecorp.com"
        },
        {
            name: "TechNova",
            industry: "Technology",
            foundedYear: 2005,
            employeeCount: 750,
            headquarters: "San Francisco, USA",
            annualRevenue: 8500000.00,
            website: "https://www.technova.io",
            contactEmail: "contact@technova.io"
        },
        {
            name: "Global Finance Partners",
            industry: "Financial Services",
            foundedYear: 1992,
            employeeCount: 1200,
            headquarters: "London, UK",
            annualRevenue: 22000000.00,
            website: "https://www.globalfinance.com",
            contactEmail: "info@globalfinance.com"
        },
        {
            name: "EcoSolutions",
            industry: "Environmental Services",
            foundedYear: 2010,
            employeeCount: 320,
            headquarters: "Berlin, Germany",
            annualRevenue: 4800000.00,
            website: "https://www.ecosolutions.de",
            contactEmail: "contact@ecosolutions.de"
        },
        {
            name: "HealthPlus",
            industry: "Healthcare",
            foundedYear: 2000,
            employeeCount: 950,
            headquarters: "Chicago, USA",
            annualRevenue: 12000000.00,
            website: "https://www.healthplus.org",
            contactEmail: "support@healthplus.org"
        }
    ];
    
    foreach var employer in sampleEmployers {
        models:Employer|http:Response response = check apiClient->post("/employers", employer);
        if response is models:Employer {
            io:println("Created employer: ", response.name);
        } else {
            io:println("HTTP Response status: ", response.statusCode);
        }
    }
    
    io:println("Sample data loaded successfully!");
}