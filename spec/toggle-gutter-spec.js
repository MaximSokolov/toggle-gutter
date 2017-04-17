'use babel'

import ToggleGutter from '../lib/toggle-gutter'

describe("Toggle Gutter", function () {
  let editor = null
  let toggleGutter = null
  let editorElement = null

  beforeEach(function () {
    toggleGutter = new ToggleGutter

    waitsForPromise(() => atom.packages.activatePackage('toggle-gutter'))
  })

  describe("::isGutterShowing()", function () {
    it("returns 'true' when the given gutter is shown", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        let gutterName = 'test-gutter'
        let editor = atom.workspace.getActiveTextEditor()
        editor.addGutter({name: gutterName})

        toggleGutter.showGutter(gutterName)
        expect(toggleGutter.isGutterShowing(gutterName)).toBe(true)
      })
    })

    it("returns 'false' when the gutter is hidden", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        let gutterName = 'test-gutter'
        let editor = atom.workspace.getActiveTextEditor()
        editor.addGutter({name: gutterName})

        toggleGutter.hideGutter(gutterName)
        expect(toggleGutter.isGutterShowing(gutterName)).toBe(false)
      })
    })
  })

  describe("::toggleGutter()", function () {
    it("it hides the given gutter", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        let gutterName = 'test-gutter'
        let editor = atom.workspace.getActiveTextEditor()
        let gutter = editor.addGutter({name: gutterName})

        toggleGutter.showGutter(gutterName)
        expect(gutter.isVisible()).toBe(true)
        toggleGutter.toggleGutter(gutterName)
        expect(gutter.isVisible()).toBe(false)
      })
    })

    it("it shows the given gutter", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        let gutterName = 'test-gutter'
        let editor = atom.workspace.getActiveTextEditor()
        let gutter = editor.addGutter({name: gutterName})

        toggleGutter.hideGutter(gutterName)
        expect(gutter.isVisible()).toBe(false)
        toggleGutter.toggleGutter(gutterName)
        expect(gutter.isVisible()).toBe(true)
      })
    })

    it("it does nothing when the given gutter doesn't exist", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(() => expect(() => toggleGutter.toggleGutter('doesntExist')).not.toThrow())
    })
  })

  describe("::isGuttersShowing()", function () {
    it("returns 'true' when gutters are shown", function () {
      toggleGutter.showGutters()
      expect(toggleGutter.isGuttersShowing()).toBe(true)
    })

    it("returns 'false' when gutters are hidden", function () {
      toggleGutter.hideGutters()
      expect(toggleGutter.isGuttersShowing()).toBe(false)
    })
  })

  describe("::toggleGutters()", function () {
    it("hides gutter", function () {
      spyOn(toggleGutter, 'hideGutters')

      toggleGutter.showGutters()
      toggleGutter.toggleGutters()
      expect(toggleGutter.hideGutters).toHaveBeenCalled()
    })

    it("shows gutter", function () {
      spyOn(toggleGutter, 'showGutters')

      toggleGutter.hideGutters()
      toggleGutter.toggleGutters()
      expect(toggleGutter.showGutters).toHaveBeenCalled()
    })

    it("saves visibility state", function () {
      toggleGutter.showGutters()
      toggleGutter.toggleGutters()
      expect(toggleGutter.isGuttersShowing()).toBe(false)
    })

    it("adds `hidden-gutter` class", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)

        toggleGutter.showGutters()
        toggleGutter.toggleGutters()
        expect(editorElement.classList.contains('hidden-gutters')).toBe(true)
      })
    })
  })

  describe("::showGutters()", function () {
    it("shows hidden gutters", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)

        toggleGutter.hideGutters()
        toggleGutter.showGutters()
        expect(editorElement.classList.contains('hidden-gutters')).toBe(false)
      })
    })

    it("saves visibility state", function () {
      toggleGutter.hideGutters()
      toggleGutter.showGutters()
      expect(toggleGutter.isGuttersShowing()).toBe(true)
    })
  })

  describe("::isLineNumbersShowing()", function () {
    it("returns 'true' when line-numbers are shown", function () {
      toggleGutter.showLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(true)
    })

    it("returns 'false' when line-numbers are hidden", function () {
      toggleGutter.hideLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(false)
    })
  })

  describe("::toggleLineNumbers()", function () {
    it("hides line numbers", function () {
      spyOn(toggleGutter, 'hideLineNumbers')

      toggleGutter.showLineNumbers()
      toggleGutter.toggleLineNumbers()
      expect(toggleGutter.hideLineNumbers).toHaveBeenCalled()
    })

    it("shows line numbers", function () {
      spyOn(toggleGutter, 'showLineNumbers')

      toggleGutter.hideLineNumbers()
      toggleGutter.toggleLineNumbers()
      expect(toggleGutter.showLineNumbers).toHaveBeenCalled()
    })
  })

  describe("::hideLineNumbers()", function () {
    it("adds `hidden-line-numbers` class", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)

        toggleGutter.showLineNumbers()
        toggleGutter.hideLineNumbers()
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(true)
      })
    })

    it("saves visibility state", function () {
      toggleGutter.showLineNumbers()
      toggleGutter.hideLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(false)
    })

    it("hides line numbers in the new files", function () {
      runs(() => toggleGutter.hideLineNumbers())

      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(true)
      })
    })
  })

  describe("::showLineNumbers()", function () {
    it("shows line numbers", function () {
      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)

        toggleGutter.hideLineNumbers()
        toggleGutter.showLineNumbers()
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)
      })
    })

    it("saves visibility state", function () {
      toggleGutter.hideLineNumbers()
      toggleGutter.showLineNumbers()
      expect(toggleGutter.isLineNumbersShowing()).toBe(true)
    })

    it("doesn't hide line numbers in the new files", function () {
      runs(() => toggleGutter.showLineNumbers())

      waitsForPromise(() => atom.workspace.open('test.txt'))

      runs(function () {
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
        expect(editorElement.classList.contains('hidden-line-numbers')).toBe(false)
      })
    })
  })
})
