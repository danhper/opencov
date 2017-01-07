#!/bin/sh

# wake up heroku!
curl https://demo.opencov.com || true

MIX_ENV=test mix coveralls.post \
  --sha="$TRAVIS_COMMIT" \
  --committer="$(git log -1 $TRAVIS_COMMIT --pretty=format:'%cN')" \
  --message="$(git log -1 $TRAVIS_COMMIT --pretty=format:'%s')" \
  --branch="$TRAVIS_BRANCH"
