$(window).load(function() {
  $('#addReservationForm').submit(function () {
    $(this).attr('action', '../room/' + $('#selectedRoomNro').val() + '/addReservation');
    $(this).submit();
  });
  $.fn.textWidth = function(){
    var html_org = $(this).html();
    var html_calc = '<span>' + html_org + '</span>';
    $(this).html(html_calc);
    var width = $(this).find('span:first').width();
    $(this).html(html_org);
    return width;
  };
  $("div[class=reservation1], div[class=reservation2]").each(function() {
    if ($(this).textWidth() > $(this).innerWidth()) {
      $(this).attr("title", $(this).text());
    }
  });
  datepicker();
});
function showForm() {
  $("#roomSelect").nextAll().remove();
  $("#roomSelect").after('<tr><td colspan=2><input type="text" name="startTime" placeholder="Saapumisaika" /></td></tr>' +
              '<tr><td colspan=2><input type="text" name="endTime" placeholder="Lähtöaika" /></td></tr>' +
              '<tr><td colspan=2><input type="submit" value="Lisää" /></td></tr>');
  for (var i = $("#selectedRoomNro option:selected").attr("maxpersoncount") - 1; i >= 0; i--) {
    $("#roomSelect").after('<tr><td colspan=2 width="150px"><input type="text" name="persons[' + i + '].name" placeholder="Nimi" /></td></tr>');
  }
  datepicker();
}
function datepicker() {
  $("input[name=startTime]").datetimepicker({dateFormat: 'yy-mm-dd', firstDay: 1});
  $("input[name=endTime]").datetimepicker({dateFormat: 'yy-mm-dd', firstDay: 1});
  $("input[name=startTime]").on("change", function (e) {
    $("input[name=endTime]").data().datepicker.settings.minDate =  $("input[name=startTime]").val();
  });
  $("input[name=endTime]").on("change", function (e) {
    $("input[name=startTime]").data().datepicker.settings.maxDate =  $("input[name=endTime]").val();
  });
}
