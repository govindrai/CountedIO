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
  var direction = $(this).attr('class')
  var data = `date=${date.text().substring(0,11)}&direction=${direction}`
  var chartID = this.classList[1]
  // debugger
  console.log(chartID);
  console.log(data);

  $.ajax({
    url: URL,
    method: 'get',
    data: data
  })
  .done(function (response) {
    console.log("This is the date from the page")
    console.log(date)
    console.log("This is the date from the server")
    console.log(response.date)
    date.text(response.date)
    if (chartID == 'dayChart') {
      dayChart.data.datasets[0].data = response.data
      dayChart.update();
    } else if (chartID == 'weekChart') {
      weekChart.data.datasets[0].data = response.data
      weekChart.data.labels = response.labels
      weekChart.data.datasets[1].data = response.target_calories
      weekChart.update();
    } else {
      monthChart.data.datasets[0].data = response.data
      monthChart.data.labels = response.labels
      monthChart.data.datasets[1].data = response.target_calories
      monthChart.update();
    }
  })
  .fail(function () {
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
  var URL = $('.day-link').children()[0].href
  $.ajax({
    url: URL,
    method: 'get'
  })
  .done(function (response) {
    console.log("GETTING getDay")
    date.text(response.date)
    dayChart.data.datasets[0].data = response.data
    dayChart.update();
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}

var getWeekData = function () {
  var URL = $('.week-link').children()[0].href
  $.ajax({
    url: URL,
    method: 'get'
  })
  .done(function (response) {
    console.log(response)
    weekChart.data.datasets[0].data = response.data
    weekChart.data.labels = response.labels
    weekChart.data.datasets[1].data = response.target_calories
    weekChart.update();
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}

var getMonthData = function () {
  var URL = $('.month-link').children()[0].href
  $.ajax({
    url: URL,
    method: 'get'
  })
  .done(function (response) {
    console.log(response)
    monthChart.data.datasets[0].data = response.data
    monthChart.data.labels = response.labels
    monthChart.data.datasets[1].data = response.target_calories
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
    console.log(response)
    $('body').append(response)
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}


