ENTRYPOINT - Comando principal que o container vai rodar
CMD - Parâmetro

#Build
docker build . 
docker build -f /dir/Dockerfile

#Tag
docker build -t ckackad:v1 .
#Várias tags
docker build -t ckackad:v1 cks:v1 xpto:v2321 .
