package ge.koaladev.msy.nso.admin;

import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.*;
import ge.koaladev.msy.nso.core.dto.admin.event.GetEventsRequest;
import ge.koaladev.msy.nso.core.dto.admin.DeletePersonRequest;
import ge.koaladev.msy.nso.core.dto.admin.DeleteRequest;
import ge.koaladev.msy.nso.core.dto.objects.EventDTO;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.EventService;
import ge.koaladev.msy.nso.core.services.OperationNotPermitException;
import ge.koaladev.msy.nso.core.services.PersonService;
import ge.koaladev.msy.nso.core.services.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.Date;

@RequestMapping({"/event"})
@Controller
public class EventController {
    @Autowired
    private EventService requestService;
    @Autowired
    private UsersService userService;
    @Autowired
    private PersonService personService;

    @RequestMapping({"/create-event"})
    @ResponseBody
    private Response createRequest(@RequestBody AddEventRequest addEventRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        addEventRequest.setSenderUserId(u.getId().intValue());
        addEventRequest.setLastStatusId(EventDTO.EVENT_STATUS_INCOMPLETE);
        addEventRequest.setLastStatusDate(new Date());
        addEventRequest.setIteration(1);
        return Response.withSuccess(this.requestService.createRequest(addEventRequest));
    }

    @RequestMapping({"/add-person"})
    @ResponseBody
    private Response addPerson(@RequestBody AddPersonToEventRequest addPersonToEventRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        addPersonToEventRequest.setUserId(u.getId());
        return Response.withSuccess(this.requestService.addPersonToEvent(addPersonToEventRequest));
    }

    @RequestMapping({"/add-event-person"})
    @ResponseBody
    private Response addEventPerson(@RequestBody AddPersonToEventRequest addPersonToEventRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        addPersonToEventRequest.setUserId(u.getId());
        return Response.withSuccess(requestService.addEventPerson(addPersonToEventRequest));
    }

    @RequestMapping({"/add-person-item"})
    @ResponseBody
    private Response addPersonItem(@RequestBody AddPersonToEventRequest addPersonToEventRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        addPersonToEventRequest.setUserId(u.getId());
        return Response.withSuccess(this.requestService.addPersonItem(addPersonToEventRequest));
    }

    @RequestMapping({"/add-person-image"})
    @ResponseBody
    private Response addPersonImage(@RequestParam("personId") Integer personId, @RequestParam("file") MultipartFile file) {
        return Response.withSuccess(this.personService.addPersonImage(personId, file));
    }

    @RequestMapping({"/find-person"})
    @ResponseBody
    private Response findPerson(@RequestBody FindPersonRequest findPersonRequest) {
        return Response.withSuccess(this.personService.findPersonByPersonalNumber(findPersonRequest));
    }

    @RequestMapping({"/get-persons-by-type"})
    @ResponseBody
    private Response getPersonByType(@RequestBody GetPersonsByTypeRequest request, HttpSession session) {
        Integer selectedUserId = request.getUserId();
        if (request.getFederationId() > 0) {
            selectedUserId = request.getFederationId();
        } else if ((request.getFederationId() == 0) && (selectedUserId == null || selectedUserId == 0)) {
            User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
            UserDTO u = (UserDTO) user.getUserData();
            selectedUserId = u.getId();
            if (u.getUsersGroup().getId().equals(UserDTO.USER_MANAGER) || u.getUsersGroup().getId().equals(UserDTO.USER_ADMINISTRATOR)) {
                selectedUserId = 0;
            }
        }
        return Response.withSuccess(personService.getPersonsByTypeId(request.getTypeId(), selectedUserId, request.getStart(), request.getLimit(), request.getFullText()));
    }


    @RequestMapping({"/get-person-list-by-type"})
    @ResponseBody
    private Response getPersonListByType(@RequestBody GetPersonsByTypeRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        Integer selectedUserId = u.getId();
        return Response.withSuccess(this.personService.getPersonsByTypeId(request.getTypeId(), selectedUserId, null, null, null));
    }

    @RequestMapping({"/get-persons"})
    @ResponseBody
    private Response getPersons(@RequestBody GetPersonsByTypeRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        Integer selectedUserId = u.getId();
        return Response.withSuccess(personService.getPersons(selectedUserId));
    }

    @RequestMapping({"/get-persons-by-federation"})
    @ResponseBody
    private Response getPersonsByFederation(@RequestBody GetPersonsByTypeRequest request, HttpSession session) {
        return Response.withSuccess(personService.getPersons(request.getFederationId()));
    }

    @RequestMapping({"/get-events"})
    @ResponseBody
    private Response getEvents(@RequestBody EventListRequest eventListRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(this.requestService.getEvents(u));
    }

    @RequestMapping({"/get-events-by"})
    @ResponseBody
    private Response getEventsBy(@RequestBody GetEventsRequest getEventsRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(this.requestService.getEventsBY(getEventsRequest, u));
    }

    @RequestMapping({"/get-history-events"})
    @ResponseBody
    private Response getHistoryEvents(@RequestBody EventListRequest eventListRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(this.requestService.getHistoryEvents(eventListRequest, u));
    }

    @RequestMapping({"/get-history-events-by"})
    @ResponseBody
    private Response getHistoryEventsBy(@RequestBody GetEventsRequest getEventsRequest, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(requestService.getHistoryEventsBY(getEventsRequest, u));
    }

