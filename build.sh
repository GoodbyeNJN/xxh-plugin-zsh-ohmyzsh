#!/usr/bin/env bash

CDIR="$(cd "$(dirname "$0")" && pwd)"
build_dir=$CDIR/build

while getopts A:K:q option
do
  case "${option}"
  in
    q) QUIET=1;;
    A) ARCH=${OPTARG};;
    K) KERNEL=${OPTARG};;
  esac
done

rm -rf $build_dir
mkdir -p $build_dir

for f in pluginrc.zsh
do
    cp $CDIR/$f $build_dir/
done

cd $build_dir

[ $QUIET ] && arg_q='-q' || arg_q=''
[ $QUIET ] && arg_s='-s' || arg_s=''
[ $QUIET ] && arg_progress='' || arg_progress='--show-progress'

ohmyzsh_home=$build_dir/ohmyzsh
tmpdir=$(dirname $(mktemp -u))
if [ -x "$(command -v git)" ]; then
  git clone $arg_q --depth 1 https://github.com/robbyrussell/oh-my-zsh.git $ohmyzsh_home
  git clone $arg_q --depth 1 https://github.com/ntnyq/omz-plugin-pnpm.git $ohmyzsh_home/custom/plugins/pnpm
  git clone $arg_q --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git $ohmyzsh_home/custom/plugins/zsh-autosuggestions
  git clone $arg_q --depth 1 https://github.com/zsh-users/zsh-completions.git $ohmyzsh_home/custom/plugins/zsh-completions
  git clone $arg_q --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ohmyzsh_home/custom/plugins/zsh-syntax-highlighting

  git clone $arg_q --depth 1 https://github.com/GoodbyeNJN/omz-plugin-and-theme.git $tmpdir/omz-plugin-and-theme
  cp -r $tmpdir/omz-plugin-and-theme $ohmyzsh_home/custom/plugins/npm
  cp -r $tmpdir/omz-plugin-and-theme/agnoster.zsh-theme $ohmyzsh_home/custom/themes/agnoster.zsh-theme
  rm -rf $tmpdir/omz-plugin-and-theme
else
  echo Install git
  exit 1
fi
