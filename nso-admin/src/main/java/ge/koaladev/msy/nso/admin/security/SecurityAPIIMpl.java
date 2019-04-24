/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.admin.security;

import ge.koaladev.core.security.api.SecurityAPI;
import ge.koaladev.core.security.api.User;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.services.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * @author mindia
 */
@Component
public class SecurityAPIIMpl implements SecurityAPI {

    @Autowired
    private UsersService service;

    @Override
    public User getUser(Map<String, Object> map) {

        UserDTO adminUser;

        String email = map.get("email").toString();
        String password = map.get("password").toString();

        if (isTwoStepVerification() && map.get(getTwoStepVerificationParam()) != null) {
            adminUser = service.loginWithPinCode(email, password, map.get(getTwoStepVerificationParam()).toString());
        } else {
            adminUser = service.login(email, password);
        }

        if (adminUser == null) {
            return null;
        }

        AdminUser admin = new AdminUser();
        admin.setUserData(adminUser);
        Set<String> s = new HashSet<>();
        s.add(adminUser.getUsersGroup().getName());
        admin.setRights(s);
        return admin;
    }

    @Override
    public List<String> getLoginParameters() {
        ArrayList<String> parameters = new ArrayList<>();

        parameters.add("email");
        parameters.add("password");

        if (isTwoStepVerification()) {
            parameters.add(getTwoStepVerificationParam());
        }
        return parameters;
    }

    @Override
    public String getLoginPage() {
        return "login";
    }

    @Override
    public String getHomePage() {
        return "home";
    }

    @Override
    public boolean sendTwoStepVerificationCode(Map<String, Object> map) {
        UserDTO adminUser = service.login(map.get("email").toString(), map.get("password").toString());
        return service.sendTwoStepVerificationCode(adminUser.getId());
    }

    @Override
    public boolean isTwoStepVerification() {
        return false;
    }

    @Override
    public String getTwoStepVerificationParam() {
        return "pincode";
    }
}
