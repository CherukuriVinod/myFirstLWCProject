echo "Create a scratch org"
sfdx force:org:create -s -f config\project-scratch-def.json --setalias saraDanPlural --durationdays 7 --setdefaultusername

echo "Push source"
sfdx force:source:push

echo "Assigning permission set Source Tracker"
sfdx force:user:permset:assign -n Source_Tracker

echo "Pushing Data To Product Object"
sfdx force:data:tree:import -u saraDanPlural --plan data/Product2-plan.json

echo "Open Newly Created Scratch Org"
sfdx force:org:open

echo "Show Org List"
sfdx force:org:list --all