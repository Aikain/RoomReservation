package fi.gosu.roomreservation.controller;

import fi.gosu.roomreservation.domain.*;
import fi.gosu.roomreservation.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/room")
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;

    @RequestMapping(method = RequestMethod.POST)
    public String createRoom(@ModelAttribute Room room) {
        roomRepository.save(room);
        return "redirect:/index/0";
    }

    @RequestMapping(value = "{id}/update", method = RequestMethod.POST)
    public String updateRoom(@PathVariable Long id, @RequestParam int roomNro, @RequestParam int maxPersonCount) {
        Room room = roomRepository.findOne(id);
        room.setMaxPersonCount(maxPersonCount);
        room.setRoomNro(roomNro);
        roomRepository.save(room);
        return "redirect:/index/0";
    }

    @RequestMapping(value = "{id}/delete", method = RequestMethod.POST)
    public String deleteRoom(@PathVariable Long id) {
        roomRepository.delete(id);
        return "redirect:/index/0";
    }

}
