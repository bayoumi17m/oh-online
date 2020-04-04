GREEN='\033[0;32m'
NC='\033[0;0m'
RED="\033[0;31m"
YELLOW="\033[0;33m"
RESET="\033[0m"
CLEAR="\033[0K"

# Check out our ip address
# curl ifconfig.me
# echo ''

export PATH=$PATH:$(pwd)

# echo "nameserver 34.230.68.125" | sudo tee -a /etc/resolv.conf

echo -e "${YELLOW}==== TESTING NAMESERVER RESOLUTION ====${NC}"
dummyempty=$(dig +short https://api.k8s.ithaqueue.com)
failure=true
if [ -z "$dummyempty" ];
then
    echo -e "${RED}====             FAILURE             ====${NC}"
elif [ "$dummyempty" = ";; connection timed out; no servers could be reached" ];
then
    echo -e "${RED}====             FAILURE             ====${NC}"
else
    failure=false
    echo -e "${GREEN}====             SUCCESS             ====${NC}"
fi
echo -e "${YELLOW}==== DONE TESTING NAMESERVER RESOLUTION ====${NC}"

echo -e "${YELLOW}==== TESTING KUBECTL CONNECTION ====${NC}"

dummybool=$(kubectl get nodes | grep NAME)
failure=true

if [ "$dummybool" = "NAME                             STATUS   ROLES    AGE    VERSION" ]; then
    failure=false
    echo -e "${GREEN}====             SUCCESS             ====${NC}"
else
    echo -e "${RED}====             FAILURE             ====${NC}"
    kubectl get nodes
fi

echo -e "${YELLOW}==== DONE TESTING KUBECTL CONNECTION ====${NC}"

# if [ "$failure" = true ]; then
#     exit 1
# fi

echo -e "${GREEN}==== Deploying RBAC role ====${NC}"
cd deployment/rbac/
for f in $(find ./ -name '*.yaml' -or -name '*.yml'); do kubectl apply -f $f; done
echo -e "${GREEN}==== Done deploying RBAC role ====${NC}"
echo ''

# echo -e "${GREEN}==== Deploying iam role ====${NC}"
# cd ../kube2iam/
# for f in $(find ./ -name '*.yaml' -or -name '*.yml'); do kubectl apply -f $f; done
# echo -e "${GREEN}==== Done deploying iam role ====${NC}"
# echo ''

echo -e "${GREEN}==== Deploying external dns ====${NC}"
cd ../external_dns/
for f in $(find ./ -name '*.yaml' -or -name '*.yml'); do kubectl apply -f $f; done
echo -e "${GREEN}==== Done deploying external dns ====${NC}"
echo ''

# echo -e "${GREEN}==== Deploying cert-manager ====${NC}"
# cd ../cert-manager/
# for f in $(find ./ -name '*.yaml' -or -name '*.yml'); do kubectl apply -f $f; done
# echo -e "${GREEN}==== Done deploying cert-manager ====${NC}"
# echo ''

cd ../..

echo -e "${GREEN}==== Updating Client deployment to VER: $TRAVIS_BUILD_NUMBER ====${NC}"
cd client/
sed -i 's|mb2363/ohclient:|mb2363/ohclient:'$TRAVIS_BUILD_NUMBER'|g' deployment.yaml
echo -e "${GREEN}==== Updated Client deployment to VER: $TRAVIS_BUILD_NUMBER ====${NC}"

echo -e "${GREEN}==== Deploying Updated Client ====${NC}"
kubectl apply -f client/deployment.yaml
echo -e "${GREEN}==== Done deploying Client ====${NC}"
cd ../
echo ''

echo -e "${GREEN}==== Updating Server deployment to VER: $TRAVIS_BUILD_NUMBER ====${NC}"
cd server/
sed -i 's|mb2363/ohserver:|mb2363/ohserver:'$TRAVIS_BUILD_NUMBER'|g' deployment.yaml
echo -e "${GREEN}==== Updated Server deployment to VER: $TRAVIS_BUILD_NUMBER ====${NC}"

echo -e "${GREEN}==== Deploying Updated Server ====${NC}"
kubectl apply -f deployment.yaml
echo -e "${GREEN}==== Done deploying server ====${NC}"
cd ../
echo ''