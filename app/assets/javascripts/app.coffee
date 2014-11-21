window.App = {}
App.Admin = {}
App.Admin.EventDashboardController = {
  run: (location, event)->
    me = App.Admin.EventDashboardController
    $(document).ready ->
      data = $("#table").data("records")
      if data.length == 0
        data = [["", null]]#[column_headers()]#[["",  null,  null,  null,  null,  null,  null,  null]]

      $("#save").click ->
        records  = $("#table").handsontable('getData')
        location = $(this).data("location")
        event    = $(this).data("event")
        me.save(records, location, event)

      $("#table").handsontable
        data: data
        minSpareRows: 1
        colHeaders: true
        contextMenu: true
        colWidths: [250]
        colHeaders: me.column_headers()
        columns: me.columns()
        fixedColumnsLeft: 1
        fixedRowsTop: 0

      hot = $("#table").handsontable('getInstance')
      hot.updateSettings()


  save: (data, location, event) ->
    json = { data: JSON.stringify(data) }
    $.post "/admin/"+location+"/"+event, json, ->
      alert("done")

  column_headers: () ->
    ["Имя",
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
      "11","12","13","14","15","16","17","18","19","20",
      "21","22","23","24","25","26","27","28","29","30",
      "31", "Количество"]

  columns: () ->
    me = App.Admin.EventDashboardController
    people    = $("#table").data("people")
    result    = me.column_headers()
    result[0] = {
      type:   'autocomplete',
      source: people,
      strict: false
    }
    return result
}