# Windows Security Investigation Lab

Hands-on Windows security investigation lab focused on Security Event Log analysis, PowerShell-based event parsing, and event correlation.

## Overview

This repository documents practical exercises for investigating Windows security activity.

The first completed investigation analyzes the lifecycle of a temporary local administrator account in a controlled lab environment:

1. A privileged Windows session is identified.
2. A temporary local user account is created.
3. The account is added to the local Administrators group.
4. The account is later removed from the group.
5. The temporary account is deleted.
6. The events are correlated using the Windows Logon ID.

The activity was intentionally generated in a lab environment and analyzed as if it were part of a security investigation.

## Skills Demonstrated

- Windows Security Event Log analysis
- Security incident investigation
- Event correlation and timeline reconstruction
- Administrative account activity analysis
- PowerShell-based log collection and parsing
- Security event normalization
- Distinguishing suspicious activity from legitimate administrative actions
- Sanitization of investigation output for documentation

## Windows Events Used

| Event ID | Description |
|---|---|
| 4624 | Successful logon |
| 4625 | Failed logon |
| 4672 | Special privileges assigned to a new logon |
| 4720 | User account created |
| 4726 | User account deleted |
| 4732 | Member added to a security-enabled local group |
| 4733 | Member removed from a security-enabled local group |

## Investigation

The completed investigation is documented here:

[`investigation/account-privilege-investigation.md`](investigation/account-privilege-investigation.md)

The investigation reconstructs the account lifecycle and correlates administrative actions with the logon session responsible for them.

## PowerShell Analysis

[`scripts/Get-AccountSecurityEvents.ps1`](scripts/Get-AccountSecurityEvents.ps1)

The PowerShell script:

- queries selected Windows Security Event IDs;
- parses structured event data from XML;
- normalizes different event types into a common output format;
- extracts accounts, domains, Logon IDs, logon types, groups, SIDs, and IP addresses where applicable;
- optionally filters routine `SYSTEM` activity.

Example usage:

```powershell
.\scripts\Get-AccountSecurityEvents.ps1 `
    -StartTime "2026-11-06 11:40" `
    -EndTime "2026-11-06 14:35" `
    -ExcludeSystem
```

## Sample Output

A sanitized example is available here:

[`sample-output/account-privilege-events.txt`](sample-output/account-privilege-events.txt)

Usernames, computer names, session identifiers, and other environment-specific values in the sample have been replaced with lab values.

## Key Investigation Lesson

Individual Windows Event IDs provide limited context on their own.

Correlating events using fields such as `SubjectLogonId` and `TargetLogonId` makes it possible to connect authentication activity, privilege assignment, and subsequent administrative actions into a single investigation timeline.

## Repository Structure

```text
windows-security-investigation-lab/
├── README.md
├── investigation/
│   └── account-privilege-investigation.md
├── scripts/
│   └── Get-AccountSecurityEvents.ps1
└── sample-output/
    └── account-privilege-events.txt
```

## Status

First investigation completed. Additional Windows security investigation exercises may be added over time.
