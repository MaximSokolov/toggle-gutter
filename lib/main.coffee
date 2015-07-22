{CompositeDisposable} = require 'atom'

module.exports = ToggleGutter =
  isLineNumbersHidden: false
  lineNumbersDisposable: null
  gutterDisposable: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'toggle-gutter:gutter': => @toggleGutter()
      'toggle-gutter:line-numbers': => @toggleLineNumbers()

    unless @isGutterShowing()
      @hideGutter()
    else
      @deserialize state

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->
    return {@isLineNumbersHidden}

  deserialize: (state) ->
    if state.isLineNumbersHidden
      @hideLineNumbers()

  isGutterShowing: ->
    atom.config.get('editor.showLineNumbers')

  toggleGutter: ->
    if @isGutterShowing()
      @hideGutter()
    else
      @showGutter()

  hideGutter: ->
    @gutterDisposable = atom.workspace.observeTextEditors (editor) ->
      atom.views.getView(editor).classList.add('hidden-gutter')
    @subscriptions.add @gutterDisposable

    atom.config.set('editor.showLineNumbers', false)

  showGutter: ->
    if @gutterDisposable
      @subscriptions.remove @gutterDisposable
      @gutterDisposable.dispose()

    for editor in atom.workspace.getTextEditors()
      atom.views.getView(editor).classList.remove('hidden-gutter')

    atom.config.set('editor.showLineNumbers', true)

  toggleLineNumbers: ->
    unless @isLineNumbersHidden
      @hideLineNumbers()
    else
      @showLineNumbers()

  hideLineNumbers: ->
    @lineNumbersDisposable = atom.workspace.observeTextEditors (editor) ->
      atom.views.getView(editor).classList.add('hidden-line-numbers')

    @subscriptions.add @lineNumbersDisposable
    @isLineNumbersHidden = true

  showLineNumbers: ->
    if @lineNumbersDisposable
      @subscriptions.remove @lineNumbersDisposable
      @lineNumbersDisposable.dispose()

    for editor in atom.workspace.getTextEditors()
      atom.views.getView(editor).classList.remove('hidden-line-numbers')

    @isLineNumbersHidden = false
