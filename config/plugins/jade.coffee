module.exports = (lineman) ->
  files:
    jade:
      templates: "app/templates/**/*.jade"
      generatedTemplate: "generated/template/jade.js"
      pages: "**/*.jade"
      pageRoot: "app/pages/"
    template:
      jade: "app/templates/**/*.jade"
      generatedJade: "generated/template/jade.js"
    pages:
      source: lineman.config.files.pages.source.concat("!<%= files.jade.pageRoot %>/<%= files.jade.pages %>")

  config:
    loadNpmTasks: lineman.config.application.loadNpmTasks.concat('grunt-contrib-jade')

    prependTasks:
      common: ["jade:templates"].concat(lineman.config.application.prependTasks.common)
      dev: lineman.config.application.prependTasks.common.concat("jade:pagesDev")
      dist: lineman.config.application.prependTasks.common.concat("jade:pagesDist")

    jade:
      templates:
        options:
          client: true
        files:
          "<%= files.jade.generatedTemplate %>": "<%= files.jade.templates %>"
      pagesDev:
        options:
          pretty: true
          data:
            js: "js/app.js"
            css: "css/app.css"
            pkg: "<%= pkg %>"
        files: [{
          expand: true
          src: "<%= files.jade.pages %>"
          cwd: "<%= files.jade.pageRoot %>"
          dest: "generated/"
          ext: ".html"
        }]
      pagesDist:
        options:
          data:
            js: "js/app.js"
            css: "css/app.css"
            pkg: "<%= pkg %>"
        files: [{
          expand: true
          src: "<%= files.jade.pages %>"
          cwd: "<%= files.jade.pageRoot %>"
          dest: "dist/"
          ext: ".html"
        }]

    watch:
      jadePages:
        files: ["<%= files.jade.pageRoot %><%= files.jade.pages %>", "<%= files.jade.templates %>"]
        tasks: ["jade:pagesDev"]
      jadeTemplates:
        files: "<%= files.jade.templates %>"
        tasks: ["jade:templates", "concat_sourcemap:js"]