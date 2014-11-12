# bought from https://github.com/fbrusch/angular-jade-coffee
module.exports = (grunt) ->

  grunt.initConfig(
    pkg:
      grunt.file.readJSON('package.json')

    less:
      glob_to_multiple:
        expand: true
        cwd: './src/less/'
        src: ['*.less']
        dest: 'css/'
        ext: '.css'

    jade:
      options:
        pretty: true
      compile_index:
        files:
          "./index.html": ["./src/index.jade"]
      glob_to_multiple:
        expand: true
        cwd: './src/views'
        src: ['*.jade']
        dest: './views'
        ext: '.html'

    cjsx:
      compileJoined:
        options:
          bare: true
        files: 
          'tmp/coffee.js': 'tmp/for-cjsx.cjsx'

    concat:
      for_cjsx:
        nonull: true
        src: [
          'src/coffee/*.cjsx'
          'src/coffee/*.coffee'
        ]
        dest: 'tmp/for-cjsx.cjsx'

      create_app_css:
        nonull: true
        src: [
          'bower_components/bootstrap-css/css/bootstrap.min.css',
          'bower_components/font-awesome/css/font-awesome.min.css',
          'src/css/style.css'
        ]
        dest: 'css/app.css'

      create_app_js:
        nonull: true
        src: [
          "bower_components/jquery/jquery.js",
          "bower_components/bootstrap-css/js/bootstrap.js",
          "bower_components/react/react-with-addons.js",
          "tmp/coffee.js"
        ]
        dest: 'js/app.js'
  )

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  # grunt.loadNpmTasks "grunt-contrib-less"
  # grunt.loadNpmTasks "grunt-contrib-livereload"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks 'grunt-coffee-react'

  grunt.registerTask "default", ["jade", "concat:for_cjsx", "cjsx", "concat"]