    @RequestMapping({"/get-event"})
    @ResponseBody
    private Response getEvent(@RequestBody EventRequest eventRequest) {
        return Response.withSuccess(this.requestService.getEvent(eventRequest.getEventId()));
    }

    @RequestMapping({"/get-event-by-key"})
    @ResponseBody
    private Response getEventByKey(@RequestBody EventRequest eventRequest) {
        return Response.withSuccess(this.requestService.getEventByKey(eventRequest.getKey()));
    }

    @RequestMapping({"/add-document"})
    private Response addDocument(@RequestParam("eventId") Integer eventId, @RequestParam("typeId") Integer typeId, @RequestParam("file") MultipartFile file) {
        return Response.withSuccess(this.requestService.addDocumentToEvent(eventId, typeId, file));
    }

    @RequestMapping({"/get-event-history"})
    @ResponseBody
    private Response getEventHistory(@RequestBody EventRequest eventRequest) {
        return Response.withSuccess(this.requestService.getEventHistory(eventRequest.getEventId()));
    }

    @RequestMapping({"/get-event-history-by-key"})
    @ResponseBody
    private Response getEventHistoryByKey(@RequestBody EventRequest eventRequest) {
        return Response.withSuccess(this.requestService.getEventHistoryByKey(eventRequest.getKey()));
    }

    @RequestMapping({"/create-history"})
    @ResponseBody
    private Response createHistory(@RequestBody CreateHistoryRequest createHistoryRequest) {
        return Response.withSuccess(this.requestService.createHistory(createHistoryRequest));
    }

    @RequestMapping({"/reject-event"})
    @ResponseBody
    private Response rejectEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(this.requestService.rejectEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/return-event"})
    @ResponseBody
    private Response returnEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(requestService.returnEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/close-event"})
    @ResponseBody
    private Response closeEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(this.requestService.closeEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/report-event"})
    @ResponseBody
    private Response reportEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(this.requestService.reportEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/add-amount-event"})
    @ResponseBody
    private Response addAmountEvent(@RequestBody CreateHistoryRequest request) {
        return Response.withSuccess(this.requestService.addAmountEvent(request));
    }

    @RequestMapping({"/add-idNumber-event"})
    @ResponseBody
    private Response addIdNumberEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(this.requestService.addIdNumberEvent(request, u));
    }

    @RequestMapping({"/add-regNumber-event"})
    @ResponseBody
    private Response addRegistrationNumberEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(this.requestService.addRegNumberEvent(request, u));
    }

    @RequestMapping({"/dispatch-event"})
    @ResponseBody
    private Response dispatchEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(this.requestService.dispatchEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/dispatch-event-accountant"})
    @ResponseBody
    private Response dispatchEventAccountant(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(this.requestService.dispatchEventAccountant(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/approve-first-event"})
    @ResponseBody
    private Response approveFirstEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(requestService.approveFirstEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/reject-first-event"})
    @ResponseBody
    private Response rejectFirstEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(requestService.rejectFirstEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/approve-event"})
    @ResponseBody
    private Response approveEvent(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(this.requestService.approveEvent(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/process-event"})
    @ResponseBody
    private Response waitingApprove(@RequestBody CreateHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            return Response.withSuccess(this.requestService.waitingApprove(request, u));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/send-event"})
    @ResponseBody
    private Response sendEvent(@RequestBody UpdateEventStatusRequest request) {
        try {
            return Response.withSuccess(requestService.sendEvent(request));
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/get-group-users"})
    @ResponseBody
    private Response getUsersByGroup(@RequestBody AddUserRequest addUserRequest) {
        return Response.withSuccess(this.userService.getUsersByGroup(addUserRequest.getUserGroupId()));
    }

    @RequestMapping({"/delete-event"})
    @ResponseBody
    private Response deleteEvent(@RequestBody DeleteRequest deleteRequest) {
        this.requestService.deleteEvent(deleteRequest.getEventId());
        return Response.ok();
    }

    @RequestMapping({"/delete-event-person"})
    @ResponseBody
    private Response deleteEventPerson(@RequestBody DeleteRequest deleteRequest) {
        this.requestService.deleteEventPerson(deleteRequest.getEventPersonId());
        return Response.ok();
    }

    @RequestMapping({"/delete-person-item"})
    @ResponseBody
    private Response deletePerson(@RequestBody DeletePersonRequest request) {
        try {
            requestService.deletePerson(request.getPersonId());
            return Response.ok();
        } catch (Exception e) {
            return Response.withError(e.getMessage());
        }
    }

    @RequestMapping({"/delete-event-document"})
    @ResponseBody
    private Response deleteEventDocument(@RequestBody DeleteRequest deleteRequest) {
        this.requestService.deleteEventDocument(deleteRequest.getDocumentId());
        return Response.ok();
    }

    @RequestMapping({"/send"})
    @ResponseBody
    private void getUsersByGroup() {
        this.requestService.sendEmailToChancellery(16);
    }

    @RequestMapping({"/check-blocked-event"})
    @ResponseBody
    private Response checkEvent(HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(Boolean.valueOf(this.requestService.checkIsBlockedEvent(u.getId())));
    }
}
