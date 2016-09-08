# Edit
$(document).on "turbolinks:load", ->
  $(".games.edit").ready ->
    $("#blinds").change ->
      if this.checked
        $("#gameLength").prop('disabled', false)
      else
        $("#gameLength").prop('disabled', true)
