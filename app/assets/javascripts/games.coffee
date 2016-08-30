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

updatePlayers = (player, user = null) ->
  if user
    button = "<button class='btn btn-danger removeUser' id='removeUser#{user}'>Remove</button>"
    trid = "usertr#{user}"
  else
    button = "<button class='btn btn-danger removeGuest' id='removeGuest#{player}'>Remove</button>"
    trid = "guesttr#{player}"
  unless player == ""
    tableRow = "<tr id='#{trid}'><td>#{player}</td><td>#{button}</td></tr>"
    document.getElementById('players').lastChild.insertAdjacentHTML('beforeend', tableRow)

addPlayer = (player, guest = false) ->
  if guest
    param_type = "guests"
    inputid = "guestin#{player}"
  else
    param_type = "user_ids"
    inputid = "userin#{player}"
  unless player == ""
    param = "<input type='hidden' name='game[#{param_type}][]' id='#{inputid}' value='#{player}' />"
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
    $("#addGuest").css('visibility','hidden')
  $(".userButton").on "click", (event) ->
    addPlayer(this.id)
    updatePlayers(this.innerHTML.substring(4), user = this.id)
    $("##{this.id}").hide()
    $("#addGuest").css('visibility','visible')
    if (button for button in $("#userButtons").children().children() when button.style.display != "none").length == 1
      $("#userButtons").hide()
    $(".removeUser").on "click", (event) ->
      user_id = this.id.substring(10)
      console.log(user_id)
      document.getElementById("userin#{user_id}").outerHTML = ""
      document.getElementById("usertr#{user_id}").outerHTML = ""
      $("##{user_id}").show()
      $("#addUser").show()
  $("#userCancelButton").on "click", (event) ->
    $("#userButtons").hide()
    if (button for button in $("#userButtons").children().children() when button.style.display != "none").length != 1
      $("#addUser").show()
    $("#addGuest").css('visibility','visible')
  $("#addGuest").on "click", (event) ->
    $("#guestForm").show()
    $("#guestInput").val("")
    $("#guestInput").focus()
    $("#addUser").hide()
    $("#addGuest").css('visibility','hidden')
  $("#guestSubmit").on "click", (event) ->
    updatePlayers name.strip() for name in $("#guestInput").val().split(",")
    addPlayer(name.strip(), guest = true) for name in $("#guestInput").val().split(",")
    $("#guestForm").hide()
    $("#addGuest").css('visibility','visible')
    if (button for button in $("#userButtons").children().children() when button.style.display != "none").length != 1
      $("#addUser").show()
    $(".removeGuest").on "click", (event) ->
      guest_name = this.id.substring(11)
      document.getElementById("guestin#{guest_name}").outerHTML = ""
      document.getElementById("guesttr#{guest_name}").outerHTML = ""
  $("#guestInput").on "keypress", (event) ->
    if event.keyCode == 13
      $("#guestSubmit").click()
      return false
