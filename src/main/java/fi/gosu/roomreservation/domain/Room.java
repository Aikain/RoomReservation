package fi.gosu.roomreservation.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;

@Entity
public class Room implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private int roomNro;
    @OrderBy("startTime ASC")
    @JoinColumn(name = "Room_Reservation", unique = false)
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.REMOVE})
    private List<Reservation> reservations;

    public Room() {
        this.reservations = new ArrayList<>();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getRoomNro() {
        return roomNro;
    }

    public void setRoomNro(int roomNro) {
        this.roomNro = roomNro;
    }

    public List<Reservation> getReservations() {
        return reservations;
    }

    public void setReservations(List<Reservation> reservations) {
        this.reservations = reservations;
    }

}
