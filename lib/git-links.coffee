{CompositeDisposable, BufferedProcess} = require 'atom'

module.exports = GitLinks =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that gets a link for the current line
    @subscriptions.add atom.commands.add 'atom-workspace', 'git-links:current-line': => @currentLine()

  deactivate: ->
    @subscriptions.dispose()

  currentLine: ->
    # there is no current line if we don't have an active text editor
    if editor = atom.workspace.getActiveTextEditor()
      cursor = editor.getCursors()[0]
      line = cursor.getBufferRow() + 1 # 0 based list of rows, 1 based file lines
      filePath = editor.getBuffer().getPath()
      self = this
      # callback hell, here we come
      self.git(['config', '--get', 'remote.origin.url'], (code, stdout) ->
        repo = stdout.trim().replace(/\.git$/, '')
        self.git(['log', '--pretty=oneline', '-1'], (code, stdout) ->
          commitHash = stdout.split(' ')[0]
          console.log(line)
          console.log(filePath)
          console.log(repo)
          console.log(commitHash)
        )
      )

  # args should be an array of strings
  # for `git reset --hard`, the array would be ['reset', '--hard']
  # callback is a function which will be called with the exit code and standard output once the command has finished
  git: (args, callback) ->
    stdout = ''
    new BufferedProcess({
      command: 'git'
      args,
      stdout: (output) ->
        console.log(output)
        stdout += output
      exit: (code) ->
        console.log("`git #{args.join(' ')}` exited with status: #{code}")
        callback(code, stdout)
    })
