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
    editor = atom.workspace.getActivePaneItem()
    word = editor.getSelectedText()
    word = editor.getWordUnderCursor() if word is ''
    wordEn = new WordEn(word)
    wordEn.getItemMean().then (mean) ->
      editor = new TextEditorView(mini:true).getModel()
      editor.insertText(mean.replace(/\t/g, "\n"))
      atom.workspace.getActivePane().splitDown().addItem editor
