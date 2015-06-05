$(window).load(function() {
  $('#addReservationForm').submit(function () {
    $(this).attr('action', '../room/' + $('#selectedRoomNro').val() + '/addReservation');
    $(this).submit();
  });
  $.fn.textWidth = function(){
    var text = $(this).html();
    $(this).html('<span>'+text+'</span>');
    var width = $(this).find('span:first').width();
    $(this).html(text);
    return width;
  };
  $(".reservation").each(function() {
    if ($(this).textWidth() > $(this).innerWidth()) {
      $(this).attr("title", $(this).text());
    }
  });
  $("input[name=startTime]").datetimepicker({dateFormat: 'yy-mm-dd', firstDay: 1});
  $("input[name=endTime]").datetimepicker({dateFormat: 'yy-mm-dd', firstDay: 1});
  $("input[name=startTime]").on("change", function (e) {
    $("input[name=endTime]").data().datepicker.settings.minDate =  $("input[name=startTime]").val();
  });
  $("input[name=endTime]").on("change", function (e) {
    $("input[name=startTime]").data().datepicker.settings.maxDate =  $("input[name=endTime]").val();
  });
});
function showForm() {
  $("#roomSelect").nextAll().find("input[name*='persons']").closest("tr").remove();
  for (var i = $("#selectedRoomNro option:selected").attr("maxpersoncount") - 1; i >= 0; i--) {
    $("#roomSelect").after('<tr><td colspan=2 width="150px"><input type="text" name="persons[' + i + '].name" placeholder="Nimi" /></td></tr>');
  }
}
