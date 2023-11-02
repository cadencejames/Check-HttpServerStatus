# Check-HttpServerStatus

## Introduction
This script is in direct response to recent [Cisco Vulnerabilities](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-iosxe-webui-privesc-j22SaA4z) (CVE-2023-20198 and CVE-2023-20273) in which the http server on Cisco IOS-XE devices can be used to gain unathorized access. This script will check the status of the http server so you can identify which devices will need to be configured.

## Notes
The included 'inventory.csv' is just an example file and will need to be filled out by the user and saved in the same file location as the .ps1 script.

## Pre-Requisites
This script requires a machine with PowerShell 2.0 or newer, PuTTY Release Version 0.72 or newer (with the CLI tool Plink)

## Running

In the base directory with the accompanying `inventory.csv` file run:
```
.\Check-HttpServerStatus.ps1
```
Enter your credentials and the output will be saved in `HTTP Server Output.txt` located in the base file directory.
