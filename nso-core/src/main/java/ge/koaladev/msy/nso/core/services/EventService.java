/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.*;
import ge.koaladev.msy.nso.core.dto.admin.*;
import ge.koaladev.msy.nso.core.dto.admin.event.GetEventsRequest;
import ge.koaladev.msy.nso.core.dto.objects.*;
import ge.koaladev.msy.nso.core.services.file.FileService;
import ge.koaladev.msy.nso.database.model.*;
import ge.koaladev.utils.datetime.YearFirstLastDayPair;
import ge.koaladev.utils.email.EmailNotSentException;
import ge.koaladev.utils.email.FileAttachment;
import ge.koaladev.utils.email.SendEmailWithAttachment;
import ge.koaladev.utils.email.SendEmailWithAttachmentFactory;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.*;

/**
 * @author mindia
 */
@Component("EventService")
public class EventService {

    @Autowired
    private EventDAO eventDao;

    @Autowired
    private MessageDao messageDao;

    @Autowired
    private EventDocumentTypeDao eventDocumentTypeDao;

    @Autowired
    private UserDao userDao;
    @Autowired
    private EventStatusDao eventStatusDao;

    @Autowired
    private FileService fileService;

    @Autowired
    private PersonService personService;

    @Autowired
    private SendEmailWithAttachmentFactory sendEmailWithAttachmentFactory;

    @Autowired
    private PersonDAO personDAO;

    private static final Logger logger = Logger.getLogger(EventService.class);

    @Transactional
    public EventDTO createRequest(AddEventRequest addEventRequest) {

        Event request = new Event();
        if (addEventRequest.getId() != 0) {
            request = eventDao.find(Event.class, addEventRequest.getId());

        } else {
            request.setId(addEventRequest.getId());
        }
        request.setSenderUser(userDao.find(Users.class, addEventRequest.getSenderUserId()));
        request.setEventName(addEventRequest.getEventName());
        request.setEventDescription(addEventRequest.getEventDescription());
        request.setPurpose(addEventRequest.getPurpose());
        request.setExpectedResult(addEventRequest.getExpectedResult());
        request.setResponsiblePerson(addEventRequest.getResponsiblePerson());
        request.setResponsiblePersonPosition(addEventRequest.getResponsiblePersonPosition());
        request.setStartDate(addEventRequest.getStartDate());
        request.setEndDate(addEventRequest.getEndDate());
        request.setReportDeliveryDate(addEventRequest.getReportDeliveryDate());
        request.setBudget(addEventRequest.getBudget());
        request.setLastStatus(eventStatusDao.find(EventStatus.class, addEventRequest.getLastStatusId()));
        request.setLastStatusDate(addEventRequest.getLastStatusDate());
        request.setLastSenderUserId(addEventRequest.getSenderUserId());
        request.setEventType(addEventRequest.getEventTypeId());
        request.setApplicationType(eventDao.find(ApplicationType.class, addEventRequest.getApplicationTypeId()));
        request.setIteration(addEventRequest.getIteration());
        request.setLetterNumber(addEventRequest.getLetterNumber());

        if (request.getId() == 0) {
            request.setCreateDate(new Date());
            request = eventDao.update(request);
            request.setKey(request.getId() + "_" + UUID.randomUUID());
            request = eventDao.update(request);
        } else {
            request = eventDao.update(request);
        }

        return EventDTO.parse(request, false, false);
    }

    @Transactional
    public EventPersonDTO addPersonToEvent(AddPersonToEventRequest addPersonToEventRequest) {

//        ep.setFirstName(addPersonToEventRequest.getFirstName());
//        ep.setLastName(addPersonToEventRequest.getLastName());
//        ep.setBirthDate(addPersonToEventRequest.getBirthDate());
//        ep.setAddress(addPersonToEventRequest.getAddress());
//        ep.setImageUrl(addPersonToEventRequest.getImageUrl());
//        ep.setPersonalNumber(addPersonToEventRequest.getPersonalNumber());
        // merge person
        Person person = personDAO.findPersonByPersonalNumber(addPersonToEventRequest.getPersonalNumber());

        if (person == null) {
            person = new Person();
        }

        person.setFirstName(addPersonToEventRequest.getFirstName());
        person.setLastName(addPersonToEventRequest.getLastName());
        person.setBirthDate(addPersonToEventRequest.getBirthDate());
        person.setAddress(addPersonToEventRequest.getAddress());
        person.setPersonalNumber(addPersonToEventRequest.getPersonalNumber());
        person.setWeightCategory(addPersonToEventRequest.getWeightCategory());
        person.setPosition(addPersonToEventRequest.getPosition());
        person.setClub(addPersonToEventRequest.getClub());
        person.setCity(addPersonToEventRequest.getCity());
        person.setTrainer(addPersonToEventRequest.getTrainer());
        person.setCategory(addPersonToEventRequest.getCategory());
        person.setTypeId(addPersonToEventRequest.getType());
        person.setUserId(addPersonToEventRequest.getUserId());

        if (person.getId() == null) {
            person = personDAO.create(person);
        } else {
            person = personDAO.update(person);
        }

        EventPerson ep = new EventPerson();
        if (addPersonToEventRequest.getId() != null) {
            ep = eventDao.find(EventPerson.class, addPersonToEventRequest.getId());
        }

        ep.setPerson(person);

        ep.setId(addPersonToEventRequest.getId());
        ep.setEventId(addPersonToEventRequest.getEventId());
        ep.setType(addPersonToEventRequest.getType());

        if (ep.getId() == null) {
            ep = eventDao.create(ep);
        } else {
            ep = eventDao.update(ep);
        }

        return EventPersonDTO.parse(ep);
    }


