package ge.koaladev.msy.nso.admin;

import ge.koaladev.msy.nso.core.dto.admin.DeleteRequest;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.UploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;

/**
 * Created by NINO on 6/18/2018.
 */
@Controller
@RequestMapping({"/upload"})
public class UploadController {


    @Autowired
    private UploadService uploadService;

    @RequestMapping({"/add-document"})
    private Response addDocument(@RequestParam("name") String name, @RequestParam("file") MultipartFile[] files) {
        return Response.withSuccess(uploadService.addDocument(name, files));
    }

    @RequestMapping({"/get-documents"})
    @ResponseBody
    private Response getDocuments() {
        return Response.withSuccess(uploadService.getDocuments());
    }

    @RequestMapping({"/delete-document"})
    @ResponseBody
    private Response deleteDocument(@RequestBody DeleteRequest deleteRequest) {
        uploadService.deleteDocument(deleteRequest.getDocumentId());
        return Response.ok();
    }
}
