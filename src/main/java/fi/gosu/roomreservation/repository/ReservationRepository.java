package fi.gosu.roomreservation.repository;

import fi.gosu.roomreservation.domain.Reservation;
import fi.gosu.roomreservation.domain.Room;
import java.util.Date;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {

    @Query("select r from Reservation r where r.room = :room and r.startTime between :startTime and :endTime and r.endTime between :startTime and :endTime")
    public List<Reservation> findAsd(@Param("room") Room room, @Param("startTime") Date startTime, @Param("endTime") Date endTime);

}
