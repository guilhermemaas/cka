#Secrets armazenadas em base64
#Criptografar em base64 (-n pra não pular linha):
echo -n "admin" | base64

#Descriptografar:
echo -n "VALOREMBASE64" | base64 -d