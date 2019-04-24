package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.CalendarDao;
import ge.koaladev.msy.nso.core.dao.MessageDao;
import ge.koaladev.msy.nso.core.dto.admin.AddCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.CreateMessageHistoryRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetMessageRequest;
import ge.koaladev.msy.nso.core.dto.admin.broadcastemail.SendBroadcastEmailRequest;
import ge.koaladev.msy.nso.core.dto.objects.*;
import ge.koaladev.msy.nso.core.services.file.FileService;
import ge.koaladev.msy.nso.database.model.*;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Created by NINO on 4/2/2018.
 */

@Service
public class CalendarService {

    @Autowired
    private CalendarDao calendarDao;


    private static final Logger logger = Logger.getLogger(CalendarService.class);


    @Transactional
    public CalendarDTO createCalendar(AddCalendarRequest request) {

        Calendars item = new Calendars();
        item.setId(request.getId());
        if (request.getId() == null || request.getId() == 0) {
            item.setStatus(calendarDao.find(CalendarStatus.class, CalendarDTO.STATUS_NEW));
        } else {
            item = calendarDao.find(Calendars.class, request.getId());
        }
        item.setSenderUser(calendarDao.find(Users.class, request.getSenderUserId()));
        item.setName(request.getName());
        item.setLocation(request.getLocation());
        item.setEventDate(request.getEventDate());
        item.setEndDate(request.getEndDate());
        if (item.getStatus().getId() == CalendarDTO.STATUS_BLOCKED) {
            item.setStatus(calendarDao.find(CalendarStatus.class, CalendarDTO.STATUS_CORRECTED));
        }
        item.setCalendarType(calendarDao.find(CalendarType.class, request.getCalendarTypeId()));
        item.setCreateDate(new Date());
        item.setFirst(request.getFirst());
        item.setSecond(request.getSecond());
        item.setThird(request.getThird());
        item.setFourth(request.getFourth());
        item.setNote(request.getNote());
        item.setParticipant(request.getParticipant());
        item = calendarDao.update(item);

        if (request.getPersonsIds() != null) {
            for (int a : request.getPersonsIds()) {
                CalendarPerson person = new CalendarPerson();
                person.setPerson(calendarDao.find(Person.class, a));
                person.setCalendarId(item.getId());
                calendarDao.update(person);
            }
        }

        return null;
    }


    @Transactional
    public List<CalendarDTO> getCalendars(GetCalendarRequest request) {
        List<Calendars> results = calendarDao.getCalendar(request.getUserId(), request.getFullText(), request.getLimit(), request.getOffset(), request.isFederation(), request.getFederationId());
        List<CalendarDTO> calendars = results != null ? CalendarDTO.parseToList(results) : null;
        return calendars;
    }

    @Transactional
    public CalendarDTO getCalendar(GetCalendarRequest request) {
        return CalendarDTO.parse(calendarDao.find(Calendars.class, request.getId()));
    }


    @Transactional
    public void blockEvent(AddCalendarRequest request, UserDTO u) throws OperationNotPermitException {

        Calendars item = calendarDao.find(Calendars.class, request.getId());
        if ((item.getStatus().getId() != CalendarDTO.STATUS_NEW && item.getStatus().getId() != CalendarDTO.STATUS_CORRECTED) || u.getUsersGroup().getId() != UserDTO.USER_MANAGER) {
            throw new OperationNotPermitException("ამ ეტაპზე ოპერაციის შესრულება შეუძლებელია");
        }
        item.setStatus(calendarDao.find(CalendarStatus.class, CalendarDTO.STATUS_BLOCKED));
        item.setNote(request.getNote());
        calendarDao.update(item);
    }

    @Transactional
    public void unblockEvent(AddCalendarRequest request, UserDTO u) throws OperationNotPermitException {

        Calendars item = calendarDao.find(Calendars.class, request.getId());
        if (item.getStatus().getId() != CalendarDTO.STATUS_BLOCKED || u.getUsersGroup().getId() != UserDTO.USER_MANAGER) {
            throw new OperationNotPermitException("ამ ეტაპზე ოპერაციის შესრულება შეუძლებელია");
        }
        item.setStatus(calendarDao.find(CalendarStatus.class, CalendarDTO.STATUS_NEW));
        calendarDao.update(item);

    }

    @Transactional
    public void sendEvent(AddCalendarRequest request, UserDTO u) throws OperationNotPermitException {

        Calendars item = calendarDao.find(Calendars.class, request.getId());
        if ((item.getStatus().getId() != CalendarDTO.STATUS_NEW && item.getStatus().getId() != CalendarDTO.STATUS_CORRECTED) || u.getUsersGroup().getId() != UserDTO.USER_MANAGER) {
            throw new OperationNotPermitException("ამ ეტაპზე ოპერაციის შესრულება შეუძლებელია");
        }
        item.setStatus(calendarDao.find(CalendarStatus.class, CalendarDTO.STATUS_SENT));
        calendarDao.update(item);

    }


}
