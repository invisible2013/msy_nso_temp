/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.core.security.auth;

/**
 * @author mindia
 */
public class UserAccessDeniedException extends Exception {

    public UserAccessDeniedException() {
    }

    public UserAccessDeniedException(String message) {
        super(message);
    }
}
