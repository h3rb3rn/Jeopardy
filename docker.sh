docker build . -t server
docker run -p 8080:80 -v `pwd`:/var/www server

