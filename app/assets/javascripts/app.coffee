window.App = {}
App.Admin = {}
App.Admin.EventDashboardController = {
  run: (location, event)->
    me = App.Admin.EventDashboardController
    $(document).ready ->
      data = $("#table").data("records")
      if data.length == 0
        data = [["", null]]

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
      alert("Сохранено")

  column_headers: () ->
    ["Имя",
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
      "11","12","13","14","15","16","17","18","19","20",
      "21","22","23","24","25","26","27","28","29","30",
      "31", "Количество", "Очки"]

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

App.EventReportController = {
  dv: null
  table: null

  run: ->
    me = App.EventReportController
    google.load("visualization", "1", {packages:["table", "corechart"]});
    google.setOnLoadCallback(() ->
      #me.drawTable(1)
      me.drawChartLocation()
      me.drawChartPerson()
    );
    $(".pager").click(() -> me.drawTable($(this).data("page")))
    $(".table").tablesorter({sortList: [[3,1]]});

  drawTable: (week) ->
    me = App.EventReportController
    records = $("#table").data("records")
    data = new google.visualization.DataTable()
    data.addColumn "string", "Имя"
    data.addColumn "string", "Город"
    for i in [1..31]
      data.addColumn "number", ("00" + i).slice(-2)
    data.addColumn "number", "Количество"
    data.addRows(records)
    view = new google.visualization.DataView(data)
    s = (week*7)-7
    e = (week)*7
    if week == 5
      e = 31
      s = 31 - 7
    for i in [0..30]
      if i<s || i>=e
        view.hideColumns([2+i])
    table = new google.visualization.Table(document.getElementById("table"))
    table.draw view,
      sortColumn: 9
      sortAscending: false

  drawChartLocation: ->
    c = $("#chart_location")
    if c.size() == 0 then return
    records = $("#chart_location").data("records")
    data = new google.visualization.DataTable()
    data.addColumn "string", "Имя"
    data.addColumn "number", "Количество"
    data.addRows(records)
    table = new google.visualization.BarChart(document.getElementById("chart_location"))
    table.draw data,
      legend: {position: 'none'}

  drawChartPerson: ->
    records = $("#chart_person").data("records")
    data = new google.visualization.DataTable()
    data.addColumn "string", "Имя"
    data.addColumn "number", "Количество"
    data.addRows(records)
    table = new google.visualization.BarChart(document.getElementById("chart_person"))
    table.draw data,
      legend: {position: 'none'}
}

App.Admin.MonthlyReportDashboardController = {
  run: ->
    me = App.Admin.MonthlyReportDashboardController
    $(document).ready ->
      data = $("#table").data("records")
      if data.length == 0
        data = [["", null]]

      $("#save").click ->
        records  = $("#table").handsontable('getData')
        location = $(this).data("location")
        year    = $(this).data("year")
        month   = $(this).data("month")
        me.save(records, location, year, month)

      $("#table").handsontable
        data: data
        minSpareRows: 1
        colHeaders: true
        contextMenu: true
        colWidths: [250]
        colHeaders: me.column_headers()
        columns: me.columns()
        stretchH: 'all'

      hot = $("#table").handsontable('getInstance')
      hot.updateSettings()


  save: (data, location, year, month) ->
    json = { data: JSON.stringify(data) }
    $.post "/admin/"+location+"/"+year+"/"+month, json, ->
      alert("Сохранено")

  column_headers: () ->
    ["Имя", "Махабиги", "Биги", "Средние", "Малые"]

  columns: () ->
    me = App.Admin.MonthlyReportDashboardController
    people    = $("#table").data("people")
    result    = me.column_headers()
    result[0] = {
      type:   'autocomplete',
      source: people,
      strict: false
    }
    return result
}

$(document).ready ->
  embedded = $('body').data("embedded")
  if embedded
    $("a").each ->
      $(this).attr "href", $(this).attr("href") + "?embedded=true"