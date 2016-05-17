WordEn = require './word-En'
{TextEditorView} =require 'atom-space-pen-views'
{CompositeDisposable} =require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable()
    @subscriptions.add atom.commands.add('atom-workspace', 'dict-en2ja:mean': =>
      @mean()
    )

  deactivate: ->

  mean: ->
    wordEn = new WordEn(atom.workspace.getActivePaneItem().getSelectedText())
    wordEn.getItemMean().then (mean) ->
      editor = new TextEditorView(mini:true).getModel()
      editor.insertText(mean.replace(/\t/g, "\n"))
      atom.workspace.getActivePane().splitDown().addItem editor
