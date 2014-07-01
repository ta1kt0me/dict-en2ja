$ = require 'jquery'
http = require 'http'
{parseString} = require 'xml2js'

module.exports =
class WordEn

  constructor: (word) ->
    @word = escape(word)

  getItemId: (word) ->
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
        parseString content, (err, result) ->
          if result.SearchDicItemResult.TitleList[0] == ""
            alert('[ ' + unescape(word) + ' ] is not found in a dictionary')
            return
          itemId = result.SearchDicItemResult.TitleList[0].DicItemTitle[0].ItemID[0]
          defer.resolve itemId
    defer.promise()

  getMean: (itemId) ->
    defer = new $.Deferred
    urlPath = "/NetDicV09.asmx/GetDicItemLite?Dic=EJdict&Item=#{itemId}&Loc=&Prof=XHTML"
    http.get {
      hostname : "public.dejizo.jp",
      path : urlPath
    }, (res) ->
      res.setEncoding('utf8')
      content = ""
      res.on 'data', (chunk) ->
        content += chunk
      res.on 'end', ->
        parseString content, (err, result) ->
          meaning = result.GetDicItemResult.Body[0].div[0].div[0]
          defer.resolve meaning
    defer.promise()
