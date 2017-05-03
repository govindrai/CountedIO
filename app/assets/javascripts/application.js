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

})

var replaceContent = function () {
  var URL = $(this).children().attr('href')
  $.ajax({
    url: URL
  })
  .done(function (response) {
    console.log(response)
    $('body').append(response)
  })
}

var refresh = function () {
  myDoughnutChart.data.datasets[0].data = [45,123,213]
  myDoughnutChart.update()
}





