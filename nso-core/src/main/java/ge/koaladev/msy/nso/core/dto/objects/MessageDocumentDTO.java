/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import ge.koaladev.msy.nso.database.model.EventDocument;
import ge.koaladev.msy.nso.database.model.MessageDocument;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
public class MessageDocumentDTO {

    private Integer id;
    private Integer messageId;
    private String name;
    private String url;

    public static MessageDocumentDTO parse(MessageDocument document) {

        MessageDocumentDTO documentDTO = new MessageDocumentDTO();
        documentDTO.setId(document.getId());
        documentDTO.setMessageId(document.getMessageId());
        documentDTO.setName(document.getName());
        documentDTO.setUrl(document.getUrl());

        return documentDTO;
    }

    public static List<MessageDocumentDTO> parseToList(List<MessageDocument> events) {

        List<MessageDocumentDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(MessageDocumentDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMessageId() {
        return messageId;
    }

    public void setMessageId(Integer messageId) {
        this.messageId = messageId;
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
