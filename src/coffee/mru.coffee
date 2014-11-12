class MRU
  constructor: (db, name)->
    @db = db
    @name = name
    @files = []
    @onChanges = []
    @db.findOne { name: @name }, (err, doc)=>
      if doc?
        @files = doc.files
        @inform()

  subscribe: (onChange)->
    @onChanges.push onChange

  inform: ->
    @onChanges.forEach (cb)->cb()

  add: (path)->
    if _.contains @files, path
      # don't add, re-order to make the path the first one
      i = _.indexOf @files, path
      @files.splice i, 1
      @files.unshift path
    else
      @files.unshift path

    # limit to 10
    if @files.length > 10
      @files.splice @files.length-1, 1

    # update db
    @db.update { name: @name}, { $set: { files: @files }}, {upsert: true}, (err, numReplaced)=>
      @db.persistence.compactDatafile()

    @inform()



