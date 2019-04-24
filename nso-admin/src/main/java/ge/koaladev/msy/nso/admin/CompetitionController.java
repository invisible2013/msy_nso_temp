package ge.koaladev.msy.nso.admin;

import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.AddCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.AddCompetitionRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetCalendarRequest;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.CalendarService;
import ge.koaladev.msy.nso.core.services.CompetitionService;
import ge.koaladev.msy.nso.core.services.OperationNotPermitException;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping({"/competition"})
public class CompetitionController {

    @Autowired
    private CompetitionService competitionService;

    private Logger logger = Logger.getLogger(CompetitionController.class);


    @RequestMapping({"/add-competition"})
    @ResponseBody
    private Response createRequest(@RequestBody AddCompetitionRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setSenderUserId(u.getId());
        return Response.withSuccess(competitionService.createCompetition(request));
    }

    @RequestMapping({"/get-competitions"})
    @ResponseBody
    private Response getCompetitions(@RequestBody GetCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setUserId(u.getId());
        request.setManager(u.getUsersGroup().getId() == UserDTO.USER_FEDERATION_MANAGER ? true : false);
        return Response.withSuccess(competitionService.getCompetitions(request));
    }

    @RequestMapping({"/get-competition"})
    @ResponseBody
    private Response getCalendar(@RequestBody GetCalendarRequest request) {
        return Response.withSuccess(competitionService.getCompetition(request));
    }



}
