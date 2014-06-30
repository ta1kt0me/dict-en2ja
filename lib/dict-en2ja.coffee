DictEn2jaView = require './dict-en2ja-view'
$ = require 'jquery'
http = require 'http'
{parseString} = require 'xml2js'
{EditorView} =require 'atom'

module.exports =
  dictEn2jaView: null

  activate: (state) ->
    # @dictEn2jaView = new DictEn2jaView(state.dictEn2jaViewState)
    atom.workspaceView.command "dict-en2jp:search", => @search()

  deactivate: ->
    @dictEn2jaView.destroy()

  serialize: ->
    dictEn2jaViewState: @dictEn2jaView.serialize()

  search: ->
    word = atom.workspace.activePaneItem.getSelection().getText()
    self = this
    console.log("start")
    @getItemIdXML(word).then (content) ->
      console.log(content)
      self.getItemId content
    .then (itemId) ->
      console.log itemId
      self.getMeaningContent itemId
    .then (content) ->
      console.log content
      self.getMeaning content
    .then (meaning) ->
      console.log meaning
      miniEditorView = new EditorView(mini:true)
      console.dir miniEditorView
      editor = miniEditorView.getEditor()
      editor.insertText(meaning)
      pane = atom.workspace.getActivePane().splitRight()
      pane.addItem editor
    console.log("end")

  getItemIdXML: (word) ->
    console.log("start getItemIdXML")
    defer = new $.Deferred
    urlPath = "/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict&Word=#{word}&Scope=HEADWORD&Match=EXACT&Merge=AND&Prof=JSON&PageSize=1&PageIndex=0"
    http.get {
      hostname : 'public.dejizo.jp',
      path : urlPath
     }, (res) ->
      res.setEncoding('utf8')
      content = ""
      res.on 'data', (chunk) ->
        content += chunk
      res.on 'end', ->
        defer.resolve content
    defer.promise()

  getItemId: (content) ->
    console.log "start getItemId"
    console.log(content)
    defer = new $.Deferred
    parseString content, (err, result) ->
      itemId = result.SearchDicItemResult.TitleList[0].DicItemTitle[0].ItemID[0]
      console.log(itemId)
      defer.resolve itemId
    defer.promise()

  getMeaningContent: (itemId) ->
    console.log(itemId)
    defer = new $.Deferred
    urlPath = "/NetDicV09.asmx/GetDicItemLite?Dic=EJdict&Item=#{itemId}&Loc=&Prof=XHTML"
    http.get {
      hostname : "public.dejizo.jp",
      path : urlPath
    }, (res) ->
      console.log res
      res.setEncoding('utf8')
      content = ""
      res.on 'data', (chunk) ->
        content += chunk
      res.on 'end', ->
        console.log content
        defer.resolve content
    defer.promise()

  getMeaning: (content) ->
    console.log "start meaning"
    console.log(content)
    defer = new $.Deferred
    parseString content, (err, result) ->
      meaning = result.GetDicItemResult.Body[0].div[0].div[0]
      defer.resolve meaning
    defer.promise()
