#GET ACLs
Get-ChildItem -Recurse | where-object {($_.PsIsContainer)} | get-acl | format-list