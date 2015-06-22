﻿Import-Module (Join-Path $PSScriptRoot "Credentials.psm1") -DisableNameChecking

$apiVersion = '2015-02-28'
$contentType = 'application/json'

function Append-ServiceVersion
{
    param ($uri)
    return $uri + "?api-version=$apiVersion"
}

function Get-DefaultHeaders
{
    return @{ 'api-key' = $Global:serviceKey }
}

function Get
{
    param ($uri)
        
    $finalUri = Append-ServiceVersion($uri)
    $headers = Get-DefaultHeaders

    $result = Invoke-RestMethod -Uri $finalUri -Method Get -Headers $headers

    return $result
}

function Get-Safe
{
    param ($uri)

    $OldEAP = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'

    $finalUri = Append-ServiceVersion($uri)
    $headers = Get-DefaultHeaders

    $result = Invoke-RestMethod -Uri $finalUri -Method Get -Headers $headers -ErrorVariable RestError

    $ErrorActionPreference = $OldEAP

    return $result
}

function Post
{
    param ($uri, $body)
        
    $finalUri = Append-ServiceVersion($uri)
    $headers = Get-DefaultHeaders

    $result = $null
    if ($body -ne $null)
    {
        $json = ConvertTo-Json $body -Depth 100
        $result = Invoke-RestMethod -Uri $finalUri -Method Post -Headers $headers -Body $json -ContentType $contentType
    }
    else
    {
        $result = Invoke-RestMethod -Uri $finalUri -Method Post -Headers $headers
    }

    return $result
}

function Put
{
    param ($uri, $body)
        
    $finalUri = Append-ServiceVersion($uri)
    $headers = Get-DefaultHeaders

    $json = ConvertTo-Json $body -Depth 100
    $result = Invoke-RestMethod -Uri $finalUri -Method Put -Headers $headers -Body $json -ContentType $contentType

    return $result
}

function Delete
{
    param ($uri)
        
    $finalUri = Append-ServiceVersion($uri)
    $headers = Get-DefaultHeaders

    $result = Invoke-RestMethod -Uri $finalUri -Method Delete -Headers $headers

    return $result
}

Export-ModuleMember -Function Get
Export-ModuleMember -Function Get-Safe
Export-ModuleMember -Function Post
Export-ModuleMember -Function Put
Export-ModuleMember -Function Delete