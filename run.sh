#!/usr/bin/env bash

if [ ! -n "$WERCKER_GIT_NOT_BEHIND_BRANCH_BRANCH" ] ; then
    error "branch property is not set or empty."
    exit 1
fi

if [ ! -n "$WERCKER_GIT_NOT_BEHIND_BRANCH_FAIL_ON_BEHIND" ] ; then
    error "fail_on_behind property is not set or empty."
    exit 1
fi

if ! [ "$WERCKER_GIT_NOT_BEHIND_BRANCH_FAIL_ON_BEHIND" == "true" ] \
    && ! [ "$WERCKER_GIT_NOT_BEHIND_BRANCH_FAIL_ON_BEHIND" == "false" ] ; then
    error "fail_on_behind property can only be be true or false."
    exit 1
fi

if [ ! -n "$WERCKER_GIT_NOT_BEHIND_BRANCH_MSG_NOT_BEHIND" ] ; then
    error "msg_not_behind property is not set or empty."
    exit 1
fi

if [ ! -n "$WERCKER_GIT_NOT_BEHIND_BRANCH_MSG_BEHIND" ] ; then
    error "msg_behind property is not set or empty."
    exit 1
fi

COMMITS_BEHIND_MASTER=$(git rev-list --left-right --count $WERCKER_GIT_NOT_BEHIND_BRANCH_BRANCH...$WERCKER_GIT_COMMIT | awk '{print $1}')

if [ "$COMMITS_BEHIND_MASTER" == "0" ] ; then
    MSG=$(printf "$WERCKER_GIT_NOT_BEHIND_BRANCH_MSG_NOT_BEHIND" "$WERCKER_GIT_NOT_BEHIND_BRANCH_BRANCH")
    info "$MSG"
else
    MSG=$(printf "$WERCKER_GIT_NOT_BEHIND_BRANCH_MSG_BEHIND" "$COMMITS_BEHIND_MASTER" "$WERCKER_GIT_NOT_BEHIND_BRANCH_BRANCH")

    if [ $WERCKER_GIT_NOT_BEHIND_BRANCH_FAIL_ON_BEHIND == "true" ] ; then
        error "$MSG"
        exit 1
    else
        info "$MSG"
    fi
fi
