module.exports = (grunt) ->

  pkg = grunt.file.readJSON 'package.json'
  shell = require 'shelljs'

  grunt.initConfig
    connect:
      server:
        options:
          port: 4444
          base: '.'

    # coffee:
    #   compileWithMaps:
    #     options:
    #       sourceMap: true
    #     files:
    #       'lib/game/main.js': [
    #         'src/game/main.coffee'
    #       ]

    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src/'
          src: ['**/*.coffee']
          dest: 'lib/'
          ext: '.js'
        ]

    watch:
      coffee:
        files: "src/game/**/*.coffee",
        tasks: ["coffee"]

    concat:
      vendor:
        src: [
          "bower_components/_module_.js/_module_.js"
          "bower_components/handlebars/handlebars.js"
          "bower_components/lodash/lodash.js"
        ]
        dest: "public/vendor.js"

    pkg: grunt.file.readJSON 'package.json'
    shell:
      bake:
        command: 'cd tools/ && ./bake.sh && cd .. && mv game.min.js <%= pkg.name %>.min.js'
      cocoon:
        command: 'zip <%= pkg.name %>.zip -r * -x "*.DS_Store" && adb push <%= pkg.name %>.zip /sdcard/<%= pkg.name %>.zip'
        options:
          stdout: true
      deploy:
        command: 'rsync -avz --exclude-from "<%= pkg.excludesFile %>" $PWD <%= pkg.deployUser %>@<%= pkg.deployServer %>:<%= pkg.deployDirectory %>'
        options:
          stdout: true
      expose:
        command: 'sed -i s/^ig./window.ig./g <%= pkg.name %>.min.js'
    uglify:
      options:
        banner: '/*! <%= pkg.name %>.min.js <%= grunt.template.today("dd-mm-yyyy") %> */\n'
      build:
        src: '<%= pkg.name %>.min.js',
        dest: '<%= pkg.name %>.min.js'

  grunt.registerTask "run", ["coffee","concat", "connect", "watch"]
  #grunt.registerTask "build", ["coffee","concat"]

  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask('default', ['shell:bake', 'uglify'])
  grunt.registerTask('bake', ['shell:bake'])
  grunt.registerTask('build', ['shell:bake', 'uglify'])
  grunt.registerTask('cocoon', ['shell:cocoon'])
  grunt.registerTask('deploy', ['shell:deploy'])
  grunt.registerTask('expose', ['shell:expose'])
