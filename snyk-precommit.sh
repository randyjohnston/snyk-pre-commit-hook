#!/usr/bin/env bash

# Snyk pre-commit hook
# Requirements to run:
# 1. Have Snyk CLI installed (will return an error if Snyk is not installed)
# 2. Have Snyk CLI authenticated (if not authenticated, then pre-commit hook will warn the user)
# 3. Have pre-commit script in their .git/hooks directory as pre-commit
# 4. Make the pre-commit file executable

RED='\033[1;31m' # Bold red
NC='\033[0m' # No Color
SNYK_TEST=snyk test --severity-threshold=high
SNYK_IAC_TEST=snyk iac test --severity-threshold=high
SNYK_CODE_TEST=snyk code test --severity-threshold=high

if ! [ -x "$(command -v snyk)" ]
then
    echo -e "${RED}Snyk could not be found. Please make sure Snyk is installed properly.${NC}" >&2
    echo -e "${RED}Documentation can be found here: https://support.snyk.io/hc/en-us/articles/360003812538-Install-the-Snyk-CLI${NC}" >&2
    exit 1
fi

# This hook will use 3 of the four scans that Snyk offers, and it can be customized to fit the tests you want to make sure are run
# Snyk covers open source vulnerability detection, container vulnerabilities, infrascructure as code misconfigurations, and static code analysis scanning
# For container scanning, we recommend this be done manually as an image name is necessary as a part of the arguments

# It is recommended to learn about the Snyk file and how it works to ignore local vulnerabilities
# https://support.snyk.io/hc/en-us/articles/360007487097-The-snyk-file

# setting severity threshold to high in order to avoid stopping a commit for medium to low severities

# ST_OUTPUT=$($SNYK_TEST)

$SNYK_TEST
$ST_STATUS=$?
echo $ST_STATUS

if [ $ST_STATUS -ne 0 ]
then
  echo -e "${RED}Vulnerablities found.${NC}"
  exit 1
fi

# $SNYK_IAC_TEST
# $SNYK_CODE_TEST