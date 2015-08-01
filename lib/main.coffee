{CompositeDisposable} = require 'atom'
ToggleGutter = require './toggle-gutter'

module.exports =
  config:
    showNumbers:
      type: 'boolean'
      default: false
    showGutter:
      type: 'boolean'
      default: true

  activate: ->
    @toggleGutter = new ToggleGutter
    @subscriptions = new CompositeDisposable
    @subscriptions = atom.commands.add 'atom-workspace',
      'toggle-gutter:gutter': => @toggleGutter.toggleGutter()
      'toggle-gutter:line-numbers': => @toggleGutter.toggleLineNumbers()

    @handleConfigChanges()

    atom.config.set('editor.showLineNumbers', atom.config.get('toggle-gutter.showGutter'))

    unless atom.config.get('toggle-gutter.showGutter')
      @toggleGutter.hideGutter()

    unless atom.config.get('toggle-gutter.showNumbers')
      @toggleGutter.hideLineNumbers()

  deactivate: ->
    @toggleGutter.destroy()
    @subscriptions.dispose()

  handleConfigChanges: ->
    @subscriptions.add atom.config.onDidChange 'editor.showLineNumbers', ({newValue}) =>
      if newValue isnt @toggleGutter.isGutterShowing()
        @toggleGutter.toggleGutter()

    @subscriptions.add atom.config.onDidChange 'toggle-gutter.showGutter', ({newValue}) ->
      if newValue isnt atom.config.get('editor.showLineNumbers')
        atom.config.set('editor.showLineNumbers', newValue)

    @subscriptions.add atom.config.onDidChange 'toggle-gutter.showNumbers', ({newValue}) =>
      if newValue isnt @toggleGutter.lineNumbersShowing
        @toggleGutter.toggleLineNumbers()
