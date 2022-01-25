<#
uso:
.\cd7zip.ps1 
#>

Clear-Host
Write-Host "----7zip----" 

$rutaactual = (Get-Location).Path 
$ruta7zip = "C:\Program Files\7-Zip\7z.exe";
$r = 0
do {
    try 
    {
        $r = Read-Host "(1)Comprimir - (2)Extraer ";
        $r = [int]$r;
    }
    catch
    {
        Write-Output ""; 
    } 
} while ($r -lt 0 -or $r -gt 2) 

# verificar existe programa 7zip 
if (-not (Test-Path -Path $ruta7zip -PathType Leaf)) 
{
    throw "7 zip file '$ruta' not found"
}

if ($r -eq 0) 
{
    ;    
}
elseif ($r -eq 1) #Comprimir
{
    write-host "" 
     # lista de archivos 
    $nom = @(); 
    $con = 0;
    Get-ChildItem -Attributes hidden, archive, directory  |  foreach{ Write-Host (++$con) ")" $_.Name; $nom += $_.Name} 

    # opcion para comprimir 
    do {
        try 
        {
            Write-Host `n"Salir : 0";
            $r = Read-Host "Opcion: 1 -" $con; 
            $r = [int]$r;
        }
        catch 
        {
            write-output ""    
        }
    } while ($r -lt 0 -or $r -gt $con)

    if ($r -ne 0) 
    {
        $nombrearchivo = $rutaactual +  "\" + $nom[$r-1]; 
        $nombrearchivo7zip = $rutaactual + "\" + ".7z"; 
    
        Set-Alias 7zip $ruta7zip 
        7zip a -mx=9 $nombrearchivo7zip $nombrearchivo 
        Write-Host `n"SE HA COMPRIMIDO" -ForegroundColor Yellow  
    }
}
elseif ($r -eq 2) #Extraer 
{
    write-host ""
    #lista de archivos comprimidos 
    $nom = @(); 
    $con = 0;
    Get-ChildItem -Attributes hidden,archive,directory | foreach-Object {$auxn = $_.Extension; if($auxn -eq ".zip" -or $auxn -eq ".7z" -or $auxn -eq ".rar"){Write-Host (++$con) ")" $_.Name; $nom += $_.Name}} 

    do {
        try 
        {
            Write-Host `n"Salir : 0";
            $r = Read-Host "Opcion: 1 -" $con; 
            $r = [int]$r;
        }
        catch 
        {
            write-output ""    
        }
    } while ($r -lt 0 -or $r -gt $con)

    if($r -ne 0)
    {
        $nombrearchivo = $rutaactual + "\" + $nom[$r-1];
        
        Set-Alias 7zip $ruta7zip 
        7zip x -y $nombrearchivo 
        Write-Host `n"DESCOMPRIMIDO" -ForegroundColor Yellow 
    }
}

Write-Host ""
