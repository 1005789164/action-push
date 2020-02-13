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
    timeStamp=`date -d "$current" +%s`
    #将current转换为时间戳，精确到毫秒
    currentTimeStamp=$((timeStamp*1000+`date "+%N"`/1000000))
    _FOLDER_OPTION=$currentTimeStamp
    mkdir -p ../d_tmp && cp -rpf * ../d_tmp
    mkdir -p $_FOLDER_OPTION && mv ../d_tmp/* $_FOLDER_OPTION
    rm -rf ../d_tmp && cd $_FOLDER_OPTION
fi

git config --local user.email "${INPUT_USER_EMAIL}"
git config --local user.name "${INPUT_USER_NAME}"
touch abcd
git add ./
git commit -m "${INPUT_COMMIT_MSG}" -a

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS_OPTION

