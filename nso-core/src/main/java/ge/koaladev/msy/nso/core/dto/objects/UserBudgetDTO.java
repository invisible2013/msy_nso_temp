/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.UserBudget;

import java.util.ArrayList;
import java.util.List;

/**
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserBudgetDTO {

    private Integer id;
    private Integer userId;
    private Integer yearId;
    private Double budget;


    public static UserBudgetDTO parse(UserBudget user) {

        UserBudgetDTO itemDTO = new UserBudgetDTO();

        itemDTO.setId(user.getId());
        itemDTO.setUserId(user.getUserId());
        itemDTO.setBudget(user.getBudget());
        return itemDTO;
    }

    public static List<UserBudgetDTO> parseToList(List<UserBudget> items) {

        List<UserBudgetDTO> dTOs = new ArrayList<>();
        items.stream().forEach((p) -> {
            dTOs.add(UserBudgetDTO.parse(p));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getYearId() {
        return yearId;
    }

    public void setYearId(Integer yearId) {
        this.yearId = yearId;
    }

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
    }

}