    @Transactional
    public EventPersonDTO addEventPerson(AddPersonToEventRequest request) {

        Person person = personDAO.find(Person.class, request.getPersonId());

        EventPerson ep = new EventPerson();
        if (request.getId() != null) {
            ep = eventDao.find(EventPerson.class, request.getId());
        }

        ep.setPerson(person);

        ep.setId(request.getId());
        ep.setEventId(request.getEventId());
        ep.setType(request.getType());

        if (ep.getId() == null) {
            ep = eventDao.create(ep);
        } else {
            ep = eventDao.update(ep);
        }
        return EventPersonDTO.parse(ep);
    }


    @Transactional
    public PersonDTO addPersonItem(AddPersonToEventRequest addPersonToEventRequest) {

        Person person = new Person();
        if (addPersonToEventRequest.getId() != null && addPersonToEventRequest.getId() != 0) {
            person = eventDao.find(Person.class, addPersonToEventRequest.getId());
        } else {
            person.setId(addPersonToEventRequest.getId());
        }

        person.setFirstName(addPersonToEventRequest.getFirstName());
        person.setLastName(addPersonToEventRequest.getLastName());
        person.setBirthDate(addPersonToEventRequest.getBirthDate());
        person.setAddress(addPersonToEventRequest.getAddress());
        person.setPersonalNumber(addPersonToEventRequest.getPersonalNumber());
        person.setWeightCategory(addPersonToEventRequest.getWeightCategory());
        person.setPosition(addPersonToEventRequest.getPosition());
        person.setClub(addPersonToEventRequest.getClub());
        person.setCity(addPersonToEventRequest.getCity());
        person.setTrainer(addPersonToEventRequest.getTrainer());
        person.setCategory(addPersonToEventRequest.getCategory());
        person.setTypeId(addPersonToEventRequest.getTypeId());
        person.setUserId(addPersonToEventRequest.getUserId());
        person.setGenderId(addPersonToEventRequest.getGenderId());

        if (person.getId() == null) {
            person.setCreateDate(new Date());
            person = personDAO.create(person);
        } else {
            person = personDAO.update(person);
        }
        return PersonDTO.parse(person);
    }

    @Transactional
    public void deleteEvent(int eventId) {
        Event event = eventDao.find(Event.class, eventId);
        if (event != null) {
            List<EventPerson> eventPersons = event.getPersons();
            if (eventPersons != null && eventPersons.size() > 0) {
                for (EventPerson e : eventPersons) {
                    deleteEventPerson(e.getId());
                }
            }
            List<EventDocument> eventDocuments = event.getDocuments();
            if (eventDocuments != null && eventDocuments.size() > 0) {
                for (EventDocument d : eventDocuments) {
                    deleteEventDocument(d.getId());
                }
            }
            eventDao.delete(event);
        }
    }

    @Transactional
    public void deleteEventPerson(int eventPersonId) {
        EventPerson eventPerson = eventDao.find(EventPerson.class, eventPersonId);
        if (eventPerson != null) {
            eventDao.delete(eventPerson);
        }
    }

    @Transactional
    public void deletePerson(int personId) throws Exception {
        List<EventPerson> persons = eventDao.getEventPersonByPersonId(personId);
        if (persons != null && persons.size() > 0) {
            throw new Exception("პერსონალის წაშლა არ შეიძლება, ის მონაწილეობს სხვადასხვა ღონისძიებაში");
        } else {
            Person person = eventDao.find(Person.class, personId);
            if (person != null) {
                eventDao.delete(person);
            }
        }
    }

    @Transactional
    public void deleteEventDocument(int eventDocumentId) {
        EventDocument eventDocument = eventDao.find(EventDocument.class, eventDocumentId);
        if (eventDocument != null) {
            fileService.deleteFile(eventDocument.getName());
            eventDao.delete(eventDocument);
        }
    }

    @Transactional
    public List<EventDTO> getAllEvents() {
        return EventDTO.parseToList(eventDao.getAll(Event.class), true, true);
    }

    @Transactional
    public List<EventDTO> getEvents() {
        return EventDTO.parseToList(eventDao.getAll(Event.class), true, true);
    }

    @Transactional
    public List<EventDTO> getEventsByStatus(int statusId) {
        List<Event> results = eventDao.getEventsByStatus(statusId);
        return results != null ? EventDTO.parseToList(results, false, false) : null;
    }

