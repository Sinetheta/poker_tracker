updateTimer = (currentTime) ->
  console.log(currentTime)
  minutes = Math.floor(currentTime/60)
  seconds = currentTime % 60
  seconds = "00" if seconds == 0
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    setTimeout((->
      timer.innerHTML = "#{minutes}:#{seconds}"
      updateTimer(currentTime-1)
    ), 1000)
  else if timer == 0
    timer.innerHTML = 0
  else
    console.log("no time or timer")

$(document).on "turbolinks:load", ->
  $("#startTimer").on "ajax:success", (e, data, status, xhr) ->
    updateTimer(data.round_length*60)
