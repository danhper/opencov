#!/bin/sh
cp "/opencov/config/local.sample.exs" "/opencov/config/local.exs"

OLD="URLHOST"
NEW=$HOST
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"
OLD="SCHEME"
NEW=$URL_SCHEME
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"
OLD="SECRET_KEY"
NEW=$SECRET_KEY
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"
OLD="PORT"
NEW=$PORT
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"

OLD="DB_USERNAME"
NEW=$DB_USERNAME
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"
OLD="DB_PASSWORD"
NEW=$DB_PASSWORD
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"
OLD="DB_HOSTNAME"
NEW=$DB_HOSTNAME
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"

OLD="KEYCLOAK_SECRET"
NEW=$KEYCLOAK_SECRET
sed -i "s/$OLD/$NEW/g" "/opencov/config/local.exs"
