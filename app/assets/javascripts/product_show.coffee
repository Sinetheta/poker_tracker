$(document).on "turbolinks:load", ->
  console.log($(".select2-hidden-accessible").length > 0)
  if $(".select2-hidden-accessible").length > 0
    location.reload()
  $("#size.select2").select2
    allowClear: false
    width: "100%"
  $("#option1.select2").select2
    allowClear: false
    width: "100%"
  $("#option2.select2").select2
    allowClear: false
    width: "100%"
  $("#option3.select2").select2
    placeholder: "Select a sauce"
    allowClear: true
    width: "100%"
  $("#removals.select2-multi").select2
    placeholder: "Remove toppings"
    multiple: true
    width: "100%"
  $("#additions.select2-multi").select2
    placeholder: "Add toppings"
    multiple: true
    width: "100%"
  $("#order_id.select2").select2
    placeholder: "Order name"
    width: "100%"
  $("#takeout.select2").select2
    allowClear: false
    width: "100%"
