//= require active_admin/base
//= require fancybox
//= require active_admin/select2
//= require active_admin_datetimepicker

$(document).ready(function() {
  $("a.fancybox").fancybox({
    helpers : {
      overlay : {
        css : {
          'background' : 'rgba(58, 42, 45, 0.95)'
        }
      },
      title: {
        type: 'inside',
        position: 'top'
      }
    }
  });
});