Function CustomStart {
    param(
        [string]$FileType,
        [int]$FilePosition
    )

    $sciezkaObecna = Get-Location

    $plik = Get-ChildItem -Path $sciezkaObecna -Filter $FileType | Select-Object -First $FilePosition

            
    if ($null -ne $plik) {
        Write-Host("Opening", $plik.FullName)
        Start-Process -FilePath $plik.FullName
    }
    else {
        Write-Host "File not found at position $FilePosition with extension $FileType in the current location."
    }
}

function CheckSimilarCharacters {
    param (
        [string]$String1,
        [string]$String2
    )


    for ($i = 0; $i -lt ($String1.Length - 2); $i++) {
        $Substr1 = $String1.Substring($i, 3)

        for ($j = 0; $j -lt ($String2.Length - 2); $j++) {
            $Substr2 = $String2.Substring($j, 3)

            if ($Substr1 -eq $Substr2) {
                Write-Host "Both strings have similar 3 characters: '$Substr1' at positions $i and $j"
                return $true
            }
        }
    }

    Write-Host "No similar 3 characters found in both strings."
    return $false
}

<#
.SYNOPSIS
This opens file you type selected

.DESCRIPTION
This function takes a file type as an input and open selected files (default first in every directory)

.PARAMETER FileType
The type of selected file
0                   -   Open .uproject & .sln
1, UnrealEngine     -   Open .uproject
2, VisualStudio     -   Open .sln
<custom>            -   Open .<custom>

For Name checking 3 chars similarity


.PARAMETER FilePosition
The position of file type you selected you wanna open

.EXAMPLE
Open 1
Outputs: Opening .uproject

.NOTES
Author: Andrzej Manderla
Date: 2023-08-19
#>
Function Open {
    param(
        [string]$FileType = 0,
        [int]$FilePosition = 1
    )
    $IsUnreal = CheckSimilarCharacters -String1 $FileType.ToLower() -String2 "UnrealEngine".ToLower()
    $IsVisual = CheckSimilarCharacters -String1 $FileType.ToLower() -String2 "VisualStudio".ToLower()
    if($IsUnreal -and $IsVisual){
        $FileType = 0
    }
    elseif($IsUnreal){
        $FileType = 1
    }
    elseif($IsVisual){
        $FileType = 2
    }
    

    if ($FileType -eq 1) {
        Write-Host "Opening .uproject on position $FilePosition"
        CustomStart -FileType *.uproject -FilePosition $FilePosition
            
    }
    elseif ($FileType -eq 2) {
        Write-Host "Opening .sln on position $FilePosition"
        CustomStart -FileType *.sln -FilePosition $FilePosition
    }
    elseif ($FileType -eq 0) {
        Write-Host "Opening .uproject and .sln on position $FilePosition"
        CustomStart -FileType *.uproject -FilePosition $FilePosition
        CustomStart -FileType *.sln -FilePosition $FilePosition
    }
    else{
        Write-Host "Opening custom FileType on position $FilePosition"
        CustomStart -FileType *.$FileType -FilePosition $FilePosition
    }
}

Export-ModuleMember -Function Open