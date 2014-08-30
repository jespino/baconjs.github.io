#!/usr/bin/env coffee

fs = require "fs"
mustache = require "mustache"
_ = require "lodash"

readmeSrc = require "../bacon.js/readme-src"
generateApi = require "./generateApi"

pageTemplate = fs.readFileSync("inc/page.html").toString()

env = if process.argv[2] == "dev"
  fonts: "http://fonts.googleapis.com/css?family=Yanone+Kaffeesatz"
  jquery: "http://codeorigin.jquery.com/jquery-2.1.1.min.js"
  baconjs: "../bacon.js/dist/bacon.js"
  version: "DEV"
else
  fonts: "//fonts.googleapis.com/css?family=Yanone+Kaffeesatz"
  jquery: "//codeorigin.jquery.com/jquery-2.1.1.min.js"
  baconjs: "//cdnjs.cloudflare.com/ajax/libs/bacon.js/0.7.22/Bacon.min.js"
  version: "0.7.22"

console.dir env

pages = [
  output: "index.html"
  title: "Bacon.js - Functional Reactive Programming library for JavaScript"
,
  output: "api.html"
  title: "Bacon.js - API reference"
  content: generateApi readmeSrc
]

# Render pages
pages.forEach (page) ->
  content = page.content || fs.readFileSync("inc/" + page.output).toString()
  data = _.extend {}, env,
    AUTOGENDISCLAIMER: "<!-- This file is generated by coffee generate.coffee, check inc/ directory for templates -->"
    title: page.title
    content: content
  html = mustache.render pageTemplate, data

  fs.writeFileSync page.output, html
