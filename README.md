# aws-scripts
Some AWS scripts we use

## `aws_app_setup.rb`

The script takes two mandatory params `--project` and `--suffix`.
From that it generates a user and a bucket of the scheme `<project>-<branch>-<suffix>`
for each branch `develop`, `master` and `testing`.
