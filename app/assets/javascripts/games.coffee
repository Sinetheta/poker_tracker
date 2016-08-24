updateTimer = (currentTime) ->
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    setTimeout((->
      timer.innerHTML = currentTime
      updateTimer(currentTime-1)
    ), 1000)
  else
    console.log("no time or timer")

$(document).ready ->
  time = document.getElementById('timer').innerHTML
  updateTimer(time)
