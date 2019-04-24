package ge.koaladev.utils.email;

/**
 * Created by mindia on 3/26/17.
 */
public class SendEmailWithAttachmentFactory {

    private String host;
    private String port;
    private String auth;
    private String starttls;
    private String from;
    private String username;
    private String password;


    public SendEmailWithAttachment getInstance() {
        SendEmailWithAttachment sendEmailWithAttachment = new SendEmailWithAttachment();
        sendEmailWithAttachment.setHost(host);
        sendEmailWithAttachment.setPort(port);
        sendEmailWithAttachment.setAuth(auth);
        sendEmailWithAttachment.setStarttls(starttls);
        sendEmailWithAttachment.setFrom(from);
        sendEmailWithAttachment.setUsername(username);
        sendEmailWithAttachment.setPassword(password);
        return sendEmailWithAttachment;
    }


    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getPort() {
        return port;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getAuth() {
        return auth;
    }

    public void setAuth(String auth) {
        this.auth = auth;
    }

    public String getStarttls() {
        return starttls;
    }

    public void setStarttls(String starttls) {
        this.starttls = starttls;
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
