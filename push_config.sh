#!/bin/bash

git add .
git commit
# git commit -m 'first_commit'
# 如果出现错误：fatal:remote origin already exists
# 则执行下面的语句：
git remote rm origin
git remote add origin https://github.com/fu123456/dotfiles-manjaro.git
# git remote add origin git@github.com/fu123456/dotfiles.git
git push origin master

# 如果出现下面的错误：error:failed to push som refs to .....
# 那么执行下面的语句：
# git pull origin master
# 先把远程服务器github上面的文件拉下来，再push上去。
