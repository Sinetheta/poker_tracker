# New
$(document).on "turbolinks:load", ->
  $(".games.new").ready ->
    $("#userButtons").hide()
    $("#guestForm").hide()
    $("#addUser").on "click", (event) ->
      $("#userButtons").show()
      $("#addingUser").show()
      $("#addUser").hide()
      $("#addGuest").css('visibility','hidden')
    $(".userButton").on "click", (event) ->
      addPlayer($(this).data("userid"))
      updatePlayers($(this).data("username"), user = $(this).data("userid"))
      $(this).hide()
      if (button for button in $("#userButtons").children().children() when button.style.display != "none").length == 1
        $("#userButtons").hide()
        $("#addGuest").css('visibility','visible')
      $(".removeUser").on "click", (event) ->
        user_id = $(this).data("userid")
        $("#userin#{user_id}").remove()
        $("#usertr#{user_id}").remove()
        $("button[data-userid=#{user_id}]").show()
        $("#addUser").show()
    $("#userCancelButton").on "click", (event) ->
      $("#userButtons").hide()
      $("#addGuest").css('visibility','visible')
      $("#addUser").show()
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
        guest_name = $(this).data("guestname")
        $("#guestin#{guest_name}").remove()
        $("#guesttr#{guest_name}").remove()
    $("#guestInput").on "keypress", (event) ->
      if event.keyCode == 13
        $("#guestSubmit").click()
        return false

String::strip = -> @replace /^\s+|\s+$/g, ""

updatePlayers = (player, user = null) ->
  if user
    button = "<button class='btn btn-danger removeUser' data-userid='#{user}'>Remove</button>"
    trid = "usertr#{user}"
  else
    button = "<button class='btn btn-danger removeGuest' data-guestname='#{player}'>Remove</button>"
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
