'use babel'

import { CompositeDisposable } from 'atom'
import ToggleGutter from './toggle-gutter'

export default {
  config: {
    showGutters: {
      title: 'Show container with all gutters',
      type: 'boolean',
      default: true
    },
    gutters: {
      title: 'Gutters',
      description: 'Creates a `toggle-gutter:{gutter-name}` command for each gutter in the list. Requires a restart.',
      type: 'array',
      default: ['linter-ui-default'],
      items: {
        type: 'string'
      }
    }
  },

  activate() {
    this.toggleGutter = new ToggleGutter
    this.subscriptions = new CompositeDisposable

    let gutterCommands = {
      'toggle-gutter:gutter': () => this.toggleGutter.toggleContainer(),
      'toggle-gutter:line-numbers': () => this.toggleGutter.toggleLineNumbers()
    }
    const gutters = atom.config.get('toggle-gutter.gutters')
    for (let gutter of gutters) {
      gutterCommands[`toggle-gutter:${gutter}`] = () => {
        return this.toggleGutter.toggleGutter(gutter)
      }

      atom.workspace.observeTextEditors((editor) => {
        editor.onDidAddGutter(({name}) => {
          if (!this.toggleGutter.isGutterVisible(name)) {
            this.toggleGutter.hideGutter(name)
          }
        })
      })
    }

    this.subscriptions = atom.commands.add('atom-workspace', gutterCommands)

    if (!atom.config.get('toggle-gutter.showGutters')) {
      this.toggleGutter.hideContainer()
    }
  },

  deactivate() {
    this.toggleGutter.destroy()
    this.subscriptions.dispose()
  }
}
