#!/usr/bin/env bash

set -e

setupRemixd () {
  mkdir remixdSharedfolder
  cd contracts
  echo 'sharing folder: '
  echo $PWD
  ./../node_modules/remixd/bin/remixd -s $PWD --remix-ide http://127.0.0.1:8080 &
  cd ..
}

BUILD_ID=${CIRCLE_BUILD_NUM:-${TRAVIS_JOB_NUMBER}}
echo "$BUILD_ID"
TEST_EXITCODE=0

npm run ganache-cli &
npm run serve &
setupRemixd

sleep 5

npm run nightwatch_local_generalSettings_firefox || TEST_EXITCODE=1
npm run nightwatch_local_ballot_firefox || TEST_EXITCODE=1
npm run nightwatch_local_gist_firefox || TEST_EXITCODE=1
npm run nightwatch_local_workspace_firefox || TEST_EXITCODE=1
npm run nightwatch_local_defaultLayout_firefox || TEST_EXITCODE=1
npm run nightwatch_local_pluginManager_firefox || TEST_EXITCODE=1
npm run nightwatch_local_publishContract_firefox || TEST_EXITCODE=1
npm run nightwatch_local_fileExplorer_firefox || TEST_EXITCODE=1
npm run nightwatch_local_debugger_firefox || TEST_EXITCODE=1
npm run nightwatch_local_editor_firefox || TEST_EXITCODE=1

echo "$TEST_EXITCODE"
if [ "$TEST_EXITCODE" -eq 1 ]
then
  exit 1
fi
