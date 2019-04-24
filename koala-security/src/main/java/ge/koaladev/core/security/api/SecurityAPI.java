/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.core.security.api;

import java.util.List;
import java.util.Map;

/**
 * @author mindia
 */
public interface SecurityAPI {

    User getUser(Map<String, Object> map);

    List<String> getLoginParameters();

    String getLoginPage();

    String getHomePage();

    boolean isTwoStepVerification();

    String getTwoStepVerificationParam();

    boolean sendTwoStepVerificationCode(Map<String, Object> map);

}
