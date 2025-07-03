// import ballerina/config; // Note: Deprecated in Swan Lake, consider using `ballerina/os` for env vars
import ballerina/log;
import ballerina/task;
import ballerina/io;
import ballerina/time;
import ballerina/os; // For command-line arguments
// import ballerina/runtime; // For runtime:sleep

// Configure log level with validation
configurable string logLevel = "INFO";

public function main() returns error? {
    // Validate and set log level
    string[] validLogLevels = ["DEBUG", "INFO", "WARN", "ERROR"];
    if validLogLevels.indexOf(logLevel.toUpper()) is int {
        log:setModuleLogLevel("", logLevel.toUpper());
    } else {
        log:printWarn("Invalid log level: " + logLevel + ", defaulting to INFO");
        log:setModuleLogLevel("", "INFO");
    }
    
    log:printInfo("E-commerce Analytics Pipeline starting up...");
    
    // Parse command-line arguments
    boolean runOnce = false;
    boolean fullSync = false;
    boolean setupTransfer = false;
    
    string[] args = os:getArgs();
    foreach var arg in args {
        match arg {
            "--run-once" => { runOnce = true; }
            "--full-sync" => { fullSync = true; }
            "--setup-transfer" => { setupTransfer = true; }
        }
    }
    
    if setupTransfer {
        // Setup MySQL to BigQuery data transfer service
        log:printInfo("Setting up MySQL to BigQuery data transfer...");
        ETLPipeline pipeline = check new();
        string|error transferId = pipeline.setupMySQLTransfer();
        
        if transferId is string {
            log:printInfo(string `Transfer setup successfully with ID: ${transferId}`);
        } else {
            log:printError("Failed to set up transfer", 'error = transferId);
        }
        
        check pipeline.close();
        return;
    }
    
    // Get sync frequency with default and validation
    int syncFrequencyMinutes = config:getAsInt("application.sync_frequency_minutes", 60);
    if syncFrequencyMinutes <= 0 {
        log:printError("Invalid sync frequency, must be positive");
        return error("Invalid configuration: sync_frequency_minutes must be positive");
    }
    
    if runOnce {
        // Run ETL once and exit
        log:printInfo("Running ETL pipeline once" + (fullSync ? " (full sync)" : ""));
        ETLPipeline pipeline = check new();
        check pipeline.runETL(fullSync);xs
        check pipeline.close();
        log:printInfo("ETL pipeline completed, exiting");
    } else {
        // Schedule ETL to run periodically
        log:printInfo(string `Scheduling ETL pipeline to run every ${syncFrequencyMinutes} minutes`);
        
        // Run initial sync
        ETLPipeline initialPipeline = check new();
        check initialPipeline.runETL(fullSync);
        check initialPipeline.close();
        log:printInfo("Initial ETL pipeline run completed");
        
        // Schedule subsequent runs
        task:JobId jobId = check task:scheduleJobRecurByFrequency(
            new ETLJob(fullSync), 
            syncFrequencyMinutes,
            maxCount = -1 // Run indefinitely
        );
        
        log:printInfo(string `ETL job scheduled with ID: ${jobId.toString()}`);
        
        // Register shutdown hook to keep application running cleanly
        runtime:onGracefulStop(function() returns error? {
            log:printInfo("Shutting down ETL pipeline...");
            // Perform any cleanup if needed
        });
    }
}

// ETL Job class for scheduled execution
class ETLJob {
    private boolean fullSync;
    
    public function init(boolean fullSync = false) {
        self.fullSync = fullSync;
    }
    
    *task:Job;
    public function execute() returns error? {
        log:printInfo("Running scheduled ETL job: " + time:utcToString(time:utcNow()));
        
        ETLPipeline pipeline = check new();
        error? result = trap pipeline.runETL(self.fullSync);
        error? closeResult = pipeline.close();
        
        if result is error {
            log:printError("ETL job execution failed", 'error = result);
            return result;
        }
        
        if closeResult is error {
            log:printError("Failed to close ETL pipeline", 'error = closeResult);
            return closeResult;
        }
    }
}

// Placeholder ETLPipeline class (to be implemented based on actual requirements)
class ETLPipeline {
    public function init() returns error? {
        // Initialize resources (e.g., database connections)
        log:printInfo("Initializing ETLPipeline...");
    }
    
    public function runETL(boolean fullSync) returns error? {
        // Implement ETL logic (e.g., extract from MySQL, transform, load to BigQuery)
        log:printInfo("Running ETL process" + (fullSync ? " (full sync)" : " (incremental sync)"));
        // Placeholder: Add actual ETL logic here
    }
    
    public function setupMySQLTransfer() returns string|error {
        // Setup data transfer service
        log:printInfo("Setting up MySQL to BigQuery transfer...");
        // Placeholder: Return a transfer ID or error
        return "transfer-12345";
    }
    
    public function close() returns error? {
        // Clean up resources
        log:printInfo("Closing ETLPipeline...");
    }
}