# Edit
$(document).on "turbolinks:load", ->
  $(".games.edit").ready ->
    gameLength = $("#gameLength").val()
    $("#blinds").change ->
      if this.checked
        $("#gameLength").prop('disabled', false)
      else
        $("#gameLength").prop('disabled', true)
        $("#gameLength").val(gameLength)