    @Transactional
    public List<EventDTO> getEventsByStatusAndDecision(int statusId, int decisionId) {
        List<Event> results = eventDao.getEventsByStatusAndDecision(statusId, decisionId);
        return results != null ? EventDTO.parseToList(results, false, false) : null;
    }

    @Transactional
    public List<EventDTO> getEventsByUserId(int userId, int statusId) {
        List<Event> results = eventDao.getEventsByUserId(userId, statusId);
        return results != null ? EventDTO.parseToList(results, false, false) : null;
    }

    @Transactional
    public List<EventDTO> getEventsBySupervisorUserId(int userId, int statusId) {
        List<Event> results = eventDao.getEventsBySupervisorUserId(userId, statusId);
        return results != null ? EventDTO.parseToList(results, false, false) : null;
    }

    @Transactional
    public List<EventDTO> getEventsByAccountantUserId(int userId, int statusId) {
        List<Event> results = eventDao.getEventsByAccountantUserId(userId, statusId);
        return results != null ? EventDTO.parseToList(results, false, false) : null;
    }

    @Transactional
    public List<EventDTO> getEventByUserStatus(int userId, int statusId, Integer year, Integer offset, Integer limit) {
        Date startDate = null;
        Date endDate = null;

        if (year != null) {
            YearFirstLastDayPair yearFirstLastDayPair = new YearFirstLastDayPair(year);
            startDate = yearFirstLastDayPair.getFirstDay();
            endDate = yearFirstLastDayPair.getLastDay();
        }
        List<Event> results = eventDao.getEventByUserStatus(userId, statusId, startDate, endDate, offset, limit);
        return results != null ? EventDTO.parseToList(results, false, false) : null;

    }

    @Transactional
    public EventDTO getEvent(int eventId) {
        Event event = eventDao.find(Event.class, eventId);
        EventDTO eventDTO = EventDTO.parse(event, true, true);
        if (event.getEventType() > 0) {
            eventDTO.setEventType(EventTypeDTO.parse(eventDao.find(EventType.class, event.getEventType())));
        }
        return eventDTO;
    }

    @Transactional
    public EventDTO getEventByKey(String key) {
        Event event = eventDao.getEventByKey(key);
        EventDTO eventDTO = EventDTO.parse(event, true, true);
        if (event.getEventType() > 0) {
            eventDTO.setEventType(EventTypeDTO.parse(eventDao.find(EventType.class, event.getEventType())));
        }
        return eventDTO;
    }

    @Transactional
    public EventDocumentDTO addDocumentToEvent(Integer eventId, Integer typeId, MultipartFile file) {
        EventDocument eventDocument = new EventDocument();
        eventDocument.setEventId(eventId);
        eventDocument.setType((EventDocumentType) eventDocumentTypeDao.find(EventDocumentType.class, typeId));
        String[] fileParts = file.getOriginalFilename().split("\\.");
        String fileExtension = fileParts.length > 1 ? fileParts[fileParts.length - 1] : "";
        String fileName = "" + eventId + "_" + UUID.randomUUID() + (fileExtension.length() > 0 ? ("." + fileExtension) : "");

        String fullPath = fileService.getRootDir() + "/" + fileName;

        File f = new File(fullPath);
        try {
            file.transferTo(f);
            logger.info("Save file with eventId=" + eventId + ", typeId=" + typeId + ", fullPath=" + fullPath);
        } catch (Exception ex) {
            logger.error("Unable to save document with eventId=" + eventId + ", typeId=" + typeId + ", fullPath=" + fullPath, ex);
        }
        eventDocument.setName(fileName);
        eventDocument = eventDao.create(eventDocument);
        return EventDocumentDTO.parse(eventDocument);
    }

    @Transactional
    public List<EventHistoryDTO> getEventHistory(int eventId) {
        if (eventId > 0) {
            List<EventHistory> results = eventDao.getEventHistory(eventId);
            return results != null ? EventHistoryDTO.parseToList(results, false, true, true) : null;
        }
        return EventHistoryDTO.parseToList(eventDao.getAll(EventHistory.class), false, true, true);
    }

    @Transactional
    public List<EventHistoryDTO> getEventHistoryByKey(String key) {
        Event event = eventDao.getEventByKey(key);
        if (event.getId() > 0) {
            List<EventHistory> results = eventDao.getEventHistory(event.getId());
            return results != null ? EventHistoryDTO.parseToList(results, false, true, true) : null;
        }
        return EventHistoryDTO.parseToList(eventDao.getAll(EventHistory.class), false, true, true);
    }

    @Transactional
    public EventDTO addAmountEvent(CreateHistoryRequest createHistoryRequest) {
        Event event = eventDao.find(Event.class, createHistoryRequest.getEventId());
        event.setRealAmount(createHistoryRequest.getAmount());
        return EventDTO.parse(eventDao.update(event), true, true);
    }

