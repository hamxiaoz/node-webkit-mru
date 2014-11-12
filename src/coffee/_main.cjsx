_ = require 'underscore'
Fs = require 'fs'
Path = require 'path'
glob = require 'glob'
Datastore = require 'nedb'

# node-webkit
win = require('nw.gui').Window.get() 
win.maximize()

# db
dbPath = Path.join(require('nw.gui').App.dataPath, 'settings.db') 
db = new Datastore({ filename: dbPath, autoload: true })

# An open file component that with mru list
OpenFile = React.createClass
  handleInputChange: (e)->
    return if not e.target.files[0]?
    path = e.target.files[0].path
    if this.props.handleOpenFile path
      this.setState
        path: path

  handleClick: (e)->
    e.preventDefault()
    path = $(e.currentTarget).text()
    if this.props.handleOpenFile path
      this.setState
        path: path

  getInitialState: ->
    return {
      path: ''
    }

  componentDidMount: ->
    this.props.mru.subscribe =>
      this.forceUpdate()

  render: ->
    rows = []
    _.each this.props.mru.files, (f, i)=>
      rows.push <li key={i}><a tabIndex="-1" href="#" onClick={this.handleClick}>{f}</a></li>

    <div className="input-group input-group-sm">
      <div className="input-group-btn">
        <label className='btn btn-default' tabIndex="-1">
          <input
            className='hidden' 
            type="file"
            accept={this.props.fileExt}
            title={this.props.text}
            nwworkingdir={this.props.defaultDir}
            onChange={this.handleInputChange}
          />
          <b>{this.props.text}</b>
        </label>
        <button className="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu">
          {rows}
        </ul>
      </div>
      <input type="text" className="form-control" readOnly value={this.state.path}/>
    </div>

OpenFolder = React.createClass
  handleInputChange: (e)->
    return if not e.target.files[0]?
    path = e.target.files[0].path
    this.props.handleOpenFolder path

  componentDidMount: ->
    # http://stackoverflow.com/questions/21648347
    # https://github.com/facebook/react/issues/140
    this.refs.input.getDOMNode().setAttribute 'nwdirectory', true
    this.refs.input.getDOMNode().setAttribute 'nwworkingdir', this.props.defaultDir

  render: ->
    <label className='btn btn-default' tabIndex="-1">
      <input
        ref="input"
        className='hidden' 
        type="file"
        title={this.props.text}
        onChange={this.handleInputChange}
      />
      <b>{this.props.text}</b>
    </label>

App = React.createClass
  getInitialState: ->
    path: ''

  openFile: (path)->
    if not path? || not !!path || not Fs.existsSync(path)
      return false

    # remember in mru
    this.props.textFileMRU.add path

    this.setState
      path: path
    return true

  render: ->
    <div className="row">
      <div className="col-md-12">
        <OpenFile 
          text='Open text file' 
          fileExt=".text, .txt, .md"
          defaultDir="C:\\"
          handleOpenFile={this.openFile} 
          mru={this.props.textFileMRU}
        /> 
        <p>{this.state.path}</p>
      </div>
    </div>


# only show window when the form is ready
$(document).load ->
  win.show()

# render the app when the DOM is ready
$(document).ready ->
  React.renderComponent App({textFileMRU: new MRU(db, 'textFileMRU')}), document.getElementById('app-container')

