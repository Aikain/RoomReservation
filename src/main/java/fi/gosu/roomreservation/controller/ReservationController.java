package fi.gosu.roomreservation.controller;

import fi.gosu.roomreservation.domain.*;
import fi.gosu.roomreservation.repository.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Transactional
    @RequestMapping(method = RequestMethod.POST)
    public String createReservation(@ModelAttribute("reservation") Reservation reservation, @RequestParam Long roomId) {
        System.out.println(reservationRepository.findByStartTimeNotBetweenAndEndTimeNotBetween(reservation.getStartTime(), reservation.getEndTime(), reservation.getStartTime(), reservation.getEndTime()));
        List<Person> persons = new ArrayList<>();
        reservation.setId(null);
        for (Person person : reservation.getPersons()) {
            persons.add(personRepository.save(person));
        }
        reservation.setPersons(persons);
        Room room = roomRepository.findOne(roomId);
        reservation.setRoom(room);
        reservation = reservationRepository.save(reservation);
        room.getReservations().add(reservation);
        return "redirect:/index/0";
    }

    @Transactional
    @RequestMapping(value = "/{reservationId}/update", method = RequestMethod.POST)
    public String update(@PathVariable Long reservationId, @ModelAttribute("reservation") Reservation newReservation, @RequestParam Long roomId) {
        Reservation oldReservation = reservationRepository.findOne(reservationId);
        oldReservation.setStartTime(newReservation.getStartTime());
        oldReservation.setEndTime(newReservation.getEndTime());
        List<Person> newPersons = new ArrayList<>();
        for (Person person : oldReservation.getPersons()) {
            if (newReservation.getPersons().contains(person)) {
                newPersons.add(person);
                newReservation.getPersons().remove(person);
            } else {
                personRepository.delete(person);
            }
        }
        for (Person person : newReservation.getPersons()) {
            newPersons.add(personRepository.save(person));
        }
        oldReservation.setPersons(newPersons);
        if (!Objects.equals(oldReservation.getRoom().getId(), roomId)) {
            oldReservation.getRoom().getReservations().remove(oldReservation);
            Room newRoom = roomRepository.findOne(roomId);
            oldReservation.setRoom(newRoom);
            newRoom.getReservations().add(oldReservation);
        }
        return "redirect:/index/0";
    }

    @Transactional
    @RequestMapping(value = "/{reservationId}/delete", method = RequestMethod.POST)
    public String deleteReservation(@PathVariable Long roomId, @PathVariable Long reservationId) {
        Reservation reservation = reservationRepository.findOne(reservationId);
        roomRepository.findOne(roomId).getReservations().remove(reservation);
        reservationRepository.delete(reservation);
        return "redirect:/index/0";
    }

}
