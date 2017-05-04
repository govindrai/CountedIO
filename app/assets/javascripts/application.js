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
  $('body').on("click", '.back', replaceContent)
  $('body').on("click", '.forward', replaceContent)
  $('body').on("click", '.refresh', refresh)
  $('body').on('click', '.close-meals', closeMeals)
})

var replaceContent = function (e) {
  e.preventDefault();
  console.log(this)
  var URL = $(this)[0].baseURI
  var date = $('.date').text()
  var direction = $(this).attr('class')
  var data = `date=${date}&direction=${direction}`
  console.log(data)

  $.ajax({
    url: URL,
    method: 'get',
    data: data
  })
  .done(function (response) {
    console.log("original data", myDoughnutChart.data.datasets[0].data)
    console.log("new_data", response.data)
    console.log(response.date)
    $('.date').text(response.date)
    myDoughnutChart.data.datasets[0].data = response.data
    myDoughnutChart.update();
  })
  .fail(function () {
    console.log("Shit is messed up")
  })
}

var closeMeals = function (e) {
  e.preventDefault();
  $(this).parent().toggle()
}

var refresh = function () {
  myDoughnutChart.data.datasets[0].data = [45,123,213]
  myDoughnutChart.update()
}




