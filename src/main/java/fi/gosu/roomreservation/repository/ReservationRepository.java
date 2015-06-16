package fi.gosu.roomreservation.repository;

import fi.gosu.roomreservation.domain.Reservation;
import java.util.Date;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {

    public List<Reservation> findByStartTimeNotBetweenAndEndTimeNotBetween(Date startTime1, Date endTime1, Date startTime2, Date endTime2);

}
