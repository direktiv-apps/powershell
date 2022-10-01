
Feature: Basic

# The secrects can be used in the payload with the following syntax #(mysecretname)
Background:


Scenario: hello 

	Given url karate.properties['testURL']

	And path '/'
	And header Direktiv-ActionID = 'development'
	And header Direktiv-TempDir = '/tmp'
	And request
	"""
	{
		"files": [
			{
				"name": "remote.ps1",
				"data": "Write-Output Hello",
				"mode": "0755"
			}
		],
		"commands": [
		{
			"command": "pwsh remote.ps1",
			"silent": false,
			"print": true,
		}
		]
	}
	"""
	When method POST
	Then status 200
	And match $ ==
	"""
	{
	"powershell": [
	{
		"result": "#notnull",
		"success": true
	}
	]
	}
	"""
	