#!/bin/sh
set -e

INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
INPUT_FOLDER=${INPUT_FOLDER:-false}
_FORCE_OPTION=''
_TAGS_OPTION=''
_FOLDER_OPTION=''


echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if $INPUT_FORCE; then
    _FORCE_OPTION='--force'
fi

if $INPUT_TAGS; then
    _TAGS_OPTION='--tags'
fi

cd ${INPUT_DIRECTORY}

if $INPUT_FOLDER; then
    current=`date "+%Y-%m-%d %H:%M:%S"`
    currentTimeStamp=`date -d "$current" +%s`
    _FOLDER_OPTION=$currentTimeStamp
    mkdir -p ${GITHUB_WORKSPACE}/$_FOLDER_OPTION && cp -rpf * ${GITHUB_WORKSPACE}/$_FOLDER_OPTION
    cd ${GITHUB_WORKSPACE}/$_FOLDER_OPTION
fi

git config --local user.email "${INPUT_USER_EMAIL}"

git config --local user.name "${INPUT_USER_NAME}"

git add -f ./

git commit -m "${INPUT_COMMIT_MSG}" -a

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git push --force "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS_OPTION

rm -rf ${GITHUB_WORKSPACE}/$_FOLDER_OPTION
