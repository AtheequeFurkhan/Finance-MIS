# Employer Management API

A RESTful API service built with Ballerina for managing employer data with Google BigQuery integration.

## 🚀 Features

- **CRUD Operations**: Create, Read, Update, Delete employer records
- **BigQuery Integration**: Persistent storage using Google BigQuery
- **RESTful API**: Standard HTTP endpoints with proper status codes
- **Modular Architecture**: Clean separation of concerns with modules
- **Error Handling**: Comprehensive error handling and logging
- **Configuration Management**: Configurable via TOML files

## 📋 Prerequisites

- **Ballerina**: Version 2201.8.6 (Swan Lake Update 8)
- **Google Cloud Account**: With BigQuery enabled
- **Java Runtime**: Required for Ballerina execution

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd employer_management
   ```

2. **Set up Google Cloud BigQuery**
   - Create a Google Cloud project
   - Enable BigQuery API
   - Create a service account with BigQuery permissions
   - Download the service account key JSON file

3. **Configure the service**
   - Place your service account key file at `./resources/service-account-key.json`
   - Update `config.toml` with your project details

## ⚙️ Configuration

Update the `config.toml` file with your Google Cloud details:

```toml
# Path to your Google service account key file
keyFilePath = "./resources/service-account-key.json"
# Your Google Cloud project ID
projectId = "your-project-id"
# BigQuery dataset ID
datasetId = "employer_data"
# BigQuery table ID
tableId = "employers"
```

## 🗄️ Database Setup

Create the BigQuery dataset and table:

```sql
-- Create dataset
CREATE SCHEMA `your-project-id.employer_data`;

-- Create table
CREATE TABLE `your-project-id.employer_data.employers` (
  id STRING NOT NULL,
  name STRING NOT NULL,
  industry STRING,
  foundedYear INT64,
  employeeCount INT64,
  headquarters STRING,
  annualRevenue FLOAT64,
  website STRING,
  contactEmail STRING,
  updatedTime TIMESTAMP
);
```

## 🚀 Running the Service

1. **Build the project**
   ```bash
   bal build
   ```

2. **Run the service**
   ```bash
   bal run target/bin/employer_management.jar
   ```

The service will start on `http://localhost:9090`

## 📡 API Endpoints

### Get All Employers
```http
GET /employers
```
**Response**: Array of employer objects

### Get Employer by ID
```http
GET /employers/{id}
```
**Response**: Single employer object

### Create New Employer
```http
POST /employers
Content-Type: application/json

{
  "name": "Tech Corp",
  "industry": "Technology",
  "foundedYear": 2020,
  "employeeCount": 150,
  "headquarters": "San Francisco, CA",
  "annualRevenue": 10000000.00,
  "website": "https://techcorp.com",
  "contactEmail": "info@techcorp.com"
}
```

### Update Employer
```http
PUT /employers/{id}
Content-Type: application/json

{
  "industry": "Software",
  "employeeCount": 200,
  "annualRevenue": 15000000.00
}
```

### Delete Employer
```http
DELETE /employers/{id}
```

## 🏗️ Project Structure

```
employer_management/
├── Ballerina.toml          # Project configuration
├── config.toml             # Runtime configuration
├── Dependencies.toml       # Dependencies
├── main.bal               # Main service file
├── load_sample_data.bal   # Sample data loader
├── modules/
│   ├── bigquery_client/   # BigQuery integration
│   │   └── bigquery_client.bal
│   └── models/            # Data models
│       └── employer_model.bal
├── resources/
│   └── service-account-key.json
└── target/                # Build artifacts
```

## 📊 Data Models

### Employer
```ballerina
public type Employer record {
    string id;
    string name;
    string? industry;
    int? foundedYear;
    int? employeeCount;
    string? headquarters;
    decimal? annualRevenue;
    string? website;
    string? contactEmail;
    time:Utc? updatedTime;
};
```

### EmployerCreate
```ballerina
public type EmployerCreate record {
    string name;
    string? industry;
    int? foundedYear;
    int? employeeCount;
    string? headquarters;
    decimal? annualRevenue;
    string? website;
    string? contactEmail;
};
```

### EmployerUpdate
```ballerina
public type EmployerUpdate record {
    string? industry;
    int? foundedYear;
    int? employeeCount;
    string? headquarters;
    decimal? annualRevenue;
    string? website;
    string? contactEmail;
};
```

## 🧪 Testing

### Using cURL

1. **Get all employers**
   ```bash
   curl -X GET http://localhost:9090/employers
   ```

2. **Create an employer**
   ```bash
   curl -X POST http://localhost:9090/employers \
     -H "Content-Type: application/json" \
     -d '{
       "name": "Example Corp",
       "industry": "Technology",
       "foundedYear": 2020,
       "employeeCount": 100,
       "headquarters": "New York, NY",
       "annualRevenue": 5000000.00,
       "website": "https://example.com",
       "contactEmail": "contact@example.com"
     }'
   ```

3. **Update an employer**
   ```bash
   curl -X PUT http://localhost:9090/employers/{id} \
     -H "Content-Type: application/json" \
     -d '{
       "employeeCount": 150,
       "annualRevenue": 7500000.00
     }'
   ```

## 🔧 Development

### Adding New Features

1. **Models**: Add new types in `modules/models/employer_model.bal`
2. **Business Logic**: Extend `modules/bigquery_client/bigquery_client.bal`
3. **API Endpoints**: Add new resources in `main.bal`

### Error Handling

The API returns appropriate HTTP status codes:
- `200 OK`: Successful operations
- `201 Created`: Resource created successfully
- `400 Bad Request`: Invalid request data
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server errors

## 📝 Logging

The service includes structured logging:
- Service initialization events
- BigQuery connection status
- Request/response logging
- Error tracking

## 🔒 Security Considerations

- Service account keys should be kept secure
- Implement authentication/authorization as needed
- Validate input data thoroughly
- Use HTTPS in production

## 🚀 Deployment

For production deployment:

1. **Environment Variables**: Use environment-specific configurations
2. **Container**: Build Docker image for containerized deployment
3. **Load Balancer**: Use reverse proxy for high availability
4. **Monitoring**: Implement health checks and monitoring

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For issues and questions:
- Create an issue in the repository
- Contact the development team

---

**Built with ❤️ using Ballerina and Google BigQuery**
