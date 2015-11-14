AtomSpellcheckView = require './atom-spellcheck-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomSpellcheck =
  atomSpellcheckView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomSpellcheckView = new AtomSpellcheckView(state.atomSpellcheckViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomSpellcheckView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-spellcheck:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomSpellcheckView.destroy()

  serialize: ->
    atomSpellcheckViewState: @atomSpellcheckView.serialize()

  toggle: ->
    console.log 'AtomSpellcheck was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      words = editor.getText().split(/\s+/).length
      @atomSpellcheckView.setCount(words)
      @modalPanel.show()
