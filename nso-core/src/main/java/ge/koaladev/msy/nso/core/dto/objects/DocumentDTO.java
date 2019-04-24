/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import ge.koaladev.msy.nso.database.model.Document;
import ge.koaladev.msy.nso.database.model.MessageDocument;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
public class DocumentDTO {

    private Integer id;
    private String name;
    private String url;

    public static DocumentDTO parse(Document document) {

        DocumentDTO documentDTO = new DocumentDTO();
        documentDTO.setId(document.getId());
        documentDTO.setName(document.getName());
        documentDTO.setUrl(document.getUrl());

        return documentDTO;
    }

    public static List<DocumentDTO> parseToList(List<Document> events) {

        List<DocumentDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(DocumentDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

}
