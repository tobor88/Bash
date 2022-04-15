#!/bin/bash
# This script is used to auto-update Gitea when new versions come out

NEW_VERSION=$(curl -s https://github.com/go-gitea/gitea/releases/latest | grep -Po '(?<=v)\d.\d\d.\d')
LOCATION=$(which gitea)
CURRENT_VERSION=$(gitea -v | grep -Po '\d.\d\d.\d')


if [ "$CURRENT_VERSION" != "$NEW_VERSION" ]; then
        wget "https://dl.gitea.io/gitea/$NEW_VERSION/gitea-$NEW_VERSION-linux-arm-6" -O /tmp/gitea
        if [ -f /tmp/gitea }; then
                printf "[*] Successfully downloaded Gitea v$NEW_VERSION \n"
                chmod a+x /tmp/gitea
                mv $LOCATION $LOCATION.$CURRENT_VERSION.old
                mv /tmp/gitea $LOCATION
                printf "[*] Saved Gitea v$CURRENT_VERSION as $LOCATION.$CURRENT_VERSION.old \n"
        else
                printf "[!] Failed to dowload Gitea. Check your internet connection and verify https://dl.gitea.io is accessible\n"
                exit 1
        fi

        if [ ! command -v $LOCATION &> /dev/null ]; then
                printf "[!] FAILED to update Gitea \n"
                exit 1
        fi
else
        printf "[*] Using the most current version of Gitea $CURRENT_VERSION \n"
        gitea -v
fi
