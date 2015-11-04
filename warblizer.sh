#!/bin/bash

if [ ! -e sdk/*standalone.jar ]
then
  echo "Warblizer: must have sdk first"
  exit 2
fi

APPNAME=`cat config/application.name`

# Standard file changes
echo "Warblizer: Creating version page"
git describe --always > app/views/main/_version.html.erb

# Warbalizing with changed files

echo "Warblizer: Bundling"
WARRING="warbilizing" RAILS_ENV=production jruby -S bundle install --path=target

echo "Warblizer: Pre Cleaning Assets"
WARRING="warbilizing" RAILS_ENV=production jruby -S bundle exec rake assets:clean

echo "Warblizer: Precompiling Assets (this takes a while)"
WARRING="warbilizing" RAILS_RELATIVE_URL_ROOT="/$APPNAME" RAILS_ENV=production jruby -S bundle exec rake assets:precompile

echo "Warblizer: Building War File"
WARRING="warbilizing" RAILS_ENV=production jruby -S bundle exec warble war

echo "Warblizer: Post Cleaning Assets"
WARRING="warbilizing" RAILS_ENV=production jruby -S bundle exec rake assets:clean

echo "Warblizer: Changing permissions and war file name"
chmod +r "$APPNAME.war"
mv -v "$APPNAME.war" "$APPNAME.war.`git describe --always`"

# Resetting standard files
git checkout app/views/main/_version.html.erb