    @Transactional
    public EventDTO addIdNumberEvent(CreateHistoryRequest request, UserDTO u) {
        Event event = eventDao.find(Event.class, request.getEventId());
        event.setIdNumber(request.getIdNumber());
        request.setStatusId(EventDTO.EVENT_STATUS_REGISTERED);
        request.setSenderUserId(u.getId());
        eventDao.update(event);
        createHistory(request);
        return EventDTO.parse(event, true, true);
    }

    @Transactional
    public EventDTO addRegNumberEvent(CreateHistoryRequest request, UserDTO u) {
        Event event = eventDao.find(Event.class, request.getEventId());
        int lastStatus = event.getLastStatus().getId();
        event.setRegistrationNumber(request.getRegistrationNumber());
        eventDao.update(event);
        if (lastStatus == EventDTO.EVENT_STATUS_ACCOUNTED || lastStatus == EventDTO.EVENT_STATUS_APPROVED) {
            request.setSenderUserId(u.getId());
            request.setStatusId(EventDTO.EVENT_STATUS_CLOSED);
            request.setDesicionId(EventDTO.EVENT_DESICION_OK);
            createHistory(request);
        }
        return EventDTO.parse(event, true, true);
    }

    @Transactional
    public EventHistoryDTO createHistory(CreateHistoryRequest createHistoryRequest) {

        Event event = eventDao.find(Event.class, createHistoryRequest.getEventId());

        EventHistory eventHistory = new EventHistory();
        eventHistory.setEvent(event);
        eventHistory.setSender(eventDao.find(Users.class, createHistoryRequest.getSenderUserId()));
        if (createHistoryRequest.getRecepientUserId() != null) {
            eventHistory.setRecipient(eventDao.find(Users.class, createHistoryRequest.getRecepientUserId()));
        }
        eventHistory.setCreateDate(new Date());
        eventHistory.setNote(createHistoryRequest.getNote());
        eventHistory.setStatus(eventDao.find(EventStatus.class, createHistoryRequest.getStatusId()));

        eventHistory = eventDao.create(eventHistory);

        if (createHistoryRequest.getStatusId() == EventDTO.EVENT_STATUS_RETURNED && event.getEventDecision() != null) {
            event.setEventDecision(null);
        }
        event.setLastStatus(eventDao.find(EventStatus.class, createHistoryRequest.getStatusId()));
        event.setLastStatusDate(new Date());
        event.setLastUserId(createHistoryRequest.getRecepientUserId());
        event.setLastSenderUserId(createHistoryRequest.getSenderUserId());
        if (createHistoryRequest.getDesicionId() != null) {
            event.setEventDecision(eventDao.find(EventDecision.class, createHistoryRequest.getDesicionId()));
        }
        if (createHistoryRequest.getSupervisorId() != null) {
            event.setSupervisorId(createHistoryRequest.getSupervisorId());
        }
        if (createHistoryRequest.getDispatcherId() != null) {
            event.setDispatcherId(createHistoryRequest.getDispatcherId());
        }
        if (createHistoryRequest.getAccountantId() != null) {
            event.setAccountantId(createHistoryRequest.getAccountantId());
        }
        if (createHistoryRequest.getIteration() != null) {
            event.setIteration(createHistoryRequest.getIteration());
        }
        eventDao.update(event);

        return EventHistoryDTO.parse(eventHistory, true, true, true);
    }

    @Transactional
    public boolean sendEmailToChancellery(int eventId) {

        Event event = eventDao.find(Event.class, eventId);
        List<FileAttachment> files = new ArrayList<>();
        for (EventDocument eventDocument : event.getDocuments()) {
            FileAttachment fileAttachment = new FileAttachment();
            fileAttachment.setName(eventDocument.getName());
            fileAttachment.setPath(fileService.getFileFullPath(eventDocument.getName()));
        }
        SendEmailWithAttachment sendEmailWithAttachment = sendEmailWithAttachmentFactory.getInstance();

        sendEmailWithAttachment.setFileUrls(files);
        try {
            sendEmailWithAttachment.send();
        } catch (EmailNotSentException ex) {
            logger.error("Unable to send email to, " + sendEmailWithAttachment.getTo() + " with atachemtn list" + files.toString(), ex);
            return false;
        }
        return true;
    }


    public List<EventDTO> getEventsBy(GetEventsRequest getEventsRequest) {

        Date startDate = null;
        Date endDate = null;

        if (getEventsRequest.getYear() != null) {
            YearFirstLastDayPair yearFirstLastDayPair = new YearFirstLastDayPair(getEventsRequest.getYear());
            startDate = yearFirstLastDayPair.getFirstDay();
            endDate = yearFirstLastDayPair.getLastDay();
        }

        List<Event> results = eventDao.getEvents(
                getEventsRequest.getSenderUserId(), getEventsRequest.getSupervisorId(),
                getEventsRequest.getAccountantId(), getEventsRequest.getChancelleryId(), getEventsRequest.getStatusId(),
                startDate, endDate,
                getEventsRequest.getLimit(), getEventsRequest.getOffset(),
                getEventsRequest.getFullText(),
                getEventsRequest.isAdmin(), getEventsRequest.getRegisteredDate(),
                getEventsRequest.getFederationId()
        );
        List<EventDTO> events = results != null ? EventDTO.parseToList(results, false, false) : null;
        return events;
    }


