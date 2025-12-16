@{
    # Module metadata
    RootModule = 'PAI.psm1'
    ModuleVersion = '1.0.0'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author = 'Jean'
    CompanyName = 'Personal'
    Copyright = '(c) 2025. MIT License.'
    Description = 'Personal AI Infrastructure (PAI) PowerShell Module'
    
    # Minimum PowerShell version
    PowerShellVersion = '7.0'
    
    # Functions to export
    FunctionsToExport = @(
        'Get-PAIConfig',
        'Get-PAISkills',
        'Get-PAIAgent',
        'Test-PAIEnvironment'
    )
    
    # Cmdlets to export
    CmdletsToExport = @()
    
    # Variables to export
    VariablesToExport = @()
    
    # Aliases to export
    AliasesToExport = @()
    
    # Private data
    PrivateData = @{
        PSData = @{
            Tags = @('AI', 'Assistant', 'PAI', 'Skills')
            ProjectUri = 'https://github.com/yourusername/pai'
            LicenseUri = 'https://opensource.org/licenses/MIT'
        }
    }
}
