package ge.koaladev.msy.nso.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import ge.koaladev.core.security.HasRight;
import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.AddCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.CreateMessageHistoryRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetMessageRequest;
import ge.koaladev.msy.nso.core.dto.admin.broadcastemail.SendBroadcastEmailRequest;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.BroadcastEmailService;
import ge.koaladev.msy.nso.core.services.CalendarService;
import ge.koaladev.msy.nso.core.services.MessageService;
import ge.koaladev.msy.nso.core.services.OperationNotPermitException;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Controller
@RequestMapping({"/calendar"})
public class CalendarController {

    @Autowired
    private CalendarService calendarService;

    private Logger logger = Logger.getLogger(CalendarController.class);


    @RequestMapping({"/add-calendar"})
    @ResponseBody
    private Response createRequest(@RequestBody AddCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setSenderUserId(u.getId());
        return Response.withSuccess(calendarService.createCalendar(request));
    }

    @RequestMapping({"/get-calendars"})
    @ResponseBody
    private Response getCalendars(@RequestBody GetCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setUserId(u.getId());
        request.setFederation(u.getUsersGroup().getId() == UserDTO.USER_FEDERATION ? true : false);
        return Response.withSuccess(calendarService.getCalendars(request));
    }

    @RequestMapping({"/get-calendar"})
    @ResponseBody
    private Response getCalendar(@RequestBody GetCalendarRequest request) {
        return Response.withSuccess(calendarService.getCalendar(request));
    }

    @RequestMapping({"/block-event"})
    @ResponseBody
    private Response blockEvent(@RequestBody AddCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            calendarService.blockEvent(request,u);
            return Response.withSuccess(true);
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/unblock-event"})
    @ResponseBody
    private Response unblockEvent(@RequestBody AddCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            calendarService.unblockEvent(request,u);
            return Response.withSuccess(true);
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/send-event"})
    @ResponseBody
    private Response sendEvent(@RequestBody AddCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            calendarService.sendEvent(request,u);
            return Response.withSuccess(true);
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }


}
