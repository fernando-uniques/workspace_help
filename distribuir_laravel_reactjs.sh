#distribuicao tpeinet

# atualizar svn, remover build and recopilar o projeto
export backend="/var/www/html/sgcelo/sgcelo"
export frontend="/var/www/html/sgcelo/sgcelo_view"

cd $frontend/..
svn up
cd $frontend
rm -rf build/
echo "copilando projeto"
npm run build
wait

# remover arquivos antigos do svn
cd $backend/public
svn rm precache-*
svn delete static
echo "arquivos antigos removidos"


# copia arquivos
echo "copiando arquivos"
cp -rf $frontend/build/* $backend/public/


echo "subindo para o svn"
cd $backend/public/
svn revert ./procEnv.js
svn add ./*
svn ci -m "deploy `date`"
wait

echo "Removendo pasta build View"
rm -rf $frontend/build

echo "done"