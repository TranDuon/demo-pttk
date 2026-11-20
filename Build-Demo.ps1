$ErrorActionPreference = 'Stop'
$target = Join-Path $PSScriptRoot 'target'
$classes = Join-Path $target 'classes'
New-Item -ItemType Directory -Path $classes -Force | Out-Null
$sources = @(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'src/main/java') -Filter '*.java' -File -Recurse)
& javac -encoding UTF-8 --release 17 -d $classes $sources.FullName
if ($LASTEXITCODE -ne 0) { throw 'Bien dich Java that bai.' }

$webapp = Join-Path $PSScriptRoot 'src/main/webapp'
$war = Join-Path $target 'CineMan7.war'
& jar --create --file $war -C $webapp .
if ($LASTEXITCODE -ne 0) { throw 'Khong tao duoc WAR.' }
$stage = Join-Path $target 'war-classes/WEB-INF'
New-Item -ItemType Directory -Path $stage -Force | Out-Null
Copy-Item -LiteralPath $classes -Destination $stage -Recurse -Force
& jar --update --file $war -C (Split-Path -Parent $stage) WEB-INF/classes
if ($LASTEXITCODE -ne 0) { throw 'Khong them duoc cac lop vao WAR.' }
Write-Host $war
