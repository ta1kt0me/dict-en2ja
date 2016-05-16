WordEn = require './word-En'
{TextEditorView} =require 'atom-space-pen-views'

module.exports =

  activate: (state) ->
    atom.commands.add 'atom-text-editor', 'dict-en2ja:mean', => @mean()

  deactivate: ->

  mean: ->
    wordEn = new WordEn(atom.workspace.getActivePaneItem().getSelectedText())
    wordEn.getItemMean().then (mean) ->
      editor = new TextEditorView(mini:true).getModel()
      editor.insertText(mean.replace(/\t/g, "\n"))
      atom.workspace.getActivePane().splitDown().addItem editor
