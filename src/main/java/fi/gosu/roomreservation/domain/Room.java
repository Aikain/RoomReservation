package fi.gosu.roomreservation.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity
public class Room implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roomNro;
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.REMOVE})
    private List<Reservation> reservations;

    public Room() {
        this.reservations = new ArrayList<>();
    }

    public Long getRoomNro() {
        return roomNro;
    }

    public void setRoomNro(Long roomNro) {
        this.roomNro = roomNro;
    }

    public List<Reservation> getReservations() {
        return reservations;
    }

    public void setReservations(List<Reservation> reservations) {
        this.reservations = reservations;
    }

}
