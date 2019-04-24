/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.admin;

import ge.koaladev.msy.nso.core.services.file.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author mindia
 */
@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    @RequestMapping("/draw/{name}/")
    public void getImage(@PathVariable String name, HttpServletRequest request, HttpServletResponse response) throws ServletException {
        fileService.processRequest(request, response, name, "draw");
    }

    @RequestMapping("/download/{name}/")
    public void getFile(@PathVariable String name, HttpServletRequest request, HttpServletResponse response) throws ServletException {
        fileService.processRequest(request, response, name, "download");
    }
}
