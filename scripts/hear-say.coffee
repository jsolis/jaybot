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

module.exports = (robot) ->

  robot.respond /hear ([\w-]+) say (.+)/i, (res) ->
    hear = res.match[1]
    say = res.match[2]

    res.send "Added #{hear} -> #{say}"

  robot.respond /list hear/i, (res) ->
    res.send "list to go here"

  robot.respond /delete hear ([\w-]+)/i, (res) ->
    hear = res.match[1]

    res.send "Deleted #{hear}"

  robot.hear /(.+)/i, (res) ->
    heard = res.match[1]

    if (robot.name != res.message.user.name && !(new RegExp("^#{robot.name}", "i").test(heard)))
      res.send "TODO - process #{heard}"
