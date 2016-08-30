updateTimer = (currentTime) ->
  timer = document.getElementById('timer')
  if timer != null and currentTime >= 0
    if currentTime == 0
      timer.innerHTML = "0:00"
      document.getElementById('marimbaAudio').play()
      flashTimer()
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
    console.log("no timer")

flashTimer = () ->
  timer = document.getElementById('timer')
  setTimeout((->
    if timer.style.visibility == "hidden"
      timer.style.visibility = "visible"
    else
      timer.style.visibility = "hidden"
    flashTimer()
    ), 500)

String::strip = -> @replace /^\s+|\s+$/g, ""

updatePlayers = (player) ->
  unless player == ""
    tableRow = "<tr><td>#{player}</td><td></td></tr>"
    document.getElementById('players').lastChild.insertAdjacentHTML('beforeend', tableRow)

addPlayer = (player, guest = false) ->
  if guest
    param_type = "guests"
  else
    param_type = "user_ids"
  unless player == ""
    param = "<input type='hidden' name='game[#{param_type}][]' value='#{player}' />"
    document.getElementById('hiddenUsers').insertAdjacentHTML('beforeend', param)

# Show
$(document).on "turbolinks:load", ->
  $("#startTimer").on "ajax:success", (e, data, status, xhr) ->
    updateTimer(data.round_length*60)
    document.getElementById('clickAudio').play()
    $("#startTimer").hide()

# New
$(document).on "turbolinks:load", ->
  $("#userButtons").hide()
  $("#guestForm").hide()
  $("#addUser").on "click", (event) ->
    $("#userButtons").show()
    $("#addUser").hide()
    $("#addGuest").hide()
  $(".userButton").on "click", (event) ->
    addPlayer(this.id)
    updatePlayers(this.innerHTML.split(' ')[1])
    $("##{this.id}").hide()
    $("#userButtons").hide()
    $("#addGuest").show()
    if (button for button in $("#userButtons").children().children() when button.style.display != "none").length != 1
      $("#addUser").show()
  $("#userCancelButton").on "click", (event) ->
    $("#userButtons").hide()
    if (button for button in $("#userButtons").children().children() when button.style.display != "none").length != 1
      $("#addUser").show()
    $("#addGuest").show()
  $("#addGuest").on "click", (event) ->
    $("#guestForm").show()
    $("#guestInput").val("")
    $("#addUser").hide()
    $("#addGuest").hide()
  $("#guestSubmit").on "click", (event) ->
    updatePlayers name.strip() for name in $("#guestInput").val().split(",")
    addPlayer(name.strip(), guest = true) for name in $("#guestInput").val().split(",")
    $("#guestForm").hide()
    $("#addGuest").show()
    if (button for button in $("#userButtons").children().children() when button.style.display != "none").length != 1
      $("#addUser").show()
  $("#guestInput").on "keypress", (event) ->
    if event.keyCode == 13
      $("#guestSubmit").click()
      return false
