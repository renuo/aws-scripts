# This script sets up AWS for a new project

set -e

echo ""
echo "Renuo AWS-Setup:"
echo "Please type in the app name (without environment suffixes): "
read APP_NAME

# setting up the aws user
aws --profile renuo-app-setup iam create-user --user-name ${APP_NAME}
aws --profile renuo-app-setup iam add-user-to-group --user-name ${APP_NAME} --group-name renuo-apps
aws --profile renuo-app-setup iam create-access-key --user-name ${APP_NAME}

# setting up s3 buckets
aws --profile renuo-app-setup s3 mb s3://${APP_NAME}-master --region eu-central-1
aws --profile renuo-app-setup s3 mb s3://${APP_NAME}-develop --region eu-central-1
aws --profile renuo-app-setup s3 mb s3://${APP_NAME}-testing --region eu-central-1

# setting up versioning for the master
aws --profile renuo-app-setup s3api put-bucket-versioning --bucket ${APP_NAME}-master --versioning-configuration Status=Enabled
exit 0
