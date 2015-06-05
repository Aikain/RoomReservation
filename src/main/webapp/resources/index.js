$(window).load(function() {
  $('#addReservationForm').submit(function () {
    $(this).attr('action', '../room/' + $('#selectedRoomNro').val() + '/addReservation');
    $(this).submit();
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
