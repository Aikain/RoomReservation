$('#addReservationForm').submit(function () {
    $(this).attr('action', '../room/' + $('#selectedRoomNro').val() + 'addReservation');
    $(this).submit();
});