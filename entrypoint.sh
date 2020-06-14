#!/bin/bash -l

# check the current target branch
re="^refs/heads/(.*)$"
if [[ $GITHUB_REF =~ $re ]]; then
    branch=${BASH_REMATCH[1]}
else
    echo "Current action only works on branch."
    exit 1
fi

# check path exist
if [[ ! -d ${INPUT_PATH} ]]; then
    echo "Path=${INPUT_PATH} does not exist."
    exit 1
fi

# OK everything should be ok now.

mkdir /root/.ssh/
chmod 700 /root/.ssh/
touch /root/.ssh/known_hosts
chmod 600  /root/.ssh/known_hosts

echo "$INPUT_PRIVATE_KEY" > /root/.ssh/private_key
chmod 600 /root/.ssh/private_key
eval `ssh-agent`
ssh-add /root/.ssh/private_key

echo "Add ${hostname} to valid known hosts"
ssh-keyscan ${hostname} >> /root/.ssh/known_hosts

echo "Check if SSH is happy: ssh git@${hostname}"
ssh -T git@${hostname}

echo "Add remote: ${INPUT_REMOTE}"
git remote add remote ${INPUT_REMOTE}

echo "Analysing path: ${INPUT_PATH}"
SHA1=`splitsh-lite --prefix=${INPUT_PATH}/ --quiet`

echo "Try to push sha1=${SHA1} to branch=${branch}"

git checkout -b splitsh/$branch $SHA1

git push -f remote splitsh/$branch:${INPUT_REMOTE_BRANCH}
