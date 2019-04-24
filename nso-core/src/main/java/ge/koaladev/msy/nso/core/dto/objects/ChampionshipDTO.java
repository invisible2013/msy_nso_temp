package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.Championship;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by NINO on 4/18/2019.
 */
public class ChampionshipDTO {

    private int id;
    private String name;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date startDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date endDate;
    private int championshipTypeId;
    private String championshipTypeName;
    private int championshipSubTypeId;
    private String championshipSubTypeName;
    private String location;
    private String description;

    public static ChampionshipDTO parse(Championship record) {
        ChampionshipDTO dto = new ChampionshipDTO();
        dto.setId(record.getId());
        dto.setName(record.getName());
        dto.setStartDate(record.getStartDate());
        dto.setEndDate(record.getEndDate());
        dto.setChampionshipTypeId(record.getChampionshipTypeId());
        dto.setChampionshipSubTypeId(record.getChampionshipSubTypeId());
        dto.setLocation(record.getLocation());
        dto.setDescription(record.getDescription());
        return dto;
    }


    public static List<ChampionshipDTO> parseToList(List<Championship> records) {
        ArrayList<ChampionshipDTO> list = new ArrayList<ChampionshipDTO>();
        for (Championship record : records) {
            list.add(ChampionshipDTO.parse(record));
        }
        return list;
    }


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
}
