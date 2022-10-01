
# powershell 1.0

Microsoft Powershell Environment

---
- #### Categories: development, build
- #### Image: gcr.io/direktiv/functions/powershell 
- #### License: [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0)
- #### Issue Tracking: https://github.com/direktiv-apps/powershell/issues
- #### URL: https://github.com/direktiv-apps/powershell
- #### Maintainer: [direktiv.io](https://www.direktiv.io) 
---

## About powershell

This function has Powershell 7.2.6 installed plus the following plugins:
- powershell-yaml
- PSWriteHTML
- Az
- Posh-SSH

For executing remote commands remoting has to be enabled on the target host. The following is an example of those settings. The `TrustedHosts` set to * is just for testing and should be more specific in production scenarios.

`Enable-PSRemoting -Force`

`Set-Item WSMan:\localhost\Client\TrustedHosts -Force -Value *`

`Set-Service WinRM -StartMode Automatic`

`Restart-Service -Force WinRM`

Additionaly the firewall needs to be changed to allow traffic to the target host. In Direktiv it is recommended to set the attribute `size` to `large` because of a  bigger memory consumption of Powershell.

### Example(s)
  #### Function Configuration
```yaml
functions:
- id: powershell
  image: gcr.io/direktiv/functions/powershell:1.0
  type: knative-workflow
  size: large
```
   #### Run small script directly
```yaml
- id: powershell 
  type: action
  action:
    function: powershell
    files:
    - key: script.ps1
      scope: workflow
    input: 
      files:
      - name: script.ps1
        data: |
          Get-ChildItem . | Select Name | ConvertTo-Json 
      commands:
      - command: pwsh script.ps1
```
   #### Run file
```yaml
- id: powershell 
  type: action
  action:
    function: powershell
    files:
    - key: script.ps1
      scope: workflow
    input: 
      commands:
      - command: pwsh script.ps1
```

   ### Secrets


*No secrets required*







### Request



#### Request Attributes
[PostParamsBody](#post-params-body)

### Response
  List of executed Powershell commands.
#### Reponse Types
    
  

[PostOKBody](#post-o-k-body)
#### Example Reponses
    
```json
{
  "result": [
    {
      "Name": "file1.txt"
    },
    {
      "Name": "file2.txt"
    }
  ],
  "success": true
}
```

### Errors
| Type | Description
|------|---------|
| io.direktiv.command.error | Command execution failed |
| io.direktiv.output.error | Template error for output generation of the service |
| io.direktiv.ri.error | Can not create information object from request |


### Types
#### <span id="post-o-k-body"></span> postOKBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| powershell | [][PostOKBodyPowershellItems](#post-o-k-body-powershell-items)| `[]*PostOKBodyPowershellItems` |  | |  |  |


#### <span id="post-o-k-body-powershell-items"></span> postOKBodyPowershellItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| result | [interface{}](#interface)| `interface{}` | ✓ | |  |  |
| success | boolean| `bool` | ✓ | |  |  |


#### <span id="post-params-body"></span> postParamsBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| commands | [][PostParamsBodyCommandsItems](#post-params-body-commands-items)| `[]*PostParamsBodyCommandsItems` |  | `[{"command":"echo Hello"}]`| Array of commands. |  |
| files | [][DirektivFile](#direktiv-file)| `[]apps.DirektivFile` |  | | File to create before running commands. |  |


#### <span id="post-params-body-commands-items"></span> postParamsBodyCommandsItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| command | string| `string` |  | | Command to run |  |
| continue | boolean| `bool` |  | | Stops excecution if command fails, otherwise proceeds with next command |  |
| print | boolean| `bool` |  | `true`| If set to false the command will not print the full command with arguments to logs. |  |
| silent | boolean| `bool` |  | | If set to false the command will not print output to logs. |  |

 
