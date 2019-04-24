package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.DocumentDao;
import ge.koaladev.msy.nso.core.dao.MessageDao;
import ge.koaladev.msy.nso.core.dto.admin.CreateMessageHistoryRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetMessageRequest;
import ge.koaladev.msy.nso.core.dto.admin.broadcastemail.SendBroadcastEmailRequest;
import ge.koaladev.msy.nso.core.dto.objects.DocumentDTO;
import ge.koaladev.msy.nso.core.dto.objects.MessageDTO;
import ge.koaladev.msy.nso.core.dto.objects.MessageHistoryDTO;
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
public class UploadService {

    @Autowired
    private DocumentDao documentDao;

    @Autowired
    private FileService fileService;

    private static final Logger logger = Logger.getLogger(UploadService.class);


    @Transactional
    public MessageDTO addDocument(String name, MultipartFile[] files) {

        if (files != null && files.length > 0) {
            MultipartFile file = files[0];
            String[] fileParts = file.getOriginalFilename().split("\\.");
            String fileExtension = fileParts.length > 1 ? fileParts[fileParts.length - 1] : "";
            String fileName = "od_1_" + UUID.randomUUID() + (fileExtension.length() > 0 ? ("." + fileExtension) : "");

            String fullPath = fileService.getRootDir() + "/" + fileName;

            File f = new File(fullPath);
            try {
                file.transferTo(f);
                Document item = new Document();
                item.setName(name);
                item.setUrl(fileName);
                documentDao.update(item);
            } catch (Exception ex) {
                logger.error("Unable to save document with, fullPath=" + fullPath, ex);
            }
        }
        return null;
    }

    @Transactional
    public void deleteDocument(int documentId) {
        Document eventDocument = documentDao.find(Document.class, documentId);
        if (eventDocument != null) {
            fileService.deleteFile(eventDocument.getUrl());
            documentDao.delete(eventDocument);
        }
    }


    @Transactional
    public List<DocumentDTO> getDocuments() {
        return DocumentDTO.parseToList(documentDao.getAll(Document.class));
    }

}
