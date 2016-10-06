$(document).on "turbolinks:load", ->
  $(".select2").select2
    placeholder: "Select a size"
    allowClear: true
    width: "100%"
  $(".select2-multi").select2
    multiple: true
    width: "100%"
