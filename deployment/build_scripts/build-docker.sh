cd client
docker build -t ohclient .
docker tag ohclient mb2363/ohclient:latest
docker tag ohclient mb2363/ohclient:$TRAVIS_BUILD_NUMBER
docker push mb2363/ohclient:latest
docker push mb2363/ohclient:$TRAVIS_BUILD_NUMBER

cd ../server
docker build -t ohserver .
docker tag ohserver mb2363/ohserver:latest
docker tag ohserver mb2363/ohserver:$TRAVIS_BUILD_NUMBER
docker push mb2363/ohserver:latest
docker push mb2363/ohserver:$TRAVIS_BUILD_NUMBER