param(
    [string]$TomcatHome,
    [string]$MysqlHome,
    [switch]$Stop
)

$ErrorActionPreference = 'Stop'
$state = Join-Path $PSScriptRoot '.demo'
$mysqlData = Join-Path $state 'mysql'
$tomcatBase = Join-Path $state 'tomcat'
$webUrl = 'http://127.0.0.1:18087/CineMan7/'
$mysqlPort = 33367

function Get-DemoProcess($Port, $Marker) {
    $listeners = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    foreach ($listener in $listeners) {
        $processId = $listener.OwningProcess
        $process = Get-CimInstance Win32_Process -Filter "ProcessId = $processId"
        if ($process -and $process.CommandLine -and $process.CommandLine.Contains($Marker)) {
            return Get-Process -Id $processId -ErrorAction SilentlyContinue
        }
    }
}

$mysqlProcess = Get-DemoProcess $mysqlPort $mysqlData
$tomcatProcess = Get-DemoProcess 18087 $tomcatBase
if ($Stop) {
    if ($tomcatProcess) { Stop-Process -Id $tomcatProcess.Id }
    if ($mysqlProcess) {
        $mysqlBin = Get-Content -LiteralPath (Join-Path $state 'mysql-bin.txt') -Raw
        & (Join-Path $mysqlBin.Trim() 'mysqladmin.exe') --protocol=TCP --host=127.0.0.1 --port=$mysqlPort --user=root shutdown
        if ($LASTEXITCODE -ne 0) { throw 'Khong dung duoc MySQL demo.' }
    }
    return
}

if (!$TomcatHome) {
    $TomcatHome = @($env:CATALINA_HOME, 'D:/pttk/tools/apache-tomcat-10.1.55') |
        Where-Object { $_ -and (Test-Path -LiteralPath (Join-Path $_ 'bin/bootstrap.jar')) } |
        Select-Object -First 1
}
if (!$MysqlHome) {
    $MysqlHome = @($env:MYSQL_HOME, 'C:/MySQL/MySQL Server 9.4', 'C:/Program Files/MySQL/MySQL Server 9.4',
        'C:/Program Files/MySQL/MySQL Server 8.4', 'C:/Program Files/MySQL/MySQL Server 8.0') |
        Where-Object { $_ -and (Test-Path -LiteralPath (Join-Path $_ 'bin/mysqld.exe')) } |
        Select-Object -First 1
}
if (!$TomcatHome -or !$MysqlHome) {
    throw 'Can chi dinh -TomcatHome va -MysqlHome (thu muc cai dat Tomcat va MySQL).'
}
$TomcatHome = (Resolve-Path -LiteralPath $TomcatHome).Path
$MysqlHome = (Resolve-Path -LiteralPath $MysqlHome).Path
$mysqlBin = Join-Path $MysqlHome 'bin'
$mysqld = Join-Path $mysqlBin 'mysqld.exe'
$mysql = Join-Path $mysqlBin 'mysql.exe'
$mysqladmin = Join-Path $mysqlBin 'mysqladmin.exe'
$mysqlArgs = @('--protocol=TCP', '--host=127.0.0.1', "--port=$mysqlPort", '--user=root')
New-Item -ItemType Directory -Path $state -Force | Out-Null

