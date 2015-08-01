{CompositeDisposable} = require 'atom'

module.exports =
class ToggleGutter
  lineNumbersShowing: false
  lineNumbersDisposable: null
  gutterDisposable: null

  constructor: ->
    @subscriptions = new CompositeDisposable

  destroy: ->
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
