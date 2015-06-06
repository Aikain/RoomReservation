$(window).load(function () {
    $.fn.textWidth = function () {
        var text = $(this).html();
        $(this).html('<span>' + text + '</span>');
        var width = $(this).find('span:first').width();
        $(this).html(text);
        return width;
    };
    $(".reservation").each(function () {
        if ($(this).textWidth() > $(this).innerWidth()) {
            $(this).attr("title", $(this).text());
        }
    });
    $("input[name=startTime]").datetimepicker({dateFormat: 'yy-mm-dd', firstDay: 1});
    $("input[name=endTime]").datetimepicker({dateFormat: 'yy-mm-dd', firstDay: 1});
    $("input[name=startTime]").on("change", function (e) {
        $("input[name=endTime]").data().datepicker.settings.minDate = $("input[name=startTime]").val();
    });
    $("input[name=endTime]").on("change", function (e) {
        $("input[name=startTime]").data().datepicker.settings.maxDate = $("input[name=endTime]").val();
    });
    $("#ui-datepicker-div").addClass("non-printable");
    $("#dialog-addRoom").dialog({
        autoOpen: false, height: 300, width: 350, modal: true,
        buttons: {
            "Lisää": function () {
                $(this).children().submit();
            },
            "Peruuta": function () {
                $(this).dialog("close");
            }
        }
    });
    $("#dialog-addReservation").dialog({autoOpen: false, height: 500, width: 350, modal: true,
        buttons: {
            "Lisää": function () {
                $(this).children().attr('action', '../room/' + $('#selectedRoomNro').val() + '/addReservation');
                $(this).children().submit();
            },
            "Peruuta": function () {
                $(this).dialog("close");
            }
        }
    });
});
function addPersonField() {
    $("#selectedRoomNro").parent().find("label[for=persons], input[name*='persons']").remove();
    for (var i = $("#selectedRoomNro option:selected").attr("maxpersoncount") - 1; i >= 0; i--) {
        $("#selectedRoomNro").after('<input type="text" name="persons[' + i + '].name" class="text ui-widget-content ui-corner-all" />');
    }
    $("#selectedRoomNro").after("<label for='persons'>Asukkaat:</label>")
}
function showRoomForm() {
    $("#dialog-addRoom").dialog("open")
}
function showReservationForm() {
    $("#dialog-addReservation").dialog("open")
}
function showNotes() {
    alert("Jos käytät firefoxia: Avaa valikko -> Tulosta -> Sivun asetukset. Valitse 'Vaaka' ja rastita 'Tulosta tausta'.");
}