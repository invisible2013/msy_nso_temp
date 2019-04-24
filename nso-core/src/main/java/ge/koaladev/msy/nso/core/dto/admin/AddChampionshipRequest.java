package ge.koaladev.msy.nso.core.dto.admin;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ge.koaladev.msy.nso.core.misc.JsonDateDeSerializeSupport;

import java.util.Date;

/**
 * Created by NINO on 4/18/2019.
 */
public class AddChampionshipRequest {

    private int id;
    private String name;
    private int championshipTypeId;
    private String championshipTypeName;
    private int championshipSubTypeId;
    private String championshipSubTypeName;
    private String location;
    private String description;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date startDate;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date endDate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getChampionshipTypeId() {
        return championshipTypeId;
    }

    public void setChampionshipTypeId(int championshipTypeId) {
        this.championshipTypeId = championshipTypeId;
    }

    public String getChampionshipTypeName() {
        return championshipTypeName;
    }

    public void setChampionshipTypeName(String championshipTypeName) {
        this.championshipTypeName = championshipTypeName;
    }

    public int getChampionshipSubTypeId() {
        return championshipSubTypeId;
    }

    public void setChampionshipSubTypeId(int championshipSubTypeId) {
        this.championshipSubTypeId = championshipSubTypeId;
    }

    public String getChampionshipSubTypeName() {
        return championshipSubTypeName;
    }

    public void setChampionshipSubTypeName(String championshipSubTypeName) {
        this.championshipSubTypeName = championshipSubTypeName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
