ToggleGutter = require '../lib/toggle-gutter'

describe "Toggle Gutter", ->
  [editor, toggleGutter, workspaceElement, editorElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    toggleGutter = new ToggleGutter

    waitsForPromise ->
      atom.packages.activatePackage('toggle-gutter')

  describe "::isGuttersShowing()", ->
    it "returns 'true' when gutters are shown", ->
      toggleGutter.showGutters()
      expect(toggleGutter.isGuttersShowing()).toBe(true)

    it "returns 'false' when gutters are hidden", ->
      toggleGutter.toggleGutters()
      expect(toggleGutter.isGuttersShowing()).toBe(false)

  describe "::toggleGutters()", ->
    it "hides gutter", ->
      spyOn(toggleGutter, 'toggleGutters')

      toggleGutter.showGutters()
      toggleGutter.toggleGutters()
      expect(toggleGutter.toggleGutters).toHaveBeenCalled()

    it "shows gutter", ->
      spyOn(toggleGutter, 'showGutters')

      toggleGutter.toggleGutters()
      toggleGutter.toggleGutters()
      expect(toggleGutter.showGutters).toHaveBeenCalled()

  describe "::toggleGutters()", ->
    beforeEach ->
      toggleGutter.showGutters()
      toggleGutter.toggleGutters()

    it "saves visibility state", ->
      expect(toggleGutter.isGuttersShowing()).toBe(false)

    it "adds hidden-gutter class", ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutters')).toBe(true)

  describe "::showGutters()", ->
    it "shows hidden gutters", ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        toggleGutter.toggleGutters()
        toggleGutter.showGutters()
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutters')).toBe(false)

    it "doesn't hide gutters in the new files", ->
      runs ->
        toggleGutter.toggleGutters()
        toggleGutter.showGutters()

      waitsForPromise ->
        atom.workspace.open("test.txt")

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutter')).toBe(false)

    it "saves visibility state", ->
      toggleGutter.toggleGutters()
      toggleGutter.showGutters()
      expect(toggleGutter.isGuttersShowing()).toBe(true)

  describe "::isLineNumbersShowing()", ->
    it "returns 'true' when line-numbers are shown", ->
      toggleGutter.showLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(true)

    it "returns 'false' when line-numbers are hidden", ->
      toggleGutter.hideLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(false)

  describe "::toggleLineNumbers()", ->
    it "hides line numbers", ->
      spyOn(toggleGutter, 'hideLineNumbers')

      toggleGutter.showLineNumbers()
      toggleGutter.toggleLineNumbers()
      expect(toggleGutter.hideLineNumbers).toHaveBeenCalled()

    it "shows line numbers", ->
      spyOn(toggleGutter, 'showLineNumbers')

      toggleGutter.hideLineNumbers()
      toggleGutter.toggleLineNumbers()
      expect(toggleGutter.showLineNumbers).toHaveBeenCalled()

  describe "::hideLineNumbers()", ->
    it "adds 'hidden-line-numbers' class", ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        toggleGutter.hideLineNumbers()
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(true)

    it "saves visibility state", ->
      toggleGutter.showLineNumbers()
      toggleGutter.hideLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(false)

  describe "::showLineNumbers()", ->
    it "shows line numbers", ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        toggleGutter.hideLineNumbers()
        toggleGutter.showLineNumbers()
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)

    it "saves visibility state", ->
      toggleGutter.hideLineNumbers()
      toggleGutter.showLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(true)

    it "doesn't hide line numbers in the new files", ->
      runs ->
        toggleGutter.hideLineNumbers()
        toggleGutter.showLineNumbers()

      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)
