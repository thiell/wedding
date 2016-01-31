#!/bin/bash

GITHUB_PAGES_BRANCH="gh-pages"

CHI_BRANCH="gh-pages"
CHI_REMOTE_NAME="origin"
CHI_REMOTE_URL="git@github.com:cbaclig/wedding.git"

LBC_BRANCH="lbc"
LBC_REMOTE_NAME="lbc"
LBC_REMOTE_URL="git@github.com:cbaclig/wedding-la.git"
LBC_HOST="www.chrisandnikita-la.com"

CNAME_FILE="CNAME"

function log {
  echo "[deploy.sh] $1"
}

log "Adding Chicago remote named \"$CHI_REMOTE_NAME..\""

if [[ `git remote | grep $CHI_REMOTE_NAME | wc -l` -eq 0 ]]; then
  git remote add $CHI_REMOTE_NAME $CHI_REMOTE_URL
else
  log "> $CHI_REMOTE_NAME remote already exists"
fi

log "Adding Long Beach remote named \"$LBC_REMOTE_NAME..\""

if [[ `git remote | grep $LBC_REMOTE_NAME | wc -l` -eq 0 ]]; then
  git remote add $LBC_REMOTE_NAME $LBC_REMOTE_URL
else
  log "> $LBC_REMOTE_NAME remote already exists"
fi

log "Deploying Chicago version..."

if [[ `git br | grep $CHI_BRANCH | wc -l` -eq 0 ]]; then
  git branch $CHI_BRANCH
  git branch -u $CHI_REMOTE_NAME/$GITHUB_PAGES_BRANCH $CHI_BRANCH
fi

git checkout $CHI_BRANCH
if [ $? -ne 0 ]; then
  echo "Can't check out $CHI_BRANCH - aborting!"
  exit 1
fi

git push $CHI_REMOTE_NAME $CHI_BRANCH:$GITHUB_PAGES_BRANCH

log "Done with Chicago version!"


log "Deploying Long Beach version..."

if [[ `git br | grep $LBC_BRANCH | wc -l` -eq 0 ]]; then
  git branch $LBC_BRANCH
  git branch -u $LBC_REMOTE_NAME/$GITHUB_PAGES_BRANCH $LBC_BRANCH
fi

log "git checkout $LBC_BRANCH"
git checkout $LBC_BRANCH
if [ $? -ne 0 ]; then
  echo "Can't check out $LBC_BRANCH - aborting!"
  exit 1
fi

if [ `cat CNAME` != $LBC_HOST ]; then
  log "Updating CNAME file on $LBC_BRANCH..."
  
  echo $LBC_HOST > $CNAME_FILE
  git add $CNAME_FILE
  git commit -m "Updating CNAME for Long Beach website (via deploy.sh)"

  log "Done updating CNAME file on $LBC_BRANCH"
fi

git merge $CHI_BRANCH -m "Merging $CHI_BRANCH INTO $LBC_BRANCH (via deploy.sh)"
if [ $? -ne 0 ]; then
  echo "Couldn't marge $CHI_BRANCH into $LBC_BRANCH - aborting!"
  exit 1
fi

git push $LBC_REMOTE_NAME $LBC_BRANCH:$GITHUB_PAGES_BRANCH

log "Done with Long Beach version!"

log "Checking out $CHI_BRANCH..."
git checkout $CHI_BRANCH


log "Done updating all website versions!!!"