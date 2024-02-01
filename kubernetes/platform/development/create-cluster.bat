echo "Initializing Kubernetes cluster..."

minikube start --cpus 2 --memory 4g --driver docker --profile polar

echo "Enabling NGINX Ingress Controller..."

minikube addons enable ingress --profile polar

echo "Deploying platform services..."

kubectl apply -f services

echo "Waiting for PostgreSQL to be ready..."

kubectl wait --for=condition=ready pod --selector=db=polar-postgres --timeout=180s

echo "Waiting for Redis to be ready..."

kubectl wait --for=condition=ready pod --selector=db=polar-redis --timeout=180s

echo "Happy Sailing!"
