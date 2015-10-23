# Description:
#  Say something when you hear something
#
# Dependencies:
#  none
#
# Configuration:
#  none
#
# Commands:
#  hubot hear <trigger-word> say <message to say> - add something to say when hubot hears something
#  hubot list hear - list all the words hubot is hearing
#  hubot delete hear <trigger-word> - stop hearing for the given trigger word
#
# Notes:
#  Inspired by ear dropping
#
# Author:
#  jsolis

class HearSay
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.hearsay
        @cache = @robot.brain.data.hearsay
  add: (pattern, action) ->
    task = {key: pattern, task: action}
    @cache.push task
    @robot.brain.data.hearsay = @cache
  all: -> @cache
  deleteByPattern: (pattern) ->
    @cache = @cache.filter (n) -> n.key != pattern
    @robot.brain.data.hearsay = @cache
  deleteAll: () ->
    @cache = []
    @robot.brain.data.hearsay = @cache

module.exports = (robot) ->

  hearsay = new HearSay robot

  robot.respond /hear ([\w-]+) say (.+)/i, (res) ->
    hear = res.match[1]
    say = res.match[2]

    hearsay.add(hear, say)

    res.send "Added #{hear} -> #{say}"

  robot.respond /list hear/i, (res) ->
    response = ""
    for task in hearsay.all()
      response += "#{task.key} -> #{task.task}\n"
    res.send response

  robot.respond /delete hear ([\w-]+)/i, (res) ->
    hear = res.match[1]

    hearsay.deleteByPattern hear

    res.send "Deleted #{hear}"

  robot.hear /(.+)/i, (res) ->
    heard = res.match[1]

    tasks = hearsay.all()

    tasksToRun = []
    for task in tasks
      if (new RegExp(task.key, "i").test(heard) && robot.name != res.message.user.name && !(new RegExp("^#{robot.name}", "i").test(heard)))
        tasksToRun.push task

    for task in tasksToRun
      res.send task.task


