#!/bin/sh
set -e

INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
_FORCE_OPTION=''
_TAGS_OPTION=''


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

echo ${GITHUB_WORKSPACE} && echo ${INPUT_DIRECTORY}

if [ ${INPUT_DIRECTORY} != "." ]; then
    cd ${INPUT_DIRECTORY}
    mkdir -p ${GITHUB_WORKSPACE}/${INPUT_FOLDER} && cp -rpf * ${GITHUB_WORKSPACE}/${INPUT_FOLDER}
    cd ${GITHUB_WORKSPACE}/${INPUT_FOLDER}
fi

git config --local user.email "${INPUT_USER_EMAIL}"

git config --local user.name "${INPUT_USER_NAME}"

git add -f ./

git commit -m "${INPUT_COMMIT_MSG}" -a

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git push --force "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS_OPTION

if [ ${INPUT_DIRECTORY} != "." ]; then
    cd ../ && rm -rf ${INPUT_FOLDER}
fi
