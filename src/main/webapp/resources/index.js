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
        },
        close: function () {
            $("button").blur();
        }
    });
    $("#dialog-addReservation").dialog({autoOpen: false, height: 500, width: 350, modal: true,
        buttons: {
            "Lisää": function () {
                $(this).children().submit();
            },
            "Peruuta": function () {
                $(this).dialog("close");
            }
        },
        close: function () {
            $("button").blur();
        }
    });
    $("#dialog-updateReservation").dialog({autoOpen: false, height: 500, width: 350, modal: true,
        buttons: {
            "Päivitä": function () {
                $(this).children().submit();
            },
            "Peruuta": function () {
                $(this).dialog("close");
            }
        },
        close: function () {
            $("button").blur();
        }
    });
});
var extraPerson = Array();
function addPersonField() {
    var names = new Array();
    $.each($("#selectedRoomNro").parent().find("input[name*='person']"), function () {
        if ($(this).val() != "") {
            names.push($(this).val());
        }
    });
    for (var i = 0; i < extraPerson.length; i++) {
        names.push(extraPerson[i]);
    }
    $("#selectedRoomNro").parent().find("label[for=persons], input[name*='persons']").remove();
    $("br + br").remove();
    for (var i = $("#selectedRoomNro option:selected").attr("maxpersoncount") - 1; i >= 0; i--) {
        $("#selectedRoomNro").after('<input id="person' + i + '-add" type="text" name="persons[' + i + '].name" class="text ui-widget-content ui-corner-all" />');
    }
    $("#selectedRoomNro").after("<br /><label for='persons'>Asukkaat:</label><br />");
    extraPerson = Array();
    for (var i = 0; i < names.length; i++) {
        if ($("#person" + i + "-add").length) {
            $("#person" + i + "-add").val(names[i]);
        } else {
            extraPerson.push(names[i]);
        }
    }
    if (extraPerson.length) {
        $("#addReservation-error").html("<p>Seuraavat henkilöt eivät mahdu huoneeseen: " + extraPerson.join(", ") + "</p>");
    } else {
        $("#addReservation-error").html("");
    }
}
function addPersonField2() {
    var names = new Array();
    $.each($("#roomNro-update").parent().find("input[name*='person']"), function () {
        if ($(this).val() != "") {
            names.push($(this).val());
        }
    });
    for (var i = 0; i < extraPerson.length; i++) {
        names.push(extraPerson[i]);
    }
    $("#roomNro-update").parent().find("label[for=persons], input[name*='persons']").remove();
    $("br + br").remove();
    for (var i = $("#roomNro-update option:selected").attr("maxpersoncount") - 1; i >= 0; i--) {
        $("#roomNro-update").after('<input id="person' + i + '-update" type="text" name="persons[' + i + '].name" class="text ui-widget-content ui-corner-all" />');
    }
    $("#roomNro-update").after("<br /><label for='persons'>Asukkaat:</label><br />");
    extraPerson = Array();
    for (var i = 0; i < names.length; i++) {
        if ($("#person" + i + "-update").length) {
            $("#person" + i + "-update").val(names[i]);
        } else {
            extraPerson.push(names[i]);
        }
    }
    if (extraPerson.length) {
        $("#updateReservation-error").html("<p>Seuraavat henkilöt eivät mahdu huoneeseen: " + extraPerson.join(", ") + "</p>");
    } else {
        $("#updateReservation-error").html("");
    }
}
function showRoomForm() {
    $("#dialog-addRoom").dialog("open");
}
function showReservationForm() {
    $("#dialog-addReservation").dialog("open");
}
function showUpdateReservationForm(id, roomNro, startTime, endTime, persons) {
    if (window.getSelection) window.getSelection().removeAllRanges();
    else if (document.selection) document.selection.empty();
    $("#dialog-updateReservation").children().attr('action', '../reservation/' + id + '/update');
    $("#roomNro-update").val(roomNro);
    $("#startTime-update").val(startTime);
    $("#endTime-update").val(endTime);
    $("#endTime-update").data().datepicker.settings.minDate = startTime;
    $("#startTime-update").data().datepicker.settings.maxDate = endTime;
    addPersonField2();
    for (var i = 0; i < persons.length; i++) {
        $("#person" + i + "-update").val(persons[i]);
    }
    $("#dialog-updateReservation").dialog("open");
}
function showNotes(btn) {
    alert("Jos käytät firefoxia: Avaa valikko -> Tulosta -> Sivun asetukset. Valitse 'Vaaka' ja rastita 'Tulosta tausta'.");
    btn.blur();
}
function printReservation(btn) {
    $("td[colspan=7]:empty").closest("tr").addClass("non-printable");
    $("input[type=checkbox][name*=selectedRoom]:checked").closest("tr").removeClass("non-printable");
    window.print();
    $("td[colspan=7]:empty").closest("tr").removeClass("non-printable");
    btn.blur();
}
function selectAll(source, target) {
    $("input[type=checkbox][name*=selectedRoom" + target + "]").prop("checked", source.checked);
}
