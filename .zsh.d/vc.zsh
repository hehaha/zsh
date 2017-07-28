#!/bin/zsh
#Autor:
#LastChange: 
#Desciption:
#
MY_LOCAL_SVN_REPO=~/svn/self

local.svn.create() {
    [[ -d $MY_LOCAL_SVN_REPO ]]            || mkdir -p $MY_LOCAL_SVN_REPO
    svnadmin create $MY_LOCAL_SVN_REPO $NE || msgE "Create svn repo failed($?) at $MY_LOCAL_SVN_REPO" 
}

local.svn.import() {
    local message
    local dirName=$1
    [[ -z $dirName ]] && msgE please specify what you want import! && exit 1
    local name=$(basename $dirName)
    read message"?please add comment : " 
    [[ -z $message ]] && message=$name
    msgI "svn import $dirName file://$MY_LOCAL_SVN_REPO/$name/trunk"
    svn import -m "[init]:$message" $dirName file://$MY_LOCAL_SVN_REPO/$name/trunk 
}



