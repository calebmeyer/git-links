{CompositeDisposable, BufferedProcess} = require 'atom'
Path = require 'path'

module.exports = GitLinks =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace',
      'git-links:copy-absolute-link-for-current-line': => @currentLine()
      'git-links:copy-absolute-link-for-current-file': => @currentFile()

  deactivate: ->
    @subscriptions.dispose()

  currentLine: ->
    # there is no current line if we don't have an active text editor
    if editor = atom.workspace.getActiveTextEditor()
      cursor = editor.getCursors()[0]
      line = cursor.getBufferRow() + 1 # 0 based list of rows, 1 based file lines
      filePath = @forwardFilePath()
      self = this
      # callback hell, here we come
      self.git(['config', '--get', 'remote.origin.url'], (code, stdout, errors) ->
        repo = stdout.trim()
          .replace(/^git@/, 'https://')
          .replace(/\.com:/, '.com/')
          .replace(/\.git$/, '')

        self.git(['log', '--pretty=oneline', '-1'], (code, stdout, errors) ->
          commitHash = stdout.split(' ')[0]

          self.git(['rev-parse', '--show-toplevel'], (code, stdout, errors) ->
            gitDirectory = stdout.trim()
            relativePath = filePath.replace(gitDirectory, '')
            link = repo + '/blob/' + commitHash + relativePath + '#L' + line
            atom.clipboard.write(link)
          )
        )
      )

  # duplication is better than the wrong abstraction - Sandi Metz
  currentFile: ->
    # there is no current file if we don't have an active text editor
    if editor = atom.workspace.getActiveTextEditor()
      filePath = @forwardFilePath()
      self = this
      # callback hell, here we come
      self.git(['config', '--get', 'remote.origin.url'], (code, stdout, errors) ->
        repo = stdout.trim()
          .replace(/^git@/, 'https://')
          .replace(/\.com:/, '.com/')
          .replace(/\.git$/, '')

        self.git(['log', '--pretty=oneline', '-1'], (code, stdout, errors) ->
          commitHash = stdout.split(' ')[0]

          self.git(['rev-parse', '--show-toplevel'], (code, stdout, errors) ->
            gitDirectory = stdout.trim()
            relativePath = filePath.replace(gitDirectory, '')
            link = repo + '/blob/' + commitHash + relativePath
            atom.clipboard.write(link)
          )
        )
      )

  # HELPER METHODS here on down
  filePath: -> atom.workspace.getActiveTextEditor().getBuffer().getPath()
  fileDirectory: -> Path.dirname(@filePath())

  # file's path, but with forward slashes like urls use
  forwardFilePath: -> @filePath().replace(/\\/g, '/')

  # args should be an array of strings
  # for `git reset --hard`, the array would be ['reset', '--hard']
  # callback is a function which will be called with the exit code and standard output once the command has finished
  # cwd is the current working directory to call git in (defaults to current file's directory)
  git: (args, callback, cwd) ->
    cwd = @fileDirectory() unless cwd?
    stdout = ''
    errors = ''
    new BufferedProcess({
      command: 'git'
      args
      options: {cwd}
      stdout: (output) ->
        console.log(output)
        stdout += output
      stderr: (errorOutput) ->
        console.error(errorOutput) if errorOutput?
        errors += errorOutput
      exit: (code) ->
        console.log("`git #{args.join(' ')}` exited with status: #{code}")
        callback(code, stdout, errors)
    })
