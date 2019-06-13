echo 'copying annotation-data-store into tmp/'
    cd tmp
    git clone https://github.com/hyperstudio/MIT-Annotation-Data-Store.git annotation-data-store
    cd annotation-data-store
    echo 'installing node packages'
    npm install

    echo 'creating annotation-data-store local .env'

    cat > .env <<EOF

NODE_ENV=development
PATH=bin:node_modules/.bin:/usr/local/bin:/usr/bin:/bin
PORT=3000
SECRET=the-secret-the-annotator-gets-from-the-authorizing-site
CONSUMER=name-of-the-app-on-which-the-annotator-runs
VERSION=1.0
DB=mongodb://localhost/annotationdb

EOF