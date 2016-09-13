# Show
$(document).on "turbolinks:load", ->
  $(".games.show").ready ->
    $.ajax({
      type: "GET",
      url: "/games/#{$("#game").data("gameid")}.json",
      success: (game) ->
        window.game = game
    })
    $("#pauseTimer").hide()
    $("#pauseTimer").on "click", (event) ->
      pauseTimer(window.timer)
    $("#startTimer").on "click", (event) ->
      $("#pauseTimer").show()
      updateTimer(window.game.round_length*60)
      document.getElementById('clickAudio').play()
      $("#startTimer").hide()
    $("#nextRound").on "click", (event) ->
      if window.timer
        clearTimeout(window.timer)
        window.timer
        $("#pauseTimer").html("Pause Timer")
      incRound()
    $(".outButton").on "click", (event) ->
      playerid = $(this).data("playerid")
      roundid = $("#roundDisplay").data("roundid")
      $.ajax({
        type: "PATCH",
        url: "/games/#{$("#game").data("gameid")}.json",
        data: { game: { player_out: playerid, round: roundid} }
        success: (game) ->
          window.game = game
          event.target.parentElement.innerHTML = "Out on round #{game.round+1}"
          if game.complete == true
            location.reload()
      })

pauseTimer = ()->
  if window.timer
    clearTimeout(window.timer)
    window.timer = null
    $("#pauseTimer").html("Resume Timer")
  else
    updateTimer($("#timer").data("currentTime"))
    $("#pauseTimer").html("Pause Timer")

updateTimer = (currentTime) ->
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    if currentTime == 0
      timer.innerHTML = "0:00"
      document.getElementById('marimbaAudio').play()
      incRound()
    else
      $("#timer").data("currentTime", currentTime)
      minutes = Math.floor(currentTime/60)
      seconds = currentTime % 60
      if seconds < 10
        seconds = "0" + seconds
      window.timer = setTimeout((->
        timer.innerHTML = "#{minutes}:#{seconds}"
        updateTimer(currentTime-1, game)
      ), 1000)
  else
    console.log("no timer")

incRound = () ->
  $.ajax({
    type: "PATCH",
    url: "/games/#{window.game.id}.json",
    data: { game: { round: window.game.round+1 } },
    success: (game) ->
      window.game = game
      $("#roundDisplay").data("roundid", game.round)
      document.getElementById('roundDisplay').innerHTML = "Round #{game.round+1}"
      updateBlinds(game)
      updateTimer(game.round_length*60)
  })

updateBlinds = (game) ->
  document.getElementById('smallBlind').innerHTML = game.blinds[game.round]
  document.getElementById('bigBlind').innerHTML = game.blinds[game.round]*2
  upcomingBlinds = game.blinds[game.round+1..game.round+4]
  upcomingBlinds = upcomingBlinds.map (blind) -> "<tr><td>#{blind}</td><td>#{blind*2}</td><tr>"
  document.getElementById('blindsTable').innerHTML = upcomingBlinds.join("")
