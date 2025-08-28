#!/bin/bash

git reset --hard HEAD
for branch in minimal master; do
  git checkout $branch

  rm -rf HOME
  git rm -r --cached HOME/

  echo "Syncing ~/dotfiles/remote/HOME/"
  if test $branch = 'minimal'; then
    rsync -azvhP \
        --info=name0 \
        --info=progress2 \
        --no-inc-recursive \
        --compress-level=9 \
        --copy-links \
        --keep-dirlinks \
        --delete \
        --relative \
        ~/dotfiles/remote/HOME/./.{bash_aliases,bash_profile,bashrc,curlrc,gitconfig,gitmessage,inputrc,less,psqlrc,terminfo,tmux.conf,vimrc} HOME/
  else
    rsync -azvhP \
        --info=name0 \
        --info=progress2 \
        --no-inc-recursive \
        --compress-level=9 \
        --copy-links \
        --keep-dirlinks \
        --delete \
        --exclude-from="/home/panh.linux/dotfiles/remote/.rsyncignore" \
        ~/dotfiles/remote/HOME/ HOME/
  fi

  git add --all
  git status
  git commit -m 'Sync local dotfiles'
  git push origin HEAD --force-with-lease
done
