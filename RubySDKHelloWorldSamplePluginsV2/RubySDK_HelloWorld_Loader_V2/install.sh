#!/bin/bash
MYDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${MYDIR}
BASEDIR="$(dirname "$MYDIR")/app_gems/"
echo "Gem install location: ${BASEDIR}"
echo "Gem path is : ${GEM_PATH}"
echo "Gem home is : ${GEM_HOME}"

export GEM_PATH=${BASEDIR}ruby/2.2.0:$GEM_PATH
echo "Modified Gem path is : ${GEM_PATH}"

bundle install --path $BASEDIR
bundle update
