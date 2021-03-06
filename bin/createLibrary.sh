#!/bin/bash

CATALOG_ROUTE=$(oc get route catalog -n home-library --template='{{ .spec.host }}')
BOOKSHELF_ROUTE=$(oc get route bookshelf -n home-library --template='{{ .spec.host }}')
LIBRARIAN_ROUTE=$(oc get route librarian -n home-library --template='{{ .spec.host }}')

for i in $(cat isbn.list)
do
    BOOK_INFO=$(curl http://${CATALOG_ROUTE}/bookCatalog/getBookInfo/${i})
    curl -X POST -H "Content-Type: application/json" -d ${BOOK_INFO} http://${CATALOG_ROUTE}/bookCatalog/saveBookInfo
    CATALOG_ID=$(echo ${BOOK_INFO} | jq .catalogId)
    curl -X POST -H "Content-Type: application/json" -d "{\"catalogId\":${CATALOG_ID},\"status\":\"ON_SHELF\",\"bookCaseId\":1,\"bookShelfId\":1}" http://${BOOKSHELF_ROUTE}/bookshelf/addBook
done

