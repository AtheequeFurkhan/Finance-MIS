import ballerinax/googleapis.bigquery;
import ballerina/log;
import ballerina/time;

//BigQuery Service using the official connector available in the ballerina central
public client class BigQueryService{
    private bigquery:Client bgClient;
    private string projectID;
    private string datasetID;

//Initialize the bigQuery Client
public function init(string projectID,string datasetID,string credentialPath) returns error?{

    self.projectID = projectID;
    self.datasetID = datasetID;

        // Configure the BigQuery client
        bigquery:ConnectionConfig config = {
            auth: {
                clientConfig: {
                    credentialsConfig: {
                        path: credentialsPath
                    }
                }
            }
        };

        //Initialize the BigQuery Client
        self.bqClient = check new(config);

        // Ensure the dataset exists
        check self.ensureDatasetExists();
        
        log.printInfo(string `BigQuery service initialized for project: ${projectId}, dataset: ${datasetId}`);
    }

    private function ensureDatasetExists() returns error?{
        bigquery:Dataset|error dataset = self.bqClient -> getDataset(self.projectID, self.datasetID);

        
    }
