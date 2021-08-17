sfdx force:org:create -s -f config\project-scratch-def.json --setalias saraDanPlural --durationdays 7 --setdefaultusername
sfdx force:source:push
sfdx force:user:permset:assign -n Source_Tracker