package ge.koaladev.msy.nso.core.dto.admin.feedback;

/**
 * Created by mindia on 3/25/17.
 */
public class SendFeedbackRequest {

    private String title;
    private String sender;
    private String text;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}
