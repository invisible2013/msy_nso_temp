package ge.koaladev.msy.nso.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import ge.koaladev.core.security.HasRight;
import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.CreateHistoryRequest;
import ge.koaladev.msy.nso.core.dto.admin.CreateMessageHistoryRequest;
import ge.koaladev.msy.nso.core.dto.admin.EventListRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetMessageRequest;
import ge.koaladev.msy.nso.core.dto.admin.broadcastemail.SendBroadcastEmailRequest;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.BroadcastEmailService;
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
@RequestMapping({"/broadcast-email"})
public class BroadcastEmailController {
    @Autowired
    private BroadcastEmailService broadcastEmailService;

    @Autowired
    private MessageService messageService;
    private Logger logger = Logger.getLogger(BroadcastEmailController.class);

    @ResponseBody
    @RequestMapping({"/send-broadcast-email"})
    @HasRight(rights = {"admin", "top", "chancellery"})
    public Response sendBroadcast(@RequestParam("data") String data, @RequestParam(value = "files", required = false) MultipartFile[] files, HttpServletRequest httpServletRequest)
            throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        try {
            SendBroadcastEmailRequest sendBroadcastEmailRequest = (SendBroadcastEmailRequest) mapper.readValue(data, SendBroadcastEmailRequest.class);
            this.broadcastEmailService.sendBroadcastEmail(sendBroadcastEmailRequest, files);
        } catch (Exception e) {
            this.logger.error(e);
            throw new Exception("Unable to send broadcast email , please try again");
        }
        return Response.ok();
    }

}
