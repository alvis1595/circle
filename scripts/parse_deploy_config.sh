#!/bin/bash

set -e

CONFIG_FILE="deploy-config.yml"

echo "Parsing deployment configuration..."

# Leer configuraciones YAML
deployments=$(yq e '.deployments' "$CONFIG_FILE" -o=json)

# Iterar sobre cada despliegue
for row in $(echo "${deployments}" | jq -r '.[] | @base64'); do
    _jq() {
        echo "${row}" | base64 --decode | jq -r "${1}"
    }

    TEMPLATE_FILE=$(_jq '.template')
    RESOURCE_NAME=$(_jq '.resource')
    REGION=$(_jq '.region')
    OIDC_PROFILE=$(_jq '.oidc_profile')

    echo "Deploying template: $TEMPLATE_FILE"
    echo "Resource: $RESOURCE_NAME"
    echo "Region: $REGION"
    echo "OIDC Profile: $OIDC_PROFILE"

    # Configurar región y perfil dinámicamente
    export AWS_DEFAULT_REGION="$REGION"

    # Autenticarse con el perfil OIDC configurado
    aws sts get-caller-identity --profile "$OIDC_PROFILE"

    # Ejecutar despliegue
    ./scripts/deploy.sh "$TEMPLATE_FILE" "$RESOURCE_NAME"
done