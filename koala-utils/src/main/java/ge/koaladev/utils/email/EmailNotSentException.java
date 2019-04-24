package ge.koaladev.utils.email;

/**
 * @author mindia
 */
public class EmailNotSentException extends Exception {

    public EmailNotSentException(String message) {
        super(message);
    }

    public EmailNotSentException(String message, Throwable cause) {
        super(message, cause);
    }

}