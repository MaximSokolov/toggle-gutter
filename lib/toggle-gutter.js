'use babel'

import {CompositeDisposable} from 'atom'

export default class ToggleGutter {
  constructor() {
    this.lineNumbersShowing = false
    this.guttersShowing = true

    this.lineNumbersDisposable = null
    this.gutterDisposable = null
    this.subscriptions = new CompositeDisposable()
  }

  destroy() {
    this.subscriptions.dispose()
  }

  isGuttersShowing() {
    return this.guttersShowing
  }

  toggleGutters() {
    if (this.isGuttersShowing()) {
      this.hideGutters()
    } else {
      this.showGutters()
    }
  }

  hideGutters() {
    this.gutterDisposable = atom.workspace.observeTextEditors(
      editor => atom.views.getView(editor).classList.add('hidden-gutters')
    )
    this.subscriptions.add(this.gutterDisposable)

    this.guttersShowing = false
    atom.config.set('toggle-gutter.showGutters', false)
  }

  showGutters() {
    if (this.gutterDisposable) {
      this.subscriptions.remove(this.gutterDisposable)
      this.gutterDisposable.dispose()
    }

    for (let editor of atom.workspace.getTextEditors()) {
      atom.views.getView(editor).classList.remove('hidden-gutters')
    }

    this.guttersShowing = true
    atom.config.set('toggle-gutter.showGutters', true)
  }

  isLineNumbersShowing() {
    return this.lineNumbersShowing
  }

  toggleLineNumbers() {
    if (this.isLineNumbersShowing()) {
      this.hideLineNumbers()
    } else {
      this.showLineNumbers()
    }
  }

  hideLineNumbers() {
    this.lineNumbersDisposable = atom.workspace.observeTextEditors(
      editor => atom.views.getView(editor).classList.add('hidden-line-numbers')
    )

    this.subscriptions.add(this.lineNumbersDisposable)

    this.lineNumbersShowing = false
    atom.config.set('toggle-gutter.showNumbers', false)
  }

  showLineNumbers() {
    if (this.lineNumbersDisposable) {
      this.subscriptions.remove(this.lineNumbersDisposable)
      this.lineNumbersDisposable.dispose()
    }

    for (let editor of atom.workspace.getTextEditors()) {
      atom.views.getView(editor).classList.remove('hidden-line-numbers')
    }

    this.lineNumbersShowing = true
    atom.config.set('toggle-gutter.showNumbers', true)
  }
}
