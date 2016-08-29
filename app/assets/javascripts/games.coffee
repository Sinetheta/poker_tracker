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

String::strip = -> @replace /^\s+|\s+$/g, ""

updatePlayers = (player) ->
  tableRow = "<tr><td>#{player}</td><td></td></tr>"
  document.getElementById('players').insertAdjacentHTML('beforeend', tableRow)

addPlayer = (player, guest = false) ->
  if guest
    param_type = "guests"
  else
    param_type = "user_ids"
  param = "<input type='hidden' name='game[#{param_type}][]' value='#{player}' />"
  document.getElementById('hiddenUsers').insertAdjacentHTML('beforeend', param)

# Show
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

# New
$(document).on "turbolinks:load", ->
  $("#userButtons").hide()
  $("#guestForm").hide()
  $("#addUser").on "click", (event) ->
    $("#userButtons").show()
    $("#addUser").hide()
  $(".userButton").on "click", (event) ->
    addPlayer(this.id)
    updatePlayers(this.innerHTML.split(' ')[1])
    $("##{this.id}").hide()
    $("#userButtons").hide()
    $("#addUser").show()
  $("#userCancelButton").on "click", (event) ->
    $("#userButtons").hide()
    $("#addUser").show()
  $("#addGuest").on "click", (event) ->
    $("#guestForm").show()
    $("#guestInput").val("")
    $("#addGuest").hide()
  $("#guestSubmit").on "click", (event) ->
    updatePlayers name.strip() for name in $("#guestInput").val().split(",")
    addPlayer(name.strip(), guest = true) for name in $("#guestInput").val().split(",")
    $("#guestForm").hide()
    $("#addGuest").show()
  $("#guestInput").on "keypress", (event) ->
    if event.keyCode == 13
      $("#guestSubmit").click()
      return false