    public List<EventDTO> getEventsBY(GetEventsRequest getEventsRequest, UserDTO u) {

        List<EventDTO> events = new ArrayList<>();

        if (u.getUsersGroup().getId() == UserDTO.USER_FEDERATION) {
//            events = getEventsByUserId(u.getId(), 0);
            getEventsRequest.setSenderUserId(u.getId());
        } else if (u.getUsersGroup().getId() == UserDTO.USER_SUPERVISOR) {
//            events = getEventsBySupervisorUserId(u.getId(), 0);
            getEventsRequest.setSupervisorId(u.getId());
        } else if (u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            //return getEventByUserStatus(u.getId(), EventDTO.EVENT_STATUS_NEW);
            getEventsRequest.setSenderUserId(u.getId());
            getEventsRequest.setAdmin(true);
            //NINO SACDELAD
            //getEventsRequest.setStatusId(EventDTO.EVENT_STATUS_NEW);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_ADMINISTRATOR) {
//            events = getAllEvents();
        } else if (u.getUsersGroup().getId() == UserDTO.USER_ACCOUNTANT) {
//            events = getEventsByAccountantUserId(u.getId(), 0);
            getEventsRequest.setAccountantId(u.getId());
        } else if (u.getUsersGroup().getId() == UserDTO.USER_CHANCELLERY) {
//            events = getEventsByStatus(EventDTO.EVENT_STATUS_NEW);
            getEventsRequest.setChancelleryId(u.getId());
            getEventsRequest.setStatusId(EventDTO.EVENT_STATUS_NEW);
            // TODO temporarily unavaialable for ministery reason
            //events = getEventsByStatus(EventDTO.EVENT_STATUS_APPROVED);
        }
        events = getEventsBy(getEventsRequest);
        for (EventDTO e : events
                ) {
            if (e.getLastStatus().getId() == EventDTO.EVENT_STATUS_REGISTERED) {
                e.setBlocked(eventDao.checkReportEventById(e.getId()) != null ? true : false);
            }
        }
        return events;
    }

    @Transactional
    public List<EventDTO> getEvents(UserDTO u) {
        List<EventDTO> events = new ArrayList<>();
        if (u.getUsersGroup().getId() == UserDTO.USER_FEDERATION) {
            events = getEventsByUserId(u.getId(), 0);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_SUPERVISOR) {
            events = getEventsBySupervisorUserId(u.getId(), 0);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            events = getEventByUserStatus(u.getId(), EventDTO.EVENT_STATUS_NEW, null, null, null);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_ADMINISTRATOR) {
            events = getAllEvents();
        } else if (u.getUsersGroup().getId() == UserDTO.USER_ACCOUNTANT) {
            events = getEventsByAccountantUserId(u.getId(), 0);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_CHANCELLERY) {
            events = getEventsByStatus(EventDTO.EVENT_STATUS_NEW);
            // TODO temporarily unavaialable for ministery reason
            //events = getEventsByStatus(EventDTO.EVENT_STATUS_APPROVED);
        }
        return events;
    }


    @Transactional
    public List<EventDTO> getHistoryEvents(EventListRequest eventListRequest, UserDTO u) {
        List<EventDTO> events = new ArrayList<>();
        if (u.getUsersGroup().getId() == UserDTO.USER_FEDERATION) {
            events = getEventsByUserId(u.getId(), EventDTO.EVENT_STATUS_CLOSED);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_SUPERVISOR) {
            events = getEventsBySupervisorUserId(u.getId(), EventDTO.EVENT_STATUS_CLOSED);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            events = getEventsByStatus(EventDTO.EVENT_STATUS_CLOSED);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_ADMINISTRATOR) {
            events = getEventsByStatus(EventDTO.EVENT_STATUS_CLOSED);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_CHANCELLERY) {
            events = getEventsByStatusAndDecision(EventDTO.EVENT_STATUS_CLOSED, EventDTO.EVENT_DESICION_OK);
        }
        return events;
    }

    @Transactional
    public List<EventDTO> getHistoryEventsBY(GetEventsRequest getEventsRequest, UserDTO u) {
        List<EventDTO> events = new ArrayList<>();
        getEventsRequest.setStatusId(EventDTO.EVENT_STATUS_CLOSED);
        if (u.getUsersGroup().getId() == UserDTO.USER_FEDERATION) {
            //events = getEventsByUserId(u.getId(), EventDTO.EVENT_STATUS_CLOSED);
            getEventsRequest.setSenderUserId(u.getId());
        } else if (u.getUsersGroup().getId() == UserDTO.USER_SUPERVISOR) {
            //events = getEventsBySupervisorUserId(u.getId(), EventDTO.EVENT_STATUS_CLOSED);
            getEventsRequest.setSupervisorId(u.getId());
        } else if (u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            //events = getEventsByStatus(EventDTO.EVENT_STATUS_CLOSED);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_ADMINISTRATOR) {
            //events = getEventsByStatus(EventDTO.EVENT_STATUS_CLOSED);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_CHANCELLERY) {
            getEventsRequest.setChancelleryId(u.getId());
            //getEventsRequest.setDesicionId(EventDTO.EVENT_DESICION_OK);
            //events = getEventsByStatusAndDecision(EventDTO.EVENT_STATUS_CLOSED, EventDTO.EVENT_DESICION_OK);
        }
        return getEventsBy(getEventsRequest);
    }

