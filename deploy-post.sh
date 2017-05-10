git checkout master && git fetch origin && git pull origin master

commit_merge=$(git log | grep Merge | head -n 1 | awk '{print $3}')
src_post=$(git log --name-status $commit_merge | grep '^A.*\.html\.md$' | head -n 1 | awk '{print $2}')
post_name=$(echo $src_post | sed -E "s/.*\/(.*).html.md/\1/")
src_sitemap="src/public/sitemap.xml"
today=$(date +"%Y-%m-%d")

sed -i.tmp -E "s/(date: *).+/\1$today/" $src_post
sed -i.tmp -E "/<\/urlset>/d" $src_sitemap

echo "<url>
  <loc>http://engenharia.elo7.com.br/$post_name/</loc>
</url>
</urlset>" >> $src_sitemap

rm $src_post.tmp
rm $src_sitemap.tmp

git diff

echo "Você tem certeza que quer fazer esse deploy? (y/N)"
read confirma

if [ "$confirma" = "y" ]; then
	git add $src_post
	git add $src_sitemap
	git commit
	git push origin HEAD

	./node_modules/.bin/docpad deploy-ghpages --env static
else
	git checkout $src_post
	git checkout $src_sitemap
	echo "Deploy cancelado :("
fi
