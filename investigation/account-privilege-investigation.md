# Local Account Privilege Investigation

## Scenario

This investigation was performed in a controlled Windows lab environment.

A temporary local account was intentionally created and added to the local Administrators group in order to observe how account creation and privilege changes appear in Windows Security Event Logs.

The account was removed after the investigation.

## Investigation Goal

The goal was to identify and correlate Windows Security events associated with:

- creation of a local user account;
- addition of the account to the local Administrators group;
- removal of the account from the group;
- deletion of the account;
- the administrative logon session responsible for the changes.

## Relevant Events

| Event ID | Description |
|---|---|
| 4624 | Successful logon |
| 4672 | Special privileges assigned to a new logon |
| 4720 | User account created |
| 4732 | Member added to a security-enabled local group |
| 4733 | Member removed from a security-enabled local group |
| 4726 | User account deleted |

## Timeline

| Time | Event | Observation |
|---|---|---|
| 2026-11-05 15:19:06 | 4624 | Successful cached interactive logon |
| 2026-11-05 15:19:06 | 4672 | Special privileges assigned to the same logon session |
| 2026-11-06 11:42:43 | 4720 | Temporary local user `security_lab_user` created |
| 2026-11-06 11:44:01 | 4732 | `security_lab_user` added to the local Administrators group |
| 2026-11-06 14:32:36 | 4733 | `security_lab_user` removed from the Administrators group |
| 2026-11-06 14:32:47 | 4726 | `security_lab_user` deleted |

## Event Correlation

The account-management events shared the same `SubjectLogonId`:

`0x259ede`

The same Logon ID was observed in the earlier successful logon (`4624`) and privileged-logon (`4672`) events.

This allowed the individual account-management events to be correlated with the administrative session that performed the actions.

Rather than looking at Event IDs independently, the investigation used the Logon ID to reconstruct activity belonging to the same session.

## Key Findings

The event sequence shows a complete account lifecycle:

1. A privileged Windows session was established.
2. A new local account was created.
3. The account was added to the local Administrators group.
4. The account was later removed from the group.
5. The account was deleted.

In a real investigation, unexpected `4720` and `4732` events would require validation because creation of a new local administrator account can be associated with unauthorized privilege assignment or persistence.

However, in this lab the activity was intentionally generated and therefore represents expected administrative activity.

## Investigation Lessons

This exercise demonstrated that:

- a single Event ID is rarely sufficient to understand an incident;
- `SubjectLogonId` can be used to correlate administrative actions with the session responsible for them;
- account creation and privilege assignment should be investigated together;
- privileged events such as `4672` are contextual indicators and are not inherently malicious;
- analyst conclusions should distinguish observed facts from hypotheses;
- known administrative activity can produce event sequences that may initially appear suspicious.

## Data Handling

Usernames, computer names, email addresses, and other identifying values from the original Windows logs are not included in the repository.

Only sanitized information required to demonstrate the investigation process is retained.
