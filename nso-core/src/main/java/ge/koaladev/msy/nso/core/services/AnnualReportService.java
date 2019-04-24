package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.AnnualReportDao;
import ge.koaladev.msy.nso.core.dao.CalendarDao;
import ge.koaladev.msy.nso.core.dto.admin.AddAnnualReportRequest;
import ge.koaladev.msy.nso.core.dto.admin.AddCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetAnnualReportRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetCalendarRequest;
import ge.koaladev.msy.nso.core.dto.objects.*;
import ge.koaladev.msy.nso.core.services.file.FileService;
import ge.koaladev.msy.nso.database.model.*;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Created by NINO on 4/2/2018.
 */

@Service
public class AnnualReportService {

    @Autowired
    private AnnualReportDao annualReportDao;

    @Autowired
    private FileService fileService;

    private static final Logger logger = Logger.getLogger(AnnualReportService.class);


    @Transactional
    public AnnualReportDTO createAnnualReport(AddAnnualReportRequest request) {

        AnnualReport item = new AnnualReport();
        item.setId(request.getId());
        if (request.getId() == null || request.getId() == 0) {
            item.setStatus(annualReportDao.find(AnnualReportStatus.class, AnnualReportDTO.STATUS_NEW));
        } else {
            item = annualReportDao.find(AnnualReport.class, request.getId());
        }
        item.setSenderUser(annualReportDao.find(Users.class, request.getSenderUserId()));
        item.setIntroduction(request.getIntroduction());
        item.setResult(request.getResult());
        item.setYear(request.getYear());
        item.setGovernance(request.getGovernance());
        item.setQualification(request.getQualification());
        item.setPopularisation(request.getPopularisation());
        item.setFight(request.getFight());
        item.setGenderIssue(request.getGenderIssue());
        item.setAlternative(request.getAlternative());
        item.setMass(request.getMass());
        item.setConclusion(request.getConclusion());
        if (item.getStatus().getId() == AnnualReportDTO.STATUS_BLOCKED) {
            item.setStatus(annualReportDao.find(AnnualReportStatus.class, AnnualReportDTO.STATUS_CORRECTED));
        }
        item.setCreateDate(new Date());
        item = annualReportDao.update(item);

        return null;
    }

    @Transactional
    public AnnualReportDTO getAnnualReport(GetAnnualReportRequest request) {
        return AnnualReportDTO.parse(annualReportDao.find(AnnualReport.class, request.getId()));
    }


    @Transactional
    public List<AnnualReportDTO> getAnnualReports(GetCalendarRequest request) {
        List<AnnualReport> results = annualReportDao.getAnnualReport(request.getUserId(), request.getFullText(), request.getLimit(), request.getOffset(), request.isFederation());
        List<AnnualReportDTO> reports = results != null ? AnnualReportDTO.parseToList(results) : null;
        for (AnnualReportDTO c : reports) {
            c.setDocuments(AnnualReportDocumentDTO.parseToList(annualReportDao.getAnnualReportDocuments(c.getId())));
        }
        return reports;
    }

    @Transactional
    public List<AnnualReportDocumentDTO> getAnnualReportDocuments(int annualReportId) {
        return AnnualReportDocumentDTO.parseToList(annualReportDao.getAnnualReportDocuments(annualReportId));
    }

    @Transactional
    public AnnualReportDocumentDTO addDocumentToReport(Integer reportId, Integer typeId, MultipartFile file) {
        AnnualReportDocument eventDocument = new AnnualReportDocument();
        eventDocument.setAnnualReportId(reportId);
        eventDocument.setType((AnnualReportDocumentType) annualReportDao.find(AnnualReportDocumentType.class, typeId));
        String[] fileParts = file.getOriginalFilename().split("\\.");
        String fileExtension = fileParts.length > 1 ? fileParts[fileParts.length - 1] : "";
        String fileName = "" + reportId + "_ar_" + UUID.randomUUID() + (fileExtension.length() > 0 ? ("." + fileExtension) : "");

        String fullPath = fileService.getRootDir() + "/" + fileName;

        File f = new File(fullPath);
        try {
            file.transferTo(f);
            logger.info("Save file with reportId=" + reportId + ", typeId=" + typeId + ", fullPath=" + fullPath);
        } catch (Exception ex) {
            logger.error("Unable to save document with reportId=" + reportId + ", typeId=" + typeId + ", fullPath=" + fullPath, ex);
        }
        eventDocument.setName(fileName);
        eventDocument = annualReportDao.create(eventDocument);
        return AnnualReportDocumentDTO.parse(eventDocument);
    }

    @Transactional
    public void blockReport(AddCalendarRequest request, UserDTO u) throws OperationNotPermitException {
        AnnualReport item = annualReportDao.find(AnnualReport.class, request.getId());
        if ((item.getStatus().getId() != AnnualReportDTO.STATUS_NEW && item.getStatus().getId() != AnnualReportDTO.STATUS_CORRECTED) || u.getUsersGroup().getId() != UserDTO.USER_MANAGER) {
            throw new OperationNotPermitException("ამ ეტაპზე ოპერაციის შესრულება შეუძლებელია");
        }
        item.setStatus(annualReportDao.find(AnnualReportStatus.class, AnnualReportDTO.STATUS_BLOCKED));
        item.setNote(request.getNote());
        annualReportDao.update(item);
    }

    @Transactional
    public void sendReport(AddCalendarRequest request, UserDTO u) throws OperationNotPermitException {
        AnnualReport item = annualReportDao.find(AnnualReport.class, request.getId());
        if ((item.getStatus().getId() != AnnualReportDTO.STATUS_NEW && item.getStatus().getId() != AnnualReportDTO.STATUS_CORRECTED) || u.getUsersGroup().getId() != UserDTO.USER_MANAGER) {
            throw new OperationNotPermitException("ამ ეტაპზე ოპერაციის შესრულება შეუძლებელია");
        }
        item.setStatus(annualReportDao.find(AnnualReportStatus.class, AnnualReportDTO.STATUS_SENT));
        annualReportDao.update(item);
    }


}
