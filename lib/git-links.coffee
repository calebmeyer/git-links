GitLinksView = require './git-links-view'
{CompositeDisposable} = require 'atom'

module.exports = GitLinks =
  gitLinksView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @gitLinksView = new GitLinksView(state.gitLinksViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @gitLinksView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'git-links:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @gitLinksView.destroy()

  serialize: ->
    gitLinksViewState: @gitLinksView.serialize()

  toggle: ->
    console.log 'GitLinks was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
