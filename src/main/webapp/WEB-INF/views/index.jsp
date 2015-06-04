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
        <table>
            <tr>
              <td class='previousWeek' colspan=7><a href="${week -1 }">Edellinen viikko</a></td>
              <td class='nextWeek'><a href="${week + 1}">Seuraava viikko</a></td>
            </tr>
            <tr>
                <th class='roomNro'>Huone</th>
                    <%
                        Calendar cal = Calendar.getInstance();
                        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                        cal.add(Calendar.DAY_OF_MONTH, 7 * (int)request.getAttribute("week"));
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
                    <td colspan=7>${room.reservations}</td>
                </tr>
            </c:forEach>
        </table>
        <form method="POST" action="room">
            <input type="number" name="roomNro" placeholder="Huonenumero" />
            <input type="submit" value="Lisää" />
        </form>
    </body>
</html>
