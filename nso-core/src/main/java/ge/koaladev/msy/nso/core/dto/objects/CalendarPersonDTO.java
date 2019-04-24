/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.CalendarPerson;
import ge.koaladev.msy.nso.database.model.EventPerson;
import ge.koaladev.msy.nso.database.model.Person;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author mindia
 */
public class CalendarPersonDTO {

    private Integer id;
    private Integer personId;
    private Integer calendarId;
    private Person person;


    public static CalendarPersonDTO parse(CalendarPerson eventPerson) {

        CalendarPersonDTO ep = new CalendarPersonDTO();
        ep.setId(eventPerson.getId());
        ep.setCalendarId(eventPerson.getCalendarId());
        ep.setPersonId(eventPerson.getPerson().getId());
        ep.setPerson(eventPerson.getPerson());

        return ep;

    }

    public static List<CalendarPersonDTO> parseToList(List<CalendarPerson> eps) {

        List<CalendarPersonDTO> dTOs = new ArrayList<>();
        eps.stream().forEach((n) -> {
            dTOs.add(CalendarPersonDTO.parse(n));
        });

        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public Integer getCalendarId() {
        return calendarId;
    }

    public void setCalendarId(Integer calendarId) {
        this.calendarId = calendarId;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }
}
