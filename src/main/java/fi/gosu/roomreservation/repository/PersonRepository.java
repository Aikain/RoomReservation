package fi.gosu.roomreservation.repository;

import fi.gosu.roomreservation.domain.Person;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PersonRepository extends JpaRepository<Person, Long> {

}
