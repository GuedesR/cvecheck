#!/bin/sh

search_dir=$(pwd .)
current_date=$(date +%d-%m-%Y)
API_LIST="carts-sapi,carts-papi,orders-sapi,orders-papi,products-sapi,products-papi,product-reg-sapi,product-reg-papi,eapi-dc,eapi-dre,eapi-hybris,eapi-resolve,eapi-sf,xref-api"

report_dir="$search_dir/dependency_checks/$current_date/"


generate_reports()

{
	mkdir -p $report_dir

	if [ $1 = "allApis" ]; 
		then
			inserted_list=$API_LIST
		else
			inserted_list=$1
	fi;
	IFS=','
	read -ra APIS <<< "$inserted_list"


	for i in "${APIS[@]}"; do 

		for entry in {"$search_dir"/*api,"$search_dir"/*framework}
		do
			cd $entry
		  
			for entryAPI in "."/*
			do
			
			cd $entryAPI
			
			if [ $entryAPI = ./$i ]; then
				echo ""
				echo ""
				echo "---------------$entryAPI---------------"
				echo ""
				echo "-----Getting latest version-----"
				git checkout develop
				git pull -f
				echo ""
				echo "-----Installing dependencies-----"
				sh -c "(mvn clean install -DskipTests)"
				echo ""
				echo "-----Generating $i report-----"
				sh -c '(dependency-check.bat --project '$i' --scan './' --out '$report_dir/$i-25-05-2020.html' --format HTML)'
			fi;
			cd ..
			
			done
		  
			cd ..
		done
		
	done
	break
}

generate_reports $1
