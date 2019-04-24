package ge.koaladev.utils.email;

/**
 * Created by mindia on 6/30/16.
 */

import org.apache.log4j.Logger;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;


public class SendEmailWithAttachment {

    private String from = "govmsy@gmail.com";
    private String to = "govmsy@gmail.com";
    private List<FileAttachment> fileUrls = new ArrayList<>();
    private String subject = "NSO MANAGER";
    private String body = "";
    private String auth = "true";
    private String host = "smtp.gmail.com";
    private String port = "587";
    private String starttls = "true";
    private String username = "govmsy@gmail.com";
    private String password = "$govmsy%";


    private static final Logger logger = Logger.getLogger(SendEmailWithAttachment.class);


    private List<String> ccEmails = new ArrayList<>();
    private List<String> bccEmails = new ArrayList<>();
    private boolean textPlain;

    public void addCC(String... emails) {
        ccEmails.addAll(Arrays.asList(emails));
    }

    public void addCC(String commaSeparatedEmails) {
        ccEmails.addAll(Arrays.asList(commaSeparatedEmails.split(",")));
    }

    public void addBCC(String... emails) {
        bccEmails.addAll(Arrays.asList(emails));
    }

    public void addBCC(String commaSeparatedEmails) {
        bccEmails.addAll(Arrays.asList(commaSeparatedEmails.split(",")));
    }

    public void sendInNewThread() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    send();
                } catch (EmailNotSentException e) {
                    logger.error(e);
                }
            }
        }).start();
    }

    public void send() throws EmailNotSentException {

        Properties props = new Properties();
        props.put("mail.smtp.auth", auth);
        props.put("mail.smtp.starttls.enable", starttls);
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        Session session;
        logger.info("SEND MAIL -- host:" + host + " port:" + port + " auth:" + auth);

        if (auth != null && auth.equals("true")) {
            session = Session.getInstance(props,
                    new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(username, password);
                        }
                    });
        } else {
            session = Session.getDefaultInstance(props);
        }

        try {
            // Create a default MimeMessage object.
            Message message = new MimeMessage(session);

            // Set From: header field of the header.
            message.setFrom(new InternetAddress(from));

            // Set To: header field of the header.
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(to));

            message.setSubject(subject);

            BodyPart messageBodyPart = new MimeBodyPart();

            if (textPlain) {
                messageBodyPart.setContent(body, "text/plain; charset=utf-8");
            } else {
                messageBodyPart.setContent(body, "text/html; charset=utf-8");
            }

            Multipart multipart = new MimeMultipart("mixed");

            multipart.addBodyPart(messageBodyPart);

            // Part two is attachment
            if (fileUrls != null) {
                for (FileAttachment fileAttachment : fileUrls) {
                    BodyPart filePart = new MimeBodyPart();
                    DataSource source;
                    if (fileAttachment.getFile() != null) {
                        source = new FileDataSource(fileAttachment.getFile());
                    } else {
                        source = new FileDataSource(fileAttachment.getPath());
                    }
                    filePart.setDataHandler(new DataHandler(source));
                    filePart.setFileName(fileAttachment.getName());
                    multipart.addBodyPart(filePart);

                }
            }
            message.setContent(multipart);


            //add cc
            for (String email : ccEmails) {
                message.addRecipient(Message.RecipientType.CC, new InternetAddress(email));
            }

            //add bcc
            for (String email : bccEmails) {
                message.addRecipient(Message.RecipientType.BCC, new InternetAddress(email));
            }

            Transport.send(message);

            System.out.println("Sent message successfully....");

        } catch (MessagingException e) {
            throw new EmailNotSentException(e.getMessage());
        }
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }


    public List<FileAttachment> getFileUrls() {
        return fileUrls;
    }

    public void setFileUrls(List<FileAttachment> fileUrls) {
        this.fileUrls = fileUrls;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getAuth() {
        return auth;
    }

    public void setAuth(String auth) {
        this.auth = auth;
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

    public String getStarttls() {
        return starttls;
    }

    public void setStarttls(String starttls) {
        this.starttls = starttls;
    }

    public List<String> getCcEmails() {
        return ccEmails;
    }

    public void setCcEmails(List<String> ccEmails) {
        this.ccEmails = ccEmails;
    }

    public List<String> getBccEmails() {
        return bccEmails;
    }

    public void setBccEmails(List<String> bccEmails) {
        this.bccEmails = bccEmails;
    }

    public static Logger getLogger() {
        return logger;
    }

    public boolean isTextPlain() {
        return textPlain;
    }

    public void setTextPlain(boolean textPlain) {
        this.textPlain = textPlain;
    }

    public static void main(String... args) throws EmailNotSentException {

        SendEmailWithAttachment attachment = new SendEmailWithAttachment();
        attachment.body = "test body";
        attachment.to = "javagc12@gmail.com";
//        attachment.fileUrls = Arrays.asList("/Users/mindia/Desktop/app_icon_1024.png", "/Users/mindia/Desktop/Homework.pages");
        attachment.send();
    }
}