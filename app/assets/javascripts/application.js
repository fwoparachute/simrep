// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery2
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require cocoon
//= require turbolinks
//= require selectize

$(document).on("turbolinks:load", function() {
  $(':input.select').selectize();

  $('tbody').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('select').selectize({
      create: true,
    });
  });

  $('[data-toggle="tooltip"]').tooltip();

});