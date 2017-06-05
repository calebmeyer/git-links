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
      repo = @git(['config', '--get', 'remote.origin.url'])
      # repo.replace(/\.git$/, '')
      console.log(line)
      console.log(filePath)
      console.warn(repo)

  # args should be an array of strings
  # for `git reset --hard`, the array would be ['reset', '--hard']
  git: (args) ->
    result = ''
    command = 'git'
    stdout = (output) ->
      console.warn(output)
      result += output
    exit = (code) -> console.log("`git #{args.join(' ')}` exited with status: #{code}")
    process = new BufferedProcess({command, args, stdout, exit})
    return result
