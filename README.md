# Windows Security Investigation Lab

Hands-on lab for investigating suspicious Windows activity using Windows Security Event Logs and PowerShell.

## Scenario

A Windows system shows a suspicious sequence of account activity:

1. Multiple failed logon attempts to an administrative account
2. A successful logon to the same account
3. Creation of a new local user account
4. Addition of the new account to the local Administrators group

The goal of the investigation is to determine what happened, correlate the relevant Windows security events, and identify indicators that could suggest unauthorized access or persistence.

## Objectives

This lab demonstrates practical skills in:

* Windows Security Event Log analysis
* Security incident investigation
* Event correlation and timeline reconstruction
* Administrative account activity analysis
* PowerShell-based log analysis
* Distinguishing suspicious activity from legitimate administrative actions

## Events of Interest

The investigation will focus on Windows Security events such as:

* 4624 — Successful logon
* 4625 — Failed logon
* 4672 — Special privileges assigned to a new logon
* 4720 — User account created
* 4732 — Member added to a local security group
* 4733 — Member removed from a local security group
* 4726 — User account deleted
* 1102 — Security audit log cleared

Additional events may be included if they are useful during the investigation.

## Planned Investigation

The lab will include:

* PowerShell queries for relevant Security events
* Event filtering and normalization
* Timeline reconstruction
* Correlation by account, logon session, and timestamp
* Investigation notes and conclusions
* Sanitized example output

## Repository Structure

windows-security-investigation-lab/
├── README.md
├── scripts/
├── sample-output/
└── investigation/

## Status

🚧 Work in progress
