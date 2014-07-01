DictEn2jaView = require './dict-en2ja-view'
WordEn = require './word-En'
{EditorView} =require 'atom'
$ = require 'jquery'

module.exports =
  dictEn2jaView: null

  activate: (state) ->
    atom.workspaceView.command "dict-en2jp:mean", => @mean()

  deactivate: ->
    @dictEn2jaView.destroy()

  serialize: ->
    dictEn2jaViewState: @dictEn2jaView.serialize()

  mean: ->
    wordEn = new WordEn(atom.workspace.activePaneItem.getSelection().getText())
    wordEn.selectItemId(wordEn.word).then (id) ->
      wordEn.selectMean(id)
    .then (mean) ->
      editor = new EditorView(mini:true).getEditor()
      editor.insertText(mean.replace(/\t/g, "\n"))
      atom.workspace.getActivePane().splitDown().addItem editor
