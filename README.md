### Getting Started:

Enable project APIs: `cloudresourcemanager.googleapis.com, container.googleapis.com`    
Set tfvar: `project-id `  
Set env: `GOOGLE_CREDENTIAL`

Sample config where attempting to disable GKE cluster autoscaling looks for default compute SA, even if not present in
project.

Using binary authorization evaluation mode may cause it to not occur.     
`binary_authorization {
evaluation_mode = "DISABLED"
}`


Cluster creation can encounter the same, where using any of the following seem to act as a workaround.  
i) Create with NAP enabled  
ii) Using binary authorization evaluation mode  
