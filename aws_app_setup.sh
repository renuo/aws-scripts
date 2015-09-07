# This script sets up new users and buckets for our three environments

set -e

echo ""
echo "Renuo AWS-Bucket Setup:"
echo "Please type in the app name (without environment suffixes): "
read APP_NAME

# The following creates a user and a bucket with the same for each branch.
# The user will be attached to the current renuo standard apps group.
for BRANCH in master develop testing; do
  aws --profile renuo-app-setup iam create-user --user-name ${APP_NAME}-${BRANCH}
  aws --profile renuo-app-setup iam add-user-to-group --user-name ${APP_NAME}-${BRANCH} --group-name renuo-apps-v2
  aws --profile renuo-app-setup iam create-access-key --user-name ${APP_NAME}-${BRANCH}
  aws --profile renuo-app-setup s3 mb s3://${APP_NAME}-${BRANCH} --region eu-central-1
done

# Enable versioning for the master
aws --profile renuo-app-setup s3api put-bucket-versioning --bucket ${APP_NAME}-master --versioning-configuration Status=Enabled
exit 0
