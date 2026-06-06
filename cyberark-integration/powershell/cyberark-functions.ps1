function Add-CyberArkAccount {

    param (
        [string]$domain = (Get-WmiObject Win32_ComputerSystem).Domain,
        [string]$username = "localadmin",
        [string]$hostname = $ENV:COMPUTERNAME
    )

    Write-Log "Adding local admin account/password into CyberArk vault"
    Write-Log "username: $username | hostname: $hostname | domain: $domain"

    $BaseURI     = "cyberark.yourcompany.com"
    $AppID       = "YourAppID"
    $AIMSafe     = "YourAIMSafeName"
    $AIMUsername = "YourServiceAccount"

    $AIMAuthenticationURI = "https://$BaseURI/AIMWebService/api/Accounts?AppID=$AppID&Safe=$AIMSafe&Username=$AIMUsername"

    Try {
        $AIMToken = Invoke-RestMethod -Method GET -Uri $AIMAuthenticationURI -ErrorAction Stop
        Write-Log "Successfully retrieved AIM credential"
    }
    Catch { Write-Log "ERROR: Unable to retrieve AIM Credential" }

    $RESTAuthenticationURI = "https://$BaseURI/PasswordVault/WebServices/auth/Cyberark/CyberArkAuthenticationService.svc/Logon"
    $AuthenticationBody = '{"username":"' + $AIMUsername + '","password":"' + $AIMToken.Content + '"}'

    Try {
        $RESTToken = Invoke-RestMethod -Method POST -Uri $RESTAuthenticationURI -Body $AuthenticationBody -ContentType "application/json" -ErrorAction Stop
        Write-Log "Successfully logged in to CyberArk"
    }
    Catch { Write-Log "ERROR: Unable to log in to CyberArk" }

    $AuthenticationHeader = @{ "Authorization" = ($RESTToken.CyberArkLogonResult -join " ") }

    switch ($domain) {
        "example.local"    { $acr = 'EXAMPLE' }
        "corp.example.com" { $acr = 'CORP' }
        "dev.example.com"  { $acr = 'DEV' }
        "lab.internal"     { $acr = 'LAB' }
        Default            { $acr = 'UNKNOWN' }
    }

    $safeName       = "ORG-P-SERV-WIN-$acr"
    $platformID     = "Windows-Local-$acr-OTU"
    $accountAddress = "$hostname.$domain"
    $accountName    = "Operating System-$platformID-$accountAddress-$username"

    $NewAccountBody = '{
        "account" : {
            "safe":"' + $safeName + '",
            "platformID":"' + $platformID + '",
            "address":"' + $accountAddress + '",
            "password":"DefaultPasswordHere",
            "accountName":"' + $accountName + '",
            "username":"' + $username + '",
            "properties": [{"Key":"ResetImmediately","Value":"ChangeTask"}]
        }
    }'

    $NewAccountCreationURI = "https://$BaseURI/PasswordVault/WebServices/PIMServices.svc/Account"

    Try {
        $NewAccountResults = Invoke-RestMethod -Method POST -Headers $AuthenticationHeader -Uri $NewAccountCreationURI -Body $NewAccountBody -ContentType "application/json" -ErrorAction Stop
        Write-Log "Successfully added account to CyberArk"
    }
    Catch { Write-Log "ERROR: Unable to add account to CyberArk" }

    $QueryAccountURI = "https://$BaseURI/PasswordVault/WebServices/PIMServices.svc/Accounts?Keywords=$accountAddress,$username&Safe=$safeName"

    Try {
        $AccountDetails = Invoke-RestMethod -Method GET -Headers $AuthenticationHeader -Uri $QueryAccountURI -ContentType "application/json" -ErrorAction Stop
    }
    Catch { Write-Log "ERROR: Unable to query account" }

    $AccountID = $AccountDetails.accounts.GetValue(0) | Select -Expand AccountID
    if ($AccountID) { Write-Log "Account ID found" } else { Write-Log "Account not found" }

    $ReleaseTokenURI = "https://$BaseURI/PasswordVault/WebServices/auth/Cyberark/CyberArkAuthenticationService.svc/Logoff"
    Invoke-RestMethod -Method POST -Headers $AuthenticationHeader -Uri $ReleaseTokenURI -ContentType "application/json"
}

