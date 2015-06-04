package fi.gosu.roomreservation.controller;

import fi.gosu.roomreservation.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/*")
public class DefaultController {

    @Autowired
    private RoomRepository roomRepository;

    @RequestMapping(value = "{week}", method = RequestMethod.GET)
    public String view(Model model, @PathVariable int week) {
        model.addAttribute("week", week);
        model.addAttribute("rooms", roomRepository.findAll(new Sort(Sort.Direction.ASC, "roomNro")));
        return "index";
    }

}
