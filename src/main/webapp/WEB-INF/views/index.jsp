<%@page import="fi.gosu.roomreservation.domain.Room"%>
<%@page import="java.util.List"%>
<%@page import="fi.gosu.roomreservation.domain.Reservation"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>RoomReservation</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" charset="UTF-8" src="<c:url value='/resources/libraries/jquery-2.1.1.min.js' />"></script>       
        <script type="text/javascript" charset="UTF-8" src="<c:url value='/resources/index.js' />"></script>
        <link rel="stylesheet" type="text/css" href="<c:url value='/resources/index.css' />" />
    </head>
    <body>
        <div class="reservationTable">
            <div class="today" style="left:<%
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
            <table>
                <tr>
                    <td class='previousWeek' colspan=7><a href="${week -1 }">Edellinen viikko</a></td>
                    <td class='nextWeek'><a href="${week + 1}">Seuraava viikko</a></td>
                </tr>
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
                        <td>${room.roomNro}</td>
                        <td colspan=7>
                            <%
                                List<Reservation> reservations = ((Room) pageContext.getAttribute("room")).getReservations();
                                Calendar now = Calendar.getInstance();
                                int week = now.get(Calendar.WEEK_OF_YEAR) + (int) request.getAttribute("week");
                                int n = 0;
                                int oldwidth = 0;
                                for (Reservation r : reservations) {
                                    Calendar call = Calendar.getInstance();
                                    call.setTimeInMillis(r.getStartTime().getTime());
                                    int startweek = call.get(Calendar.WEEK_OF_YEAR);
                                    Calendar call2 = Calendar.getInstance();
                                    call2.setTimeInMillis(r.getEndTime().getTime());
                                    int endweek = call2.get(Calendar.WEEK_OF_YEAR);
                                    if (startweek <= week && endweek >= week) {
                                        Double width = 163 * 7 * (r.getEndTime().getTime() - r.getStartTime().getTime()) / 608400000.0;
                                        Double left = 163 * 7 * (r.getStartTime().getTime() - weekStartTime) / 608400000.0 - oldwidth;
                                        if (left < 0) {
                                            left = 0.0;
                                            width = 163 * 7 * (r.getEndTime().getTime() - weekStartTime) / 608400000.0;
                                        }
                                        if (left + width + oldwidth > 163 * 7 - 2) {
                                            width = 163 * 7 - left - oldwidth - 2;
                                        }
                                        out.print("<div class='reservation" + (n % 2 + 1) + "' style='left:" + left + "px;width:" + width + "px'>" + r.getPerson() + "</div>");
                                        oldwidth += width;
                                    }
                                    n++;
                                }
                            %>
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <form method="POST" action="../room">
                <input type="number" name="roomNro" placeholder="Huonenumero" />
                <input type="submit" value="Lisää" />
            </form>
        </div>
        <div class="addReservation">
            <form method="POST" action="../room/1/addReservation">
                <table>
                    <tbody>
                        <tr>
                            <td><input type="text" name="person0" placeholder="Nimi" /></td>
                        </tr>
                        <tr>
                            <td>Huone: </td>
                            <td>
                                <select>
                                    <c:forEach var="room" items="${rooms}">
                                        <option value="${room.id}">${room.roomNro}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr><td><input type="datetime" name="startTime" placeholder="Saapumisaika" /></td></tr>
                        <tr><td><input type="datetime" name="endTime" placeholder="Lähtöaika" /></td></tr>
                        <tr><td><input type="submit" value="Lisää" /></td></tr>
                    </tbody>
                </table>
            </form>
        </div>
    </body>
</html>
