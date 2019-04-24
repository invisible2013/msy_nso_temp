package ge.koaladev.msy.nso.admin;

import ge.koaladev.msy.nso.core.dto.admin.GetDocumentTypesRequest;
import ge.koaladev.msy.nso.core.dto.admin.event.GetEventTypesRequest;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.MiscService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping({"/misc"})
@Controller
public class MiscController {

    @Autowired
    private MiscService miscService;

    @RequestMapping({"/get-event-types"})
    @ResponseBody
    private Response getEventTypes(@RequestBody GetEventTypesRequest getEventTypesRequest) {
        return Response.withSuccess(miscService.getEventTypes(getEventTypesRequest.getApplicationTypeId()));
    }

    @RequestMapping({"/get-person-types"})
    @ResponseBody
    private Response getPersonTypes() {
        return Response.withSuccess(miscService.getPersonTypes());
    }

    @RequestMapping({"/get-genders"})
    @ResponseBody
    private Response getGenders() {
        return Response.withSuccess(miscService.getGenders());
    }

    @RequestMapping({"/get-document-types"})
    @ResponseBody
    private Response getEventDocumentTypes(@RequestBody GetDocumentTypesRequest getDocumentTypesRequest) {
        return Response.withSuccess(miscService.getEventDocumentTypes(getDocumentTypesRequest.getEventTypeId()));
    }

    @RequestMapping({"/get-calendar-types"})
    @ResponseBody
    private Response getCalendarTypes() {
        return Response.withSuccess(miscService.getCalendarTypes());
    }

    @RequestMapping({"/get-report-document-types"})
    @ResponseBody
    private Response getAnnualReportDocumentTypes(@RequestBody GetDocumentTypesRequest getDocumentTypesRequest) {
        return Response.withSuccess(miscService.getAnnualReportDocumentTypes());
    }

}
