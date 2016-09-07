# Show
$(".games.show").ready ->
  $(document).on "turbolinks:load", ->
    $("#startTimer").on "ajax:success", (e, data, status, xhr) ->
      updateTimer(data.round_length*60, data)
      document.getElementById('clickAudio').play()
      $("#startTimer").hide()
    $(".outButton").on "click", (event) ->
      playerid = $(this).data("playerid")
      roundid = $("#roundDisplay").data("roundid")
      $.ajax({
        type: "PATCH",
        url: "/games/#{$("#game").data("gameid")}.json",
        data: { game: { player_out: playerid, round: roundid} }
        success: (game) ->
          event.target.parentElement.innerHTML = "Out on round #{roundid+1}"
          if game.complete == true
            location.reload()
      })

updateTimer = (currentTime, game) ->
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    if currentTime == 0
      timer.innerHTML = "0:00"
      document.getElementById('marimbaAudio').play()
      incRound(game)
    else
      minutes = Math.floor(currentTime/60)
      seconds = currentTime % 60
      if seconds < 10
        seconds = "0" + seconds
      setTimeout((->
        timer.innerHTML = "#{minutes}:#{seconds}"
        updateTimer(currentTime-1, game)
      ), 1000)
  else
    console.log("no timer")

incRound = (game) ->
  $.ajax({
    type: "PATCH",
    url: "/games/#{game.id}.json",
    data: { game: { round: game.round+1 } },
    success: (game) ->
      $("#roundDisplay").data("roundid", game.round)
      document.getElementById('roundDisplay').innerHTML = "Round #{game.round+1}"
      updateBlinds(game)
      updateTimer(game.round_length*60, game)
  })

updateBlinds = (game) ->
  document.getElementById('smallBlind').innerHTML = game.blinds[game.round]
  document.getElementById('bigBlind').innerHTML = game.blinds[game.round]*2
  upcomingBlinds = game.blinds[game.round+1..game.round+4]
  upcomingBlinds = upcomingBlinds.map (blind) -> "<tr><td>#{blind}</td><td>#{blind*2}</td><tr>"
  document.getElementById('blindsTable').innerHTML = upcomingBlinds.join("")
