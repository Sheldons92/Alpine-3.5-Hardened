#!/usr/bin/env bash

source version.sh

REPO=
AUTHOR=
COMPONENT=
LATEST=

VERSIONTAG=${REPO}/${AUTHOR}/${COMPONENT}:${VERSION}
LATESTTAG=${REPO}/${AUTHOR}/${COMPONENT}:${LATEST}

if [ "${GIT_COMMIT}" != "" ]; then
    LAST_COMMENT=$(git show -s --format="%s" HEAD)
    if [[ ${LAST_COMMENT} == Upped* ]]; then
        echo "Skipping build, last commit was automatic"
    else
        echo "Checking out develop to enable git push"
	git fetch --all
	git branch -D develop
        git checkout -b develop --track origin/develop
        docker build --rm -t ${LATESTTAG} .
        docker login -u $USERNAME -p $PASSWORD --email ci $REPO
        docker push ${LATESTTAG}
        GITTAG=${REPO}/${AUTHOR}/${COMPONENT}:${GIT_COMMIT}
        docker tag $LATESTTAG $GITTAG
        docker tag $GITTAG $VERSIONTAG
        docker push $VERSIONTAG
        docker push $GITTAG
        docker rmi -f ${GITTAG}
        docker rmi -f ${LATESTTAG}
        docker rmi -f ${VERSIONTAG}
        git config user.name "${GITUSERNAME}"
        git config user.email "${GITUSEREMAIL}"
        git tag -a ${VERSION} -m "Version ${VERSION}"
        ./increment.sh p
        git commit -am "Upped next version to $(cat version.sh)"
        git push origin develop --tags
    fi
else
    docker build --rm -t ${LATESTTAG} .
fi
