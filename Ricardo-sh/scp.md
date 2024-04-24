
```bash

scp [OPTION] [user@]SRC_HOST:]file1 [user@]DEST_HOST:]file2

scp file.txt remote_username@10.10.0.2:/remote/directory

scp MemberCoordinationOfBenefits.metadata.json.gz adm_i12701@pvmongodpx01.iehp.org:/tmpMemberCoordinationOfBenefits.metadata.json.gz

#-P - Specifies the remote host ssh port.
#-p - Preserves file modification and access times.
#-q - Use this option if you want to suppress the progress meter and non-error messages.
#-C - This option forces scp to compress the data as it is sent to the destination machine.
#-r - This option tells scp to copy directories recursively.
#The colon (:) is how scp distinguishes between local and remote locations.

```

