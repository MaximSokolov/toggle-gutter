{CompositeDisposable} = require 'atom'
ToggleGutter = require './toggle-gutter'

module.exports =
  config:
    showNumbers:
      title: 'Show line numbers'
      type: 'boolean'
      default: false
    showGutters:
      title: 'Show gutters'
      type: 'boolean'
      default: true

  activate: ->
    @toggleGutter = new ToggleGutter
    @subscriptions = new CompositeDisposable
    @subscriptions = atom.commands.add 'atom-workspace',
      'toggle-gutter:gutter': => @toggleGutter.toggleGutters()
      'toggle-gutter:line-numbers': => @toggleGutter.toggleLineNumbers()

    @handleConfigChanges()

    # NOTE: Now `editor.showLineNumbers` toggles Gutter's visibility
    # See https://github.com/atom/atom/issues/3466 for details
    atom.config.set('editor.showLineNumbers', atom.config.get('toggle-gutter.showGutters'))

    unless atom.config.get('toggle-gutter.showGutters')
      @toggleGutter.hideGutters()

    unless atom.config.get('toggle-gutter.showNumbers')
      @toggleGutter.hideLineNumbers()

  deactivate: ->
    @toggleGutter.destroy()
    @subscriptions.dispose()

  handleConfigChanges: ->
    @subscriptions.add atom.config.onDidChange 'editor.showLineNumbers', ({newValue}) =>
      if newValue isnt @toggleGutter.isGuttersShowing()
        @toggleGutter.toggleGutters()

    @subscriptions.add atom.config.onDidChange 'toggle-gutter.showGutters', ({newValue}) ->
      if newValue isnt atom.config.get('editor.showLineNumbers')
        atom.config.set('editor.showLineNumbers', newValue)

    @subscriptions.add atom.config.onDidChange 'toggle-gutter.showNumbers', ({newValue}) =>
      if newValue isnt @toggleGutter.lineNumbersShowing
        @toggleGutter.toggleLineNumbers()
