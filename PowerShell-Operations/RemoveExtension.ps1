
$Path="C:\Users\i4682\Downloads\DeidentificationScript_2017"
$Extension="sql"

#TEST FIRST 
gci $Path\*.$Extension |% {rename-item $_.fullname -newname $_.basename -whatif}

#EXECUTE
gci $Path\*.$Extension |% {rename-item $_.fullname -newname $_.basename }
