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

  $('body').on("click", '#day-button', toggleDay);
  $('body').on("click", '#week-button', toggleWeek);
  $('body').on("click", '#month-button', toggleMonth);
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
  // debugger
  var dateLabel = $('#date-label')
  var direction = this.classList[0]
  var chartType = $('.active').text()
  var queryParams = "?date=" + dateLabel.text().substring(0,11) + "&direction=" + direction + "&range=" + chartType
  URL+= queryParams
  console.log(URL)
  console.log(chartType);
  console.log(queryParams);
  var request = $.ajax({
    url: URL,
    method: 'get'
  })

  request.done(function (response) {
    console.log("RESPONSE FROM PRESSING ARROW BUTTON")
    console.log(response)
    var calsEaten = response.data[0] + response.data[1] + response.data[2] + response.data[3]
    var calsRemaining = response.data[4]
    $('.middle-text').html(' ')
    if (calsRemaining <= 0) {
      $('.middle-text').append("<p>Over Limit By: " + (calsEaten - response.targetCalories).toString() + "Calories</p>")
      $('.middle-text').addClass('over')
    } else {
      $('.middle-text').append("<p>Remaining Today: " + calsRemaining.toString() + "Calories</p>")
      $('.middle-text').removeClass('over')
    }
    // debugger
    dateLabelsObj[chartType.toLowerCase()] = response.dateLabel;
    dateLabel.text(dateLabelsObj[chartType.toLowerCase()]);

    // debugger
    if (chartType == 'Day') {
      dayChart.data.datasets[0].data = response.data
      dayChart.update();
    } else if (chartType == 'Week') {
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

  var baseUrl = $(document)[0].URL.split("?")
  var url = baseUrl[0] + "get_day_meals" + "?" + baseUrl[1]
  var direction = $(this).attr('class')
  var data = "?date=" + dateLabel.text().substring(0,11) + "&direction=" + direction

  $.ajax({
    url: url,
    method: 'get',
    data: data
  })
  .done(function (response) {
    $('.foods-container').replaceWith(response)
  })
  .fail(function () {
    console.log("This function has failed")
  })

}

var closeMeals = function (e) {
  e.preventDefault();
  $(this).parent().toggle();
}

var toggleDay = function (e) {
  e.preventDefault();
  hideTabs();
  $('#day-button').toggleClass('active');
  $('#date-label').text(dateLabelsObj.day)
  $('.day').toggle();
}

var toggleWeek = function (e) {
  e.preventDefault();
  hideTabs();
  $('#week-button').toggleClass('active');
  $('#date-label').text(dateLabelsObj.week)
  $('.week').toggle();
}

var toggleMonth = function (e) {
  e.preventDefault();
  hideTabs();
  $('#month-button').toggleClass('active');
  $('#date-label').text(dateLabelsObj.month)
  $('.month').toggle();

}

var hideTabs = function () {
  $('.day').hide();
  $('.week').hide();
  $('.month').hide();
  $('#day-button').removeClass('active');
  $('#week-button').removeClass('active');
  $('#month-button').removeClass('active');
}


var getDayData = function () {
  var URL = location.protocol + "/" + location.host + location.pathname + 'get_data?direction=none&range=Day'
  // debugger
  $.ajax({
    url: URL,
    method: 'get'
  })
  .done(function (response) {
    dayChart.data.datasets[0].data = response.data
    dayChart.update();
    var calsEaten = response.data[0] + response.data[1] + response.data[2] + response.data[3]
    var calsRemaining = response.data[4]
    console.log(calsEaten - response.targetCalories)
    $('.middle-text').html(' ')
    if (calsRemaining <= 0) {
      $('.middle-text').append("<p>Over Limit By: " + (calsEaten - response.targetCalories).toString() + "Calories</p>")
      $('.middle-text').addClass('over')
    } else {
      $('.middle-text').append("<p>Remaining Today: " + calsRemaining.toString() + "Calories</p>")
      $('.middle-text').removeClass('over')
    }
  })
  .fail(function (response) {
    console.log("Something is messed up.")
  })
}

var getWeekData = function () {
  var URL = location.protocol + "/" + location.host + location.pathname + 'get_data?direction=none&range=Week'
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
  var URL = location.protocol + "/" + location.host + location.pathname + 'get_data?direction=none&range=Month'
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
  var url = baseUrl[0] + "get_day_meals" + "?" + baseUrl[1]
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


var getDayMealsOnToggle = function () {
  var baseUrl = $(document)[0].URL.split("?")
  var url = baseUrl[0] + "get_day_meals" + "?" + baseUrl[1]
  var date = $(this).parent().parent().find('.date')
  var direction = $(this).attr('class')
  var data = "?date=" + dateLabel.text().substring(0,11) + "&direction=" + direction

  $.ajax({
    url: url,
    method: 'get',
    data: data
  })
  .done(function (response) {
    $('.foods-container').replaceWith(response)
  })
  .fail(function () {
    console.log("This function has failed")
  })
}


