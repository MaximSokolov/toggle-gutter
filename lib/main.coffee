{CompositeDisposable} = require 'atom'

module.exports = ToggleGutter =
  config:
    showNumbers:
      type: 'boolean'
      default: false
    showGutter:
      type: 'boolean'
      default: true

  lineNumbersShowing: false
  lineNumbersDisposable: null
  gutterDisposable: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'toggle-gutter:gutter': => @toggleGutter()
      'toggle-gutter:line-numbers': => @toggleLineNumbers()

    if atom.config.get('toggle-gutter.showGutter') isnt atom.config.get('editor.showLineNumbers')
      atom.config.set('editor.showLineNumbers', atom.config.get('toggle-gutter.showGutter'))

    @subscriptions.add atom.config.onDidChange 'editor.showLineNumbers', ({newValue}) =>
      if newValue isnt @isGutterShowing()
        @toggleGutter()

    @subscriptions.add atom.config.onDidChange 'toggle-gutter.showGutter', ({newValue}) ->
      if newValue isnt atom.config.get('editor.showLineNumbers')
        atom.config.set('editor.showLineNumbers', newValue)

    @subscriptions.add atom.config.onDidChange 'toggle-gutter.showNumbers', ({newValue}) =>
      if newValue isnt @lineNumbersShowing
        @toggleLineNumbers()

    @lineNumbersShowing =  atom.config.get('toggle-gutter.showNumbers')
    unless @isGutterShowing()
      @hideGutter()

    unless @isLineNumbersShowing()
      @hideLineNumbers()

  deactivate: ->
    @subscriptions.dispose()

  isGutterShowing: ->
    atom.config.get('toggle-gutter.showGutter')

  toggleGutter: ->
    if @isGutterShowing()
      @hideGutter()
    else
      @showGutter()

  hideGutter: ->
    @gutterDisposable = atom.workspace.observeTextEditors (editor) ->
      atom.views.getView(editor).classList.add('hidden-gutter')
    @subscriptions.add @gutterDisposable

    atom.config.set('toggle-gutter.showGutter', false)

  showGutter: ->
    if @gutterDisposable
      @subscriptions.remove @gutterDisposable
      @gutterDisposable.dispose()

    for editor in atom.workspace.getTextEditors()
      atom.views.getView(editor).classList.remove('hidden-gutter')

    atom.config.set('toggle-gutter.showGutter', true)

  isLineNumbersShowing: ->
    @lineNumbersShowing

  toggleLineNumbers: ->
    if @isLineNumbersShowing()
      @hideLineNumbers()
    else
      @showLineNumbers()

  hideLineNumbers: ->
    @lineNumbersDisposable = atom.workspace.observeTextEditors (editor) ->
      atom.views.getView(editor).classList.add('hidden-line-numbers')

    @subscriptions.add @lineNumbersDisposable

    @lineNumbersShowing = false
    atom.config.set('toggle-gutter.showNumbers', false)

  showLineNumbers: ->
    if @lineNumbersDisposable
      @subscriptions.remove @lineNumbersDisposable
      @lineNumbersDisposable.dispose()

    for editor in atom.workspace.getTextEditors()
      atom.views.getView(editor).classList.remove('hidden-line-numbers')

    @lineNumbersShowing = true
    atom.config.set('toggle-gutter.showNumbers', true)
