package fi.gosu.roomreservation.repository;

import fi.gosu.roomreservation.domain.Room;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomRepository extends JpaRepository<Room, Long> {

}
