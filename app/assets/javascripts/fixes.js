$(function() {
  tooltpis();
});

function tooltpis()
{
  $('a.top[rel="tooltip"]').tooltip({ placement: 'top', animation: true });
  $('a.left[rel="tooltip"]').tooltip({ placement: 'left', animation: true });
  $('a.right[rel="tooltip"]').tooltip({ placement: 'right', animation: true });
  $('a.bottom[rel="tooltip"]').tooltip({ placement: 'bottom', animation: true });
}
