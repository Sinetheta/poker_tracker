# Show
$(".games.show").ready ->
  $(document).on "turbolinks:load", ->
    $("#startTimer").on "ajax:success", (e, data, status, xhr) ->
      updateTimer(data.round_length*60, data)
      document.getElementById('clickAudio').play()
      $("#startTimer").hide()
    $(".userOutButton").on "ajax:success", (e, data, status, xhr) ->
      userid = $(this).attr('playerid')
      gameid = data.id
      round = data.round
      $.ajax({
        type: "PATCH",
        url: "/games/#{gameid}.json",
        data: { game: { users_out: { "#{userid}": round } } }
        success: (data) ->
          document.getElementById("userOutButtonCell#{userid}").innerHTML = "Out on round #{parseInt(round)+1}"
          if data.winner_id != null
            location.reload()
      })
    $(".guestOutButton").on "ajax:success", (e, data, status, xhr) ->
      userid = $(this).attr('playerid')
      gameid = data.id
      round = data.round
      $.ajax({
        type: "PATCH",
        url: "/games/#{gameid}.json",
        data: { game: { guests_out: { "#{userid}": round } } }
        success: (data) ->
          document.getElementById("guestOutButtonCell#{userid}").innerHTML = "Out on round #{parseInt(round)+1}"
          if data.winner_id != null
            location.reload()
      })

updateTimer = (currentTime, game) ->
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    if currentTime == 0
      timer.innerHTML = "0:00"
      document.getElementById('marimbaAudio').play()
      updateRound(game)
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

updateRound = (game) ->
  $.ajax({
    type: "PATCH",
    url: "/games/#{game.id}.json",
    data: { game: { round: game.round+1 } },
    success: (data) ->
      document.getElementById('roundDisplay').innerHTML = "Round #{data.round+1}"
      updateBlinds(data)
      updateTimer(data.round_length*60, data)
  })

updateBlinds = (game) ->
  document.getElementById('smallBlind').innerHTML = game.blinds[game.round]
  document.getElementById('bigBlind').innerHTML = game.blinds[game.round]*2
  upcomingBlinds = game.blinds[game.round+1..game.round+4]
  upcomingBlinds = upcomingBlinds.map (blind) -> "<tr><td>#{blind}</td><td>#{blind*2}</td><tr>"
  document.getElementById('blindsTable').innerHTML = upcomingBlinds.join("")
