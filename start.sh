#!/bin/sh
set -e

INPUT_YOU_TOKEN=${INPUT_YOU_TOKEN:-$GITHUB_TOKEN}
INPUT_USER_EMAIL=${INPUT_USER_EMAIL:-'action@github.com'}
INPUT_USER_NAME=${INPUT_USER_NAME:-'GitHub Action'}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'./'}
INPUT_FOLDER=${INPUT_FOLDER:-'dir_upload'}
INPUT_COMMIT_MSG=${INPUT_COMMIT_MSG:-'Add changes'}
INPUT_BRANCH=${INPUT_BRANCH:-'master'}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
_FORCE_OPTION=''
_TAGS_OPTION=''


echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_YOU_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if $INPUT_FORCE; then
    _FORCE_OPTION='--force'
fi

if $INPUT_TAGS; then
    _TAGS_OPTION='--tags'
fi

echo ${GITHUB_WORKSPACE} && echo ${INPUT_DIRECTORY}

cd ${INPUT_DIRECTORY}

if [ $(pwd) != ${GITHUB_WORKSPACE} ]; then
    mkdir -p ${GITHUB_WORKSPACE}/${INPUT_FOLDER} && cp -rpf * ${GITHUB_WORKSPACE}/${INPUT_FOLDER}
    cd ${GITHUB_WORKSPACE}/${INPUT_FOLDER}
fi

git config --global user.email "${INPUT_USER_EMAIL}"

git config --global user.name "${INPUT_USER_NAME}"

remote_repo="https://${INPUT_YOU_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git remote add publisher $remote_repo

git add -f ./

git commit -m "${INPUT_COMMIT_MSG}" -a

git push --force publisher ${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS_OPTION

cd ${INPUT_DIRECTORY}

if [ $(pwd) != ${GITHUB_WORKSPACE} ]; then
    cd ${GITHUB_WORKSPACE} && rm -rf ${INPUT_FOLDER}
fi
