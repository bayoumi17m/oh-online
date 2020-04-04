# Using AES with OpenSSL to Encrypt Files

This will briefly describes how to utilise AES to encrypt and decrypt files with OpenSSL.

> AES - [Advanced Encryptuon Standard](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)\
> OpenSSL - [Cryptogrohy and SSL/TLS Toolkit](https://www.openssl.org/)

We do the followng:
* Generate an AES Key and initialization vector (iv) w/ `openssl`
* Encode a file using the Key/IV
* Decode a file using the Key/IV

## Generating Key and IV

We want to generate a 256-bit key and use [Cipher Block Chaining (CBC)](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_Block_Chaining_.28CBC.29)

The basic command is to use `openssl enc` plus some options:
* `-P` Print out the salt, key and IV used, then exit
* `-k <secret>` or `-p pass:<secret>` to specify the password
* `-aes-256-cbc` the specific cipher name we are using
* `-S <salt>` Specify the salt (in raw hex) that is to be used (7 char long)

```console
ubuntu@ip:~$ openssl enc -aes-256-cbc -S 68617373616c740a -pbkdf2 -k hello-aes -P
salt=68617373616C740A
key=0376406EA372240BA1FA3990CB0B139A9129162D053D4D68C0EA07A612D27DF1
iv =91A0A6A3FDD1D6686CA070E677ECE6B5
```

> Note: These are not the actual values used and just here for an example

## Encoding

Let's encode some secrets! Say we have a file with `username="helloworld"` on one line, and the next line has `password="password"`.

```console
$ openssl enc -aes-256-cbc -S <salt>  -in dummy.txt -out dummy.txt.enc -base64 -K <key> -iv <iv>
```

## Decoding

The command is the essentially the same as encoding. There's an addition `-d` for decode.

```console
$ openssl enc -aes-256-cbc -d -S <salt>  -in dummy.txt.enc -out dummy.txt -base64 -K <key> -iv <iv>
```
