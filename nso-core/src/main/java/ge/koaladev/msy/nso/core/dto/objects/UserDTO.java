/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.Users;

import java.util.ArrayList;
import java.util.List;

/**
 * @author mindia
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserDTO {

    private Integer id;
    private String email;
    private String idNumber;
    private String name;
    private String phone;
    private String phone2;
    private UsersGroupDTO usersGroup;
    private UsersStatusDTO usersStatus;
    private String address;
    private Integer supervisorId;
    private Integer managerId;
    private String url;

    public static int USER_ADMINISTRATOR = 1;
    public static int USER_MANAGER = 2;
    public static int USER_SUPERVISOR = 3;
    public static int USER_FEDERATION = 4;
    public static int USER_ACCOUNTANT = 5;
    public static int USER_CHANCELLERY = 6;
    public static int USER_FEDERATION_MANAGER = 7;

    public static UserDTO parse(Users user, boolean sensitiveInfo) {

        UserDTO userDTO = new UserDTO();

        userDTO.setId(user.getId());
        userDTO.setName(user.getName());

        if (sensitiveInfo) {
            userDTO.setId(user.getId());
            userDTO.setEmail(user.getEmail());
            userDTO.setIdNumber(user.getIdNumber());
            userDTO.setPhone(user.getPhone());
            userDTO.setAddress(user.getAddress());
            userDTO.setUsersGroup(UsersGroupDTO.parse(user.getUsersGroup(), true));
            userDTO.setUsersStatus(UsersStatusDTO.parse(user.getUsersStatus()));
            userDTO.setSupervisorId(user.getSupervisorId());
            userDTO.setPhone2(user.getPhone2());
            userDTO.setUrl(user.getUrl());
        }

        return userDTO;
    }

    public static List<UserDTO> parseToList(List<Users> users, boolean sensitiveInfo) {

        List<UserDTO> dTOs = new ArrayList<>();
        users.stream().forEach((p) -> {
            dTOs.add(UserDTO.parse(p, sensitiveInfo));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public UsersGroupDTO getUsersGroup() {
        return usersGroup;
    }

    public void setUsersGroup(UsersGroupDTO usersGroup) {
        this.usersGroup = usersGroup;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public UsersStatusDTO getUsersStatus() {
        return usersStatus;
    }

    public void setUsersStatus(UsersStatusDTO usersStatus) {
        this.usersStatus = usersStatus;
    }

    public Integer getSupervisorId() {
        return supervisorId;
    }

    public void setSupervisorId(Integer supervisorId) {
        this.supervisorId = supervisorId;
    }

    public String getPhone2() {
        return phone2;
    }

    public void setPhone2(String phone2) {
        this.phone2 = phone2;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }
}
