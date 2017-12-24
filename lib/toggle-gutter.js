'use babel'

import {CompositeDisposable} from 'atom'

export default class ToggleGutter {
  constructor() {
    this.lineNumbersVisible = false
    this.containerVisible = true

    this.lineNumbersDisposable = null
    this.gutterDisposable = null
    this.guttersDisposable = {}
    this.subscriptions = new CompositeDisposable()
  }

  destroy() {
    this.subscriptions.dispose()
  }

  isGutterVisible(name) {
    return !(localStorage.getItem(`gutter-${name}-is-hidden`) === 'true')
  }

  toggleGutter(name) {
    if (this.isGutterVisible(name)) {
      this.hideGutter(name)
    } else {
      this.showGutter(name)
    }
  }

  hideGutter(name) {
    this.guttersDisposable[name] = atom.workspace.observeTextEditors((editor) => {
      const gutter = editor.gutterWithName(name)
      if (gutter) {
        gutter.hide()
      }
    })
    localStorage.setItem(`gutter-${name}-is-hidden`, true)
    this.subscriptions.add(this.guttersDisposable[name])
  }

  showGutter(name) {
    if (this.guttersDisposable[name]) {
      this.subscriptions.remove(this.guttersDisposable[name])
      this.guttersDisposable[name].dispose()
    }

    for (let editor of atom.workspace.getTextEditors()) {
      const gutter = editor.gutterWithName(name)
      if (gutter) {
        gutter.show()
      }
    }
    localStorage.setItem(`gutter-${name}-is-hidden`, false)
  }

  isContainerVisible() {
    return this.containerVisible
  }

  toggleContainer() {
    if (this.isContainerVisible()) {
      this.hideContainer()
    } else {
      this.showContainer()
    }
  }

  hideContainer() {
    this.gutterDisposable = atom.workspace.observeTextEditors(
      editor => atom.views.getView(editor).classList.add('hidden-gutters')
    )
    this.subscriptions.add(this.gutterDisposable)

    this.containerVisible = false
    atom.config.set('toggle-gutter.showGutters', false)
  }

  showContainer() {
    if (this.gutterDisposable) {
      this.subscriptions.remove(this.gutterDisposable)
      this.gutterDisposable.dispose()
    }

    for (let editor of atom.workspace.getTextEditors()) {
      atom.views.getView(editor).classList.remove('hidden-gutters')
    }

    this.containerVisible = true
    atom.config.set('toggle-gutter.showGutters', true)
  }

  toggleLineNumbers() {
      atom.commands.dispatch(atom.views.getView(atom.workspace.getActiveTextEditor()), 'editor:toggle-line-numbers')
  }
}
