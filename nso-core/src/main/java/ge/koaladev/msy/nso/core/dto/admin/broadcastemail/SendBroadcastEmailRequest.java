package ge.koaladev.msy.nso.core.dto.admin.broadcastemail;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ge.koaladev.msy.nso.core.misc.JsonDateDeSerializeSupport;

import java.util.Date;
import java.util.List;

/**
 * Created by mindia on 3/26/17.
 */
public class SendBroadcastEmailRequest {

    private List<Integer> recipients;
    private String title;
    private Integer id;
    private Integer senderUserId;
    private Integer receiverUserId;
    private String body;
    private String sendBy = "email";
    private String number;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date dueDate;
    private String url;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(Integer senderUserId) {
        this.senderUserId = senderUserId;
    }

    public List<Integer> getRecipients() {
        return recipients;
    }

    public void setRecipients(List<Integer> recipients) {
        this.recipients = recipients;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getSendBy() {
        return sendBy;
    }

    public void setSendBy(String sendBy) {
        this.sendBy = sendBy;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Integer getReceiverUserId() {
        return receiverUserId;
    }

    public void setReceiverUserId(Integer receiverUserId) {
        this.receiverUserId = receiverUserId;
    }
}
