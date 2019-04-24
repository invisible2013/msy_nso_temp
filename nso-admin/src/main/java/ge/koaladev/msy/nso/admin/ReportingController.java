package ge.koaladev.msy.nso.admin;

import ge.koaladev.msy.nso.core.dto.admin.reporting.Report1Request;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.ReportingServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping({"/reporting"})
@Controller
public class ReportingController {
    @Autowired
    private ReportingServices reportingServices;

    @RequestMapping({"/report1"})
    @ResponseBody
    public Response report1(@RequestBody Report1Request report1Request) {
        return Response.withSuccess(this.reportingServices.report1(report1Request));
    }
}
