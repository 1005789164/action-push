#!/bin/sh
set -e

REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
INPUT_BRANCH=${INPUT_BRANCH:-master}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
_FORCE_OPTION=''
_TAGS_OPTION=''


echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

[ -z "${INPUT_USERNAME}" ] && {
    exit 1;
};

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi

if ${TAGS}; then
    _TAGS_OPTION='--tags'
fi

cd ${INPUT_DIRECTORY}

remote_repo="https://${INPUT_USERNAME}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"

git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS_OPTION

