Build-json() {
    IMAGE_URL="https:\/\/gundamevolution.jp\/favicon.ico"
    _json=$(cat << EOS
{
    "blocks": [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": "UPDATE AGONES DONE :rocket:",
                "emoji": true
            }
        },
        {
            "type": "divider"
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*Branch / Tag *\t\n${CIRCLE_BRANCH}${CIRCLE_TAG}"
            },
            "fields": [
                {
                    "type": "mrkdwn",
                    "text": "*Repo*\t\n${CIRCLE_PROJECT_REPONAME}"
                },
                {
                    "type": "mrkdwn",
                    "text": "*Message*\t\n${GIT_COMMIT_MSG}"
                },
                {
                    "type": "mrkdwn",
                    "text": "*Commit*\t\n${CIRCLE_SHA1:0:7}"
                },
                {
                    "type": "mrkdwn",
                    "text": "*Author*\t\n${CIRCLE_USERNAME}"
                }
            ]
        }
    ]
}
EOS
)

    _image_json=$(cat << EOS
{
    "type": "image",
    "image_url": "${IMAGE_URL}",
    "alt_text": "thumbnail"
}
EOS
)

    if [ -n "${IMAGE_URL}" ]; then
        _json=$(echo ${_json} | jq '.blocks[2] |= .+ {"accessory": '"${_image_json}"'}')
    fi

    echo "export JSON=${_json}"  >> $BASH_ENV
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Build-json
fi
