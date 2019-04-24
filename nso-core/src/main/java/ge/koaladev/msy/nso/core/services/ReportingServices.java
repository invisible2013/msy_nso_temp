package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.EventTypeDao;
import ge.koaladev.msy.nso.core.dao.ReportingDAO;
import ge.koaladev.msy.nso.core.dao.UserDao;
import ge.koaladev.msy.nso.core.dto.admin.reporting.Report1Request;
import ge.koaladev.msy.nso.core.dto.objects.Report1DTO;
import ge.koaladev.msy.nso.core.dto.objects.Report1DetailsDTO;
import ge.koaladev.msy.nso.database.model.Event;
import ge.koaladev.msy.nso.database.model.EventType;
import ge.koaladev.msy.nso.database.model.Users;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReportingServices {
    @Autowired
    private ReportingDAO reportingDAO;
    @Autowired
    private UserDao userDao;
    @Autowired
    private EventTypeDao eventTypeDao;

    public List<Report1DTO> report1(Report1Request report1Request) {
        List<Report1DTO> report1DTOs = new ArrayList();
        for (Integer federation : report1Request.getFederations()) {
            List<Event> events = this.reportingDAO.report1(federation, report1Request.getEventTypes(), report1Request.getStartDate(), report1Request.getEndDate());
            Report1DTO report1DTO = new Report1DTO();

            double sum = 0.0D;
            for (Event event : events) {
                Report1DetailsDTO report1DetailsDTO = new Report1DetailsDTO();

                report1DetailsDTO.setBudget(event.getBudget() != null ? event.getBudget().doubleValue() : 0.0D);
                report1DetailsDTO.setEventName(event.getEventName());
                if (report1DetailsDTO.getBudget() != 0.0D) {
                    EventType eventType = (EventType) this.eventTypeDao.find(EventType.class, event.getEventType());
                    if (eventType != null) {
                        report1DetailsDTO.setEventTypeName(eventType.getName());
                    }
                    sum += report1DetailsDTO.getBudget();
                    report1DTO.getDetails().add(report1DetailsDTO);
                }
            }
            if (events != null) {
                report1DTO.setEventsCount(events.size());
            }
            report1DTO.setFederationId(federation.intValue());
            report1DTO.setSum(sum);
            report1DTO.setEventTypes(report1Request.getEventTypes());
            report1DTO.setStartDate(report1Request.getStartDate());
            report1DTO.setEndDate(report1Request.getEndDate());

            Users users = (Users) this.userDao.find(Users.class, federation);
            if (users != null) {
                report1DTO.setFederationName(users.getName());
            }
            report1DTOs.add(report1DTO);
        }
        return report1DTOs;
    }
}
