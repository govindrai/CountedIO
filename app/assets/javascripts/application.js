// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require Chart
//= require jquery_ujs
//= require_tree .

$(document).ready(function () {

  $('body').on("click", '#nav-1', toggleDay);
  $('body').on("click", '#nav-2', toggleWeek);
  $('body').on("click", '#nav-3', toggleMonth);
  $('body').on("click", '.back', replaceContent);
  $('body').on("click", '.forward', replaceContent);
  $('body').on('click', '.close-meals', closeMeals);
  getDayData();
  getWeekData();
  getMonthData();
  getDayMeals();

})

var replaceContent = function (e) {
  e.preventDefault();
  var URL = $(this).attr('href')
  var date = $(this).parent().parent().find('.date')
  var direction = this.classList[0]
  var chartID = this.classList[1]
  var queryParams = `?date=${date.text().substring(0,11)}&direction=${direction}&range=${chartID}`
  URL+= queryParams
  console.log(URL)
  console.log(chartID);
  console.log(queryParams);
  var request = $.ajax({
    url: URL,
    method: 'get'
  })

  request.done(function (response) {
    console.log("RESPONSE FROM PRESSING ARROW BUTTON")
    console.log(response)
    date.text(response.dateLabel)
    if (chartID == 'Day') {
      dayChart.data.datasets[0].data = response.data
      dayChart.update();
    } else if (chartID == 'Week') {
      weekChart.data.datasets[0].data = response.data
      weekChart.data.labels = response.dataLabels
      weekChart.data.datasets[1].data = response.targetCalories
      weekChart.update();
    } else {
      monthChart.data.datasets[0].data = response.data
      monthChart.data.labels = response.dataLabels
      monthChart.data.datasets[1].data = response.targetCalories
      monthChart.update();
    }
  })

  request.fail(function () {
    console.log("Shit is messed up")
  })
}

var closeMeals = function (e) {
  e.preventDefault();
  $(this).parent().toggle();
}

var toggleDay = function (e) {
  e.preventDefault();
  hideTabs();
  $('.day').toggle();
}

var toggleWeek = function (e) {
  e.preventDefault();
  hideTabs();
  $('.week').toggle();
}

var toggleMonth = function (e) {
  e.preventDefault();
  hideTabs();
  $('.month').toggle();
}

var hideTabs = function () {
  $('.day').hide();
  $('.week').hide();
  $('.month').hide();
}


var getDayData = function () {
  var URL = $('.day-link').children()[0].href + "?direction=none&range=Day"
  $.ajax({
    url: URL,
    method: 'get'
  })
  .done(function (response) {
    console.log(response)
    dayChart.data.datasets[0].data = response.data
    dayChart.update();
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}

var getWeekData = function () {
  var URL = $('.week-link').children()[0].href + "?direction=none&range=Week"
  $.ajax({
    url: URL,
    method: 'get'
  })
  .done(function (response) {
    console.log(response)
    weekChart.data.datasets[0].data = response.data
    weekChart.data.labels = response.dataLabels
    weekChart.data.datasets[1].data = response.targetCalories
    weekChart.update();
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}

var getMonthData = function () {
  var URL = $('.month-link').children()[0].href + "?direction=none&range=Month"
  $.ajax({
    url: URL,
    method: 'get'
  })
  .done(function (response) {
    console.log(response)
    monthChart.data.datasets[0].data = response.data
    monthChart.data.labels = response.dataLabels
    monthChart.data.datasets[1].data = response.targetCalories
    monthChart.update();
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}

var getDayMeals = function () {
  var baseUrl = $(document)[0].URL.split("?")
  var url = baseUrl[0] + "/get_day_meals" + "?" + baseUrl[1]
  $.ajax({
    url: url,
    method: 'get'
  })
  .done(function (response) {
    // console.log(response)
    $('body').append(response)
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}


