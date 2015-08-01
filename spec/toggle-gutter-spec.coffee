ToggleGutter = require '../lib/toggle-gutter'

describe 'Toggle Gutter', ->
  [editor, toggleGutter, workspaceElement, editorElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    toggleGutter = new ToggleGutter

    waitsForPromise ->
      atom.packages.activatePackage('toggle-gutter')

  describe '::isGutterShowing()', ->
    it 'mast be true', ->
      toggleGutter.showGutter()
      expect(toggleGutter.isGutterShowing()).toBe(true)

    it 'mast be false', ->
      toggleGutter.toggleGutter()
      expect(toggleGutter.isGutterShowing()).toBe(false)

  describe '::toggleGutter()', ->
    it 'hides gutter', ->
      spyOn(toggleGutter, 'toggleGutter')

      toggleGutter.showGutter()
      toggleGutter.toggleGutter()
      expect(toggleGutter.toggleGutter).toHaveBeenCalled()

    it 'shows gutter', ->
      spyOn(toggleGutter, 'showGutter')

      toggleGutter.toggleGutter()
      toggleGutter.toggleGutter()
      expect(toggleGutter.showGutter).toHaveBeenCalled()

  describe '::toggleGutter()', ->
    beforeEach ->
      toggleGutter.showGutter()
      toggleGutter.toggleGutter()

    it 'saves visibility state', ->
      expect(toggleGutter.isGutterShowing()).toBe(false)

    it 'adds hidden-gutter class', ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutter')).toBe(true)

  describe '::showGutter()', ->
    it 'removes "hidden-gutter" class', ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        toggleGutter.toggleGutter()
        toggleGutter.showGutter()
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutter')).toBe(false)

    it 'does not add "hidden-gutter" class to new files', ->
      runs ->
        toggleGutter.toggleGutter()
        toggleGutter.showGutter()

      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutter')).toBe(false)

    it 'saves visibility state', ->
      toggleGutter.toggleGutter()
      toggleGutter.showGutter()
      expect(toggleGutter.isGutterShowing()).toBe(true)

  describe '::isLineNumbersShowing()', ->
    it 'mast be true', ->
      toggleGutter.showLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(true)

    it 'mast be false', ->
      toggleGutter.hideLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(false)

  describe '::toggleLineNumbers()', ->
    it 'hides line numbers', ->
      spyOn(toggleGutter, 'hideLineNumbers')

      toggleGutter.showLineNumbers()
      toggleGutter.toggleLineNumbers()
      expect(toggleGutter.hideLineNumbers).toHaveBeenCalled()

    it 'shows line numbers', ->
      spyOn(toggleGutter, 'showLineNumbers')

      toggleGutter.hideLineNumbers()
      toggleGutter.toggleLineNumbers()
      expect(toggleGutter.showLineNumbers).toHaveBeenCalled()

  describe '::hideLineNumbers()', ->
    it 'adds "hidden-line-numbers" class', ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        toggleGutter.hideLineNumbers()
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(true)

    it 'saves visibility state', ->
      toggleGutter.showLineNumbers()
      toggleGutter.hideLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(false)

  describe '::showLineNumbers()', ->
    it 'removes hidden-gutter class', ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        toggleGutter.hideLineNumbers()
        toggleGutter.showLineNumbers()
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)

    it 'saves visibility state', ->
      toggleGutter.hideLineNumbers()
      toggleGutter.showLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(true)

    it 'does not add class hidden-gutter to new files', ->
      runs ->
        toggleGutter.hideLineNumbers()
        toggleGutter.showLineNumbers()

      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        console.log toggleGutter.isLineNumbersShowing()
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)
