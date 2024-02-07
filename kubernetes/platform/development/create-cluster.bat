echo "Initializing Kubernetes cluster..."

minikube start --cpus 2 --memory 4g --driver docker --profile polar

echo "Enabling NGINX Ingress Controller..."

minikube addons enable ingress --profile polar

ping 127.0.0.1 -n 31 > nul

echo "Deploying Keycloak..."

kubectl apply -f services/keycloak-config.yml
kubectl apply -f services/keycloak.yml

ping 127.0.0.1 -n 6 > nul

echo "Waiting for Keycloak to be deployed..."

kubectl wait --for=condition=ready pod --selector=app=polar-keycloak --timeout=300s

echo "Ensuring Keycloak Ingress is created..."

kubectl apply -f services/keycloak.yml

echo "Deploying PostgreSQL..."

kubectl apply -f services/postgresql.yml

ping 127.0.0.1 -n 6 > nul

echo "Waiting for PostgreSQL to be deployed..."

kubectl wait --for=condition=ready pod --selector=db=polar-postgres --timeout=180s

echo "Deploying Redis..."

kubectl apply -f services/redis.yml

ping 127.0.0.1 -n 6 > nul

echo "Waiting for Redis to be deployed..."


echo "Waiting for Redis to be ready..."

kubectl wait --for=condition=ready pod --selector=db=polar-redis --timeout=180s

echo "Deploying RabbitMQ..."

kubectl apply -f services/rabbitmq.yml

ping 127.0.0.1 -n 6 > nul


echo "Waiting for RabbitMQ to be ready..."

kubectl wait --for=condition=ready pod --selector=db=polar-rabbitmq --timeout=180s

echo "Deploying Polar UI..."

kubectl apply -f services/polar-ui.yml

ping 127.0.0.1 -n 6 > nul

echo "Waiting for Polar UI to be deployed..."

kubectl wait --for=condition=ready pod --selector=app=polar-ui --timeout=180s

echo "Happy Sailing!"
