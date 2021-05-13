docker build -t ft_server .
docker run -p 80:80 -p 443:443 --name ft_serv -d ft_server
