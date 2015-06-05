package fi.gosu.roomreservation.controller;

import fi.gosu.roomreservation.domain.*;
import fi.gosu.roomreservation.repository.*;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/room")
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @RequestMapping(method = RequestMethod.POST)
    public String createRoom(@ModelAttribute Room room) {
        roomRepository.save(room);
        return "redirect:/index/0";
    }

    @Transactional
    @RequestMapping(value = "{id}/addReservation", method = RequestMethod.POST)
    public String addReservation(@PathVariable Long id, @ModelAttribute("reservation") Reservation reservation) {
        List<Person> persons = new ArrayList<>();
        for (Person person : reservation.getPersons()) {
            persons.add(personRepository.save(person));
        }
        reservation.setPersons(persons);
        Room room = roomRepository.findOne(id);
        reservation.setRoom(room);
        reservation = reservationRepository.save(reservation);
        room.getReservations().add(reservation);
        return "redirect:/index/0";
    }

    @Transactional
    @RequestMapping(value = "{roomId}/reservation/{reservationId}", method = RequestMethod.DELETE)
    public ResponseEntity deleteReservation(@PathVariable Long roomId, @PathVariable Long reservationId) {
        Reservation reservation = reservationRepository.findOne(reservationId);
        roomRepository.findOne(roomId).getReservations().remove(reservation);
        reservationRepository.delete(reservation);
        return new ResponseEntity(HttpStatus.OK);
    }

}
