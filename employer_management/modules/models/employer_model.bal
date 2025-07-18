import ballerina/time;

# Represents an employer record
#
# + id - Unique identifier for the employer
# + name - Name of the employer
# + industry - Industry sector of the employer
# + foundedYear - Year the company was founded
# + employeeCount - Number of employees in the company
# + headquarters - Headquarters location
# + annualRevenue - Annual revenue in USD
# + website - Company website URL
# + contactEmail - Contact email address
# + updatedTime - Last updated timestamp
public type Employer record {|
    string id;
    string name;
    string industry;
    int foundedYear;
    int employeeCount;
    string headquarters;
    decimal annualRevenue;
    string website;
    string contactEmail;
    time:Utc updatedTime;
|};

# Represents employer data for creating a new record
#
# + name - Name of the employer
# + industry - Industry sector of the employer
# + foundedYear - Year the company was founded
# + employeeCount - Number of employees in the company
# + headquarters - Headquarters location
# + annualRevenue - Annual revenue in USD
# + website - Company website URL
# + contactEmail - Contact email address
public type EmployerCreate record {|
    string name;
    string industry;
    int foundedYear;
    int employeeCount;
    string headquarters;
    decimal annualRevenue;
    string website;
    string contactEmail;
|};

# Represents employer data for updating an existing record
#
# + industry - Industry sector of the employer
# + employeeCount - Number of employees in the company
# + headquarters - Headquarters location
# + annualRevenue - Annual revenue in USD
# + website - Company website URL
# + contactEmail - Contact email address
public type EmployerUpdate record {|
    string? industry = ();
    int? employeeCount = ();
    string? headquarters = ();
    decimal? annualRevenue = ();
    string? website = ();
    string? contactEmail = ();
|};