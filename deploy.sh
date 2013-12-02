meteor bundle forakerclimb.tgz
tar -zxvf forakerclimb.tgz && rm forakerclimb.tgz
rsync -r bundle/* ../foraker-climb/
rm -rf bundle
cd ../foraker-climb
cd programs/server
rm -rf node_modules/fibers
npm install fibers
cd ../..
git add -A
git commit -m 'Re-bundle'
git push heroku
