# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "DictEn2ja", ->
  [workspaceElement, editor, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('dict-en2ja')

  describe "when the dict-en2ja:mean event is triggered", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open().then (e) ->
          editor = e
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      editor.setText('bar')
      editor.setCursorBufferPosition([0, 0])
      editor.selectToEndOfLine()

      expect(workspaceElement.querySelector('.editor.mini')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'dict-en2ja:mean'

      waitsForPromise ->
        activationPromise

      waitsFor -> workspaceElement.querySelector('.editor.mini')

      runs ->
        resultElement = workspaceElement.querySelector('.editor.mini')
        expect(resultElement).toExist()
