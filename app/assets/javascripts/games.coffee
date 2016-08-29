updateTimer = (currentTime) ->
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    if currentTime == 0
      timer.innerHTML = "0:00"
      setTimeout((->
        if timer.style.visibility == "hidden"
          timer.style.visibility = "visible"
        else
          timer.style.visibility = "hidden"
        updateTimer(0)
        ), 500)
    else
      minutes = Math.floor(currentTime/60)
      seconds = currentTime % 60
      if seconds < 10
        seconds = "0" + seconds
      setTimeout((->
        timer.innerHTML = "#{minutes}:#{seconds}"
        updateTimer(currentTime-1)
      ), 1000)
  else
    console.log("no time or timer")

$(document).on "turbolinks:load", ->
  $("#startTimer").on "ajax:success", (e, data, status, xhr) ->
    updateTimer(data.round_length*60)
  winnerSubmission = document.getElementById('winnerSubmission')
  if winnerSubmission
    winnerSubmission.style.display = "none"
  $("#declareWinner").on "click", (event) ->
    winnerSubmission = document.getElementById('winnerSubmission')
    if winnerSubmission.style.display == "block"
      winnerSubmission.style.display = "none"
    else
      winnerSubmission.style.display = "block"

$(document).on "turbolinks:load", ->
  $("#userButtons").hide()
  $("#addUser").on "click", (event) ->
    $("#userButtons").show()
    $("#addUser").hide()
  $(".userButton").on "click", (event) ->
    input = "<input type='hidden' name='game[user_ids][]' value='#{this.id}' />"
    console.log(this.id)
    document.getElementById('hiddenUsers').insertAdjacentHTML('beforeend', input)
    $("#userButtons").hide()
    $("#addUser").show()
