updateTimer = (currentTime) ->
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    setTimeout((->
      timer.innerHTML = currentTime
      updateTimer(currentTime-1)
    ), 1000)
  else if timer == 0
    timer.innerHTML = 0
  else
    console.log("no time or timer")

$ ->
  $("#startTimer").on "ajax:success", (e, data, status, xhr) ->
    updateTimer(data.round_length*60)
