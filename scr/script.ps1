Import-Module WebAdministration

$response = Invoke-WebRequest -UseBasicParsing http://localhost:5000 -MaximumRedirection 1
$statusCode = [int]$response.StatusCode

If ($statusCode -eq 200) {
    Write-Output "200 OK"
} Else {
    throw "Failed"
}
Write-Output "Done"

Stop-WebSite 'localhost'