{WorkspaceView} = require 'atom'
DictEn2ja = require '../lib/dict-en2ja'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "DictEn2ja", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('dict-en2ja')

  describe "when the dict-en2ja:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.dict-en2ja')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'dict-en2ja:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.dict-en2ja')).toExist()
        atom.workspaceView.trigger 'dict-en2ja:toggle'
        expect(atom.workspaceView.find('.dict-en2ja')).not.toExist()
