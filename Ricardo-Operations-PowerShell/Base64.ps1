### BASE 64 ENCODING IS USED WHEN WE WANT TO TRANSFER DATA OVER MEDIA OR NETWORK IN ASCII STRING FORMAT 
### SO THAT DATA REMAIN INTACT ON TRANSPORT.
Clear-Host

$Text = '2393TQ:f893cec6f7790e30fa01cb9a64863a03'
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$EncodedText =[Convert]::ToBase64String($Bytes)
Write-Host -ForegroundColor Green "### TEXT"
$Text
Write-Host -ForegroundColor Green "### ENCODEDTEXT"
$EncodedText

$EncodedText2 = $EncodedText
$DecodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedText2))
Write-Host -ForegroundColor Green "### DECODEDTEXT"
$DecodedText

### https://www.base64encode.org/
# MjM5M1RROmY4OTNjZWM2Zjc3OTBlMzBmYTAxY2I5YTY0ODYzYTAz
# MgAzADkAMwBUAFEAOgBmADgAOQAzAGMAZQBjADYAZgA3ADcAOQAwAGUAMwAwAGYAYQAwADEAYwBiADkAYQA2ADQAOAA2ADMAYQAwADMA