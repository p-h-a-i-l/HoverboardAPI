#!/bin/sh

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

flatten_submodule() {
  git checkout -b arduino
  
  git rm --cached src/hbprotocol # delete reference to submodule HEAD (no trailing slash)
  git rm .gitmodules             # if you have more than one submodules,
                                 # you need to edit this file instead of deleting!
  rm -rf src/hbprotocol/.git     # make sure you have backup!!
  mv src/hbprotocol/* src/
  git add .

  git commit --message "Convert to Arduino Library ($TRAVIS_BUILD_NUMBER)"
}

upload_files() {
  git remote add upload https://${GITHUB_TOKEN}@github.com/p-h-a-i-l/HoverboardAPI.git > /dev/null 2>&1
  git push --quiet --set-upstream upload arduino
}

setup_git
flatten_submodule
upload_files
