$numberOfParallels = 10
$numberOfExecutions = 30

$desiredUrl = 'http://api.yoursite.com/data/ws/xxx/login'

$paramPassado = @{
usuar="lee@yoursite.com"
pswd="qwerty"
access="web"
} | ConvertTo-Json


For ($iParalelos = 0; $iParalelos -le $numberOfParallels; $iParalelos++){

    Start-Job -Name $iParalelos.ToString() -ScriptBlock{

        param(
            [int]$iIterations,
            $urlURL,
            $oParams
        )
        For($count=0; $count -le $iIterations; $count++){
            Invoke-WebRequest -Uri $urlURL -Body $oParam -Method Post -TimeoutSec 10
        }

    } -ArgumentList $numberOfExecutions, $desiredUrl, $paramPassado 

}

$running = $true
while ($running -eq $true){
    Clear-Host
    Write-Output "Looking for Jobs in execution..."

    $results = Get-Job | Where-Object {$_.State -eq "Running"}

    if($results -eq $null){
        Write-Output "Removing Jobs..."
        Start-Sleep -Seconds 3
        $running = $false
        Get-Job | Remove-Job
        Clear-Host
    } else{
        $results
        Start-Sleep -Seconds 2
    }
}
