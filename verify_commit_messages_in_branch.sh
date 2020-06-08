#!/bin/bash
# A helper script to verify the messages of every commit in
# the current branch when compared against `origin/<base_branch>`.
# If there is no difference then the latest commit will be used.

if [ -z "$1" ]
then
	echo "Base branch not specified, falling back to master"
	base_branch=master
fi

set -eu

script_dir=$(dirname "$0")
base_branch=$1
commits_since_base=$(git rev-list HEAD ^origin/$base_branch)

while read -r commit_hash; do
    commit_message="$(git log --format=%B -n 1 $commit_hash)"
    python3 $script_dir/bad_commit_message_blocker.py --message "$commit_message"
done <<< "$commits_since_base"
