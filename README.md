# git-links
Beta: command names may change, but no commands should disappear

This package provides a quick way to get a link to any piece of code hosted in github or github enterprise.

## Install
`apm install git-links`

or

1. `Ctrl(command)+,` (open settings)
1. Click install, and ensure that "packages" is selected
1. Type `git-links` in the box and hit enter
1. Click install

## Usage
Define your own keymap, or use Ctrl(command)+Shift+P (the command palette) to execute one of the commands

### Commands
NOTE: These are subject to change at any time until this package reaches 1.0

|Name|Description|
|----|-----------|
|`git-links:copy-absolute-link-for-current-line`|Copies a link to your clipboard which represents the current line of code in Github|
|`git-links:copy-absolute-link-for-current-file`|Copies a link to your clipboard which represents the current file in Github|
|`git-links:copy-absolute-link-for-current-commit`|Copies a link to your clipboard which represents the current commit in Github|

## Roadmap
- [x] 0.1.0 Initial release, copy current line
- [x] 0.2.0 Copy current file
- [x] 0.3.0 Copy current commit
- [ ] 0.4.0 Add relative commands (links to branches, rather than commits)
- [x] 0.5.0 Add indication that link was copied (completed ahead of schedule)
- [ ] 0.6.0 Add commands to insert links into current buffer instead of copying them
- [ ] 0.7.0 Add ability to point to a specific git instead of just using `git` and expecting the shell to figure it out
- [ ] 1.0.0 Clean up all the above into a nice package
- [ ] 1.1.0 Add bitbucket support
- [ ] 1.2.0 Add gitlab support

## Contributing
Contributions are always welcome!

If you encounter a bug, please open an issue and [write a bug report](http://www.lee-dohm.com/2015/01/04/writing-good-bug-reports/).

If you want to add a new feature or fix a bug, fork this repository and send a pull request.
