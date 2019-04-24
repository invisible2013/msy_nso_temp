/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import ge.koaladev.msy.nso.database.model.AnnualReportDocument;
import ge.koaladev.msy.nso.database.model.AnnualReportDocumentType;
import ge.koaladev.msy.nso.database.model.EventDocument;

import java.util.ArrayList;
import java.util.List;

/**
 * @author mindia
 */
public class AnnualReportDocumentDTO {

    private Integer id;
    private Integer annualReportId;
    private AnnualReportDocumentType type;
    private String name;


    public static AnnualReportDocumentDTO parse(AnnualReportDocument eventDocument) {

        AnnualReportDocumentDTO eventDocumentDTO = new AnnualReportDocumentDTO();
        eventDocumentDTO.setId(eventDocument.getId());
        eventDocumentDTO.setAnnualReportId(eventDocument.getAnnualReportId());
        eventDocumentDTO.setName(eventDocument.getName());
        if (eventDocument.getType() != null) {
            eventDocumentDTO.setType(eventDocument.getType());
        }

        return eventDocumentDTO;
    }

    public static List<AnnualReportDocumentDTO> parseToList(List<AnnualReportDocument> events) {

        List<AnnualReportDocumentDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(AnnualReportDocumentDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAnnualReportId() {
        return annualReportId;
    }

    public void setAnnualReportId(Integer annualReportId) {
        this.annualReportId = annualReportId;
    }

    public AnnualReportDocumentType getType() {
        return type;
    }

    public void setType(AnnualReportDocumentType type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