function Get-CyberArkAccount {

    param (
        [Parameter(Mandatory = $true)]
        [string]$server,
        [string]$username = "localadmin"
    )

    Write-Log "Requesting CyberArk password for $username on $server"

    $BaseURI     = "cyberark.yourcompany.com"
    $AppID       = "YourAppID"
    $AIMSafe     = "YourAIMSafeName"
    $AIMUsername = "YourServiceAccount"

    $AIMAuthenticationURI = "https://$BaseURI/AIMWebService/api/Accounts?AppID=$AppID&Safe=$AIMSafe&Username=$AIMUsername"

    Try {
        $AIMToken = Invoke-RestMethod -Method GET -Uri $AIMAuthenticationURI -ErrorAction Stop
        Write-Log "Successfully retrieved AIM credential"
    }
    Catch { Write-Log "ERROR: Unable to retrieve AIM token" }

    $RESTAuthenticationURI = "https://$BaseURI/PasswordVault/WebServices/auth/Cyberark/CyberArkAuthenticationService.svc/Logon"
    $AuthenticationBody = '{"username":"' + $AIMUsername + '","password":"' + $AIMToken.Content + '"}'

    Try {
        $RESTToken = Invoke-RestMethod -Method POST -Uri $RESTAuthenticationURI -Body $AuthenticationBody -ContentType "application/json" -ErrorAction Stop
        Write-Log "Successfully logged in to CyberArk"
    }
    Catch { Write-Log "ERROR: Unable to log in to CyberArk" }

    $AuthenticationHeader = @{ "Authorization" = ($RESTToken.CyberArkLogonResult -join " ") }

    $QueryAccountURI = "https://$BaseURI/PasswordVault/WebServices/PIMServices.svc/Accounts?Keywords=$server,$username"

    Try {
        $AccountDetails = Invoke-RestMethod -Method GET -Headers $AuthenticationHeader -Uri $QueryAccountURI -ContentType "application/json" -ErrorAction Stop
    }
    Catch { Write-Log "ERROR: Unable to query account" }

    $AccountID         = $AccountDetails.accounts.GetValue(0) | Select -Expand AccountID
    $AccountProperties = $AccountDetails.accounts.GetValue(0) | Select -ExpandProperty Properties

    if ($AccountID) { Write-Log "Account ID found" } else { Write-Log "Account not found" }

    $hostname, $domain = $server.Split('.')
    $domain = $domain -join '.'

    switch ($domain) {
        "example.local"    { $acr = 'EXAMPLE' }
        "corp.example.com" { $acr = 'CORP' }
        "dev.example.com"  { $acr = 'DEV' }
        "lab.internal"     { $acr = 'LAB' }
        Default            { $acr = 'UNKNOWN' }
    }

    $platformID = "Windows-Local-$acr-NR"

    foreach ($property in $AccountProperties) {
        switch ($property.Key) {
            "Safe"       { $AccountSafe       = $property.Value }
            "Folder"     { $AccountFolder     = $property.Value }
            "Name"       { $AccountName       = $property.Value }
            "UserName"   { $AccountUserName   = $property.Value }
            "DeviceType" { $AccountDeviceType = $property.Value }
            "Address"    { $AccountAddress    = $property.Value }
        }
    }

    $GetPWDURI = "https://$BaseURI/PasswordVault/WebServices/PIMServices.svc/Accounts/$AccountID/Credentials"

    Try {
        $AccountPassword = Invoke-RestMethod -Method GET -Headers $AuthenticationHeader -Uri $GetPWDURI -ContentType "application/json" -ErrorAction Stop
        if ($AccountPassword) {
            $credPassword = $AccountPassword | ConvertTo-SecureString -AsPlainText -Force
            $global:CAcreds = New-Object System.Management.Automation.PSCredential("$hostname\$username", $credPassword)
            Write-Log "Retrieved password"
        }
    }
    Catch { Write-Log "ERROR: Unable to retrieve password" }

    $ReleaseTokenURI = "https://$BaseURI/PasswordVault/WebServices/auth/Cyberark/CyberArkAuthenticationService.svc/Logoff"
    Invoke-RestMethod -Method POST -Headers $AuthenticationHeader -Uri $ReleaseTokenURI -ContentType "application/json"
}
