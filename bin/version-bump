#! /bin/bash

branch=beta

git checkout master
git pull origin master

git checkout staging
git pull origin staging
git merge master

git checkout $branch
git pull origin $branch
git merge staging

ruby -e "p = './config/version.rb'; c = File.read(p); File.open(p, 'w') { |f| f.puts c.sub(/patch\s*=\s*(\d+)/i) { |m| \"#{'patch'.upcase} = #{\$1.to_i + 1}\" } }"

version=`ruby -e "require './config/version.rb'; print OpenCourts::VERSION::STRING"`

git add config/version.rb
git commit -m "Bump version to $version"
git tag "v$version"

git checkout staging
git merge $branch

git checkout master
git merge staging

git checkout $branch

git push origin
git push --tags
