hasCommand = (element, commandName) ->
  return true for command in atom.commands.findCommands(target: element) when command.name is commandName

describe "main", ->
  [workspaceElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('toggle-gutter')

  describe "activate", ->
    it "creates the commands", ->
      expect(hasCommand(workspaceElement, 'toggle-gutter:gutter')).toBeTruthy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:line-numbers')).toBeTruthy()

  describe "deactivate", ->
    it "destroys the commands", ->
      atom.packages.deactivatePackage('toggle-gutter')
      expect(hasCommand(workspaceElement, 'toggle-gutter:gutter')).toBeFalsy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:line-numbers')).toBeFalsy()
