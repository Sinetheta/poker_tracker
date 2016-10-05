# New
$(document).on "turbolinks:load", ->
  $(".saved-order").hide()
  $(".show-order").on "click", (event) ->
    showOrder = $("pre[data-orderid='" + $(this).data().orderid + "']")
    if showOrder.is(":visible")
      showOrder.hide()
    else
      showOrder.show()
