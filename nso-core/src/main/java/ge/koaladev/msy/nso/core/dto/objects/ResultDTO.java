package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.CalendarStatus;
import ge.koaladev.msy.nso.database.model.CalendarType;
import ge.koaladev.msy.nso.database.model.Calendars;
import ge.koaladev.msy.nso.database.model.Result;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author nino
 */
public class ResultDTO {

    private Integer id;
    private Integer championshipId;
    private Integer sportsmanId;
    private Integer awardId;
    private String category;
    private String note;
    private String discipline;
    private String score;
    private Integer userId;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;


    public static ResultDTO parse(Result item) {

        ResultDTO requestDTO = new ResultDTO();
        requestDTO.setId(item.getId());
        requestDTO.setNote(item.getNote());
        requestDTO.setCategory(item.getCategory());
        requestDTO.setChampionshipId(item.getChampionshipId());
        requestDTO.setSportsmanId(item.getSportsmanId());
        requestDTO.setAwardId(item.getAwardId());
        requestDTO.setDiscipline(item.getDiscipline());
        requestDTO.setScore(item.getScore());
        requestDTO.setUserId(item.getUserId());
        requestDTO.setCreateDate(item.getCreateDate());


        return requestDTO;
    }

    public static List<ResultDTO> parseToList(List<Result> items) {

        List<ResultDTO> dTOs = new ArrayList<>();
        items.stream().forEach((n) -> {
            dTOs.add(ResultDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getChampionshipId() {
        return championshipId;
    }

    public void setChampionshipId(Integer championshipId) {
        this.championshipId = championshipId;
    }

    public Integer getSportsmanId() {
        return sportsmanId;
    }

    public void setSportsmanId(Integer sportsmanId) {
        this.sportsmanId = sportsmanId;
    }

    public Integer getAwardId() {
        return awardId;
    }

    public void setAwardId(Integer awardId) {
        this.awardId = awardId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getDiscipline() {
        return discipline;
    }

    public void setDiscipline(String discipline) {
        this.discipline = discipline;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}
