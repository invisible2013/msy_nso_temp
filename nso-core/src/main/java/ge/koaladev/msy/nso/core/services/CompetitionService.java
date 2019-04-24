package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.CalendarDao;
import ge.koaladev.msy.nso.core.dao.CompetitionDao;
import ge.koaladev.msy.nso.core.dto.admin.AddCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.AddCompetitionRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetCalendarRequest;
import ge.koaladev.msy.nso.core.dto.objects.*;
import ge.koaladev.msy.nso.database.model.*;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

/**
 * Created by NINO on 4/2/2018.
 */

@Service
public class CompetitionService {

    @Autowired
    private CompetitionDao competitionDao;


    private static final Logger logger = Logger.getLogger(CompetitionService.class);


    @Transactional
    public CompetitionDTO createCompetition(AddCompetitionRequest request) {

        Competition item = new Competition();
        item.setId(request.getId());
        if (request.getId() != null && request.getId() != 0) {
            item = competitionDao.find(Competition.class, request.getId());
        }
        item.setSenderUser(competitionDao.find(Users.class, request.getSenderUserId()));
        item.setFederationUser(competitionDao.find(Users.class, request.getFederationId()));
        item.setName(request.getName());
        item.setLocation(request.getLocation());
        item.setCompetitionDate(request.getCompetitionDate());
        item.setCategory(request.getCategory());
        item.setGroupQuantity(request.getGroupQuantity());
        item.setProfessional(request.getProfessional());
        item.setDiscipline(request.getDiscipline());
        item.setCreateDate(new Date());

        item = competitionDao.update(item);

        if (request.getPersonsIds() != null) {
            List<CompetitionPerson> oldPersons = competitionDao.getCompetitionPersons(request.getId());
            for (CompetitionPerson person : oldPersons) {
                competitionDao.delete(person);
            }
            for (int a : request.getPersonsIds()) {
                CompetitionPerson person = new CompetitionPerson();
                person.setPerson(competitionDao.find(Person.class, a));
                person.setCompetitionId(item.getId());
                competitionDao.update(person);
            }
        }
        return null;
    }


    @Transactional
    public List<CompetitionDTO> getCompetitions(GetCalendarRequest request) {
        List<Competition> results = competitionDao.getCompetition(request.getUserId(), request.getFullText(), request.getLimit(), request.getOffset(), request.isManager(), request.getFederationId());
        List<CompetitionDTO> items = results != null ? CompetitionDTO.parseToList(results) : null;
        for (CompetitionDTO c : items) {
            c.setCompetitionPersons(CompetitionPersonDTO.parseToList(competitionDao.getCompetitionPersons(c.getId())));
        }
        return items;
    }

    @Transactional
    public CompetitionDTO getCompetition(GetCalendarRequest request) {
        CompetitionDTO dto = CompetitionDTO.parse(competitionDao.find(Competition.class, request.getId()));
        dto.setCompetitionPersons(CompetitionPersonDTO.parseToList(competitionDao.getCompetitionPersons(dto.getId())));
        return dto;
    }


}
