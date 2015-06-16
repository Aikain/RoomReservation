<%@page import="fi.gosu.roomreservation.domain.Room"%>
<%@page import="fi.gosu.roomreservation.domain.Person"%>
<%@page import="fi.gosu.roomreservation.domain.Reservation"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>RoomReservation</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" charset="UTF-8" src="<c:url value='/resources/libraries/jquery.min.js' />"></script>       
        <script type="text/javascript" charset="UTF-8" src="<c:url value='/resources/libraries/jquery-ui.min.js' />"></script>       
        <script type="text/javascript" charset="UTF-8" src="<c:url value='/resources/libraries/jquery-ui-timepicker-addon.js' />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value='/resources/index.js' />"></script>
        <link rel="stylesheet" type="text/css" href="<c:url value='/resources/libraries/jquery-ui.min.css' />" />
        <link rel="stylesheet" type="text/css" href="<c:url value='/resources/libraries/jquery-ui-timepicker-addon.css' />" />
        <link rel="stylesheet" type="text/css" href="<c:url value='/resources/index.css' />" />
    </head>
    <body>
        <div id="dialog-addRoom" class="non-printable" title="Lisää huone">
            <form method="POST" action="<c:url value='/room/' />">
                <fieldset>
                    <label for="roomNro">Huonenumero</label><br />
                    <input type="number" name="roomNro" class="number ui-widget-content ui-corner-all"><br />
                    <label for="maxPersonCount">Max asukamäärä</label><br />
                    <input type="number" name="maxPersonCount" class="number ui-widget-content ui-corner-all"><br />
                    <p id="addRoom-error"></p>
                    <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                </fieldset>
            </form>
        </div>
        <div id="dialog-addReservation" class="non-printable" title="Lisää huonevaraus">
            <form id="addReservationForm" method="POST" action="<c:url value='/reservation/' />" modelAttribute="reservation">
                <fieldset>
                    <label for="roomNro">Huonenumero</label><br />
                    <select id="selectedRoomNro" name="roomId" onchange="addPersonField()">
                        <option>---</option>
                        <c:forEach var="room" items="${rooms}">
                            <option value="${room.id}" maxpersoncount="${room.maxPersonCount}">${room.roomNro}</option>
                        </c:forEach>
                    </select><br />
                    <label for="startTime">Saapumisaika</label><br />
                    <input type="text" name="startTime" class="text ui-widget-content ui-corner-all"><br />
                    <label for="endTime">Lähtöaika</label><br />
                    <input type="text" name="endTime" class="text ui-widget-content ui-corner-all"><br />
                    <p id="addReservation-error"></p>
                    <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                </fieldset>
            </form>
        </div>
        <div id="dialog-updateReservation" class="non-printable" title="Päivitä huonevaraus">
            <form id="updateReservationForm" method="POST" action="#" modelAttribute="reservation">
                <fieldset>
                    <label for="roomNro">Huonenumero</label><br />
                    <select name="roomId" id="roomNro-update" onchange="addPersonField2()">
                        <c:forEach var="room" items="${rooms}">
                            <option value="${room.id}" maxpersoncount="${room.maxPersonCount}">${room.roomNro}</option>
                        </c:forEach>
                    </select><br />
                    <label for="startTime">Saapumisaika</label><br />
                    <input id="startTime-update" type="text" name="startTime" class="text ui-widget-content ui-corner-all"><br />
                    <label for="endTime">Lähtöaika</label><br />
                    <input id="endTime-update" type="text" name="endTime" class="text ui-widget-content ui-corner-all"><br />
                    <p id="updateReservation-error"></p>
                    <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                </fieldset>
            </form>
        </div>
        <div class="topButtonDiv non-printable">
            <button class="topButton" onclick="showRoomForm()">Lisää huone</button>
            <button class="topButton" onclick="showReservationForm()">Lisää huonevaraus</button>
            <button class="topButton" onclick="print($(this))">Tulosta</button>
            <button class="topButton" onclick="showNotes($(this))">Huomautukset</button>
            <hr /><br />
        </div>
        <div class="weekController non-printable">
            <button class="weekControllerButton preButton" onclick="location.href = ${week - 1}">&lt;&lt;&lt; Edellinen viikko</button>
            <button class="weekControllerButton nowButton" onclick="location.href = 0">Nyt</button>
            <button class="weekControllerButton nextButton" onclick="location.href = ${week + 1}">Seuraava viikko &gt;&gt;&gt;</button>
        </div>
        <div class="reservationTable">
            <div class="today non-printable" style="left:<%
                Calendar cal = Calendar.getInstance();
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                cal.add(Calendar.DAY_OF_MONTH, 7 * (int) request.getAttribute("week"));
                cal.set(Calendar.HOUR, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                Long weekStartTime = cal.getTimeInMillis();
                if ((int) request.getAttribute("week") != 0) {
                    out.print("0");
                } else {
                    out.print("" + (63 + (System.currentTimeMillis() - weekStartTime) * 163 * 7 / 604800000));
                }
                 %>px"></div>
            <table id="reservationTable">
                <tr>
                    <th class='roomNro'>Huone</th>
                        <%
                            DateFormat df = new SimpleDateFormat("EEE dd/MM/yyyy");
                            for (int i = 0; i < 7; i++) {
                                out.print("<th class='date'>" + df.format(cal.getTime()) + "</th>");
                                cal.add(Calendar.DATE, 1);
                            }
                        %>
                </tr>
                <c:forEach var="room" items="${rooms}">
                    <c:if test="${room.roomNro % 100 == 1}">
                        <tr><td colspan="8" class="emptyRow"></td></tr>
                        </c:if>
                    <tr>
                        <td>${room.roomNro} (${room.maxPersonCount})</td>
                        <td colspan=7>
                            <%
                                List<Reservation> reservations = ((Room) pageContext.getAttribute("room")).getReservations();

                                int n = 0;
                                int oldwidth = 0;
                                for (Reservation r : reservations) {;
                                    if (r.getStartTime().getTime() <= weekStartTime + 604800000 && r.getEndTime().getTime() >= weekStartTime) {
                                        Double width = 163 * 7 * (r.getEndTime().getTime() - r.getStartTime().getTime()) / 608400000.0;
                                        Double left = 163 * 7 * (r.getStartTime().getTime() - weekStartTime) / 608400000.0 - oldwidth;
                                        if (left < 0) {
                                            left = 0.0;
                                            width = 163 * 7 * (r.getEndTime().getTime() - weekStartTime) / 608400000.0;
                                        }
                                        if (left + width + oldwidth > 163 * 7 - 2) {
                                            width = 163 * 7 - left - oldwidth - 2;
                                        }
                                        String persons = "";
                                        for (Person p : r.getPersons()) {
                                            persons += p.getName() + ", ";
                                        }
                                        persons = persons.substring(0, persons.length() - 2);
                                        String ondbclick = "showUpdateReservationForm(" + r.getId() + ", " + r.getRoom().getId() + ", \"" + r.getStartTime() + "\", \"" + r.getEndTime() + "\", [\"" + persons.replace(", ", "\", \"") + "\"])";
                                        out.print("<div ondblclick='" + ondbclick + "' class='reservation bg" + (n % 2 + 1) + "' style='left:" + left + "px;width:" + width + "px'>" + persons + "</div>");
                                        oldwidth += width;
                                    }
                                    n++;
                                }
                            %>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
</body>
</html>
