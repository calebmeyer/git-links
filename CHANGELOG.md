## 0.1.0 - First Release
* Added command to copy link for the current current line
* Added (internal) git function so we can run git commands

## 0.1.1 - Fixed Readme

## 0.2.0 - File Support
* Added command to copy link for the current file
* Added (internal) functions to get the current file/path
* Updated git function to use the current path instead of relying on the environment (fixes #1)

## 0.3.0 - Commit Support
* Added command to copy link for the current commit
* Updated regex to work for repos cloned using ssh
* Updated regex to work for GitHub Enterprise

## 0.3.1 - bugfix
* There was an issue with the indentation in git-links.coffee. That's been fixed.
