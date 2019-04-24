package ge.koaladev.msy.nso.admin;

import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.*;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.CalendarService;
import ge.koaladev.msy.nso.core.services.OperationNotPermitException;
import ge.koaladev.msy.nso.core.services.ResultService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping({"/result"})
public class ResultController {

    @Autowired
    private ResultService resultService;

    private Logger logger = Logger.getLogger(ResultController.class);


    @RequestMapping({"/add-result"})
    @ResponseBody
    private Response addResult(@RequestBody AddResultRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setUserId(u.getId());
        return Response.withSuccess(resultService.createResult(request));
    }

    @RequestMapping({"/get-results"})
    @ResponseBody
    private Response getResults(@RequestBody GetResultRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setUserId(u.getId());
        return Response.withSuccess(resultService.getResult(request));
    }

    @RequestMapping({"/delete-result"})
    @ResponseBody
    private Response deleteResult(@RequestBody DeleteRequest request) {
        resultService.deleteResult(request.getItemId());
        return Response.withSuccess(true);
    }


}
