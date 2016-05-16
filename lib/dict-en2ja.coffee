DictEn2jaView = require './dict-en2ja-view'
WordEn = require './word-En'
{TextEditorView} =require 'atom-space-pen-views'
$ = require 'jquery'

module.exports =
  dictEn2jaView: null

  activate: (state) ->
    atom.commands.add 'atom-text-editor', 'dict-en2ja:mean', => @mean()

  deactivate: ->
    @dictEn2jaView.destroy()

  mean: ->
    wordEn = new WordEn(atom.workspace.getActivePaneItem().getSelections()[0].getText())
    wordEn.getItemMean().then (mean) ->
      editor = new TextEditorView(mini:true).getModel()
      editor.insertText(mean.replace(/\t/g, "\n"))
      atom.workspace.getActivePane().splitDown().addItem editor
