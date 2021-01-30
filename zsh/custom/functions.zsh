# old encryption method (not as secure)
function old_encrypt() { openssl aes-256-cbc -salt -in $1 -out $2; }
function old_decrypt() { openssl aes-256-cbc -d -in $1 -out $2; }

# current encryption method (using GPG)
function encrypt() { gpg --output $1 --symmetric --no-symkey-cache --cipher-algo AES256 $2; }
function decrypt() { gpg --output $1 --decrypt --no-symkey-cache $2; }
