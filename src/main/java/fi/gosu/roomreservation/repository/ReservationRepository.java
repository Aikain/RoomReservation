package fi.gosu.roomreservation.repository;

import fi.gosu.roomreservation.domain.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {

}
