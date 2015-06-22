﻿Import-Module (Join-Path $PSScriptRoot "Utils.psm1") -DisableNameChecking

function Get-Uri
{
    param ($baseUri, $entityName)
    return "$baseUri/$entityName"
}

function Get-Entity
{
    param ($baseUri, $entityName)

    $uri = Get-Uri $baseUri $entityName
    return Get-Safe $uri
}

function Create-Entity
{
    param ($baseUri, $entityDefinition)

    $entityName = $entityDefinition.name
    Write-Host "Creating entity $entityName..."

    return Post $baseUri $entityDefinition
}

function Update-Entity
{
    param ($baseUri, $entityName, $entityDefinition)

    if ($entityName -eq $null)
    {
        $entityName = $entityDefinition.name
    }
    Write-Host "Updating entity $entityName..."

    $uri = Get-Uri $baseUri $entityName
    return Put $uri $entityDefinition
}

function Delete-Entity
{
    param ($baseUri, $entityName)

    Write-Host "Deleting entity $entityName..."

    $uri = Get-Uri $baseUri $entityName
    return Delete $uri
}

function List-Entities
{
    param ($baseUri)

    return Get $baseUri
}

Export-ModuleMember -Function Get-Entity
Export-ModuleMember -Function Create-Entity
Export-ModuleMember -Function Update-Entity
Export-ModuleMember -Function Delete-Entity
Export-ModuleMember -Function List-Entities