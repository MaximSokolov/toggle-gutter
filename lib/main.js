'use babel'

import { CompositeDisposable } from 'atom'
import ToggleGutter from './toggle-gutter'

export default {
  config: {
    showNumbers: {
      title: 'Show line numbers',
      type: 'boolean',
      default: false
    },
    showGutters: {
      title: 'Show gutters',
      type: 'boolean',
      default: true
    }
  },

  activate() {
    this.toggleGutter = new ToggleGutter
    this.subscriptions = new CompositeDisposable
    this.subscriptions = atom.commands.add('atom-workspace', {
      'toggle-gutter:gutter': () => this.toggleGutter.toggleGutters(),
      'toggle-gutter:line-numbers': () => this.toggleGutter.toggleLineNumbers()
    })

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
        if (newValue !== this.toggleGutter.isGuttersShowing()) {
          this.toggleGutter.toggleGutters()
        }
      }
    ))

    this.subscriptions.add(atom.config.onDidChange('toggle-gutter.showNumbers',
      ({newValue}) => {
        if (newValue !== this.toggleGutter.lineNumbersShowing) {
          this.toggleGutter.toggleLineNumbers()
        }
      }
    ))
  }
}
