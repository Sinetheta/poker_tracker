# New
$(document).on "turbolinks:load", ->
  $(".games.new").ready ->
    $("#userButtons").hide()
    $("#guestForm").hide()
    $("#addingUser").hide()
    $("#addingUser").on "click", (event) ->
      $(this).hide()
      $("#userButtons").hide()
      if (button for button in $("#userButtons").children().children() when button.style.display != "none").length != 1
        $("#addUser").show()
        $("#addGuest").css('visibility','visible')
    $("#addUser").on "click", (event) ->
      $("#userButtons").show()
      $("#addingUser").show()
      $("#addUser").hide()
      $("#addGuest").css('visibility','hidden')
    $(".userButton").on "click", (event) ->
      addPlayer(this.id)
      updatePlayers(this.innerHTML.substring(4), user = this.id)
      $("##{this.id}").hide()
      if (button for button in $("#userButtons").children().children() when button.style.display != "none").length == 1
        $("#userButtons").hide()
        $("#addGuest").css('visibility','visible')
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
    param_type = "guest_ids"
    inputid = "guestin#{player}"
  else
    param_type = "user_ids"
    inputid = "userin#{player}"
  unless player == ""
    param = "<input type='hidden' name='game[#{param_type}][]' id='#{inputid}' value='#{player}' />"
    document.getElementById('hiddenUsers').insertAdjacentHTML('beforeend', param)
