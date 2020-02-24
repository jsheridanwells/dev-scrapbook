# Building Artifacts in Azure DevOps

The following config builds, tests, publishes and drops a linux artifact in dotnetcore 3.1. The artifact name contains the build number for versioning. ([This blog was helpful](https://www.hanselman.com/blog/SettingUpAzureDevOpsCICDForANETCore31WebAppHostedInAzureAppServiceForLinux.aspx))
```yaml
trigger:
- master

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildConfiguration: 'Release'

steps:
- task: DotNetCoreCLI@2
  displayName: 'dotnet test'
  inputs:
    command: 'test'
- task: UseDotNet@2
  displayName: 'dotnet build'
  inputs:
    version: '3.1.x'
    packageType: sdk
- script: dotnet build --configuration $(buildConfiguration)
  displayName: 'dotnet build $(buildConfiguration)'

- task: DotNetCoreCLI@2
  displayName: 'dotnet publish'
  inputs:
    command: 'publish'
    publishWebProjects: true
    arguments: '-r linux-x64 --configuration $(BuildConfiguration) --output $(Build.ArtifactStagingDirectory)'
    zipAfterPublish: true

- task: PublishBuildArtifacts@1
  displayName: "Upload Artifacts"
  inputs:
    pathtoPublish: '$(Build.ArtifactStagingDirectory)' 
    artifactName: 'MY_ARTIFACT_NAME_$(Build.BuildNumber)'
```
