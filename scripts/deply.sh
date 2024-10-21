#!/bin/bash

# Parámetros
readonly templateFilePath="$1"
readonly resource="$2"
readonly infraName="my-vpc-stack"

echo " ===> Desplegando VPC usando AWS CloudFormation <====="
echo "AWS CloudFormation template: $templateFilePath"
echo "Recurso: $resource"

# Despliegue con AWS CloudFormation
aws cloudformation deploy --stack-name "$infraName" --template-file "$templateFilePath" \
    --capabilities CAPABILITY_NAMED_IAM \
    --tags "Environment=prod" "Resource=$resource" "Name=$infraName"

# Verificación de errores
if [ $? -ne 0 ]; then
    echo "Error en el despliegue de CloudFormation"
    exit 1
fi

echo "Despliegue de la VPC completado con éxito"