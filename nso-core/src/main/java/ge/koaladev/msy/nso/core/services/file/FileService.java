/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.services.file;

import net.coobird.thumbnailator.Thumbnails;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.UUID;

/**
 * @author mindia
 */
@Service
public class FileService {

    private String rootDir;

    private final Logger logger = Logger.getLogger(FileService.class);

    public String getFileFullPath(String name) {
        return rootDir + "/" + name;
    }

    public void processRequest(HttpServletRequest request, HttpServletResponse response, String name, String type) throws ServletException {
        String filePath = rootDir + "/" + name;
        try {
            switch (type) {
                case "draw":
                    drawFile(request, response, filePath);
                    break;
                case "download":
                    downloadFile(request, response, filePath, name);
                    break;
//                case "file":
//                    pricessFile(request, response, filePath);
//                    break;
            }
        } catch (IOException e) {
            if (e instanceof FileNotFoundException) {
                response.setStatus(404);
            }
        }
    }

    private void drawFile(HttpServletRequest request, HttpServletResponse response, String path) throws IOException {
        try {
            logger.info("processing image , path " + path);
            //response.addHeader("Content-Type", "text/plain");
            InputStream inputStream = new FileInputStream(new File(path));
            byte[] buffer = new byte[1024];
            int len;
            while ((len = inputStream.read(buffer)) != -1) {
                response.getOutputStream().write(buffer, 0, len);
            }
        } catch (IOException ex) {
            logger.error("Unable to make responce for path " + path, ex);
            throw ex;
        }
    }

    public void downloadFile(HttpServletRequest request, HttpServletResponse response, String path, String name) throws IOException {
        try {
            logger.info("processing video , path " + path);
            //response.setContentType("video/mpg");
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("Content-Disposition", "attachment; filename=" + name);
            byte[] content = new byte[1024];
            OutputStream os;
            try (BufferedInputStream is = new BufferedInputStream(new FileInputStream(new File(path)))) {
                os = response.getOutputStream();
                while (is.read(content) != -1) {
                    os.write(content);
                }
            }
            os.close();
        } catch (IOException ex) {
            logger.error("Unable to make responce for path " + path, ex);
            throw ex;
        }
    }

    public void processImage(HttpServletRequest request, HttpServletResponse response, String path) throws IOException {
        try {
            logger.info("processing file , path " + path);
            response.setContentType("image/x-png");
            File f = new File(path);
            BufferedImage bi = ImageIO.read(f);
            try (OutputStream out = response.getOutputStream()) {
                ImageIO.write(bi, "png", out);
            }
        } catch (IOException ex) {
            logger.error("Unable to make responce for path " + path, ex);
            throw ex;
        }
    }

    public FileItem saveFile(MultipartFile file, String namePart, boolean thumbnail, boolean saveOriginalAndThumbnail) {

        String[] fileParts = file.getOriginalFilename().split("\\.");
        String fileExtension = fileParts.length > 1 ? fileParts[fileParts.length - 1] : "";
        String fileName = "" + namePart + "_" + UUID.randomUUID() + (fileExtension.length() > 0 ? ("." + fileExtension) : "");
        String thumbnailName = "" + namePart + "_" + UUID.randomUUID() + "_thumbnail" + (fileExtension.length() > 0 ? ("." + fileExtension) : "");

        File f = new File(rootDir + "/" + fileName);
        File tf = new File(rootDir + "/" + thumbnailName);
        try {
            file.transferTo(f);
            Thumbnails.of(f).size(100, 100).toFile(tf);
        } catch (Exception ex) {
            logger.error("Unable to save file with name " + fileName, ex);
            return null;
        }
        return new FileItem(fileName, thumbnailName);
    }

    public void deleteFile(String fileName) {
        File f = new File(rootDir + "/" + fileName);
        try {
            f.delete();
        } catch (Exception e) {
            logger.error(e);
        }
    }

    public String getRootDir() {
        return rootDir;
    }

    public void setRootDir(String rootDir) {
        this.rootDir = rootDir;
    }

}
