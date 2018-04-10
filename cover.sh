#!/bin/sh

COVERALLS_ENDPOINT=https://opencov.bukalapak.io mix coveralls.post \
  --sha="$CI_COMMIT_SHA" \
  --committer="$(git log -1 $CI_COMMIT_SHA --pretty=format:'%cN')" \
  --message="$(git log -1 $CI_COMMIT_SHA --pretty=format:'%s')" \
  --branch="$CI_COMMIT_REF_NAME"
