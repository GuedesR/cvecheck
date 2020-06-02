#!/bin/bash

cat ./carts-sapi-25-05-2020.json | 
	jq '.dependencies[] | 
		select(.vulnerabilities != null) |  {
			app: .fileName, 
			vulnerabilities:  [
				.vulnerabilities[]? | {
					name: .name,
					link: ("https://nvd.nist.gov/vuln/detail/" + .name),
					severity: .severity,
					score: .cvssv3.baseScore,
					description: .description,
				}
			]
		}
	' > carts-sapi-vulnerabilities.json
	
cat ./carts-sapi-vulnerabilities.json | jq ' @html' > carts-sapi-25-05-2020.html
	
	
