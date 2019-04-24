/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import ge.koaladev.msy.nso.database.model.CalendarPerson;
import ge.koaladev.msy.nso.database.model.CompetitionPerson;
import ge.koaladev.msy.nso.database.model.Person;

import java.util.ArrayList;
import java.util.List;

/**
 * @author nino
 */
public class CompetitionPersonDTO {

    private Integer id;
    private Integer personId;
    private Integer competitionId;
    private Person person;


    public static CompetitionPersonDTO parse(CompetitionPerson eventPerson) {

        CompetitionPersonDTO ep = new CompetitionPersonDTO();
        ep.setId(eventPerson.getId());
        ep.setCompetitionId(eventPerson.getCompetitionId());
        ep.setPersonId(eventPerson.getPerson().getId());
        ep.setPerson(eventPerson.getPerson());

        return ep;

    }

    public static List<CompetitionPersonDTO> parseToList(List<CompetitionPerson> eps) {

        List<CompetitionPersonDTO> dTOs = new ArrayList<>();
        eps.stream().forEach((n) -> {
            dTOs.add(CompetitionPersonDTO.parse(n));
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

    public Integer getCompetitionId() {
        return competitionId;
    }

    public void setCompetitionId(Integer competitionId) {
        this.competitionId = competitionId;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }
}
