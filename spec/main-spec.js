const hasCommand = function (element, commandName) {
  for (let command of atom.commands.findCommands({target: element})) {
    if (command.name === commandName) {
      return true
    }
  }
}

describe("main", function () {
  let workspaceElement = null

  beforeEach(function () {
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise(() => atom.packages.activatePackage('toggle-gutter'))
  })

  describe("activate", () =>
    it("creates the commands", function () {
      expect(hasCommand(workspaceElement, 'toggle-gutter:gutter')).toBeTruthy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:line-numbers')).toBeTruthy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:linter-ui-default')).toBeTruthy()
    })
  )

  describe("deactivate", () =>
    it("destroys the commands", function () {
      atom.packages.deactivatePackage('toggle-gutter')
      expect(hasCommand(workspaceElement, 'toggle-gutter:gutter')).toBeFalsy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:line-numbers')).toBeFalsy()
      expect(hasCommand(workspaceElement, 'toggle-gutter:linter-ui-default')).toBeFalsy()
    })
  )
})
