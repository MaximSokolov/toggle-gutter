HideGutter = require '../lib/main'

hasCommand = (element, commandName) ->
  return true for command in atom.commands.findCommands(target: element) when command.name is commandName

describe 'Toggle Gutter', ->
  [editor, workspaceElement, editorElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('toggle-gutter')

  describe 'activate', ->
    it 'creates the commands', ->
      expect(hasCommand(workspaceElement, 'toggle-gutter:gutter')).toBeTruthy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:line-numbers')).toBeTruthy()

  describe 'deactivate', ->
    it 'destroys the commands', ->
      atom.packages.deactivatePackage('toggle-gutter')
      expect(hasCommand(workspaceElement, 'toggle-gutter:gutter')).toBeFalsy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:line-numbers')).toBeFalsy()

    it 'does not add "hidden-gutter" class to new files', ->
      runs ->
        HideGutter.hideGutter()
        atom.packages.deactivatePackage('toggle-gutter')

      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutter')).toBeFalsy()

    it 'does not add "hidden-line-numbers" class to new files', ->
      runs ->
        HideGutter.hideLineNumbers()
        atom.packages.deactivatePackage('toggle-gutter')

      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBeFalsy()

  describe '::isGutterShowing()', ->
    it 'mast be true', ->
      HideGutter.showGutter()
      expect(HideGutter.isGutterShowing()).toBe(true)

    it 'mast be false', ->
      HideGutter.hideGutter()
      expect(HideGutter.isGutterShowing()).toBe(false)

  describe '::hideGutter()', ->
    beforeEach ->
      HideGutter.showGutter()
      HideGutter.hideGutter()

    it 'saves visibility state', ->
      expect(HideGutter.isGutterShowing()).toBe(false)

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
        HideGutter.hideGutter()
        HideGutter.showGutter()
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutter')).toBe(false)

    it 'does not add "hidden-gutter" class to new files', ->
      runs ->
        HideGutter.hideGutter()
        HideGutter.showGutter()

      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-gutter')).toBe(false)

    it 'saves visibility state', ->
      HideGutter.hideGutter()
      HideGutter.showGutter()
      expect(HideGutter.isGutterShowing()).toBe(true)

  describe '::hideLineNumbers()', ->
    it 'adds "hidden-line-numbers" class', ->
      waitsForPromise ->
        atom.workspace.open('test.txt')
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        HideGutter.hideLineNumbers()
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(true)

  describe '::showLineNumbers()', ->
    it 'removes hidden-gutter class', ->
      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        HideGutter.hideLineNumbers()
        HideGutter.showLineNumbers()
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)

    it 'does not add class hidden-gutter in new files', ->
      runs ->
        HideGutter.hideLineNumbers()
        HideGutter.showLineNumbers()

      waitsForPromise ->
        atom.workspace.open('test.txt')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)
