1. go to https://www.nitrous.io register an account, and create a jeklly project
2. start the jeklly project in the IDE
  cd code
  cd jeklly
  git config --global user.email "your email"
  git config --global user.name "your name"
  git init
  git add .
  git commit -m "first commit"
3. go to github and create a new repo called yourname.github.io
4. go back to nitrous.io IDE
  git remote add origin https://github.com/yourname/yourname.github.io.git
  git push origin master
5. use browser and go to yourname.github.io