if (!$mysqlProcess) {
    $occupied = Get-NetTCPConnection -LocalPort $mysqlPort -State Listen -ErrorAction SilentlyContinue
    if ($occupied) { throw "Cong MySQL demo $mysqlPort dang duoc su dung." }
    if (!(Test-Path -LiteralPath (Join-Path $mysqlData 'mysql'))) {
        $result = Start-Process -FilePath $mysqld -ArgumentList @(
            '--no-defaults', '--initialize-insecure', "--basedir=""$MysqlHome""", "--datadir=""$mysqlData"""
        ) -WindowStyle Hidden -Wait -PassThru -RedirectStandardError (Join-Path $state 'mysql-init.log')
        if ($result.ExitCode -ne 0) { throw "Khoi tao MySQL that bai. Xem $state/mysql-init.log" }
    }
    $mysqlProcess = Start-Process -FilePath $mysqld -ArgumentList @(
        '--no-defaults', "--basedir=""$MysqlHome""", "--datadir=""$mysqlData""", "--port=$mysqlPort",
        '--bind-address=127.0.0.1', '--mysqlx=OFF', '--console'
    ) -WindowStyle Hidden -PassThru -RedirectStandardError (Join-Path $state 'mysql.err') `
        -RedirectStandardOutput (Join-Path $state 'mysql.out')
    $mysqlProcess.Id | Set-Content -LiteralPath (Join-Path $state 'mysql.pid')
}
$mysqlBin | Set-Content -LiteralPath (Join-Path $state 'mysql-bin.txt')

$mysqlReady = $false
for ($attempt = 0; $attempt -lt 60; $attempt++) {
    & $mysqladmin @mysqlArgs ping --silent 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $mysqlReady = $true; break }
    if ($mysqlProcess.HasExited) { break }
    Start-Sleep -Milliseconds 500
}
if (!$mysqlReady) { throw "MySQL khong khoi dong. Xem $state/mysql.err" }

$seeded = Join-Path $state 'seed.loaded'
if (!(Test-Path -LiteralPath $seeded)) {
    $seed = Join-Path $PSScriptRoot 'database/seed_cineman7.sql'
    $result = Start-Process -FilePath $mysql -ArgumentList ($mysqlArgs + '--default-character-set=utf8mb4') `
        -RedirectStandardInput $seed -WindowStyle Hidden -Wait -PassThru -RedirectStandardError (Join-Path $state 'seed.err')
    if ($result.ExitCode -ne 0) { throw "Nap du lieu mau that bai. Xem $state/seed.err" }
    $grants = "CREATE USER IF NOT EXISTS 'cineman7'@'localhost' IDENTIFIED BY 'cineman7-local-demo'; GRANT SELECT ON cineman7.* TO 'cineman7'@'localhost'; GRANT INSERT ON cineman7.tblUser7 TO 'cineman7'@'localhost'; GRANT INSERT ON cineman7.tblCustomer7 TO 'cineman7'@'localhost';"
    & $mysql @mysqlArgs --execute=$grants
    if ($LASTEXITCODE -ne 0) { throw 'Khong tao duoc tai khoan MySQL demo.' }
    New-Item -ItemType File -Path $seeded | Out-Null
}

if (!$tomcatProcess) {
    $occupied = Get-NetTCPConnection -LocalPort 18087 -State Listen -ErrorAction SilentlyContinue
    if ($occupied) { throw 'Cong Tomcat demo 18087 dang duoc su dung.' }
    $war = Join-Path $PSScriptRoot 'target/CineMan7.war'
    if (!(Test-Path -LiteralPath $war)) { & (Join-Path $PSScriptRoot 'Build-Demo.ps1') }
    foreach ($directory in 'webapps', 'logs', 'temp', 'conf') {
        New-Item -ItemType Directory -Path (Join-Path $tomcatBase $directory) -Force | Out-Null
    }
    Copy-Item -Path (Join-Path $TomcatHome 'conf/*') -Destination (Join-Path $tomcatBase 'conf') -Force -Recurse
    $serverConfig = Join-Path $tomcatBase 'conf/server.xml'
    [xml]$configuration = Get-Content -LiteralPath $serverConfig -Raw
    $configuration.Server.port = '-1'
    $connector = $configuration.SelectSingleNode('/Server/Service/Connector')
    $connector.SetAttribute('port', '18087')
    $connector.SetAttribute('address', '127.0.0.1')
    $configuration.Save($serverConfig)
    Copy-Item -LiteralPath $war -Destination (Join-Path $tomcatBase 'webapps') -Force

    $classpath = (Join-Path $TomcatHome 'bin/bootstrap.jar') + ';' + (Join-Path $TomcatHome 'bin/tomcat-juli.jar')
    $javaArgs = @(
        "-Dcatalina.home=""$TomcatHome""", "-Dcatalina.base=""$tomcatBase""",
        "-Djava.io.tmpdir=""$tomcatBase/temp""",
        "-Djava.util.logging.config.file=""$tomcatBase/conf/logging.properties""",
        '-Duser.timezone=Asia/Ho_Chi_Minh', '-cp', """$classpath""",
        'org.apache.catalina.startup.Bootstrap', 'start'
    )
    $tomcatProcess = Start-Process -FilePath (Get-Command java).Source -ArgumentList $javaArgs `
        -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $state 'tomcat.out') `
        -RedirectStandardError (Join-Path $state 'tomcat.err')
    $tomcatProcess.Id | Set-Content -LiteralPath (Join-Path $state 'tomcat.pid')
}

for ($attempt = 0; $attempt -lt 45; $attempt++) {
    try {
        $response = Invoke-WebRequest -Uri $webUrl -UseBasicParsing -TimeoutSec 3
        if ($response.StatusCode -eq 200) {
            Write-Host "CineMan7: $webUrl"
            return
        }
    } catch {
        if ($tomcatProcess.HasExited) { break }
    }
    Start-Sleep -Milliseconds 500
}
throw "Tomcat khong phuc vu CineMan7. Xem $state/tomcat.err"
