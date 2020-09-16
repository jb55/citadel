#!/usr/bin/env sh
OHMY=.oh-my-zsh
OLD=/tmp/old

if [ ! -d $OLD ]; then
  mkdir $OLD
fi

# set up symlinks
echo "Creating sym links..."

FILES=`ls -a | grep "^\." \
  | sed \
      -e "1,2d" \
      -e "/\.git$/d" \
      -e "/\.gitmodules$/d" \
`

for FILE in $FILES
do
  DEST=$HOME/$FILE
  if [ -e $DEST ]; then
    mv $DEST $OLD/$FILE
  fi
  ln -sf `pwd`/$FILE $HOME/$FILE
done

# install vim config
echo "Installing vim config..."
ln -sf $HOME/.vim/.vimrc $HOME/.vimrc

# install zsh config
echo "Installing zsh config..."
if [ -d $HOME/$OHMY ]; then
  mv $HOME/$OHMY $OLD/$OHMY
fi

git clone http://github.com/robbyrussell/oh-my-zsh.git $HOME/$OHMY
ln -sf `pwd`/jb55.zsh-theme $HOME/$OHMY/themes/jb55.zsh-theme
