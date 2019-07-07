#!/bin/bash

function get_alternate_binds()
{
    local alternates
    local git_dir

    git_dir=$(cd $SRC; git rev-parse --absolute-git-dir)
    alternates="$git_dir/objects/info/alternates"
    if [[ -r "$alternates" ]]; then
        for line in $(cat "$alternates")
        do
            echo "-v $line:$line:ro "
        done
    fi
}

function get_output_dir()
{
    local script_base="$1"
    local subarch="$2"
    local distro="$3"
    local version="$4"
    local gcc_version="$5" # optional

    if [[ -z "$script_base" || -z "$subarch" || -z "$distro" || -z "$version" ]]; then
        echo "Error: not enough arguments to get_output_dir()" >&2
        return 1
    fi

    if [[ -n "$gcc_version" ]]; then
	gcc_version="@$gcc_version"
    fi

    if [[ -n "$CI_OUTPUT" ]]; then
        echo "$CI_OUTPUT/$subarch@$distro@$version$gcc_version"
    else
        echo "$script_base/../output/$subarch@$distro@$version$gcc_version"
    fi

    return 0
}

function get_image_name()
{
    image="linuxppc/build:$1-$2"

    if [[ -n "$3" ]]; then
	image="$image-$3"
    fi

    echo "$image"
    return 0
}

grep "^NAME=Fedora$" /etc/os-release > /dev/null
if [[ $? -eq 0 ]]; then
    DOCKER="sudo docker"
else
    DOCKER="docker"
fi
