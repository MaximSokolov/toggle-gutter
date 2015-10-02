{CompositeDisposable} = require 'atom'

module.exports =
class ToggleGutter
  lineNumbersShowing: false
  guttersShowing: true
  lineNumbersDisposable: null
  gutterDisposable: null

  constructor: ->
    @subscriptions = new CompositeDisposable

  destroy: ->
    @subscriptions.dispose()

  isGuttersShowing: ->
    @guttersShowing

  toggleGutters: ->
    if @isGuttersShowing()
      @hideGutters()
    else
      @showGutters()

  hideGutters: ->
    @gutterDisposable = atom.workspace.observeTextEditors (editor) ->
      atom.views.getView(editor).classList.add('hidden-gutters')
    @subscriptions.add @gutterDisposable

    @guttersShowing = false
    atom.config.set('toggle-gutter.showGutters', false)

  showGutters: ->
    if @gutterDisposable
      @subscriptions.remove @gutterDisposable
      @gutterDisposable.dispose()

    for editor in atom.workspace.getTextEditors()
      atom.views.getView(editor).classList.remove('hidden-gutters')

    @guttersShowing = true
    atom.config.set('toggle-gutter.showGutters', true)

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
