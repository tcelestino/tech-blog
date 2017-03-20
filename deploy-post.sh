git fupum

commitMerge=$(git log | grep Merge | head -n 1 | awk '{print $3}')
srcPost=$(git log --name-status $commitMerge | grep '^A.*\.html\.md$' | head -n 1 | awk '{print $2}')
echo $srcPost

today=$(date +"%Y-%m-%d")

sed -i.tmp -E "s/(date: *).+/\1$today/" $srcPost
rm $srcPost.tmp

git add $srcPost
git ci
git ph

./node_modules/.bin/docpad deploy-ghpages --env static
