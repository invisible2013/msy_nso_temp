package ge.koaladev.msy.nso.admin;

import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.AddAnnualReportRequest;
import ge.koaladev.msy.nso.core.dto.admin.AddCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetAnnualReportRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetCalendarRequest;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.AnnualReportService;
import ge.koaladev.msy.nso.core.services.OperationNotPermitException;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;

/**
 * Created by NINO on 4/23/2019.
 */

@Controller
@RequestMapping({"/soas"})
public class AnnualReportController {

    @Autowired
    private AnnualReportService annualReportService;

    private Logger logger = Logger.getLogger(AnnualReportController.class);


    @RequestMapping({"/add-annual-report"})
    @ResponseBody
    private Response createAnnualReport(@RequestBody AddAnnualReportRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setSenderUserId(u.getId());
        return Response.withSuccess(annualReportService.createAnnualReport(request));
    }

    @RequestMapping({"/get-annual-report"})
    @ResponseBody
    private Response getAnnualReports(@RequestBody GetCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setUserId(u.getId());
        request.setFederation(u.getUsersGroup().getId() == UserDTO.USER_FEDERATION ? true : false);
        return Response.withSuccess(annualReportService.getAnnualReports(request));
    }

    @RequestMapping({"/get-annual-report-item"})
    @ResponseBody
    private Response getAnnualReportItem(@RequestBody GetAnnualReportRequest request) {
        return Response.withSuccess(annualReportService.getAnnualReport(request));
    }

    @RequestMapping({"/get-annual-report-documents"})
    @ResponseBody
    private Response getAnnualReportDocuments(@RequestBody GetCalendarRequest request) {
        return Response.withSuccess(annualReportService.getAnnualReportDocuments(request.getId()));
    }

    @RequestMapping({"/add-document"})
    private Response addDocument(@RequestParam("reportId") Integer reportId, @RequestParam("typeId") Integer typeId, @RequestParam("file") MultipartFile file) {
        return Response.withSuccess(annualReportService.addDocumentToReport(reportId, typeId, file));
    }

    @RequestMapping({"/block-report"})
    @ResponseBody
    private Response blockEvent(@RequestBody AddCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            annualReportService.blockReport(request,u);
            return Response.withSuccess(true);
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }

    @RequestMapping({"/send-report"})
    @ResponseBody
    private Response sendEvent(@RequestBody AddCalendarRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        try {
            annualReportService.sendReport(request,u);
            return Response.withSuccess(true);
        } catch (OperationNotPermitException ex) {
            return Response.withError(ex.getMessage());
        }
    }



}
