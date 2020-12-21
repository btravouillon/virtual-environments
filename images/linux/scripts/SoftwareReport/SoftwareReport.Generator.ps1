param (
    [Parameter(Mandatory)][string]
    $OutputDirectory
)

$ErrorActionPreference = "Stop"

Import-Module MarkdownPS
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Android.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Browsers.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.CachedTools.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Common.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Databases.psm1") -DisableNameChecking
Import-Module "$PSScriptRoot/../helpers/SoftwareReport.Helpers.psm1" -DisableNameChecking
Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1" -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Java.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Rust.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Tools.psm1") -DisableNameChecking

# Restore file owner in user profile
Restore-UserOwner

$markdown = ""

$OSName = Get-OSName
$markdown += New-MDHeader "$OSName" -Level 1

$markdown += New-MDList -Style Unordered -Lines @(
    "Image Version: $env:IMAGE_VERSION"
)

$markdown += New-MDHeader "Installed Software" -Level 2
$markdown += New-MDHeader "Language and Runtime" -Level 3

$markdown += New-MDList -Style Unordered -Lines @(
        (Get-BashVersion),
        (Get-CPPVersions),
        (Get-FortranVersions),
        (Get-ClangVersions),
        (Get-ErlangVersion),
        (Get-MonoVersion),
        (Get-PerlVersion),
        (Get-PythonVersion),
        (Get-Python3Version),
        (Get-RubyVersion),
        (Get-JuliaVersion)
)

$markdown += New-MDHeader "Package Management" -Level 3

$packageManagementList = @(
        (Get-HomebrewVersion),
        (Get-GemVersion),
        (Get-MinicondaVersion),
        (Get-HelmVersion),
        (Get-NpmVersion),
        (Get-YarnVersion),
        (Get-PipVersion),
        (Get-Pip3Version),
        (Get-VcpkgVersion)
)

if (-not (Test-IsUbuntu16)) {
    $packageManagementList += @(
        (Get-PipxVersion)
    )
}

$markdown += New-MDList -Style Unordered -Lines ($packageManagementList | Sort-Object)

$markdown += New-MDHeader "Project Management" -Level 3
$markdown += New-MDList -Style Unordered -Lines @(
        (Get-AntVersion),
        (Get-GradleVersion),
        (Get-MavenVersion),
        (Get-SbtVersion)
)

$markdown += New-MDHeader "Tools" -Level 3
$toolsList = @(
    (Get-7zipVersion),
    (Get-AnsibleVersion),
    (Get-AptFastVersion),
    (Get-AzCopy7Version),
    (Get-AzCopy10Version),
    (Get-CMakeVersion),
    (Get-CurlVersion),
    (Get-DockerMobyVersion),
    (Get-DockerComposeVersion),
    (Get-DockerBuildxVersion),
    (Get-GitVersion),
    (Get-GitLFSVersion),
    (Get-GitFTPVersion),
    (Get-HavegedVersion),
    (Get-HerokuVersion),
    (Get-HHVMVersion),
    (Get-SVNVersion),
    (Get-JqVersion),
    (Get-KindVersion),
    (Get-KubectlVersion),
    (Get-KustomizeVersion),
    (Get-MediainfoVersion),
    (Get-M4Version),
    (Get-MinikubeVersion),
    (Get-PackerVersion),
    (Get-PassVersion),
    (Get-PhantomJSVersion),
    (Get-PulumiVersion),
    (Get-RVersion),
    (Get-SphinxVersion),
    (Get-SwigVersion),
    (Get-TerraformVersion),
    (Get-UnZipVersion),
    (Get-WgetVersion),
    (Get-YamllintVersion),
    (Get-ZipVersion),
    (Get-ZstdVersion)
)

if (-not (Test-IsUbuntu16)) {
    $toolsList += @(
        (Get-PodManVersion),
        (Get-BuildahVersion),
        (Get-SkopeoVersion)
    )
}

$markdown += New-MDList -Style Unordered -Lines ($toolsList | Sort-Object)

$markdown += New-MDHeader "CLI Tools" -Level 3
$markdown += New-MDList -Style Unordered -Lines @(
    (Get-AlibabaCloudCliVersion),
    (Get-AzureCliVersion),
    (Get-AzureDevopsVersion),
    (Get-GitHubCliVersion),
    (Get-HubCliVersion),
    (Get-OCCliVersion),
    (Get-VerselCliversion)
)

$markdown += New-MDHeader "Java" -Level 3
$markdown += Get-JavaVersions | New-MDTable
$markdown += New-MDNewLine

$markdown += New-MDHeader "Haskell" -Level 3
$markdown += New-MDList -Style Unordered -Lines @(
    (Get-GHCVersion),
    (Get-CabalVersion),
    (Get-StackVersion)
)

$markdown += New-MDHeader "Rust Tools" -Level 3
$markdown += New-MDList -Style Unordered -Lines @(
    (Get-RustVersion),
    (Get-RustupVersion),
    (Get-RustdocVersion),
    (Get-CargoVersion)
)

$markdown += New-MDHeader "Packages" -Level 4
$markdown += New-MDList -Style Unordered -Lines @(
    (Get-BindgenVersion),
    (Get-CargoAuditVersion),
    (Get-CargoOutdatedVersion),
    (Get-CargoClippyVersion),
    (Get-CbindgenVersion),
    (Get-RustfmtVersion)
)

$markdown += New-MDHeader "Databases" -Level 3
$markdown += New-MDList -Style Unordered -Lines @(
    (Get-MongoDbVersion),
    (Get-SqliteVersion)
)

$markdown += Build-MSSQLToolsSection

$markdown += New-MDHeader "PowerShell Tools" -Level 3
$markdown += New-MDList -Lines (Get-PowershellVersion) -Style Unordered

$markdown += New-MDHeader "PowerShell Modules" -Level 4
$markdown += Get-PowerShellModules | New-MDTable
$markdown += New-MDNewLine

$markdown += New-MDHeader "Cached Docker images" -Level 3
$markdown += Get-CachedDockerImagesTableData | New-MDTable
$markdown += New-MDNewLine

$markdown += New-MDHeader "Installed apt packages" -Level 3
$markdown += New-MDList -Style Unordered -Lines @(Get-AptPackages)

$markdown | Out-File -FilePath "${OutputDirectory}/Ubuntu-Readme.md"
