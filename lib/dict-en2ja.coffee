DictEn2jaView = require './dict-en2ja-view'
$ = require 'jquery'
http = require 'http'
{parseString} = require 'xml2js'

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
    $.Deferred(@getItemIdXML(word))
    .then (content) ->
      self.getItemId content
    .then (itemId) ->
      console.log itemId
      console.log "fugafugahogehoge"

  getItemIdXML: (word) ->
    defer = new $.Deferred
    urlParam = "/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict&Word=#{word}&Scope=HEADWORD&Match=EXACT&Merge=AND&Prof=JSON&PageSize=1&PageIndex=0"
    http.get {
      hostname : 'public.dejizo.jp',
      path : urlParam
     }, (res) ->
      res.setEncoding('utf8')
      content = ""
      res.on 'data', (chunk) ->
        content += chunk
      res.on 'end', ->
        defer.resolve content
    defer.promise

  getItemId: (content) ->
    defer = new $.Deferred
    parseString content, (err, result) ->
      itemId = result.SearchDicItemResult.TitleList[0].DicItemTitle[0].ItemID[0]
      console.log(itemId)
      defer.resolve itemId
    defer.promise
