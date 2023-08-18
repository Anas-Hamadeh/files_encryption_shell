# files_encryption_shell
Shell scripts that provide the possibility to encrypt and decrypt folders

## Encryption
``./encryption.sh -s ./docs -d ./docs.enc``

Parameters Usage:  -s [source_dir] -d [destination_encrypted_file]

## Decryption
``./decryption.sh -s ./docs.enc -d ./docs``

Parameters Usage:  -s [source_encrypted_file] -d [destination_dir]
