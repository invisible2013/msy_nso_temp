package ge.koaladev.msy.nso.core.services;

/**
 * Created by nl on 3/7/2016.
 */
public class OperationNotPermitException extends Exception{

    public OperationNotPermitException() {
    }

    public OperationNotPermitException(String message) {
        super(message);
    }
}
