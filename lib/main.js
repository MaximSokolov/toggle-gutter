'use babel'

import { CompositeDisposable } from 'atom'
import ToggleGutter from './toggle-gutter'

export default {
  config: {
    showNumbers: {
      title: 'Show `line-number` gutter',
      type: 'boolean',
      default: false
    },
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

    this.handleConfigChanges()

    if (!atom.config.get('toggle-gutter.showGutters')) {
      this.toggleGutter.hideGutters()
    }

    // HACK: Now `editor.showLineNumbers` hides git diff, folding marks, etc.
    // See https://github.com/atom/atom/issues/3466 for details
    if (!atom.config.get('editor.showLineNumbers')) {
      atom.config.set('editor.showLineNumbers', true)
      this.toggleGutter.hideLineNumbers()
    } else if (!atom.config.get('toggle-gutter.showNumbers')) {
      this.toggleGutter.hideLineNumbers()
    }
  },

  deactivate() {
    this.toggleGutter.destroy()
    this.subscriptions.dispose()
  },

  handleConfigChanges() {
    this.subscriptions.add(atom.config.onDidChange('editor.showLineNumbers',
      ({newValue}) => {
        if (!newValue) {
          atom.config.set('editor.showLineNumbers', true)
          this.toggleGutter.hideLineNumbers()
        }
      }
    ))

    this.subscriptions.add(atom.config.onDidChange('toggle-gutter.showGutters',
      ({newValue}) => {
        if (newValue !== this.toggleGutter.isContainerVisible()) {
          this.toggleGutter.toggleContainer()
        }
      }
    ))

    this.subscriptions.add(atom.config.onDidChange('toggle-gutter.showNumbers',
      ({newValue}) => {
        if (newValue !== this.toggleGutter.lineNumbersVisible) {
          this.toggleGutter.toggleLineNumbers()
        }
      }
    ))
  }
}
