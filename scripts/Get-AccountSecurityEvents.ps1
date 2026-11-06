param (
    [datetime]$StartTime = (Get-Date).AddDays(-1),
    [datetime]$EndTime   = (Get-Date),
    [switch]$ExcludeSystem
)

$EventIds = 4624, 4625, 4672, 4720, 4726, 4732, 4733

$Events = Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = $EventIds
    StartTime = $StartTime
    EndTime   = $EndTime
} -ErrorAction SilentlyContinue

$Results = foreach ($Event in $Events) {

    $Xml = [xml]$Event.ToXml()
    $Data = @{}

    foreach ($Item in $Xml.Event.EventData.Data) {
        $Data[$Item.Name] = $Item.'#text'
    }

    switch ($Event.Id) {

        4624 {
            [PSCustomObject]@{
                TimeCreated = $Event.TimeCreated
                EventId     = $Event.Id
                EventType   = 'Successful logon'
                Account     = $Data['TargetUserName']
                Domain      = $Data['TargetDomainName']
                LogonId     = $Data['TargetLogonId']
                LogonType   = $Data['LogonType']
                Target      = ''
                Group       = ''
                MemberSid   = ''
                IpAddress   = $Data['IpAddress']
            }
        }

        4625 {
            [PSCustomObject]@{
                TimeCreated = $Event.TimeCreated
                EventId     = $Event.Id
                EventType   = 'Failed logon'
                Account     = $Data['TargetUserName']
                Domain      = $Data['TargetDomainName']
                LogonId     = $Data['TargetLogonId']
                LogonType   = $Data['LogonType']
                Target      = ''
                Group       = ''
                MemberSid   = ''
                IpAddress   = $Data['IpAddress']
            }
        }

        4672 {
            [PSCustomObject]@{
                TimeCreated = $Event.TimeCreated
                EventId     = $Event.Id
                EventType   = 'Special privileges assigned'
                Account     = $Data['SubjectUserName']
                Domain      = $Data['SubjectDomainName']
                LogonId     = $Data['SubjectLogonId']
                LogonType   = ''
                Target      = ''
                Group       = ''
                MemberSid   = ''
                IpAddress   = ''
            }
        }

        4720 {
            [PSCustomObject]@{
                TimeCreated = $Event.TimeCreated
                EventId     = $Event.Id
                EventType   = 'User account created'
                Account     = $Data['SubjectUserName']
                Domain      = $Data['SubjectDomainName']
                LogonId     = $Data['SubjectLogonId']
                LogonType   = ''
                Target      = $Data['TargetUserName']
                Group       = ''
                MemberSid   = ''
                IpAddress   = ''
            }
        }

        4726 {
            [PSCustomObject]@{
                TimeCreated = $Event.TimeCreated
                EventId     = $Event.Id
                EventType   = 'User account deleted'
                Account     = $Data['SubjectUserName']
                Domain      = $Data['SubjectDomainName']
                LogonId     = $Data['SubjectLogonId']
                LogonType   = ''
                Target      = $Data['TargetUserName']
                Group       = ''
                MemberSid   = ''
                IpAddress   = ''
            }
        }

        4732 {
            [PSCustomObject]@{
                TimeCreated = $Event.TimeCreated
                EventId     = $Event.Id
                EventType   = 'Member added to local group'
                Account     = $Data['SubjectUserName']
                Domain      = $Data['SubjectDomainName']
                LogonId     = $Data['SubjectLogonId']
                LogonType   = ''
                Target      = $Data['MemberName']
                Group       = $Data['TargetUserName']
                MemberSid   = $Data['MemberSid']
                IpAddress   = ''
            }
        }

        4733 {
            [PSCustomObject]@{
                TimeCreated = $Event.TimeCreated
                EventId     = $Event.Id
                EventType   = 'Member removed from local group'
                Account     = $Data['SubjectUserName']
                Domain      = $Data['SubjectDomainName']
                LogonId     = $Data['SubjectLogonId']
                LogonType   = ''
                Target      = $Data['MemberName']
                Group       = $Data['TargetUserName']
                MemberSid   = $Data['MemberSid']
                IpAddress   = ''
            }
        }
    }
}

if ($ExcludeSystem) {
    $Results = $Results | Where-Object {
        $_.Account -ne 'SYSTEM'
    }
}

$Results |
    Sort-Object TimeCreated |
    Format-Table -AutoSize