    @Transactional
    public EventDTO rejectEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_NEW
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_CHECK
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_PROCESSING
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SEND_ACCOUNTANT
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_CORRECTED) {
            throw new OperationNotPermitException("უარის თქმა ამ ეტაპზე არ შეიძლება");
        }
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW && u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            request.setDispatcherId(u.getId());
        }
        request.setDesicionId(EventDTO.EVENT_DESICION_NO);
        request.setSenderUserId(u.getId());
        request.setRecepientUserId(event.getSenderUser().getId());
        request.setStatusId(EventDTO.EVENT_STATUS_CLOSED);
        createHistory(request);
        return event;

    }

    @Transactional
    public EventDTO returnEventOld(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_PROCESSING
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_CHECK
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_CORRECTED
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SEND_ACCOUNTANT) {
            throw new OperationNotPermitException("დაბრუნება არ არის ხელმისაწვდომი ამ ეტაპისთვის");
        }
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW && u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            request.setDispatcherId(u.getId());
        }
        request.setSenderUserId(u.getId());
        request.setRecepientUserId(event.getSenderUser().getId());
        request.setStatusId(EventDTO.EVENT_STATUS_RETURNED);
        createHistory(request);
        return event;
    }


    @Transactional
    public EventDTO returnEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_REGISTERED
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_CLOSED
                && event.getEventDecision().getId() != EventDTO.EVENT_DESICION_OK
                && u.getUsersGroup().getId() != UserDTO.USER_MANAGER
                ) {
            throw new OperationNotPermitException("დაბრუნება არ არის ხელმისაწვდომი ამ ეტაპისთვის");
        }
        request.setDispatcherId(u.getId());
        request.setSenderUserId(u.getId());
        request.setRecepientUserId(event.getSenderUser().getId());
        request.setStatusId(EventDTO.EVENT_STATUS_RETURNED);
        createHistory(request);
        return event;
    }

    @Transactional
    public EventDTO closeEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_ACCOUNTANT_APPROVE
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE) {
            throw new OperationNotPermitException("უარის თქმა არ არის ხელმისაწვდომი ამ ეტაპისთვის");
        }
        request.setDesicionId(EventDTO.EVENT_DESICION_OK);
        request.setSenderUserId(u.getId());
        request.setRecepientUserId(event.getSenderUser().getId());
        request.setStatusId(EventDTO.EVENT_STATUS_CLOSED);
        createHistory(request);
        // Send Mail To chancellery
        sendEmailToChancellery(request.getEventId());
        return event;
    }

    @Transactional
    public EventDTO reportEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (
            // NINO remove this check will not need
            //event.getLastStatus().getId() != EventDTO.EVENT_STATUS_APPROVED &&
                event.getLastStatus().getId() != EventDTO.EVENT_STATUS_RETURNED
                        && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_REGISTERED) {
            throw new OperationNotPermitException("რეპორტი მიბმა არ არის ამ ეტაპისთვის ხელმისაწვდომი");
        }
        boolean checkCounter = false;
        for (EventDocumentDTO d : event.getDocuments()) {
            if (d.getType().getId() == EventDTO.EVENT_DOCUMENT_TECHNICAL_REPORT) {
                checkCounter = true;
            }
            if (d.getType().getId() == EventDTO.EVENT_DOCUMENT_FINANCIAL_REPORT) {
                checkCounter = true;
            }
        }
        if (!checkCounter) {
            throw new OperationNotPermitException("გაგაზავნამდე ღონისძიებაზე ჯერ უნდა ატვირთოთ ყველა ანგარიშის დოკუმენტი");
        }
        request.setSenderUserId(u.getId());
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_RETURNED) {
            request.setStatusId(EventDTO.EVENT_STATUS_CORRECTED);
            request.setRecepientUserId(event.getLastSenderUserId());
        }
        // NINO REMOVE THIS CHECK WILL NOT NEED
       /* else if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_APPROVED) {
            request.setRecepientUserId(event.getDispatcherId());
            request.setStatusId(EventDTO.EVENT_STATUS_ACCOUNTED);
            request.setIteration(event.getIteration() + 1);
        } */
        else if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_REGISTERED) {
            request.setRecepientUserId(event.getLastSenderUserId());
            request.setStatusId(EventDTO.EVENT_STATUS_ACCOUNTED);
            /*createHistory(request);
            request.setStatusId(EventDTO.EVENT_STATUS_CLOSED);
            request.setDesicionId(EventDTO.EVENT_DESICION_OK);*/
        }
        createHistory(request);
        return event;
    }

    @Transactional
    public EventDTO dispatchEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_NEW
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_ACCOUNTANT_APPROVE
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_PROCESSING
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_CORRECTED
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_ACCOUNTED) {
            throw new OperationNotPermitException("გადანაწილება არ არის ხემისაწვდომი  ამ ეტაპისთვის");
        }
        request.setSenderUserId(u.getId());
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW) {
            request.setDispatcherId(u.getId());
        }
        if (request.getSupervisorId() != null && request.getSupervisorId() != 0) {
            request.setStatusId(EventDTO.EVENT_STATUS_SUPERVISOR_CHECK);
            request.setRecepientUserId(request.getSupervisorId());
        } else {
            request.setStatusId(EventDTO.EVENT_STATUS_SEND_ACCOUNTANT);
            request.setRecepientUserId(request.getAccountantId());
        }
        createHistory(request);
        return event;
    }

    @Transactional
    public EventDTO dispatchEventAccountant(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_CHECK) {
            throw new OperationNotPermitException("ბუღალტერთან გადანაწილება არ არის ამ ეტაპზე ხელმისაწვდომი");
        }
        request.setSenderUserId(u.getId());
        request.setRecepientUserId(request.getAccountantId());
        request.setStatusId(EventDTO.EVENT_STATUS_SEND_ACCOUNTANT);
        createHistory(request);
        return event;
    }

    @Transactional
    public EventDTO approveEventOld(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_NEW
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_ACCOUNTANT_APPROVE
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_CORRECTED
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_PROCESSING) {
            throw new OperationNotPermitException("თანხმობა ამ ეტაპისთვის არ არის ხელმისაწვდომი");
        }
        request.setSenderUserId(u.getId());
        request.setRecepientUserId(event.getSenderUser().getId());
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW) {
            request.setSupervisorId(u.getId());
            request.setDispatcherId(u.getId());
        }
        request.setStatusId(EventDTO.EVENT_STATUS_APPROVED);
        createHistory(request);

        // Send Mail To chancellery
        sendEmailToChancellery(request.getEventId());

        return event;
    }

    @Transactional
    public EventDTO approveFirstEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_CHECK &&
                event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE
                ) {
            throw new OperationNotPermitException("თანხმობა ამ ეტაპისთვის არ არის ხელმისაწვდომი");
        }
        request.setSenderUserId(u.getId());
        if (u.getUsersGroup().getId() == UserDTO.USER_SUPERVISOR) {
            request.setStatusId(EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE);
        } else if (u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            request.setStatusId(EventDTO.EVENT_STATUS_NEW);
            request.setDispatcherId(u.getId());
        }
        createHistory(request);
        return event;
    }


    @Transactional
    public EventDTO rejectFirstEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_CHECK
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_MANAGER_REJECT
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE
                ) {
            throw new OperationNotPermitException("უარის თქმა ამ ეტაპზე არ შეიძლება");
        }
        if (u.getUsersGroup().getId() == UserDTO.USER_SUPERVISOR) {
            request.setStatusId(EventDTO.EVENT_STATUS_SUPERVISOR_REJECT);
        } else if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE && u.getUsersGroup().getId() == UserDTO.USER_MANAGER) {
            request.setDispatcherId(u.getId());
            request.setStatusId(EventDTO.EVENT_STATUS_MANAGER_REJECT);
        }
        request.setSenderUserId(u.getId());

        createHistory(request);
        return event;

    }


    @Transactional
    public EventDTO approveEvent(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_CORRECTED
                ) {
            throw new OperationNotPermitException("თანხმობა ამ ეტაპისთვის არ არის ხელმისაწვდომი");
        }
        request.setSenderUserId(u.getId());
        request.setRecepientUserId(event.getSenderUser().getId());
        request.setStatusId(EventDTO.EVENT_STATUS_APPROVED);
        // Change Logic first sent chancellery and than close by chancellery
        /*request.setStatusId(EventDTO.EVENT_STATUS_CLOSED);
        request.setDesicionId(EventDTO.EVENT_DESICION_OK);*/
        createHistory(request);
        // Send Mail To chancellery
        // sendEmailToChancellery(request.getEventId());
        return event;
    }

    @Transactional
    public EventDTO waitingApprove(CreateHistoryRequest request, UserDTO u) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW) {
            request.setDispatcherId(u.getId());
            request.setRecepientUserId(u.getId());
            request.setStatusId(EventDTO.EVENT_STATUS_PROCESSING);
        } else if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_SUPERVISOR_CHECK
                || event.getLastStatus().getId() == EventDTO.EVENT_STATUS_SEND_ACCOUNTANT
                || event.getLastStatus().getId() == EventDTO.EVENT_STATUS_CORRECTED) {
            request.setRecepientUserId(event.getDispatcherId());
            if (u.getUsersGroup().getId() == UserDTO.USER_ACCOUNTANT) {
                request.setStatusId(EventDTO.EVENT_STATUS_ACCOUNTANT_APPROVE);
            } else if (u.getUsersGroup().getId() == UserDTO.USER_SUPERVISOR) {
                request.setStatusId(EventDTO.EVENT_STATUS_SUPERVISOR_APPROVE);
            }
        } else {
            throw new OperationNotPermitException("დამუშავება არ არის ხელმისაწვოდმი ამ ეტაპისთვის");
        }
        request.setSenderUserId(u.getId());
        createHistory(request);
        return event;
    }

    @Transactional
    public EventHistoryDTO sendEventOld19042018(UpdateEventStatusRequest request) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_INCOMPLETE
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_RETURNED
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_NEW
                ) {
            throw new OperationNotPermitException("ღონისძიება უკვე გაგზავნილია");
        }
        if (event.getApplicationType().getId() == EventDTO.APPLICATION_TYPE_EVENT
                && (event.getEventTypeId() != 1 && event.getEventTypeId() != 2 && event.getEventTypeId() != 4)
                && (event.getPersons() == null || event.getPersons().size() < 1)) {
            throw new OperationNotPermitException("ამ ღონისძიებას არ ყავს მონაწილეები დამატებული");
        }
        if (event.getDocuments() == null || event.getDocuments().size() < 1) {
            throw new OperationNotPermitException("ამ ღონისძიებას არ აქვს დოკუმენტი მიბმული");
        }
        CreateHistoryRequest req = new CreateHistoryRequest();
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_INCOMPLETE
                //TODO temporary
                || event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW) {
            req.setStatusId(EventDTO.EVENT_STATUS_NEW);
        } else if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_RETURNED) {
            req.setStatusId(EventDTO.EVENT_STATUS_CORRECTED);
            req.setRecepientUserId(event.getLastSenderUserId());
        }
        req.setEventId(request.getEventId());
        req.setSenderUserId(event.getSenderUser().getId());
        //TODO temporary
        // TODO NINO
        // sendEmailToChancellery(event.getId());
        return createHistory(req);
    }


    @Transactional
    public EventHistoryDTO sendEvent(UpdateEventStatusRequest request) throws OperationNotPermitException {
        EventDTO event = getEvent(request.getEventId());
        if (event.getLastStatus().getId() != EventDTO.EVENT_STATUS_INCOMPLETE
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_RETURNED
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_NEW
                && event.getLastStatus().getId() != EventDTO.EVENT_STATUS_SUPERVISOR_REJECT
                ) {
            throw new OperationNotPermitException("ღონისძიება უკვე გაგზავნილია");
        }
        if (event.getApplicationType().getId() == EventDTO.APPLICATION_TYPE_EVENT
                && (event.getEventTypeId() != 1 && event.getEventTypeId() != 2 && event.getEventTypeId() != 4)
                && (event.getPersons() == null || event.getPersons().size() < 1)) {
            throw new OperationNotPermitException("ამ ღონისძიებას არ ყავს მონაწილეები დამატებული");
        }
        if (event.getDocuments() == null || event.getDocuments().size() < 1) {
            throw new OperationNotPermitException("ამ ღონისძიებას არ აქვს დოკუმენტი მიბმული");
        }
        CreateHistoryRequest req = new CreateHistoryRequest();
        if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_INCOMPLETE
                || event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW
                ) {
            if (event.getSenderUser().getSupervisorId() != null && event.getSenderUser().getSupervisorId() != 0) {
                req.setStatusId(EventDTO.EVENT_STATUS_SUPERVISOR_CHECK);
                req.setSupervisorId(event.getSenderUser().getSupervisorId());
                req.setRecepientUserId(event.getSenderUser().getSupervisorId());
            } else {
                req.setStatusId(EventDTO.EVENT_STATUS_NEW);
            }
        } else if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_RETURNED) {
            req.setStatusId(EventDTO.EVENT_STATUS_CORRECTED);
            req.setRecepientUserId(event.getLastSenderUserId());
        } else if (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_SUPERVISOR_REJECT) {
            req.setStatusId(EventDTO.EVENT_STATUS_SUPERVISOR_CHECK);
            req.setRecepientUserId(event.getSenderUser().getSupervisorId());
        }
        req.setEventId(request.getEventId());
        req.setSenderUserId(event.getSenderUser().getId());
        //TODO temporary
        // TODO NINO
        // sendEmailToChancellery(event.getId());
        return createHistory(req);
    }

    @Transactional
    public boolean checkIsBlockedEvent(int userId) {
        List<Event> events = eventDao.getBlockedEventsByUserId(userId);
        List<Message> messasges = messageDao.getBlockedMessagesByUserId(userId);
        // remove automatic block request
        //List<Event> eventsTwo = eventDao.getReportEventsByUserId(userId);
        return ((events != null && events.size() > 0) ||
                (messasges != null && messasges.size() > 0)
                // || (eventsTwo != null && eventsTwo.size() > 0)
        ) ? true : false;
    }
}
