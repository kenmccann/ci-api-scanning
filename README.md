# ci-api-scanning

The scripts in this repository can be used for automating the scan of an image in the CI/CD pipeline and then polling for the scan results.  This can be useful if the standard Aqua Scanner container cannot be used.

The scripts rely on communication with the Aqua API and therefore utilize the existing scanner daemons which act as slaves to the Aqua Server.  Using this method, the scanning does not take place on the CI/CD build host. 
