# Settings up an Azure DevOps Pipeline (build)

The following AspNetCore config will:
1. Build the artifacts
1. Run the tests
1. Publish (for linux)
1. Upload the artifacts to a staging directory

```yaml
trigger:
- Development

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildConfiguration: 'Release'

steps:
- script: dotnet build --configuration $(buildConfiguration)
  displayName: 'dotnet build $(buildConfiguration)'

- task: DotNetCoreCLI@2
  displayName: 'dotnet test'
  inputs:
    command: 'test'

- task: DotNetCoreCLI@2
  displayName: 'dotnet publish'
  inputs:
    command: 'publish'
    publishWebProjects: true
    arguments: '-r linux-x64 --configuration $(BuildConfiguration) --output $(Build.ArtifactStagingDirectory)'
    zipAfterPublish: true

- task: PublishPipelineArtifact@1
  displayName: 'Upload Artifacts'
  inputs:
    targetPath: '$(Build.ArtifactStagingDirectory)'
    artifactName: 'MY_ARTIFACT'
```